clear all
clc

%load data
load('Inputdata.mat');

%convert 0s to 10s for X and y
%(and later convert the predicted result back to 0)
for i = 1 : length(trainY)
	if trainY(i) == 0
	trainY(i) = 10;
end
end
for i = 1 : length(testY)
	if testY(i) == 0
	testY(i) = 10;
end
end
for i = 1 : length(CV_Y)
	if CV_Y(i) == 0
	CV_Y(i) = 10;
end
end

% Define some useful variables
X = trainX; % X size: 60,000 *784
y = trainY; % y size: 60,000 * 1
%set Cross Validation set
CV_X = CV_X;
CV_Y = CV_Y;
%set test set
testX = testX;
testY = testY;
m = size(X,1); % number of training examples
n = size(X,2);% number of features

%construct neural network architecture
NetworkLayers = 3;
Input_Neurons = 784;
Hiddden_Neurons = 400;%156;
Output_Neurons = 10;

%plot part of input data
sel = randperm(size(X,1));
sel = sel(1:100);
Display_Data(X(sel, :));

%randomly initialize theta
Init_Theta1 = Initialize_Theta(Input_Neurons,Hiddden_Neurons); %Theta1 size: 15 * 784+1
Init_Theta2 = Initialize_Theta(Hiddden_Neurons,Output_Neurons); %Theta2 size: 10 * 15+1
Init_Theta = [Init_Theta1(:);Init_Theta2(:)];

%Use cost function to compute cost&grandient
lambda = 1.82; %first set lambda(penalty for weights to prevent overfitting)
[J,Grad] = CostGradFunc(X,y,Init_Theta,Input_Neurons,Hiddden_Neurons,Output_Neurons,lambda);
J
%gradient check(check if backpropagation is implemented correctly)
GradientCheck(lambda);
pause;
%fprintf('\nloading errors for differ modal + lambda... \n')

%ModelLambdaSelection(X,y,CV_X,CV_Y,Input_Neurons,Output_Neurons);

%pause;

%%Train Neural Network
fprintf('\nTraining Neural Network... \n')
theta = TrainNeurals(X,y,lambda,Init_Theta,Input_Neurons,Hiddden_Neurons,Output_Neurons);

%resize Theta
num_theta1 = Hiddden_Neurons * (Input_Neurons +1);
Theta1 = reshape(theta(1:num_theta1),Hiddden_Neurons,Input_Neurons+1);
Theta2 =  reshape(theta(num_theta1+1:end),Output_Neurons,Hiddden_Neurons+1);

%predict the handwrite recognition and give accuracy
Prediction = predict(Theta1,Theta2,X);
accuracy = mean(double(Prediction == y)) * 100;
fprintf('\nLearning Accuracy: %f\n', accuracy)
%Test accuracy
TestPrediction = predict(Theta1,Theta2,testX);
accuracyTest = mean(double(TestPrediction == testY)) * 100;
fprintf('\nTest Accuracy: %f\n', accuracyTest)

%Build Learning Curve to diagnose
%*sel = randperm(size(CV_X,1));
%*sel = sel(1:50);
%*[error_train, error_val] = LearningCurve(X(sel,:),y(sel,:),CV_X(sel,:),CV_Y(sel,:),lambda,Input_Neurons,Hiddden_Neurons,Output_Neurons,Init_Theta);
%*plot(1:50, error_train, 1:50, error_val);
%*title('Learning curve for neural network')
%*legend('Train', 'Cross Validation')
%*xlabel('Number of training examples')
%*ylabel('Error')
%*axis([0 50 0 150])

%*fprintf('# Training Examples\tTrain Error\tCross Validation Error\n');
%*for i = 1:length(error_train)
    %*fprintf('  \t%d\t\t%f\t%f\n', i, error_train(i), error_val(i));
%*end

%Ask input and predict
PredictUserInput;
