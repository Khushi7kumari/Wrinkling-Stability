% ANN script

clear; clc; close all;

filePath = "VHB_breakdown_dataset.xlsx";
if ~isfile(filePath)
    error("File not found: %s", filePath);
end

T = readtable(filePath,'PreserveVariableNames',true);

% Column names (change if needed)
col_lambda1 = "λ1";
col_lambda2 = "λ2";
col_thickness = "VHB Membrane";
col_vbr = "Dim_Vbr (V)";

% Directly use numeric columns (assumes already numeric)
lambda1 = T{:,col_lambda1};
lambda2 = T{:,col_lambda2};
thickness = T{:,col_thickness};
Vbr = T{:,col_vbr};

% --- Minimal feature engineering ---
aspect = lambda2 ./ lambda1;       % λ2/λ1
l1t    = lambda1 .* thickness;      % interaction

X = [lambda1, lambda2, thickness, aspect, l1t];
Y = Vbr(:);

% Simple split: 70% train, 30% test
N = size(X,1);
idx = randperm(N);
nTrain = round(0.7 * N);
trainIdx = idx(1:nTrain);
testIdx  = idx(nTrain+1:end);

Xtrain = X(trainIdx, :);
Ytrain = Y(trainIdx);
Xtest = X(testIdx, :);
Ytest = Y(testIdx);

% Standardize using train statistics
muX = mean(Xtrain,1);
sigmaX = std(Xtrain,[],1);
sigmaX(sigmaX==0) = 1;
XtrainZ = (Xtrain - muX) ./ sigmaX;
XtestZ  = (Xtest - muX) ./ sigmaX;

muY = mean(Ytrain); sigmaY = std(Ytrain);
YtrainZ = (Ytrain - muY) ./ sigmaY;

% --- Simple ANN ---
layers = [
    featureInputLayer(size(XtrainZ,2), 'Normalization', 'none')
    fullyConnectedLayer(64)
    reluLayer
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer
];

opts = trainingOptions('adam', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',100, ...
    'MiniBatchSize',16, ...
    'Shuffle','every-epoch', ...
    'Verbose',false);

fprintf('Training simple ANN...\n');
net = trainNetwork(XtrainZ, YtrainZ, layers, opts);

% Predict and evaluate
YpredZ = predict(net, XtestZ);
Ypred = YpredZ * sigmaY + muY;

res = Ytest - Ypred;
RMSE = sqrt(mean(res.^2));
MAE = mean(abs(res));
SS_res = sum(res.^2);
SS_tot = sum((Ytest - mean(Ytest)).^2);
R2 = 1 - SS_res/SS_tot;

fprintf('\nResults on test set:\nRMSE = %.4f\nMAE = %.4f\nR^2 = %.4f\n', RMSE, MAE, R2);

% Plot
figure; scatter(Ytest, Ypred, 50, 'filled'); hold on;
mn = min([Ytest; Ypred]); mx = max([Ytest; Ypred]);
plot([mn mx],[mn mx],'k--'); xlabel('True Dim\_Vbr (V)'); ylabel('Predicted Dim\_Vbr (V)');
title(sprintf('ANN: R^2=%.3f, RMSE=%.3f', R2, RMSE)); grid on; axis equal;

% Save model and scalers
save('modal_for_breakdown_voltage.mat', 'net', 'muX', 'sigmaX', 'muY', 'sigmaY');
fprintf('Saved ANN model to modal_for_breakdown_voltage.mat\n');