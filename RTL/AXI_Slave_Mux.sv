//=============================================================================
//
//Module Name:					AXI_Slave_Mux.sv
//Department:					Xidian University
//Function Description:	        AXI总线从机用多路复用器
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana	Verdvana	Verdvana		  			2020-3-14
//
//------------------------------------------------------------------------------
//
//Version	Modified History
//V1.0		
//
//=============================================================================

`timescale 1ns/1ns

module AXI_Slave_Mux (
    /********* 时钟&复位 *********/
	input               ACLK,
	input      	        ARESETn,
    /********* 读写地址 **********/
    input      [63:0]   s_AWADDR,
    input      [63:0]   s_ARADDR,
    /********** 0号从机 **********/
    output reg          s0_AWVALID,
	input	   	        s0_AWREADY,
    output reg          s0_WVALID,
    input	  		    s0_WREADY,
	input	   [31:0]	s0_BID,
	input	   [1:0]	s0_BRESP,
	input	   [1023:0] s0_BUSER,
	input	     		s0_BVALID,
    output reg          s0_BREADY,
    output reg          s0_ARVALID,
	input	  		    s0_ARREADY,
	input	   [31:0]   s0_RID,
	input	   [1023:0] s0_RDATA,
	input	   [1:0]	s0_RRESP,
	input	  		    s0_RLAST,
	input	   [1023:0]	s0_RUSER,
	input	 		    s0_RVALID,
    output reg          s0_RREADY,  
    /********** 1号从机 **********/
    output reg          s1_AWVALID,
    input	   	        s1_AWREADY,
    output reg          s1_WVALID,
    input	  		    s1_WREADY,
	input	   [31:0]	s1_BID,
	input	   [1:0]	s1_BRESP,
	input	   [1023:0] s1_BUSER,
	input	     		s1_BVALID,
    output reg          s1_BREADY,
    output reg          s1_ARVALID,
	input	  		    s1_ARREADY,
	input	   [31:0]   s1_RID,
	input	   [1023:0] s1_RDATA,
	input	   [1:0]	s1_RRESP,
	input	  		    s1_RLAST,
	input	   [1023:0]	s1_RUSER,
	input	 		    s1_RVALID,
    output reg          s1_RREADY,  
    /********** 2号从机 **********/
    output reg          s2_AWVALID,
    input	   	        s2_AWREADY,
    output reg          s2_WVALID,
    input	  		    s2_WREADY,
	input	   [31:0]	s2_BID,
	input	   [1:0]	s2_BRESP,
	input	   [1023:0] s2_BUSER,
	input	     		s2_BVALID,
    output reg          s2_BREADY,
    output reg          s2_ARVALID,
	input	  		    s2_ARREADY,
	input	   [31:0]   s2_RID,
	input	   [1023:0] s2_RDATA,
	input	   [1:0]	s2_RRESP,
	input	  		    s2_RLAST,
	input	   [1023:0]	s2_RUSER,
	input	 		    s2_RVALID,
    output reg          s2_RREADY,  
    /********** 3号从机 **********/
    output reg          s3_AWVALID,
    input	   	        s3_AWREADY,
    output reg          s3_WVALID,
    input	  		    s3_WREADY,
	input	   [31:0]	s3_BID,
	input	   [1:0]	s3_BRESP,
	input	   [1023:0] s3_BUSER,
	input	     		s3_BVALID,
    output reg          s3_BREADY,
    output reg          s3_ARVALID,
	input	  		    s3_ARREADY,
	input	   [31:0]   s3_RID,
	input	   [1023:0] s3_RDATA,
	input	   [1:0]	s3_RRESP,
	input	  		    s3_RLAST,
	input	   [1023:0]	s3_RUSER,
	input	 		    s3_RVALID, 
    output reg          s3_RREADY,  
    /********** 4号从机 **********/
    output reg          s4_AWVALID,
    input	   	        s4_AWREADY,
    output reg          s4_WVALID,
    input	  		    s4_WREADY,
	input	   [31:0]	s4_BID,
	input	   [1:0]	s4_BRESP,
	input	   [1023:0] s4_BUSER,
	input	     		s4_BVALID,
    output reg          s4_BREADY,
    output reg          s4_ARVALID,
	input	  		    s4_ARREADY,
	input	   [31:0]   s4_RID,
	input	   [1023:0] s4_RDATA,
	input	   [1:0]	s4_RRESP,
	input	  		    s4_RLAST,
	input	   [1023:0]	s4_RUSER,
	input	 		    s4_RVALID, 
    output reg          s4_RREADY,  
    /********** 5号从机 **********/
    output reg          s5_AWVALID,
    input	   	        s5_AWREADY,
    output reg          s5_WVALID,
    input	  		    s5_WREADY,
	input	   [31:0]	s5_BID,
	input	   [1:0]	s5_BRESP,
	input	   [1023:0] s5_BUSER,
	input	     		s5_BVALID,
    output reg          s5_BREADY,
    output reg          s5_ARVALID,
	input	  		    s5_ARREADY,
	input	   [31:0]   s5_RID,
	input	   [1023:0] s5_RDATA,
	input	   [1:0]	s5_RRESP,
	input	  		    s5_RLAST,
	input	   [1023:0]	s5_RUSER,
	input	 		    s5_RVALID, 
    output reg          s5_RREADY,  
    /********** 6号从机 **********/
    output reg          s6_AWVALID,
    input	   	        s6_AWREADY,
    output reg          s6_WVALID,
    input	  		    s6_WREADY,
	input	   [31:0]	s6_BID,
	input	   [1:0]	s6_BRESP,
	input	   [1023:0] s6_BUSER,
	input	     		s6_BVALID,
    output reg          s6_BREADY,
    output reg          s6_ARVALID,
	input	  		    s6_ARREADY,
	input	   [31:0]   s6_RID,
	input	   [1023:0] s6_RDATA,
	input	   [1:0]	s6_RRESP,
	input	  		    s6_RLAST,
	input	   [1023:0]	s6_RUSER,
	input	 		    s6_RVALID, 
    output reg          s6_RREADY,  
    /********** 7号从机 **********/
    output reg          s7_AWVALID,
    input	   	        s7_AWREADY,
    output reg          s7_WVALID,
    input	  		    s7_WREADY,
	input	   [31:0]	s7_BID,
	input	   [1:0]	s7_BRESP,
	input	   [1023:0] s7_BUSER,
	input	     		s7_BVALID,
    output reg          s7_BREADY, 
    output reg          s7_ARVALID,
	input	  		    s7_ARREADY,
	input	   [31:0]   s7_RID,
	input	   [1023:0] s7_RDATA,
	input	   [1:0]	s7_RRESP,
	input	  		    s7_RLAST,
	input	   [1023:0]	s7_RUSER,
	input	 		    s7_RVALID,
    output reg          s7_RREADY,  
    /******** 从机通用信号 ********/
    input               s_AWVALID,
    input               s_WVALID,
    input               s_BREADY,
    input               s_ARVALID,
    input               s_RREADY,
    /******** 主控通用信号 ********/
    output reg 	        m_AWREADY,
    output reg		    m_WREADY,
	output reg [31:0]	m_BID,
	output reg [1:0]	m_BRESP,
	output reg [1023:0] m_BUSER,
	output reg   		m_BVALID,
	output reg		    m_ARREADY,
	output reg [31:0]   m_RID,
	output reg [1023:0] m_RDATA,
	output reg [1:0]	m_RRESP,
	output reg		    m_RLAST,
	output reg [1023:0]	m_RUSER,
	output reg	        m_RVALID
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