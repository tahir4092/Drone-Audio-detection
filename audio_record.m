%  audio recording
clear; clc;

% parameters
fs = 44100;        % Hz
nBits = 16;        
nChannels = 1;     
duration = 5;      % Recording duration in seconds


recorder = audiorecorder(fs, nBits, nChannels);

% Starting recording
disp('Recording started... ');
record(recorder, duration);

% Waiting for recording to complete
pause(duration + 0.5);

% Stopping the recording
stop(recorder);
disp('Recording completed.');


audioData = getaudiodata(recorder);

disp('Playing back recorded audio...');
play(recorder);

% Saving
filename = 'recordedaudio.wav';
audiowrite(filename, audioData, fs);
disp(['Audio saved as: ' filename]);

% Plot 
figure;
t = (0:length(audioData)-1) / fs;
plot(t, audioData);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Recorded Audio Waveform');
grid on;
