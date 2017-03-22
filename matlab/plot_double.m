frequency_vector = linspace(0,SF/2,N/2);

%%
figure
plot(frequency_vector,abs(output_fft_double))
plot_properties
legend('FFT')

%%
figure
plot(frequency_vector,abs(output_sdft_double))
plot_properties
legend('SDFT')

%%
figure
plot(frequency_vector,abs(output_goertzel_double))
plot_properties
legend('Goertzel')

%%
figure
plot(frequency_vector,abs(output_fft_double),frequency_vector,abs(output_sdft_double),frequency_vector,abs(output_goertzel_double))
plot_properties
legend('FFT','SDFT','Goertzel')