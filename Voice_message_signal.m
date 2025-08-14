% Computer Project communication1 ------ amirhossein owji 400113010
% --------------------- Voice message signal ----------------------

clc
clear
close all
warning off

%% Voice Signal

[y,Fs]=audioread('myVoice.m4a');    %y is the audio data & Fs is the sampling frequency of the audio file 
Voice_signal=y(:,2);
normalized_Voice=Voice_signal/(max(abs(Voice_signal(:))));
t_voice=(0:length(normalized_Voice)-1)/Fs;

% optional: play voice
sound(Voice_signal,Fs)
pause(ceil(length(Voice_signal)/Fs));

L = length(Voice_signal);                  % Number of points in the signal
frequencies = (0:L-1) * Fs/L;              % Frequency vector
fft_result = fft(Voice_signal);
fft_voice = abs(fft_result);

figure;
subplot(2,1,1)
plot(t_voice,normalized_Voice)
xlabel('time(s)')
title('Voice signal')
subplot(2, 1, 2);
plot(frequencies, fft_voice);
title('Frequency Content of voice Message Signal');
xlabel('Frequency (Hz)');
title('Voice signal in frequency domain')

%% AM Modulation & Demodulation :
% Parameters
Ac=1;
mu=0.85;

% Perform AM modulation and demodulation
Voice_1=1+mu*normalized_Voice;
am_mod_voice=Ac*my_module(Voice_1,Fs,t_voice);
am_demod_voice=my_demodule(am_mod_voice,Fs,t_voice) ;

% Plot signals
figure;
sgtitle('Voice message signal AM Modulation and Demodulation');
subplot(3,1,1)
plot(t_voice,normalized_Voice)
xlabel('time(s)')
title('normalized voice')
subplot(3,1,2)
plot(t_voice,am_mod_voice)
xlabel('time(s)')
title('modulated signal (AM)')
subplot(3,1,3)
plot(t_voice,am_demod_voice)
xlabel('time(s)')
title('demodulated signal')

%% DSB Modulation & Demodulation :
dsb_mod_voice=Ac*my_module(normalized_Voice,Fs,t_voice);
dsb_demod_voice=my_demodule(dsb_mod_voice,Fs,t_voice);

% Plot signals
figure;
sgtitle('Voice message signal DSB Modulation and Demodulation');
subplot(3,1,1)
plot(t_voice,normalized_Voice)
xlabel('time(s)')
ylabel('amplitude')
title('normalized voice')
subplot(3,1,2)
plot(t_voice,dsb_mod_voice)
xlabel('time(s)')
ylabel('X_{c}(t)')
title('modulated signal (DSB)')
subplot(3,1,3)
plot(t_voice,dsb_demod_voice)
xlabel('time(s)')
ylabel('Y_{d}(t)')
title('demodulated signal')

%% SSB Modulation & Demodulation:
H=hilbert(normalized_Voice);
ssb_mod_voice=zeros(size(normalized_Voice));

for i=1:length(ssb_mod_voice)
    ssb_mod_voice(i)=0.5*(normalized_Voice(i)*cos(2*pi*Fs*t_voice(i)) - H(i)*sin(2*pi*Fs*t_voice(i)));
end

ssb_demod_voice=my_demodule(ssb_mod_voice,Fs,t_voice);

% Plot signals
figure;
sgtitle('Voice message signal SSB Modulation and Demodulation');
subplot(3,1,1)
plot(t_voice,normalized_Voice)
xlabel('time(s)')
ylabel('amplitude')
title('normalized voice')
subplot(3,1,2)
plot(t_voice,ssb_mod_voice)
xlabel('time(s)')
ylabel('X_{c}(t)')
title('modulated signal (SSB)')
subplot(3,1,3)
plot(t_voice,ssb_demod_voice)
xlabel('time(s)')
ylabel('Y_{d}(t)')
title('demodulated signal')

%% FM Modulation & Demodulation:
% Parameters
fc = 5000;             % Carrier frequency
fd = 2000;             % Frequency deviation constant

% FM modulation
fm_modulated_signal = fmmod(normalized_Voice, fc, Fs, fd);

% FM demodulation
fm_demodulated_signal = fmdemod(fm_modulated_signal, fc, Fs, fd);

figure;
sgtitle('Voice message signal FM Modulation and Demodulation');
subplot(3, 1, 1);
plot(t_voice, normalized_Voice);
title('Message Signal');
xlabel('Time (s)');
subplot(3, 1, 2);
plot(t_voice, fm_modulated_signal);
title('FM Modulated Signal');
xlabel('Time (s)');
subplot(3, 1, 3);
plot(t_voice, fm_demodulated_signal);
title('FM Demodulated Signal');
xlabel('Time (s)');

%% Distortion 
% AM 
y_am_mod = am_mod_voice .^3 + 0.5 * am_mod_voice .^2;
envelope_y = abs(hilbert(y_am_mod));
y_am_demodulated_signal = envelope_y - mean(envelope_y);
sound(y_am_demodulated_signal,Fs)
pause(ceil(length(y_am_demodulated_signal)/Fs));

% DSB
y_dsb_mod = dsb_mod_voice .^3 + 0.5 * dsb_mod_voice .^2;
y_dsb_demod_voice=my_demodule(y_dsb_mod,Fs,t_voice);
sound(y_dsb_demod_voice,Fs)
pause(ceil(length(y_dsb_demod_voice)/Fs));

