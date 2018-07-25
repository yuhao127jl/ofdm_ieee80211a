% puncturing

function punctured_bits = tx_puncture(in_bits, code_rate)

[punc_patt, punc_patt_size] = get_punc_params(code_rate);

% Remainder bits are the bits in the end of the packet that are not integer multiple of the puncture window size
num_rem_bits = rem(length(in_bits), punc_patt_size);

puncture_table = reshape(in_bits(1:length(in_bits)-num_rem_bits), punc_patt_size, fix(length(in_bits)/punc_patt_size));
tx_table = puncture_table(punc_patt,:);

%puncture the remainder bits
rem_bits = in_bits(length(in_bits)-num_rem_bits+1:length(in_bits));
rem_punc_patt = find(punc_patt<=num_rem_bits);
rem_punc_bits = rem_bits(rem_punc_patt)';

punctured_bits = [tx_table(:)' rem_punc_bits];

