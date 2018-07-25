function correction_phases = rx_pilot_phase_est(rx_pilots, channel, sim_options)

global sim_consts;

num_symbols = size(rx_pilots, 3);

% Pilot scrambling pattern
scramble_patt = repmat(sim_consts.PilotScramble, sim_consts.NumPilotSubc,...
   ceil(num_symbols/length(sim_consts.PilotScramble)));
scramble_patt = scramble_patt(:,1:num_symbols);
ref_pilots = repmat(sim_consts.PilotSubcSymbols, 1, num_symbols);

% Estimate the symbol rotation from the pilot subcarriers
% Different Tx and/or Rx diversity options require different processing of the pilot symbols
if (~sim_options.UseTxDiv) & (~sim_options.UseRxDiv)
   channel_est = repmat(channel(sim_consts.PilotSubcPatt), 1, num_symbols);
   phase_error_est = angle(sum(conj(ref_pilots).*squeeze(rx_pilots).*conj(channel_est).*conj(scramble_patt)));
   
   correction_phases = zeros(1, sim_consts.NumDataSubc, num_symbols);
   correction_phases(1,:,:) = repmat(phase_error_est, sim_consts.NumDataSubc, 1);   
elseif (~sim_options.UseTxDiv) & (sim_options.UseRxDiv)
   channel_est1 = repmat(channel(sim_consts.PilotSubcPatt, 1), 1, num_symbols);
   phase_error_est1 = sum(conj(ref_pilots).*squeeze(rx_pilots(1,:,:)).*conj(channel_est1).*conj(scramble_patt));
   
   channel_est2 = repmat(channel(sim_consts.PilotSubcPatt, 2), 1, num_symbols);
   phase_error_est2 = sum(conj(ref_pilots).*squeeze(rx_pilots(2,:,:)).*conj(channel_est2).*conj(scramble_patt));
   
   phase_error_est = angle(phase_error_est1+phase_error_est2);
   
   correction_phases = zeros(2, sim_consts.NumDataSubc, num_symbols);
   correction_phases(1,:,:) = repmat(phase_error_est, sim_consts.NumDataSubc, 1); 
   correction_phases(2,:,:) = repmat(phase_error_est, sim_consts.NumDataSubc, 1);
elseif (sim_options.UseTxDiv) & (~sim_options.UseRxDiv)
   channel_est1 = repmat(channel(sim_consts.PilotSubcPatt, 1), 1, num_symbols);  
   channel_est2 = repmat(channel(sim_consts.PilotSubcPatt, 2), 1, num_symbols);
   
   phase_error_est = sum(conj(channel_est1.*ref_pilots+channel_est2.*ref_pilots).*...
      squeeze(rx_pilots(1,:,:)).*conj(scramble_patt));
   
   phase_error_est = angle(phase_error_est);
   
   correction_phases = zeros(1, sim_consts.NumDataSubc, num_symbols);
   correction_phases(1,:,:) = repmat(phase_error_est, sim_consts.NumDataSubc, 1); 
elseif (sim_options.UseTxDiv) & (sim_options.UseRxDiv)
   channel_est1_1 = repmat(channel(sim_consts.PilotSubcPatt, 1), 1, num_symbols);  
   channel_est1_2 = repmat(channel(sim_consts.PilotSubcPatt, 2), 1, num_symbols);
   channel_est2_1 = repmat(channel(sim_consts.PilotSubcPatt, 3), 1, num_symbols);  
   channel_est2_2 = repmat(channel(sim_consts.PilotSubcPatt, 4), 1, num_symbols);

   
   phase_error_est1 = sum(conj(channel_est1_1.*ref_pilots+channel_est1_2.*ref_pilots).*...
      squeeze(rx_pilots(1,:,:)).*conj(scramble_patt));
   phase_error_est2 = sum(conj(channel_est2_1.*ref_pilots+channel_est2_2.*ref_pilots).*...
      squeeze(rx_pilots(2,:,:)).*conj(scramble_patt));
   
   phase_error_est = angle(phase_error_est1+phase_error_est2);
   
   correction_phases = zeros(2, sim_consts.NumDataSubc, num_symbols);
   correction_phases(1,:,:) = repmat(phase_error_est, sim_consts.NumDataSubc, 1);   
   correction_phases(2,:,:) = repmat(phase_error_est, sim_consts.NumDataSubc, 1);    
end
