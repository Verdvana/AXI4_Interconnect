//=============================================================================
//
//Module Name:					AXI_Master.sv
//Department:					Xidian University
//Function Description:	        AXI总线模拟主机
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

module AXI_Master(
    /**********时钟&复位**********/
    input               ACLK,
    input      	        ARESETn,
    /*********写地址通道**********/
    output reg [63:0]   AWADDR,
    output reg [7:0]	AWLEN,
    output reg          AWVALID,
    input               AWREADY,
    /*********写数据通道**********/
    output reg [1023:0] WDATA,
    output reg          WLAST,
    output reg          WVALID,
    input               WREADY,
    /*********写响应通道**********/
    input               BVALID,
    output reg          BREADY,
    /*********读地址通道**********/
    output reg [63:0]   ARADDR,
    output reg          ARVALID,
    input               ARREADY,
    /*********读数据通道**********/
    input  [1023:0]     RDATA,
    input               RLAST,
    input               RVALID,
    output reg	 		RREADY,
    /**********控制信号***********/
    input               en_w,
    input               en_r,
    input  [7:0]        awlen,
    input  [63:0]       addr_start,
    /**********读到数据***********/
    output reg [1023:0] data_r
);

    parameter   TCO =   1;

    //=========================================================
    //写地址通道

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            AWVALID <= #TCO '0;
        else if(en_w)
            AWVALID <= #TCO '1;
        else if(AWREADY&&AWVALID)
            AWVALID <= #TCO '0;
        else
            AWVALID <= #TCO AWVALID;
    end

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            AWLEN <= #TCO '0;
        else if(en_w)
            AWLEN <= #TCO awlen;
        else
            AWLEN <= #TCO AWLEN;
    end


    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            AWADDR <= #TCO '0;
        else if(en_w)
            AWADDR <= #TCO addr_start;
        else if(AWREADY)
            AWADDR <= #TCO '0;
    end


    //=========================================================
    //写数据通道

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            WVALID <= #TCO '0;
        else if(AWREADY)
            WVALID <= #TCO '1;
        else if(WREADY&&WVALID&&WLAST)
            WVALID <= #TCO '0;
        else
            WVALID <= #TCO WVALID;
    end

    logic en_data_w;

    always_comb begin
        if(AWREADY&&AWVALID)
            en_data_w = '1;
        else if(WLAST)
            en_data_w = '0;
        else
            en_data_w = en_data_w;
    end

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            WDATA <= #TCO '0;
        else if(en_data_w)
            WDATA <= #TCO WDATA+1;
        else
            WDATA <= #TCO '0;
    end

    logic [7:0] cnt_addr;

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            cnt_addr <= #TCO '0;
        else if(WVALID) begin
            if(cnt_addr==AWLEN)
                cnt_addr <= #TCO '0;
            else
                cnt_addr <= #TCO cnt_addr+1;
        end
        else
            cnt_addr <= #TCO '0;
    end
        

    always_comb begin
        if(WVALID)begin
            if(cnt_addr==AWLEN)
                WLAST = '1;
            else
                WLAST = '0;
        end
        else
            WLAST = '0;
    end

    //=========================================================
    //写响应通道

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            BREADY <= #TCO '0;
        else if(AWREADY)
            BREADY <= #TCO '1;
        else if(BVALID)
            BREADY <= #TCO '0;
        else
            BREADY <= #TCO BREADY;
    end


    //=========================================================
    //读地址通道

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            ARVALID <= #TCO '0;
        else if(en_r&&~ARVALID)
            ARVALID <= #TCO '1;
        else if(ARREADY&&ARVALID)
            ARVALID <= #TCO '0;
        else
            ARVALID <= #TCO ARVALID;
    end

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            ARADDR <= #TCO '0;
        else if(en_w)
            ARADDR <= #TCO addr_start;
        else
            ARADDR <= #TCO ARADDR;
    end

    //=========================================================
    //读数据通道

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            RREADY <= #TCO '0;
        else if(ARVALID)
            RREADY <= #TCO '1;
        else if(RLAST)
            RREADY <= #TCO '0;
        else
            RREADY <= #TCO RREADY;
    end

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            data_r <= #TCO '0;
        else if(RREADY&&ARVALID)
            data_r <= #TCO RDATA;
        else
            data_r <= #TCO '0;
    end

endmodule