

%  directory for Train_label_0 
inputDir = 'Train_label_0';
outputDir = 'spectrogram_images_0/';

% Creating output directory if it doesn't exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%  list of all .wav files
wavFiles = dir(fullfile(inputDir, '*.wav'));

% Spectrogram parameters
window = hann(1024);
noverlap = 800;
nfft = 2048;

minLength = length(window);  % 

for k = 1:length(wavFiles)
    %  path of the current audio file
    filePath = fullfile(inputDir, wavFiles(k).name);
    
    
    [x, fs] = audioread(filePath);
    if size(x, 2) > 1
        x = mean(x, 2); 
    end

    % Check if signal is long enough
    if length(x) < minLength
        fprintf('Skipping %s: too short (%d samples)\n', wavFiles(k).name, length(x));
        continue;
    end

    %  spectrogram
    [s, f, t] = spectrogram(x, window, noverlap, nfft, fs);

    % Plot
    fig = figure('Visible', 'off');
    imagesc(t, f, 20*log10(abs(s)));
    axis xy;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('');
    ylim([0 3000]);
    colormap jet;
    colorbar off;
    
   
    axis off;

    % Save spectrogram image
    [~, name, ~] = fileparts(wavFiles(k).name);
    outputFile = fullfile(outputDir, [name '.png']);
    saveas(fig, outputFile);
    close(fig);
end

disp('All spectrograms saved!');
