/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: d_mem

*/
module d_mem(
    input wire clock, input wire MemWrite, input wire MemRead, input wire [31:0] Address,
    input wire [31:0] WriteData, output reg [31:0] ReadData
);
    reg [31:0] ram_memory [0:63];
    always @(*) begin
        if (MemRead) ReadData = ram_memory[Address >> 2];
        else ReadData = 32'bz;
    end
    always @(posedge clock) begin
        if (MemWrite) ram_memory[Address >> 2] <= WriteData;
    end
endmodule