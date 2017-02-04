function f = sPiano( n )
% Genera frequenza pianoforte

f = zeros(1,length(n));
offset = 44;
for m = 1:length(n)
    f(m) = 2^(( ( m*2+offset) -49)/12)*440;
end

end

