function ui_check_params

persistent state;%定义局部变量

if isempty(state)
   state = struct('PktLen', '100', 'FreqError', '0', 'ExpDecayTrms', '50', 'SNR','20', ...
      'PhaseNoisedBc', '-90', 'PhaseNoiseCFreq', '30e3', 'PhaseNoiseFloor', '-140', ...
      'PktsPerRun', '1000', 'RxTimingOffset', '-3');
end

curr_obj = gcbo;
obj_tag = get(curr_obj,'Tag');

% performs logical check on input parameters
switch (obj_tag)
case 'PktLen'
   pkt_len_str = get(curr_obj,'String');
   try
      pkt_len = eval(pkt_len_str);
      if pkt_len <= 0
         set(curr_obj, 'String', state.PktLen);
         errordlg('Packet length must be positive','Invalid input', 'modal');
      else
         state = setfield(state, 'PktLen', pkt_len_str);
      end
   catch
      set(curr_obj,'String', state.PktLen);
      errordlg('Packet length value not a number','Invalid input', 'modal');
   end
case 'FreqError'
   freq_err_str = get(curr_obj, 'String');
   try
      freq_err = eval(freq_err_str);
      state = setfield(state, 'FreqError', freq_err_str);
   catch
      set(curr_obj,'String', state.FreqError);
      errordlg('Frequency error value not a number','Invalid input', 'modal');
   end
case 'AWGN'
   awgn_val = get(curr_obj, 'Value');
      
   if awgn_val == 1
      set(curr_obj, 'Enable', 'inactive')
      exp_decay_chan = findobj('Tag', 'ExponentialDecay');
      set(exp_decay_chan, 'Enable', 'on')
      set(exp_decay_chan, 'Value', 0);
   end
case 'ExponentialDecay'
   exp_decay_val = get(curr_obj, 'Value');
   if exp_decay_val == 1      
      set(curr_obj, 'Enable', 'inactive');
      awgn_chan = findobj('Tag', 'AWGN');
      set(awgn_chan, 'Enable', 'on')
      set(awgn_chan, 'Value', 0);
   end
case 'ExpDecayTrms'
   exp_decay_trms_str = get(curr_obj,'String');
   try
      exp_decay_trms = eval(exp_decay_trms_str);
      if exp_decay_trms < 0
         set(curr_obj, 'String', state.ExpDecayTrms);
         errordlg('Exponential decay T rms cannot be negative','Invalid input', 'modal');
      else
         state = setfield(state, 'ExpDecayTrms', exp_decay_trms_str);      
      end
   catch
      set(curr_obj,'String', state.ExpDecayTrms);
      errordlg('Exponential decay T rms value not a number','Invalid input', 'modal');
   end
case 'SNR'
   snr_str = get(curr_obj,'String');
   try
      snr = eval(snr_str);
      state = setfield(state, 'SNR', snr_str);
   catch
      set(curr_obj,'String', state.SNR);
      errordlg('SNR value not a number','Invalid input', 'modal');
   end
case 'PhaseNoiseDbcLevel'
   phase_noise_dbc_str = get(curr_obj,'String');
   try
      phase_noise_dbc = eval(phase_noise_dbc_str);
      if phase_noise_dbc > 0
         set(curr_obj, 'String', state.PhaseNoisedBc);
         errordlg('Phase noise dBc level must be negative', 'Invalid input', 'modal');
      else
         state = setfield(state, 'PhaseNoisedBc', phase_noise_dbc_str);      
      end
   catch
      set(curr_obj,'String', state.PhaseNoisedBc);
      errordlg('Phase noise dBc value not a number','Invalid input', 'modal');
   end
case 'PhaseNoiseCornerFreq'
   phase_noise_cfreq_str = get(curr_obj,'String');
   try
      phase_noise_cfreq = eval(phase_noise_cfreq_str);
      if phase_noise_cfreq < 0
         set(curr_obj, 'String', state.PhaseNoiseCFreq);
         errordlg('Phase noise corner frequency must be positive','Invalid input', 'modal');
      else
         state = setfield(state, 'PhaseNoiseCFreq', phase_noise_cfreq_str);      
      end
   catch
      set(curr_obj,'String', state.PhaseNoiseCFreq);
      errordlg('Phase noise corner frequency value not a number','Invalid input', 'modal');
   end
