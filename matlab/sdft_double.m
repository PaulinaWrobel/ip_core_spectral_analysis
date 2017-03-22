function [y, state] = sdft_double(x, k)

    N = length(x);

    A = 2*pi*(k/N);
    B = exp(1i*A);

    state = zeros(N,1);
    state_prev = 0;

    for m = 1:N
      state(m) = x(m) + B*state_prev;
      state_prev = state(m);
    end
    y = abs(state_prev);

%     dt = datestr(now,'yyyymmdd_HHMMSS');
%     filename = sprintf('output/%s_k_%d_%s',mfilename,k,dt);
%     save(filename,'state');

end