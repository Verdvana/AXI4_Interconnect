//=============================================================================
//
//Module Name:					AXI4_Interconnect.sv
//Department:					Xidian University
//Function Description:	        AXI总线连接器
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana	Verdvana	Verdvana		  			2020-3-13
//V1.1		Verdvana	Verdvana	Verdvana		  			2020-3-16
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
//=============================================================================

`timescale 1ns/1ns

module AXI4_Interconnect#(
    parameter   DATA_WIDTH  = 8,
                ADDR_WIDTH  = 8,
                ID_WIDTH    = 1,
                USER_WIDTH  = 1,
                STRB_WIDTH  = (DATA_WIDTH/8)
)(
	/********* 时钟&复位 *********/
	input                       ACLK,
	input      	                ARESETn,
    /********** 0号主控 **********/
    //写地址通道
	input      [ID_WIDTH-1:0]   m0_AWID,
    input	   [ADDR_WIDTH-1:0] m0_AWADDR,
    input      [7:0]            m0_AWLEN,
    input      [7:0]            m0_AWSIZE,
    input      [2:0]            m0_AWBURST,
    input                       m0_AWLOCK,
    input      [3:0]            m0_AWCACHE,
    input      [2:0]            m0_AWPROT,
    input      [3:0]            m0_AWQOS,
    input      [3:0]            m0_AWREGION,
    input      [USER_WIDTH-1:0] m0_AWUSER,
    input                       m0_AWVALID,
    output                      m0_AWREADY,
    //写数据通道
    input      [ID_WIDTH-1:0]   m0_WID,
    input      [DATA_WIDTH-1:0] m0_WDATA,
    input      [STRB_WIDTH-1:0] m0_WSTRB,
    input                       m0_WLAST,
    input      [USER_WIDTH-1:0] m0_WUSER,
    input                       m0_WVALID,
    output                      m0_WREADY,
    //写响应通道
    output                      m0_BVALID,
    input                       m0_BREADY,
    //读地址通道
    input      [ID_WIDTH-1:0]   m0_ARID,
    input      [ADDR_WIDTH-1:0] m0_ARADDR,
    input      [7:0]            m0_ARLEN,
    input      [2:0]            m0_ARSIZE,
    input      [1:0]            m0_ARBURST,
    input                       m0_ARLOCK,
    input      [3:0]            m0_ARCACHE,
    input      [2:0]            m0_ARPROT,
    input      [3:0]            m0_ARQOS,
    input      [3:0]            m0_ARREGION,
    input      [USER_WIDTH-1:0] m0_ARUSER,
    input                       m0_ARVALID,
    output                      m0_ARREADY,
    //读数据通道
    output                      m0_RVALID,
    input                       m0_RREADY,
    /********** 1号主控 **********/
    //写地址通道
    input      [ID_WIDTH-1:0]   m1_AWID,
    input	   [ADDR_WIDTH-1:0]	m1_AWADDR,
    input      [7:0]            m1_AWLEN,
    input      [7:0]            m1_AWSIZE,
    input      [2:0]            m1_AWBURST,
    input                       m1_AWLOCK,
    input      [3:0]            m1_AWCACHE,
    input      [2:0]            m1_AWPROT,
    input      [3:0]            m1_AWQOS,
    input      [3:0]            m1_AWREGION,
    input      [USER_WIDTH-1:0] m1_AWUSER,
    input                       m1_AWVALID,
    output                      m1_AWREADY,
    //写数据通道
    input      [ID_WIDTH-1:0]   m1_WID,
    input      [DATA_WIDTH-1:0] m1_WDATA,
    input      [STRB_WIDTH-1:0] m1_WSTRB,
    input                       m1_WLAST,
    input      [USER_WIDTH-1:0] m1_WUSER,
    input                       m1_WVALID,
    output                      m1_WREADY,
    //写响应通道
    output                      m1_BVALID,
    input                       m1_BREADY,
    //读地址通道
    input      [ID_WIDTH-1:0]   m1_ARID,
    input      [ADDR_WIDTH-1:0] m1_ARADDR,
    input      [7:0]            m1_ARLEN,
    input      [2:0]            m1_ARSIZE,
    input      [1:0]            m1_ARBURST,
    input                       m1_ARLOCK,
    input      [3:0]            m1_ARCACHE,
    input      [2:0]            m1_ARPROT,
    input      [3:0]            m1_ARQOS,
    input      [3:0]            m1_ARREGION,
    input      [USER_WIDTH-1:0] m1_ARUSER,
    input                       m1_ARVALID,
    output                      m1_ARREADY,
    //读数据通道
    output                      m1_RVALID,
    input                       m1_RREADY,
    /********** 2号主控 **********/
    //写地址通道
    input      [ID_WIDTH-1:0]   m2_AWID,
    input	   [ADDR_WIDTH-1:0]	m2_AWADDR,
    input      [7:0]            m2_AWLEN,
    input      [7:0]            m2_AWSIZE,
    input      [2:0]            m2_AWBURST,
    input                       m2_AWLOCK,
    input      [3:0]            m2_AWCACHE,
    input      [2:0]            m2_AWPROT,
    input      [3:0]            m2_AWQOS,
    input      [3:0]            m2_AWREGION,
    input      [USER_WIDTH-1:0] m2_AWUSER,
    input                       m2_AWVALID,
    output                      m2_AWREADY,
    //写数据通道
    input      [ID_WIDTH-1:0]   m2_WID,
    input      [DATA_WIDTH-1:0] m2_WDATA,
    input      [STRB_WIDTH-1:0] m2_WSTRB,
    input                       m2_WLAST,
    input      [USER_WIDTH-1:0] m2_WUSER,
    input                       m2_WVALID,
    output                      m2_WREADY,
    //写响应通道
    output                      m2_BVALID,
    input                       m2_BREADY,
    //读地址通道
    input      [ID_WIDTH-1:0]   m2_ARID,
    input      [ADDR_WIDTH-1:0] m2_ARADDR,
    input      [7:0]            m2_ARLEN,
    input      [2:0]            m2_ARSIZE,
    input      [1:0]            m2_ARBURST,
    input                       m2_ARLOCK,
    input      [3:0]            m2_ARCACHE,
    input      [2:0]            m2_ARPROT,
    input      [3:0]            m2_ARQOS,
    input      [3:0]            m2_ARREGION,
    input      [USER_WIDTH-1:0] m2_ARUSER,
    input                       m2_ARVALID,
    output                      m2_ARREADY,
    //读数据通道
    output                      m2_RVALID,
    input                       m2_RREADY,
    /********** 3号主控 **********/
    //写地址通道
    input      [ID_WIDTH-1:0]   m3_AWID,
    input	   [ADDR_WIDTH-1:0]	m3_AWADDR,
    input      [7:0]            m3_AWLEN,
    input      [7:0]            m3_AWSIZE,
    input      [2:0]            m3_AWBURST,
    input                       m3_AWLOCK,
    input      [3:0]            m3_AWCACHE,
    input      [2:0]            m3_AWPROT,
    input      [3:0]            m3_AWQOS,
    input      [3:0]            m3_AWREGION,
    input      [USER_WIDTH-1:0] m3_AWUSER,
    input                       m3_AWVALID,
    output                      m3_AWREADY,
    //写数据通道
    input      [ID_WIDTH-1:0]   m3_WID,
    input      [DATA_WIDTH-1:0] m3_WDATA,
    input      [STRB_WIDTH-1:0] m3_WSTRB,
    input                       m3_WLAST,
    input      [USER_WIDTH-1:0] m3_WUSER,
    input                       m3_WVALID,
    output                      m3_WREADY,
    //写响应通道
    output                      m3_BVALID,
    input                       m3_BREADY,
    //读地址通道
    input      [ID_WIDTH-1:0]   m3_ARID,
    input      [ADDR_WIDTH-1:0] m3_ARADDR,
    input      [7:0]            m3_ARLEN,
    input      [2:0]            m3_ARSIZE,
    input      [1:0]            m3_ARBURST,
    input                       m3_ARLOCK,
    input      [3:0]            m3_ARCACHE,
    input      [2:0]            m3_ARPROT,
    input      [3:0]            m3_ARQOS,
    input      [3:0]            m3_ARREGION,
    input      [USER_WIDTH-1:0] m3_ARUSER,
    input                       m3_ARVALID,
    output                      m3_ARREADY,
    //读数据通道
    output                      m3_RVALID,
    input                       m3_RREADY,
    /******** 主控通用信号 ********/
    //写响应通道
	output     [ID_WIDTH-1:0]	m_BID,
	output     [1:0]	        m_BRESP,
	output     [USER_WIDTH-1:0] m_BUSER,
    //读数据通道
	output     [ID_WIDTH-1:0]   m_RID,
	output     [DATA_WIDTH-1:0] m_RDATA,
	output     [1:0]	        m_RRESP,
    output                      m_RLAST,
	output     [USER_WIDTH-1:0]	m_RUSER,
    /********** 0号从机 **********/
    //写地址通道
    output                      s0_AWVALID,
    input	   	                s0_AWREADY,
    //写数据通道
    output                      s0_WVALID,
    input	  		            s0_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s0_BID,
	input	   [1:0]	        s0_BRESP,
	input	   [USER_WIDTH-1:0] s0_BUSER,
	input	     		        s0_BVALID,
    output                      s0_BREADY,
    //读地址通道
    output                      s0_ARVALID,
	input	  		            s0_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s0_RID,
	input	   [DATA_WIDTH-1:0] s0_RDATA,
	input	   [1:0]	        s0_RRESP,
	input	  		            s0_RLAST,
	input	   [USER_WIDTH-1:0]	s0_RUSER,
	input	 		            s0_RVALID, 
    output                      s0_RREADY, 
    /********** 1号从机 **********/
    //写地址通道
    output                      s1_AWVALID,
    input	   	                s1_AWREADY,
    //写数据通道
    output                      s1_WVALID,
    input	  		            s1_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s1_BID,
	input	   [1:0]	        s1_BRESP,
	input	   [USER_WIDTH-1:0] s1_BUSER,
	input	     		        s1_BVALID,
    output                      s1_BREADY,
    //读地址通道
    output                      s1_ARVALID,
	input	  		            s1_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s1_RID,
	input	   [DATA_WIDTH-1:0] s1_RDATA,
	input	   [1:0]	        s1_RRESP,
	input	  		            s1_RLAST,
	input	   [USER_WIDTH-1:0]	s1_RUSER,
	input	 		            s1_RVALID,
    output                      s1_RREADY,
    /********** 2号从机 **********/
    //写地址通道
    output                      s2_AWVALID,
    input	   	                s2_AWREADY,
    //写数据通道
    output                      s2_WVALID,
    input	  		            s2_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s2_BID,
	input	   [1:0]	        s2_BRESP,
	input	   [USER_WIDTH-1:0] s2_BUSER,
	input	     		        s2_BVALID,
    output                      s2_BREADY,
    //读地址通道
    output                      s2_ARVALID,
	input	  		            s2_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s2_RID,
	input	   [DATA_WIDTH-1:0] s2_RDATA,
	input	   [1:0]	        s2_RRESP,
	input	  		            s2_RLAST,
	input	   [USER_WIDTH-1:0]	s2_RUSER,
	input	 		            s2_RVALID,
    output                      s2_RREADY,
    /********** 3号从机 **********/
    //写地址通道
    output                      s3_AWVALID,
    input	   	                s3_AWREADY,
    //写数据通道
    output                      s3_WVALID,
    input	  		            s3_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s3_BID,
	input	   [1:0]	        s3_BRESP,
	input	   [USER_WIDTH-1:0] s3_BUSER,
	input	     		        s3_BVALID,
    output                      s3_BREADY,
    //读地址通道
    output                      s3_ARVALID,
	input	  		            s3_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s3_RID,
	input	   [DATA_WIDTH-1:0] s3_RDATA,
	input	   [1:0]	        s3_RRESP,
	input	  		            s3_RLAST,
	input	   [USER_WIDTH-1:0]	s3_RUSER,
	input	 		            s3_RVALID, 
    output                      s3_RREADY,
    /********** 4号从机 **********/
    //写地址通道
    output                      s4_AWVALID,
    input	   	                s4_AWREADY,
    //写数据通道
    output                      s4_WVALID,
    input	  		            s4_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s4_BID,
	input	   [1:0]	        s4_BRESP,
	input	   [USER_WIDTH-1:0] s4_BUSER,
	input	     		        s4_BVALID,
    output                      s4_BREADY,
    //读地址通道
    output                      s4_ARVALID,
	input	  		            s4_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s4_RID,
	input	   [DATA_WIDTH:0]   s4_RDATA,
	input	   [1:0]	        s4_RRESP,
	input	  		            s4_RLAST,
	input	   [USER_WIDTH-1:0]	s4_RUSER,
	input	 		            s4_RVALID, 
    output                      s4_RREADY,
    /********** 5号从机 **********/
    //写地址通道
    output                      s5_AWVALID,
    input	   	                s5_AWREADY,
    //写数据通道
    output                      s5_WVALID,
    input	  		            s5_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s5_BID,
	input	   [1:0]	        s5_BRESP,
	input	   [USER_WIDTH-1:0] s5_BUSER,
	input	     		        s5_BVALID,
    output                      s5_BREADY,
    //读地址通道
    output                      s5_ARVALID,
	input	  		            s5_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s5_RID,
	input	   [DATA_WIDTH:0]   s5_RDATA,
	input	   [1:0]	        s5_RRESP,
	input	  		            s5_RLAST,
	input	   [USER_WIDTH-1:0]	s5_RUSER,
	input	 		            s5_RVALID,
    output                      s5_RREADY,
    /********** 6号从机 **********/
    //写地址通道
    output                      s6_AWVALID,
    input	   	                s6_AWREADY,
    //写数据通道
    output                      s6_WVALID,
    input	  		            s6_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s6_BID,
	input	   [1:0]	        s6_BRESP,
	input	   [USER_WIDTH-1:0] s6_BUSER,
	input	     		        s6_BVALID,
    output                      s6_BREADY,
    //读地址通道
    output                      s6_ARVALID,
	input	  		            s6_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s6_RID,
	input	   [DATA_WIDTH:0]   s6_RDATA,
	input	   [1:0]	        s6_RRESP,
	input	  		            s6_RLAST,
	input	   [USER_WIDTH-1:0]	s6_RUSER,
	input	 		            s6_RVALID, 
    output                      s6_RREADY, 
    /********** 7号从机 **********/
    //写地址通道
    output                      s7_AWVALID,
    input	   	                s7_AWREADY,
    //写数据通道
    output                      s7_WVALID,
    input	  		            s7_WREADY,
    //写响应通道
	input	   [ID_WIDTH-1:0]	s7_BID,
	input	   [1:0]	        s7_BRESP,
	input	   [USER_WIDTH-1:0] s7_BUSER,
	input	     		        s7_BVALID,
    output                      s7_BREADY,
    //读地址通道
    output                      s7_ARVALID,
	input	  		            s7_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s7_RID,
	input	   [DATA_WIDTH:0]   s7_RDATA,
	input	   [1:0]	        s7_RRESP,
	input	  		            s7_RLAST,
	input	   [USER_WIDTH-1:0]	s7_RUSER,
	input	 		            s7_RVALID, 
    output                      s7_RREADY,
    /******** 从机通用信号 ********/
    //写地址通道
    output     [ID_WIDTH-1:0]   s_AWID,
    output     [ADDR_WIDTH-1:0]	s_AWADDR,
    output     [7:0]            s_AWLEN,
    output     [7:0]            s_AWSIZE,
    output     [2:0]            s_AWBURST,
    output                      s_AWLOCK,
    output     [3:0]            s_AWCACHE,
    output     [2:0]            s_AWPROT,
    output     [3:0]            s_AWQOS,
    output     [3:0]            s_AWREGION,
    output     [USER_WIDTH-1:0] s_AWUSER,  
    //写数据通道
    output     [ID_WIDTH-1:0]   s_WID,
    output     [DATA_WIDTH:0]   s_WDATA,
    output     [STRB_WIDTH-1:0] s_WSTRB,
    output                      s_WLAST,
    output     [USER_WIDTH-1:0] s_WUSER,
    //读地址通道
    output     [ID_WIDTH-1:0]   s_ARID,    
    output     [ADDR_WIDTH-1:0] s_ARADDR,
    output     [7:0]            s_ARLEN,
    output     [2:0]            s_ARSIZE,
    output     [1:0]            s_ARBURST,
    output                      s_ARLOCK,
    output     [3:0]            s_ARCACHE,
    output     [2:0]            s_ARPROT,
    output     [3:0]            s_ARQOS,
    output     [3:0]            s_ARREGION,
    output     [USER_WIDTH-1:0] s_ARUSER   
);


    //=========================================================
    //仲裁器例化
    AXI_Arbiter_W#(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH(ID_WIDTH),
        .USER_WIDTH(USER_WIDTH),
        .STRB_WIDTH(STRB_WIDTH)
    )AXI_Arbiter_W(.*);

    AXI_Arbiter_R#(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ID_WIDTH(ID_WIDTH),
        .USER_WIDTH(USER_WIDTH)
    )AXI_Arbiter_R(.*);

endmodule