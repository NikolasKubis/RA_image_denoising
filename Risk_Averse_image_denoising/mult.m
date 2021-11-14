function product=mult(row,col)
% this function takes as inputs two arrays and multiplies them to create a
% multidimensional array. It performs the component-wise cross products.
% It outputs an array of arrays that contains the results.

%first thing in the morning to check the sizes.

product=zeros(size(row,1),size(row,1),size(row,2));
if(size(row)==size(col'))
    %disp('everything set')
    for i=1:size(row,2)
       product(:,:,i)= row(:,i)*col(i,:);
    end
else
   disp('R U DUMB? YOU GAVE WRONG DIMENSIONS!')
  
end











end