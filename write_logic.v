module w_domain #(                         //write_domain
parameter ptr_width=11,depth=1024)
(input wen,wclk,wrst_n,
input [ptr_width-1:0]w_wptr,
output wfull,
output reg [ptr_width-2:0]waddr,
output reg [ptr_width-1:0]wptr,
output [ptr_width-1:0]wptr_g);
//flop_sync#(ptr_width) f1 (.wclk(wclk), .wrst_n(wrst_n),.wq2_rptr(sync_r));
always@(posedge wclk or negedge wrst_n)begin
if(!wrst_n)begin
wptr<=0;
waddr<=0;end
else if(wen && !wfull)begin
wptr<=(wptr+1);
waddr<=(waddr+1);
end
/*else begin
wptr<=(wptr+1)%depth;
waddr<=(waddr+1)%depth;
end*/
end

assign wfull = (wptr_g == {~w_wptr[ptr_width-1:ptr_width-2], w_wptr[ptr_width-3:0]});

assign wptr_g= wptr^(wptr>>1);
endmodule

