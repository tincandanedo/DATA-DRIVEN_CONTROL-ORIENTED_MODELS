function NNtraining(input)
%% Preparing the Data
if input==1
InData=load ('InitialData','InitialData');
disp('load initial data for model trainning successful.');
xx=con2seq(InData.InitialData(:,1:3)');
tt=con2seq(InData.InitialData(:,4)');
net = narxnet(1,1,2);
net.trainParam.showWindow = 0;
[Xs,Xi,Ai,Ts] = preparets(net,xx,{},tt);

%%
[net,tr] = trainlm(net,Xs,Ts,Xi,Ai);
save('net');
disp('neural network model trainning successful.');
end
end

