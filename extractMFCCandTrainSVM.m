function extractMFCCandTrainSVM()
    % folders and labels
    folders = {'Train_label_1', 'Train_label_0'};
    labels = [1, 0];

    
    X = [];  % Feature matrix
    y = [];  % Label vector

    % Loop over both classes
    for k = 1:2
        folder = folders{k};
        label = labels(k);

        files = dir(fullfile(folder, '*.wav'));
        for i = 1:length(files)
            filePath = fullfile(folder, files(i).name);
            try
                [x, fs] = audioread(filePath);
                if size(x,2) > 1
                    x = mean(x, 2); % Convert to mono
                end

                % Computing MFCCs (default: 13 coefficients per frame)
                coeffs = mfcc(x, fs, ...
                    'NumCoeffs', 13, ...
                    'LogEnergy', 'Ignore');

                % Conversion to fixed-size feature vector (mean + std)
                meanCoeffs = mean(coeffs, 1);
                stdCoeffs = std(coeffs, 0, 1);
                featureVec = [meanCoeffs, stdCoeffs];  % 26-dimensional

                % Append to dataset
                X = [X; featureVec];
                y = [y; label];
            catch ME
                warning('Failed on %s: %s', filePath, ME.message);
            end
        end
    end

    % Save features and labels
    save('mfcc_features.mat', 'X', 'y');

    % Train/test split
    cv = cvpartition(y, 'HoldOut', 0.2);
    idxTrain = training(cv);
    idxTest = test(cv);

    XTrain = X(idxTrain,:);
    yTrain = y(idxTrain);
    XTest = X(idxTest,:);
    yTest = y(idxTest);

    % Training SVM
    svmModel = fitcsvm(XTrain, yTrain, 'KernelFunction', 'linear', 'Standardize', true);

    % Evaluation
    yPred = predict(svmModel, XTest);
    acc = sum(yPred == yTest) / numel(yTest);
    fprintf('\nSVM Accuracy: %.2f%%\n', acc * 100);

    % Saving the model
    save('svm_model_mfcc.mat', 'svmModel');
end
