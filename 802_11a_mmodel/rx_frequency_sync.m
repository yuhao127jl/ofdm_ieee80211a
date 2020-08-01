% Frequency error estimation and correction
function [out_signal, freq_est] = rx_frequency_sync(rxsignal, sim_options)

global sim_consts;

[n_tx_antennas, n_rx_antennas] = get_n_antennas(sim_options);

% Estimate the frequency error
if sim_options.FreqSync
   
   % allows for error in packet detection
   pkt_det_offset = 30;
   
   % averaging length
   rlen = 128;
   
   % short training symbol periodicity
   D = 16; 
      
   phase = rxsignal(:,pkt_det_offset:pkt_det_offset+rlen-D).* ...
      conj(rxsignal(:,pkt_det_offset+D:pkt_det_offset+rlen));
   
   % add all estimates 
   phase = sum(phase, 2);   

   % with rx diversity combine antennas
   phase = sum(phase, 1);   
   
   freq_est = -angle(phase) / (2*D*pi/sim_consts.SampFreq);
   
   radians_per_sample = 2*pi*freq_est/sim_consts.SampFreq;
else
   % Magic number
   freq_est = -sim_options.FreqError;
   radians_per_sample = 2*pi*freq_est/sim_consts.SampFreq;
end

% Now create a signal that has the frequency offset in the other direction
siglen=length(rxsignal(1,:));
time_base=0:siglen-1;
correction_signal=repmat(exp(-j*(radians_per_sample)*time_base),n_rx_antennas,1);

% And finally apply correction on the signal
out_signal = rxsignal.*correction_signal;

