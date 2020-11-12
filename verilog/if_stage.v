`include "defines.v"

module if_stage (
    input 	wire 					cpu_clk_50M,
    input 	wire 					cpu_rst_n,
    
    input   wire [ 1: 0         ]  jtsel,
    input   wire [`REG_BUS      ]  addr1,
    input   wire [`REG_BUS      ]  addr2,
    input   wire [`REG_BUS      ]  addr3,
    
    output  reg                    ice,
    output 	reg  [`INST_ADDR_BUS] 	pc,
    output 	wire [`INST_ADDR_BUS]	iaddr
    );
    
    wire [`INST_ADDR_BUS] pc_next; 
    assign pc_next = pc + 4;                  // 计算下一条指令的地址
    always @(posedge cpu_clk_50M) begin
		if (cpu_rst_n == `RST_ENABLE) begin
			ice <= `CHIP_DISABLE;		      // 复位的时候指令存储器禁用  
		end else begin
			ice <= `CHIP_ENABLE; 		      // 复位结束后，指令存储器使能
		end
	end

    always @(posedge cpu_clk_50M) begin
        if (ice == `CHIP_DISABLE)
            pc <= `PC_INIT;                   // 指令存储器禁用的时候，PC保持初始值（MiniMIPS32中设置为0x00000000）
        else begin
            case (jtsel)
                2'b00: pc <= pc_next;
                2'b01: pc <= addr3;
                2'b10: pc <= addr1;
                2'b11: pc <= addr2;
                default: pc <= pc_next; // 指令存储器使能后，PC值每时钟周期加4 
            endcase	
        end
    end
    
    assign iaddr = (ice == `CHIP_DISABLE) ? `PC_INIT : pc;    // 获得访问指令存储器的地址

endmodule