function analyzePitchStatistics()
    
    folder1 = 'Train_label_1';  % Class 1 (drone)
    folder0 = 'Train_label_0';  % Class 0 ( background)

    % Analyzing both folders
    freqs1 = extractPitchFromFolder(folder1);
    freqs0 = extractPitchFromFolder(folder0);

    % Cleaning pitch data (remove 0 or NaN)
    freqs1 = freqs1(freqs1 > 0 & ~isnan(freqs1));
    freqs0 = freqs0(freqs0 > 0 & ~isnan(freqs0));

    %  statistics
    stats1 = computePitchStats(freqs1);
    stats0 = computePitchStats(freqs0);

    % results
    fprintf('\n=== Train_label_1 (Class 1) ===\n');
    disp(stats1);
    fprintf('\n=== Train_label_0 (Class 0) ===\n');
    disp(stats0);

    % Saving statistics to MAT file
    save('pitch_statistics.mat', 'stats1', 'stats0');

    % Plot
    figure;
    histogram(freqs1, 'Normalization', 'pdf');
    hold on;
    histogram(freqs0, 'Normalization', 'pdf');
    legend('Class 1 (Train_label_1)', 'Class 0 (Train_label_0)');
    xlabel('Pitch (Hz)');
    ylabel('Probability Density');
    title('Fundamental Frequency Distributions');
    grid on;
end

function freqs = extractPitchFromFolder(folderPath)
    files = dir(fullfile(folderPath, '*.wav'));
    freqs = [];
    for i = 1:length(files)
        filePath = fullfile(folderPath, files(i).name);
        try
            [x, fs] = audioread(filePath);
            if size(x,2) > 1
                x = mean(x, 2); % Convert to mono
            end
            pitchVals = pitch(x, fs, ...
                'WindowLength', 1024, ...
                'OverlapLength', 512, ...
                'Range', [50 1000]);  % f range
            
            % Concatenate all pitch values
            freqs = [freqs; pitchVals]; 
        catch ME
            warning('Error processing %s: %s', filePath, ME.message);
        end
    end
end

function stats = computePitchStats(freqs)
    stats.mean = mean(freqs);
    stats.median = median(freqs);
    stats.std = std(freqs);
    stats.min = min(freqs);
    stats.max = max(freqs);
    stats.count = numel(freqs); % total number of elements in freqs
end
