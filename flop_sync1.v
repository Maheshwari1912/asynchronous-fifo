module flop_sync#(parameter ptr_width = 11)  //write
 (input wclk, wrst_n,
 input [ptr_width-1:0] rptr_g,
 output reg [ptr_width-1:0] wq2_rptr);
 reg [ptr_width-1:0] wq1_rptr;
 wire [ptr_width-1:0]w_rptr;
 always @(posedge wclk or negedge wrst_n)begin
 if (!wrst_n)begin
 wq1_rptr <= 0;
 wq2_rptr <=0;end
 else begin
 wq1_rptr <= rptr_g;
 wq2_rptr <=wq1_rptr;
 end
 end
 assign w_rptr = wq2_rptr[ptr_width-1:0] ;
endmodule
