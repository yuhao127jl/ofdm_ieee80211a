function depunctured_bits = rx_depuncture(in_bits, code_rate)

[punc_patt, punc_patt_size] = get_punc_params(code_rate);

% Remainder bits are the bits in the and of the packet that are not integer mulitple of the puncture window size
num_rem_bits = rem(length(in_bits), length(punc_patt));

depuncture_table = zeros(punc_patt_size, fix(length(in_bits)/length(punc_patt)));

depunc_bits = reshape(in_bits(1:length(in_bits)-num_rem_bits), length(punc_patt), ...
   fix(length(in_bits)/length(punc_patt)));

depuncture_table(punc_patt,:) = depuncture_table(punc_patt,:) + depunc_bits;

%puncture the remainder bits
rem_bits = in_bits(length(in_bits)-num_rem_bits+1:length(in_bits));
rem_depunc_bits = zeros(1,punc_patt_size);

rem_depunc_bits(punc_patt(1:num_rem_bits)) = rem_depunc_bits(punc_patt(1:num_rem_bits)) + rem_bits;

depunctured_bits = [depuncture_table(:)' rem_depunc_bits];
