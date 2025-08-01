[signal, Fs] = audioread('recorded_audio.wav');

% Using Wiener filter (adaptive)
clean_signal = wiener2(signal, [1 round(0.02*Fs)]); % 20ms window

% Save and play
audiowrite('recorded.wav', clean_signal, Fs);
soundsc(clean_signal, Fs);
t = (0:length(signal)-1)/Fs;  
figure;  
subplot(2,1,1); plot(t, signal); title('Original Audio'); xlim([0 5]);  
subplot(2,1,2); plot(t, clean_signal); title('Wiener Filtered'); xlim([0 5]);
