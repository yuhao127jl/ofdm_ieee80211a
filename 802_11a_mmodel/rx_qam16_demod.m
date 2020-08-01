% 
function soft_bits = rx_qam16_demod(rx_symbols)

soft_bits = zeros(4*size(rx_symbols,1), size(rx_symbols,2));  % Each symbol consists of 4 bits

bit0 = real(rx_symbols);
bit2 = imag(rx_symbols);

bit1 = 2/sqrt(10)-(abs(real(rx_symbols)));
bit3 = 2/sqrt(10)-(abs(imag(rx_symbols)));

soft_bits(1:4:size(soft_bits,1),:) = bit0;
soft_bits(2:4:size(soft_bits,1),:) = bit1;
soft_bits(3:4:size(soft_bits,1),:) = bit2;
soft_bits(4:4:size(soft_bits,1),:) = bit3;

