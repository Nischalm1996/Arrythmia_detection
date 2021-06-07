
data=xlsread('ecg.xlsx',1); 
time=data(:,1);
ecg=data(:,2);
% ecg_smooth=smooth(time,ecg,0.005,'moving'); %%%%%%%%%%%%%large amp

% plot(time,ecg_smooth,'k');
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%find R in the QRS
[A,B]=findpeaks(ecg,'MinPeakHeight',1.09,'MinPeakDistance',90); %%%% manual judedgement - constant for a given strain/deflection level


time_R=time(B); %%%%%%TIME CORRESPONDING TO PEAK R value 
R_peaks=A; %%%%%%PEAK R VALUES

MM=vertcat(0,time_R);
time_diff_R=diff(MM); %%%%%%%%Difference in the time values between peak to peak R values

%%%%%%%%%%%%%%%%%%%%%%%%find S in the QRS
ecg_new=-ecg;
plot(time,ecg_new);
[A1,B1]=findpeaks(ecg_new,'MinPeakHeight',0.4,'MinPeakDistance',90); %%%% manual judedgement - constant for a given strain/deflection level

time_S=time(B1); %%%%%%TIME CORRESPONDING TO PEAK R value 
S_peaks=-A1; %%%%%PEAK S VALUES

MM1=vertcat(0,time_S);
time_diff_S=diff(MM1); %%%%%%%%Difference in the time values between peak to peak S values


%%%%%%%%%%%%%%%%%%%%%%%%find Q in the QRS
T=vertcat(0,time_R(1),time_S(1),time_R(2),time_S(2),time_R(3),time_S(3));

for i=0:length(R_peaks)-1
% v(:,i)=find(time<T(2,1) & time>T((2*i)+1));
[vv,yy]=find(time<T((2*i)+2) & time>T((2*i)+1));
p=ecg(vv(end-20:end));
q=time(vv(end-20:end));
[z,z1]=min(p);
time_Q(i+1)=q(z1);
Q_peaks(i+1)=z;
clear v p q z z1 vv yy
end

time_Q=time_Q';
Q_peaks=Q_peaks';

plot(time,ecg,'r');
hold on
scatter(time(B),A);
hold on
scatter(time(B1),-A1);
hold on
scatter(time_Q,Q_peaks);

QRS_time=time_S-time_Q; %%%%%%%%%%%%%%QRS time
