//=============================================================================
//
//Module Name:					AXI_Master_Mux.sv
//Department:					Xidian University
//Function Description:	        AXI总线主控用多路复用器
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

module AXI_Master_Mux (
    /********** 0号主控 **********/
	input      [31:0]   m0_AWID,
    input	   [63:0]	m0_AWADDR,
    input      [7:0]    m0_AWLEN,
    input      [7:0]    m0_AWSIZE,
    input      [2:0]    m0_AWBURST,
    input               m0_AWLOCK,
    input      [3:0]    m0_AWCACHE,
    input      [2:0]    m0_AWPROT,
    input      [3:0]    m0_AWQOS,
    input      [3:0]    m0_AWREGION,
    input      [1023:0] m0_AWUSER,
    input               m0_AWVALID,
    output reg          m0_AWREADY,
    input      [31:0]   m0_WID,
    input      [1023:0] m0_WDATA,
    input      [127:0]  m0_WSTRB,
    input               m0_WLAST,
    input      [1023:0] m0_WUSER,
    input               m0_WVALID,
    output reg          m0_WREADY,
    output reg          m0_BVALID,
    input               m0_BREADY,
    input      [31:0]   m0_ARID,
    input      [63:0]   m0_ARADDR,
    input      [7:0]    m0_ARLEN,
    input      [2:0]    m0_ARSIZE,
    input      [1:0]    m0_ARBURST,
    input               m0_ARLOCK,
    input      [3:0]    m0_ARCACHE,
    input      [2:0]    m0_ARPROT,
    input      [3:0]    m0_ARQOS,
    input      [3:0]    m0_ARREGION,
    input      [1023:0] m0_ARUSER,
    input               m0_ARVALID,
    output reg          m0_ARREADY,
    output reg          m0_RVALID,
    input               m0_RREADY,
    /********** 1号主控 **********/
    input      [31:0]   m1_AWID,
    input	   [63:0]	m1_AWADDR,
    input      [7:0]    m1_AWLEN,
    input      [7:0]    m1_AWSIZE,
    input      [2:0]    m1_AWBURST,
    input               m1_AWLOCK,
    input      [3:0]    m1_AWCACHE,
    input      [2:0]    m1_AWPROT,
    input      [3:0]    m1_AWQOS,
    input      [3:0]    m1_AWREGION,
    input      [1023:0] m1_AWUSER,
    input               m1_AWVALID,
    output reg          m1_AWREADY,
    input      [31:0]   m1_WID,
    input      [1023:0] m1_WDATA,
    input      [127:0]  m1_WSTRB,
    input               m1_WLAST,
    input      [1023:0] m1_WUSER,
    input               m1_WVALID,
    output reg          m1_WREADY,
    output reg          m1_BVALID,
    input               m1_BREADY,
    input      [31:0]   m1_ARID,
    input      [63:0]   m1_ARADDR,
    input      [7:0]    m1_ARLEN,
    input      [2:0]    m1_ARSIZE,
    input      [1:0]    m1_ARBURST,
    input               m1_ARLOCK,
    input      [3:0]    m1_ARCACHE,
    input      [2:0]    m1_ARPROT,
    input      [3:0]    m1_ARQOS,
    input      [3:0]    m1_ARREGION,
    input      [1023:0] m1_ARUSER,
    input               m1_ARVALID,
    output reg          m1_ARREADY,
    output reg          m1_RVALID,
    input               m1_RREADY,
    /********** 2号主控 **********/
    input      [31:0]   m2_AWID,
    input	   [63:0]	m2_AWADDR,
    input      [7:0]    m2_AWLEN,
    input      [7:0]    m2_AWSIZE,
    input      [2:0]    m2_AWBURST,
    input               m2_AWLOCK,
    input      [3:0]    m2_AWCACHE,
    input      [2:0]    m2_AWPROT,
    input      [3:0]    m2_AWQOS,
    input      [3:0]    m2_AWREGION,
    input      [1023:0] m2_AWUSER,
    input               m2_AWVALID,
    output reg          m2_AWREADY,
    input      [31:0]   m2_WID,
    input      [1023:0] m2_WDATA,
    input      [127:0]  m2_WSTRB,
    input               m2_WLAST,
    input      [1023:0] m2_WUSER,
    input               m2_WVALID,
    output reg          m2_WREADY,
    output reg          m2_BVALID,
    input               m2_BREADY,
    input      [31:0]   m2_ARID,
    input      [63:0]   m2_ARADDR,
    input      [7:0]    m2_ARLEN,
    input      [2:0]    m2_ARSIZE,
    input      [1:0]    m2_ARBURST,
    input               m2_ARLOCK,
    input      [3:0]    m2_ARCACHE,
    input      [2:0]    m2_ARPROT,
    input      [3:0]    m2_ARQOS,
    input      [3:0]    m2_ARREGION,
    input      [1023:0] m2_ARUSER,
    input               m2_ARVALID,
    output reg          m2_ARREADY,
    output reg          m2_RVALID,
    input               m2_RREADY,
    /********** 3号主控 **********/
    input      [31:0]   m3_AWID,
    input	   [63:0]	m3_AWADDR,
    input      [7:0]    m3_AWLEN,
    input      [7:0]    m3_AWSIZE,
    input      [2:0]    m3_AWBURST,
    input               m3_AWLOCK,
    input      [3:0]    m3_AWCACHE,
    input      [2:0]    m3_AWPROT,
    input      [3:0]    m3_AWQOS,
    input      [3:0]    m3_AWREGION,
    input      [1023:0] m3_AWUSER,
    input               m3_AWVALID,
    output reg          m3_AWREADY,
    input      [31:0]   m3_WID,
    input      [1023:0] m3_WDATA,
    input      [127:0]  m3_WSTRB,
    input               m3_WLAST,
    input      [1023:0] m3_WUSER,
    input               m3_WVALID,
    output reg          m3_WREADY,
    output reg          m3_BVALID,
    input               m3_BREADY,
    input      [31:0]   m3_ARID,
    input      [63:0]   m3_ARADDR,
    input      [7:0]    m3_ARLEN,
    input      [2:0]    m3_ARSIZE,
    input      [1:0]    m3_ARBURST,
    input               m3_ARLOCK,
    input      [3:0]    m3_ARCACHE,
    input      [2:0]    m3_ARPROT,
    input      [3:0]    m3_ARQOS,
    input      [3:0]    m3_ARREGION,
    input      [1023:0] m3_ARUSER,
    input               m3_ARVALID,
    output reg          m3_ARREADY,
    output reg          m3_RVALID,
    input               m3_RREADY,
    /******** 从机通用信号 ********/
    output reg [31:0]   s_AWID,
    output reg [63:0]	s_AWADDR,
    output reg [7:0]    s_AWLEN,
    output reg [7:0]    s_AWSIZE,
    output reg [2:0]    s_AWBURST,
    output reg          s_AWLOCK,
    output reg [3:0]    s_AWCACHE,
    output reg [2:0]    s_AWPROT,
    output reg [3:0]    s_AWQOS,
    output reg [3:0]    s_AWREGION,
    output reg [1023:0] s_AWUSER,
    output reg          s_AWVALID,
    output reg [31:0]   s_WID,
    output reg [1023:0] s_WDATA,
    output reg [127:0]  s_WSTRB,
    output reg          s_WLAST,
    output reg [1023:0] s_WUSER,
    output reg          s_WVALID,
    output reg          s_BREADY,
    output reg [31:0]   s_ARID,    
    output reg [63:0]   s_ARADDR,
    output reg [7:0]    s_ARLEN,
    output reg [2:0]    s_ARSIZE,
    output reg [1:0]    s_ARBURST,
    output reg          s_ARLOCK,
    output reg [3:0]    s_ARCACHE,
    output reg [2:0]    s_ARPROT,
    output reg [3:0]    s_ARQOS,
    output reg [3:0]    s_ARREGION,
    output reg [1023:0] s_ARUSER,
    output reg          s_ARVALID,
    output reg          s_RREADY,
    /******** 主控通用信号 ********/
    input               m_AWREADY,
    input               m_WREADY,
    input               m_ARREADY,
    input               m_BVALID,
    input               m_RVALID,
    /****** 读写通道仲裁结果 ******/
    input               m0_wgrnt,
    input               m0_rgrnt,
    input               m1_wgrnt,
    input               m1_rgrnt,
    input               m2_wgrnt,
    input               m2_rgrnt,
    input               m3_wgrnt,
    input               m3_rgrnt
);


    //=========================================================
    //写入通路的多路复用主控信号

    //---------------------------------------------------------
    //其他信号复用
    always_comb begin
        case({m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt})     //判断写入通路的仲裁结果
            4'b1000: begin
                s_AWID      =  m0_AWID;
                s_AWADDR    =  m0_AWADDR;
                s_AWLEN     =  m0_AWLEN;
                s_AWSIZE    =  m0_AWSIZE;
                s_AWBURST   =  m0_AWBURST;
                s_AWLOCK    =  m0_AWLOCK;
                s_AWCACHE   =  m0_AWCACHE;
                s_AWPROT    =  m0_AWPROT;
                s_AWQOS     =  m0_AWQOS;
                s_AWREGION  =  m0_AWREGION;
                s_AWUSER    =  m0_AWUSER;
                s_AWVALID   =  m0_AWVALID;
                s_WID       =  m0_WID;
                s_WDATA     =  m0_WDATA;
                s_WSTRB     =  m0_WSTRB;
                s_WLAST     =  m0_WLAST;
                s_WUSER     =  m0_WUSER;
                s_WVALID    =  m0_WVALID;
                s_BREADY    =  m0_BREADY;
            end
            4'b0100: begin
                s_AWID      =  m1_AWID;
                s_AWADDR    =  m1_AWADDR;
                s_AWLEN     =  m1_AWLEN;
                s_AWSIZE    =  m1_AWSIZE;
                s_AWBURST   =  m1_AWBURST;
                s_AWLOCK    =  m1_AWLOCK;
                s_AWCACHE   =  m1_AWCACHE;
                s_AWPROT    =  m1_AWPROT;
                s_AWQOS     =  m1_AWQOS;
                s_AWREGION  =  m1_AWREGION;
                s_AWUSER    =  m1_AWUSER;
                s_AWVALID   =  m1_AWVALID;
                s_WID       =  m1_WID;
                s_WDATA     =  m1_WDATA;
                s_WSTRB     =  m1_WSTRB;
                s_WLAST     =  m1_WLAST;
                s_WUSER     =  m1_WUSER;
                s_WVALID    =  m1_WVALID;
                s_BREADY    =  m1_BREADY;
            end
            4'b0010: begin
                s_AWID      =  m2_AWID;
                s_AWADDR    =  m2_AWADDR;
                s_AWLEN     =  m2_AWLEN;
                s_AWSIZE    =  m2_AWSIZE;
                s_AWBURST   =  m2_AWBURST;
                s_AWLOCK    =  m2_AWLOCK;
                s_AWCACHE   =  m2_AWCACHE;
                s_AWPROT    =  m2_AWPROT;
                s_AWQOS     =  m2_AWQOS;
                s_AWREGION  =  m2_AWREGION;
                s_AWUSER    =  m2_AWUSER;
                s_AWVALID   =  m2_AWVALID;
                s_WID       =  m2_WID;
                s_WDATA     =  m2_WDATA;
                s_WSTRB     =  m2_WSTRB;
                s_WLAST     =  m2_WLAST;
                s_WUSER     =  m2_WUSER;
                s_WVALID    =  m2_WVALID;
                s_BREADY    =  m2_BREADY;
            end
            4'b0001: begin
                s_AWID      =  m3_AWID;
                s_AWADDR    =  m3_AWADDR;
                s_AWLEN     =  m3_AWLEN;
                s_AWSIZE    =  m3_AWSIZE;
                s_AWBURST   =  m3_AWBURST;
                s_AWLOCK    =  m3_AWLOCK;
                s_AWCACHE   =  m3_AWCACHE;
                s_AWPROT    =  m3_AWPROT;
                s_AWQOS     =  m3_AWQOS;
                s_AWREGION  =  m3_AWREGION;
                s_AWUSER    =  m3_AWUSER;
                s_AWVALID   =  m3_AWVALID;
                s_WID       =  m3_WID;
                s_WDATA     =  m3_WDATA;
                s_WSTRB     =  m3_WSTRB;
                s_WLAST     =  m3_WLAST;
                s_WUSER     =  m3_WUSER;
                s_WVALID    =  m3_WVALID;
                s_BREADY    =  m3_BREADY;
            end
            default: begin
                s_AWID      =  '0;
                s_AWADDR    =  '0;
                s_AWLEN     =  '0;
                s_AWSIZE    =  '0;
                s_AWBURST   =  '0;
                s_AWLOCK    =  '0;
                s_AWCACHE   =  '0;
                s_AWPROT    =  '0;
                s_AWQOS     =  '0;
                s_AWREGION  =  '0;
                s_AWUSER    =  '0;
                s_AWVALID   =  '0;
                s_WID       =  '0;
                s_WDATA     =  '0;
                s_WSTRB     =  '0;
                s_WLAST     =  '0;
                s_WUSER     =  '0;
                s_WVALID    =  '0;
                s_BREADY    =  '0;
            end
        endcase
    end

    //---------------------------------------------------------
    //AWREADY信号复用
    always_comb begin
        case({m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt})
            4'b1000: begin 
                m0_AWREADY = m_AWREADY;
                m1_AWREADY = '0;
                m2_AWREADY = '0;
                m3_AWREADY = '0;
            end
            4'b0100: begin
                m0_AWREADY = '0;
                m1_AWREADY = m_AWREADY;
                m2_AWREADY = '0;
                m3_AWREADY = '0;
            end
            4'b0010: begin
                m0_AWREADY = '0;
                m1_AWREADY = '0;
                m2_AWREADY = m_AWREADY;
                m3_AWREADY = '0;
            end
            4'b0001: begin
                m0_AWREADY = '0;
                m1_AWREADY = '0;
                m2_AWREADY = '0;
                m3_AWREADY = m_AWREADY;
            end
            default: begin
                m0_AWREADY = '0;
                m1_AWREADY = '0;
                m2_AWREADY = '0;
                m3_AWREADY = '0;
            end
        endcase
    end

    //---------------------------------------------------------
    //WREADY信号复用
    always_comb begin
        case({m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt})
            4'b1000: begin 
                m0_WREADY = m_WREADY;
                m1_WREADY = '0;
                m2_WREADY = '0;
                m3_WREADY = '0;
            end
            4'b0100: begin
                m0_WREADY = '0;
                m1_WREADY = m_WREADY;
                m2_WREADY = '0;
                m3_WREADY = '0;
            end
            4'b0010: begin
                m0_WREADY = '0;
                m1_WREADY = '0;
                m2_WREADY = m_WREADY;
                m3_WREADY = '0;
            end
            4'b0001: begin
                m0_WREADY = '0;
                m1_WREADY = '0;
                m2_WREADY = '0;
                m3_WREADY = m_WREADY;
            end
            default: begin
                m0_WREADY = '0;
                m1_WREADY = '0;
                m2_WREADY = '0;
                m3_WREADY = '0;
            end
        endcase
    end    

    //---------------------------------------------------------
    //BVALID信号复用
    always_comb begin
        case({m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt})
            4'b1000: begin 
                m0_BVALID = m_BVALID;
                m1_BVALID = '0;
                m2_BVALID = '0;
                m3_BVALID = '0;
            end
            4'b0100: begin
                m0_BVALID = '0;
                m1_BVALID = m_BVALID;
                m2_BVALID = '0;
                m3_BVALID = '0;
            end
            4'b0010: begin
                m0_BVALID = '0;
                m1_BVALID = '0;
                m2_BVALID = m_BVALID;
                m3_BVALID = '0;
            end
            4'b0001: begin
                m0_BVALID = '0;
                m1_BVALID = '0;
                m2_BVALID = '0;
                m3_BVALID = m_BVALID;
            end
            default: begin
                m0_BVALID = '0;
                m1_BVALID = '0;
                m2_BVALID = '0;
                m3_BVALID = '0;
            end
        endcase
    end    


    //=========================================================
    //读取通路的多路复用主控信号

    //---------------------------------------------------------
    //其他信号复用
    always_comb begin
        case({m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt})
            4'b1000: begin
                s_ARID      =   m0_ARID;
                s_ARADDR    =   m0_ARADDR;
                s_ARLEN     =   m0_ARLEN;
                s_ARSIZE    =   m0_ARSIZE;
                s_ARBURST   =   m0_ARBURST;
                s_ARLOCK    =   m0_ARLOCK;
                s_ARCACHE   =   m0_ARCACHE;
                s_ARPROT    =   m0_ARPROT;
                s_ARQOS     =   m0_ARQOS;
                s_ARREGION  =   m0_ARREGION;
                s_ARUSER    =   m0_ARUSER;
                s_ARVALID   =   m0_ARVALID;
                s_RREADY    =   m0_RREADY;
            end
            4'b0100: begin
                s_ARID      =   m1_ARID;
                s_ARADDR    =   m1_ARADDR;
                s_ARLEN     =   m1_ARLEN;
                s_ARSIZE    =   m1_ARSIZE;
                s_ARBURST   =   m1_ARBURST;
                s_ARLOCK    =   m1_ARLOCK;
                s_ARCACHE   =   m1_ARCACHE;
                s_ARPROT    =   m1_ARPROT;
                s_ARQOS     =   m1_ARQOS;
                s_ARREGION  =   m1_ARREGION;
                s_ARUSER    =   m1_ARUSER;
                s_ARVALID   =   m1_ARVALID;
                s_RREADY    =   m1_RREADY;
            end
            4'b0010: begin
                s_ARID      =   m2_ARID;
                s_ARADDR    =   m2_ARADDR;
                s_ARLEN     =   m2_ARLEN;
                s_ARSIZE    =   m2_ARSIZE;
                s_ARBURST   =   m2_ARBURST;
                s_ARLOCK    =   m2_ARLOCK;
                s_ARCACHE   =   m2_ARCACHE;
                s_ARPROT    =   m2_ARPROT;
                s_ARQOS     =   m2_ARQOS;
                s_ARREGION  =   m2_ARREGION;
                s_ARUSER    =   m2_ARUSER;
                s_ARVALID   =   m2_ARVALID;
                s_RREADY    =   m2_RREADY;
            end
            4'b0001: begin
                s_ARID      =   m3_ARID;
                s_ARADDR    =   m3_ARADDR;
                s_ARLEN     =   m3_ARLEN;
                s_ARSIZE    =   m3_ARSIZE;
                s_ARBURST   =   m3_ARBURST;
                s_ARLOCK    =   m3_ARLOCK;
                s_ARCACHE   =   m3_ARCACHE;
                s_ARPROT    =   m3_ARPROT;
                s_ARQOS     =   m3_ARQOS;
                s_ARREGION  =   m3_ARREGION;
                s_ARUSER    =   m3_ARUSER;
                s_ARVALID   =   m3_ARVALID;
                s_RREADY    =   m3_RREADY;
            end
            default: begin
                s_ARID      =   '0;
                s_ARADDR    =   '0;
                s_ARLEN     =   '0;
                s_ARSIZE    =   '0;
                s_ARBURST   =   '0;
                s_ARLOCK    =   '0;
                s_ARCACHE   =   '0;
                s_ARPROT    =   '0;
                s_ARQOS     =   '0;
                s_ARREGION  =   '0;
                s_ARUSER    =   '0;
                s_ARVALID   =   '0;
                s_RREADY    =   '0;
            end

        endcase
    end

    //---------------------------------------------------------
    //ARREADY信号复用
    always_comb begin
        case({m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt})
            4'b1000: begin
                m0_ARREADY  = m_ARREADY;
                m1_ARREADY  = '0;
                m2_ARREADY  = '0;
                m3_ARREADY  = '0;
            end
            4'b0100: begin
                m0_ARREADY  = '0;
                m1_ARREADY  = m_ARREADY;
                m2_ARREADY  = '0;
                m3_ARREADY  = '0;
            end
            4'b0010: begin
                m0_ARREADY  = '0;
                m1_ARREADY  = '0;
                m2_ARREADY  = m_ARREADY;
                m3_ARREADY  = '0;
            end
            4'b0001: begin
                m0_ARREADY  = '0;
                m1_ARREADY  = '0;
                m2_ARREADY  = '0;
                m3_ARREADY  = m_ARREADY;
            end
            default: begin
                m0_ARREADY  = '0;
                m1_ARREADY  = '0;
                m2_ARREADY  = '0;
                m3_ARREADY  = '0;
            end
        endcase
    end

    //---------------------------------------------------------
    //RVALID信号复用
    always_comb begin
        case({m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt})
            4'b1000: begin
                m0_RVALID  = m_RVALID;
                m1_RVALID  = '0;
                m2_RVALID  = '0;
                m3_RVALID  = '0;
            end
            4'b0100: begin
                m0_RVALID  = '0;
                m1_RVALID  = m_RVALID;
                m2_RVALID  = '0;
                m3_RVALID  = '0;
            end
            4'b0010: begin
                m0_RVALID  = '0;
                m1_RVALID  = '0;
                m2_RVALID  = m_RVALID;
                m3_RVALID  = '0;
            end
            4'b0001: begin
                m0_RVALID  = '0;
                m1_RVALID  = '0;
                m2_RVALID  = '0;
                m3_RVALID  = m_RVALID;
            end
            default: begin
                m0_RVALID  = '0;
                m1_RVALID  = '0;
                m2_RVALID  = '0;
                m3_RVALID  = '0;
            end
        endcase
    end

endmodule