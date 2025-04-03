module r_domain #(                               //read_domain
parameter ptr_width=11,depth=1024)
(input rclk,rrst_n,ren,
input [ptr_width-1:0]w_rptr,
output rempty,
output reg [ptr_width-1:0]rptr,
output reg [ptr_width-2:0]raddr,
output [ptr_width-1:0]rptr_g);

//flop_sync_1 #(ptr_width) f2 (.rclk(rclk), .rrst_n(rrst_n),.rq2_wptr(sync_w));
always@(posedge rclk or negedge rrst_n)
begin
if(!rrst_n)begin
rptr<=0;
raddr<=0;
end
else if(ren && !rempty)
begin
rptr<=(rptr+1);
raddr<=(raddr+1);
end
/*else begin
rptr<=(rptr+1)%depth;
raddr<=(raddr+1)%depth;
end*/
end
assign rempty=(rptr_g==w_rptr);
assign rptr_g=rptr^(rptr>>1);
endmodule
