//=============================================================================
//
//Module Name:					AXI_Master_Mux_R.sv
//Department:					Xidian University
//Function Description:	        AXI总线读通道主控用多路复用器
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

module AXI_Master_Mux_R#(
    parameter   DATA_WIDTH  = 1024,
                ADDR_WIDTH  = 64,
                ID_WIDTH    = 8,
                USER_WIDTH  = 8
)(
	/********* 时钟&复位 *********/
	input                       ACLK,
	input      	                ARESETn,
    /********** 0号主控 **********/
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
    output reg                  m0_ARREADY,
    //读数据通道
    output reg                  m0_RVALID,
    input                       m0_RREADY,
    /********** 1号主控 **********/
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
    output reg                  m1_ARREADY,
    //读数据通道
    output reg                  m1_RVALID,
    input                       m1_RREADY,
    /********** 2号主控 **********/
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
    output reg                  m2_ARREADY,
    //读数据通道
    output reg                  m2_RVALID,
    input                       m2_RREADY,
    /********** 3号主控 **********/
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
    output reg                  m3_ARREADY,
    //读数据通道
    output reg                  m3_RVALID,
    input                       m3_RREADY,
    /******** 从机通用信号 ********/
    //读地址通道
    output reg [ID_WIDTH-1:0]   s_ARID,
    output reg [ADDR_WIDTH-1:0] s_ARADDR,
    output reg [7:0]            s_ARLEN,
    output reg [2:0]            s_ARSIZE,
    output reg [1:0]            s_ARBURST,
    output reg                  s_ARLOCK,
    output reg [3:0]            s_ARCACHE,
    output reg [2:0]            s_ARPROT,
    output reg [3:0]            s_ARQOS,
    output reg [3:0]            s_ARREGION,
    output reg [USER_WIDTH-1:0] s_ARUSER,
    output reg                  s_ARVALID,
    //读数据通道
    output reg                  s_RREADY,
    /******** 主机通用信号 ********/
    input                       m_ARREADY,
    input                       m_RVALID,
    /******** 片选使能信号 ********/
    input                       m0_rgrnt,
	input                       m1_rgrnt,
    input                       m2_rgrnt,
    input                       m3_rgrnt
);

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