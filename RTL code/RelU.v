module RelU#(parameter ACC_WIDTH = 32)(
    input wire signed [ACC_WIDTH-1:0] final_sum,
    output wire signed [ACC_WIDTH-1:0] RelU_out
);

assign RelU_out=(final_sum[ACC_WIDTH-1]==1)? 0 : final_sum ;

endmodule