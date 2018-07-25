

function runsim(sim_options)

% set constants used in simulation
set_sim_consts;

% Set Random number generators initial state
% reset random number generators based on current clock value
rand('state',sum(100*clock));
randn('state',sum(100*clock));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main simulation loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize simulation timer
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
   [inf_bit_cnt, inf_bit_errors, raw_bits_cnt, raw_bit_errors] = ...
      single_packet(sim_options);
   
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

