% Channel amplitudes corresponding to bits for Viterbi decoding

function channel_amps = rx_gen_chan_amps(data_len, channel_est, sim_options)

global sim_consts;

bits_per_subc = get_bits_per_symbol(sim_options.Modulation);
amps_mat = repmat(sum(abs(channel_est(sim_consts.DataSubcPatt, :)).^2, 2), bits_per_subc, 1);
amps_mat = amps_mat(:)';
amps_mat = repmat(amps_mat, 1, ceil(data_len/length(amps_mat)));
channel_amps = amps_mat(1:data_len);


