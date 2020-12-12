%% Assignment 2 Q4

clear all
close all


DT=0.1;
Tend = 50;
t=0:DT:Tend;

A=eye(3)+DT*[-2 1 0; -2 0 1; -2 0 0];
B=DT*[5;5;1];
C=[1 0 0];
Q=[0.1 0 0; 0 0.2 0; 0 0 0.3]; %Process noise covariance
R=0.1; %Sensor noise covariance

x=zeros(3,length(t));
x(:,1)=[3;-3;2];
y=zeros(length(t),1);

xHat=zeros(3,length(t));
xHat(:,1)=[3;-3;2];
P=eye(3);
Kk=zeros(3,1);

% Input signal
U(:,1)=1*ones(length(t),1);
U(:,2)=sin(0.5*t);

randn('seed',0);
w = DT*mvnrnd([0 0 0],Q,length(t));
v = mvnrnd(0,R,length(t));
%m=2;
%u = U(:,m);
for m=1:2
    u = U(:,m);
    
for k=1:Tend/DT
    %actual system
    x(:,k+1)=A*x(:,k)+B*u(k)+w(k,:)';
    y(k+1)=C*x(:,k)+v(k);
    
    %predict
    xHat(:,k+1)=A*xHat(:,k)+B*u(k);
    P=A*P*A'+Q;
    
    %correct
    Kk=P*C'*inv(C*P*C'+R);
    xHat(:,k+1)=xHat(:,k+1)+Kk*(y(k+1)-C*xHat(:,k+1));
    P=P-Kk*C*P;
end

figure(1)
plot(t,x(1,:),'r',t,x(2,:),'b',t,x(3,:),'g',t,y','m',t,xHat(1,:),'r--',t,xHat(2,:),'b--',t,xHat(3,:),'g--')
legend('x1','x2','x3','y','x1^','x2^','x3^');
xlabel('time'); ylabel('State and estimation values')
grid on

figure
plot(t,u)
xlabel('time'); ylabel('u')

figure
plot(t,x-xHat)
xlabel('time')
legend('x1 error','x2 error','x3 error');
ylabel('x estimate error')

mseMeasurement = sum((x(2,:)-y').^2)
mseEstimate = sum((x(2,:)-xHat(2,:)).^2)

end