% FM
y_fm_mod = fm_modulated_signal .^3 + 0.5 * fm_modulated_signal .^2;
y_fm_demodulated_signal = fmdemod(y_fm_mod, 5000, Fs, 2000);
y_fm_dm = lowpass(y_fm_demodulated_signal,0.0001);
sound(y_fm_dm,Fs)
pause(ceil(length(y_fm_dm)/Fs));

% Plot signals
figure;
sgtitle('demodulation with Distortion');
subplot(4, 1, 1);
plot(t_voice, normalized_Voice);
title('voice Message Signal');
xlabel('Time (s)');
subplot(4, 1, 2);
plot(t_voice, y_am_demodulated_signal);
title('AM Demodulated Signal with Distortion');
xlabel('Time (s)');
subplot(4, 1, 3);
plot(t_voice, y_dsb_demod_voice);
title('DSB Demodulated Signal with Distortion');
xlabel('Time (s)');
subplot(4, 1, 4);
plot(t_voice,y_fm_dm);
title('FM Demodulated Signal with Distortion');
xlabel('Time (s)');
%% noise
%AM
Z_am5=awgn(am_mod_voice,5);
Zs_am5=lowpass(amdemod(Z_am5, fc, Fs, fd),0.5);
sound(Zs_am5,Fs)
pause(ceil(length(Zs_am5)/Fs));
Z_am10=awgn(am_mod_voice,10);
Zs_am10=lowpass(amdemod(Z_am10, fc, Fs, fd),0.5);
sound(Zs_am5,Fs)
pause(ceil(length(Zs_am5)/Fs));
Z_am15=awgn(am_mod_voice,15);
Zs_am15=lowpass(amdemod(Z_am15, fc, Fs, fd),0.5);
sound(Zs_am5,Fs)
pause(ceil(length(Zs_am5)/Fs));

%DSB
Z_dsb5=awgn(dsb_mod_voice,5);
Zs_dsb5=lowpass(my_demodule(Z_dsb5,Fs,t_voice),0.05);
sound(Zs_dsb5,Fs)
pause(ceil(length(Zs_dsb5)/Fs));
Z_dsb10=awgn(dsb_mod_voice,10);
Zs_dsb10=lowpass(my_demodule(Z_dsb10,Fs,t_voice),0.05);
sound(Zs_dsb10,Fs)
pause(ceil(length(Zs_dsb10)/Fs));
Z_dsb15=awgn(dsb_mod_voice,15);
Zs_dsb15=lowpass(my_demodule(Z_dsb15,Fs,t_voice),0.05);
sound(Zs_dsb15,Fs)
pause(ceil(length(Zs_dsb15)/Fs));

%SSB
Z_ssb5=awgn(ssb_mod_voice,5);
Zs_ssb5=lowpass(my_demodule(Z_ssb5,Fs,t_voice),0.05);
sound(Zs_ssb5,Fs)
pause(ceil(length(Zs_ssb5)/Fs));
Z_ssb10=awgn(ssb_mod_voice,10);
Zs_ssb10=lowpass(my_demodule(Z_ssb10,Fs,t_voice),0.05);
sound(Zs_ssb10,Fs)
pause(ceil(length(Zs_ssb10)/Fs));
Z_ssb15=awgn(ssb_mod_voice,15);
Zs_ssb15=lowpass(my_demodule(Z_ssb15,Fs,t_voice),0.05);
sound(Zs_ssb15,Fs)
pause(ceil(length(Zs_ssb15)/Fs));

%FM
Z_fm5=awgn(fm_modulated_signal,5);
Zs_fm5=lowpass(fmdemod(Z_fm5, fc, Fs, fd),0.05);
sound(Zs_fm5,Fs)
pause(ceil(length(Zs_fm5)/Fs));
Z_fm10=awgn(fm_modulated_signal,10);
Zs_fm10=lowpass(fmdemod(Z_fm10, fc, Fs, fd),0.05);
sound(Zs_fm10,Fs)
pause(ceil(length(Zs_fm10)/Fs));
Z_fm15=awgn(fm_modulated_signal,15);
Zs_fm15=lowpass(fmdemod(Z_fm15, fc, Fs, fd),0.05);
sound(Zs_fm15,Fs)
pause(ceil(length(Zs_fm15)/Fs));

% Plot signals
figure;
sgtitle('effect of noise in linear and angular modulations');
subplot (3,4,4)
plot(t_voice,Zs_fm5)
title('SNR for FM with 5 dB')
subplot (3,4,8)
plot(t_voice,Zs_fm10)
title('SNR for FM with 10 dB')
subplot (3,4,12)
plot(t_voice,Zs_fm15)
title('SNR for FM with 15 dB')
subplot (3,4,1)
plot(t_voice,Zs_am5)
title('SNR for AM with 5 dB')
subplot (3,4,5)
plot(t_voice,Zs_am10)
title('SNR for AM with 10 dB')
subplot (3,4,9)
plot(t_voice,Zs_am15)
title('SNR for AM with 15 dB')
subplot (3,4,3)
plot(t_voice,Zs_ssb5)
title('SNR for SSB with 5 dB')
subplot (3,4,7)
plot(t_voice,Zs_ssb10)
title('SNR for SSB with 10 dB')
subplot (3,4,11)
plot(t_voice,Zs_ssb15)
title('SNR for SSB with 15 dB')
subplot (3,4,2)
plot(t_voice,Zs_dsb5)
title('SNR for DSB with 5 dB')
subplot (3,4,6)
plot(t_voice,Zs_dsb10)
title('SNR for DSB with 10 dB')
subplot (3,4,10)
plot(t_voice,Zs_dsb15)
title('SNR for DSB with 15 dB')
