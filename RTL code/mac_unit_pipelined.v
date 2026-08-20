module mac_unit #
(
   parameter DATA_WIDTH = 8,
   parameter ACC_WIDTH  = 32
)
(
   // in Ports
   input  wire signed [(DATA_WIDTH - 1):0] x_in,
   input  wire signed [(DATA_WIDTH - 1):0] w_in,
   input  wire clk,
   input  wire rst_n,
   input  wire mac_en, 
   input  wire mac_clear,

   // Output port
   output reg  signed [(ACC_WIDTH - 1):0] mac_out
);
  reg signed [(2*DATA_WIDTH)-1 : 0] mult_pipe_reg;
  reg mac_en_d;

   always @(posedge clk or negedge rst_n) begin 
      if (!rst_n) begin
	     mult_pipe_reg <= 16'sd0;
		 mac_en_d <= 1'b0;
         mac_out <= {ACC_WIDTH{1'b0}};
      end
      else if (mac_clear) begin
	     mult_pipe_reg <= 16'sd0;
		 mac_en_d <= 1'b0;
         mac_out <= {ACC_WIDTH{1'b0}};
      end
      else  begin
	     mult_pipe_reg <= x_in * w_in;
		 mac_en_d <= mac_en;
      if(mac_en_d) begin
	  mac_out <= mac_out + $signed({{(ACC_WIDTH - 2*DATA_WIDTH){mult_pipe_reg[(2*DATA_WIDTH)-1]}}, mult_pipe_reg});
	  end
	  end
   end

endmodule
