
clear all;
close all;
clc;
% let us create three normal RV's
mu1=[0;0];
sigma_1=[1 0;0 1];
normal_1 = mvnrnd(mu1,sigma_1,1000)';
%
mu2=[4;3];
sigma_2=[0.1 0;0 0.2];
normal_2 = mvnrnd(mu2,sigma_2,200)';
%
mu3=[2;9];
sigma_3=[0.1 0;0 0.2];
normal_3 = mvnrnd(mu3,sigma_3,200)';


% First I am going to stack together the data to form the complete data set
data=[normal_1 normal_2 normal_3];   %||||||...||||









%given N =number of samples and K=number of mixands
N=size(data,2); %#cols

K=3;

matrix=zeros(N,K); % (#datapoints)x(#mixands) 
% assume\guess some known parameters for the mixands
mu_guess=zeros(2,K);  %|||||...||||


[~,C,sumd] = kmeans(data',3);
mu_guess=C';

sigma_guess=zeros(2,2,K);
sigma_guess(:,:,1)=1*eye(2);
sigma_guess(:,:,2)=0.1*eye(2);
sigma_guess(:,:,3)=0.2*eye(2);




weights=zeros(K,1); % |

weights(:,1)=1/K;


total_likelihood_prior=-1000;

total_likelihood=0;

ratio=1000;


% iter=0;
for iter=1:200
% while ratio>10^(-7)

    
    
%The E-step


for n=1:N
    for k=1:K
        post_belief(n,k)=posterior(k,mu_guess,sigma_guess,weights,data(:,n));
        % input the mixand and the sample.
    end
end



% the M-step


epsilon=0.01;
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
        sum(latend_matrix,3)/sum(post_belief(:,k))+epsilon*eye(2,2); 
    
       weights(k)=sum(post_belief(:,k))/size(data,2); %updated covariance
end



%calculate the total likelihood

likeli=@(m,c,w,d)log10(pdf(gmdistribution(m',c,w),d));

likelini=@(x)likeli(mu_guess,sigma_guess,weights,x');

v=num2cell(data,1);

c=cellfun(likelini,v);

total_likelihood=sum(c);

ratio=abs(total_likelihood-total_likelihood_prior)/abs(total_likelihood);

total_likelihood_prior=total_likelihood;

iter=iter+1;

end

disp(ratio);
disp(' ')
disp(abs(total_likelihood))

%plot

figure(1)
plot(data(1,:),data(2,:),'+');

figure(2)
plot(normal_1(1,:),normal_1(2,:),'o','color',[0.8500, 0.3250, 0.0980]);
hold on;
plot(normal_2(1,:),normal_2(2,:),'^','color',[0, 0.4470, 0.7410]);
hold on;
plot(normal_3(1,:),normal_3(2,:),'+','color',[0.9290, 0.6940, 0.1250]);


gm = gmdistribution(mu_guess',sigma_guess,weights);

figure(3)
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm,[x0 y0]),x,y);
fsurf(gmPDF,[-4 10])


% in order to color ta eniamera
[~,i]=max(post_belief,[],2); % return the position of the maximum for each row.
data_and_index=[data;i']; % first two rows are the data.






