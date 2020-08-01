function [data_syms_out, pilot_syms_out] = rx_diversity_proc(freq_data_syms, freq_pilot_syms, ...
   channel_est, sim_options)

global sim_consts;

% remove extra dimension from matrices, if rx diversity is not used
freq_data_syms = squeeze(freq_data_syms);
freq_pilot_syms = squeeze(freq_pilot_syms);

% tx diversity
if sim_options.UseTxDiv
   % Radon-Hurwitz transmit diversity
   if ~sim_options.UseRxDiv
      freq_data_syms = rx_radon_hurwitz(freq_data_syms, channel_est(sim_consts.DataSubcPatt,:));
   elseif sim_options.UseRxDiv
      % Rx R-H performed to both receiver antennas
      freq_data_syms(1,:,:) = rx_radon_hurwitz(squeeze(freq_data_syms(1,:,:)), ...
         channel_est(sim_consts.DataSubcPatt,1:2));
      freq_data_syms(2,:,:) = rx_radon_hurwitz(squeeze(freq_data_syms(2,:,:)), ...
         channel_est(sim_consts.DataSubcPatt,3:4));
   end
end

% rx diversity
if sim_options.UseRxDiv
   if ~sim_options.UseTxDiv
      freq_data_syms = rx_mr_combiner(freq_data_syms, channel_est(sim_consts.DataSubcPatt,:), sim_options);
      freq_pilot_syms = rx_mr_combiner(freq_pilot_syms, channel_est(sim_consts.PilotSubcPatt,:), sim_options);   
   elseif sim_options.UseTxDiv
      freq_data_syms = squeeze(freq_data_syms(1,:,:) + freq_data_syms(2,:,:));
      freq_pilot_syms = rx_mr_combiner(freq_pilot_syms, channel_est(sim_consts.PilotSubcPatt,:), sim_options);
   end
end

% no diversity
if (~sim_options.UseTxDiv) & (~sim_options.UseRxDiv)
   % Data symbols channel correction
   chan_corr_mat = repmat(channel_est(sim_consts.DataSubcPatt), 1, size(freq_data_syms,2));
   freq_data_syms = freq_data_syms.*conj(chan_corr_mat);
   chan_corr_mat = repmat(channel_est(sim_consts.PilotSubcPatt), 1, size(freq_pilot_syms,2));
   freq_pilot_syms = freq_pilot_syms.*conj(chan_corr_mat);
end

% Amplitude normalization
chan_sq_amplitude = sum(abs(channel_est(sim_consts.DataSubcPatt,:)).^2, 2);
chan_sq_amplitude_mtx = repmat(chan_sq_amplitude,1, size(freq_data_syms,2));

data_syms_out = freq_data_syms./chan_sq_amplitude_mtx;

chan_sq_amplitude = sum(abs(channel_est(sim_consts.PilotSubcPatt,:)).^2, 2);
chan_sq_amplitude_mtx = repmat(chan_sq_amplitude,1, size(freq_pilot_syms,2));
pilot_syms_out = freq_pilot_syms./chan_sq_amplitude_mtx;


