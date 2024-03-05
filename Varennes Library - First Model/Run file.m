range = [1:900:86400*4];
data2=xlsread('Input_3','A:D');
data1=xlsread('Output_3','A:D');
% ICs=[data1(1,1),data1(1,3),data1(1,3),data1(1,3),20,20,20,20,data1(1,2),data1(1,4),data1(1,4),data1(1,4),data1(1,4),20,20,20];
% ICs=[20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20];
% ICs=[a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a];
a=3;
b=5;
ICs=[data1(1,1),data1(1,3)+a,data1(1,3)+a+b,data1(1,3)+a+b,data1(1,3),data1(1,1),data1(1,3)+a,data1(1,3)+a,data1(1,2),data1(1,4)+a,data1(1,4)+a+b,data1(1,4)+a+b,data1(1,4)+a+b,data1(1,2),data1(1,4)+a,data1(1,4)+a];
To_inp=data2(1:end,1);
Q1_inp=data2(1:end,2);
Q2_inp=data2(1:end,3); 
S_inp=data2(1:end,4);
Tg_inp=data2(1:end,1)+7;

opts = odeset('MaxStep',300)
[t,T]=ode15s(@(t,var) Heat_test_ref_draft2(t,var,To_inp,Q1_inp,Q2_inp,S_inp,Tg_inp),range,ICs);
[t,T_simple]=ode15s(@(t,var) Heat_test_simple_draft2(t,var,To_inp,Q1_inp,Q2_inp,S_inp,Tg_inp),range,ICs);
[t,T_wall]=ode15s(@(t,var) Heat_test_wall_draft2(t,var,To_inp,Q1_inp,Q2_inp,S_inp,Tg_inp),range,ICs);
[t,T_air]=ode15s(@(t,var) Heat_test_air_draft2(t,var,To_inp,Q1_inp,Q2_inp,S_inp,Tg_inp),range,ICs);
[t,T_wall_air]=ode15s(@(t,var) Heat_test_wall_air_draft2(t,var,To_inp,Q1_inp,Q2_inp,S_inp,Tg_inp),range,ICs);
s=193;
f=288;

figure(1)
x1 = t(s:f);
y1 = data1(s:f,1);
d1=plot(x1,y1,'LineWidth',3)
hold on

y2 = T(s:f,1);
p2=plot(x1,y2,'LineWidth',3);
hold on

y3 = T_simple(s:f,1);
p3=plot(x1,y3,'LineWidth',3);
hold on

y4 = T_wall(s:f,1);
p4=plot(x1,y4,'LineWidth',3);
hold on

y5 = T_air(s:f,1);
p5=plot(x1,y5,'LineWidth',3);
hold on

y6 = T_wall_air(s:f,1);
p6=plot(x1,y6,'LineWidth',3);


title('2nd floor air T on sunny day')

h=[d1; p2; p3; p4; p5; p6];
legend(h,'Data','Reference','30% Capacitance','Wall','Air','Air-Wall');

hold off


figure(2)

x1 = t(s:f);
y11 = data1(s:f,2);
d11=plot(x1,y11,'LineWidth',3)
hold on

y12 = T(s:f,9);
p12=plot(x1,y12,'LineWidth',3);
hold on

y13 = T_simple(s:f,9);
p13=plot(x1,y13,'LineWidth',3);
hold on

y14 = T_wall(s:f,9);
p14=plot(x1,y14,'LineWidth',3);
hold on

y15 = T_air(s:f,9);
p15=plot(x1,y15,'LineWidth',3);
hold on

y16 = T_wall_air(s:f,9);
p16=plot(x1,y16,'LineWidth',3);
title('air T on 1st floor 17 February')
h=[d11; p12; p13; p14; p15; p16];
legend(h,'Data','Reference','30% Capacitance','Wall','Air','Air-Wall');
hold off
NMBE1=sum(y1-y2)/(96*mean(y1));
RMSE1 = sqrt(sum((y1-y2).^2)./95)/mean(y1);
NMBE2=sum(y1-y3)/(96*mean(y1));
RMSE2 = sqrt(sum((y1-y3).^2)./95)/mean(y1);
NMBE3=sum(y1-y4)/(96*mean(y1));
RMSE3 = sqrt(sum((y1-y4).^2)./95)/mean(y1);
NMBE4=sum(y1-y5)/(96*mean(y1));
RMSE4 = sqrt(sum((y1-y5).^2)./95)/mean(y1);
NMBE5=sum(y1-y6)/(96*mean(y1));
RMSE5 = sqrt(sum((y1-y6).^2)./95)/mean(y1);

NMBE11=sum(y11-y12)/(96*mean(y11));
RMSE11 = sqrt(sum((y11-y12).^2)./95)/mean(y11);
NMBE12=sum(y11-y13)/(96*mean(y11));
RMSE12 = sqrt(sum((y11-y13).^2)./95)/mean(y11);
NMBE13=sum(y11-y14)/(96*mean(y11));
RMSE13 = sqrt(sum((y1-y4).^2)./95)/mean(y1);
NMBE14=sum(y11-y15)/(96*mean(y11));
RMSE14 = sqrt(sum((y11-y15).^2)./95)/mean(y11);
NMBE15=sum(y11-y16)/(96*mean(y11));
RMSE15 = sqrt(sum((y11-y16).^2)./95)/mean(y11);
