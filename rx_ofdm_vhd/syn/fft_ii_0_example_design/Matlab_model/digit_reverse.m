function y = digit_reverse(x, n_bits)
    if mod(n_bits,2)
        z = dec2bin(x, n_bits);
        for i=1:2:n_bits-1
            p(:,i) = z(:,n_bits-i);
            p(:,i+1) = z(:,n_bits-i+1);
        end
            p(:,n_bits) = z(:,1);
            y=bin2dec(p);
        else
            y=digitrevorder(x,4);
    end
end