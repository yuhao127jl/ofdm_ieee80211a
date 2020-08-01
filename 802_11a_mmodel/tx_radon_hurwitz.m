function ofdm_syms_out = tx_radon_hurwitz(mod_ofdm_syms)

global sim_consts;

num_symbols = length(mod_ofdm_syms)/sim_consts.NumDataSubc;
mod_syms = reshape(mod_ofdm_syms, sim_consts.NumDataSubc, num_symbols);

ant1_syms = zeros(sim_consts.NumDataSubc, num_symbols);
ant2_syms = zeros(sim_consts.NumDataSubc, num_symbols);

% unchanged symbols
ant1_syms(:,1:2:num_symbols) = mod_syms(:,1:2:num_symbols);
ant2_syms(:,1:2:num_symbols) = mod_syms(:,2:2:num_symbols);

% transformed symbols
ant1_syms(:,2:2:num_symbols) = -conj(mod_syms(:,2:2:num_symbols));
ant2_syms(:,2:2:num_symbols) = conj(mod_syms(:,1:2:num_symbols));

ofdm_syms_out = zeros(2, length(mod_ofdm_syms));

ofdm_syms_out(1,:) = ant1_syms(:).';
ofdm_syms_out(2,:) = ant2_syms(:).';
