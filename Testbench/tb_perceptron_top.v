`timescale 1ns/100ps

module tb_perceptron_top;

 parameter clkPeriod  = 10;
 parameter DATA_WIDTH = 8;
 parameter ACC_WIDTH  = 32;
 parameter N          = 8;

  reg clk;
  reg rst_n;
  reg start;
  reg data_valid;
  reg signed [DATA_WIDTH-1:0] x_in;
  reg signed [DATA_WIDTH-1:0] w_in;
  reg signed [DATA_WIDTH-1:0] bias;

  wire signed [ACC_WIDTH-1:0] final_output;
  wire done;

  perceptron_top #(
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH),
    .N(N)
) DUT (
    .clk           (clk),
    .rst_n         (rst_n),
    .start         (start),
    .data_valid    (data_valid),
    .x_in          (x_in),
    .w_in          (w_in),
    .bias          (bias),
    .final_output  (final_output),
    .done          (done)
);

always #(clkPeriod/2) clk = ~clk;

always @(posedge done) begin
  $display("[t=%0t ps] Internal Raw Sum = %0d | final_output = %0d",$time, $signed(DUT.top_mac_unit.mac_out), final_output);
end 	

initial 
begin
$monitor("Time = %t|rst_n = %b|start = %b|data_valid = %b|x_in = %d|w_in = %d|bias = %d|done = %b|final_output = %d",$time,
rst_n,start,data_valid,x_in,w_in,bias,done,final_output);
	clk   = 0;       rst_n      = 0;
	start = 0;       data_valid = 0;
	x_in  = 8'sd1;   w_in       = 8'sd1;
	bias  = 0;
	
	#(clkPeriod*2); 
	rst_n = 1;
	x_in = 0; w_in = 0;
	
	//1st 8 input pairs
	#(clkPeriod);start = 1;  // 3shan el idle => mac 	
	#(clkPeriod); data_valid = 1;
	x_in  = 8'sd5;   w_in       = 8'sd4;
	#(clkPeriod); start = 0;
	x_in  = 8'sd3;   w_in       = 8'sd6;
	#(clkPeriod);
	x_in  = 8'sd2;   w_in       = 8'sd1;
	#(clkPeriod);
	x_in  = 8'sd4;   w_in       = 8'sd2;
	#(clkPeriod);
	x_in  = 8'sd1;   w_in       = 8'sd5;
	#(clkPeriod);
	x_in  = 8'sd6;   w_in       = 8'sd1;
	#(clkPeriod);
	x_in  = 8'sd2;   w_in       = 8'sd3;
	#(clkPeriod);
	x_in  = 8'sd3;   w_in       = 8'sd2;
	wait(done);	data_valid <= 0;

	
	//test for reset
	#(clkPeriod); rst_n = 0;
	#(clkPeriod); rst_n = 1;
	
	
	//2nd 8 pairs
	#(clkPeriod); start = 1;
	#(clkPeriod); data_valid = 1;
	x_in  = -8'sd10;   w_in       = 8'sd3;
	#(clkPeriod); start = 0;
	start = 0;
	x_in  = -8'sd5;   w_in       = 8'sd2;
	#(clkPeriod);
	x_in  = -8'sd3;   w_in       = 8'sd4;
	#(clkPeriod);
	x_in  = -8'sd1;   w_in       = 8'sd1;
	#(clkPeriod);
	x_in  = -8'sd2;   w_in       = 8'sd5;
	#(clkPeriod);
	x_in  = -8'sd4;   w_in       = 8'sd2;
	#(clkPeriod);
	x_in  = -8'sd1;   w_in       = 8'sd3;
	#(clkPeriod);
	x_in  = -8'sd2;   w_in       = 8'sd1;
	wait(done);	data_valid <= 0;


	// neg max*pos max
	#(clkPeriod); start = 1;
	#(clkPeriod); data_valid = 1;
	x_in  = -8'sd128;   w_in       = 8'sd127;	
	#(clkPeriod); start = 0;
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	wait(done);	data_valid <= 0;
	


	//all max *
	#(clkPeriod*2); start = 1;
	#(clkPeriod); data_valid = 1;
	x_in  = 8'sd127;   w_in       = 8'sd127;
	#(clkPeriod); start = 0;
	x_in  = 8'sd127;   w_in       = 8'sd127;
	#(clkPeriod);
	x_in  = 8'sd127;   w_in       = 8'sd127;
	#(clkPeriod);
	x_in  = 8'sd127;   w_in       = 8'sd127;
	#(clkPeriod);
	x_in  = 8'sd127;   w_in       = 8'sd127;
	#(clkPeriod);
	x_in  = 8'sd127;   w_in       = 8'sd127;
	#(clkPeriod);
	x_in  = 8'sd127;   w_in       = 8'sd127;
	#(clkPeriod);
	x_in  = 8'sd127;   w_in       = 8'sd127;
	wait(done);	data_valid <= 0;
	

	
	#(clkPeriod); bias = -128;
	#(clkPeriod); start = 1;
	#(clkPeriod); data_valid = 1;
	x_in  = 8'sd5;   w_in       = 8'sd2;	
	#(clkPeriod); start = 0;
	x_in  = 8'sd5;   w_in       = 8'sd2;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	#(clkPeriod);
	x_in  = 8'sd0;   w_in       = 8'sd0;
	wait(done);	data_valid <= 0;
	


	#(clkPeriod*2);
	data_valid = 0; start = 0;
	
	#(clkPeriod);
	$stop;

end

endmodule