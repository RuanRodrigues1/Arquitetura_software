

module regfile (ReadAddr1, ReadAddr2, ReadData1, ReadData2, WriteAddr, WriteData, clock, reset, RegWrite);
	
	//Descrição das entradas e saidas:
	input wire clock, reset, RegWrite; 						// Sinais relacionados ao clock e módulo de controle
   input wire [4:0] ReadAddr1, ReadAddr2, WriteAddr; 	// Endereços dos registradores (0 a 31)
   input wire [31:0] WriteData; 								// Dado a ser escrito no registrador
   output wire [31:0] ReadData1, ReadData2; 				// Dados lidos dos registradores

    // Banco de Registradores: 32 registradores de 32 bits
    reg [31:0] regs [0:31];

    always @(posedge clock or posedge reset) begin
    // Se reset for ativado, todos os registradores são zerados
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
