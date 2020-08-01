%

function channel_estimate = rx_estimate_channel(freq_tr_syms, cir, sim_options)

global sim_consts;

[n_tx_antennas, n_rx_antennas] = get_n_antennas(sim_options);

if sim_options.ChannelEstimation
   % Estimate from training symbols
   if ~sim_options.UseTxDiv
      for rx_ant=1:n_rx_antennas
         mean_symbols = mean(squeeze(freq_tr_syms(rx_ant,:,:)).');
         channel_estimate(rx_ant,:) = mean_symbols.*conj(sim_consts.LongTrainingSymbols);
      end
      channel_estimate = channel_estimate.';
   else
      for rx_ant=1:n_rx_antennas
         for tx_ant = 1:n_tx_antennas            
            tr_symbol = squeeze(freq_tr_syms(rx_ant, :, tx_ant));            
            channel_estimate((rx_ant-1)*n_tx_antennas+tx_ant,:) = ...
               tr_symbol.*conj(sim_consts.LongTrainingSymbols*sqrt(1/2));
         end
      end
      channel_estimate = channel_estimate.';
   end;
else
   % Known channel estimate
   channel_estimate = fft([zeros(size(cir,1), abs(sim_options.RxTimingOffset)) cir], 64, 2);
   reorder = [33:64 1:32];
   channel_estimate(:,reorder) = channel_estimate;
   channel_estimate = channel_estimate(:, sim_consts.UsedSubcIdx).';
end
