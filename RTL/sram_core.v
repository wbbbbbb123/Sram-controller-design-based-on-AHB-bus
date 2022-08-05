`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/17 16:52:15
// Design Name: 
// Module Name: sram_core
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


module sram_core(
    //input signals
    input			    hclk,
    input			    sram_clk,
    input			    hresetn,

    input			    sram_wen,        // =1 读sram; =0,写sram.
    input	[12:0]	    sram_addr,       //物理地址 = 系统地址 / 4
    input	[31:0]	    sram_wdata_in,   //data write into sram when "sram_wen_in" active low
    input               bank_sel,        //bank_sel为1代表bank0被访问；bank_sel为0代表bank1被访问
    input	[3:0]	    bank0_csn,       //两个bank,每个bank有四个片选
    input	[3:0]	    bank1_csn,
    input			    bist_en,         //BIST test mode//用不上
    input	    	    dft_en,          //DFT test mode//用不上
          
    //output signals
    output [7:0]	sram_q0,
    output [7:0]	sram_q1,
    output [7:0]	sram_q2,
    output [7:0]	sram_q3,
    output [7:0]	sram_q4,
    output [7:0]	sram_q5,
    output [7:0]	sram_q6,
    output [7:0]	sram_q7,
                    
    output			bist_done,  //When "bist_done" is high, it shows BIST test is over.
    output [7:0]    bist_fail   //"bist_fail" shows the results of each sram funtions.
);
 
    //data_in sram_csn
    reg [7:0] sram_cs0_data_in;
    reg [7:0] sram_cs1_data_in;
    reg [7:0] sram_cs2_data_in;
    reg [7:0] sram_cs3_data_in;
    reg [7:0] sram_cs4_data_in;
    reg [7:0] sram_cs5_data_in;
    reg [7:0] sram_cs6_data_in;
    reg [7:0] sram_cs7_data_in;
 
    //Every sram bist's work state and results output.
    wire bist_done0;
    wire bist_fail0;
    wire bist_done1;
    wire bist_fail1;
    wire bist_done2;
    wire bist_fail2;
    wire bist_done3;
    wire bist_fail3;
    wire bist_done4;
    wire bist_fail4;
    wire bist_done5;
    wire bist_fail5;
    wire bist_done6;
    wire bist_fail6;
    wire bist_done7;
    wire bist_fail7;

    wire bank0_bistdone;
    wire bank1_bistdone;

    wire [3:0] bank0_bistfail;
    wire [3:0] bank1_bistfail;

    //bist finishing state of bank0
    assign bank0_bistdone = (bist_done3 && bist_done2) && (bist_done1 && bist_done0);

    //bist results of bank0
    assign bank0_bistfail = {bist_fail3,bist_fail2,bist_fail1,bist_fail0};

    //bist finishing state of bank1
    assign bank1_bistdone = (bist_done7 && bist_done6) && (bist_done5 && bist_done4);

    //bist results of bank1
    assign bank1_bistfail = {bist_fail7,bist_fail6,bist_fail5,bist_fail4};

    //--------------------------------------------------------------------------
    //the 8 srams results of BIST test and the finishing state
    //--------------------------------------------------------------------------
    assign bist_done = bank0_bistdone && bank1_bistdone;
    assign bist_fail = {bank1_bistfail,bank0_bistfail} ;
    //write data in bank cs 
    
//    assign sram_cs0_data_in = (~sram_wen&~bank0_csn[0]&bank_sel) ?sram_wdata_in[7:0]    :{8{1'bz}};
//    assign sram_cs1_data_in = (~sram_wen&~bank0_csn[1]&bank_sel) ?sram_wdata_in[15:8]   :{8{1'bz}};
//    assign sram_cs2_data_in = (~sram_wen&~bank0_csn[2]&bank_sel) ?sram_wdata_in[23:16]  :{8{1'bz}};
//    assign sram_cs3_data_in = (~sram_wen&~bank0_csn[3]&bank_sel) ?sram_wdata_in[31:24]  :{8{1'bz}};
//    assign sram_cs4_data_in = (~sram_wen&~bank1_csn[0]&~bank_sel)?sram_wdata_in[7:0]    :{8{1'bz}};
//    assign sram_cs5_data_in = (~sram_wen&~bank1_csn[1]&~bank_sel)?sram_wdata_in[15:8]   :{8{1'bz}};
//    assign sram_cs6_data_in = (~sram_wen&~bank1_csn[2]&~bank_sel)?sram_wdata_in[23:16]  :{8{1'bz}};
//    assign sram_cs7_data_in = (~sram_wen&~bank1_csn[3]&~bank_sel)?sram_wdata_in[31:24]  :{8{1'bz}};

    
    //write data in bank cs     
    always@(*)begin
        if(!hresetn)begin
			sram_cs0_data_in = 8'd0;
			sram_cs1_data_in = 8'd0;
            sram_cs2_data_in = 8'd0;
            sram_cs3_data_in = 8'd0;
            sram_cs4_data_in = 8'd0;
            sram_cs5_data_in = 8'd0;
            sram_cs6_data_in = 8'd0;
            sram_cs7_data_in = 8'd0;
        end    
        else begin
            if(bank_sel)begin//bank_sel为1代表bank0被访问；bank_sel为0代表bank1被访问
                case(bank0_csn)
                    //8bit data in 
                    4'b1110:begin
                        sram_cs0_data_in = sram_wdata_in[7:0];
                    end
                    4'b1101:begin
                        sram_cs1_data_in = sram_wdata_in[7:0];
                    end
                    4'b1011:begin
                        sram_cs2_data_in = sram_wdata_in[7:0];
                    end
                    4'b0111:begin
                        sram_cs3_data_in = sram_wdata_in[7:0];
                    end               
                    //16bit data in 
                    4'b1100:begin
                        sram_cs0_data_in = sram_wdata_in[7:0];
                        sram_cs1_data_in = sram_wdata_in[15:8];
                    end
                    4'b0011:begin
                        sram_cs2_data_in = sram_wdata_in[7:0];
                        sram_cs3_data_in = sram_wdata_in[15:8];
                    end  
                    //32bit data in              
                    4'b0000:begin
                        sram_cs0_data_in = sram_wdata_in[7:0];
                        sram_cs1_data_in = sram_wdata_in[15:8];                
                        sram_cs2_data_in = sram_wdata_in[23:16];
                        sram_cs3_data_in = sram_wdata_in[31:24];
                    end 
                    default:;              
                endcase
            end
            else begin
                case(bank1_csn)
                    //8bit data in 
                    4'b1110:begin
                        sram_cs4_data_in = sram_wdata_in[7:0];
                    end
                    4'b1101:begin
                        sram_cs5_data_in = sram_wdata_in[7:0];
                    end
                    4'b1011:begin
                        sram_cs6_data_in = sram_wdata_in[7:0];
                    end
                    4'b0111:begin
                        sram_cs7_data_in = sram_wdata_in[7:0];
                    end               
                    //16bit data in 
                    4'b1100:begin
                        sram_cs4_data_in = sram_wdata_in[7:0];
                        sram_cs5_data_in = sram_wdata_in[15:8];
                    end
                    4'b0011:begin
                        sram_cs6_data_in = sram_wdata_in[7:0];
                        sram_cs7_data_in = sram_wdata_in[15:8];
                    end  
                    //32bit data in              
                    4'b0000:begin
                        sram_cs4_data_in = sram_wdata_in[7:0];
                        sram_cs5_data_in = sram_wdata_in[15:8];                
                        sram_cs6_data_in = sram_wdata_in[23:16];
                        sram_cs7_data_in = sram_wdata_in[31:24];
                    end 
                    default:;              
                endcase
            end
        end
    end
    //-------------------------------------------------------------------------
    //Instance 8 srams and each provides with BIST and DFT functions. 
    //Bank0 comprises of sram0~sram3, and bank1 comprises of sram4~sram7. 
    //In each bank, the sram control signals broadcast to each sram, and data
    //written per byte into each sram in little-endian style.
    //-------------------------------------------------------------------------
 
    //bank0_cs0
    sram_bist u_sram_bist0(
        .hclk             (hclk            ),
        .sram_clk         (sram_clk        ),
        .sram_rst_n       (hresetn         ),
        .sram_csn_in      (bank0_csn[0]    ),
        .sram_wen_in      (sram_wen        ),
        .sram_addr_in     (sram_addr       ),
        .sram_wdata_in    (sram_cs0_data_in),
        .bist_en          (bist_en         ),
        .dft_en           (dft_en          ),
                    
        .sram_data_out    (sram_q0         ),
        .bist_done        (bist_done0      ),
        .bist_fail        (bist_fail0      )  
        );
    //bank0_cs1
    sram_bist u_sram_bist1(
        .hclk             (hclk            ),
        .sram_clk         (sram_clk        ),
        .sram_rst_n       (hresetn         ),
        .sram_csn_in      (bank0_csn[1]    ),
        .sram_wen_in      (sram_wen        ),
        .sram_addr_in     (sram_addr       ),
        .sram_wdata_in    (sram_cs1_data_in),
        .bist_en          (bist_en         ),
        .dft_en           (dft_en          ),
                    
        .sram_data_out    (sram_q1         ),
        .bist_done        (bist_done1      ),
        .bist_fail        (bist_fail1      )  
        );
    //bank0_cs2
    sram_bist u_sram_bist2(
        .hclk             (hclk            ),
        .sram_clk         (sram_clk        ),
        .sram_rst_n       (hresetn         ),
        .sram_csn_in      (bank0_csn[2]    ),
        .sram_wen_in      (sram_wen        ),
        .sram_addr_in     (sram_addr       ),
        .sram_wdata_in    (sram_cs2_data_in),
        .bist_en          (bist_en         ),
        .dft_en           (dft_en          ),
                    
        .sram_data_out    (sram_q2),
        .bist_done        (bist_done2),
        .bist_fail        (bist_fail2)  
        );
    //bank0_cs3
    sram_bist u_sram_bist3(
        .hclk             (hclk            ),
        .sram_clk         (sram_clk        ),
        .sram_rst_n       (hresetn         ),
        .sram_csn_in      (bank0_csn[3]    ),
        .sram_wen_in      (sram_wen        ),
        .sram_addr_in     (sram_addr       ),
        .sram_wdata_in    (sram_cs3_data_in),
        .bist_en          (bist_en         ),
        .dft_en           (dft_en          ),
                    
        .sram_data_out    (sram_q3         ),
        .bist_done        (bist_done3      ),
        .bist_fail        (bist_fail3      )  
        );
    //bank1_cs4
    sram_bist u_sram_bist4(
        .hclk             (hclk            ),
        .sram_clk         (sram_clk        ),
        .sram_rst_n       (hresetn         ),
        .sram_csn_in      (bank1_csn[0]    ),
        .sram_wen_in      (sram_wen        ),
        .sram_addr_in     (sram_addr       ),
        .sram_wdata_in    (sram_cs4_data_in),
        .bist_en          (bist_en         ),
        .dft_en           (dft_en          ),
                    
        .sram_data_out    (sram_q4         ),
        .bist_done        (bist_done4      ),
        .bist_fail        (bist_fail4      )  
        );
    //bank1_cs5
    sram_bist u_sram_bist5(
        .hclk             (hclk            ),
        .sram_clk         (sram_clk        ),
        .sram_rst_n       (hresetn         ),
        .sram_csn_in      (bank1_csn[1]    ),
        .sram_wen_in      (sram_wen        ),
        .sram_addr_in     (sram_addr       ),
        .sram_wdata_in    (sram_cs5_data_in),
        .bist_en          (bist_en         ),
        .dft_en           (dft_en          ),
                    
        .sram_data_out    (sram_q5         ),
        .bist_done        (bist_done5      ),
        .bist_fail        (bist_fail5      )  
        );
    //bank1_cs6
    sram_bist u_sram_bist6(
        .hclk             (hclk            ),
        .sram_clk         (sram_clk        ),
        .sram_rst_n       (hresetn         ),
        .sram_csn_in      (bank1_csn[2]    ),
        .sram_wen_in      (sram_wen        ),
        .sram_addr_in     (sram_addr       ),
        .sram_wdata_in    (sram_cs6_data_in),
        .bist_en          (bist_en         ),
        .dft_en           (dft_en          ),
                    
        .sram_data_out    (sram_q6         ),
        .bist_done        (bist_done6      ),
        .bist_fail        (bist_fail6      )  
        );
    //bank1_cs7        
    sram_bist u_sram_bist7(
        .hclk             (hclk            ),
        .sram_clk         (sram_clk        ),
        .sram_rst_n       (hresetn         ),
        .sram_csn_in      (bank1_csn[3]    ),
        .sram_wen_in      (sram_wen        ),
        .sram_addr_in     (sram_addr       ),
        .sram_wdata_in    (sram_cs7_data_in),
        .bist_en          (bist_en         ),
        .dft_en           (dft_en          ),
                        
        .sram_data_out    (sram_q7         ),
        .bist_done        (bist_done7      ),
        .bist_fail        (bist_fail7      )  
        );

endmodule