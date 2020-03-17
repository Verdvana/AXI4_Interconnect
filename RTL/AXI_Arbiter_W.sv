//=============================================================================
//
//Module Name:					AXI_Arbiter_W.sv
//Department:					Xidian University
//Function Description:	        AXI总线仲裁器写通道仲裁
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

module AXI_Arbiter_W#(
    parameter   DATA_WIDTH  = 1024,
                ADDR_WIDTH  = 64,
                ID_WIDTH    = 32,
                USER_WIDTH  = 1024,
                STRB_WIDTH  = (DATA_WIDTH/8)
)(
	/**********时钟&复位**********/
	input           ACLK,
	input      	    ARESETn,
	/********** 0号主控 **********/
	input      [ID_WIDTH-1:0]   m0_AWID,
    input	   [ADDR_WIDTH-1:0] m0_AWADDR,/*
    input      [7:0]            m0_AWLEN,
    input      [7:0]            m0_AWSIZE,
    input      [2:0]            m0_AWBURST,
    input                       m0_AWLOCK,
    input      [3:0]            m0_AWCACHE,
    input      [2:0]            m0_AWPROT,
    input      [3:0]            m0_AWQOS,
    input      [3:0]            m0_AWREGION,
    input      [USER_WIDTH-1:0] m0_AWUSER,*/
    input                       m0_AWVALID,
    output reg                  m0_AWREADY,
    input      [ID_WIDTH-1:0]   m0_WID,
    input      [DATA_WIDTH-1:0] m0_WDATA,
    input      [STRB_WIDTH-1:0] m0_WSTRB,
    input                       m0_WLAST,
    input      [USER_WIDTH-1:0] m0_WUSER,
    input                       m0_WVALID,
    output reg                  m0_WREADY,
    output reg                  m0_BVALID,
    input                       m0_BREADY,
	/********** 1号主控 **********/
    input      [ID_WIDTH-1:0]   m1_AWID,
    input	   [ADDR_WIDTH-1:0]	m1_AWADDR,/*
    input      [7:0]            m1_AWLEN,
    input      [7:0]            m1_AWSIZE,
    input      [2:0]            m1_AWBURST,
    input                       m1_AWLOCK,
    input      [3:0]            m1_AWCACHE,
    input      [2:0]            m1_AWPROT,
    input      [3:0]            m1_AWQOS,
    input      [3:0]            m1_AWREGION,
    input      [USER_WIDTH-1:0] m1_AWUSER,*/
    input                       m1_AWVALID,
    output reg                  m1_AWREADY,
    //写数据通道
    input      [ID_WIDTH-1:0]   m1_WID,
    input      [DATA_WIDTH-1:0] m1_WDATA,
    input      [STRB_WIDTH-1:0] m1_WSTRB,
    input                       m1_WLAST,
    input      [USER_WIDTH-1:0] m1_WUSER,
    input                       m1_WVALID,
    output reg                  m1_WREADY,
    //写响应通道
    output reg                  m1_BVALID,
    input                       m1_BREADY,
	/********** 2号主控 **********/
    input      [ID_WIDTH-1:0]   m2_AWID,
    input	   [ADDR_WIDTH-1:0]	m2_AWADDR,/*
    input      [7:0]            m2_AWLEN,
    input      [7:0]            m2_AWSIZE,
    input      [2:0]            m2_AWBURST,
    input                       m2_AWLOCK,
    input      [3:0]            m2_AWCACHE,
    input      [2:0]            m2_AWPROT,
    input      [3:0]            m2_AWQOS,
    input      [3:0]            m2_AWREGION,
    input      [USER_WIDTH-1:0] m2_AWUSER,*/
    input                       m2_AWVALID,
    output reg                  m2_AWREADY,
    //写数据通道
    input      [ID_WIDTH-1:0]   m2_WID,
    input      [DATA_WIDTH-1:0] m2_WDATA,
    input      [STRB_WIDTH-1:0] m2_WSTRB,
    input                       m2_WLAST,
    input      [USER_WIDTH-1:0] m2_WUSER,
    input                       m2_WVALID,
    output reg                  m2_WREADY,
    //写响应通道
    output reg                  m2_BVALID,
    input                       m2_BREADY,
	/********** 3号主控 **********/
	input      [ID_WIDTH-1:0]   m3_AWID,
    input	   [ADDR_WIDTH-1:0]	m3_AWADDR,/*
    input      [7:0]            m3_AWLEN,
    input      [7:0]            m3_AWSIZE,
    input      [2:0]            m3_AWBURST,
    input                       m3_AWLOCK,
    input      [3:0]            m3_AWCACHE,
    input      [2:0]            m3_AWPROT,
    input      [3:0]            m3_AWQOS,
    input      [3:0]            m3_AWREGION,
    input      [USER_WIDTH-1:0] m3_AWUSER,*/
    input                       m3_AWVALID,
    output reg                  m3_AWREADY,
    //写数据通道
    input      [ID_WIDTH-1:0]   m3_WID,
    input      [DATA_WIDTH-1:0] m3_WDATA,
    input      [STRB_WIDTH-1:0] m3_WSTRB,
    input                       m3_WLAST,
    input      [USER_WIDTH-1:0] m3_WUSER,
    input                       m3_WVALID,
    output reg                  m3_WREADY,
    //写响应通道
    output reg                  m3_BVALID,
    input                       m3_BREADY,
    /******* 主控通用信号 ********/
    output reg [ID_WIDTH-1:0]	m_BID,
	output reg [1:0]	        m_BRESP,
	output reg [USER_WIDTH-1:0] m_BUSER,
    /********** 0号从机 **********/
    output reg                  s0_AWVALID,
    input                       s0_AWREADY,
    output reg                  s0_WVALID,
    input                       s0_WREADY,
	input	   [ID_WIDTH-1:0]	s0_BID,
	input	   [1:0]	        s0_BRESP,
	input	   [USER_WIDTH-1:0] s0_BUSER,
	input	     		        s0_BVALID,
    output reg                  s0_BREADY,
    /********** 1号从机 **********/
    output reg                  s1_AWVALID,
    input                       s1_AWREADY,
    output reg                  s1_WVALID,
    input                       s1_WREADY,
	input	   [ID_WIDTH-1:0]	s1_BID,
	input	   [1:0]	        s1_BRESP,
	input	   [USER_WIDTH-1:0] s1_BUSER,
	input	     		        s1_BVALID,
    output reg                  s1_BREADY,
    /********** 2号从机 **********/
    output reg                  s2_AWVALID,
    input                       s2_AWREADY,
    output reg                  s2_WVALID,
    input                       s2_WREADY,
	input	   [ID_WIDTH-1:0]	s2_BID,
	input	   [1:0]	        s2_BRESP,
	input	   [USER_WIDTH-1:0] s2_BUSER,
	input	     		        s2_BVALID,
    output reg                  s2_BREADY,
    /********** 3号从机 **********/
    output reg                  s3_AWVALID,
    input                       s3_AWREADY,
    output reg                  s3_WVALID,
    input                       s3_WREADY,
	input	   [ID_WIDTH-1:0]	s3_BID,
	input	   [1:0]	        s3_BRESP,
	input	   [USER_WIDTH-1:0] s3_BUSER,
	input	     		        s3_BVALID,
    output reg                  s3_BREADY,
    /********** 4号从机 **********/
    output reg                  s4_AWVALID,
    input                       s4_AWREADY,
    output reg                  s4_WVALID,
    input                       s4_WREADY,
	input	   [ID_WIDTH-1:0]	s4_BID,
	input	   [1:0]	        s4_BRESP,
	input	   [USER_WIDTH-1:0] s4_BUSER,
	input	     		        s4_BVALID,
    output reg                  s4_BREADY,
    /********** 5号从机 **********/
    output reg                  s5_AWVALID,
    input                       s5_AWREADY,
    output reg                  s5_WVALID,
    input                       s5_WREADY,
	input	   [ID_WIDTH-1:0]	s5_BID,
	input	   [1:0]	        s5_BRESP,
	input	   [USER_WIDTH-1:0] s5_BUSER,
	input	     		        s5_BVALID,
    output reg                  s5_BREADY,
    /********** 6号从机 **********/
    output reg                  s6_AWVALID,
    input                       s6_AWREADY,
    output reg                  s6_WVALID,
    input                       s6_WREADY,
	input	   [ID_WIDTH-1:0]	s6_BID,
	input	   [1:0]	        s6_BRESP,
	input	   [USER_WIDTH-1:0] s6_BUSER,
	input	     		        s6_BVALID,
    output reg                  s6_BREADY,
    /********** 7号从机 **********/
    output reg                  s7_AWVALID,
    input                       s7_AWREADY,
    output reg                  s7_WVALID,
    input                       s7_WREADY,
	input	   [ID_WIDTH-1:0]	s7_BID,
	input	   [1:0]	        s7_BRESP,
	input	   [USER_WIDTH-1:0] s7_BUSER,
	input	     		        s7_BVALID,
    output reg                  s7_BREADY,
    /******** 从机通用信号 ********/
    //写地址通道
    output reg [ID_WIDTH-1:0]   s_AWID,
    output reg [ADDR_WIDTH-1:0]	s_AWADDR,
    output reg [7:0]            s_AWLEN,
    output reg [7:0]            s_AWSIZE,
    output reg [2:0]            s_AWBURST,
    output reg                  s_AWLOCK,
    output reg [3:0]            s_AWCACHE,
    output reg [2:0]            s_AWPROT,
    output reg [3:0]            s_AWQOS,
    output reg [3:0]            s_AWREGION,
    output reg [USER_WIDTH-1:0] s_AWUSER,
    //写数据通道
    output reg [ID_WIDTH-1:0]   s_WID,
    output reg [DATA_WIDTH:0]   s_WDATA,
    output reg [STRB_WIDTH-1:0] s_WSTRB,
    output reg                  s_WLAST,
    output reg [USER_WIDTH-1:0] s_WUSER	
);

    //=========================================================
    //常量定义
    parameter   TCO     =   1;  //寄存器延时

    //=========================================================
    //中间信号
    logic       m_AWREADY;
    logic       m_WREADY;
    logic       m_BVALID;
    logic       s_AWVALID;
    logic       s_WVALID;
    logic       s_BREADY;


    //=========================================================
    //写地址寄存

    logic [2:0] awaddr [4];
    logic [2:0] m_AWADDR;

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)begin
            for(int i=0;i<4;i++)
                awaddr[i] <= #TCO '0;
        end
        else if(m0_AWVALID||m1_AWVALID||m2_AWVALID||m3_AWVALID)begin
            awaddr[0] <= #TCO m0_AWADDR[ADDR_WIDTH-1-:3];
            awaddr[1] <= #TCO m1_AWADDR[ADDR_WIDTH-1-:3];
            awaddr[2] <= #TCO m2_AWADDR[ADDR_WIDTH-1-:3];
            awaddr[3] <= #TCO m3_AWADDR[ADDR_WIDTH-1-:3];
        end
    end


    //=========================================================
    //写地址通道仲裁状态机

    //---------------------------------------------------------
    //枚举所有状态（logic四状态）
    enum logic [3:0] {
        AXI_AW_MASTER_0,    //0号主机写地址通道握手状态
        AXI_W_MASTER_0,     //0号主机写数据通道握手状态
        AXI_B_MASTER_0,     //0号主机写响应通道握手状态

        AXI_AW_MASTER_1,    //1号主机写地址通道握手状态
        AXI_W_MASTER_1,     //1号主机写数据通道握手状态
        AXI_B_MASTER_1,     //1号主机写响应通道握手状态

        AXI_AW_MASTER_2,    //2号主机写地址通道握手状态
        AXI_W_MASTER_2,     //2号主机写数据通道握手状态
        AXI_B_MASTER_2,     //2号主机写响应通道握手状态

        AXI_AW_MASTER_3,    //3号主机写地址通道握手状态
        AXI_W_MASTER_3,     //3号主机写数据通道握手状态
        AXI_B_MASTER_3      //3号主机写响应通道握手状态
    } state,next_state;

    //---------------------------------------------------------
    //状态译码
    always_comb begin
        case (state)
            AXI_AW_MASTER_0: begin                      //0号主机写地址通道握手状态，此状态下仲裁优先级为：0>1>2>3
                if(m0_AWVALID)begin                     //0号主机申请仲裁
                    if(m_AWREADY)                       //有握手回应
                        next_state = AXI_W_MASTER_0;    //进入0号主机写数据通道握手状态
                    else
                        next_state = AXI_AW_MASTER_0;   //否则状态不变
                end
                else if(m1_AWVALID)                     //1号主机申请仲裁
                    next_state = AXI_AW_MASTER_1;       //进入1号主机写地址通道握手状态
                else if(m2_AWVALID)                     //2号主机申请仲裁
                    next_state = AXI_AW_MASTER_2;       //进入2号主机写地址通道握手状态
                else if(m3_AWVALID)                     //3号主机申请仲裁
                    next_state = AXI_AW_MASTER_3;       //进入3号主机写地址通道握手状态
                else                                    //都未申请仲裁
                    next_state = AXI_AW_MASTER_0;       //保持在0号主机写地址通道握手状态
            end
            AXI_AW_MASTER_1: begin                      //1号主机写地址通道握手状态，此状态下仲裁优先级为：1>2>3>0
                if(m1_AWVALID)begin                     //与上一部分类似
                    if(m_AWREADY)
                        next_state = AXI_W_MASTER_1;
                    else
                        next_state = AXI_AW_MASTER_1;
                end
                else if(m2_AWVALID)
                    next_state = AXI_AW_MASTER_2;
                else if(m3_AWVALID)
                    next_state = AXI_AW_MASTER_3;
                else if(m0_AWVALID)
                    next_state = AXI_AW_MASTER_0;
                else
                    next_state = AXI_AW_MASTER_1;
            end
            AXI_AW_MASTER_2: begin                      //2号主机写地址通道握手状态，此状态下仲裁优先级为：2>3>0>1
                if(m2_AWVALID)begin                     //与上一部分类似
                    if(m_AWREADY)
                        next_state = AXI_W_MASTER_2;
                    else
                        next_state = AXI_AW_MASTER_2;
                end
                else if(m3_AWVALID)
                    next_state = AXI_AW_MASTER_3;
                else if(m0_AWVALID)
                    next_state = AXI_AW_MASTER_0;
                else if(m1_AWVALID)
                    next_state = AXI_AW_MASTER_1;
                else
                    next_state = AXI_AW_MASTER_2;
            end
            AXI_AW_MASTER_3: begin                      //3号主机写地址通道握手状态，此状态下仲裁优先级为：3>0>1>2
                if(m3_AWVALID)begin                     //与上一部分类似
                    if(m_AWREADY)
                        next_state = AXI_W_MASTER_3;
                    else
                        next_state = AXI_AW_MASTER_3;
                end
                else if(m0_AWVALID)
                    next_state = AXI_AW_MASTER_0;
                else if(m1_AWVALID)
                    next_state = AXI_AW_MASTER_1;
                else if(m2_AWVALID)
                    next_state = AXI_AW_MASTER_2;
                else
                    next_state = AXI_AW_MASTER_3;
            end

            AXI_W_MASTER_0: begin                       //0号主机写数据通道握手状态
                if(m0_WLAST)begin                       //如果发送到最后一个数
                    if(m0_WVALID && m_WREADY)           //此时握手成功
                        next_state = AXI_B_MASTER_0;    //进入0号主机写回应通道握手状态
                    else                                
                        next_state = AXI_AW_MASTER_0;   //否则回到0号主机写地址通道握手状态
                end
                else begin                              //如果还在发送数据中
                    if(~m0_WVALID && ~m_WREADY)         //握手断开
                        next_state = AXI_AW_MASTER_0;   //回到0号主机写地址通道握手状态
                    else
                        next_state = AXI_W_MASTER_0;    //保持0号主机写数据通道握手状态
                end
            end
            AXI_W_MASTER_1: begin                       //1号主机写数据通道握手状态
                if(m1_WLAST)begin                       //与上一部分类似
                    if(m1_WVALID && m_WREADY)
                        next_state = AXI_B_MASTER_1;
                    else
                        next_state = AXI_AW_MASTER_1;
                end
                else begin
                    if(~m1_WVALID && ~m_WREADY)
                        next_state = AXI_AW_MASTER_1;
                    else
                        next_state = AXI_W_MASTER_1;
                end
            end
            AXI_W_MASTER_2: begin                       //2号主机写数据通道握手状态
                if(m2_WLAST)begin                       //与上一部分类似
                    if(m2_WVALID && m_WREADY)
                        next_state = AXI_B_MASTER_2;
                    else
                        next_state = AXI_AW_MASTER_2;
                end
                else begin
                    if(~m2_WVALID && ~m_WREADY)
                        next_state = AXI_AW_MASTER_2;
                    else
                        next_state = AXI_W_MASTER_2;
                end
            end
            AXI_W_MASTER_3: begin                       //2号主机写数据通道握手状态
                if(m3_WLAST)begin                       //与上一部分类似
                    if(m3_WVALID && m_WREADY)
                        next_state = AXI_B_MASTER_3;
                    else
                        next_state = AXI_AW_MASTER_3;
                end
                else begin
                    if(~m3_WVALID && ~m_WREADY)
                        next_state = AXI_AW_MASTER_3;
                    else
                        next_state = AXI_W_MASTER_3;
                end
            end

            AXI_B_MASTER_0: begin                       //0号主机写响应通道握手状态
                if(m_BVALID)                            //如果有写响应握手信号
                    if(m0_BREADY)                       //如果0号主机有回应
                        next_state = AXI_AW_MASTER_1;   //则0号主机一次写任务完成，下次优先仲裁1号主机
                    else                                //如果0号主机有回应
                        next_state = AXI_B_MASTER_0;    //保持0号主机写响应通道握手状态
                else                                    //如果没有写响应握手信号
                    next_state = AXI_AW_MASTER_0;       //回到0号主机写地址通道握手状态
            end
            AXI_B_MASTER_1: begin                       //1号主机写响应通道握手状态   
                if(m_BVALID)                            //与上一部分类似
                    if(m1_BREADY)
                        next_state = AXI_AW_MASTER_2;
                    else
                        next_state = AXI_B_MASTER_1;
                else
                    next_state = AXI_AW_MASTER_1;
            end
            AXI_B_MASTER_2: begin                       //2号主机写响应通道握手状态
                if(m_BVALID)                            //与上一部分类似
                    if(m2_BREADY)
                        next_state = AXI_AW_MASTER_3;
                    else
                        next_state = AXI_B_MASTER_2;
                else
                    next_state = AXI_AW_MASTER_2;
            end
            AXI_B_MASTER_3: begin                       //3号主机写响应通道握手状态
                if(m_BVALID)                            //与上一部分类似
                    if(m3_BREADY)
                        next_state = AXI_AW_MASTER_0;
                    else
                        next_state = AXI_B_MASTER_3;
                else
                    next_state = AXI_AW_MASTER_3;
            end

            default:                                    //默认状态为0号主机写地址通道握手状态
                next_state = AXI_AW_MASTER_0;
        endcase
    end


    //---------------------------------------------------------
    //更新状态寄存器
    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            state <= #TCO AXI_AW_MASTER_0;              //默认状态为0号主机写地址通道握手状态
        else
            state <= #TCO next_state;
    end

    //---------------------------------------------------------
    //利用状态寄存器输出控制结果
    always_comb begin
        case (state)
            AXI_AW_MASTER_0,                            //仲裁结果为0号主机
            AXI_W_MASTER_0,
            AXI_B_MASTER_0: begin
                s_AWID      = m0_AWID;
                s_AWADDR    = m0_AWADDR;/*
                s_AWLEN     = m0_AWLEN;
                s_AWSIZE    = m0_AWSIZE;
                s_AWBURST   = m0_AWBURST;
                s_AWLOCK    = m0_AWLOCK;
                s_AWCACHE   = m0_AWCACHE;
                s_AWPROT    = m0_AWPROT;
                s_AWQOS     = m0_AWQOS;
                s_AWREGION  = m0_AWREGION;
                s_AWUSER    = m0_AWUSER;*/
                s_AWVALID   = m0_AWVALID;
                s_WID       = m0_WID;
                s_WDATA     = m0_WDATA;
                s_WSTRB     = m0_WSTRB;
                s_WLAST     = m0_WLAST;
                s_WUSER     = m0_WUSER;
                s_WVALID    = m0_WVALID;
                s_BREADY    = m0_BREADY;
                m_AWADDR    = awaddr[0];
                m0_AWREADY  = m_AWREADY;
                m1_AWREADY  = '0;
                m2_AWREADY  = '0;
                m3_AWREADY  = '0;
                m0_WREADY   = m_WREADY;
                m1_WREADY   = '0;
                m2_WREADY   = '0;
                m3_WREADY   = '0;
                m0_BVALID   = m_BVALID;
                m1_BVALID   = '0;
                m2_BVALID   = '0;
                m3_BVALID   = '0;
            end
            AXI_AW_MASTER_1,                            //仲裁结果为1号主机
            AXI_W_MASTER_1,
            AXI_B_MASTER_1: begin
                s_AWID      = m1_AWID;
                s_AWADDR    = m1_AWADDR;/*
                s_AWLEN     = m1_AWLEN;
                s_AWSIZE    = m1_AWSIZE;
                s_AWBURST   = m1_AWBURST;
                s_AWLOCK    = m1_AWLOCK;
                s_AWCACHE   = m1_AWCACHE;
                s_AWPROT    = m1_AWPROT;
                s_AWQOS     = m1_AWQOS;
                s_AWREGION  = m1_AWREGION;
                s_AWUSER    = m1_AWUSER;*/
                s_AWVALID   = m1_AWVALID;
                s_WID       = m1_WID;
                s_WDATA     = m1_WDATA;
                s_WSTRB     = m1_WSTRB;
                s_WLAST     = m1_WLAST;
                s_WUSER     = m1_WUSER;
                s_WVALID    = m1_WVALID;
                s_BREADY    = m1_BREADY; 
                m_AWADDR    = awaddr[1]; 
                m0_AWREADY  = '0;
                m1_AWREADY  = m_AWREADY;
                m2_AWREADY  = '0;
                m3_AWREADY  = '0;
                m0_WREADY   = '0;
                m1_WREADY   = m_WREADY;
                m2_WREADY   = '0;
                m3_WREADY   = '0;
                m0_BVALID   = '0;
                m1_BVALID   = m_BVALID;
                m2_BVALID   = '0;
                m3_BVALID   = '0;
            end
            AXI_AW_MASTER_2,                            //仲裁结果为2号主机
            AXI_W_MASTER_2,
            AXI_B_MASTER_2: begin
                s_AWID      = m2_AWID;
                s_AWADDR    = m2_AWADDR;/*
                s_AWLEN     = m2_AWLEN;
                s_AWSIZE    = m2_AWSIZE;
                s_AWBURST   = m2_AWBURST;
                s_AWLOCK    = m2_AWLOCK;
                s_AWCACHE   = m2_AWCACHE;
                s_AWPROT    = m2_AWPROT;
                s_AWQOS     = m2_AWQOS;
                s_AWREGION  = m2_AWREGION;
                s_AWUSER    = m2_AWUSER;*/
                s_AWVALID   = m2_AWVALID;
                s_WID       = m2_WID;
                s_WDATA     = m2_WDATA;
                s_WSTRB     = m2_WSTRB;
                s_WLAST     = m2_WLAST;
                s_WUSER     = m2_WUSER;
                s_WVALID    = m2_WVALID;
                s_BREADY    = m2_BREADY;
                m_AWADDR    = awaddr[2]; 
                m0_AWREADY  = '0;
                m1_AWREADY  = '0;
                m2_AWREADY  = m_AWREADY;
                m3_AWREADY  = '0;
                m0_WREADY   = '0;
                m1_WREADY   = '0;
                m2_WREADY   = m_WREADY;
                m3_WREADY   = '0;
                m0_BVALID   = '0;
                m1_BVALID   = '0;
                m2_BVALID   = m_BVALID;
                m3_BVALID   = '0;
            end
            AXI_AW_MASTER_3,                            //仲裁结果为3号主机
            AXI_W_MASTER_3,
            AXI_B_MASTER_3: begin
                s_AWID      = m3_AWID;
                s_AWADDR    = m3_AWADDR;/*
                s_AWLEN     = m3_AWLEN;
                s_AWSIZE    = m3_AWSIZE;
                s_AWBURST   = m3_AWBURST;
                s_AWLOCK    = m3_AWLOCK;
                s_AWCACHE   = m3_AWCACHE;
                s_AWPROT    = m3_AWPROT;
                s_AWQOS     = m3_AWQOS;
                s_AWREGION  = m3_AWREGION;
                s_AWUSER    = m3_AWUSER;*/
                s_AWVALID   = m3_AWVALID;
                s_WID       = m3_WID;
                s_WDATA     = m3_WDATA;
                s_WSTRB     = m3_WSTRB;
                s_WLAST     = m3_WLAST;
                s_WUSER     = m3_WUSER;
                s_WVALID    = m3_WVALID;
                s_BREADY    = m3_BREADY; 
                m_AWADDR    = awaddr[3]; 
                m0_AWREADY  = '0;
                m1_AWREADY  = '0;
                m2_AWREADY  = '0;
                m3_AWREADY  = m_AWREADY;
                m0_WREADY   = '0;
                m1_WREADY   = '0;
                m2_WREADY   = '0;
                m3_WREADY   = m_WREADY;
                m0_BVALID   = '0;
                m1_BVALID   = '0;
                m2_BVALID   = '0;
                m3_BVALID   = m_BVALID;
            end
            default:        begin
                s_AWID      = '0;
                s_AWADDR    = '0;/*
                s_AWLEN     = '0;
                s_AWSIZE    = '0;
                s_AWBURST   = '0;
                s_AWLOCK    = '0;
                s_AWCACHE   = '0;
                s_AWPROT    = '0;
                s_AWQOS     = '0;
                s_AWREGION  = '0;
                s_AWUSER    = '0;*/
                s_AWVALID   = '0;
                s_WID       = '0;
                s_WDATA     = '0;
                s_WSTRB     = '0;
                s_WLAST     = '0;
                s_WUSER     = '0;
                s_WVALID    = '0;
                s_BREADY    = '0; 
                m_AWADDR    = '0;  
                m0_AWREADY  = '0;
                m1_AWREADY  = '0;
                m2_AWREADY  = '0;
                m3_AWREADY  = '0;
                m0_WREADY   = '0;
                m1_WREADY   = '0;
                m2_WREADY   = '0;
                m3_WREADY   = '0;
                m0_BVALID   = '0;
                m1_BVALID   = '0;
                m2_BVALID   = '0;
                m3_BVALID   = '0;
            end
        endcase
    end

    //---------------------------------------------------------
    //根据写地址输出握手信号
    always_comb begin
        case(m_AWADDR)
            3'b000:begin
                s0_AWVALID  = s_AWVALID;
                s0_WVALID   = s_WVALID;
                s0_BREADY   = s_BREADY;
                s1_AWVALID  = '0;
                s1_WVALID   = '0;
                s1_BREADY   = '0;
                s2_AWVALID  = '0;
                s2_WVALID   = '0;
                s2_BREADY   = '0;
                s3_AWVALID  = '0;
                s3_WVALID   = '0;
                s3_BREADY   = '0;
                s4_AWVALID  = '0;
                s4_WVALID   = '0;
                s4_BREADY   = '0;
                s5_AWVALID  = '0;
                s5_WVALID   = '0;
                s5_BREADY   = '0;
                s6_AWVALID  = '0;
                s6_WVALID   = '0;
                s6_BREADY   = '0;
                s7_AWVALID  = '0;
                s7_WVALID   = '0;
                s7_BREADY   = '0;
                m_AWREADY   = s0_AWREADY;
                m_WREADY    = s0_WREADY;
                m_BVALID    = s0_BVALID;
                m_BID       = s0_BID;
                m_BRESP     = s0_BRESP;
                m_BUSER     = s0_BUSER;
            end
            3'b001:begin
                s0_AWVALID  = '0;
                s0_WVALID   = '0;
                s0_BREADY   = '0;
                s1_AWVALID  = s_AWVALID;
                s1_WVALID   = s_WVALID;
                s1_BREADY   = s_BREADY;
                s2_AWVALID  = '0;
                s2_WVALID   = '0;
                s2_BREADY   = '0;
                s3_AWVALID  = '0;
                s3_WVALID   = '0;
                s3_BREADY   = '0;
                s4_AWVALID  = '0;
                s4_WVALID   = '0;
                s4_BREADY   = '0;
                s5_AWVALID  = '0;
                s5_WVALID   = '0;
                s5_BREADY   = '0;
                s6_AWVALID  = '0;
                s6_WVALID   = '0;
                s6_BREADY   = '0;
                s7_AWVALID  = '0;
                s7_WVALID   = '0;
                s7_BREADY   = '0;
                m_AWREADY   = s1_AWREADY;
                m_WREADY    = s1_WREADY;
                m_BVALID    = s1_BVALID;
                m_BID       = s1_BID;
                m_BRESP     = s1_BRESP;
                m_BUSER     = s1_BUSER;
            end
            3'b010:begin
                s0_AWVALID  = '0;
                s0_WVALID   = '0;
                s0_BREADY   = '0;
                s1_AWVALID  = '0;
                s1_WVALID   = '0;
                s1_BREADY   = '0;
                s2_AWVALID  = s_AWVALID;
                s2_WVALID   = s_WVALID;
                s2_BREADY   = s_BREADY;
                s3_AWVALID  = '0;
                s3_WVALID   = '0;
                s3_BREADY   = '0;
                s4_AWVALID  = '0;
                s4_WVALID   = '0;
                s4_BREADY   = '0;
                s5_AWVALID  = '0;
                s5_WVALID   = '0;
                s5_BREADY   = '0;
                s6_AWVALID  = '0;
                s6_WVALID   = '0;
                s6_BREADY   = '0;
                s7_AWVALID  = '0;
                s7_WVALID   = '0;
                s7_BREADY   = '0;
                m_AWREADY   = s2_AWREADY;
                m_WREADY    = s2_WREADY;
                m_BVALID    = s2_BVALID;
                m_BID       = s2_BID;
                m_BRESP     = s2_BRESP;
                m_BUSER     = s2_BUSER;
            end
            3'b011:begin
                s0_AWVALID  = '0;
                s0_WVALID   = '0;
                s0_BREADY   = '0;
                s1_AWVALID  = '0;
                s1_WVALID   = '0;
                s1_BREADY   = '0;
                s2_AWVALID  = '0;
                s2_WVALID   = '0;
                s2_BREADY   = '0;
                s3_AWVALID  = s_AWVALID;
                s3_WVALID   = s_WVALID;
                s3_BREADY   = s_BREADY;
                s4_AWVALID  = '0;
                s4_WVALID   = '0;
                s4_BREADY   = '0;
                s5_AWVALID  = '0;
                s5_WVALID   = '0;
                s5_BREADY   = '0;
                s6_AWVALID  = '0;
                s6_WVALID   = '0;
                s6_BREADY   = '0;
                s7_AWVALID  = '0;
                s7_WVALID   = '0;
                s7_BREADY   = '0;
                m_AWREADY   = s3_AWREADY;
                m_WREADY    = s3_WREADY;
                m_BVALID    = s3_BVALID;
                m_BID       = s3_BID;
                m_BRESP     = s3_BRESP;
                m_BUSER     = s3_BUSER;
            end
            3'b100:begin
                s0_AWVALID  = '0;
                s0_WVALID   = '0;
                s0_BREADY   = '0;
                s1_AWVALID  = '0;
                s1_WVALID   = '0;
                s1_BREADY   = '0;
                s2_AWVALID  = '0;
                s2_WVALID   = '0;
                s2_BREADY   = '0;
                s3_AWVALID  = '0;
                s3_WVALID   = '0;
                s3_BREADY   = '0;
                s4_AWVALID  = s_AWVALID;
                s4_WVALID   = s_WVALID;
                s4_BREADY   = s_BREADY;
                s5_AWVALID  = '0;
                s5_WVALID   = '0;
                s5_BREADY   = '0;
                s6_AWVALID  = '0;
                s6_WVALID   = '0;
                s6_BREADY   = '0;
                s7_AWVALID  = '0;
                s7_WVALID   = '0;
                s7_BREADY   = '0;
                m_AWREADY   = s4_AWREADY;
                m_WREADY    = s4_WREADY;
                m_BVALID    = s4_BVALID;
                m_BID       = s4_BID;
                m_BRESP     = s4_BRESP;
                m_BUSER     = s4_BUSER;
            end
            3'b101:begin
                s0_AWVALID  = '0;
                s0_WVALID   = '0;
                s0_BREADY   = '0;
                s1_AWVALID  = '0;
                s1_WVALID   = '0;
                s1_BREADY   = '0;
                s2_AWVALID  = '0;
                s2_WVALID   = '0;
                s2_BREADY   = '0;
                s3_AWVALID  = '0;
                s3_WVALID   = '0;
                s3_BREADY   = '0;
                s4_AWVALID  = '0;
                s4_WVALID   = '0;
                s4_BREADY   = '0;
                s5_AWVALID  = s_AWVALID;
                s5_WVALID   = s_WVALID;
                s5_BREADY   = s_BREADY;
                s6_AWVALID  = '0;
                s6_WVALID   = '0;
                s6_BREADY   = '0;
                s7_AWVALID  = '0;
                s7_WVALID   = '0;
                s7_BREADY   = '0;
                m_AWREADY   = s5_AWREADY;
                m_WREADY    = s5_WREADY;
                m_BVALID    = s5_BVALID;
                m_BID       = s5_BID;
                m_BRESP     = s5_BRESP;
                m_BUSER     = s5_BUSER;
            end
            3'b110:begin
                s0_AWVALID  = '0;
                s0_WVALID   = '0;
                s0_BREADY   = '0;
                s1_AWVALID  = '0;
                s1_WVALID   = '0;
                s1_BREADY   = '0;
                s2_AWVALID  = '0;
                s2_WVALID   = '0;
                s2_BREADY   = '0;
                s3_AWVALID  = '0;
                s3_WVALID   = '0;
                s3_BREADY   = '0;
                s4_AWVALID  = '0;
                s4_WVALID   = '0;
                s4_BREADY   = '0;
                s5_AWVALID  = '0;
                s5_WVALID   = '0;
                s5_BREADY   = '0;
                s6_AWVALID  = s_AWVALID;
                s6_WVALID   = s_WVALID;
                s6_BREADY   = s_BREADY;
                s7_AWVALID  = '0;
                s7_WVALID   = '0;
                s7_BREADY   = '0;
                m_AWREADY   = s6_AWREADY;
                m_WREADY    = s6_WREADY;
                m_BVALID    = s6_BVALID;
                m_BID       = s6_BID;
                m_BRESP     = s6_BRESP;
                m_BUSER     = s6_BUSER;
            end
            3'b111:begin
                s0_AWVALID  = '0;
                s0_WVALID   = '0;
                s0_BREADY   = '0;
                s1_AWVALID  = '0;
                s1_WVALID   = '0;
                s1_BREADY   = '0;
                s2_AWVALID  = '0;
                s2_WVALID   = '0;
                s2_BREADY   = '0;
                s3_AWVALID  = '0;
                s3_WVALID   = '0;
                s3_BREADY   = '0;
                s4_AWVALID  = '0;
                s4_WVALID   = '0;
                s4_BREADY   = '0;
                s5_AWVALID  = '0;
                s5_WVALID   = '0;
                s5_BREADY   = '0;
                s6_AWVALID  = '0;
                s6_WVALID   = '0;
                s6_BREADY   = '0;
                s7_AWVALID  = s_AWVALID;
                s7_WVALID   = s_WVALID;
                s7_BREADY   = s_BREADY;
                m_AWREADY   = s7_AWREADY;
                m_WREADY    = s7_WREADY;
                m_BVALID    = s7_BVALID;
                m_BID       = s7_BID;
                m_BRESP     = s7_BRESP;
                m_BUSER     = s7_BUSER;
                
            end
            default:begin
                s0_AWVALID  = '0;
                s0_WVALID   = '0;
                s0_BREADY   = '0;
                s1_AWVALID  = '0;
                s1_WVALID   = '0;
                s1_BREADY   = '0;
                s2_AWVALID  = '0;
                s2_WVALID   = '0;
                s2_BREADY   = '0;
                s3_AWVALID  = '0;
                s3_WVALID   = '0;
                s3_BREADY   = '0;
                s4_AWVALID  = '0;
                s4_WVALID   = '0;
                s4_BREADY   = '0;
                s5_AWVALID  = '0;
                s5_WVALID   = '0;
                s5_BREADY   = '0;
                s6_AWVALID  = '0;
                s6_WVALID   = '0;
                s6_BREADY   = '0;
                s7_AWVALID  = '0;
                s7_WVALID   = '0;
                s7_BREADY   = '0;
                m_AWREADY   = '0;
                m_WREADY    = '0;
                m_BVALID    = '0;
                m_BID       = '0;
                m_BRESP     = '0;
                m_BUSER     = '0;
            end
        endcase
    end

endmodule