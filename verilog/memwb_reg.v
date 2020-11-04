`include "defines.v"

module memwb_reg (
    input  wire                     cpu_clk_50M,
	input  wire                     cpu_rst_n,

	// ���Էô�׶ε���Ϣ
	input  wire [`REG_ADDR_BUS  ]   mem_wa,
	input  wire                     mem_wreg,
	input  wire                     mem_whilo,
	input  wire                     mem_mreg,
	input  wire [`REG_BUS       ] 	 mem_dreg,
	input  wire [`DOUBLE_REG_BUS] 	 mem_dhilo,
	input wire  [`DATA_WE_BUS   ]   mem_dre,

	// ����д�ؽ׶ε���Ϣ 
	output reg  [`REG_ADDR_BUS  ]   wb_wa,
	output reg                      wb_wreg,
	output reg                      wb_whilo,
	output reg                      wb_mreg,
	output reg  [`REG_BUS       ]   wb_dreg,
	output reg  [`DOUBLE_REG_BUS]   wb_dhilo,
	output reg  [`DATA_WE_BUS   ]   wb_dre
    );

    always @(posedge cpu_clk_50M) begin
		// ��λ��ʱ������д�ؽ׶ε���Ϣ��0
		if (cpu_rst_n == `RST_ENABLE) begin
			wb_wa       <= `REG_NOP;
			wb_wreg     <= `WRITE_DISABLE;
			wb_whilo    <= `WRITE_DISABLE;
			wb_mreg     <= `WRITE_DISABLE;
			wb_dreg     <= `ZERO_WORD;
			wb_dhilo    <= `ZERO_DWORD;
			wb_dre      <= 4'b0000;
		end
		// �����Էô�׶ε���Ϣ�Ĵ沢����д�ؽ׶�
		else begin
			wb_wa 	    <= mem_wa;
			wb_wreg     <= mem_wreg;
			wb_whilo    <= mem_whilo;
			wb_mreg     <= mem_mreg;
			wb_dreg     <= mem_dreg;
			wb_dhilo    <= mem_dhilo;
			wb_dre      <= mem_dre;
		end
	end

endmodule