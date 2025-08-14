% Computer Project communication1 ------ amirhossein owji 400113010
% part1 --------------------------------- Triangular message signal 

clc
clear
close all
warning off

%% Triangular message signal
% Parameters
Fs_t = 10000;                        % Sampling frequency
T = 1/Fs_t;                         % Sampling period
duration = 0.4;                     % Signal duration in seconds
f_message = 5;                      % Frequency of the message signal in Hz
t_message = 0:T:duration-T;         % Time vector

% Triangular message signal
message_signal = 0.5 * (1 + sawtooth(2*pi*f_message*t_message, 0.5));

% Plot the signal in the time domain
figure;
subplot(2, 1, 1);
plot(t_message, message_signal);
title('Triangular Message Signal in Time Domain');
xlabel('Time (s)');

% Perform FFT and plot the signal in the frequency domain
L = length(message_signal);           % Length of the signal
frequencies = Fs_t*(0:(L-1))/L;       % Frequency vector for FFT

message_signal_fft = fft(message_signal);
message_signal_fft_magnitude = abs(message_signal_fft)/L;

subplot(2, 1, 2);
plot(frequencies, message_signal_fft_magnitude);
title('Frequency Content of Triangular Message Signal');
xlabel('Frequency (Hz)');

% Optional: Zoom in on the frequency axis
%xlim([0, 2*f_message]);

%% Voice Signal

[y,Fs]=audioread('myVoice.m4a');
Voice_signal=y(:,2);
normalized_Voice=Voice_signal/(max(abs(Voice_signal(:))));
t_voice=(0:length(normalized_Voice)-1)/Fs;

 sound(Voice_signal,Fs)
 pause(ceil(length(Voice_signal)/Fs));

Fs1 = 500000;                       % Sampling frequency in Hz
N1 = length(Voice_signal);          % Number of points in the signal
f1 = (0:N1-1) * Fs1/N1;             % Frequency vector
fft_result = fft(Voice_signal);
magnitude_spectrum_voice = abs(fft_result);

figure;
subplot(2,1,1)
plot(t_voice,normalized_Voice)
xlabel('time(s)')
ylabel('amplitude')
title('Voice signal')
subplot(2, 1, 2);
plot(f1, magnitude_spectrum_voice);
title('Magnitude Spectrum (FFT)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Voice signal in frequency domain')

%% AM Modulation & Demodulation :
% AM Modulation
fc = 50000; % Carrier frequency
mu = 0.85; % Modulation index

% Create a carrier signal
carrier_signal_AM = cos(2*pi*fc*t_message);

% Perform AM modulation
am_modulated_signal = (1 + mu * message_signal) .* carrier_signal_AM;

% Perform AM demodulation using envelope detection
envelope = abs(hilbert(am_modulated_signal));
am_demodulated_signal = envelope - mean(envelope); % Remove DC offset

% Plot 
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
carrier_signal_DSB = cos(2*pi*fc*t_message);

% Perform DSB modulation
dsb_modulated_signal = message_signal .* carrier_signal_DSB;

% Perform DSB demodulation using product detection
dsb_demodulated_signal = dsb_modulated_signal .* carrier_signal_DSB;

% Plot 
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
ssb_demodulated_signal = ssb_modulated_signal .* carrier_signal_SSB;

% Plot 
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
fc_fm = 5000;
fd = 2000;             % Frequency deviation constant
% FM modulation
fm_modulated_signal = fmmod(message_signal, fc_fm, Fs_t, fd);

% FM demodulation
fm_demodulated_signal = fmdemod(fm_modulated_signal, fc_fm, Fs_t, fd);

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

%% noise
Z_am5=awgn(am_modulated_signal,5);
Zs_am5=lowpass(Z_am5,0.5);
Z_am10=awgn(am_modulated_signal,10);
Zs_am10=lowpass(Z_am10,0.5);
Z_am15=awgn(am_modulated_signal,15);
Zs_am15=lowpass(Z_am15,0.5);

Z_dsb5=awgn(dsb_modulated_signal,5);
Zs_dsb5=lowpass(Z_dsb5,0.5);
Z_dsb10=awgn(dsb_modulated_signal,10);
Zs_dsb10=lowpass(Z_dsb10,0.5);
Z_dsb15=awgn(dsb_modulated_signal,15);
Zs_dsb15=lowpass(Z_dsb15,0.5);

Z_ssb5=awgn(ssb_modulated_signal,5);
Zs_ssb5=lowpass(Z_ssb5,0.5);
Z_ssb10=awgn(ssb_modulated_signal,10);
Zs_ssb10=lowpass(Z_ssb10,0.5);
Z_ssb15=awgn(ssb_modulated_signal,15);
Zs_ssb15=lowpass(Z_ssb15,0.5);


Z_fm5=awgn(fm_modulated_signal,5);
Zs_fm5=lowpass(Z_fm5,0.5);
Z_fm10=awgn(fm_modulated_signal,10);
Zs_fm10=lowpass(Z_fm10,0.5);
Z_fm15=awgn(fm_modulated_signal,15);
Zs_fm15=lowpass(Z_fm15,0.5);

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
