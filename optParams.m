function [C, sigma] = optParams(X,Y,kernel)
%optParams returns your choice of C and sigma
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel or linear kernel

C = 0.01;
sigma = 0.01;

[m,n]=size(X);
ratio=0.7;
idx=floor(m*ratio);
myrand=randperm(m);
Xtmp=X(myrand,:);
Ytmp=Y(myrand,:);
Xtrain=Xtmp(1:idx,:);
Ytrain=Ytmp(1:idx,:);
Xtest=Xtmp(idx+1:m,:);
Ytest=Ytmp(idx+1:m,:);

% model = svmTrain(X, Y, C, @linearKernel, 1e-3, 20);

Cvec=[0.01;0.02;0.03;0.05;0.07;0.1;0.3;0.5;0.7;1;3;10;20;30;50;80;100];
sigmavec=[0.01;0.02;0.03;0.05;0.07;0.1;0.3;0.5;0.7;1;3;10;20;30;50;80;100];

% model=svmTrain(X, y, Cvec(1), @(x1,x2) gaussianKernel(x1, x2, sigma));
% predictions=svmPredict(model,Xval);
% costmin=mean(double(predictions~=yval));
% for i=1:size(Cvec)
%     for j=1:size(sigmavec)
%         model=svmTrain(X, y, Cvec(i), @(x1,x2) gaussianKernel(x1, x2, sigmavec(j)));
%         predictions=svmPredict(model,Xval);
%         costtmp=mean(double(predictions~=yval));
%         if costtmp<costmin
%             C=Cvec(i);
%             sigma=sigmavec(j);
%             costmin=costtmp;
%         end
%     end
% end

if strcmp(kernel,'linearKernel')
    fprintf('Using linear kernel to optimize\n');
    Accuracy=zeros(size(Cvec,1),2);
    C = 0.01;
	model = svmTrain(Xtrain, Ytrain, C, @linearKernel, 1e-3, 20);
	maxPrec=predPrecision(Xtest,Ytest,model);
    for i=1:size(Cvec)
        model = svmTrain(Xtrain, Ytrain, Cvec(i), @linearKernel, 1e-3, 20);
        Accuracy(i,1)=predPrecision(Xtrain,Ytrain,model);
        Accuracy(i,2)=predPrecision(Xtest,Ytest,model);
        if Accuracy(i,2)>maxPrec
            C=Cvec(i);
            maxPrec=Accuracy(i,2);
        end
    end
    figure(7)
    plot(Cvec,Accuracy(:,1),'b-');
    hold on
    plot(Cvec,Accuracy(:,2),'g-');
    xlabel('C');
    ylabel('accuracy');
    legend('Training','Testing');
    hold off
    
elseif strcmp(kernel,'gaussianKernel')
    fprintf('Using gaussian kernel to optimize\n');
    Accuracy=zeros(size(Cvec,1),size(sigmavec,1),2);
    C = 0.01;
    sigma = 0.01;
    model=svmTrain(Xtrain, Ytrain, C, @(x1,x2) gaussianKernel(x1, x2, sigma));
    maxPrec=predPrecision(Xtest,Ytest,model);
    for i=1:size(Cvec)
        for j=1:size(sigmavec)
            model=svmTrain(Xtrain, Ytrain, Cvec(i), @(x1,x2) gaussianKernel(x1, x2, sigmavec(j)));
            Accuracy(i,j,1)=predPrecision(Xtrain,Ytrain,model);
            Accuracy(i,j,2)=predPrecision(Xtest,Ytest,model);
            if Accuracy(i,j,2)>maxPrec
                C=Cvec(i);
                sigma=sigmavec(j);
                maxPrec=Accuracy(i,j,2);
            end
        end
    end
    [xx,yy]=meshgrid(Cvec,sigmavec);
    figure(8)
    surf(xx,yy,Accuracy(:,:,1));
    xlabel('C');
    ylabel('sigma');
    zlabel('accuracy');
    title('Training accuracy');
    rotate3d;
    figure(9)
    surf(xx,yy,Accuracy(:,:,2));
    xlabel('C');
    ylabel('sigma');
    zlabel('accuracy');
    title('Testing accuracy');
    rotate3d;
    
end




% =========================================================================

end
