function time_signal = tx_add_cyclic_prefix(time_syms)

num_symbols = size(time_syms, 2)/64;
n_antennas = size(time_syms, 1);
time_signal = zeros(n_antennas, num_symbols*80);

% Add cyclic prefix for each antenna's signal
for antenna = 1:n_antennas
   symbols = reshape(time_syms(antenna,:), 64, num_symbols);
   tmp_syms = [symbols(49:64,:); symbols]; 
   time_signal(antenna,:) = tmp_syms(:).';
end


