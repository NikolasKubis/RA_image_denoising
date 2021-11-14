function [patches,lamda_1,lamda_2,p]=splitter(image)
m=size(image,1);
n=size(image,2);
%The function calculates the possible vector dimension by extracting the
% Greatest Common Divisor of m and n, GCD(m,n).
%Then it performs a prime factorization of the latter and provides all the
%possible vector dimension. This can be done with factor(x).
g=gcd(m,n);
disp('The possible vector dimensions are')
disp('')
disp(factor(g))
p=input('Please enter a value');

%the function asks for the vector dimension that is preferable.
%

lamda_1=n/p; lamda_2=m/p;

patches=zeros(p,p,lamda_1*lamda_2);

k=1;
for i=1:lamda_1
    
    for j=1:lamda_2
        
        patches(:,:,k)=image((i-1)*p+1:i*p,(j-1)*p+1:j*p);
        k=k+1;
        
    end
    
end

end