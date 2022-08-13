function [outmod,btz] = trainandtest(train1)
% it will train and test the method and  gives you model for
% Predicting New dates
%   Train1 Dataset for training
% outmod give the model out

tbl=train1;
labelName = "Output";
tbl = convertvars(tbl,labelName,'categorical');
numObservations = size(tbl,1)
numObservationsTrain = floor(0.7*numObservations)
numObservationsValidation = floor(0.15*numObservations)
numObservationsTest = numObservations - numObservationsTrain - numObservationsValidation
idx = randperm(numObservations);
idxTrain = idx(1:numObservationsTrain);
idxValidation = idx(numObservationsTrain+1:numObservationsTrain+numObservationsValidation);
idxTest = idx(numObservationsTrain+numObservationsValidation+1:end);
tblTrain = tbl(idxTrain,:);
tblValidation = tbl(idxValidation,:);
tblTest = tbl(idxTest,:);

%% Creating Neural network
numFeatures = 3;
numClasses = 2;
 
layers = [
    featureInputLayer(numFeatures,'Normalization', 'zscore')
    fullyConnectedLayer(50)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
miniBatchSize = 16;

options = trainingOptions('adam', ...
    'MiniBatchSize',miniBatchSize, ...
    'Shuffle','every-epoch', ...
    'ValidationData',tblValidation, ...
    'Plots','training-progress', ...
    'Verbose',false);


%% Training
net = trainNetwork(tblTrain,labelName,layers,options);
figure;
title('Neural Network Layers')
plot(net)
%% testing

YPred = classify(net,tblTest(:,1:end-1),'MiniBatchSize',miniBatchSize);
YTest = tblTest{:,labelName};
accuracy = sum(YPred == YTest)/numel(YTest)
figure
confusionchart(YTest,YPred)

btz=miniBatchSize;
outmod = net;
end