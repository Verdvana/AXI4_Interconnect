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

module AXI_Arbiter_W (
	/**********时钟&复位**********/
	input           ACLK,
	input      	    ARESETn,
	/********** 0号主控 **********/
    input                       m0_AWVALID,
    input                       m0_WVALID,
    input                       m0_BREADY,
	/********** 1号主控 **********/
    input                       m1_AWVALID,
    input                       m1_WVALID,
    input                       m1_BREADY,
	/********** 2号主控 **********/
    input                       m2_AWVALID,
    input                       m2_WVALID,
    input                       m2_BREADY,
	/********** 3号主控 **********/
    input                       m3_AWVALID,
    input                       m3_WVALID,
    input                       m3_BREADY,

    input                       m_AWREADY,
    input                       m_WREADY,
    input                       m_BVALID,
    
    output reg                  m0_wgrnt,
	output reg	                m1_wgrnt,
    output reg                  m2_wgrnt,
    output reg                  m3_wgrnt
);

    //=========================================================
    //常量定义
    parameter   TCO     =   1;  //寄存器延时


    //=========================================================
    //写地址通道仲裁状态机

    //---------------------------------------------------------
    //枚举所有状态（logic四状态）
    enum logic [1:0] {
        AXI_MASTER_0,    //0号主机占用总线状态
        AXI_MASTER_1,    //1号主机占用总线状态
        AXI_MASTER_2,    //2号主机占用总线状态
        AXI_MASTER_3     //3号主机占用总线状态
    } state,next_state;

    //---------------------------------------------------------
    //状态译码
    always_comb begin
        case (state)
            AXI_MASTER_0: begin                 //0号主机占用总线状态，响应请求优先级为：0>1>2>3
                if(m0_AWVALID)                  //如果0号主机请求总线
                    next_state = AXI_MASTER_0;  //保持0号主机占用总线状态
                else if(m0_WVALID||m_WREADY)    //如果还在写入数据
                    next_state = AXI_MASTER_0;  //保持0号主机占用总线状态
                else if(m_BVALID&&m0_BREADY)    //写回应完成
                    next_state = AXI_MASTER_1;  //更换优先级
                else if(m1_AWVALID)             //如果1号主机请求总线
                    next_state = AXI_MASTER_1;  //下一状态为1号主机占用总线
                else if(m2_AWVALID)             //如果2号主机请求总线
                    next_state = AXI_MASTER_2;  //下一状态为2号主机占用总线
                else if(m3_AWVALID)             //如果3号主机请求总线
                    next_state = AXI_MASTER_3;  //下一状态为3号主机占用总线
                else                            //都未请求总线
                    next_state = AXI_MASTER_0;  //保持0号主机占用总线状态
            end
            AXI_MASTER_1: begin                 //1号主机占用总线状态，响应请求优先级为：1>2>3>0
                if(m1_AWVALID)                  //与上一部分类似
                    next_state = AXI_MASTER_1;
                else if(m1_WVALID||m_WREADY)
                    next_state = AXI_MASTER_1;
                else if(m_BVALID&&m1_BREADY)
                    next_state = AXI_MASTER_2;
                else if(m2_AWVALID)
                    next_state = AXI_MASTER_2;
                else if(m3_AWVALID)
                    next_state = AXI_MASTER_3;
                else if(m0_AWVALID)
                    next_state = AXI_MASTER_0;
                else
                    next_state = AXI_MASTER_1;
            end
            AXI_MASTER_2: begin                 //2号主机占用总线状态，响应请求优先级为：2>3>0>1
                if(m2_AWVALID)                  //与上一部分类似
                    next_state = AXI_MASTER_2;
                else if(m2_WVALID||m_WREADY)
                    next_state = AXI_MASTER_2;
                else if(m_BVALID&&m2_BREADY)
                    next_state = AXI_MASTER_3;
                else if(m3_AWVALID)
                    next_state = AXI_MASTER_3;
                else if(m0_AWVALID)
                    next_state = AXI_MASTER_0;
                else if(m1_AWVALID)
                    next_state = AXI_MASTER_1;
                else
                    next_state = AXI_MASTER_2;
            end
            AXI_MASTER_3: begin                 //3号主机占用总线状态，响应请求优先级为：2>3>0>1
                if(m3_AWVALID)                  //与上一部分类似
                    next_state = AXI_MASTER_3;
                else if(m3_WVALID||m_WREADY)
                    next_state = AXI_MASTER_3;
                else if(m_BVALID&&m3_BREADY)
                    next_state = AXI_MASTER_0;
                else if(m0_AWVALID)
                    next_state = AXI_MASTER_0;
                else if(m1_AWVALID)
                    next_state = AXI_MASTER_1;
                else if(m2_AWVALID)
                    next_state = AXI_MASTER_2;
                else
                    next_state = AXI_MASTER_3;
            end
            default:
                next_state = AXI_MASTER_0;      //默认状态为0号主机占用总线
        endcase
    end


    //---------------------------------------------------------
    //更新状态寄存器
    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            state <= #TCO AXI_MASTER_0;         //默认状态为0号主机占用总线
        else
            state <= #TCO next_state;
    end

    //---------------------------------------------------------
    //利用状态寄存器输出控制结果
    always_comb begin
        case (state)
            AXI_MASTER_0: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b1000;
            AXI_MASTER_1: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0100;
            AXI_MASTER_2: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0010;
            AXI_MASTER_3: {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0001;
            default:      {m0_wgrnt,m1_wgrnt,m2_wgrnt,m3_wgrnt} = 4'b0000;
        endcase
    end

endmodule