## RPS Classifier
A rock paper scissors classifier built in Matlab. This repo contains files to perform classficiation both on offline data as well as live classification. 

### File Organization
**Data Collected** \
The data used in this project is present in the `dataCollection` directory. Here, there are 3 subdirectories: `11_10_Avery`, `11_6_Avery`, and `OldData`. The first two are used in the final model and were collected during the second set of data collection. OldData is the data present in the shared drive under the name RedMarsbar (Messy, resulted in low accuracy which is why we rerecorded.) 

This data was collected through the process described in the Neurotech 2023 repo. `recordData.mlapp` is the app used to interactively collect this data in Matlab. 

**Offline Classification** \
The `analysis` directory contains all the scripts needed to perform offline classification on the data obtained. There are two main files here: `MakeFeatureTable.mlx` and `Classification.mlx`. 

MakeFeatureTable imports the data collected from the dataCollection data and preprocesses it (bandpass filter) using the `preprocessData` function. This is saved as `fullDataBandpass.mat`. It then normalizes the data and extracts all possible features using the `extractFeatures` function. This is saved under `feature_norm_full_data.mat`. 

Classification imports in the normalized feature table and selects important features from this data. It then splits the data into training and testing based on the previous partition and builds a classification model. 

**Live Classification**\
The `dataCollection` directory also contains everything needed to run live classification. The process for this is properly documented in the Neurotech repo. `classifier.mat` contains the classifier created from the offline classification that is to be imported for live classification. `runMatlabModel.m` contains the final model to be run in the live classification. This imports the classifier as well as normalization metrics based on which individual the wristband is fitted to. The incoming data then follows the same pre-processing as the training data and predicts what gesture was performed.

