function [redRatio,greenRatio,rR,rG,rB,gR,gG,gB]=calRatio(RGB)

% cd forest
% RGB=imread('4.jpg');
% cd ..

% %HSV=HSV*255;%原先范围为0-1
[row col pixel]=size(RGB);
HSV=rgb2hsv(RGB);
% greenPic=zeros(size(RGB));
% redPic=zeros(size(RGB));
redCount=0;%代表red,yellow,orange
greenCount=0;%代表green,cyan
%分别计算被分割出来的红色区域的RGB均值和绿色区域的RGB均值
rR=0;
rG=0;
rB=0;
gR=0;
gG=0;
gB=0;
total=row*col;
for i=1:row
    for j=1:col
        if(HSV(i,j,2)>=110/255)% saturation default 43/255
            if(HSV(i,j,3)>=100/255)% value default 46/255
                if(HSV(i,j,1)<=34/180 || HSV(i,j,1)>=156/180)
                    redCount=redCount+1;
                    rR=rR+double(RGB(i,j,1));
                    rG=rG+double(RGB(i,j,2));
                    rB=rB+double(RGB(i,j,3));
%                     redPic(i,j,:)=RGB(i,j,:);
                elseif(HSV(i,j,1)>=35/180 && HSV(i,j,1)<=99/180)
                    greenCount=greenCount+1;
                    gR=gR+double(RGB(i,j,1));
                    gG=gG+double(RGB(i,j,2));
                    gB=gB+double(RGB(i,j,3));
%                     greenPic(i,j,:)=RGB(i,j,:);
                end
            end
            
        end
    end
end

redRatio=redCount/(total+1);%To avoid divided by zero
greenRatio=greenCount/(total+1);
rR=rR/(redCount+1);
rG=rG/(redCount+1);
rB=rB/(redCount+1);
gR=gR/(greenCount+1);
gG=gG/(greenCount+1);
gB=gB/(greenCount+1);
% Show image
% figure(1)
% subplot(1,3,1);
% imshow(RGB);
% title('Original');
% subplot(1,3,2);
% redPic=uint8(redPic);
% imshow(redPic);
% title('Red');
% subplot(1,3,3);
% greenPic=uint8(greenPic);
% imshow(greenPic);
% title('Green');