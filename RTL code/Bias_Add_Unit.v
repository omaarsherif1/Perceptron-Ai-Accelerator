module Bias_Add_Unit#(parameter DATA_WIDTH = 8,parameter ACC_WIDTH = 32)
( input wire signed [DATA_WIDTH-1:0] bias, 
  input wire signed [ACC_WIDTH-1:0] acc,
  output wire signed [ACC_WIDTH-1:0] final_sum  
);    
 wire signed [ACC_WIDTH-1:0] bias_32;  
 assign bias_32 = {{(ACC_WIDTH-DATA_WIDTH){bias[DATA_WIDTH-1]}},bias} ;
 assign final_sum = acc + bias_32 ;
endmodule