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
//
//------------------------------------------------------------------------------
//
//Version	Modified History
//V1.0		
//
//=============================================================================

`timescale 1ns/1ns

module AXI_Arbiter_R (
	/**********时钟&复位**********/
	input           ACLK,
	input      	    ARESETn,
	/********** 0号主控 **********/
	input      	    m0_ARVALID,
	/********** 1号主控 **********/
	input      	    m1_ARVALID,
	/********** 2号主控 **********/
	input      	    m2_ARVALID,
	/********** 3号主控 **********/
	input      	    m3_ARVALID,
    /******* 主控通用信号 ********/
    input           m_ARREADY,
    input           m_RLAST,
    input           m_RVALID,
    input           s_RREADY,
    /******* 读通道仲裁结果 *******/
	output reg      m0_rgrnt,
	output reg      m1_rgrnt,
	output reg      m2_rgrnt,
	output reg      m3_rgrnt
);

    //=========================================================
    //常量定义
    parameter   TCO     =   1;  //寄存器延时

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
                    if(m_RVALID && s_RREADY)            //此时握手成功
                        next_state = AXI_AR_MASTER_1;   //则0号主机一次读任务完成，下次优先仲裁1号主机
                    else
                        next_state = AXI_AR_MASTER_0;   //否则回到0号主机读地址通道握手状态
                end
                else begin                              //如果还在读取数据中
                    if(~m_RVALID && ~s_RREADY)          //握手断开
                        next_state = AXI_AR_MASTER_0;   //回到0号主机读地址通道握手状态
                    else
                        next_state = AXI_R_MASTER_0;    //保持0号主机读数据通道握手状态
                end
            end
            AXI_R_MASTER_1: begin                       //1号主机读数据通道握手状态  
                if(m_RLAST)begin                        //与上一部分类似
                    if(m_RVALID && s_RREADY)
                        next_state = AXI_AR_MASTER_2;
                    else
                        next_state = AXI_AR_MASTER_1;
                end
                else begin
                    if(~m_RVALID && ~s_RREADY)
                        next_state = AXI_AR_MASTER_1;
                    else
                        next_state = AXI_R_MASTER_1;
                end
            end
            AXI_R_MASTER_2: begin                       //2号主机读数据通道握手状态
                if(m_RLAST)begin                        //与上一部分类似
                    if(m_RVALID && s_RREADY)
                        next_state = AXI_AR_MASTER_3;
                    else
                        next_state = AXI_AR_MASTER_2;
                end
                else begin
                    if(~m_RVALID && ~s_RREADY)
                        next_state = AXI_AR_MASTER_2;
                    else
                        next_state = AXI_R_MASTER_2;
                end
            end
            AXI_R_MASTER_3: begin                       //3号主机读数据通道握手状态
                if(m_RLAST)begin                        //与上一部分类似
                    if(m_RVALID && s_RREADY)
                        next_state = AXI_AR_MASTER_0;
                    else
                        next_state = AXI_AR_MASTER_3;
                end
                else begin
                    if(~m_RVALID && ~s_RREADY)
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
        {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = '0;     //产生默认值，防止产生锁存器
        case (state)
            AXI_AR_MASTER_0,                            //仲裁结果为0号主机
            AXI_R_MASTER_0: {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b1000;
            AXI_AR_MASTER_1,                            //仲裁结果为1号主机
            AXI_R_MASTER_1: {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b0100;
            AXI_AR_MASTER_2,                            //仲裁结果为2号主机
            AXI_R_MASTER_2: {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b0010;
            AXI_AR_MASTER_3,                            //仲裁结果为3号主机
            AXI_R_MASTER_3: {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b0001;
            default:        {m0_rgrnt,m1_rgrnt,m2_rgrnt,m3_rgrnt} = 4'b0000;
        endcase
    end
    
endmodule