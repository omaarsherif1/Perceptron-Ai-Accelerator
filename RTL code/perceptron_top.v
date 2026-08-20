module perceptron_top
#(
  parameter DATA_WIDTH = 8,
  parameter ACC_WIDTH = 32,
  parameter N = 8
)
(
  input wire                                clk,
  input wire                              rst_n,
  input wire                              start,
  input wire                         data_valid,
  input wire signed  [DATA_WIDTH-1 : 0]    x_in,
  input wire signed  [DATA_WIDTH-1 : 0]    w_in,
  input wire signed  [DATA_WIDTH-1 : 0]    bias,
  
  
  output wire signed [ACC_WIDTH-1 : 0] final_output,
  output wire                                  done 
);

  wire mac_en_sig;
  wire mac_clear_sig;
  wire signed [ACC_WIDTH-1 : 0] mac_to_bias_sum;
  wire signed [ACC_WIDTH-1 : 0] bias_to_relu_sum;
  
  
  fsm_controller 
  #(.N(N))
  top_fsm
  (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .data_valid(data_valid),
    .done(done),
    .mac_en(mac_en_sig),
    .clear(mac_clear_sig)
  );
  
  mac_unit
  #(
     .DATA_WIDTH(DATA_WIDTH),
     .ACC_WIDTH(ACC_WIDTH)
   )
  top_mac_unit
  (
    .x_in(x_in),
	.w_in(w_in),
	.clk(clk),
	.rst_n(rst_n),
	.mac_en(mac_en_sig),
	.mac_clear(mac_clear_sig),
	.mac_out(mac_to_bias_sum)
  );
  
  
  Bias_Add_Unit
  #(
     .DATA_WIDTH(DATA_WIDTH),
     .ACC_WIDTH(ACC_WIDTH)
   )
  top_Bias_Add_Unit
  (
    .bias(bias),
	.acc(mac_to_bias_sum),
	.final_sum(bias_to_relu_sum)
  );
  
  
   RelU
   #(.ACC_WIDTH(ACC_WIDTH))
   top_RelU
   (
    .final_sum(bias_to_relu_sum),
	.RelU_out(final_output)
   );
  
endmodule
  



