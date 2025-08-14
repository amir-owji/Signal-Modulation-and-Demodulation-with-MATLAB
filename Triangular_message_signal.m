% Computer Project communication1 ------ amirhossein owji 400113010
% ------------------- Triangular message signal -------------------

clc
clear
close all
warning off

%% Triangular message signal
% Parameters
Fs = 500000;                        % Sampling frequency
T = 1/Fs;                           % Sampling period
duration = 0.4;                     % Signal duration in seconds
f_message = 5;                      % Frequency of the message signal in Hz
t_message = 0:T:duration;           % Time vector

% Triangular message signal
message_signal = 0.5 * (1 + sawtooth(2*pi*f_message*t_message, 0.5));

% Perform FFT and plot the signal in the frequency domain
L = length(message_signal);         % Length of the signal
frequencies = (0:(L-1)) * Fs/L;     % Frequency vector for FFT

message_signal_fft_result = fft(message_signal);
message_signal_fft = abs(message_signal_fft_result);

% Plot signals
figure;
subplot(2, 1, 1);
plot(t_message, message_signal);
title('Triangular Message Signal in Time Domain');
xlabel('Time (s)');
subplot(2, 1, 2);
plot(frequencies, message_signal_fft);
title('Frequency Content of Triangular Message Signal');
xlabel('Frequency (Hz)');

% Optional: Zoom in on the frequency axis
xlim([0, 20*f_message]);

%% AM Modulation & Demodulation :
% Parameters
fc = 50000;             % Carrier frequency
mu = 0.85;              % Modulation index

% Create a carrier signal
carrier_signal_AM = cos(2*pi*fc*t_message*2.5);

% Perform AM modulation
am_modulated_signal = (1 + mu * message_signal) .* carrier_signal_AM;
%am_modulated_signal  = ammod(message_signal,fc,Fs) ;

% Perform AM demodulation using envelope detection
envelope = abs(hilbert(am_modulated_signal));
am_demodulated_signal = envelope - mean(envelope);      % Remove DC offset
%am_demodulated_signal = amdemod(am_modulated_signal, fc, Fs);

% Plot signals
figure;
sgtitle('Triangular message signal AM Modulation and Demodulation');
subplot(3,1,1);
plot(t_message, message_signal);
title('Triangular Message Signal');
xlabel('Time (s)');
subplot(3,1,2);
plot(t_message, am_modulated_signal);
title('AM Modulated Signal');
xlabel('Time (s)');
subplot(3,1,3);
plot(t_message, am_demodulated_signal);
title('AM Demodulated Signal');
xlabel('Time (s)');

%% DSB Modulation & Demodulation :
% Create a carrier signal
carrier_signal_DSB = cos(2*pi*fc*t_message*2.5);

% Perform DSB modulation
dsb_modulated_signal = message_signal .* carrier_signal_DSB;

% Perform DSB demodulation using product detection
dsb_demodulated_signal = lowpass(dsb_modulated_signal .* carrier_signal_DSB,0.05);

% Plot signals
figure;
sgtitle('Triangular message signal DSB Modulation and Demodulation');
subplot(3,1,1);
plot(t_message, message_signal);
title('Triangular Message Signal');
xlabel('Time (s)');
subplot(3,1,2);
plot(t_message, dsb_modulated_signal);
title('DSB Modulated Signal');
xlabel('Time (s)');
subplot(3,1,3);
plot(t_message, dsb_demodulated_signal);
title('DSB Demodulated Signal');
xlabel('Time (s)');

%% SSB Modulation & Demodulation:
% Create a carrier signal
carrier_signal_SSB = cos(2*pi*fc*t_message);

% Perform SSB modulation using the phasing method
ssb_modulated_signal = message_signal .* cos(2*pi*fc*t_message) - hilbert(message_signal) .* sin(2*pi*fc*t_message);

% Perform SSB demodulation using the phasing method
ssb_demodulated_signal = lowpass(ssb_modulated_signal .* carrier_signal_SSB,0.05);

% Plot signals
figure;
sgtitle('Triangular message signal SSB Modulation and Demodulation');
subplot(3,1,1);
plot(t_message, message_signal);
title('Triangular Message Signal');
xlabel('Time (s)');
subplot(3,1,2);
plot(t_message, ssb_modulated_signal);
title('SSB Modulated Signal');
xlabel('Time (s)');
subplot(3,1,3);
plot(t_message, ssb_demodulated_signal);
title('SSB Demodulated Signal');
xlabel('Time (s)');

%% FM Modulation & Demodulation:
fc_fm = 5000;          % Carrier frequency
fd = 2000;             % Frequency deviation constant
% Perform FM modulation
fm_modulated_signal = fmmod(message_signal, fc_fm, Fs, fd);

% Perform FM demodulation
fm_demodulated_signal = lowpass(fmdemod(fm_modulated_signal, fc_fm, Fs, fd),0.0001);

