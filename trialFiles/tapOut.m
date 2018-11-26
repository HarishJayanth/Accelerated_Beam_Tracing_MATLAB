function y = tapOut(delay, samp, wrPtr, ynm1)

n = floor(samp);
del = n - samp;

n = wrPtr - n;
n_lt_1 = find(n<1);
n(n_lt_1) = n(n_lt_1) + length(delay);

nm1 = n - 1;
nm1_et_0 = find(nm1 == 0);
nm1(nm1_et_0) = ones(size(nm1(nm1_et_0)))*length(delay);


% n = ceil(samp);
% del = n - samp;
% if del < 0.3 && n > 2 
%     n = n - 1;
% end
for i = 1:length(del)
   if del(i) < 0.3 && n(i) > 2
       n(i) = n(i) - 1;
       del(i) = del(i) + 1;
   end
end

a = (1-del)./(1+del);


y = a.*(delay(n) - ynm1) + delay(nm1);

end