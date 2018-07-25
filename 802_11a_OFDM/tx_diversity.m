function div_ofdm_syms = tx_diversity(ofdm_symbols, sim_options)

if sim_options.UseTxDiv
   % Radon-Hurwitz or Alamouti tx diversity
   div_ofdm_syms = tx_radon_hurwitz(ofdm_symbols);
else
   % No diversity
   div_ofdm_syms = ofdm_symbols;
end

