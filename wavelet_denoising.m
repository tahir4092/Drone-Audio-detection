

% Reading the audio file
[X, Fs] = audioread("1.wav");
fprintf('Original file Fs: %d Hz\n', Fs);



% Denoising
xden = wdenoise(X);

% Normalizing
xden = xden / max(abs(xden));  

% Saving the denoised audio
audiowrite("recorded.wav", xden, Fs);  

fprintf('Denoised audio saved as "recorded.wav" at %d Hz\n', Fs);

