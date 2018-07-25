

function fine_time_est = rx_fine_time_sync(input_signal, sim_options);

global sim_consts;

[n_tx_antennas, n_rx_antennas] = get_n_antennas(sim_options);

if sim_options.FineTimeSync
   %timing search window size
   start_search=130;
   end_search=200;
   
   % get time domain long training symbols
   long_tr_symbols = tx_freqd_to_timed(sim_consts.LongTrainingSymbols);
   
   if sim_options.UseTxDiv
      long_trs = [long_tr_symbols(49:64) long_tr_symbols(1:48)];
   else
      long_trs = [long_tr_symbols(33:64) long_tr_symbols(1:32)];
   end
   
   time_corr_long = zeros(n_rx_antennas,end_search-start_search+1);
   
   for k=1:n_rx_antennas   
      % calculate cross correlation      
      for idx=start_search:end_search
         time_corr_long(k,idx-start_search+1) = sum((input_signal(k,idx:idx+63).*conj(long_trs)));
      end
   end
   
   % combine, if we had two antennas
   time_corr_long = sum(abs(time_corr_long),1);
   [max_peak_long,long_search_idx] = max(abs(time_corr_long));
   
   if sim_options.UseTxDiv
      fine_time_est = start_search-1 + long_search_idx+16;
   else
      fine_time_est = start_search-1 + long_search_idx+32;
   end
   
else
   % Magic numbers
   if ~sim_options.UseTxDiv
      fine_time_est = 194;
   else
      fine_time_est = 194-16;
   end
end


