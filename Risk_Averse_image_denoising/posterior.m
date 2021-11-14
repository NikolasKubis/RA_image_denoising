
function post=posterior(k,mean,cov,weight,data_point)

gm = gmdistribution(mean',cov,weight);

mixture=pdf(gm,data_point');

% if mixture==0
%     arithmitis=(mvnpdf(data_point,mean(:,k),cov(:,:,k))*weight(k));
%     pause;
% end

post=(mvnpdf(data_point,mean(:,k),cov(:,:,k))*weight(k))/(mixture);

end

%to create a GMM pdf in matlab you have first to create an object 
%gm = gmdistribution(mu,sigma) and then take the values from y = pdf(gm,X).

% to plot
% gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm,[x0 y0]),x,y);
% fsurf(gmPDF,[-10 10])