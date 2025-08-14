%% Voice Signal

[y,Fs]=audioread('myVoice.m4a');
Voice_signal=y(:,2);
normalized_Voice=Voice_signal/(max(abs(Voice_signal(:))));
t_voice=(0:length(normalized_Voice)-1)/Fs;

% optional
%sound(Voice_signal,Fs)
%pause(ceil(length(Voice_signal)/Fs));

%Fs = 500000;                       % Sampling frequency in Hz
N1 = length(Voice_signal);          % Number of points in the signal
f1 = (0:N1-1) * Fs/N1;             % Frequency vector
fft_result = fft(Voice_signal);
magnitude_spectrum_voice = abs(fft_result);

figure;
subplot(2,1,1)
plot(t_voice,normalized_Voice)
xlabel('time(s)')
title('Voice signal')
subplot(2, 1, 2);
plot(f1, magnitude_spectrum_voice);
title('Frequency Content of voice Message Signal');
xlabel('Frequency (Hz)');
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

% DSB
y_dsb_mod = dsb_mod_voice .^3 + 0.5 * dsb_mod_voice .^2;
y_dsb_demod_voice=my_demodule(y_dsb_mod,Fs,t_voice,Wc);

% FM
y_fm_mod = fm_modulated_signal .^3 + 0.5 * fm_modulated_signal .^2;
y_fm_demodulated_signal = fmdemod(y_fm_mod, 100, 200, 50);

%plot
figure;
sgtitle('demodulation wuth Distortion');
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
plot(t_voice, y_fm_demodulated_signal);
title('FM Demodulated Signal with Distortion');
xlabel('Time (s)');
