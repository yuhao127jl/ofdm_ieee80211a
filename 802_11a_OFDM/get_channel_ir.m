function cir = get_channel_ir(sim_options);

global sim_consts;

[n_tx_antennas, n_rx_antennas] = get_n_antennas(sim_options);

n_channels = n_tx_antennas*n_rx_antennas;

if ~isempty(findstr(sim_options.ChannelModel, 'ExponentialDecay'))
   if sim_options.ExpDecayTrms == 0
      Kmax = 0;
      vark = 1;
   else
      % Calculate the exponential decay envelope
      Kmax = ceil( 10 * (sim_options.ExpDecayTrms*(1e-9))*sim_consts.SampFreq);
      var0 = (1 - exp( - 1/(sim_consts.SampFreq*(sim_options.ExpDecayTrms*(1e-9))))) / ...
         (1 - exp( -1*((Kmax+1)*sim_consts.SampFreq/(sim_options.ExpDecayTrms*(1e-9)))));
      k = (0:Kmax);
      env = var0 * exp( - k/(sim_consts.SampFreq*(sim_options.ExpDecayTrms*(1e-9))));
   end
   
   stdDevReOrIm = sqrt(env/2);
   cir = repmat(stdDevReOrIm, n_channels,1) .* (randn(n_channels, Kmax+1) + j*randn(n_channels, Kmax+1));
   
elseif ~isempty(findstr(sim_options.ChannelModel, 'AWGN'))
   cir = ones(n_channels,1);
else
   error('Undefined channel model');
end
