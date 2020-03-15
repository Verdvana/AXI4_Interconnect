//=============================================================================
//
//Module Name:					AXI4_Interconnect_TB.sv
//Department:					Xidian University
//Function Description:	        AXI总线连接器测试 
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

module AXI4_Interconnect_TB;

    /**********时钟&复位**********/
	logic           ACLK;
	logic      	    ARESETn;

    logic  [63:0]	m0_AWADDR;
    logic  [7:0]    m0_AWLEN;
    logic           m0_AWVALID;
    logic           m0_AWREADY;

    logic  [1023:0] m0_WDATA;
    logic           m0_WLAST;
    logic           m0_WVALID;
    logic           m0_WREADY;

    logic           m0_BVALID;
    logic           m0_BREADY;
    
    logic  [63:0]   m0_ARADDR;
    logic  [7:0]    m0_ARLEN;
    logic           m0_ARVALID;
    logic           m0_ARREADY;

    logic           m0_RVALID;
    logic           m0_RREADY;

    logic  [63:0]	m1_AWADDR;
    logic  [7:0]    m1_AWLEN;
    logic           m1_AWVALID;
    logic           m1_AWREADY;

    logic  [1023:0] m1_WDATA;
    logic           m1_WLAST;
    logic           m1_WVALID;
    logic           m1_WREADY;

    logic           m1_BVALID;
    logic           m1_BREADY;
    
    logic  [63:0]   m1_ARADDR;
    logic  [7:0]    m1_ARLEN;
    logic           m1_ARVALID;
    logic           m1_ARREADY;

    logic           m1_RVALID;
    logic           m1_RREADY;

	logic    		m_BVALID;
	logic  [1023:0] m_RDATA;
	logic 		    m_RLAST;
	logic 	        m_RVALID;

    logic           s0_AWVALID;
    logic  	        s0_AWREADY;
    logic           s0_WVALID;
    logic 		    s0_WREADY;
	logic    		s0_BVALID;
    logic           s0_BREADY;
    logic           s0_ARVALID;
	logic 		    s0_ARREADY;
	logic  [1023:0] s0_RDATA;
	logic 		    s0_RLAST;
	logic		    s0_RVALID;  
    logic           s0_RREADY;

    logic           s1_AWVALID;
    logic  	        s1_AWREADY;
    logic           s1_WVALID;
    logic 		    s1_WREADY;
	logic    		s1_BVALID;
    logic           s1_BREADY;
    logic           s1_ARVALID;
	logic 		    s1_ARREADY;
	logic  [1023:0] s1_RDATA;
	logic 		    s1_RLAST;
	logic		    s1_RVALID;  
    logic           s1_RREADY;

    logic  [63:0]	s_AWADDR;
    logic  [63:0]   s_AWLEN;


    logic  [1023:0] s_WDATA;
    logic           s_WLAST;
    logic           s_WVALID;


    logic  [63:0]   s_ARADDR;
    logic  [7:0]    s_ARLEN;
    

    


    logic               en_w_0;
    logic               en_r_0;
    logic    [7:0]      awlen_0;
    logic  [63:0]       addr_start_0;

    logic [1023:0]      data_r_0;

    logic               en_w_1;
    logic               en_r_1;
    logic    [7:0]      awlen_1;
    logic  [63:0]       addr_start_1;

    logic [1023:0]      data_r_1;

    //=========================================================
    //0号主机例化
    AXI_Master u0_AXI_Master(
        .ACLK       (ACLK),
        .ARESETn    (ARESETn),

        .AWADDR     (m0_AWADDR),
        .AWLEN      (m0_AWLEN),
        .AWVALID    (m0_AWVALID),
        .AWREADY    (m0_AWREADY),

        .WDATA      (m0_WDATA),
        .WLAST      (m0_WLAST),
        .WVALID     (m0_WVALID),
        .WREADY     (m0_WREADY),

        .BVALID     (m0_BVALID),
        .BREADY     (m0_BREADY),

        .ARADDR     (m0_ARADDR),
        .ARVALID    (m0_ARVALID),
        .ARREADY    (m0_ARREADY),

        .RDATA      (m_RDATA),
        .RLAST      (m_RLAST),
        .RVALID     (m0_RVALID),
        .RREADY     (m0_RREADY),

        .en_w       (en_w_0),
        .en_r       (en_r_0),
        .awlen      (awlen_0),
        .addr_start (addr_start_0),
        .data_r     (data_r_0)
    );

    //=========================================================
    //1号主机例化
    AXI_Master u1_AXI_Master(
        .ACLK       (ACLK),
        .ARESETn    (ARESETn),

        .AWADDR     (m1_AWADDR),
        .AWLEN      (m1_AWLEN),
        .AWVALID    (m1_AWVALID),
        .AWREADY    (m1_AWREADY),

        .WDATA      (m1_WDATA),
        .WLAST      (m1_WLAST),
        .WVALID     (m1_WVALID),
        .WREADY     (m1_WREADY),

        .BVALID     (m1_BVALID),
        .BREADY     (m1_BREADY),

        .ARADDR     (m1_ARADDR),
        .ARVALID    (m1_ARVALID),
        .ARREADY    (m1_ARREADY),

        .RDATA      (m_RDATA),
        .RLAST      (m_RLAST),
        .RVALID     (m1_RVALID),
        .RREADY     (m1_RREADY),

        .en_w       (en_w_1),
        .en_r       (en_r_1),
        .awlen      (awlen_1),
        .addr_start (addr_start_1),
        .data_r     (data_r_1)
    );

    //=========================================================
    //AXI4连接器例化
    AXI4_Interconnect u_AXI4_Interconnect(
    .ACLK           (ACLK),
	.ARESETn        (ARESETn),

	.m0_AWID        (),
    .m0_AWADDR      (m0_AWADDR),
    .m0_AWLEN       (m0_AWLEN),
    .m0_AWSIZE      (),
    .m0_AWBURST     (),
    .m0_AWLOCK      (),
    .m0_AWCACHE     (),
    .m0_AWPROT      (),
    .m0_AWQOS       (),
    .m0_AWREGION    (),
    .m0_AWUSER      (),
    .m0_AWVALID     (m0_AWVALID),
    .m0_AWREADY     (m0_AWREADY),

    .m0_WID         (),
    .m0_WDATA       (m0_WDATA),
    .m0_WSTRB       (),
    .m0_WLAST       (m0_WLAST),
    .m0_WUSER       (),
    .m0_WVALID      (m0_WVALID),
    .m0_WREADY      (m0_WREADY),
    
    .m0_BVALID      (m0_BVALID),
    .m0_BREADY      (m0_BREADY),
    .m0_ARID        (),
    .m0_ARADDR      (m0_ARADDR),
    .m0_ARLEN       (m0_ARLEN),
    .m0_ARSIZE      (),
    .m0_ARBURST     (),
    .m0_ARLOCK      (),
    .m0_ARCACHE     (),
    .m0_ARPROT      (),
    .m0_ARQOS       (),
    .m0_ARREGION    (),
    .m0_ARUSER      (),
    .m0_ARVALID     (m0_ARVALID),
    .m0_ARREADY     (m0_ARREADY),
    
    .m0_RVALID      (m0_RVALID),
    .m0_RREADY      (m0_RREADY),

    .m1_AWID        (),
    .m1_AWADDR      (m1_AWADDR),
    .m1_AWLEN       (m1_AWLEN),
    .m1_AWSIZE      (),
    .m1_AWBURST     (),
    .m1_AWLOCK      (),
    .m1_AWCACHE     (),
    .m1_AWPROT      (),
    .m1_AWQOS       (),
    .m1_AWREGION    (),
    .m1_AWUSER      (),
    .m1_AWVALID     (m1_AWVALID),
    .m1_AWREADY     (m1_AWREADY),
    
    .m1_WID         (),
    .m1_WDATA       (m1_WDATA),
    .m1_WSTRB       (),
    .m1_WLAST       (m1_WLAST),
    .m1_WUSER       (),
    .m1_WVALID      (m1_WVALID),
    .m1_WREADY      (m1_WREADY),
    
    .m1_BVALID      (m1_BVALID),
    .m1_BREADY      (m1_BREADY),

    .m1_ARID        (),
    .m1_ARADDR      (m1_ARADDR),
    .m1_ARLEN       (m1_ARLEN),
    .m1_ARSIZE      (),
    .m1_ARBURST     (),
    .m1_ARLOCK      (),
    .m1_ARCACHE     (),
    .m1_ARPROT      (),
    .m1_ARQOS       (),
    .m1_ARREGION    (),
    .m1_ARUSER      (),
    .m1_ARVALID     (m1_ARVALID),
    .m1_ARREADY     (m1_ARREADY),
    
    .m1_RVALID      (m1_RVALID),
    .m1_RREADY      (m1_RREADY),

    .m2_AWID        (),
    .m2_AWADDR      (),
    .m2_AWLEN       (),
    .m2_AWSIZE      (),
    .m2_AWBURST     (),
    .m2_AWLOCK      (),
    .m2_AWCACHE     (),
    .m2_AWPROT      (),
    .m2_AWQOS       (),
    .m2_AWREGION    (),
    .m2_AWUSER      (),
    .m2_AWVALID     (),
    .m2_AWREADY     (),
    
    .m2_WID         (),
    .m2_WDATA       (),
    .m2_WSTRB       (),
    .m2_WLAST       (),
    .m2_WUSER       (),
    .m2_WVALID      (),
    .m2_WREADY      (),

    .m2_BVALID      (),
    .m2_BREADY      (),

    .m2_ARID        (),
    .m2_ARADDR      (),
    .m2_ARLEN       (),
    .m2_ARSIZE      (),
    .m2_ARBURST     (),
    .m2_ARLOCK      (),
    .m2_ARCACHE     (),
    .m2_ARPROT      (),
    .m2_ARQOS       (),
    .m2_ARREGION    (),
    .m2_ARUSER      (),
    .m2_ARVALID     (),
    .m2_ARREADY     (),
    
    .m2_RVALID      (),
    .m2_RREADY      (),

    .m3_AWID        (),
    .m3_AWADDR      (),
    .m3_AWLEN       (),
    .m3_AWSIZE      (),
    .m3_AWBURST     (),
    .m3_AWLOCK      (),
    .m3_AWCACHE     (),
    .m3_AWPROT      (),
    .m3_AWQOS       (),
    .m3_AWREGION    (),
    .m3_AWUSER      (),
    .m3_AWVALID     (),
    .m3_AWREADY     (),

    .m3_WID         (),
    .m3_WDATA       (),
    .m3_WSTRB       (),
    .m3_WLAST       (),
    .m3_WUSER       (),
    .m3_WVALID      (),
    .m3_WREADY      (),

    .m3_BVALID      (),
    .m3_BREADY      (),

    .m3_ARID        (),
    .m3_ARADDR      (),
    .m3_ARLEN       (),
    .m3_ARSIZE      (),
    .m3_ARBURST     (),
    .m3_ARLOCK      (),
    .m3_ARCACHE     (),
    .m3_ARPROT      (),
    .m3_ARQOS       (),
    .m3_ARREGION    (),
    .m3_ARUSER      (),
    .m3_ARVALID     (),
    .m3_ARREADY     (),

    .m3_RVALID      (),
    .m3_RREADY      (),


	.m_BID          (),
	.m_BRESP        (),
	.m_BUSER        (),
	.m_RID          (),
	.m_RDATA        (m_RDATA),
	.m_RRESP        (),
	.m_RLAST        (m_RLAST),
	.m_RUSER        (),

    .s0_AWVALID     (s0_AWVALID),
    .s0_AWREADY     (s0_AWREADY),
    .s0_WREADY      (s0_WREADY),
    .s0_WVALID      (s0_WVALID),
	.s0_BID         (),
	.s0_BRESP       (),
	.s0_BUSER       (),
	.s0_BVALID      (s0_BVALID),
    .s0_BREADY      (s0_BREADY),
    .s0_ARVALID     (s0_ARVALID),
	.s0_ARREADY     (s0_ARREADY),
	.s0_RID         (),
	.s0_RDATA       (s0_RDATA),
	.s0_RRESP       (),
	.s0_RLAST       (s0_RLAST),
	.s0_RUSER       (),
	.s0_RVALID      (s0_RVALID),  
    .s0_RREADY      (s0_RREADY),

    .s1_AWVALID     (s1_AWVALID),
    .s1_AWREADY     (s1_AWREADY),
    .s1_WVALID      (s1_WVALID),
    .s1_WREADY      (s1_WREADY),
	.s1_BID         (),
	.s1_BRESP       (),
	.s1_BUSER       (),
	.s1_BVALID      (s1_BVALID),
    .s1_BREADY      (s1_BREADY),
    .s1_ARVALID     (s1_ARVALID),
	.s1_ARREADY     (s1_ARREADY),
	.s1_RID         (),
	.s1_RDATA       (s1_RDATA),
	.s1_RRESP       (),
	.s1_RLAST       (s1_RLAST),
	.s1_RUSER       (),
	.s1_RVALID      (s1_RVALID),
    .s1_RREADY      (s1_RREADY),

    .s2_AWVALID     (),
    .s2_AWREADY     (),
    .s2_WVALID      (),
    .s2_WREADY      (),
	.s2_BID         (),
	.s2_BRESP       (),
	.s2_BUSER       (),
	.s2_BVALID      (),
    .s2_BREADY      (),
    .s2_ARVALID     (),
	.s2_ARREADY     (),
	.s2_RID         (),
	.s2_RDATA       (),
	.s2_RRESP       (),
	.s2_RLAST       (),
	.s2_RUSER       (),
	.s2_RVALID      (),
    .s2_RREADY      (),

    .s3_AWVALID     (),
    .s3_AWREADY     (),
    .s3_WVALID      (),
    .s3_WREADY      (),
	.s3_BID         (),
	.s3_BRESP       (),
	.s3_BUSER       (),
	.s3_BVALID      (),
    .s3_BREADY      (),
    .s3_ARVALID     (),
	.s3_ARREADY     (),
	.s3_RID         (),
	.s3_RDATA       (),
	.s3_RRESP       (),
	.s3_RLAST       (),
	.s3_RUSER       (),
	.s3_RVALID      (), 
    .s3_RREADY      (),

    .s4_AWVALID     (),
    .s4_AWREADY     (),
    .s4_WVALID      (),
    .s4_WREADY      (),
	.s4_BID         (),
	.s4_BRESP       (),
	.s4_BUSER       (),
	.s4_BVALID      (),
    .s4_BREADY      (),
    .s4_ARVALID     (),
	.s4_ARREADY     (),
	.s4_RID         (),
	.s4_RDATA       (),
	.s4_RRESP       (),
	.s4_RLAST       (),
	.s4_RUSER       (),
	.s4_RVALID      (), 
    .s4_RREADY      (),

    .s5_AWVALID     (),
    .s5_AWREADY     (),
    .s5_WVALID      (),
    .s5_WREADY      (),
	.s5_BID         (),
	.s5_BRESP       (),
	.s5_BUSER       (),
	.s5_BVALID      (),
    .s5_BREADY      (),
    .s5_ARVALID     (),
	.s5_ARREADY     (),
	.s5_RID         (),
	.s5_RDATA       (),
	.s5_RRESP       (),
	.s5_RLAST       (),
	.s5_RUSER       (),
	.s5_RVALID      (), 
    .s5_RREADY      (),

    .s6_AWVALID     (),
    .s6_AWREADY     (),
    .s6_WVALID      (),
    .s6_WREADY      (),
	.s6_BID         (),
	.s6_BRESP       (),
	.s6_BUSER       (),
	.s6_BVALID      (),
    .s6_BREADY      (),
    .s6_ARVALID     (),
	.s6_ARREADY     (),
	.s6_RID         (),
	.s6_RDATA       (),
	.s6_RRESP       (),
	.s6_RLAST       (),
	.s6_RUSER       (),
	.s6_RVALID      (), 
    .s6_RREADY      (),

    .s7_AWVALID     (),
    .s7_AWREADY     (),
    .s7_WVALID      (),
    .s7_WREADY      (),
	.s7_BID         (),
	.s7_BRESP       (),
	.s7_BUSER       (),
	.s7_BVALID      (),
    .s7_BREADY      (),
    .s7_ARVALID     (),
	.s7_ARREADY     (),
	.s7_RID         (),
	.s7_RDATA       (),
	.s7_RRESP       (),
	.s7_RLAST       (),
	.s7_RUSER       (),
	.s7_RVALID      (), 
    .s7_RREADY      (),

    .s_AWID         (),
    .s_AWADDR       (s_AWADDR),
    .s_AWLEN        (s_AWLEN),
    .s_AWSIZE       (),
    .s_AWBURST      (),
    .s_AWLOCK       (),
    .s_AWCACHE      (),
    .s_AWPROT       (),
    .s_AWQOS        (),
    .s_AWREGION     (),
    .s_AWUSER       (),

    .s_WID          (),
    .s_WDATA        (s_WDATA),
    .s_WSTRB        (),
    .s_WLAST        (s_WLAST),
    .s_WUSER        (),


    .s_ARID         (),    
    .s_ARADDR       (s_ARADDR),
    .s_ARLEN        (s_ARLEN),
    .s_ARSIZE       (),
    .s_ARBURST      (),
    .s_ARLOCK       (),
    .s_ARCACHE      (),
    .s_ARPROT       (),
    .s_ARQOS        (),
    .s_ARREGION     (),
    .s_ARUSER       ()
    );

    //=========================================================
    //0号从机例化
    AXI_Slave u0_AXI_Slave(
        .ACLK       (ACLK),
        .ARESETn    (ARESETn),

        .AWADDR     (s_AWADDR),
        .AWLEN      (s_AWLEN),
        .AWVALID    (s0_AWVALID),
        .AWREADY    (s0_AWREADY),

        .WDATA      (s_WDATA),
        .WLAST      (s_WLAST),
        .WVALID     (s0_WVALID),
        .WREADY     (s0_WREADY),

        .BVALID     (s0_BVALID),
        .BREADY     (s0_BREADY),

        .ARADDR     (s_ARADDR),
        .ARVALID    (s0_ARVALID),
        .ARREADY    (s0_ARREADY),

        .RDATA      (s0_RDATA),
        .RLAST      (s0_RLAST),
        .RVALID     (s0_RVALID),
        .RREADY     (s0_RREADY)
    );

    //=========================================================
    //1号从机例化
    AXI_Slave u1_AXI_Slave(
        .ACLK       (ACLK),
        .ARESETn    (ARESETn),

        .AWADDR     (s_AWADDR),
        .AWLEN      (s_AWLEN),
        .AWVALID    (s1_AWVALID),
        .AWREADY    (s1_AWREADY),

        .WDATA      (s_WDATA),
        .WLAST      (s_WLAST),
        .WVALID     (s1_WVALID),
        .WREADY     (s1_WREADY),

        .BVALID     (s1_BVALID),
        .BREADY     (s1_BREADY),

        .ARADDR     (s_ARADDR),
        .ARVALID    (s1_ARVALID),
        .ARREADY    (s1_ARREADY),

        .RDATA      (s1_RDATA),
        .RLAST      (s1_RLAST),
        .RVALID     (s1_RVALID),
        .RREADY     (s1_RREADY)
    );

    //=========================================================
    //常量
    parameter   PERIOD  =   20, //时钟周期
                TCO     =   1;  //寄存器延迟

    //=========================================================
    //时钟激励
    initial begin
        ACLK = '0;
        forever #(PERIOD/2) ACLK = ~ACLK;
    end

    //=========================================================
    //复位&初始化任务
    task task_init;
        ARESETn      = '0;
        //初始化
        en_w_0       = '0;
        en_r_0       = '0;
        awlen_0      = 8'b0000_1111;    //写入/读取数据次数
        addr_start_0 = '0;

        en_w_1       = '0;
        en_r_1       = '0;
        awlen_1      = 8'b0000_0111;
        addr_start_1 = '0;
        //复位
        #PERIOD;#PERIOD;
        ARESETn = '1;
        #PERIOD;#PERIOD;
        #2;//输入延迟
    endtask

    //=========================================================
    //0号主机写任务
    task task_m0_w(input [63:0] addr_start);
    begin
        addr_start_0 = addr_start;
        en_w_0       = '1;
        #PERIOD;
        en_w_0       = '0;
        #400;
    end
    endtask

    //=========================================================
    //0号主机读任务
    task task_m0_r(input [63:0] addr_start);
    begin
        addr_start_0 = addr_start;
        en_r_0       = '1;
        #PERIOD;
        en_r_0       = '0;
        #400;
    end
    endtask


    //=========================================================
    //1号主机写任务
    task task_m1_w(input [63:0] addr_start);
    begin
        addr_start_1 = addr_start;
        en_w_1 = '1;
        #PERIOD;
        en_w_1 = '0;
        #400;
    end
    endtask

    //=========================================================
    //1号主机读任务
    task task_m1_r(input [63:0] addr_start);
    begin
        addr_start_0 = addr_start;
        en_r_1 = '1;
        #PERIOD;
        en_r_1 = '0;
        #400;
    end
    endtask



    initial begin
        //复位&初始化
        task_init;

        //0号主机给0号从机写入和读取
        task_m0_w(64'h5);
        task_m0_r(64'h5);

        //1号主机给0号从机写入和读取
        task_m1_w(64'h15);
        task_m1_r(64'h15);

        //1号主机给1号从机写入和读取
        task_m1_w(64'h2000_0000_0000_0011);
        task_m1_r(64'h2000_0000_0000_0011);

        //0号主机1号主机同时发出请求
        fork 
            task_m1_w(64'h2000_0000_0000_0001);
            task_m0_w(64'h0);
        join


        #400;
        $stop;
    end

endmodule