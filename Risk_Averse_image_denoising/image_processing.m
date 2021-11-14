close all;
clear all;

%colored_lenna = imread('Lenna.png');
colored_lenna = imread('Trial_3_EVG.tif');

gray_lenna = rgb2gray(colored_lenna);

lenna_double=im2double(gray_lenna);

lenna_double=lenna_double(1:1024,1:1024);

[patches,lamda_1,lamda_2,dim]=splitter(lenna_double);

sigma_noise=0.001;

noisy_patches=zeros(dim,dim,lamda_1*lamda_2);

%add noise to every patch.
for k=1:lamda_1*lamda_2
noisy_patches(:,:,k)=patches(:,:,k)+sqrt(sigma_noise)*randn(dim,dim);
end


noisy_vectors=zeros(dim^2,lamda_1*lamda_2);

for k=1:(lamda_1*lamda_2)
    noisy_vectors(:,k)=reshape(noisy_patches(:,:,k),[dim^2,1]);
end

data=noisy_vectors;

reconstructed_noisy_image=noisy_image_reconstruction(data,dim^2);


%%
number_of_mixands=4;

iterations=10;

tic

[mu_guess,sigma_guess,weights]=EM_2(data,number_of_mixands,iterations);
   % The program section to time. 
toc

%From here you can use the ouput of EM_2.....
% Save mu_guess,sigma_guess,weights.

%%
%
%save('numberofmixands5iterations10noise0','mu_guess','sigma_guess','weights');
%load('numberofmixands40iterations15epsilon10-4')

%converting to cells
mu_guess_cell=num2cell(mu_guess,1);

sigma_guess_cell=reshape(squeeze(num2cell(sigma_guess,[1 2])),[1 number_of_mixands]);

sigma_guess_cell_plus_noise=(cellfun(@(x)x+sigma_noise^2*eye(dim^2),sigma_guess_cell,'un',0));

%applying the filter

filtered_mmse_vector_matrix=zeros(size(data));

filtered_risk_mmse_vector_matrix=zeros(size(data));

risk_parameter=0.00001;
%risk_parameter=0;


for i=1:size(data,2)
    
    [post_weights]=posterior_weights(weights,mu_guess_cell,sigma_guess_cell_plus_noise,data(:,i));
    
    filtered_mmse_vector_matrix(:,i)=filtered_mmse_vectors(data(:,i),mu_guess_cell,sigma_guess_cell,post_weights,sigma_noise,dim);
    
    filtered_risk_mmse_vector_matrix(:,i)=filtered_risk_mmse_vectors(data(:,i),mu_guess_cell,sigma_guess_cell,post_weights,sigma_noise,dim,risk_parameter);

    %the_difference(:,i)=filtered_mmse_vector_matrix(:,i)+0.1*filtered_risk_mmse_vector_matrix(:,i);
    
end

reconstructed_mmse_image=reconstrction(filtered_mmse_vector_matrix,dim);

reconstructed_risk_image=risk_mmse_reconstrction(filtered_risk_mmse_vector_matrix,dim);

%the_difference=reconstrction(the_difference,dim);

%%
figure(1)
subplot(1,2,1)
imshow(gray_lenna)
title('Original image')

subplot(1,2,2)
imshow((reconstructed_noisy_image))
title('Noisy image')

figure(2)
subplot(1,2,1)
imshow((reconstructed_mmse_image))
title('Filtered MMSE image')

subplot(1,2,2)
imshow((reconstructed_risk_image))
title('Filtered Risk MMSE image')

%figure(10)
%imshow(the_difference)
psnr_noisy=psnr(reconstructed_noisy_image,im2double(lenna_double))

psnr_mmse=psnr(reconstructed_mmse_image,im2double(lenna_double))

psnr_risk=psnr(reconstructed_risk_image,im2double(lenna_double))

%psnr_diff=psnr(the_difference,im2double(lenna_double))


ssim_mmse=ssim(reconstructed_mmse_image,im2double(lenna_double))

ssim_risk=ssim(reconstructed_risk_image,im2double(lenna_double))

%Vasika nai, oso ayxaneis to dimensionality tou patch, toso pio diakrita / distinct einai ta 
%patches metaxy tous, pou simainei oti dyskola na exoun erthei apo idio mixand. 
%Theleis loipon perissotera mixands gia na ta kaneis decode.