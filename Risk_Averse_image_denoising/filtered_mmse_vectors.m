function [filtered_mmse_vector]=filtered_mmse_vectors(y,mu_guess_cell,sigma_guess_cell,post_weights,sigma_noise,dim)

%this function takes as input the ALL the noisy patches i.e. the noisy vectors
%also, the mu_guess vectors, the sigma guess matrices and the posterior
%weights. The function returns the mmse filtered noisy patches (all of
%them) as vectors. 

%Then another system inputs these filtered vectors and maps their images.

% Another function then takes these filtered patch images and glues them
% together to reproduce the original image. 

% ta inputs isos prepei na ginontai cells ap exo.....alla ayto meta....

yy=repmat(y,[1,size(mu_guess_cell,2)]);

yy_cell=num2cell(yy,1);

% mu_guess_cell=num2cell(mu_guess,1);

yy_minus_mean=cellfun(@(x,y)x-y,yy_cell,mu_guess_cell,'un',0);

% sigma_guess_cell=reshape(squeeze(num2cell(sigma_guess,[1 2])),[1 K]);

gain=cellfun(@(x)x/((sigma_noise^2*eye(dim^2))+x),sigma_guess_cell,'un',0);

correction=cellfun(@(x,y)x*y,gain,yy_minus_mean,'un',0);

cond_mean=cellfun(@(x,y)x+y,mu_guess_cell,correction,'un',0);

post_weights_cell=num2cell(post_weights,1);

final_terms=cellfun(@(x,y)x*y,post_weights_cell,cond_mean,'un',0);

filtered_mmse_vector= sum(cell2mat(final_terms),2);

end