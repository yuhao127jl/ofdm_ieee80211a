//**********************************************************
// Project      : OFDM-IEEE 802.11a
// DesignModule : data_scramble.v
// Description  :
// Designer     :
// Date         : 
//**********************************************************

module data_scramble(
input			    sys_clk,
input			    sys_rstn,

input	[6:0]		scram_seed,
input			    scram_din,
input			    scram_load,
input			    scram_valid_i,

output	reg		    scram_dout,
output	reg		    scram_valid_o 
);

//***************************************************
//
// Internal Defination
//
//***************************************************
reg [6:0] scramble;

wire [6:0] scramble_in = scram_load ? scram_seed :    // initial scram_seed = 7'b1011101
			             (scram_valid_i) ? {scramble[5:0], scramble[6] + scramble[3]} : 7'd0;    // cyculatory left shift 
assign scram_dout_in = scram_valid_i ? scram_din + scramble[6] + scramble[3] : 1'd0;   // s(x) = 1 + x^4 + x^7
assign scram_valid_o_in = scram_valid_i ? 1'b1 : 1'd0; 


//***************************************************
//
// always
//
//***************************************************
always @(posedge sys_clk or negedge sys_rstn)
if(!sys_rstn)
begin
	scramble            <= #1 7'd0;
	scram_dout          <= #1 1'd0;
	scram_valid_o       <= #1 1'b0;
end
else
begin
	scramble            <= #1 scramble_in;
	scram_dout          <= #1 scram_dout_in;
	scram_valid_o       <= #1 scram_valid_o_in;
end


endmodule
//**********************************************************
//
// END Of Module
//
//**********************************************************
