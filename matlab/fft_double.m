function y = fft_double(x)

    X = fft(x);
    y = abs(X);
    
end