function comb_syms = rx_mr_combiner(rx_syms, channel_est, sim_options)

n_ofdm_syms = size(squeeze(rx_syms(1,:,:)),2);

comb_syms = repmat(conj(channel_est(:,1)), 1, n_ofdm_syms).*squeeze(rx_syms(1,:,:)) + ...
   repmat(conj(channel_est(:,2)), 1, n_ofdm_syms).*squeeze(rx_syms(2,:,:));
