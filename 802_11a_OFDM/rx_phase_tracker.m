
function corrected_syms = rx_phase_tracker(freq_data_syms, freq_pilot_syms, channel_est, sim_options);

global sim_consts;

num_symbols = size(freq_data_syms,2);
corrected_syms = zeros(sim_consts.NumDataSubc, num_symbols);

if sim_options.PilotPhaseTracking      
   % estimate the phase change using the pilots
   correction_phases = rx_pilot_phase_est(freq_pilot_syms, channel_est, sim_options);
   
   % correct symbol using the phase estimate of this one OFDM symbol,
   corrected_syms = exp(-j*correction_phases).*freq_data_syms;
else
   corrected_syms = freq_data_syms;
end
