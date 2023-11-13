function res = runMatlabModel()
    %%%
    % This is starter code for where you should add your MATLAB model.
    % You can place this wherever you want, but keep the function name
    % This function should take in a bunch of data from the EMG sensor
    % and return rock, paper, and scissors, based on what your model
    % predicts. 
    %%%
    % disp(data)

    % Defining sampling frequency and channel number
    Fs = 1000;
    numCh = 4;

    % First check to make sure Fs (samping frequency is correct)
    actualFs = 1/mean(diff(data(:,1)));
    if abs(diff(actualFs - Fs )) > 50
        warning("Actual Fs and Fs are quite different. Please check sampling frequency.")
    end

    % Filter data same way as training
    filtered_lsl_data = [];
    filtered_lsl_data(:,1) = data(:,1);
    for ch = 1:numCh
        filtered_lsl_data(:,1+ch) = highpass(data(:,ch+1),20,Fs);

        % x = highpass(lsl_data(:,ch+1),5,Fs);
        % x = bandstop(x,[58 62],Fs);
        % x = bandstop(x,[118 122],Fs);
        % filtered_lsl_data(:,1+ch) = bandstop(x,[178 182],Fs);
    end
    
    dataChTimeTr = filtered_lsl_data;

    % Extract same features from new data as trained on
    includedFeatures = {'var','rms','william', 'lcov', 'wl', 'iqr'}; 
    feature_table = extractFeatures(dataChTimeTr,includedFeatures,1000);

    % Load pretrained classifier
    load classifier.mat currentClassifier;
    classifier = currentClassifier;

    % Select ideal features for classification
    selected_features = [5 6 7 8 9 10 11 12];
    X_test = feature_table(:,selected_features);

    % Prediction
    y_test_prediction = currentClassifier.predict(X_test);
    res = y_test_prediction;
end