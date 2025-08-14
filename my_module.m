function C_S=my_module(S,f,t)
cs=cos(2*pi*f*2.5*t);
C_S=zeros(size(S));
for i=1:length(S)
    C_S(i)=S(i)*cs(i); 
end
end

