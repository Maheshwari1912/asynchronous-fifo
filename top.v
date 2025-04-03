module async_fifo #(parameter depth=1024, parameter data_width=32, parameter ptr_width=11)
(
    input wclk,wrst_n,rclk,rrst_n,                            
    input [data_width-1:0] wdata,  
    input wen,ren,  
    output [data_width-1:0] rdata,  
    output rempty,wfull,
    output overflow,underflow ,almostfull,almostempty
                                                       //top_module
);
    wire [ptr_width-1:0]wptr,rptr;
    wire [ptr_width-1:0] wptr_g,rptr_g;
    wire [ptr_width-1:0] wq2_rptr, rq2_wptr;
    wire [ptr_width-2:0] waddress,raddress;
    reg [ptr_width-1:0] wptr_bi, rptr_bi;
    integer i;
    
    fifo_memory #(ptr_width,data_width,depth)fifo_mem (.wclk(wclk),.wdata(wdata),.wen(wen),.ren(ren),.full(wfull),.empty(rempty),.waddr(waddress),.raddr(raddress),.rdata(rdata));

    flop_sync #(ptr_width) sync_w2r(.wclk(wclk),.wrst_n(wrst_n),.rptr_g(rptr_g),.wq2_rptr(wq2_rptr));

    flop_sync_1 #(ptr_width) sync_r2w (.rclk(rclk),.rrst_n(rrst_n),.wptr_g(wptr_g),.rq2_wptr(rq2_wptr));

    w_domain #(ptr_width) w_d (.wclk(wclk),.wrst_n(wrst_n),.wen(wen),.wfull(wfull), .w_wptr(wq2_rptr),.waddr(waddress),.wptr(wptr),.wptr_g(wptr_g));

    r_domain #(ptr_width) r_d (.rclk(rclk),.rrst_n(rrst_n),.ren(ren),.rempty(rempty),.w_rptr(rq2_wptr),.raddr(raddress),.rptr(rptr),.rptr_g(rptr_g));
    
     always @(*) begin
     rptr_bi[ptr_width-1] = wq2_rptr[ptr_width-1]; 
    for (i = ptr_width-2; i >= 0; i = i - 1) begin
        rptr_bi[i] = rptr_bi[i + 1] ^ wq2_rptr[i]; 
    end
end
    always @(*) begin
    wptr_bi[ptr_width-1] = rq2_wptr[ptr_width-1]; 
    for (i = ptr_width-2; i >= 0; i = i - 1) begin
        wptr_bi[i] = wptr_bi[i + 1] ^ rq2_wptr[i]; 
    end
end
    assign overflow = wfull && wen;
    assign underflow = rempty && ren;
    //assign almostfull = (wptr >= (rptr + 11'd1000)) && !wfull;
    assign  almostempty = ((wptr_bi-rptr) <= 11'd24);

   assign almostfull = ((wptr-rptr_bi) >= 1000 &&(wptr-rptr_bi) <= 1023) ? 1'b1 : 1'b0;

   endmodule
