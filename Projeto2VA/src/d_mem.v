/*
PROJETO: Processador MIPS, autores: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

ARQUIVO: Modulo d_mem (memória RAM + escrita / leitura)

*/


module d_mem(
    input wire MemWrite, // flag de escrita
    input wire MemRead, // flag de leitura
    input wire [31:0] Address, // endereco
    input wire [31:0] WriteData, // dado a ser escrito
    output reg [31:0] ReadData // dado lido
);

    parameter MEMORIA_SIZE = 7;

    reg [31:0] ram_memory [0:MEMORIA_SIZE];

    always @(*) begin
    
        if (MemWrite) begin // se escrita, escreve
            ram_memory[Address] = WriteData;
        end
		  
        if (MemRead) begin // se leitura, lê
            ReadData = ram_memory[Address];
        end
        else begin
            ReadData = 32'b0;
        end
    end

endmodule