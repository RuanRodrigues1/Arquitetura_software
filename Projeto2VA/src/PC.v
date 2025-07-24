/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: PC (Lida com endereco PC (next ou reset))

*/

module PC (clock, next_PC, PC, reset);
    input wire clock;
    input wire [31:0] next_PC;
    input wire reset;
    output reg [31:0] PC;

    // A cada ciclo de clock
    always @(posedge clock) begin
        if (reset)
            PC <= 32'b0; // Se reset, reseta para 0
        else
            PC <= next_PC; // Se nao vai pra o proximo PC
    end

endmodule