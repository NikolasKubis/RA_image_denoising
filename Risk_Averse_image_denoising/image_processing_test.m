close all;
clear all;
A=zeros(512,512);


k=1;

for i=160:238
    A(:,i)=ones(512,1);
    k=k+1;
end
figure(1)
imshow(A)

sigma_noise=0.001;
noisy_image=A+sqrt(sigma_noise)*randn(512,512);

figure(2)
imshow(noisy_image)

%The next step is to split the image into patches of dimension p. 
%To this end we create the function splitter which inputs the noisy image and
%outputs the various patches. The function asks for the most appropriate
%vector dimension by performing a Greatest Common Divisor step.
[patches,lamda_1,lamda_2,p]=splitter(noisy_image);
%Further, we vectorize the image patches and place them into a
%pX(lamda_1*lamda_2) matrix. Each column is a vectorized patch.

noisy_vectors=zeros(p^2,lamda_1*lamda_2);
for k=1:(lamda_1*lamda_2)
    noisy_vectors(:,k)=reshape(patches(:,:,k),[p*p,1]); %k+1 stili kato apo tin k stili.
end

%The next task is to fit the Gaussian Mixture Model (GMM) into the available patches.
%In order to do so, we employ the Expectation Maxmization (EM) algorithm.

%Normally the function should take as input only the available data, the
%number of mixands and the 

data=noisy_vectors;

number_of_mixands=2;

iterations=10;

[mu_guess,sigma_guess,weights]=EM_2(data,number_of_mixands,iterations);


%From here you can use the ouput of EM_2.....
% Save mu_guess,sigma_guess,weights.

%%
% save('numberofmixands40iterations15epsilon10-4','mu_guess','sigma_guess','weights');
% load('numberofmixands40iterations15epsilon10-4')
dim=p;
%converting to cells
mu_guess_cell=num2cell(mu_guess,1);

sigma_guess_cell=reshape(squeeze(num2cell(sigma_guess,[1 2])),[1 number_of_mixands]);

sigma_guess_cell_plus_noise=(cellfun(@(x)x+(sigma_noise^2)*eye(dim^2),sigma_guess_cell,'un',0));

%applying the filter

filtered_mmse_vector_matrix=zeros(size(data));

filtered_risk_mmse_vector_matrix=zeros(size(data));

risk_parameter=0;

for i=1:size(data,2)
    
    post_weights=posterior_weights(weights,mu_guess_cell,sigma_guess_cell_plus_noise,data(:,i));

    filtered_mmse_vector_matrix(:,i)=filtered_mmse_vectors(data(:,i),mu_guess_cell,sigma_guess_cell,post_weights,sigma_noise,dim);
    
    filtered_risk_mmse_vector_matrix(:,i)=filtered_risk_mmse_vectors(data(:,i),mu_guess_cell,sigma_guess_cell,post_weights,sigma_noise,dim,risk_parameter);
end

figure(4)
imshow(risk_mmse_reconstrction(filtered_risk_mmse_vector_matrix,dim));

figure(5)
imshow(mmse_reconstrction(filtered_mmse_vector_matrix,dim))




