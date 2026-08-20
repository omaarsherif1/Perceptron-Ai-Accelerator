module fsm_controller (clk,rst_n,start,data_valid,done,mac_en,clear);
    
	localparam IDLE = 3'd0 ;
    localparam MAC = 3'd1 ;
    localparam ADD = 3'd2 ;
    localparam RelU = 3'd3 ;   
    localparam COMPLETED = 3'd4 ;
    parameter N = 8;    // number of inputs
    
	input start,data_valid,clk,rst_n;
    output done,mac_en,clear;
    
	reg [2:0] cs,ns;
    reg [$clog2(N)-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) cs <= IDLE;
        else cs <= ns;
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            count <= 3'd0;
        else if (cs == IDLE || cs == COMPLETED ) count <= 3'd0;
        else if ( cs == MAC && data_valid == 1'b1) count <= count + 1'b1;
    end
    
    always @(*) begin
        ns = cs;
        case (cs)
        IDLE: 
            if (start == 1'b1) ns = MAC;
        MAC: 
            if (data_valid == 1'b1 && count == N-1) ns = ADD;
        ADD:
            ns = RelU;
        RelU:
            ns = COMPLETED;
        COMPLETED:
            if (start == 0) ns = IDLE;
        default: 
            ns = IDLE;
        endcase
    end
    assign done = (cs == COMPLETED);
    assign mac_en = (cs == MAC && data_valid == 1'b1);  // tell mac to accumulate only on valid data
    assign clear = (cs == IDLE);    // hold mac unit while waiting
endmodule
