

module i_mem (endereco_PC, instrucao_out);

   // Descrição das entradas e saídas:
   input wire [31:0] endereco_PC;  		// Endereço fornecido pelo PC
   output reg [31:0] instrucao_out;   // Instrução de saída armazenada na posição especificada pelo endereco_pc
	
	parameter MEMORIA_TAMANHO = 64;    // Definição do tamanho do array da memoria_ROM
	
   // Declaração da memória ROM:
   reg [31:0] memoria_ROM [0: MEMORIA_TAMANHO - 1];  	// cria um array de registros de 256 posições com cada posição podendo armazenar uma instrução de 32 bits     
	
   // Inicializa a leitura da memória com os dados do arquivo externo "instruction.list":
   initial begin
       $readmemb("instructions.list", memoria_ROM);
   end
	
	always @ (endereco_PC) begin
		// Divide o endereco do PC por 4, para que assim seja possível acessar a posição correta da instrução no array 
		instrucao_out = memoria_ROM[endereco_PC >> 2];
	end

endmodule