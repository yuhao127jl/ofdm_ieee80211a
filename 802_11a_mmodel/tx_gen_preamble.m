
function preamble = tx_gen_preamble(sim_options);


global sim_consts;

%Generate first ten short training symbols

short_tr = sim_consts.ShortTrainingSymbols;

% generate four short training symbols
short_tr_symbols = tx_freqd_to_timed(short_tr);

% Pick one short training symbol
Strs = short_tr_symbols(1:16);

% extend to ten short training symbols
short_trs=[Strs Strs Strs Strs Strs Strs Strs Strs Strs Strs];

short_trs_len=length(short_trs);


% next generate the two long training symbols

long_tr = sim_consts.LongTrainingSymbols;
long_tr_symbol = tx_freqd_to_timed(long_tr);

if ~sim_options.UseTxDiv
   % single antenna preamble
   % extend with the 2*guard interval in front and then two long training symbols 
   long_trs_signal = [long_tr_symbol(64-2*16+1:64) long_tr_symbol long_tr_symbol];
else
   % generate the two antenna preamble,
   % long training symbols are not transmitted simultaneously from both antennas to allow
   % channel estimation in receiver
   long_trs_signal(1,:) = sqrt(2)*[long_tr_symbol(64-16+1:64) long_tr_symbol ...
         zeros(1,80)];
   long_trs_signal(2,:) = sqrt(2)*[zeros(1,80) ...
         long_tr_symbol(64-16+1:64) long_tr_symbol];
end

% concatenate first short training symbols and long training symbols
preamble(1,:) = [short_trs(1,:) long_trs_signal(1,:)];

% add the second antenna preamble
if sim_options.UseTxDiv
   preamble(2,:) = [short_trs(1,:) long_trs_signal(2,:)];
end
