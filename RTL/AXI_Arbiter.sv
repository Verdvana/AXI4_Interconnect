//=============================================================================
//
//Module Name:					AXI_Arbiter.sv
//Department:					Xidian University
//Function Description:	        AXI总线仲裁器 
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana	Verdvana	Verdvana		  			2020-3-13
//
//------------------------------------------------------------------------------
//
//Version	Modified History
//V1.0		
//
//=============================================================================

`timescale 1ns/1ns

module AXI_Arbiter (
	/**********时钟&复位**********/
	input           ACLK,
	input      	    ARESETn,
	/********** 0号主控 **********/
	input      	    m0_AWVALID,
    input      	    m0_WVALID,
    input           m0_WLAST,
    input           m0_BREADY,
    input      	    m0_ARVALID,
	/********** 1号主控 **********/
	input      	    m1_AWVALID,
    input      	    m1_WVALID,
    input           m1_WLAST,
    input           m1_BREADY,
    input      	    m1_ARVALID,
	/********** 2号主控 **********/
	input      	    m2_AWVALID,
    input      	    m2_WVALID,
    input           m2_WLAST,
    input           m2_BREADY,
    input      	    m2_ARVALID,
	/********** 3号主控 **********/
	input      	    m3_AWVALID,
    input      	    m3_WVALID,
    input           m3_WLAST,
    input           m3_BREADY,
    input      	    m3_ARVALID,
    /********* 通用信号 *********/
    input           m_AWREADY,
    input           m_WREADY,
    input           m_ARREADY,
    input           m_RVALID,
    input           m_RLAST,
    input           s_RREADY,
    input           m_BVALID,
    /***** 读写通道仲裁结果 ******/
	output          m0_wgrnt,
    output          m0_rgrnt,
	output    	    m1_wgrnt,
    output          m1_rgrnt,
    output          m2_wgrnt,
    output          m2_rgrnt,
    output          m3_wgrnt,
    output          m3_rgrnt
);

    //=========================================================
    //写通道仲裁状态机例化
    AXI_Arbiter_W u_AXI_Arbiter_W(.*);

    //=========================================================
    //读通道仲裁状态机例化
    AXI_Arbiter_R u_AXI_Arbiter_R(.*);

endmodule