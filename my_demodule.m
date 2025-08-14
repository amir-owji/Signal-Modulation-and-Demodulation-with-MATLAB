function Yd=my_demodule(Xc,f,t)
cs=cos(2*pi*f*t*2.5);
Yc=zeros(size(Xc));
for i=1:length(Xc)
    Yc(i)=Xc(i)*cs(i);
end
Yd=lowpass(Yc,0.5);
end