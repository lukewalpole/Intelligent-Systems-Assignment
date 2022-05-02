% All comments have been removed to make the code more readable and because
% an explanation of how to code works is given in the AI Experiements
% section. 
% The experiment code and database is referenced at the start of
% the AI Experiements section. 

clc;
clear;

url = ['https://www.kaggle.com/datasets/sartajbhuvaji/brain-tumor-classification' ...
    '-mri?utm_source=pocket_mylist'];

outputFolder = fullfile('archive');
rootFolder = fullfile(outputFolder, 'Training');

categories = {'pituitary_tumor', 'no_tumor', 'meningioma_tumor', 'glioma_tumor'};

imds = imageDatastore(fullfile(rootFolder,categories), 'LabelSource', 'foldernames');

table = countEachLabel(imds)

minSetCount = min(table{:,2});

imds = splitEachLabel(imds, minSetCount, 'randomize');
countEachLabel(imds)

pituitary_tumor = find(imds.Labels == 'pituitary_tumor', 1);
no_tumor = find(imds.Labels == 'no_tumor', 1);
meningioma_tumor = find(imds.Labels == 'meningioma_tumor', 1);
glioma_tumor = find(imds.Labels == 'glioma_tumor', 1);

subplot(2,2,1);
imshow(readimage(imds,pituitary_tumor));
subplot(2,2,2);
imshow(readimage(imds,no_tumor));
subplot(2,2,3);
imshow(readimage(imds,meningioma_tumor));
subplot(2,2,4);
imshow(readimage(imds,glioma_tumor));

net = resnet50();

figure
plot(net)
title('ResNet-50 Architecture')
set(gca,'YLim', [150 170]);

net.Layers(1)

net.Layers(end)

numel(net.Layers(end).ClassNames)

[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomized');

imageSize = net.Layers(1).InputSize;
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet, ...
    'ColorPreprocessing','gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet, ...
    'ColorPreprocessing','gray2rgb');

w1 = net.Layers(2).Weights;
w1 = mat2gray(w1);

figure
montage(w1)
title('First Convolutional Layer Weight')

featureLayer = 'fc1000';
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

trainingLabels = trainingSet.Labels;

classifier = fitcecoc(trainingFeatures, trainingLabels, 'Learner', 'Linear', ...
    'Coding', 'onevsall', 'ObservationsIn', 'columns');

testFeatures = activations(net, augmentedTestSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');

predictLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

testLabels = testSet.Labels;

confMat = confusionmat(testLabels, predictLabels);

confMat = bsxfun(@rdivide, confMat, sum(confMat,2))

mean(diag(confMat))

testImage = readimage(testSet, 1);
testLabel = testSet.Labels(1)

ds = augmentedImageDatastore(imageSize, testImage, 'ColorPreprocessing', 'gray2rgb');

imageFeatures = activations(net, ds, featureLayer, 'OutputAs', 'columns');

predictedLabel = predict(classifier, imageFeatures, 'ObservationsIn', 'columns')



