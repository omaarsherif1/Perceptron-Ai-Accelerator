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

   always @(posedge clk or negedge rst_n) begin 
      if (!rst_n) begin
         mac_out <= {ACC_WIDTH{1'b0}};
      end
      else if (mac_clear) begin
         mac_out <= {ACC_WIDTH{1'b0}};
      end
      else if (mac_en) begin
         mac_out <= mac_out + (x_in * w_in);
      end
   end

endmodule
