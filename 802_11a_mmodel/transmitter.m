% Generates transmitted signal for one packet.

function [tx_signal, inf_bits, tx_bits] = transmitter(sim_options);

global sim_consts;

% Generate the information bits
inf_bits = randn(1, sim_options.PacketLength) > 0;

% Convolutional encoding
coded_bit_stream = tx_conv_encoder(inf_bits);
   
%Puncturing   
tx_bits = tx_puncture(coded_bit_stream, sim_options.ConvCodeRate);

% Generate number bits that is an integer multiple of OFDM symbols
rdy_to_mod_bits = tx_make_int_num_ofdm_syms(tx_bits, sim_options);

if sim_options.InterleaveBits == 1
   %Interleave padded bit stream 
   rdy_to_mod_bits = tx_interleaver(rdy_to_mod_bits, sim_options);
end

%Modulate
mod_syms = tx_modulate(rdy_to_mod_bits, sim_options.Modulation);

% Transmit diversity
mod_syms = tx_diversity(mod_syms, sim_options);

%Add pilot symbols
if ~sim_options.UseTxDiv
   mod_ofdm_syms = tx_add_pilot_syms(mod_syms, sim_options);
else
   mod_ofdm_syms(1,:) = tx_add_pilot_syms(mod_syms(1,:), sim_options);
   mod_ofdm_syms(2,:) = tx_add_pilot_syms(mod_syms(2,:), sim_options);
end

% Tx symbols to time domain
time_syms = tx_freqd_to_timed(mod_ofdm_syms);

% Add cyclic prefix
time_signal = tx_add_cyclic_prefix(time_syms);

% Construction of the preamble
preamble = tx_gen_preamble(sim_options);

% Concatenate preamble and data part and normalize the average signal power to 1
tx_signal = [preamble time_signal]*64/sqrt(52)/sqrt(size(time_signal,1));

% Model phase noise
if sim_options.UsePhaseNoise
   phase_noise = phase_noise_model(sim_options.PhaseNoisedBcLevel, ...
      sim_options.PhaseNoiseCFreq, sim_options.PhaseNoiseFloor, size(tx_signal,2));
   tx_signal = tx_signal.*exp(j*repmat(phase_noise,size(tx_signal,1), 1));
end

%Power amplifier model
if sim_options.UseTxPA
   if ~sim_options.UseTxDiv
      [tx_signal, pwr_in, pwr_out] = tx_power_amplifier(tx_signal, 1, 1, 1, 2, size(tx_signal,2));
      % normalize average tx power to one
      tx_signal(1,:) = tx_signal(1,:)/sqrt(pwr_out);
   else
      % first antenna
      [tx_signal(1,:), pwr_in, pwr_out] = tx_power_amplifier(tx_signal(1,:), 1, 1, 1, 2, size(tx_signal(1,:),2));
      % normalize average tx power to one
      tx_signal(1,:) = tx_signal(1,:)/sqrt(pwr_out);
      
      % second antenna
      [tx_signal(2,:), pwr_in, pwr_out] = tx_power_amplifier(tx_signal(2,:), 1, 1, 1, 2, size(tx_signal(2,:),2));
      % normalize average tx power to one
      tx_signal(2,:) = tx_signal(2,:)/sqrt(pwr_out);
   end   
end

% Generates passband signal from which the tx power spectrum can be estimated
if sim_options.TxPowerSpectrum
   if ~sim_options.UseTxDiv
      interp_tx_signal = interp(tx_signal, 16);
   else
      interp_tx_signal(1,:) = interp(tx_signal(1,:), 16);
      interp_tx_signal(2,:) = interp(tx_signal(2,:), 16);
   end
   
   % upconvert, and extract passband signal
   rf_tx_signal = interp_tx_signal.*exp(repmat(j*2*pi*4/16* ...
      (0:size(interp_tx_signal,2)-1), size(interp_tx_signal, 1), 1));
   rf_tx_signal = real(rf_tx_signal);
end
