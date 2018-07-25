function [n_tx_antennas, n_rx_antennas] = get_n_antennas(sim_options)

if sim_options.UseTxDiv
   n_tx_antennas = 2;
else
   n_tx_antennas = 1;
end


if sim_options.UseRxDiv
   n_rx_antennas = 2;
else
   n_rx_antennas = 1;
end


