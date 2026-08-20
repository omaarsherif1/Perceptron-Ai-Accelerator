
`timescale 1ns/100ps

module tb_mac_unit;

parameter clkPeriod  = 10;
parameter DATA_WIDTH = 8;
parameter ACC_WIDTH  = 32;

reg                             clk;
reg                             rst_n;
reg                             mac_en;
reg                             mac_clear;
reg signed [(DATA_WIDTH - 1):0] x_in;
reg signed [(DATA_WIDTH - 1):0] w_in;
wire signed [(ACC_WIDTH - 1):0] mac_out;

mac_unit #(
	.DATA_WIDTH(DATA_WIDTH),
	.ACC_WIDTH(ACC_WIDTH)
)
DUT (
	.x_in      (x_in),
    .w_in      (w_in),
    .clk       (clk),
    .rst_n     (rst_n),
    .mac_en    (mac_en),
    .mac_clear (mac_clear),
    .mac_out   (mac_out)
);

always #(clkPeriod/2) clk = ~clk;

initial 
begin
$monitor("Time = %t|x = %d|w = %d|output = %d",$time,x_in,w_in,mac_out);
	clk = 0; rst_n = 0; mac_en = 0; mac_clear = 0; x_in = 8'd0; w_in = 8'd0;
	#(clkPeriod); //t=1
	
	mac_en = 1; mac_clear = 1; x_in = 8'd5; w_in = 8'd3;
	#(clkPeriod); //t=2
	
	rst_n = 1; mac_en = 0; mac_clear = 1; x_in = 8'd0; w_in = 8'd0;
	#(clkPeriod); //t=3
	
	rst_n = 1; mac_en = 1; mac_clear = 1; x_in = 8'd4; w_in = 8'd4;
	#(clkPeriod); //t=4
	
	rst_n = 1; mac_en = 0; mac_clear = 0; x_in = 8'd9; w_in = 8'd9;
	#(clkPeriod); //t=5
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = 8'd0; w_in = 8'd0;
	#(clkPeriod); //t=6
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = 8'd5; w_in = 8'd3;
	#(clkPeriod); //t=7
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = -8'sd5; w_in = 8'd3;
	#(clkPeriod); //t=8
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = 8'd5; w_in = -8'sd3;
	#(clkPeriod); //t=9
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = -8'sd5; w_in = -8'sd3;
	#(clkPeriod); //t=10
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = 8'd127; w_in = 8'd127;
	#(clkPeriod); //t=11
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = -8'sd128; w_in = -8'sd128;
	#(clkPeriod); //t=12
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = -8'sd128; w_in = 8'd127;
	#(clkPeriod); //t=13
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = 8'd1; w_in = -8'sd128;
	#(clkPeriod); //t=14
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = 8'd10; w_in = 8'd5;
	#(clkPeriod); //t=15
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = -8'sd10; w_in = 8'd8;
	#(clkPeriod); //t=16
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = 8'd5; w_in = 8'd2;
	#(clkPeriod); //t=17
	
	rst_n = 1; mac_en = 1; mac_clear = 0; x_in = 8'd0; w_in = 8'd0;
	#(clkPeriod); //t=18	
	#(clkPeriod);
	$stop;
end
endmodule
 


