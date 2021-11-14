function [post_weights]=posterior_weights(weights,mu_guess_cell,sigma_guess_cell_plus_noise,y)

normal_y=@(mu,sigma)mvnpdf(y,mu,sigma); %plagkaro to observable 
% kai exo mia sinartisi ton mu kai sigma....to y exei parei timi.


normal3x=cellfun(normal_y,mu_guess_cell,sigma_guess_cell_plus_noise);

den=sum(weights'.*cellfun(normal_y,mu_guess_cell,sigma_guess_cell_plus_noise));

post_weights=weights'.*(normal3x/(den));


%tsekare me ena example an to cell tou array of matrices vgainei sosto...
% an vgainei ayto sosto, ola einai sosta.
end