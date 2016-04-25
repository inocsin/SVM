function ratio=predPrecision(X,Y,model)
pred=svmPredict(model,X);
total=length(Y);
equal=(pred==Y);
rightpredict=sum(equal);
ratio=rightpredict/total;