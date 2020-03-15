//=============================================================================
//
//Module Name:					AXI_Arbiter_W_TB.sv
//Department:					Xidian University
//Function Description:	        AXI总线仲裁器写仲裁测试
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

module AXI_Arbiter_W_TB;

	/**********时钟&复位**********/
	logic           ACLK;
	logic      	    ARESETn;
	/**********仲裁信号***********/
	// 0号总线主控
	logic      	    m0_AWVALID;
    logic      	    m0_WVALID;
    logic           m0_WLAST;
    logic           m0_BREADY;

	logic           m0_wgrnt;
	// 1号总线主控
	logic      	    m1_AWVALID;
    logic      	    m1_WVALID;
    logic           m1_WLAST;
    logic           m1_BREADY;

	logic   	    m1_wgrnt;
	// 2号总线主控
	logic      	    m2_AWVALID;
    logic      	    m2_WVALID;
    logic           m2_WLAST;
    logic           m2_BREADY;

    logic           m2_wgrnt;
	// 3号总线主控
	logic      	    m3_AWVALID;
    logic      	    m3_WVALID;
    logic           m3_WLAST;
    logic           m3_BREADY;

    logic           m3_wgrnt;
    /**********应答信号***********/


    logic	[31:0]		AWID;
	logic	[63:0]		AWADDR;
	logic	[7:0]		AWLEN;
	logic	[2:0]		AWSIZE;
	logic	[1:0]		AWBURST;
	logic	  			AWLOCK;
	logic	[3:0]		AWCACHE;
	logic	[2:0]		AWPROT;
	logic	[3:0]		AWQOS;
	logic	[3:0]		AWREGION;
	logic	[1023:0]	AWUSER;
	logic	 			AWVALID;
	logic	 			AWREADY;
	
	
	//写数据通道	
	logic	[31:0]		WID;
	logic	[1023:0]	WDATA;
	logic	[127:0]		WSTRB;
	logic	  			WLAST;
	logic	[1023:0]	WUSER;
	logic	  			WVALID;
	logic	  			WREADY;
	
	//写响应通道	
	logic	[31:0]		BID;
	logic	[1:0]		BRESP;
	logic	[1023:0]	BUSER;
	logic	  			BVALID;
	logic	  			BREADY;
	
	//读地址地址	
	logic	[31:0]		ARID;
	logic	[63:0]		ARADDR;
	logic	[7:0]		ARLEN;
	logic	[2:0]		ARSIZE;
	logic	[1:0]		ARBURST;
	logic	  			ARLOCK;
	logic	[3:0]		ARCACHE;
	logic	[2:0]		ARPROT;
	logic	[3:0]		ARQOS;
	logic	[3:0]		ARREGION;
	logic	[1023:0]	ARUSER;
	logic	  			ARVALID;
	logic	  			ARREADY;
	
	//读数据通道	
	logic	[31:0]		RID;
	logic	[1023:0]	RDATA;
	logic	[1:0]		RRESP;
	logic	 			RLAST;
	logic	[1023:0]	RUSER;
	logic	 			RVALID;
	logic	 			RREADY;

    logic               en_w;
    logic               en_r;
    logic    [7:0]      awlen;
    logic  [63:0]       addr_start;

    logic [1023:0]      data_r;

    parameter   PERIOD  =   20,
                TCO     =   1;

    //AXI_Arbiter_W u_AXI_Arbiter_W(.*);

    AXI_Master u_AXI_Master(
        .ACLK       ,
        .ARESETn    ,

        .AWADDR     ,
        .AWLEN      ,
        .AWVALID    ,
        .AWREADY    ,

        .WDATA      ,
        .WLAST      ,
        .WVALID     ,
        .WREADY     ,

        .BVALID     ,
        .BREADY     ,

        .ARADDR     ,
        .ARVALID    ,
        .ARREADY    ,

        .RDATA      ,
        .RLAST      ,
        .RVALID     ,
        .RREADY     ,

        .en_w       ,
        .en_r       ,
        .awlen      ,
        .addr_start ,
        .data_r
    );

    AXI_Slave u_AXI_Slave(
        .ACLK       ,
        .ARESETn    ,

        .AWADDR     ,
        .AWLEN      ,
        .AWVALID    ,
        .AWREADY    ,

        .WDATA      ,
        .WLAST      ,
        .WVALID     ,
        .WREADY     ,

        .BVALID     ,
        .BREADY     ,

        .ARADDR     ,
        .ARVALID    ,
        .ARREADY    ,

        .RDATA      ,
        .RLAST      ,
        .RVALID     ,
        .RREADY
    );

    initial begin
        ACLK = '0;
        forever #(PERIOD/2) ACLK = ~ACLK;
    end

    task task_init;
        ARESETn = '0;

        en_w    = '0;
        en_r    = '0;
        awlen = 8'b0000_1111;
        addr_start = 64'd28;

        #PERIOD;#PERIOD;
        ARESETn = '1;
        #PERIOD;#PERIOD;
    endtask

    initial begin
        task_init;

        #2 en_w = '1;
        #PERIOD;
        en_w = '0;

        # 600;

        en_r = '1;
        #PERIOD;
        en_r = '0;

        # 600;
        addr_start = 64'd3;

        en_w = '1;
        #PERIOD;
        en_w = '0;

        # 600;

        en_r = '1;
        #PERIOD;
        en_r = '0;

        


        #1000;

        $stop;
    end



endmodule