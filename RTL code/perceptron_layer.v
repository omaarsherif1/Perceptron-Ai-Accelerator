`timescale 1ns / 1ps
module perceptron_layer
#(
  parameter DATA_WIDTH = 8,
  parameter ACC_WIDTH = 32,
  parameter N = 8,
  parameter NUM_NEURONS = 4
)
(
  input wire                                clk,
  input wire                              rst_n,
  input wire                              start,
  input wire                         data_valid,
  input wire signed  [DATA_WIDTH-1 : 0]    x_in,
  
  input  wire signed [(NUM_NEURONS*DATA_WIDTH)-1:0] w_in_flat,
  input  wire signed [(NUM_NEURONS*DATA_WIDTH)-1:0] bias_flat,

  output wire signed [(NUM_NEURONS*ACC_WIDTH)-1:0]  out_flat,
  output wire                                     layer_done
);

  wire [NUM_NEURONS-1 : 0] done_bus;
  genvar i;
  
  
  generate
    for(i=0 ; i < NUM_NEURONS ; i = i + 1)
	  begin : perceptron_array
	    perceptron_top
		#(
		  .DATA_WIDTH(DATA_WIDTH),
		  .ACC_WIDTH(ACC_WIDTH),
		  .N(N)
		 )
		 u_perceptron
		 (
		    .clk(clk),
            .rst_n(rst_n),
            .start(start),
            .data_valid(data_valid),
            .x_in(x_in),

            .w_in(w_in_flat[i*DATA_WIDTH +: DATA_WIDTH]),
            .bias(bias_flat[i*DATA_WIDTH +: DATA_WIDTH]),
            .final_output(out_flat[i*ACC_WIDTH +: ACC_WIDTH]),
            .done(done_bus[i])			
		 );
      end
	endgenerate
	
	
  assign layer_done = &done_bus;

endmodule