function res = runMatlabModel(data)
    %%%
    % This function should take in a bunch of data from the EMG sensor
    % and return rock, paper, and scissors, based on what your model
    % predicts. 
    %%%
    addpath('../analysis');

    % Defining sampling frequency and channel number
    Fs = 1000;
    numCh = 4;

    % Filter incoming data same way as training model
    filtered_lsl_data = [];
    for ch = 1:numCh
        x = highpass(data(:,ch+1),5,Fs);
        x = bandstop(x,[58 62],Fs);
        x = bandstop(x,[118 122],Fs);
        filtered_lsl_data(:,ch) = bandstop(x,[178 182],Fs);
    end
    
    dataChTimeTr = filtered_lsl_data';

    % Extract same features from new data as trained on
    includedFeatures = {'var','rms','william', 'lcov', 'wl', 'iqr'}; 
    feature_table1 = extractFeatures(dataChTimeTr,includedFeatures,Fs);

    % Load in feature table that was trained on 
    load("feature_table.mat",  "full_feature_table");
    feature_og = full_feature_table;

    % For Rucha's hand, load in previously created feature table with mean
    % and standard deviation and normalize to new data based on that 
    
    % Change this to "feature_norm_averytest_bandpassHz.mat" for Avery's
    % hand
    load("feature_norm_ruchatest_bandpassHz.mat", "C", "S");
    feature_table = normalize(feature_table1, "center", C, "scale", S);
    full_feature_table = [feature_og; feature_table];

    % Load pretrained classifier
    load classifier.mat currentClassifier;
    classifier = currentClassifier;

    % Select ideal features for classification
    selected_features = [5 6 7 8 21 22 23 24];
    X_test = feature_table(:,selected_features);

    % Prediction is returned
    y_test_prediction = currentClassifier.predict(X_test);
    res = y_test_prediction;
end