%%
[y_sdft_double, state_sdft_double] = sdft_double(data_double, k);
filename = sprintf('../../output/state_sdft_double_N%d_k%d',N,k);
save(filename,'state_sdft_double');
%%
[y_sdft2_double, state_sdft2_double] = sdft2_double(data_double, k);
filename = sprintf('../../output/state_sdft2_double_N%d_k%d',N,k);
save(filename,'state_sdft2_double');
%%
[y_sdft3_double, state_sdft3_double] = sdft3_double(data_double, k);
filename = sprintf('../../output/state_sdft3_double_N%d_k%d',N,k);
save(filename,'state_sdft3_double');

% %%
% [y_sdftl_fixed, state_sdft_fixed] = sdft_fixed(data_fixed, k, NT);
% filename = sprintf('output/state_sdft_fixed_%d_%d',N,k);
% save(filename,'state_sdft_fixed');

%%
[y_goertzel_double, state_goertzel_double] = goertzel_double(data_double, k);
filename = sprintf('../../output/state_goertzel_double_%d_%d',N,k);
save(filename,'state_goertzel_double');

% %%
% [y_goertzel_fixed, state_goertzel_fixed] = goertzel_fixed(data_fixed, k, NT);
% filename = sprintf('output/state_goertzel_fixed_%d_%d',N,k);
% save(filename,'state_goertzel_fixed');