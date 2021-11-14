function [filtered_risk_mmse_vector]=filtered_risk_mmse_vectors(y,mu_guess_cell,sigma_guess_cell,post_weights,sigma_noise,dim,risk_parameter)

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



% the trace of each Sigma 

norm_squared_cond_mean=cellfun(@(x)norm(x)^2,cond_mean,'un',0);

% Finding the posterior covariance Lamda.

posterior_covariance_cell=cellfun(@(x)inv(inv(x)+(1/sigma_noise^2)*eye(dim^2)),sigma_guess_cell,'un',0);

%taking the trace
trace_cell=cellfun(@(x)trace((x)),posterior_covariance_cell,'un',0);

adding_trace_norm_cell=cellfun(@(x,y)(x+y),norm_squared_cond_mean,trace_cell,'un',0);

adding_cov_previous_cell=cellfun(@(x,y)(2*x+(y*eye(dim^2))),posterior_covariance_cell ,adding_trace_norm_cell ,'un',0);

term_01=cellfun(@(y,x)y*x,adding_cov_previous_cell,cond_mean,'un',0);

final_terms_2=cellfun(@(x,y)x*y,post_weights_cell,term_01,'un',0);

term_1=sum(cell2mat(final_terms_2),2);
%telos protou orou


%arxi deyterou orou arithmiti
term_2=cellfun(@(x,y)x*y,post_weights_cell,adding_trace_norm_cell,'un',0);
%telos deyterou orou arithmiti

%o arithmitis
num=filtered_mmse_vector+risk_parameter*(term_1-sum(cell2mat(term_2))*filtered_mmse_vector);
%telos arithmiti

% arxi paranomasti
term_product_con_mean=cellfun(@(y,x)y+x*x',posterior_covariance_cell,cond_mean,'un',0);

final_t=cellfun(@(x,y)x*y,post_weights_cell,term_product_con_mean,'un',0);

term_1_den= sum(cell2mat(final_t),2);

term_4=filtered_mmse_vector*filtered_mmse_vector';

den=eye(dim^2)+2*risk_parameter*((term_1_den)-(term_4));

filtered_risk_mmse_vector=den\num; 
end