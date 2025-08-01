function predictSVMFromAudio(audioFile)
    % Load trained SVM model
    load('svm_model_mfcc.mat', 'svmModel');
    
    % Load audio
    [x, fs] = audioread("recorded.wav");
    if size(x,2) > 1
        x = mean(x, 2);  % Convert to mono
    end

    % Compute MFCCs
    coeffs = mfcc(x, fs, ...
        'NumCoeffs', 13, ...
        'LogEnergy', 'Ignore');

    % Convert to fixed-size feature vector
    meanCoeffs = mean(coeffs, 1);
    stdCoeffs = std(coeffs, 0, 1);
    featureVec = [meanCoeffs, stdCoeffs];  % 26-dimensional

    % Predict
    predictedLabel = predict(svmModel, featureVec);
    
    % Display result
    if predictedLabel == 1
        disp('Prediction: DRONE');
    else
        disp('Prediction: NOT DRONE');
    end
end
