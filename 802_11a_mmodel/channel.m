

function rx_signal = channel(tx_signal, cir, sim_options);

global sim_consts;

[n_tx_antennas, n_rx_antennas] = get_n_antennas(sim_options);

% Channel effect
rx_signal = zeros(n_rx_antennas, size(tx_signal,2)+size(cir,2)-1);
for rx_ant = 1:n_rx_antennas   
   for tx_ant = 1:n_tx_antennas
      rx_signal(rx_ant,:) = rx_signal(rx_ant,:) + ...
         conv(tx_signal(tx_ant,:), cir((rx_ant-1)*n_tx_antennas+tx_ant,:));
   end
end

len = size(rx_signal, 2);

% Add noise
% calculate noise variance
% 64/52 scale factor normalizes the noise with the used subcarrier number
noise_var = 64/52/(10^(sim_options.SNR/10))/2;

noise = sqrt(noise_var) * (randn(n_rx_antennas, len) + j*randn(n_rx_antennas, len));

extra_noise = sqrt(noise_var) * (randn(n_rx_antennas,sim_consts.ExtraNoiseSamples) + ...
   j*randn(n_rx_antennas, sim_consts.ExtraNoiseSamples));

% end noise is added to prevent simulation from crashing from incorrect timing in receiver
end_noise = sqrt(noise_var) * (randn(n_rx_antennas,170) + j*randn(n_rx_antennas, 170));

% add noise
rx_signal = rx_signal+noise;

% extra noise samples are inserted before the packet to test the packet search algorithm
rx_signal = [extra_noise rx_signal end_noise];

%Create frequency offset
rx_signal = create_freq_offset(rx_signal, sim_options.FreqError);

