

function soft_bits = rx_qam64_demod(rx_symbols)

soft_bits = zeros(6*size(rx_symbols,1), size(rx_symbols,2));  % Each symbol consists of 6 bits
bit0 = real(rx_symbols);
bit3 = imag(rx_symbols);

bit1 = 4/sqrt(42)-abs(real(rx_symbols));
bit4 = 4/sqrt(42)-abs(imag(rx_symbols));


for m=1:size(rx_symbols,2)
   for k=1:size(rx_symbols,1)
      if abs(4/sqrt(42)-abs(real(rx_symbols(k,m)))) <= 2/sqrt(42)  % bit is one
         bit2(k,m) = 2/sqrt(42) - abs(4/sqrt(42)-abs(real(rx_symbols(k,m))));
      elseif abs(real(rx_symbols(k,m))) <= 2/sqrt(42) % bit is zero, close to real axis
         bit2(k,m) = -2/sqrt(42) + abs(real(rx_symbols(k,m)));
      else
         bit2(k,m) = 6/sqrt(42)-abs(real(rx_symbols(k,m))); % bit is zero 
      end;
      
      if abs(4/sqrt(42)-abs(imag(rx_symbols(k,m)))) <= 2/sqrt(42)  % bit is one
         bit5(k,m) = 2/sqrt(42) - abs(4/sqrt(42)-abs(imag(rx_symbols(k,m))));
      elseif abs(imag(rx_symbols(k,m))) <= 2/sqrt(42) % bit is zero, close to real axis
         bit5(k,m) = -2/sqrt(42) + abs(imag(rx_symbols(k,m)));
      else
         bit5(k,m) = 6/sqrt(42)-abs(imag(rx_symbols(k,m)));
      end;
   end;
end;

soft_bits(1:6:size(soft_bits,1),:) = bit0;
soft_bits(2:6:size(soft_bits,1),:) = bit1;
soft_bits(3:6:size(soft_bits,1),:) = bit2;
soft_bits(4:6:size(soft_bits,1),:) = bit3;
soft_bits(5:6:size(soft_bits,1),:) = bit4;
soft_bits(6:6:size(soft_bits,1),:) = bit5;

