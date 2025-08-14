# Signal-Modulation-and-Demodulation-with-MATLAB
This project, developed for the Telecommunications 1 course, focuses on simulating modulation and demodulation techniques for a triangular signal and a voice signal. The implementation is done in MATLAB, analyzing signals in both time and frequency domains, and evaluating the effects of non-linear distortion and noise.

Project Overview





Objective: Simulate linear (AM, DSB, SSB) and angular (FM) modulation/demodulation techniques, analyze their performance under non-linear distortion, and evaluate the impact of AWGN noise at different SNR levels (5, 10, 15 dB).



Signals:





Triangular Signal: Generated using MATLAB's sawtooth function with a frequency of 5 Hz and sampling frequency of 500 kHz.



Voice Signal: Loaded from an audio file (myVoice.m4a), normalized for processing.



Key Tasks:





Plot signals in time and frequency domains using FFT.



Implement modulation/demodulation for AM (μ=0.85), DSB, SSB, and FM (Δf=2 kHz, fc=50 kHz).



Analyze the effect of non-linear distortion (y = x^3 + 0.5x^2) on modulated signals.



Evaluate the impact of AWGN noise on demodulated signals.

Repository Structure





/src: Contains MATLAB scripts for signal generation, modulation, demodulation, and noise analysis.





my_module.m: Function for modulation.



my_demodule.m: Function for demodulation.



/outputs: Includes plots of time-domain signals, frequency spectra, modulated/demodulated signals, and noise-affected signals.



/data: Contains the input audio file (myVoice.m4a).

Key Features





Signal Generation:





Triangular signal created with sawtooth and normalized.



Voice signal normalized for consistent amplitude.



Modulation/Demodulation:





AM: Implemented with envelope detection for demodulation.



DSB: Product detection with low-pass filtering.



SSB: Phasing method using Hilbert transform.



FM: Using MATLAB's fmmod and fmdemod with a low-pass filter.



Analysis:





Frequency domain analysis using FFT (fft and abs).



Non-linear distortion applied to modulated signals.



Noise analysis with AWGN at SNR levels of 5, 10, and 15 dB.



Results:





FM shows better immunity to non-linear distortion compared to AM and DSB.



Plots and audio playback (commented) demonstrate signal quality under noise.

Prerequisites





MATLAB with Signal Processing Toolbox.


Notes





Ensure the audio file is in the correct format and path.



Some plots (e.g., FM modulation) are best viewed in MATLAB for clarity.



Audio playback code is commented out but can be enabled for testing.


Audio file (myVoice.m4a) for voice signal processing.

Sample Outputs




![untitled1](https://github.com/user-attachments/assets/584bcb22-929b-4cb7-9912-fadf6fe30020)
![untitled](https://github.com/user-attachments/assets/aa7de973-0597-4a42-9f61-7f8ec75138d1)
![ssb v](https://github.com/user-attachments/assets/8571e7e7-a170-40b0-8048-fcdc9a9e3643)
![ssb tri](https://github.com/user-attachments/assets/d1fad2a8-f614-4c0a-a3da-adc7d128b958)
![noise v](https://github.com/user-attachments/assets/00a37ee9-9efd-4ea6-bd3f-712a31bffb41)
![noise tri](https://github.com/user-attachments/assets/52c63e09-7d3e-42f4-a6b6-653df5a808ac)
![fm v](https://github.com/user-attachments/assets/ca7ac178-b045-40db-9182-dddfb0e3e719)
![fm tri](https://github.com/user-attachments/assets/e56328a6-2b03-4899-aa0f-2ded840b8c08)
![dsb V](https://github.com/user-attachments/assets/bad589cc-75d6-4a62-b9b1-1960adc63d55)
![dsb tri](https://github.com/user-attachments/assets/f3fa7abe-bcf4-45d8-a57a-783424bb4516)
![dis v](https://github.com/user-attachments/assets/f81b54c8-1983-4689-9d51-fa9d489ba89f)
![dis tri](https://github.com/user-attachments/assets/8056996e-1fbc-4d73-8fd2-c3fba6ba31d0)
![am v](https://github.com/user-attachments/assets/c63e693f-935d-4d6c-8b89-9227d8bbf093)
![am tri](https://github.com/user-attachments/assets/20c78103-a08f-4fae-b29c-8f13469121c9)




