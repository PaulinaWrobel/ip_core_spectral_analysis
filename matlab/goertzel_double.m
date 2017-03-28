function [y, state] = goertzel_double(x, k)

    N = length(x);

    A = 2*pi*(k/N);
    B = 2*cos(A);
    C = exp(-1i*A);

    state = zeros(N,1);
    state_prev = 0;
    state_prev2 = 0;

    for m = 1:N
      state(m) = x(m) + B*state_prev - state_prev2;
      state_prev2 = state_prev;
      state_prev = state(m);
    end
    
    output = B*state_prev - state_prev2 - C*state_prev;
    y = abs(output);

end