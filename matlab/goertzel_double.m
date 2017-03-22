function [y, state] = goertzel_double(x, k)

    N = length(x);

    A = 2*pi*(k/N);
    B = 2*cos(A);
    C = exp(-1i*A);

    state = zeros(N,1);
    state_prev = 0;
    state_prev2 = 0;
    output = zeros(N,1);
    
%     s(1) = 0;
%     s(2) = 0;
%     s(3) = 0;

    for m = 1:N
      state(m) = x(m) + B*state_prev - state_prev2;
      state_prev2 = state_prev;
      state_prev = state(m);
      output(m) = B*state_prev - state_prev2 - C*state_prev;
        
%       s(1) = x(m) + B*s(2) - s(3);
%       s(3) = s(2);
%       s(2) = s(1);
    end
    y = abs(output(N));
%     s(1) = B*s(2) - s(3);
%     y = s(1) - s(2)*C;

    
%     dt = datestr(now,'yyyymmdd_HHMMSS');
%     filename = sprintf('output/%s_k_%d_%s',mfilename,k,dt);
%     save(filename,'output');
end