function [fireratio,segment]=partition(gray)
fireratio=0;

% subplot(2,2,1)
% gray=rgb2gray(rgb);
% imshow(rgb);
% gray=histeq(gray);
% subplot(2,2,2)
% imshow(gray);
% subplot(2,2,3)
% imhist(gray);

[m,n]=size(gray);
segment=zeros(m,n);
threshold=200;
for i=1:m
    for j=1:n
        if(gray(i,j)>threshold)
            segment(i,j)=gray(i,j);
            fireratio=fireratio+1;
        end
    end
end
segment=uint8(segment);
% subplot(2,2,4)
% imshow(segment);
fireratio=fireratio/(m*n);
            