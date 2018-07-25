//*********************************************
// Project      : OFDM-IEEE 802.11a
// DesignModule : conv_code.v
// Description  :
// Designer     :
// Date         : 
//*********************************************

module conv_code(
input			sys_clk,
input			sys_rstn,

input			data_in,
input			data_valid_i,

output	reg [1:0]	data_out,
output	reg		data_valid_o
);

//**************************************
//
// Internal Defination
//
//**************************************
reg [5:0] shift_reg;
wire [5:0] shift_reg_in = (data_valid_i) ? {shift_reg[4:0], data_in} : shift_reg;//cyculatory left shift

assign data_valid_o_in = data_valid_i;
assign data_out_in = (data_valid_i) ? {shift_reg[5] + shift_reg[2] + shift_reg[1] + shift_reg[0] + data_in, shift_reg[5] + shift_reg[4] + shift_reg[2] + shift_reg[1] + data_in} : data_out;

//**************************************
//
// register 
//
//**************************************
always @(posedge sys_clk or negedge sys_rstn)
if(!sys_rstn)
begin
	shift_reg <= #1 6'd0;
	data_valid_o <= #1 6'd0;
end
else
begin
	shift_reg <= #1 shift_reg_in;
end




endmodule
//*********************************************
//
// END Of Module
//
//*********************************************
