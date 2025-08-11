function y = drr(x)
    a=max(abs(x)).^2;
    b=sum(x.^2);
    c=a/b;
    y=10*log10(c);
end