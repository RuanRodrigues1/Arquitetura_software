/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: regfile

*/

module regfile (ReadAddr1, ReadAddr2, ReadData1, ReadData2, WriteAddr, WriteData, clock, reset, RegWrite);
	
	
	input wire clock, reset, RegWrite; 						
	
   input wire [4:0] ReadAddr1, ReadAddr2, WriteAddr; 	
	
   input wire [31:0] WriteData; 								

   output wire [31:0] ReadData1, ReadData2; 				

    reg [31:0] regs [0:31];

    always @(posedge clock or posedge reset) begin
	 
    // Zera todos os regs
		 if (reset) begin
			  regs[0]  <= 32'b0; regs[1]  <= 32'b0; regs[2]  <= 32'b0; regs[3]  <= 32'b0;
			  
			  regs[4]  <= 32'b0; regs[5]  <= 32'b0; regs[6]  <= 32'b0; regs[7]  <= 32'b0;
			  
			  regs[8]  <= 32'b0; regs[9]  <= 32'b0; regs[10] <= 32'b0; regs[11] <= 32'b0;
			  
			  regs[12] <= 32'b0; regs[13] <= 32'b0; regs[14] <= 32'b0; regs[15] <= 32'b0;
			  
			  regs[16] <= 32'b0; regs[17] <= 32'b0; regs[18] <= 32'b0; regs[19] <= 32'b0;
			  
			  regs[20] <= 32'b0; regs[21] <= 32'b0; regs[22] <= 32'b0; regs[23] <= 32'b0;
			  
			  regs[24] <= 32'b0; regs[25] <= 32'b0; regs[26] <= 32'b0; regs[27] <= 32'b0;
			  
			  regs[28] <= 32'b0; regs[29] <= 32'b0; regs[30] <= 32'b0; regs[31] <= 32'b0;
		 end 
		 
		 else if (RegWrite) begin
		 
			  if (WriteAddr != 5'b0) begin // Impede escrita no registrador $zero
			  
					regs[WriteAddr] <= WriteData;
					
			  end else begin
			  
					$display ("Registrador $zero não pode ser sobrescrito");
					
			  end
		 end
	end


    // Saídas para leitura dos registradores
    assign ReadData1 = (ReadAddr1 == 5'b0) ? 32'b0 : regs[ReadAddr1];
	 
    assign ReadData2 = (ReadAddr2 == 5'b0) ? 32'b0 : regs[ReadAddr2];

endmodule
