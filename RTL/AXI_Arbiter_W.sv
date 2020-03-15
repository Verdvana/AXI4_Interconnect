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

module AXI_Arbiter_W (
	/**********时钟&复位**********/
	input           ACLK,
	input      	    ARESETn,
	/********** 0号主控 **********/
	input      	    m0_AWVALID,
    input      	    m0_WVALID,
    input           m0_WLAST,
    input           m0_BREADY,
	/********** 1号主控 **********/
	input      	    m1_AWVALID,
    input      	    m1_WVALID,
    input           m1_WLAST,
    input           m1_BREADY,
	/********** 2号主控 **********/
	input      	    m2_AWVALID,
    input      	    m2_WVALID,
    input           m2_WLAST,
    input           m2_BREADY,
	/********** 3号主控 **********/
	input      	    m3_AWVALID,
    input      	    m3_WVALID,
    input           m3_WLAST,
    input           m3_BREADY,
    /******* 主控通用信号 ********/
    input           m_AWREADY,
    input           m_WREADY,
    input           m_BVALID,
    /******* 写通道仲裁结果 *******/
	output reg      m0_wgrnt,
	output reg	    m1_wgrnt,
    output reg      m2_wgrnt,
    output reg      m3_wgrnt
);

    //=========================================================
    //常量定义
    parameter   TCO     =   1;  //寄存器延时

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
        {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = '0;     //产生默认值，防止产生锁存器
        case (state)
            AXI_AW_MASTER_0,                            //仲裁结果为0号主机
            AXI_W_MASTER_0,
            AXI_B_MASTER_0: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b1000;
            AXI_AW_MASTER_1,                            //仲裁结果为1号主机
            AXI_W_MASTER_1,
            AXI_B_MASTER_1: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0100;
            AXI_AW_MASTER_2,                            //仲裁结果为2号主机
            AXI_W_MASTER_2,
            AXI_B_MASTER_2: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0010;
            AXI_AW_MASTER_3,                            //仲裁结果为3号主机
            AXI_W_MASTER_3,
            AXI_B_MASTER_3: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0001;
            default:        {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0000;
        endcase
    end

endmodule