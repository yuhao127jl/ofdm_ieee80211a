

function soft_bits = rx_qpsk_demod(rx_symbols)

soft_bits = zeros(2*size(rx_symbols,1),size(rx_symbols,2));

bit0 = real(rx_symbols); 
bit1 = imag(rx_symbols);

soft_bits(1:2:size(soft_bits, 1),:) = bit0;
soft_bits(2:2:size(soft_bits, 1),:) = bit1;

