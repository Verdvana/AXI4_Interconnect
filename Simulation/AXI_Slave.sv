//=============================================================================
//
//Module Name:					AXI_Slave.sv
//Department:					Xidian University
//Function Description:	        AXI总线模拟从机
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

module AXI_Slave(
    /**********时钟&复位**********/
    input               ACLK,
    input      	        ARESETn,
    /*********写地址通道**********/
    input      [63:0]   AWADDR,
    input      [7:0]	AWLEN,
    input               AWVALID,
    output reg          AWREADY,
    /*********写数据通道**********/
    input      [1023:0] WDATA,
    input               WLAST,
    input               WVALID,
    output reg          WREADY,
    /*********写响应通道**********/
    output reg          BVALID,
    input               BREADY,
    /*********读地址通道**********/
    input      [63:0]   ARADDR,
    input               ARVALID,
    output reg          ARREADY,
    /*********读数据通道**********/
    output reg [1023:0] RDATA,
    output reg          RLAST,
    output reg          RVALID,
    input     	 		RREADY
);

    parameter   TCO =   1;

    //=========================================================
    //写地址通道

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            AWREADY <= #TCO '0;
        else if(AWVALID&&!AWREADY)
            AWREADY <= #TCO '1;
        else
            AWREADY <= #TCO '0;
    end

    logic [63:0] addr_w;

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            addr_w <= #TCO '0;
        else if(AWVALID)
            addr_w <= #TCO {3'b000,AWADDR[60:0]};
        else
            addr_w <= #TCO addr_w;
    end

    logic [7:0] len_w;

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            len_w <= #TCO '0;
        else if(AWVALID)
            len_w <= #TCO AWLEN;
        else
            len_w <= #TCO len_w;
    end


    


    //=========================================================
    //写数据通道

    reg [1023:0] ram [64];

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            WREADY <= #TCO '0;
        else if(WVALID&&!WREADY)
            WREADY <= #TCO '1;
        else if(WVALID&&WLAST)
            WREADY <= #TCO '0;
        else
            WREADY <= #TCO WREADY;
    end

    logic [7:0] cnt_addr_w;

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            cnt_addr_w <= #TCO '0;
        else if(WVALID) begin
            if(cnt_addr_w==len_w)
                cnt_addr_w <= #TCO '0;
            else
                cnt_addr_w <= #TCO cnt_addr_w+1;
        end
        else
            cnt_addr_w <= #TCO '0;
    end



    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)begin
            for(int i=0;i<64;i++)
                ram[i] <= #TCO '0;
        end
        else if(WVALID)
            ram[addr_w+cnt_addr_w] <= #TCO WDATA;
    end

        

    //=========================================================
    //写响应通道

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            BVALID <= #TCO '0;
        else if(WLAST)
            BVALID <= #TCO '1;
        else if(BREADY)
            BVALID <= #TCO '0;
        else
            BVALID <= #TCO '0;
    end


    //=========================================================
    //读地址通道

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            ARREADY <= #TCO '0;
        else if(ARVALID&&!ARREADY)
            ARREADY <= #TCO '1;
        else
            ARREADY <= #TCO '0;
    end

    logic [63:0] addr_r;

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            addr_r <= #TCO '0;
        else if(ARVALID)
            addr_r <= #TCO ARADDR; 
        else
            addr_r <= #TCO addr_r;
    end

    //=========================================================
    //读数据通道

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            RVALID <= #TCO '0;
        else if(ARREADY)
            RVALID <= #TCO '1;
        else if(RLAST)
            RVALID <= #TCO '0;
        else
            RVALID <= #TCO RVALID;
    end

    logic [7:0] cnt_addr_r;

    always_ff@(posedge ACLK, negedge ARESETn) begin
        if(!ARESETn)
            RLAST <= #TCO '0;
        if(cnt_addr_r==len_w)
            RLAST <= #TCO '1;
        else
            RLAST <= #TCO '0;
    end

    logic en_data_r;

    always_comb begin
        if(ARREADY)
            en_data_r = '1;
        else if(RLAST)
            en_data_r = '0;
        else
            en_data_r = en_data_r;
    end
    

    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            cnt_addr_r <= #TCO '0;
        else if(en_data_r) begin
            if(cnt_addr_r==len_w)
                cnt_addr_r <= #TCO '0;
            else
                cnt_addr_r <= #TCO cnt_addr_r+1;
        end
        else
            cnt_addr_r <= #TCO '0;
    end





    always_ff@(posedge ACLK, negedge ARESETn)begin
        if(!ARESETn)
            RDATA <= #TCO '0;
        else if(en_data_r)
            RDATA <= #TCO ram[addr_r+cnt_addr_r];
        else
            RDATA <= #TCO '0;
    end







endmodule