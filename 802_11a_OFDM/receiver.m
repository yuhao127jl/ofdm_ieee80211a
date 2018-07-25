

function [data_bits, raw_bits] = receiver(rx_signal, cir, sim_options);

global sim_consts;

[n_tx_antennas, n_rx_antennas] = get_n_antennas(sim_options);

% Phase noise model
if sim_options.UsePhaseNoise
   phase_noise = phase_noise_model(sim_options.PhaseNoisedBcLevel, ...
      sim_options.PhaseNoiseCFreq, sim_options.PhaseNoiseFloor, size(rx_signal,2));
   rx_signal = rx_signal.*exp(j*repmat(phase_noise, size(rx_signal,1), 1));
end

%packet search
rx_signal = rx_find_packet_edge(rx_signal, sim_options);

% Frequency error estimation and correction
rx_signal = rx_frequency_sync(rx_signal, sim_options);

% Fine time synchronization
fine_time_est = rx_fine_time_sync(rx_signal, sim_options);

% Time synchronized signal
sync_time_signal = rx_signal(:,fine_time_est + sim_options.RxTimingOffset:length(rx_signal(1,:)));

% Return to frequency domain
[freq_tr_syms, freq_data_syms, freq_pilot_syms] = rx_timed_to_freqd(sync_time_signal, sim_options);

% Channel estimation
channel_est = rx_estimate_channel(freq_tr_syms, cir, sim_options);

% Phase tracker, returns phase error corrected symbols
freq_data_syms = rx_phase_tracker(freq_data_syms, freq_pilot_syms, channel_est, sim_options);

% receiver diversity processing
[freq_data_syms,freq_pilot_syms] = rx_diversity_proc(freq_data_syms, freq_pilot_syms, ...
   channel_est, sim_options);

% Demodulate
soft_bits = rx_demodulate(freq_data_syms, sim_options);

% Deinterleave if bits were interleaved
if sim_options.InterleaveBits
   deint_bits = rx_deinterleave(soft_bits, sim_options);
else
   deint_bits = soft_bits;
end

% hard decision of soft bits, used to measure uncoded BER
raw_bits = deint_bits > 0;

% depuncture
depunc_bits = rx_depuncture(deint_bits, sim_options.ConvCodeRate);

% Subcarrier amplitudes are used to weight the soft decisions before Viterbi decoding
channel_amps = rx_gen_chan_amps(length(deint_bits), channel_est, sim_options);

if sim_options.InterleaveBits
   channel_amps = rx_deinterleave(channel_amps, sim_options);
end
channel_amps = rx_depuncture(channel_amps, sim_options.ConvCodeRate);

% Weight soft decisions by subcarrier amplitudes
viterbi_input = channel_amps(1:(sim_options.PacketLength+6)*2).* ...
   depunc_bits(1:(sim_options.PacketLength+6)*2);

% Vitervi decoding
data_bits = rx_viterbi_decode(viterbi_input);

