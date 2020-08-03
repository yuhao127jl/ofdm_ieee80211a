
% ------------------------------------------------------------------
% Projet      :                                
% Filename    : main.m                     
% Description : This communication system consists of transmitter                                
%               and receiver.                              
% Author      :                                     
% Data        : 08/03/2020 
% ------------------------------------------------------------------
clc;clear all; close all;

global sim_options;
global sim_consts;

pkt_length = 8* 100;
%conv_code_rate = ['R1/2', 'R2/3', 'R3/4'];
conv_code_rate = 'R1/2';
interleave_bits = 1;
%modulation = ['BPSK', 'QPSK', '16QAM', '64QAM'];
modulation = 'BPSK';
use_tx_div = 0; 
use_rx_div = 0; 
freq_error = 0; 
chan_model = 'AWGN'; 
exp_decay_trms = 50; 
snr = 10;
use_tx_pa = 0; 
use_phase_noise = 0; 
phase_noise_dbc = -90; 
phase_noise_cfreq = 30000;    
phase_noise_floor = -140;       
packet_detection = 0; 
tx_pwr_spectrum_test = 0; 
fine_time_sync = 0; 
freq_sync = 0; 
pilot_phase_tracking = 0; 
channel_estimation = 0; 
rx_timing_offset = -3; 
pkts_per_run = 100;

sim_options = struct(  'PacketLength', 			pkt_length, ...
					   'ConvCodeRate', 			conv_code_rate, ...
					   'InterleaveBits', 		interleave_bits, ...
					   'Modulation', 			modulation,...
					   'UseTxDiv', 				use_tx_div, ...
					   'UseRxDiv', 				use_rx_div, ...
					   'FreqError', 			freq_error, ...
					   'ChannelModel', 			chan_model, ...
					   'ExpDecayTrms', 			exp_decay_trms, ...
					   'SNR', 					snr,...
					   'UseTxPA', 				use_tx_pa, ...
					   'UsePhaseNoise', 		use_phase_noise, ...
					   'PhaseNoisedBcLevel', 	phase_noise_dbc, ...
					   'PhaseNoiseCFreq', 		phase_noise_cfreq, ...   
					   'PhaseNoiseFloor', 		phase_noise_floor, ...      
					   'PacketDetection', 		packet_detection, ...
					   'TxPowerSpectrum', 		tx_pwr_spectrum_test, ...
					   'FineTimeSync', 			fine_time_sync, ...
					   'FreqSync', 				freq_sync, ...
					   'PilotPhaseTracking', 	pilot_phase_tracking, ...
					   'ChannelEstimation', 	channel_estimation, ...
					   'RxTimingOffset', 		rx_timing_offset, ...
					   'PktsToSimulate', 		pkts_per_run);

sim_consts = struct(  'SampFreq' , 20e6, ...
   'ConvCodeGenPoly', [1 0 1 1 0 1 1;1 1 1 1 0 0 1 ], ...
   'NumSubc', 52, ...
   'UsedSubcIdx', [7:32 34:59]', ...
   'ShortTrainingSymbols', sqrt(13/6)*[0 0 1+j 0 0 0 -1-j 0 0 0 1+j 0 0 0 -1-j 0 0 0 -1-j 0 0 0 1+j 0 0 0 0 0 0 -1-j 0 0 0 -1-j 0 0 0 ...
      1+j 0 0 0 1+j 0 0 0 1+j 0 0 0 1+j 0 0], ...
   'LongTrainingSymbols', [1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 ...
      1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1], ...
   'ExtraNoiseSamples', 500, ...
   'PilotScramble', [1 1 1 1 -1 -1 -1 1 -1 -1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 1 1 -1 1 1 1 1 ...
      1 1 -1 1 1 1 -1 1 1 -1 -1 1 1 1 -1 1 -1 -1 -1 1 -1 1 -1 -1 1 -1 -1 1 1 1 1 1 -1 -1 1 ...
      1 -1 -1 1 -1 1 -1 1 1 -1 -1 -1 1 1 -1 -1 -1 -1 1 -1 -1 1 -1 1 1 1 1 -1 1 -1 1 -1 1 -1 ...
      -1 -1 -1 -1 1 -1 1 1 -1 1 -1 1 1 1 -1 -1 1 -1 -1 -1 1 1 1 -1 -1 -1 -1 -1 -1 -1], ...
   'NumDataSubc', 48, ...
   'NumPilotSubc' , 4, ...
   'DataSubcIdx', [7:11 13:25 27:32 34:39 41:53 55:59]', ...
   'PilotSubcIdx', [12 26 40 54]', ...
   'PilotSubcPatt', [6 20 33 47]', ...
   'DataSubcPatt', [1:5 7:19 21:26 27:32 34:46 48:52]', ...
   'PilotSubcSymbols' , [1;1;1;-1]);

% Set Random number generators initial state, reset random number generators based on current clock value
rand('state',sum(100*clock));
randn('state',sum(100*clock));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main simulation loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_time = clock;

% Initialize trellis tables for Viterbi decoding
rx_init_viterbi;

% counters for information bits
num_inf_bits          = 0;
num_inf_bit_errors    = 0;
num_inf_packet_errors = 0;
inf_ber               = 0;
inf_per               = 0;

% counters for raw (uncoded) bits
num_raw_bits          = 0;
num_raw_bit_errors    = 0;
num_raw_packet_errors = 0;
raw_ber               = 0;
raw_per               = 0;

% Simulation the number of packets specified 
packet_count = 0;
while packet_count < sim_options.PktsToSimulate
    packet_count = packet_count + 1;
   
    packet_start_time  = clock;
                  
    % Simulate one packet with the current options
    [inf_bit_cnt, inf_bit_errors, raw_bits_cnt, raw_bit_errors] = single_packet(sim_options);
    num_inf_bits          = num_inf_bits + inf_bit_cnt;
    num_inf_bit_errors    = num_inf_bit_errors + inf_bit_errors;
    num_inf_packet_errors = num_inf_packet_errors + (inf_bit_errors~=0);
    inf_ber               = num_inf_bit_errors/num_inf_bits;
    inf_per               = num_inf_packet_errors/packet_count;
   
    num_raw_bits          = num_raw_bits + raw_bits_cnt;
    num_raw_bit_errors    = num_raw_bit_errors + raw_bit_errors;
    num_raw_packet_errors = num_raw_packet_errors + (raw_bit_errors~=0);
    raw_ber               = num_raw_bit_errors/num_raw_bits;
    raw_per               = num_raw_packet_errors/packet_count;
                     
    packet_stop_time = clock;
    packet_duration = etime(packet_stop_time, packet_start_time);
    
    % Display results
    fprintf('%8s %8s %9s %10s %8s %10s %10s %9s\n', ...
      ' Packet |', ' Time |', 'raw errs |', '  raw BER |', 'data errs |',' data BER |', '  raw PER |', 'data PER');
    fprintf('%7d |%7g | %8d |%10.2e |%10d |%10.2e |%10.2e |%10.2e\n',...
      packet_count, packet_duration, raw_bit_errors, raw_ber, inf_bit_errors, inf_ber, raw_per, inf_per);
   
    % read event queue
    drawnow;
end
    
stop_time = clock;
elapsed_time = etime(stop_time,start_time);

fprintf('Simulation duration: %g seconds\n',elapsed_time);
