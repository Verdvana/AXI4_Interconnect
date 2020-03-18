//=============================================================================
//
//Module Name:					AXI_Slave_Mux_W.sv
//Department:					Xidian University
//Function Description:	        AXI总线写通道从机用多路复用器
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

module AXI_Slave_Mux_W#(
    parameter   DATA_WIDTH  = 1024,
                ADDR_WIDTH  = 64,
                ID_WIDTH    = 8,
                USER_WIDTH  = 8
)(
	/********* 时钟&复位 *********/
	input                       ACLK,
	input      	                ARESETn,
    /********** 0号从机 **********/
    //写地址通道
    output reg                  s0_AWVALID,
    input	   	                s0_AWREADY,
    //写数据通道
    output reg                  s0_WVALID,
    input	  		            s0_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s0_BID,
	input	   [1:0]	        s0_BRESP,
	input	   [USER_WIDTH-1:0] s0_BUSER,
	input	     		        s0_BVALID,
    output reg                  s0_BREADY,
    /********** 1号从机 **********/
    //写地址通道
    output reg                  s1_AWVALID,
    input	   	                s1_AWREADY,
    //写数据通道
    output reg                  s1_WVALID,
    input	  		            s1_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s1_BID,
	input	   [1:0]	        s1_BRESP,
	input	   [USER_WIDTH-1:0] s1_BUSER,
	input	     		        s1_BVALID,
    output reg                  s1_BREADY,
    /********** 2号从机 **********/
    //写地址通道
    output reg                  s2_AWVALID,
    input	   	                s2_AWREADY,
    //写数据通道
    output reg                  s2_WVALID,
    input	  		            s2_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s2_BID,
	input	   [1:0]	        s2_BRESP,
	input	   [USER_WIDTH-1:0] s2_BUSER,
	input	     		        s2_BVALID,
    output reg                  s2_BREADY,
    /********** 3号从机 **********/
    //写地址通道
    output reg                  s3_AWVALID,
    input	   	                s3_AWREADY,
    //写数据通道
    output reg                  s3_WVALID,
    input	  		            s3_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s3_BID,
	input	   [1:0]	        s3_BRESP,
	input	   [USER_WIDTH-1:0] s3_BUSER,
	input	     		        s3_BVALID,
    output reg                  s3_BREADY,
    /********** 4号从机 **********/
    //写地址通道
    output reg                  s4_AWVALID,
    input	   	                s4_AWREADY,
    //写数据通道
    output reg                  s4_WVALID,
    input	  		            s4_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s4_BID,
	input	   [1:0]	        s4_BRESP,
	input	   [USER_WIDTH-1:0] s4_BUSER,
	input	     		        s4_BVALID,
    output reg                  s4_BREADY,
    /********** 5号从机 **********/
    //写地址通道
    output reg                  s5_AWVALID,
    input	   	                s5_AWREADY,
    //写数据通道
    output reg                  s5_WVALID,
    input	  		            s5_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s5_BID,
	input	   [1:0]	        s5_BRESP,
	input	   [USER_WIDTH-1:0] s5_BUSER,
	input	     		        s5_BVALID,
    output reg                  s5_BREADY,
    /********** 6号从机 **********/
    //写地址通道
    output reg                  s6_AWVALID,
    input	   	                s6_AWREADY,
    //写数据通道
    output reg                  s6_WVALID,
    input	  		            s6_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s6_BID,
	input	   [1:0]	        s6_BRESP,
	input	   [USER_WIDTH-1:0] s6_BUSER,
	input	     		        s6_BVALID,
    output reg                  s6_BREADY,
    /********** 7号从机 **********/
    //写地址通道
    output reg                  s7_AWVALID,
    input	   	                s7_AWREADY,
    //写数据通道
    output reg                  s7_WVALID,
    input	  		            s7_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s7_BID,
	input	   [1:0]	        s7_BRESP,
	input	   [USER_WIDTH-1:0] s7_BUSER,
	input	     		        s7_BVALID,
    output reg                  s7_BREADY,
    /******** 主控通用信号 ********/
    //写地址通道
    output reg 	                m_AWREADY,
    //写数据通道
    output reg		            m_WREADY,
    //写响应通道
	output reg [ID_WIDTH-1:0]	m_BID,
	output reg [1:0]	        m_BRESP,
	output reg [USER_WIDTH-1:0] m_BUSER,
	output reg   		        m_BVALID,
    /******** 从机通用信号 ********/
    //写地址通道
    input     [ADDR_WIDTH-1:0]	s_AWADDR,
    input                       s_AWVALID,
    //写数据通道
    input                       s_WVALID,
    //写响应通道
    input                       s_BREADY    
);

    //=========================================================
    //常量定义
    parameter   TCO     =   1;  //寄存器延时

    //=========================================================
    //写地址寄存
    logic [63:0]    awaddr;     //写地址寄存器

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            awaddr <= #TCO '0;
        else if(s_AWVALID)                  //写地址握手信号启动时寄存写地址
            awaddr <= #TCO s_AWADDR;
        else
            awaddr <= #TCO awaddr;
    end



    //=========================================================
    //写入通路的多路复用从机信号

    //---------------------------------------------------------
    //其他信号复用
    always_comb begin
        case(awaddr[63-:3])
            3'b000: begin
                m_AWREADY   = s0_AWREADY;
                m_WREADY    = s0_WREADY;
                m_BID       = s0_BID;
                m_BRESP     = s0_BRESP;
                m_BUSER     = s0_BUSER;
                m_BVALID    = s0_BVALID;
            end
            3'b001: begin
                m_AWREADY   = s1_AWREADY;
                m_WREADY    = s1_WREADY;
                m_BID       = s1_BID;
                m_BRESP     = s1_BRESP;
                m_BUSER     = s1_BUSER;
                m_BVALID    = s1_BVALID;
            end
            3'b010: begin
                m_AWREADY   = s2_AWREADY;
                m_WREADY    = s2_WREADY;
                m_BID       = s2_BID;
                m_BRESP     = s2_BRESP;
                m_BUSER     = s2_BUSER;
                m_BVALID    = s2_BVALID;
            end
            3'b011: begin
                m_AWREADY   = s3_AWREADY;
                m_WREADY    = s3_WREADY;
                m_BID       = s3_BID;
                m_BRESP     = s3_BRESP;
                m_BUSER     = s3_BUSER;
                m_BVALID    = s3_BVALID;
            end
            3'b100: begin
                m_AWREADY   = s4_AWREADY;
                m_WREADY    = s4_WREADY;
                m_BID       = s4_BID;
                m_BRESP     = s4_BRESP;
                m_BUSER     = s4_BUSER;
                m_BVALID    = s4_BVALID;
            end
            3'b101: begin
                m_AWREADY   = s5_AWREADY;
                m_WREADY    = s5_WREADY;
                m_BID       = s5_BID;
                m_BRESP     = s5_BRESP;
                m_BUSER     = s5_BUSER;
                m_BVALID    = s5_BVALID;
            end
            3'b110: begin
                m_AWREADY   = s6_AWREADY;
                m_WREADY    = s6_WREADY;
                m_BID       = s6_BID;
                m_BRESP     = s6_BRESP;
                m_BUSER     = s6_BUSER;
                m_BVALID    = s6_BVALID;
            end
            3'b111: begin
                m_AWREADY   = s7_AWREADY;
                m_WREADY    = s7_WREADY;
                m_BID       = s7_BID;
                m_BRESP     = s7_BRESP;
                m_BUSER     = s7_BUSER;
                m_BVALID    = s7_BVALID;
            end
            default: begin
                m_AWREADY   = '0;
                m_WREADY    = '0;
                m_BID       = '0;
                m_BRESP     = '0;
                m_BUSER     = '0;
                m_BVALID    = '0;
            end
        endcase
    end

    //---------------------------------------------------------
    //AWVALID信号复用
    always_comb begin
        case(awaddr[63-:3])
            3'b000:begin
                s0_AWVALID  = s_AWVALID;
                s1_AWVALID  = '0;
                s2_AWVALID  = '0;
                s3_AWVALID  = '0;
                s4_AWVALID  = '0;
                s5_AWVALID  = '0;
                s6_AWVALID  = '0;
                s7_AWVALID  = '0;
            end
            3'b001:begin
                s0_AWVALID  = '0;
                s1_AWVALID  = s_AWVALID;
                s2_AWVALID  = '0;
                s3_AWVALID  = '0;
                s4_AWVALID  = '0;
                s5_AWVALID  = '0;
                s6_AWVALID  = '0;
                s7_AWVALID  = '0;
            end
            3'b010:begin
                s0_AWVALID  = '0;
                s1_AWVALID  = '0;
                s2_AWVALID  = s_AWVALID;
                s3_AWVALID  = '0;
                s4_AWVALID  = '0;
                s5_AWVALID  = '0;
                s6_AWVALID  = '0;
                s7_AWVALID  = '0;
            end
            3'b011:begin
                s0_AWVALID  = '0;
                s1_AWVALID  = '0;
                s2_AWVALID  = '0;
                s3_AWVALID  = s_AWVALID;
                s4_AWVALID  = '0;
                s5_AWVALID  = '0;
                s6_AWVALID  = '0;
                s7_AWVALID  = '0;
            end
            3'b100:begin
                s0_AWVALID  = '0;
                s1_AWVALID  = '0;
                s2_AWVALID  = '0;
                s3_AWVALID  = '0;
                s4_AWVALID  = s_AWVALID;
                s5_AWVALID  = '0;
                s6_AWVALID  = '0;
                s7_AWVALID  = '0;
            end
            3'b101:begin
                s0_AWVALID  = '0;
                s1_AWVALID  = '0;
                s2_AWVALID  = '0;
                s3_AWVALID  = '0;
                s4_AWVALID  = '0;
                s5_AWVALID  = s_AWVALID;
                s6_AWVALID  = '0;
                s7_AWVALID  = '0;
            end
            3'b110:begin
                s0_AWVALID  = '0;
                s1_AWVALID  = '0;
                s2_AWVALID  = '0;
                s3_AWVALID  = '0;
                s4_AWVALID  = '0;
                s5_AWVALID  = '0;
                s6_AWVALID  = s_AWVALID;
                s7_AWVALID  = '0;
            end
            3'b111:begin
                s0_AWVALID  = '0;
                s1_AWVALID  = '0;
                s2_AWVALID  = '0;
                s3_AWVALID  = '0;
                s4_AWVALID  = '0;
                s5_AWVALID  = '0;
                s6_AWVALID  = '0;
                s7_AWVALID  = s_AWVALID;
            end
            default: begin
                s0_AWVALID  = '0;
                s1_AWVALID  = '0;
                s2_AWVALID  = '0;
                s3_AWVALID  = '0;
                s4_AWVALID  = '0;
                s5_AWVALID  = '0;
                s6_AWVALID  = '0;
                s7_AWVALID  = '0;
            end
        endcase
    end

    //---------------------------------------------------------
    //BREADY信号复用
    always_comb begin
        case(awaddr[63-:3])
            3'b000:begin
                s0_BREADY  = s_BREADY;
                s1_BREADY  = '0;
                s2_BREADY  = '0;
                s3_BREADY  = '0;
                s4_BREADY  = '0;
                s5_BREADY  = '0;
                s6_BREADY  = '0;
                s7_BREADY  = '0;
            end
            3'b001:begin
                s0_BREADY  = '0;
                s1_BREADY  = s_BREADY;
                s2_BREADY  = '0;
                s3_BREADY  = '0;
                s4_BREADY  = '0;
                s5_BREADY  = '0;
                s6_BREADY  = '0;
                s7_BREADY  = '0;
            end
            3'b010:begin
                s0_BREADY  = '0;
                s1_BREADY  = '0;
                s2_BREADY  = s_BREADY;
                s3_BREADY  = '0;
                s4_BREADY  = '0;
                s5_BREADY  = '0;
                s6_BREADY  = '0;
                s7_BREADY  = '0;
            end
            3'b011:begin
                s0_BREADY  = '0;
                s1_BREADY  = '0;
                s2_BREADY  = '0;
                s3_BREADY  = s_BREADY;
                s4_BREADY  = '0;
                s5_BREADY  = '0;
                s6_BREADY  = '0;
                s7_BREADY  = '0;
            end
            3'b100:begin
                s0_BREADY  = '0;
                s1_BREADY  = '0;
                s2_BREADY  = '0;
                s3_BREADY  = '0;
                s4_BREADY  = s_BREADY;
                s5_BREADY  = '0;
                s6_BREADY  = '0;
                s7_BREADY  = '0;
            end
            3'b101:begin
                s0_BREADY  = '0;
                s1_BREADY  = '0;
                s2_BREADY  = '0;
                s3_BREADY  = '0;
                s4_BREADY  = '0;
                s5_BREADY  = s_BREADY;
                s6_BREADY  = '0;
                s7_BREADY  = '0;
            end
            3'b110:begin
                s0_BREADY  = '0;
                s1_BREADY  = '0;
                s2_BREADY  = '0;
                s3_BREADY  = '0;
                s4_BREADY  = '0;
                s5_BREADY  = '0;
                s6_BREADY  = s_BREADY;
                s7_BREADY  = '0;
            end
            3'b111:begin
                s0_BREADY  = '0;
                s1_BREADY  = '0;
                s2_BREADY  = '0;
                s3_BREADY  = '0;
                s4_BREADY  = '0;
                s5_BREADY  = '0;
                s6_BREADY  = '0;
                s7_BREADY  = s_BREADY;
            end
            default: begin
                s0_BREADY  = '0;
                s1_BREADY  = '0;
                s2_BREADY  = '0;
                s3_BREADY  = '0;
                s4_BREADY  = '0;
                s5_BREADY  = '0;
                s6_BREADY  = '0;
                s7_BREADY  = '0;
            end
        endcase
    end

    //---------------------------------------------------------
    //WVALID信号复用
    always_comb begin
        case(awaddr[63-:3])
            3'b000:begin
                s0_WVALID  = s_WVALID;
                s1_WVALID  = '0;
                s2_WVALID  = '0;
                s3_WVALID  = '0;
                s4_WVALID  = '0;
                s5_WVALID  = '0;
                s6_WVALID  = '0;
                s7_WVALID  = '0;
            end
            3'b001:begin
                s0_WVALID  = '0;
                s1_WVALID  = s_WVALID;
                s2_WVALID  = '0;
                s3_WVALID  = '0;
                s4_WVALID  = '0;
                s5_WVALID  = '0;
                s6_WVALID  = '0;
                s7_WVALID  = '0;
            end
            3'b010:begin
                s0_WVALID  = '0;
                s1_WVALID  = '0;
                s2_WVALID  = s_WVALID;
                s3_WVALID  = '0;
                s4_WVALID  = '0;
                s5_WVALID  = '0;
                s6_WVALID  = '0;
                s7_WVALID  = '0;
            end
            3'b011:begin
                s0_WVALID  = '0;
                s1_WVALID  = '0;
                s2_WVALID  = '0;
                s3_WVALID  = s_WVALID;
                s4_WVALID  = '0;
                s5_WVALID  = '0;
                s6_WVALID  = '0;
                s7_WVALID  = '0;
            end
            3'b100:begin
                s0_WVALID  = '0;
                s1_WVALID  = '0;
                s2_WVALID  = '0;
                s3_WVALID  = '0;
                s4_WVALID  = s_WVALID;
                s5_WVALID  = '0;
                s6_WVALID  = '0;
                s7_WVALID  = '0;
            end
            3'b101:begin
                s0_WVALID  = '0;
                s1_WVALID  = '0;
                s2_WVALID  = '0;
                s3_WVALID  = '0;
                s4_WVALID  = '0;
                s5_WVALID  = s_WVALID;
                s6_WVALID  = '0;
                s7_WVALID  = '0;
            end
            3'b110:begin
                s0_WVALID  = '0;
                s1_WVALID  = '0;
                s2_WVALID  = '0;
                s3_WVALID  = '0;
                s4_WVALID  = '0;
                s5_WVALID  = '0;
                s6_WVALID  = s_WVALID;
                s7_WVALID  = '0;
            end
            3'b111:begin
                s0_WVALID  = '0;
                s1_WVALID  = '0;
                s2_WVALID  = '0;
                s3_WVALID  = '0;
                s4_WVALID  = '0;
                s5_WVALID  = '0;
                s6_WVALID  = '0;
                s7_WVALID  = s_WVALID;
            end
            default: begin
                s0_WVALID  = '0;
                s1_WVALID  = '0;
                s2_WVALID  = '0;
                s3_WVALID  = '0;
                s4_WVALID  = '0;
                s5_WVALID  = '0;
                s6_WVALID  = '0;
                s7_WVALID  = '0;
            end
        endcase
    end


endmodule