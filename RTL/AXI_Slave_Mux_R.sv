//=============================================================================
//
//Module Name:					AXI_Slave_Mux_R.sv
//Department:					Xidian University
//Function Description:	        AXI总线读通道从机用多路复用器
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana	Verdvana	Verdvana		  			2020-3-13
//V1.1		Verdvana	Verdvana	Verdvana		  			2020-3-16
//V1.2		Verdvana	Verdvana	Verdvana		  			2020-3-18
//
//------------------------------------------------------------------------------
//
//Version	Modified History
//V1.0		4个AXI4总线主设备接口；
//          8个AXI4总线从设备接口；
//          从设备地址隐藏与读写地址的高三位；
//          主设备仲裁优先级随上一次总线所有者向后顺延；
//          Cyclone IV EP4CE30F29C8上综合后最高时钟频率可达80MHz+。
//
//V1.1      优化电路结构，状态机判断主设备握手请求信号后直接输出到对应从设备，省去一层MUX；
//          数据、地址、ID、USER位宽可设置;
//          时序不变，综合后最高时钟频率提高至100MHz+。	
//
//V1.2      进一步优化电路结构，精简状态机的状态；
//          时序不变，综合后最高时钟频率提高至400MHz。
//
//=============================================================================

`timescale 1ns/1ns

module AXI_Slave_Mux_R#(
    parameter   DATA_WIDTH  = 1024,
                ADDR_WIDTH  = 64,
                ID_WIDTH    = 8,
                USER_WIDTH  = 8
)(
	/********* 时钟&复位 *********/
	input                       ACLK,
	input      	                ARESETn,
    /********** 0号从机 **********/
    //读地址通道
    output reg                  s0_ARVALID,
	input	  		            s0_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s0_RID,
	input	   [DATA_WIDTH-1:0] s0_RDATA,
	input	   [1:0]	        s0_RRESP,
	input	  		            s0_RLAST,
	input	   [USER_WIDTH-1:0]	s0_RUSER,
	input	 		            s0_RVALID, 
    output reg                  s0_RREADY, 
    /********** 1号从机 **********/
    //读地址通道
    output reg                  s1_ARVALID,
	input	  		            s1_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s1_RID,
	input	   [DATA_WIDTH-1:0] s1_RDATA,
	input	   [1:0]	        s1_RRESP,
	input	  		            s1_RLAST,
	input	   [USER_WIDTH-1:0]	s1_RUSER,
	input	 		            s1_RVALID,
    output reg                  s1_RREADY,
    /********** 2号从机 **********/
    //读地址通道
    output reg                  s2_ARVALID,
	input	  		            s2_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s2_RID,
	input	   [DATA_WIDTH-1:0] s2_RDATA,
	input	   [1:0]	        s2_RRESP,
	input	  		            s2_RLAST,
	input	   [USER_WIDTH-1:0]	s2_RUSER,
	input	 		            s2_RVALID,
    output reg                  s2_RREADY,
    /********** 3号从机 **********/
    //读地址通道
    output reg                  s3_ARVALID,
	input	  		            s3_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s3_RID,
	input	   [DATA_WIDTH-1:0] s3_RDATA,
	input	   [1:0]	        s3_RRESP,
	input	  		            s3_RLAST,
	input	   [USER_WIDTH-1:0]	s3_RUSER,
	input	 		            s3_RVALID, 
    output reg                  s3_RREADY,
    /********** 4号从机 **********/
    //读地址通道
    output reg                  s4_ARVALID,
	input	  		            s4_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s4_RID,
	input	   [DATA_WIDTH-1:0] s4_RDATA,
	input	   [1:0]	        s4_RRESP,
	input	  		            s4_RLAST,
	input	   [USER_WIDTH-1:0]	s4_RUSER,
	input	 		            s4_RVALID, 
    output reg                  s4_RREADY,
    /********** 5号从机 **********/
    //读地址通道
    output reg                  s5_ARVALID,
	input	  		            s5_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s5_RID,
	input	   [DATA_WIDTH-1:0] s5_RDATA,
	input	   [1:0]	        s5_RRESP,
	input	  		            s5_RLAST,
	input	   [USER_WIDTH-1:0]	s5_RUSER,
	input	 		            s5_RVALID,
    output reg                  s5_RREADY,
    /********** 6号从机 **********/
    //读地址通道
    output reg                  s6_ARVALID,
	input	  		            s6_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s6_RID,
	input	   [DATA_WIDTH-1:0] s6_RDATA,
	input	   [1:0]	        s6_RRESP,
	input	  		            s6_RLAST,
	input	   [USER_WIDTH-1:0]	s6_RUSER,
	input	 		            s6_RVALID, 
    output reg                  s6_RREADY, 
    /********** 7号从机 **********/
    //读地址通道
    output reg                  s7_ARVALID,
	input	  		            s7_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s7_RID,
	input	   [DATA_WIDTH-1:0] s7_RDATA,
	input	   [1:0]	        s7_RRESP,
	input	  		            s7_RLAST,
	input	   [USER_WIDTH-1:0]	s7_RUSER,
	input	 		            s7_RVALID, 
    output reg                  s7_RREADY,
    /******** 主控通用信号 ********/
    //读地址通道
	output reg	  		        m_ARREADY,
    //读数据通道
	output reg [ID_WIDTH-1:0]   m_RID,
	output reg [DATA_WIDTH-1:0] m_RDATA,
	output reg [1:0]	        m_RRESP,
	output reg		            m_RLAST,
	output reg [USER_WIDTH-1:0]	m_RUSER,
	output reg	                m_RVALID, 
    /******** 从机通用信号 ********/
    //写地址通道
    input     [ADDR_WIDTH-1:0]	s_ARADDR,
    input                       s_ARVALID,
    //写数据通道
    input                       s_RREADY  
);

    //=========================================================
    //常量定义
    parameter   TCO     =   1;  //寄存器延时


    //=========================================================
    //读地址寄存
    logic [63:0]    araddr;     //读地址寄存器

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            araddr <= #TCO '0;
        else if(s_ARVALID)                  //读地址握手信号启动时寄存写地址
            araddr <= #TCO s_ARADDR;
        else
            araddr <= #TCO araddr;
    end



    //=========================================================
    //读取通路的多路复用从机信号

    //---------------------------------------------------------
    //其他信号复用
    always_comb begin
        case(araddr[63-:3])
            3'b000: begin
                m_ARREADY   = s0_ARREADY;
                m_RID       = s0_RID;
                m_RDATA     = s0_RDATA;
                m_RRESP     = s0_RRESP;
                m_RLAST     = s0_RLAST;
                m_RUSER     = s0_RUSER;
                m_RVALID    = s0_RVALID;
            end
            3'b001: begin
                m_ARREADY   = s1_ARREADY;
                m_RID       = s1_RID;
                m_RDATA     = s1_RDATA;
                m_RRESP     = s1_RRESP;
                m_RLAST     = s1_RLAST;
                m_RUSER     = s1_RUSER;
                m_RVALID    = s1_RVALID;
            end
            3'b010: begin
                m_ARREADY   = s2_ARREADY;
                m_RID       = s2_RID;
                m_RDATA     = s2_RDATA;
                m_RRESP     = s2_RRESP;
                m_RLAST     = s2_RLAST;
                m_RUSER     = s2_RUSER;
                m_RVALID    = s2_RVALID;
            end
            3'b011: begin
                m_ARREADY   = s3_ARREADY;
                m_RID       = s3_RID;
                m_RDATA     = s3_RDATA;
                m_RRESP     = s3_RRESP;
                m_RLAST     = s3_RLAST;
                m_RUSER     = s3_RUSER;
                m_RVALID    = s3_RVALID;
            end
            3'b100: begin
                m_ARREADY   = s4_ARREADY;
                m_RID       = s4_RID;
                m_RDATA     = s4_RDATA;
                m_RRESP     = s4_RRESP;
                m_RLAST     = s4_RLAST;
                m_RUSER     = s4_RUSER;
                m_RVALID    = s4_RVALID;
            end
            3'b101: begin
                m_ARREADY   = s5_ARREADY;
                m_RID       = s5_RID;
                m_RDATA     = s5_RDATA;
                m_RRESP     = s5_RRESP;
                m_RLAST     = s5_RLAST;
                m_RUSER     = s5_RUSER;
                m_RVALID    = s5_RVALID;
            end
            3'b110: begin
                m_ARREADY   = s6_ARREADY;
                m_RID       = s6_RID;
                m_RDATA     = s6_RDATA;
                m_RRESP     = s6_RRESP;
                m_RLAST     = s6_RLAST;
                m_RUSER     = s6_RUSER;
                m_RVALID    = s6_RVALID;
            end
            3'b111: begin
                m_ARREADY   = s7_ARREADY;
                m_RID       = s7_RID;
                m_RDATA     = s7_RDATA;
                m_RRESP     = s7_RRESP;
                m_RLAST     = s7_RLAST;
                m_RUSER     = s7_RUSER;
                m_RVALID    = s7_RVALID;
            end
            default: begin
                m_ARREADY   = '0;
                m_RID       = '0;
                m_RDATA     = '0;
                m_RRESP     = '0;
                m_RLAST     = '0;
                m_RUSER     = '0;
                m_RVALID    = '0;
            end
        endcase
    end

    //---------------------------------------------------------
    //ARVALID信号复用
    always_comb begin
        case(araddr[63-:3])
            3'b000: begin
                s0_ARVALID  = s_ARVALID;
                s1_ARVALID  = '0;
                s2_ARVALID  = '0;
                s3_ARVALID  = '0;
                s4_ARVALID  = '0;
                s5_ARVALID  = '0;
                s6_ARVALID  = '0;
                s7_ARVALID  = '0;
            end
            3'b001: begin
                s0_ARVALID  = '0;
                s1_ARVALID  = s_ARVALID;
                s2_ARVALID  = '0;
                s3_ARVALID  = '0;
                s4_ARVALID  = '0;
                s5_ARVALID  = '0;
                s6_ARVALID  = '0;
                s7_ARVALID  = '0;
            end
            3'b010: begin
                s0_ARVALID  = '0;
                s1_ARVALID  = '0;
                s2_ARVALID  = s_ARVALID;
                s3_ARVALID  = '0;
                s4_ARVALID  = '0;
                s5_ARVALID  = '0;
                s6_ARVALID  = '0;
                s7_ARVALID  = '0;
            end
            3'b011: begin
                s0_ARVALID  = '0;
                s1_ARVALID  = '0;
                s2_ARVALID  = '0;
                s3_ARVALID  = s_ARVALID;
                s4_ARVALID  = '0;
                s5_ARVALID  = '0;
                s6_ARVALID  = '0;
                s7_ARVALID  = '0;
            end
            3'b100: begin
                s0_ARVALID  = '0;
                s1_ARVALID  = '0;
                s2_ARVALID  = '0;
                s3_ARVALID  = '0;
                s4_ARVALID  = s_ARVALID;
                s5_ARVALID  = '0;
                s6_ARVALID  = '0;
                s7_ARVALID  = '0;
            end
            3'b101: begin
                s0_ARVALID  = '0;
                s1_ARVALID  = '0;
                s2_ARVALID  = '0;
                s3_ARVALID  = '0;
                s4_ARVALID  = '0;
                s5_ARVALID  = s_ARVALID;
                s6_ARVALID  = '0;
                s7_ARVALID  = '0;
            end
            3'b110: begin
                s0_ARVALID  = '0;
                s1_ARVALID  = '0;
                s2_ARVALID  = '0;
                s3_ARVALID  = '0;
                s4_ARVALID  = '0;
                s5_ARVALID  = '0;
                s6_ARVALID  = s_ARVALID;
                s7_ARVALID  = '0;
            end
            3'b111: begin
                s0_ARVALID  = '0;
                s1_ARVALID  = '0;
                s2_ARVALID  = '0;
                s3_ARVALID  = '0;
                s4_ARVALID  = '0;
                s5_ARVALID  = '0;
                s6_ARVALID  = '0;
                s7_ARVALID  = s_ARVALID;
            end            
            default: begin
                s0_ARVALID  = '0;
                s1_ARVALID  = '0;
                s2_ARVALID  = '0;
                s3_ARVALID  = '0;
                s4_ARVALID  = '0;
                s5_ARVALID  = '0;
                s6_ARVALID  = '0;
                s7_ARVALID  = '0;
            end
        endcase
    end

    //---------------------------------------------------------
    //RREADY信号复用
    always_comb begin
        case(araddr[63-:3])
            3'b000: begin
                s0_RREADY  = s_RREADY;
                s1_RREADY  = '0;
                s2_RREADY  = '0;
                s3_RREADY  = '0;
                s4_RREADY  = '0;
                s5_RREADY  = '0;
                s6_RREADY  = '0;
                s7_RREADY  = '0;
            end
            3'b001: begin
                s0_RREADY  = '0;
                s1_RREADY  = s_RREADY;
                s2_RREADY  = '0;
                s3_RREADY  = '0;
                s4_RREADY  = '0;
                s5_RREADY  = '0;
                s6_RREADY  = '0;
                s7_RREADY  = '0;
            end
            3'b010: begin
                s0_RREADY  = '0;
                s1_RREADY  = '0;
                s2_RREADY  = s_RREADY;
                s3_RREADY  = '0;
                s4_RREADY  = '0;
                s5_RREADY  = '0;
                s6_RREADY  = '0;
                s7_RREADY  = '0;
            end
            3'b011: begin
                s0_RREADY  = '0;
                s1_RREADY  = '0;
                s2_RREADY  = '0;
                s3_RREADY  = s_RREADY;
                s4_RREADY  = '0;
                s5_RREADY  = '0;
                s6_RREADY  = '0;
                s7_RREADY  = '0;
            end
            3'b100: begin
                s0_RREADY  = '0;
                s1_RREADY  = '0;
                s2_RREADY  = '0;
                s3_RREADY  = '0;
                s4_RREADY  = s_RREADY;
                s5_RREADY  = '0;
                s6_RREADY  = '0;
                s7_RREADY  = '0;
            end
            3'b101: begin
                s0_RREADY  = '0;
                s1_RREADY  = '0;
                s2_RREADY  = '0;
                s3_RREADY  = '0;
                s4_RREADY  = '0;
                s5_RREADY  = s_RREADY;
                s6_RREADY  = '0;
                s7_RREADY  = '0;
            end
            3'b110: begin
                s0_RREADY  = '0;
                s1_RREADY  = '0;
                s2_RREADY  = '0;
                s3_RREADY  = '0;
                s4_RREADY  = '0;
                s5_RREADY  = '0;
                s6_RREADY  = s_RREADY;
                s7_RREADY  = '0;
            end
            3'b111: begin
                s0_RREADY  = '0;
                s1_RREADY  = '0;
                s2_RREADY  = '0;
                s3_RREADY  = '0;
                s4_RREADY  = '0;
                s5_RREADY  = '0;
                s6_RREADY  = '0;
                s7_RREADY  = s_RREADY;
            end            
            default: begin
                s0_RREADY  = '0;
                s1_RREADY  = '0;
                s2_RREADY  = '0;
                s3_RREADY  = '0;
                s4_RREADY  = '0;
                s5_RREADY  = '0;
                s6_RREADY  = '0;
                s7_RREADY  = '0;
            end
        endcase
    end

endmodule