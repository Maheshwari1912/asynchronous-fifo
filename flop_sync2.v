module flop_sync_1#(parameter ptr_width = 11)   //read
 (input rclk, rrst_n,
 input [ptr_width-1:0] wptr_g,
 output reg [ptr_width-1:0] rq2_wptr);
 reg [ptr_width-1:0] rq1_wptr;
 wire [ptr_width-1:0]w_wptr;
 always @(posedge rclk or negedge rrst_n)begin
 if (!rrst_n)begin
  rq1_wptr<= 0;
 rq2_wptr<=0;
end
 else begin
 rq1_wptr<= wptr_g;
 rq2_wptr<=rq1_wptr;end
 end
 assign w_wptr = rq2_wptr[ptr_width-1:0] ;
endmodule
