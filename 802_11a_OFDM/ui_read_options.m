function sim_options = ui_read_options
% 读取文本框中的数据，得到相应设置参数
% packet lengths vector, in bits
pkt_length = eval(get(findobj('Tag', 'PktLen'),'String'))*8;

% convolutional code options
conv_code_rate = get(findobj('Tag', 'ConvCodeRate'),'String');
conv_code_rate = conv_code_rate(get(findobj('Tag', 'ConvCodeRate'),'Value'),:);

% Interleaving
interleave_bits = get(findobj('Tag', 'InterleaveBits'),'Value');

% Modulation
modulation = get(findobj('Tag', 'Modulation'),'String');
modulation = modulation(get(findobj('Tag', 'Modulation'),'Value'),:);

% Tx Diversity options
use_tx_div = get(findobj('Tag', 'UseTxDiversity'),'Value');

% Rx Diversity
use_rx_div = get(findobj('Tag', 'UseRxDiversity'),'Value');

% Frequency error vector
freq_error = eval(get(findobj('Tag', 'FreqError'),'String'));

% Channel models
if get(findobj('Tag', 'AWGN'),'Value')
   chan_model = 'AWGN';
elseif get(findobj('Tag', 'ExponentialDecay'),'Value')
   chan_model = 'ExponentialDecay';
end
exp_decay_trms = eval(get(findobj('Tag', 'ExpDecayTrms'),'String'));

% Signal to Noise Rations
snr = eval(get(findobj('Tag', 'SNR'),'String'));

% Tx Power Amplifier
use_tx_pa = get(findobj('Tag', 'UseTxPA'),'Value');

% Phase Noise
use_phase_noise = get(findobj('Tag', 'UsePhaseNoise'),'Value');
phase_noise_dbc = eval(get(findobj('Tag', 'PhaseNoiseDbcLevel'),'String'));
phase_noise_cfreq = eval(get(findobj('Tag', 'PhaseNoiseCornerFreq'),'String'));
phase_noise_floor = eval(get(findobj('Tag', 'PhaseNoiseFloor'),'String'));

% Tx Power Spectrum test
tx_pwr_spectrum_test = get(findobj('Tag', 'TxSpectrumShape'),'Value');

% Synchronization options
packet_detection = get(findobj('Tag', 'PacketDetection'),'Value');
fine_time_sync = get(findobj('Tag', 'FineTimeSync'),'Value');
freq_sync = get(findobj('Tag', 'FreqSync'),'Value');
pilot_phase_tracking = get(findobj('Tag', 'PilotPhaseTrack'),'Value');
channel_estimation = get(findobj('Tag', 'ChannelEst'),'Value');
rx_timing_offset = eval(get(findobj('Tag', 'RxTimingOffset'),'String'));

%Packets per run options
pkts_per_run = eval(get(findobj('Tag', 'PktsToSimulate'),'String'));

sim_options = struct('PacketLength', pkt_length, ...
   'ConvCodeRate', conv_code_rate, ...
   'InterleaveBits', interleave_bits, ...
   'Modulation', modulation,...
   'UseTxDiv', use_tx_div, ...
   'UseRxDiv', use_rx_div, ...
   'FreqError', freq_error, ...
   'ChannelModel', chan_model, ...
   'ExpDecayTrms', exp_decay_trms, ...
   'SNR', snr,...
   'UseTxPA', use_tx_pa, ...
   'UsePhaseNoise', use_phase_noise, ...
   'PhaseNoisedBcLevel', phase_noise_dbc, ...
   'PhaseNoiseCFreq', phase_noise_cfreq, ...   
   'PhaseNoiseFloor', phase_noise_floor, ...      
   'PacketDetection', packet_detection, ...
   'TxPowerSpectrum', tx_pwr_spectrum_test, ...
   'FineTimeSync', fine_time_sync, ...
   'FreqSync', freq_sync, ...
   'PilotPhaseTracking', pilot_phase_tracking, ...
   'ChannelEstimation', channel_estimation, ...
   'RxTimingOffset', rx_timing_offset, ...
   'PktsToSimulate', pkts_per_run);

