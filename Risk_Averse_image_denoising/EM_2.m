
function [mu_guess,sigma_guess,weights]=EM_2(data,K,iterations)

%given N =number of samples and K=number of mixands

N=size(data,2); %#cols

dim=size(data,1);


matrix=zeros(N,K); % (#datapoints)x(#mixands) 
% assume\guess some known parameters for the mixands

[~,C,sumd] = kmeans(data',K);

mu_guess=C';

%mu_guess=rand(dim,K);  %|||||...||||

sigma_guess=zeros(dim,dim,K);
for k=1:K
    sigma_guess(:,:,k)=diag(1*ones(1,dim));
end

weights=zeros(K,1); % |
weights(:,1)=1/K;

for iter=1:iterations %100
iter
    
    
%The E-step

post_belief=zeros(N,K);

for n=1:N
    for k=1:K
        post_belief(n,k)=posterior(k,mu_guess,sigma_guess,weights,data(:,n));
        % input the mixand and the sample.
    end
end



% the M-step


epsilon=1*10^(-5);
for k=1:K
      mu_guess(:,k)=sum(post_belief(:,k)'.*data,2)/sum(post_belief(:,k)); % | %updated mean
end


for k=1:K
    mu_guess_vector=repmat(mu_guess(:,k),1,size(data,2)); 
    
    latend_matrix=mult(data-mu_guess_vector,(data-mu_guess_vector)'); % this matrix contains all 
                                                                      %the matrices (x-m)'(x-m)
    
    for l=1:length(post_belief(:,k)')
       latend_matrix(:,:,l)= post_belief(l,k)*latend_matrix(:,:,l);
    end
    
    sigma_guess(:,:,k)=...
        ...
        sum(latend_matrix,3)/sum(post_belief(:,k))+epsilon*eye(dim,dim); 
    
       weights(k)=sum(post_belief(:,k))/size(data,2); %updated covariance
end


weights

end




end