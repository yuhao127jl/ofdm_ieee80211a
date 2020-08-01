

function time_syms = tx_freqd_to_timed(mod_ofdm_syms) 

global sim_consts;

num_symbols = size(mod_ofdm_syms, 2)/sim_consts.NumSubc;
n_antennas = size(mod_ofdm_syms, 1);

resample_patt=[33:64 1:32];
time_syms = zeros(n_antennas, num_symbols*64);

% Convert each antenna's signal to time domain
for antenna = 1:n_antennas
   syms_into_ifft = zeros(64, num_symbols);
   syms_into_ifft(sim_consts.UsedSubcIdx,:) = reshape(mod_ofdm_syms(antenna,:), ...
      sim_consts.NumSubc, num_symbols);
   
   syms_into_ifft(resample_patt,:) = syms_into_ifft;
   
   % Convert to time domain
   ifft_out = ifft(syms_into_ifft);
   time_syms(antenna,:) = ifft_out(:).';
end
