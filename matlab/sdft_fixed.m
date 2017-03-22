function [y, state] = sdft_fixed(x, k, NT)
    
    NTC = numerictype;
    NTC.Signedness = 'Signed';
    NTC.WordLength = 32;
    NTC.FractionLength = 30;
    
    N = length(x);

    A = 2*pi*(k/N);
    B = exp(1i*A);

    B = fi(B,NTC);

    state = complex(fi(zeros(N,1),NT));
    state_prev = complex(fi(0,NT));

    for m = 1:N
      %s(1) = x(m) + D*s(2);
      %s(2) = s(1);
      state(m) =  x(m) + B*state_prev;
      state_prev = state(m);
    end
    y = abs(state_prev);

end