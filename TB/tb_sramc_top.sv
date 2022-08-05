`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/18 08:58:00
// Design Name: 
// Module Name: tb_sramc_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`define START_ADDR   8192//32bit:0~2*8192-1、16bit:0~4*8192-1、8bit:0~8*8192-1
`define DATA_SIZE    16  
`define IS_SEQ       1   //1：SEQ write、read  0：NOSEQ write、read（STL中两种都一样）


class random_data;
    rand  bit [`DATA_SIZE-1:0] data;
    rand  bit [`DATA_SIZE-1:0] delay;
    constraint c_delay{
        delay <=50;
    }
endclass

module tb_sramc_top();

//interface define
reg           hclk       ;//产生时钟信号
wire          sram_clk   ;//hclk 的反向，与hclk属于同一个时钟沿
reg           hresetn    ;//复位
reg           hsel       ;//选中该slave
reg           hwrite     ;//读写模式0:读、1:写
reg [1:0]     htrans     ;//传输是否有效00:空闲、01:忙、10:非连续、11:连续
reg [2:0]     hsize      ;//有效传输位00：8bit、01：16bit、10：32bit
reg           hready     ;// master -> slave，一般接常高
reg [31:0]    haddr      ;//本次命令访问的地址
reg [31:0]    hwdata     ;// 写数据
wire [31:0]   hrdata     ;// 从sram读出的数据
wire          hready_resp;// slave -> master，看 slave 是否ready
wire [1:0]    hresp      ;// hresp 也只会返回0，即ok状态。

reg  [`DATA_SIZE-1:0]   rdata      ;//读出数据
static int wr_iter = 0 ;
static int rd_iter = 0 ;
//reg [`DATA_SIZE-1:0] data;

always #10 hclk = ~hclk;
assign     sram_clk = ~hclk;

random_data  rm_data;




initial begin
    hclk  =1;
    hresetn = 0;
    #200
    hresetn = 1;
end

initial begin:process
    rm_data = new();
    direct_write_during_read(16'd8);
    #200;
    loop_wr_rd_data(16'd18);
    
    $finish;
end

task ahb_init();
    hsel   = 1'b0 ;//未中该slave
    hwrite = 1'b1 ;//写
    htrans = `IS_SEQ?2'b11:2'b10;
    hsize  = (`DATA_SIZE==32)?2'b10:((`DATA_SIZE==16)?2'b01:((`DATA_SIZE==8)?2'b00:2'b10));//00:8bit、01:16bit、10:32bit、11:32bit
    hready = 1'b1;
    haddr  = 32'd0;
    hwdata = 32'd0;
    rdata  = 32'd0;
    wait(hresetn);
    repeat(3)@(posedge hclk);
endtask




task write_data;
input [15:0] wr_nums;
begin
    repeat(wr_nums)begin
        @(posedge hclk);
        rm_data.randomize();
        hsel   = 1'b1 ;//选中该slave
        hwrite = 1'b1 ;//写
        haddr  =  `START_ADDR + wr_iter;
        hwdata = rm_data.data;
        wr_iter = wr_iter +1;
    end
end
endtask


task read_data;
input [15:0] rd_nums;
begin
    repeat(rd_nums)begin
        @(posedge hclk);
        fork
            begin
                hsel   = 1'b1 ;//选中该slave
                hwrite = 1'b0;//read
                haddr  =  `START_ADDR + rd_iter;//bank1 cs0
                rd_iter = rd_iter +1;
            end
            begin
                @(posedge hclk); 
                rdata = hrdata; 
            end   
        join_any 
        //wait fork;
    end
    //@(posedge hclk);
end
endtask

task direct_write_during_read;
input [15:0] wr_nums;//读写次数
begin
    ahb_init();
    repeat(wr_nums)begin
        write_data(1);
        read_data(1);
    end
    @(posedge hclk);
    ahb_init();
    #200;
end 
endtask

task loop_wr_rd_data;
input [15:0] wr_nums;
begin
    ahb_init();
    write_data(wr_nums);
    #rm_data.delay;
    read_data(wr_nums);
    @(posedge hclk);
    ahb_init();
    #200;
end
endtask




sramc_top   u_sramc_top(                 
          .hclk           (hclk      ),    //input
          .sram_clk       (sram_clk   ),   //input
          .hresetn        (hresetn    ),   //input
          .hsel           (hsel       ),   //input
          .hwrite         (hwrite     ),   //input
          .htrans         (htrans     ),   //input [1:0]
          .hsize          (hsize      ),   //input [2:0]
          .hready         (hready     ),   //input
          .haddr          (haddr      ),   //input [31:0]
          .hwdata         (hwdata     ),   //input [31:0]
          .hrdata         (hrdata     ),   //output [31:0]
          .hready_resp    (hready_resp),   //output           
          .hresp          (hresp      ),   //output [1:0]   
             
          .hburst         (3'b0),      	   //burst没用的话就接0，在tr里面激励产生什么都关系不大了              
          .dft_en         (1'b0),      	   //不测    dft不测，写成0        
          .bist_en        (1'b0),          //不测
          .bist_done      ( ),             //不测              
          .bist_fail      ( )          	   //不测
);

endmodule