% Plot signals
figure;
sgtitle('Triangular message signal FM Modulation and Demodulation');
subplot(3, 1, 1);
plot(t_message, message_signal);
title('Message Signal');
xlabel('Time (s)');
subplot(3, 1, 2);
plot(t_message, fm_modulated_signal);
title('FM Modulated Signal');
xlabel('Time (s)');
subplot(3, 1, 3);
plot(t_message, fm_demodulated_signal);
title('FM Demodulated Signal');
xlabel('Time (s)');

%% Distortion 
% AM 
y_am_mod = am_modulated_signal .^3 + 0.5 * am_modulated_signal .^2;
envelope_y = abs(hilbert(y_am_mod));
y_am_demodulated_signal = envelope_y - mean(envelope_y);

% DSB
y_dsb_mod = dsb_modulated_signal .^3 + 0.5 * dsb_modulated_signal .^2;
y_dsb_demodulated_signal = y_dsb_mod .* carrier_signal_DSB;

% FM
y_fm_mod = fm_modulated_signal .^3 + 0.5 * fm_modulated_signal .^2;
y_fm_demodulated_signal = fmdemod(y_fm_mod, 50000, Fs, 2000);
y_fm_dm = lowpass(y_fm_demodulated_signal,0.0001);

%plot
figure;
sgtitle('demodulation with Distortion');
subplot(4, 1, 1);
plot(t_message, message_signal);
title('Triangular message signal');
xlabel('Time (s)');
subplot(4, 1, 2);
plot(t_message, y_am_demodulated_signal);
title('AM Demodulated Signal with Distortion');
xlabel('Time (s)');
subplot(4, 1, 3);
plot(t_message, y_dsb_demodulated_signal);
title('DSB Demodulated Signal with Distortion');
xlabel('Time (s)');
subplot(4, 1, 4);
plot(t_message, y_fm_dm);
title('FM Demodulated Signal with Distortion');
xlabel('Time (s)');
%% noise
%AM
Z_am5=awgn(am_modulated_signal,5);
Zs_am5=lowpass(amdemod(Z_am5, fc_fm, Fs, fd),0.05);
Z_am10=awgn(am_modulated_signal,10);
Zs_am10=lowpass(amdemod(Z_am10, fc_fm, Fs, fd),0.05);
Z_am15=awgn(am_modulated_signal,15);
Zs_am15=lowpass(amdemod(Z_am15, fc_fm, Fs, fd),0.05);

%DSB
Z_dsb5=awgn(dsb_modulated_signal,5);
Zs_dsb5=lowpass(Z_dsb5 .* carrier_signal_DSB,0.05);
Z_dsb10=awgn(dsb_modulated_signal,10);
Zs_dsb10=lowpass(Z_dsb10 .* carrier_signal_DSB,0.05);
Z_dsb15=awgn(dsb_modulated_signal,15);
Zs_dsb15=lowpass(Z_dsb15 .* carrier_signal_DSB,0.05);

%SSB
Z_ssb5=awgn(ssb_modulated_signal,5);
Zs_ssb5=lowpass(Z_ssb5 .* carrier_signal_SSB,0.05);
Z_ssb10=awgn(ssb_modulated_signal,10);
Zs_ssb10=lowpass(Z_ssb10 .* carrier_signal_SSB,0.05);
Z_ssb15=awgn(ssb_modulated_signal,15);
Zs_ssb15=lowpass(Z_ssb15 .* carrier_signal_SSB,0.05);

%FM
Z_fm5=awgn(fm_modulated_signal,5);
Zs_fm5=lowpass(fmdemod(Z_fm5, fc_fm, Fs, fd),0.05);
Z_fm10=awgn(fm_modulated_signal,10);
Zs_fm10=lowpass(fmdemod(Z_fm10, fc_fm, Fs, fd),0.05);
Z_fm15=awgn(fm_modulated_signal,15);
Zs_fm15=lowpass(fmdemod(Z_fm15, fc_fm, Fs, fd),0.05);

% plot signals
figure;
subplot (3,4,4)
plot(t_message,Zs_fm5)
title('SNR for FM with 5 dB')
subplot (3,4,8)
plot(t_message,Zs_fm10)
title('SNR for FM with 10 dB')
subplot (3,4,12)
plot(t_message,Zs_fm15)
title('SNR for FM with 15 dB')
subplot (3,4,1)
plot(t_message,Zs_am5)
title('SNR for AM with 5 dB')
subplot (3,4,5)
plot(t_message,Zs_am10)
title('SNR for AM with 10 dB')
subplot (3,4,9)
plot(t_message,Zs_am15)
title('SNR for AM with 15 dB')
subplot (3,4,3)
plot(t_message,Zs_ssb5)
title('SNR for SSB with 5 dB')
subplot (3,4,7)
plot(t_message,Zs_ssb10)
title('SNR for SSB with 10 dB')
subplot (3,4,11)
plot(t_message,Zs_ssb15)
title('SNR for SSB with 15 dB')
subplot (3,4,2)
plot(t_message,Zs_dsb5)
title('SNR for DSB with 5 dB')
subplot (3,4,6)
plot(t_message,Zs_dsb10)
title('SNR for DSB with 10 dB')
subplot (3,4,10)
plot(t_message,Zs_dsb15)
title('SNR for DSB with 15 dB')
sgtitle('effect of noise in linear and angular modulations');