function [X,Y]=processImg()
%% 处理火灾照片
% clear;clc;
listing = dir('d:\Coding\Matlab\SVM\onfire\*.jpg');
Dir1='d:\Coding\Matlab\SVM\onfire\';
[onfireNum tmp]=size(listing);
% onfireNum=4;
% X1=zeros(onfireNum,11);
X1=zeros(onfireNum,15);%1 redRatio,2 greenRatio,3 rR,4 rG,5 rB,6 gR,7 gG,8 gB,9 fireratio,10 graymean,11 graystd,12 energy,13 entropy,14 contrast,15 covariance
Y1=ones(onfireNum,1);
fprintf('\nProcessing images\n');
dots=0;

T=zeros(8,1);

for i = 1:onfireNum
    imgName = listing(i).name;
    imgData = imread([Dir1 imgName]);
    [X1(i,1),X1(i,2),X1(i,3),X1(i,4),X1(i,5),X1(i,6),X1(i,7),X1(i,8)]=calRatio(imgData);
	gray=rgb2gray(imgData);
    X1(i,9)=partition(gray);
    X1(i,10)=mean2(gray);
    X1(i,11)=std2(gray);

    T=Texture(gray);
    X1(i,12:15)=[T(1),T(3),T(5),T(7)];

% pause
    fprintf('.');
    dots = dots + 1;
    if dots > 78
        dots = 0;
        fprintf('\n');
    end
end

%% 处理森林照片
listing = dir('d:\Coding\Matlab\SVM\forest\*.jpg');
Dir2='d:\Coding\Matlab\SVM\forest\';
[forestNum tmp]=size(listing);
% forestNum=4;
% X2=zeros(forestNum,11);
X2=zeros(forestNum,15);
Y2=zeros(forestNum,1);
for i = 1:forestNum
    imgName = listing(i).name;
    imgData = imread([Dir2 imgName]);
    [X2(i,1),X2(i,2),X2(i,3),X2(i,4),X2(i,5),X2(i,6),X2(i,7),X2(i,8)]=calRatio(imgData);
	gray=rgb2gray(imgData);
    X2(i,9)=partition(gray);
    X2(i,10)=mean2(gray);
    X2(i,11)=std2(gray);

    T=Texture(gray);
    X2(i,12:15)=[T(1),T(3),T(5),T(7)];
% pause
    fprintf('.');
    dots = dots + 1;
    if dots > 78
        dots = 0;
        fprintf('\n');
    end
end
fprintf('\n');
%对由X1和X2合成的Xtmp中的数据进行随机打乱
myrand=randperm(onfireNum+forestNum);
Xtmp=[X1;X2];
Ytmp=[Y1;Y2];
X=Xtmp(myrand,:);
Y=Ytmp(myrand,:);
%% 绘制散点图
figure(1)
scatter(X1(:,1),X1(:,2),'r*');
hold on
scatter(X2(:,1),X2(:,2),'go');
xlabel('red ratio');
ylabel('green ratio');
figure(2)
scatter3(X1(:,3),X1(:,4),X1(:,5),'r*');
hold on
scatter3(X2(:,3),X2(:,4),X2(:,5),'go');
rotate3d;
xlabel('rR');
ylabel('rG');
zlabel('rB');
figure(3)
scatter3(X1(:,6),X1(:,7),X1(:,8),'r*');
hold on
scatter3(X2(:,6),X2(:,7),X2(:,8),'go');
rotate3d;
xlabel('gR');
ylabel('gG');
zlabel('gB');
figure(4)
scatter3(X1(:,9),X1(:,10),X1(:,11),'r*');
hold on
scatter3(X2(:,9),X2(:,10),X2(:,11),'go');
rotate3d;
xlabel('fire ratio');
ylabel('gray mean');
zlabel('gray std');
figure(5)
scatter(X1(:,12),X1(:,13),'r*');
hold on
scatter(X2(:,12),X2(:,13),'go');
xlabel('energy');
ylabel('entropy');
figure(6)
scatter(X1(:,14),X1(:,15),'r*');
hold on
scatter(X2(:,14),X2(:,15),'go');
xlabel('contrast');
ylabel('covariance');

%% save data
save svmdata X Y X1 X2 Y1 Y2


