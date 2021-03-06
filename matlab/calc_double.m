%%
tic
output_fft_double = fft_double(data_double);
output_fft_double = output_fft_double(1:N/2);
toc
filename = sprintf('../../output/output_fft_double_%d',N);
save(filename,'output_fft_double');

%%
tic
output_sdft_double = zeros(N/2,1);
parfor m = 1:N/2
    output_sdft_double(m) = sdft_double(data_double, m-1);
end
toc
filename = sprintf('../../output/output_sdft_double_%d',N);
save(filename,'output_sdft_double');
% %%
% tic
% output_sdft2_double = zeros(N/2,1);
% parfor m = 1:N/2
%     output_sdft2_double(m) = sdft2_double(data_double, m-1);
% end
% toc
% filename = sprintf('../../output/output_sdft2_double_%d',N);
% save(filename,'output_sdft2_double');
%%
tic
output_goertzel_double = zeros(N/2,1);
parfor m = 1:N/2
    output_goertzel_double(m) = goertzel_double(data_double, m-1);
end
toc
filename = sprintf('../../output/output_goertzel_double_%d',N);
save(filename,'output_goertzel_double');
