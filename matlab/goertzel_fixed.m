function [y, state] = goertzel_fixed(x, k, NT)

    NTC = numerictype;
    NTC.Signedness = 'Signed';
    NTC.WordLength = 33;
    NTC.FractionLength = 30;
    
    N = length(x);

    A = 2*pi*(k/N);
    B = 2*cos(A);
    C = exp(-1i*A);
    
    B = fi(B,NTC);
    C = fi(C,NTC);

    state = complex(fi(zeros(N,1),NT));
    state_prev = complex(fi(0,NT));
    state_prev2 = complex(fi(0,NT));

    for m = 1:N
      state(m) = x(m) + B*state_prev - state_prev2;
      state_prev2 = state_prev;
      state_prev = state(m);
    end
    
    output = B*state_prev - state_prev2 - C*state_prev;
    y = abs(output);
    
end