
function [inf_bits_cnt, inf_bit_errs, raw_bits_cnt, raw_bit_errs] = single_packet(sim_options)

% Generate channel impulse response
cir = get_channel_ir(sim_options);

% Generate tx signal, returns also information bits and raw bits
[txsignal, tx_inf_bits, tx_raw_bits] = transmitter(sim_options);

% Channel model
rxsignal = channel(txsignal, cir, sim_options);

%Receiver, return data bits and undecoded bits
[rx_inf_bits, rx_raw_bits] = receiver(rxsignal, cir, sim_options);

% Calculate bit errors
raw_bit_errs = sum(abs(rx_raw_bits(1:length(tx_raw_bits))-tx_raw_bits));
raw_bits_cnt = length(tx_raw_bits);

inf_bit_errs = sum(abs(rx_inf_bits(1:length(tx_inf_bits))-tx_inf_bits));
inf_bits_cnt = length(tx_inf_bits);
