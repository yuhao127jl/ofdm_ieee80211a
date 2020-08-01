function ui_run_sim

sim_options = ui_read_options;
feval('runsim', sim_options);
