function reconstructed_image_r=risk_mmse_reconstrction(filtered_risk_mmse_vector_matrix,dim)

filtered_risk_mmse_vector_matrix_cell=num2cell(filtered_risk_mmse_vector_matrix,1);

s=sqrt(size(filtered_risk_mmse_vector_matrix_cell,2));

answer=reshape(filtered_risk_mmse_vector_matrix_cell,s,s); 

answer = cellfun(@transpose,answer,'UniformOutput',false);

for i=1:size(answer,1)
    for j=1:size(answer,1)
      AA{i,j}=reshape(answer{i,j},dim,dim); 
    end
end

reconstructed_image_r=cell2mat(AA'); 

end





