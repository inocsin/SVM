function [avgaccuracy,avgoriginal]=crossValidation(X,Y,k,kernel,C,sigma)
% k represent k-fold corss validation.
% there are two choices of kernel, 'linearKernel' and 'gaussianKernel'
[m,n]=size(X);
% randomize the X and Y
myrand=randperm(m);
XX=X(myrand,:);
YY=Y(myrand,:);
idx=zeros(k,2);%store indexes range of each fold
interval=floor(m/k);
for i=1:k
    idx(i,1)=(i-1)*interval+1;
    idx(i,2)=i*interval;
end
idx(k,2)=m;
original=zeros(k,1);
accuracy=zeros(k,1);
if strcmp(kernel,'linearKernel')
    fprintf('Using linear kernel\n');
    for i=1:k
        if i==1
        	model = svmTrain(X(idx(i+1,1):m,:), Y(idx(i+1,1):m,:), C, @linearKernel, 1e-3, 20);
            original(i)=predPrecision(X(idx(i+1,1):m,:), Y(idx(i+1,1):m,:),model);
            accuracy(i)=predPrecision(X(idx(i,1):idx(i,2),:),Y(idx(i,1):idx(i,2),:),model);
        elseif i==k
            model = svmTrain(X(idx(1,1):idx(i,1)-1,:), Y(idx(1,1):idx(i,1)-1,:), C, @linearKernel, 1e-3, 20);
            original(i)=predPrecision(X(idx(1,1):idx(i,1)-1,:), Y(idx(1,1):idx(i,1)-1,:),model);
            accuracy(i)=predPrecision(X(idx(i,1):idx(i,2),:),Y(idx(i,1):idx(i,2),:),model);
        else
            model = svmTrain(X([idx(1,1):idx(i,1)-1 idx(i+1,1):m],:), Y([idx(1,1):idx(i,1)-1 idx(i+1,1):m],:), C, @linearKernel, 1e-3, 20);
            original(i)=predPrecision(X([idx(1,1):idx(i,1)-1 idx(i+1,1):m],:), Y([idx(1,1):idx(i,1)-1 idx(i+1,1):m],:),model);
            accuracy(i)=predPrecision(X(idx(i,1):idx(i,2),:),Y(idx(i,1):idx(i,2),:),model);
        end
    end
%     disp(X);
%     disp(Y);
%     disp(k);
elseif strcmp(kernel,'gaussianKernel')
    fprintf('Using gaussian kernel\n');
    for i=1:k
        if i==1
        	model = svmTrain(X(idx(i+1,1):m,:), Y(idx(i+1,1):m,:), C, @(x1, x2) gaussianKernel(x1, x2, sigma));
            original(i)=predPrecision(X(idx(i+1,1):m,:), Y(idx(i+1,1):m,:),model);
            accuracy(i)=predPrecision(X(idx(i,1):idx(i,2),:),Y(idx(i,1):idx(i,2),:),model);
        elseif i==k
            model = svmTrain(X(idx(1,1):idx(i,1)-1,:), Y(idx(1,1):idx(i,1)-1,:), C, @(x1, x2) gaussianKernel(x1, x2, sigma));
            original(i)=predPrecision(X(idx(1,1):idx(i,1)-1,:), Y(idx(1,1):idx(i,1)-1,:),model);
            accuracy(i)=predPrecision(X(idx(i,1):idx(i,2),:),Y(idx(i,1):idx(i,2),:),model);
        else
            model = svmTrain(X([idx(1,1):idx(i,1)-1 idx(i+1,1):m],:), Y([idx(1,1):idx(i,1)-1 idx(i+1,1):m],:), C, @(x1, x2) gaussianKernel(x1, x2, sigma));
            original(i)=predPrecision(X([idx(1,1):idx(i,1)-1 idx(i+1,1):m],:), Y([idx(1,1):idx(i,1)-1 idx(i+1,1):m],:),model);
            accuracy(i)=predPrecision(X(idx(i,1):idx(i,2),:),Y(idx(i,1):idx(i,2),:),model);
        end
    end
%     disp(X);
%     disp(Y);
%     disp(k);
%     disp(C);
%     disp(sigma);
end
avgoriginal=mean(original);
avgaccuracy=mean(accuracy);