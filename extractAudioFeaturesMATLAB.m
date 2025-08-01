function features = extractAudioFeaturesMATLAB(filePath)
    [x, fs] = audioread(filePath); % recorded.wav
    if size(x,2) > 1
        x = mean(x,2); 
    end

    win = hann(512, 'periodic');
    overlap = round(0.75 * length(win));

    % MFCC
    coeffs = mfcc(x, fs, 'Window', win, 'OverlapLength', overlap, 'NumCoeffs', 13);

    % Chroma
    s = stft(x, 'Window', win, 'OverlapLength', overlap, 'FFTLength', 512);
    mag = abs(s);
    chroma = computeChroma(mag, fs);

    % Spectral Contrast Approximation
    [s2, ~, ~] = spectrogram(x, win, overlap, 512, fs);
    magnitude = abs(s2);
    contrast = std(magnitude, 0, 2);  % Approximation

    % Fix dimensions to 130 frames
    mfccFixed = padOrTruncate(coeffs', 130);
    chromaFixed = padOrTruncate(chroma, 130);
    contrastFixed = padOrTruncate(contrast', 130);

    features = [mfccFixed(:); chromaFixed(:); contrastFixed(:)];

  
end

function out = padOrTruncate(mat, targetLen)
    [r, c] = size(mat);
    if c < targetLen
        out = [mat, zeros(r, targetLen - c)];
    else
        out = mat(:, 1:targetLen);
    end
end

function chroma = computeChroma(mag, fs)
    powerSpec = mag.^2;
    [numBins, numFrames] = size(powerSpec);
    chroma = zeros(12, numFrames);

    f = linspace(0, fs/2, numBins);
    A440 = 440;
    midi = 69 + 12*log2(f / A440);
    chromaIndex = mod(round(midi), 12) + 1;

    for k = 1:numFrames
        for b = 1:numBins
            if ~isnan(chromaIndex(b)) && chromaIndex(b) >= 1 && chromaIndex(b) <= 12
                chroma(chromaIndex(b), k) = chroma(chromaIndex(b), k) + powerSpec(b, k);
            end
        end
    end
end
