module regfile (
    input wire clk,
    input wire we,
    input wire [4:0] rs1, rs2, rd,
    input wire [31:0] wd,
    output wire [31:0] rd1, rd2
);

    // 32 registradores de 32 bits
    reg [31:0] regs [0:31];

    // Leitura assíncrona
    assign rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

    // Escrita síncrona
    always @(posedge clk) begin
        if (we && rd != 5'd0) begin
            regs[rd] <= wd;
        end
    end

endmodule
