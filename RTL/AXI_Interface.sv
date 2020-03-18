//=============================================================================
//
//Module Name:					AXI_Interface.sv
//Department:					Xidian University
//Function Description:	        AXI接口
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

interface axi4;


//写地址通道
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


	modport master(
		//写地址通道
		output	  		AWID,
		output	  		AWADDR,
		output	  		AWLEN,
		output	  		AWSIZE,
		output	  		AWBURST,
		output	  		AWLOCK,
		output	  		AWCACHE,
		output	  		AWPROT,
		output	  		AWQOS,
		output	  		AWREGION,
		output	  		AWUSER,
		output	 		AWVALID,
		input	 		AWREADY,
		//写数据通道
		output			WID,
		output			WDATA,
		output			WSTRB,
		output			WLAST,
		output			WUSER,
		output	  		WVALID,
		input	  		WREADY,
		//写响应通道
		input			BID,
		input			BRESP,
		input			BUSER,
		input	  		BVALID,
		output	  		BREADY,
		//读地址地址
		output	  		ARID,
		output	  		ARADDR,
		output	  		ARLEN,
		output	  		ARSIZE,
		output	  		ARBURST,
		output	  		ARLOCK,
		output	  		ARCACHE,
		output	  		ARPROT,
		output	  		ARQOS,
		output	  		ARREGION,
		output	  		ARUSER,
		output	  		ARVALID,
		input	  		ARREADY,
		//读数据通道
		input	  		RID,
		input	  		RDATA,
		input	  		RRESP,
		input	  		RLAST,
		input	  		RUSER,
		input	 		RVALID,
		output	 		RREADY
	);



	modport slave(
		//写地址通道
		input	  		AWID,
		input	  		AWADDR,
		input	  		AWLEN,
		input	  		AWSIZE,
		input	  		AWBURST,
		input	  		AWLOCK,
		input	  		AWCACHE,
		input	  		AWPROT,
		input	  		AWQOS,
		input	  		AWREGION,
		input	  		AWUSER,
		input	 		AWVALID,
		output	 		AWREADY,
		//写数据通道
		input			WID,
		input			WDATA,
		input			WSTRB,
		input			WLAST,
		input			WUSER,
		input	  		WVALID,
		output	  		WREADY,
		//写响应通道
		output			BID,
		output			BRESP,
		output			BUSER,
		output	  		BVALID,
		input	  		BREADY,
		//读地址地址
		input	  		ARID,
		input	  		ARADDR,
		input	  		ARLEN,
		input	  		ARSIZE,
		input	  		ARBURST,
		input	  		ARLOCK,
		input	  		ARCACHE,
		input	  		ARPROT,
		input	  		ARQOS,
		input	  		ARREGION,
		input	  		ARUSER,
		input	  		ARVALID,
		output	  		ARREADY,
		//读数据通道
		output	  		RID,
		output	  		RDATA,
		output	  		RRESP,
		output	  		RLAST,
		output	  		RUSER,
		output	 		RVALID,
		input	 		RREADY
	);

endinterface