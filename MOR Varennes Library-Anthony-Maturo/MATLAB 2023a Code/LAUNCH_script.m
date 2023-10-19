%% TEST MODEL PERFORMANCE OF THE ROM FOR VARENNES LIBRARY

clear
clc

load MODEL_VARENNES_5C6R

%%% MODEL_VARENNES description %%%
% This file containes the matrices A,B,C and D, the data used for the
% calibration and the validation. In detail:
%
% # Data_calibration, represent the measurement for each node during the
%   calibratrion horizon. It gives values of indoor temperatures [°C], 
%   outdoor temperature [°C], solar radiation [W/m2] and thermal energy [W].
%
% # Data_validation , represent the measurement for each node during the
%   validation horizon. It gives values of indoor temperatures [°C], 
%   outdoor temperature [°C], solar radiation [W/m2] and thermal energy [W].
%
% # MODEL, is the "structure" file with the matrices and performance over
%   the calibration period, including the RMSE [°C] and FIT [%].
%
% # prediction, is the prediction horizon. The unit is in timestamps,
%   considering a time step of 15 minutes. (example, 96/4 = 24 hours)
% 
% # numberofnodes, is the number of nodes of the model.


%% Choose the value of "CALIBRATION"
CALIBRATION = 0;   % if 1, considers calibratrion results, else, considers
                   % validation results

                   if CALIBRATION == 1
                       Temperature = Data_calibration{:,1:numberofnodes}';
                       Uinput      = Data_calibration{:,numberofnodes+1:end}';
                       time        = Data_calibration.Time;
                       timestamps  = size(Data_calibration,1)-prediction;
                   else
                       Temperature = Data_validation{:,1:numberofnodes}';
                       Uinput      = Data_validation{:,numberofnodes+1:end}';
                       time        = Data_validation.Time;
                       timestamps  = size(Data_validation,1)-prediction;
                   end

% Converting all the temperatures from °C to K
to_kelvin   = 273.15;
Temperature = Temperature + to_kelvin;
Uinput(1,:) = Uinput(1,:) + to_kelvin;


%% Evaluation of temperature prediction
Tnext = [];
for j = 1:numberofnodes
    eval(['TnextHistory_' num2str(j) '=[];'])
end
for k = 0:timestamps-1
    initialcondition = [Temperature(:,k+1)];
    Tprevious = initialcondition;
    for kk = 1:prediction
        Tnext(:,kk) = MODEL.A*Tprevious + MODEL.B*Uinput(:,k+kk);
        Tprevious = Tnext(:,kk);
    end
    for kkk = 1:numberofnodes
        eval(['TnextHistory_' num2str(kkk) '=[TnextHistory_' num2str(kkk) '; Tnext(kkk,:)];'])
    end
end

%% Figure definition
NAME = char('MODEL FOR VARENNES LIBRARY');
figure('Color', 'w', 'Name', NAME)
for kkk = 1:numberofnodes
    hold on
    X(kkk) = subplot(numberofnodes,1,kkk);
    plot(time,Temperature(kkk,1:timestamps+prediction)-to_kelvin, 'LineWidth', 2)
    hold on
    for kkkk = 1:timestamps-1
        eval(['plot(time(kkkk:kkkk+prediction-1),TnextHistory_' num2str(kkk) '(kkkk,1:prediction)-to_kelvin, ''LineWidth'' , 0.5, ''Color'' , [0.8 0.8 0.9 0.3]);'])
    end
    ylabel(['T_{node' num2str(kkk) '} [^oC]'])
    if kkk < numberofnodes
        set(gca,'XTickLabel',[]);
        set(gca,'fontname', 'Times New Roman', 'FontSize', 12)
    else
        set(gca,'fontname', 'Times New Roman', 'FontSize', 12)
    end
    set(get(gca,'YLabel'),'Rotation',60)
    ylim([17 26.5]);
    grid on
end
legend('Measured','Predicted')

%% Performance evaluation
timelenght = prediction;    % prediction performance evaluation,
                            % this value may be changed to check the
                            % performance of the developed model (<= 96).

% RMSE evaluation
RMSElocal  = [];      % RMSE for each time step
RMSEnode   = [];      % RMSE of each node 
RMSEglobal = [];      % RMSE of the whole building 

for i=1:numberofnodes
    for ii = 1:timestamps-1
        eval(['XXX = TnextHistory_' num2str(i) '(ii,1:timelenght);'])
        for iii =1:timelenght
            element(iii) = (Temperature(i,ii+iii-1)-XXX(iii))^2;
        end
        RMSElocal(ii,i) = rmse(XXX,Temperature(i,ii:ii+timelenght-1));
    end
end
for i=1:size(RMSElocal,2)
    RMSEnode(1,i) = mean(RMSElocal(:,i));
end
RMSEglobal = mean(RMSEnode)


% FIT evaluation
FITlocal  = [];      % FIT for each time step
FITnode   = [];      % FIT of each node
FITglobal = [];      % FIT of the whole building
element = [];
for h=1:numberofnodes
    for ii = 1:timestamps-1
        eval(['XXX = TnextHistory_' num2str(h) '(ii,1:timelenght);'])
        for iii =1:timelenght
            element(iii)  = (Temperature(h,ii+iii-1)-XXX(iii))^2;
            element1(iii) = (Temperature(h,ii+iii-1)-mean(Temperature(h,1:timestamps-1)))^2;
        end
        FITlocal(ii,h)= 100*(1-sqrt(sum(element(:)))/sqrt(sum(element1(:))));
    end
end
for h=1:size(FITlocal,2)
    FITnode(h,1) = mean(FITlocal(:,h));
end
FITglobal = mean(FITnode)


clear NAME element element1 h i ii iii initialcondition j k kk kkk kkkk Tnext ...
    Tprevious X XXX