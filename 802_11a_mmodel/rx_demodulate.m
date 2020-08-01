

function [soft_bits_out]  = rx_demodulate(rx_symbols, sim_options)


% We make 'soft' bit estimation for viterbi.
if ~isempty(findstr(sim_options.Modulation, 'BPSK'))
	soft_bits = rx_bpsk_demod(rx_symbols);
elseif ~isempty(findstr(sim_options.Modulation, 'QPSK'))
   soft_bits = rx_qpsk_demod(rx_symbols);
elseif ~isempty(findstr(sim_options.Modulation, '16QAM'))	
   soft_bits = rx_qam16_demod(rx_symbols);
elseif ~isempty(findstr(sim_options.Modulation, '64QAM'))
   soft_bits = rx_qam64_demod(rx_symbols);
else
   error('Undefined modulation');
end

soft_bits_out = soft_bits(:)';

