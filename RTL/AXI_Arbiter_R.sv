//=============================================================================
//
//Module Name:					AXI_Arbiter_R.sv
//Department:					Xidian University
//Function Description:	        AXI总线仲裁器读通道仲裁
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

module AXI_Arbiter_R#(
    parameter   DATA_WIDTH  = 1024,
                ADDR_WIDTH  = 64,
                ID_WIDTH    = 32,
                USER_WIDTH  = 1024
)(
	/**********时钟&复位**********/
	input                       ACLK,
	input      	                ARESETn,
	/********** 0号主控 **********/
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
    /******* 主控通用信号 ********/
    output reg [ID_WIDTH-1:0]   m_RID,
	output reg [DATA_WIDTH-1:0] m_RDATA,
	output reg [1:0]	        m_RRESP,
    output reg                  m_RLAST,
	output reg [USER_WIDTH-1:0]	m_RUSER,
    /********** 0号从机 **********/
    output reg                  s0_ARVALID,
	input	  		            s0_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s0_RID,
	input	   [DATA_WIDTH-1:0] s0_RDATA,
	input	   [1:0]	        s0_RRESP,
	input	  		            s0_RLAST,
	input	   [USER_WIDTH-1:0]	s0_RUSER,
	input	 		            s0_RVALID, 
    output reg                  s0_RREADY, 
    /********** 1号从机 **********/
    output reg                  s1_ARVALID,
	input	  		            s1_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s1_RID,
	input	   [DATA_WIDTH-1:0] s1_RDATA,
	input	   [1:0]	        s1_RRESP,
	input	  		            s1_RLAST,
	input	   [USER_WIDTH-1:0]	s1_RUSER,
	input	 		            s1_RVALID,
    output reg                  s1_RREADY,
    /********** 2号从机 **********/
    output reg                  s2_ARVALID,
	input	  		            s2_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s2_RID,
	input	   [DATA_WIDTH-1:0] s2_RDATA,
	input	   [1:0]	        s2_RRESP,
	input	  		            s2_RLAST,
	input	   [USER_WIDTH-1:0]	s2_RUSER,
	input	 		            s2_RVALID,
    output reg                  s2_RREADY,
    /********** 3号从机 **********/
    output reg                  s3_ARVALID,
	input	  		            s3_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s3_RID,
	input	   [DATA_WIDTH-1:0] s3_RDATA,
	input	   [1:0]	        s3_RRESP,
	input	  		            s3_RLAST,
	input	   [USER_WIDTH-1:0]	s3_RUSER,
	input	 		            s3_RVALID, 
    output reg                  s3_RREADY,
    /********** 4号从机 **********/
    output reg                  s4_ARVALID,
	input	  		            s4_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s4_RID,
	input	   [DATA_WIDTH:0]   s4_RDATA,
	input	   [1:0]	        s4_RRESP,
	input	  		            s4_RLAST,
	input	   [USER_WIDTH-1:0]	s4_RUSER,
	input	 		            s4_RVALID, 
    output reg                  s4_RREADY,
    /********** 5号从机 **********/
    output reg                  s5_ARVALID,
	input	  		            s5_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s5_RID,
	input	   [DATA_WIDTH:0]   s5_RDATA,
	input	   [1:0]	        s5_RRESP,
	input	  		            s5_RLAST,
	input	   [USER_WIDTH-1:0]	s5_RUSER,
	input	 		            s5_RVALID,
    output reg                  s5_RREADY,
    /********** 6号从机 **********/
    output reg                  s6_ARVALID,
	input	  		            s6_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s6_RID,
	input	   [DATA_WIDTH:0]   s6_RDATA,
	input	   [1:0]	        s6_RRESP,
	input	  		            s6_RLAST,
	input	   [USER_WIDTH-1:0]	s6_RUSER,
	input	 		            s6_RVALID, 
    output reg                  s6_RREADY, 
    /********** 7号从机 **********/
    output reg                  s7_ARVALID,
	input	  		            s7_ARREADY,
    //读数据通道
	input	   [ID_WIDTH-1:0]   s7_RID,
	input	   [DATA_WIDTH:0]   s7_RDATA,
	input	   [1:0]	        s7_RRESP,
	input	  		            s7_RLAST,
	input	   [USER_WIDTH-1:0]	s7_RUSER,
	input	 		            s7_RVALID, 
    output reg                  s7_RREADY,
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
    output reg [USER_WIDTH-1:0] s_ARUSER  
);

    //=========================================================
    //常量定义
    parameter   TCO     =   1;  //寄存器延时

    //=========================================================
    //中间信号
    logic       m_ARREADY;
    logic       m_RVALID;
    logic       s_ARVALID;
    logic       s_RREADY;

    //=========================================================
    //读地址寄存

    logic [2:0] araddr [4];
    logic [2:0] m_ARADDR;

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)begin
            for(int i=0;i<4;i++)
                araddr[i] <= #TCO '0;
        end
        else if(m0_ARVALID||m1_ARVALID||m2_ARVALID||m3_ARVALID)begin
            araddr[0] <= #TCO m0_ARADDR[ADDR_WIDTH-1-:3];
            araddr[1] <= #TCO m1_ARADDR[ADDR_WIDTH-1-:3];
            araddr[2] <= #TCO m2_ARADDR[ADDR_WIDTH-1-:3];
            araddr[3] <= #TCO m3_ARADDR[ADDR_WIDTH-1-:3];
        end
    end

    //=========================================================
    //写地址通道仲裁状态机

    //---------------------------------------------------------
    //枚举所有状态（logic四状态）
    enum logic [2:0] {
        AXI_AR_MASTER_0,    //0号主机读地址通道握手状态
        AXI_R_MASTER_0,     //0号主机读数据通道握手状态

        AXI_AR_MASTER_1,    //1号主机读地址通道握手状态
        AXI_R_MASTER_1,     //1号主机读数据通道握手状态

        AXI_AR_MASTER_2,    //2号主机读地址通道握手状态
        AXI_R_MASTER_2,     //2号主机读数据通道握手状态

        AXI_AR_MASTER_3,    //3号主机读地址通道握手状态
        AXI_R_MASTER_3      //3号主机读数据通道握手状态
    } state,next_state;

    //---------------------------------------------------------
    //状态译码
    always_comb begin
        case (state)
            AXI_AR_MASTER_0: begin                      //0号主机读地址通道握手状态，此状态下仲裁优先级为：0>1>2>3
                if(m0_ARVALID)begin                     //0号主机申请仲裁
                    if(m_ARREADY)                       //有握手回应
                        next_state = AXI_R_MASTER_0;    //进入0号主机读数据通道握手状态
                    else
                        next_state = AXI_AR_MASTER_0;   //否则状态不变
                end
                else if(m1_ARVALID)                     //1号主机申请仲裁
                    next_state = AXI_AR_MASTER_1;       //进入1号主机读地址通道握手状态
                else if(m2_ARVALID)                     //2号主机申请仲裁
                    next_state = AXI_AR_MASTER_2;       //进入2号主机读地址通道握手状态
                else if(m3_ARVALID)                     //3号主机申请仲裁
                    next_state = AXI_AR_MASTER_3;       //进入3号主机读地址通道握手状态
                else                                    //都未申请仲裁
                    next_state = AXI_AR_MASTER_0;       //保持在0号主机读地址通道握手状态
            end
            AXI_AR_MASTER_1: begin                      //1号主机读地址通道握手状态，此状态下仲裁优先级为：1>2>3>0
                if(m1_ARVALID)begin                     //与上一部分类似
                    if(m_ARREADY)
                        next_state = AXI_R_MASTER_1;
                    else
                        next_state = AXI_AR_MASTER_1;
                end
                else if(m2_ARVALID)
                    next_state = AXI_AR_MASTER_2;
                else if(m3_ARVALID)
                    next_state = AXI_AR_MASTER_3;
                else if(m0_ARVALID)
                    next_state = AXI_AR_MASTER_0;
                else
                    next_state = AXI_AR_MASTER_1;
            end
            AXI_AR_MASTER_2: begin                      //2号主机读地址通道握手状态，此状态下仲裁优先级为：2>3>0>1
                if(m2_ARVALID)begin                     //与上一部分类似
                    if(m_ARREADY)
                        next_state = AXI_R_MASTER_2;
                    else
                        next_state = AXI_AR_MASTER_2;
                end
                else if(m3_ARVALID)
                    next_state = AXI_AR_MASTER_3;
                else if(m0_ARVALID)
                    next_state = AXI_AR_MASTER_0;
                else if(m1_ARVALID)
                    next_state = AXI_AR_MASTER_1;
                else
                    next_state = AXI_AR_MASTER_2;
            end
            AXI_AR_MASTER_3: begin                      //3号主机读地址通道握手状态，此状态下仲裁优先级为：3>0>1>2
                if(m3_ARVALID)begin                     //与上一部分类似
                    if(m_ARREADY)
                        next_state = AXI_R_MASTER_3;
                    else
                        next_state = AXI_AR_MASTER_3;
                end
                else if(m0_ARVALID)
                    next_state = AXI_AR_MASTER_0;
                else if(m1_ARVALID)
                    next_state = AXI_AR_MASTER_1;
                else if(m2_ARVALID)
                    next_state = AXI_AR_MASTER_2;
                else
                    next_state = AXI_AR_MASTER_3;
            end

            AXI_R_MASTER_0: begin                       //0号主机读数据通道握手状态
                if(m_RLAST)begin                        //如果读取到最后一个数
                    if(m_RVALID && m0_RREADY)            //此时握手成功
                        next_state = AXI_AR_MASTER_1;   //则0号主机一次读任务完成，下次优先仲裁1号主机
                    else
                        next_state = AXI_AR_MASTER_0;   //否则回到0号主机读地址通道握手状态
                end
                else begin                              //如果还在读取数据中
                    if(~m_RVALID && ~m0_RREADY)          //握手断开
                        next_state = AXI_AR_MASTER_0;   //回到0号主机读地址通道握手状态
                    else
                        next_state = AXI_R_MASTER_0;    //保持0号主机读数据通道握手状态
                end
            end
            AXI_R_MASTER_1: begin                       //1号主机读数据通道握手状态  
                if(m_RLAST)begin                        //与上一部分类似
                    if(m_RVALID && m1_RREADY)
                        next_state = AXI_AR_MASTER_2;
                    else
                        next_state = AXI_AR_MASTER_1;
                end
                else begin
                    if(~m_RVALID && ~m1_RREADY)
                        next_state = AXI_AR_MASTER_1;
                    else
                        next_state = AXI_R_MASTER_1;
                end
            end
            AXI_R_MASTER_2: begin                       //2号主机读数据通道握手状态
                if(m_RLAST)begin                        //与上一部分类似
                    if(m_RVALID && m2_RREADY)
                        next_state = AXI_AR_MASTER_3;
                    else
                        next_state = AXI_AR_MASTER_2;
                end
                else begin
                    if(~m_RVALID && ~m2_RREADY)
                        next_state = AXI_AR_MASTER_2;
                    else
                        next_state = AXI_R_MASTER_2;
                end
            end
            AXI_R_MASTER_3: begin                       //3号主机读数据通道握手状态
                if(m_RLAST)begin                        //与上一部分类似
                    if(m_RVALID && m3_RREADY)
                        next_state = AXI_AR_MASTER_0;
                    else
                        next_state = AXI_AR_MASTER_3;
                end
                else begin
                    if(~m_RVALID && ~m3_RREADY)
                        next_state = AXI_AR_MASTER_3;
                    else
                        next_state = AXI_R_MASTER_3;
                end
            end

            default:                                    //默认状态为0号主机读地址通道握手状态
                next_state = AXI_AR_MASTER_0;
        endcase
    end


    //---------------------------------------------------------
    //更新状态寄存器
    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            state <= #TCO AXI_AR_MASTER_0;              //默认状态为0号主机读地址通道握手状态
        else
            state <= #TCO next_state;
    end

    //---------------------------------------------------------
    //利用状态寄存器输出控制结果
    always_comb begin
        case (state)
            AXI_AR_MASTER_0,                            //仲裁结果为0号主机
            AXI_R_MASTER_0: begin
                s_ARID      = m0_ARID;
                s_ARADDR    = m0_ARADDR;
                s_ARLEN     = m0_ARLEN;
                s_ARSIZE    = m0_ARSIZE;
                s_ARBURST   = m0_ARBURST;
                s_ARLOCK    = m0_ARLOCK;
                s_ARCACHE   = m0_ARCACHE;
                s_ARPROT    = m0_ARPROT;
                s_ARQOS     = m0_ARQOS;
                s_ARREGION  = m0_ARREGION;
                s_ARUSER    = m0_ARUSER;
                s_ARVALID   = m0_ARVALID;
                s_RREADY    = m0_RREADY;
                m_ARADDR    = araddr[0];
                m0_ARREADY  = m_ARREADY;
                m1_ARREADY  = '0;
                m2_ARREADY  = '0;
                m3_ARREADY  = '0;
                m0_RVALID   = m_RVALID;
                m1_RVALID   = '0;
                m2_RVALID   = '0;
                m3_RVALID   = '0;
            end
            AXI_AR_MASTER_1,                            //仲裁结果为1号主机
            AXI_R_MASTER_1: begin
                s_ARID      = m1_ARID;
                s_ARADDR    = m1_ARADDR;
                s_ARLEN     = m1_ARLEN;
                s_ARSIZE    = m1_ARSIZE;
                s_ARBURST   = m1_ARBURST;
                s_ARLOCK    = m1_ARLOCK;
                s_ARCACHE   = m1_ARCACHE;
                s_ARPROT    = m1_ARPROT;
                s_ARQOS     = m1_ARQOS;
                s_ARREGION  = m1_ARREGION;
                s_ARUSER    = m1_ARUSER;
                s_ARVALID   = m1_ARVALID;
                s_RREADY    = m1_RREADY;
                m_ARADDR    = araddr[1];
                m0_ARREADY  = '0;
                m1_ARREADY  = m_ARREADY;
                m2_ARREADY  = '0;
                m3_ARREADY  = '0;
                m0_RVALID   = '0;
                m1_RVALID   = m_RVALID;
                m2_RVALID   = '0;
                m3_RVALID   = '0;
            end
            AXI_AR_MASTER_2,                            //仲裁结果为2号主机
            AXI_R_MASTER_2: begin
                s_ARID      = m2_ARID;
                s_ARADDR    = m2_ARADDR;
                s_ARLEN     = m2_ARLEN;
                s_ARSIZE    = m2_ARSIZE;
                s_ARBURST   = m2_ARBURST;
                s_ARLOCK    = m2_ARLOCK;
                s_ARCACHE   = m2_ARCACHE;
                s_ARPROT    = m2_ARPROT;
                s_ARQOS     = m2_ARQOS;
                s_ARREGION  = m2_ARREGION;
                s_ARUSER    = m2_ARUSER;
                s_ARVALID   = m2_ARVALID;
                s_RREADY    = m2_RREADY;
                m_ARADDR    = araddr[2];
                m0_ARREADY  = '0;
                m1_ARREADY  = '0;
                m2_ARREADY  = m_ARREADY;
                m3_ARREADY  = '0;
                m0_RVALID   = '0;
                m1_RVALID   = '0;
                m2_RVALID   = m_RVALID;
                m3_RVALID   = '0;
            end
            AXI_AR_MASTER_3,                            //仲裁结果为3号主机
            AXI_R_MASTER_3: begin
                s_ARID      = m3_ARID;
                s_ARADDR    = m3_ARADDR;
                s_ARLEN     = m3_ARLEN;
                s_ARSIZE    = m3_ARSIZE;
                s_ARBURST   = m3_ARBURST;
                s_ARLOCK    = m3_ARLOCK;
                s_ARCACHE   = m3_ARCACHE;
                s_ARPROT    = m3_ARPROT;
                s_ARQOS     = m3_ARQOS;
                s_ARREGION  = m3_ARREGION;
                s_ARUSER    = m3_ARUSER;
                s_ARVALID   = m3_ARVALID;
                s_RREADY    = m3_RREADY;
                m_ARADDR    = araddr[3];
                m0_ARREADY  = '0;
                m1_ARREADY  = '0;
                m2_ARREADY  = '0;
                m3_ARREADY  = m_ARREADY;
                m0_RVALID   = '0;
                m1_RVALID   = '0;
                m2_RVALID   = '0;
                m3_RVALID   = m_RVALID;
            end
            default:        begin
                s_ARID      = '0;
                s_ARADDR    = '0;
                s_ARLEN     = '0;
                s_ARSIZE    = '0;
                s_ARBURST   = '0;
                s_ARLOCK    = '0;
                s_ARCACHE   = '0;
                s_ARPROT    = '0;
                s_ARQOS     = '0;
                s_ARREGION  = '0;
                s_ARUSER    = '0;
                s_ARVALID   = '0;
                s_RREADY    = '0;
                m_ARADDR    = '0;
                m0_ARREADY  = '0;
                m1_ARREADY  = '0;
                m2_ARREADY  = '0;
                m3_ARREADY  = '0;
                m0_RVALID   = '0;
                m1_RVALID   = '0;
                m2_RVALID   = '0;
                m3_RVALID   = '0;
            end
        endcase
    end


    always_comb begin
        case(m_ARADDR)
            3'b000: begin
                s0_ARVALID  = s_ARVALID;
                s0_RREADY   = s_RREADY;
                s1_ARVALID  = '0;
                s1_RREADY   = '0;
                s2_ARVALID  = '0;
                s2_RREADY   = '0;
                s3_ARVALID  = '0;
                s3_RREADY   = '0;
                s4_ARVALID  = '0;
                s4_RREADY   = '0;
                s5_ARVALID  = '0;
                s5_RREADY   = '0;
                s6_ARVALID  = '0;
                s6_RREADY   = '0;
                s7_ARVALID  = '0;
                s7_RREADY   = '0;
                m_ARREADY   = s0_ARREADY;
                m_RVALID    = s0_RVALID;
                m_RID       = s0_RID;
                m_RDATA     = s0_RDATA;
                m_RRESP     = s0_RRESP;
                m_RLAST     = s0_RLAST;
                m_RUSER     = s0_RUSER;
            end
            3'b001: begin
                s0_ARVALID  = '0;
                s0_RREADY   = '0;
                s1_ARVALID  = s_ARVALID;
                s1_RREADY   = s_RREADY;
                s2_ARVALID  = '0;
                s2_RREADY   = '0;
                s3_ARVALID  = '0;
                s3_RREADY   = '0;
                s4_ARVALID  = '0;
                s4_RREADY   = '0;
                s5_ARVALID  = '0;
                s5_RREADY   = '0;
                s6_ARVALID  = '0;
                s6_RREADY   = '0;
                s7_ARVALID  = '0;
                s7_RREADY   = '0;
                m_ARREADY   = s1_ARREADY;
                m_RVALID    = s1_RVALID;
                m_RID       = s1_RID;
                m_RDATA     = s1_RDATA;
                m_RRESP     = s1_RRESP;
                m_RLAST     = s1_RLAST;
                m_RUSER     = s1_RUSER;
            end
            3'b010: begin
                s0_ARVALID  = '0;
                s0_RREADY   = '0;
                s1_ARVALID  = '0;
                s1_RREADY   = '0;
                s2_ARVALID  = s_ARVALID;
                s2_RREADY   = s_RREADY;
                s3_ARVALID  = '0;
                s3_RREADY   = '0;
                s4_ARVALID  = '0;
                s4_RREADY   = '0;
                s5_ARVALID  = '0;
                s5_RREADY   = '0;
                s6_ARVALID  = '0;
                s6_RREADY   = '0;
                s7_ARVALID  = '0;
                s7_RREADY   = '0;
                m_ARREADY   = s2_ARREADY;
                m_RVALID    = s2_RVALID;
                m_RID       = s2_RID;
                m_RDATA     = s2_RDATA;
                m_RRESP     = s2_RRESP;
                m_RLAST     = s2_RLAST;
                m_RUSER     = s2_RUSER;
            end
            3'b011: begin
                s0_ARVALID  = '0;
                s0_RREADY   = '0;
                s1_ARVALID  = '0;
                s1_RREADY   = '0;
                s2_ARVALID  = '0;
                s2_RREADY   = '0;
                s3_ARVALID  = s_ARVALID;
                s3_RREADY   = s_RREADY;
                s4_ARVALID  = '0;
                s4_RREADY   = '0;
                s5_ARVALID  = '0;
                s5_RREADY   = '0;
                s6_ARVALID  = '0;
                s6_RREADY   = '0;
                s7_ARVALID  = '0;
                s7_RREADY   = '0;
                m_ARREADY   = s3_ARREADY;
                m_RVALID    = s3_RVALID;
                m_RID       = s3_RID;
                m_RDATA     = s3_RDATA;
                m_RRESP     = s3_RRESP;
                m_RLAST     = s3_RLAST;
                m_RUSER     = s3_RUSER;
            end
            3'b100: begin
                s0_ARVALID  = '0;
                s0_RREADY   = '0;
                s1_ARVALID  = '0;
                s1_RREADY   = '0;
                s2_ARVALID  = '0;
                s2_RREADY   = '0;
                s3_ARVALID  = '0;
                s3_RREADY   = '0;
                s4_ARVALID  = s_ARVALID;
                s4_RREADY   = s_RREADY;
                s5_ARVALID  = '0;
                s5_RREADY   = '0;
                s6_ARVALID  = '0;
                s6_RREADY   = '0;
                s7_ARVALID  = '0;
                s7_RREADY   = '0;
                m_ARREADY   = s4_ARREADY;
                m_RVALID    = s4_RVALID;
                m_RID       = s4_RID;
                m_RDATA     = s4_RDATA;
                m_RRESP     = s4_RRESP;
                m_RLAST     = s4_RLAST;
                m_RUSER     = s4_RUSER;
            end
            3'b101: begin
                s0_ARVALID  = '0;
                s0_RREADY   = '0;
                s1_ARVALID  = '0;
                s1_RREADY   = '0;
                s2_ARVALID  = '0;
                s2_RREADY   = '0;
                s3_ARVALID  = '0;
                s3_RREADY   = '0;
                s4_ARVALID  = '0;
                s4_RREADY   = '0;
                s5_ARVALID  = s_ARVALID;
                s5_RREADY   = s_RREADY;
                s6_ARVALID  = '0;
                s6_RREADY   = '0;
                s7_ARVALID  = '0;
                s7_RREADY   = '0;
                m_ARREADY   = s5_ARREADY;
                m_RVALID    = s5_RVALID;
                m_RID       = s5_RID;
                m_RDATA     = s5_RDATA;
                m_RRESP     = s5_RRESP;
                m_RLAST     = s5_RLAST;
                m_RUSER     = s5_RUSER;
            end
            3'b110: begin
                s0_ARVALID  = '0;
                s0_RREADY   = '0;
                s1_ARVALID  = '0;
                s1_RREADY   = '0;
                s2_ARVALID  = '0;
                s2_RREADY   = '0;
                s3_ARVALID  = '0;
                s3_RREADY   = '0;
                s4_ARVALID  = '0;
                s4_RREADY   = '0;
                s5_ARVALID  = '0;
                s5_RREADY   = '0;
                s6_ARVALID  = s_ARVALID;
                s6_RREADY   = s_RREADY;
                s7_ARVALID  = '0;
                s7_RREADY   = '0;
                m_ARREADY   = s6_ARREADY;
                m_RVALID    = s6_RVALID;
                m_RID       = s6_RID;
                m_RDATA     = s6_RDATA;
                m_RRESP     = s6_RRESP;
                m_RLAST     = s6_RLAST;
                m_RUSER     = s6_RUSER;
            end
            3'b111: begin
                s0_ARVALID  = '0;
                s0_RREADY   = '0;
                s1_ARVALID  = '0;
                s1_RREADY   = '0;
                s2_ARVALID  = '0;
                s2_RREADY   = '0;
                s3_ARVALID  = '0;
                s3_RREADY   = '0;
                s4_ARVALID  = '0;
                s4_RREADY   = '0;
                s5_ARVALID  = '0;
                s5_RREADY   = '0;
                s6_ARVALID  = '0;
                s6_RREADY   = '0;
                s7_ARVALID  = s_ARVALID;
                s7_RREADY   = s_RREADY;
                m_ARREADY   = s7_ARREADY;
                m_RVALID    = s7_RVALID;
                m_RID       = s7_RID;
                m_RDATA     = s7_RDATA;
                m_RRESP     = s7_RRESP;
                m_RLAST     = s7_RLAST;
                m_RUSER     = s7_RUSER;
            end
            default: begin
                s0_ARVALID  = '0;
                s0_RREADY   = '0;
                s1_ARVALID  = '0;
                s1_RREADY   = '0;
                s2_ARVALID  = '0;
                s2_RREADY   = '0;
                s3_ARVALID  = '0;
                s3_RREADY   = '0;
                s4_ARVALID  = '0;
                s4_RREADY   = '0;
                s5_ARVALID  = '0;
                s5_RREADY   = '0;
                s6_ARVALID  = '0;
                s6_RREADY   = '0;
                s7_ARVALID  = '0;
                s7_RREADY   = '0;
                m_ARREADY   = '0;
                m_RVALID    = '0;
                m_RID       = '0;
                m_RDATA     = '0;
                m_RRESP     = '0;
                m_RLAST     = '0;
                m_RUSER     = '0;
            end
        endcase
    end
endmodule