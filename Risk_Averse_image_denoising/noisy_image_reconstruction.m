function reconstructed_image_n=noisy_image_reconstruction(data,dim)

data_cell=num2cell(data,1);


s=sqrt(size(data,2));

answer=reshape(data_cell,s,s); 

answer = cellfun(@transpose,answer,'UniformOutput',false);

for i=1:size(answer,1)
    for j=1:size(answer,1)
      AA{i,j}=reshape(answer{i,j},sqrt(dim),sqrt(dim)); 
    end
end

reconstructed_image_n=cell2mat(AA'); 

end





