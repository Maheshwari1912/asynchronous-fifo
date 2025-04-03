module fifo_memory #(parameter ptr_width=11, parameter data_width=32, parameter depth=1024)
(
    input wclk,                      
    input [data_width-1:0] wdata, 
    input wen,ren,
    input [ptr_width-2:0]waddr,                        //memory
    input [ptr_width-2:0]raddr,  
    input full,empty,
    output [data_width-1:0] rdata);  
  
    reg [data_width-1:0] mem [0:depth-1]; 
    
   
   always @(posedge wclk) begin
        if (wen && !full) begin
         mem[waddr] <= wdata;  
         end
       end
        assign rdata= (ren && !empty)? mem[raddr]: rdata; 
       
       
endmodule