case 'PhaseNoiseFloor'
   phase_noise_floor_str = get(curr_obj,'String');
   try
      phase_noise_floor = eval(phase_noise_floor_str);
      if phase_noise_floor > 0
         set(curr_obj, 'String', state.PhaseNoiseFloor);
         errordlg('Phase noise floor must be negative','Invalid input', 'modal');
      else
         state = setfield(state, 'PhaseNoiseFloor', phase_noise_floor_str);      
      end
   catch
      set(curr_obj,'String', state.PhaseNoiseFloor);
      errordlg('Phase noise floor level value not a number','Invalid input', 'modal');
   end
case 'PacketDetection'
   pkt_det = get(curr_obj,'Value');
   if pkt_det == 1
      fine_time_sync = findobj('Tag', 'FineTimeSync');
      freq_sync = findobj('Tag', 'FreqSync');
      pilot_phase_track = findobj('Tag', 'PilotPhaseTrack');
      channel_est = findobj('Tag', 'ChannelEst');
      
      set(fine_time_sync, 'Value', 1);
      set(freq_sync, 'Value', 1);
      set(pilot_phase_track, 'Value', 1);
      set(channel_est, 'Value', 1);
   end
case 'FineTimeSync'
   fine_time_sync = get(curr_obj,'Value');
   if fine_time_sync == 1
      freq_sync = findobj('Tag', 'FreqSync');
      pilot_phase_track = findobj('Tag', 'PilotPhaseTrack');
      channel_est = findobj('Tag', 'ChannelEst');
      
      set(freq_sync, 'Value', 1);
      set(pilot_phase_track, 'Value', 1);
      set(channel_est, 'Value', 1);
   else
      packet_detection = findobj('Tag', 'PacketDetection');
      set(packet_detection, 'Value', 0);
   end
case 'FreqSync'
   freq_sync = get(curr_obj,'Value');
   if freq_sync == 1
      pilot_phase_track = findobj('Tag', 'PilotPhaseTrack');
      channel_est = findobj('Tag', 'ChannelEst');
      
      set(pilot_phase_track, 'Value', 1);
      set(channel_est, 'Value', 1);
   else
      packet_detection = findobj('Tag', 'PacketDetection');
      fine_time_sync = findobj('Tag', 'FineTimeSync');
      
      set(packet_detection, 'Value', 0);
      set(fine_time_sync, 'Value', 0);
   end
case 'PilotPhaseTrack'
   pilot_phase_track = get(curr_obj,'Value');
   if pilot_phase_track == 1
      channel_est = findobj('Tag', 'ChannelEst');
      
      set(channel_est, 'Value', 1);
   else
      packet_detection = findobj('Tag', 'PacketDetection');
      fine_time_sync = findobj('Tag', 'FineTimeSync');
      freq_sync = findobj('Tag', 'FreqSync');
      
      set(packet_detection, 'Value', 0);
      set(fine_time_sync, 'Value', 0);
      set(freq_sync, 'Value', 0);
   end
case 'ChannelEst'
   channel_est = get(curr_obj,'Value');
   if channel_est == 0
      packet_detection = findobj('Tag', 'PacketDetection');
      fine_time_sync = findobj('Tag', 'FineTimeSync');
      freq_sync = findobj('Tag', 'FreqSync');
      pilot_phase_track = findobj('Tag', 'PilotPhaseTrack');
      
      set(packet_detection, 'Value', 0);
      set(fine_time_sync, 'Value', 0);
      set(freq_sync, 'Value', 0);
      set(pilot_phase_track, 'Value', 0);
   end
case 'RxTimingOffset'
   rx_timing_offset_str = get(curr_obj,'String');
   try
      rx_timing_offset = eval(rx_timing_offset_str);
      if rx_timing_offset > 0
         set(curr_obj,'String', state.RxTimingOffset);
         errordlg('Rx timing offset positive','Invalid input', 'modal');
      else
         state = setfield(state, 'RxTimingOffset', rx_timing_offset_str);
      end
   catch
      set(curr_obj,'String', state.RxTimingOffset);
      errordlg('Rx timing offset value not a number','Invalid input', 'modal');
   end
case 'PktsToSimulate'
   pkts_to_simulate_str = get(curr_obj, 'String');
   try
      pkts_to_simulate = eval(pkts_to_simulate_str);
      if pkts_to_simulate < 0
         set(curr_obj,'String', state.PktsPerRun);
         errordlg('Packets to simulate cannot be negative','Invalid input', 'modal');
      else
         state = setfield(state, 'PktsPerRun', pkts_to_simulate_str);
      end
   catch
      set(curr_obj,'String', state.PktsPerRun);
      errordlg('Packets to simulate value not a number','Invalid input', 'modal');
   end
otherwise
   
end

