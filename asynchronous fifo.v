module async_fifo #(parameter DATA_WIDTH=8,parameter ADDR_WIDTH=4)(
  input rst, wr_clk, rd_clk,
  input wr_en, rd_en,
  input [DATA_WIDTH-1:0] wr_data;
  output [DATA_WIDTH-1:0] rd_data;
  output reg full,empty);
  reg [DATA_WIDTH-1:0] mem [(1<<ADDR_WIDTH)-1:0];
  reg [ADDR_WIDTH:0] wr_ptr, rd_ptr;
  reg [ADDR_WIDTH:0] rd_ptr_sync1, rd_ptr_sync2;
  reg [ADDR_WIDTH:0] wr_ptr_sync1, wr_ptr_sync2;
  //write logic
  always @ (posedge wr_clk or posedge rst) begin
    if(rst) begin
      wr_ptr <=0;
    end else if(wr_en && !full) begin
      mem[wr_ptr[ADDR_WIDTH-1:0]] <=wr_data;
      wr_ptr <= wr_ptr+1;
    end
  end
  //read logic
  always @(posedge rd_clk or posedge rst) begin
    if(rst) begin
      rd_ptr <=0;
    end else if(rd_en && !empty) begin
      rd_data <= mem[rd_ptr[ADDR_WIDTH-1:0]];
      rd_ptr <= rd_ptr+1;
    end
  end
  always @(posedge wr_clk or posedge rst) begin
    if(rst) begin
      rd_ptr_sync1 <=0;
      rd_ptr_sync2 <=0;
    end else begin
      rd_ptr_sync1 <= rd_ptr;
      rd_ptr_sync2 <=rd_ptr_sync1;
    end
  end
  always @(posedge rd_clk or posedge rst) begin
    if(rst) begin
      wr_ptr_sync1 <=0;
      wr_ptr_sync2 <=0;
    end else begin
      wr_ptr_sync1 <= wr_ptr;
      wr_ptr_sync2 <=wr_ptr_sync1;
    end
  end
  //full and empty logic
  always@(*) begin
    full = (wr_ptr[ADDR_WIDTH-1:0]==rd_ptr_sync2[ADDR_WIDTH-1:0]) &&
           (wr_ptr[ADDR_WIDTH]!=rd_ptr_sync2[ADDR_WIDTH]);
  end
  always@(*) begin
    empty = (rd_ptr == wr_ptr_sync2);
  end
endmodule
