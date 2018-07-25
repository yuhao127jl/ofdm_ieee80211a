

function [freq_tr_syms, freq_data_syms, freq_pilot_syms] = rx_timed_to_freqd(time_signal, sim_options)

global sim_consts;

[n_tx_antennas, n_rx_antennas] = get_n_antennas(sim_options);

for rx_ant = 1:n_rx_antennas
   % Long Training symbols
   
   if ~sim_options.UseTxDiv
      long_tr_syms = time_signal(rx_ant,1:2*64);
   else
      long_tr_syms = [time_signal(rx_ant,1:64) time_signal(rx_ant,81:144)];
   end
   long_tr_syms = reshape(long_tr_syms, 64, 2);
   
   % to frequency domain
   freq_long_tr = fft(long_tr_syms)/(64/sqrt(52)/sqrt(n_tx_antennas));
   reorder = [33:64 1:32];
   freq_long_tr(reorder,:) = freq_long_tr;
   
   % Select training carriers
   freq_tr_syms = freq_long_tr(sim_consts.UsedSubcIdx,:);
   
   % Take data symbols
   if ~sim_options.UseTxDiv
      data_syms = time_signal(rx_ant,129:length(time_signal));
   else
      data_syms = time_signal(rx_ant, 145:length(time_signal));
   end
   
   data_sig_len = length(data_syms);
   n_data_syms = floor(data_sig_len/80);
   
   % Cut to multiple of symbol period
   data_syms = data_syms(1:n_data_syms*80);
   data_syms = reshape(data_syms, 80, n_data_syms);
   % remove guard intervals
   data_syms(1:16,:) = [];
   
   % perform fft
   freq_data = fft(data_syms)/(64/sqrt(52)/sqrt(n_tx_antennas));
   
   %Reorder pattern is [33:64 1:32]
   freq_data(reorder,:) = freq_data;
   
   %Select data carriers
   freq_data_syms = freq_data(sim_consts.DataSubcIdx,:);
   
   %Select the pilot carriers
   freq_pilot_syms = freq_data(sim_consts.PilotSubcIdx,:);
   
   tmp_freq_tr(rx_ant,:,:) = freq_tr_syms;
   tmp_data_syms(rx_ant,:,:) = freq_data_syms;
   tmp_pilot_syms(rx_ant,:,:) = freq_pilot_syms;
end

freq_tr_syms = tmp_freq_tr;
freq_data_syms = tmp_data_syms;
freq_pilot_syms = tmp_pilot_syms;
