%%
figure
plot(1:N,abs(state_sdft_double-double(state_sdft_fixed)))
plot_properties_error
legend('SDFT')
legend('Location','northwest')

%%
figure
plot(1:N,abs(state_goertzel_double-double(state_goertzel_fixed)))
plot_properties_error
legend('Goertzel')
legend('Location','northwest')