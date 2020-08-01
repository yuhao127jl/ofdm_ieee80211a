function detected_packet = rx_find_packet_edge(rx_signal, sim_options)

global sim_consts;

search_win = 800;
D = 16;

if sim_options.PacketDetection
   rx_len = length(rx_signal);
   
   % Calculate the delayd correlation
   delay_xcorr = rx_signal(:,1:search_win+2*D).*conj(rx_signal(:,1*D+1:search_win+3*D));
      
   % Moving average of the delayed correlation
   ma_delay_xcorr = abs(filter(ones(1,2*D), 1, delay_xcorr, [], 2));
   
   % Moving average of received power
   ma_rx_pwr = filter(ones(1,2*D), 1, abs(rx_signal(:,1*D+1:search_win+3*D)).^2,[], 2);
   
   % The decision variable
   delay_len = length(ma_delay_xcorr);
   ma_M = ma_delay_xcorr(:,1:delay_len)./ma_rx_pwr(:,1:delay_len);
         
   % remove delay samples
   ma_M(:,1:2*D) = [];
   
   % combine antennas, if rx diversity is used
   ma_M = sum(ma_M, 1);
   
   if ~sim_options.UseRxDiv
      threshold = 0.75;
   else
      threshold = 1.5;
   end
   
   thres_idx = find(ma_M > threshold);
   if isempty(thres_idx)
      thres_idx = 1;
   else
      thres_idx = thres_idx(1);
   end
   
else
   thres_idx = sim_consts.ExtraNoiseSamples;
end;

% check if the packet has been detected too late, 
% > sim_consts.extra_noise_samples + 35 index 
% is out of range of the fine timing algorithm
% This prevents simulation error for code running out samples
if thres_idx > sim_consts.ExtraNoiseSamples + 35
   thres_idx = 1;
end

detected_packet = rx_signal(:,thres_idx:length(rx_signal));


