function fun = maxval(x)
mid = ceil(size(x,1)/2);
maxi = max(x);
if(x(mid) == maxi)
    fun = max(x);
else
    fun = 0;
end
end
