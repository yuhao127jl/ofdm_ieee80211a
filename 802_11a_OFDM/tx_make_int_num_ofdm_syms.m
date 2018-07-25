function out_bits = tx_make_int_num_ofdm_syms(tx_bits, sim_options)

global sim_consts;

n_tx_bits = length(tx_bits);

n_syms = sim_consts.NumDataSubc;
n_bits_per_sym = get_bits_per_symbol(sim_options.Modulation);
n_ofdm_syms = ceil(n_tx_bits/(n_syms*n_bits_per_sym));

% if Radon Hurwitz transform is used we need an even number of OFDM symbols
if sim_options.UseTxDiv
   if rem(n_ofdm_syms,2) ~= 0
      n_ofdm_syms = n_ofdm_syms + 1;
   end
end

pad_bits = randn(1, n_ofdm_syms*n_syms*n_bits_per_sym - n_tx_bits) > 0;
out_bits = [tx_bits  pad_bits];

