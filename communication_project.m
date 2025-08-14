% Computer Project communication1 ------ amirhossein owji 400113010
% part2 -------------------------------------- Voice message signal

clc
clear
close all
warning off

%% Voice Signal

[y,Fs]=audioread('myVoice.m4a');
Voice_signal=y(:,2);
normalized_Voice=Voice_signal/(max(abs(Voice_signal(:))));
t_voice=(0:length(normalized_Voice)-1)/Fs;

sound(Voice_signal,Fs)
pause(ceil(length(Voice_signal)/Fs));

%Fs = 500000;                       % Sampling frequency in Hz
N1 = length(Voice_signal);          % Number of points in the signal
f1 = (0:N1-1) * Fs/N1;             % Frequency vector
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
Ac=1;
mu=0.85;
Wc=0.5;

Voice_1=1+mu*normalized_Voice;
am_mod_voice=Ac*carrier(Voice_1,Fs,t_voice);
am_demod_voice=my_demodule(am_mod_voice,Fs,t_voice,Wc) ;

% Plot 
figure;
subplot(3,1,1)
plot(t_voice,normalized_Voice)
xlabel('time(s)')
ylabel('amplitude')
title('normalized voice')
subplot(3,1,2)
plot(t_voice,am_mod_voice)
xlabel('time(s)')
ylabel('X_{c}(t)')
title('modulated signal (AM)')
subplot(3,1,3)
plot(t_voice,am_demod_voice)
xlabel('time(s)')
ylabel('Y_{d}(t)')
title('demodulated signal')

%% DSB Modulation & Demodulation :
Ac=1;
Wc=0.5;

dsb_mod_voice=Ac*carrier(normalized_Voice,Fs,t_voice);
dsb_demod_voice=my_demodule(dsb_mod_voice,Fs,t_voice,Wc);

figure;
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
Fc_2=2.5*Fs;
ssb_mod_voice=zeros(size(normalized_Voice));
H=hilbert(normalized_Voice);
for i=1:length(ssb_mod_voice)
    ssb_mod_voice(i)=0.5*(normalized_Voice(i)*cos(2*pi*Fc_2*t_voice(i))-H(i)*sin(2*pi*Fc_2*t_voice(i)));
end
ssb_demod_voice=my_demodule(ssb_mod_voice,Fs,t_voice,Wc);

figure;
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
fc_fm = 5000;
fd = 2000;             % Frequency deviation constant
% FM modulation
fm_modulated_signal = fmmod(normalized_Voice, fc_fm, Fs, fd);

% FM demodulation
fm_demodulated_signal = fmdemod(fm_modulated_signal, fc_fm, Fs, fd);

% Plot signals
figure;
sgtitle('Triangular message signal FM Modulation and Demodulation');
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

%% noise
Z_am5=awgn(am_mod_voice,5);
Zs_am5=lowpass(Z_am5,0.5);
Z_am10=awgn(am_mod_voice,10);
Zs_am10=lowpass(Z_am10,0.5);
Z_am15=awgn(am_mod_voice,15);
Zs_am15=lowpass(Z_am15,0.5);

Z_dsb5=awgn(dsb_mod_voice,5);
Zs_dsb5=lowpass(Z_dsb5,0.5);
Z_dsb10=awgn(dsb_mod_voice,10);
Zs_dsb10=lowpass(Z_dsb10,0.5);
Z_dsb15=awgn(dsb_mod_voice,15);
Zs_dsb15=lowpass(Z_dsb15,0.5);

Z_ssb5=awgn(ssb_mod_voice,5);
Zs_ssb5=lowpass(Z_ssb5,0.5);
Z_ssb10=awgn(ssb_mod_voice,10);
Zs_ssb10=lowpass(Z_ssb10,0.5);
Z_ssb15=awgn(ssb_mod_voice,15);
Zs_ssb15=lowpass(Z_ssb15,0.5);


Z_fm5=awgn(fm_modulated_signal,5);
Zs_fm5=lowpass(Z_fm5,0.5);
Z_fm10=awgn(fm_modulated_signal,10);
Zs_fm10=lowpass(Z_fm10,0.5);
Z_fm15=awgn(fm_modulated_signal,15);
Zs_fm15=lowpass(Z_fm15,0.5);

%plot
figure;
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
sgtitle('effect of noise in linear and angular modulations');

