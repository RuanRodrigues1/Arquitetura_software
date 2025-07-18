//Unidade de controle, pegando os bits mais significativos para identificar instrucoes

module ctrl(

	input[31:0] instrucao, //vetor de bits do op, vai receber a instrucao
	output reg RegDest,
	output reg Branch,
	output reg MemRead,
	output reg[1:0] MemToReg, // 2 bits para escrever no pc no caso de tipo j
	output reg[1:0] ALUOp,
	output reg MemWrite,
	output reg ALUSrc,
	output reg RegWrite,
	output reg Jump,	//sinal para tipo j
   	output reg Jal_Dest //sinal para tipo j


);

	wire[5:0] opcode; //conjunto de 6 fios para opcode

	assign opcode = instrucao[31:26]; // atribui os fios aos bits do op code

	always@(opcode) begin // cria um bloco que muda sempre que o opcode mudar

		RegDest = 1'b0;   //numero binario de tamanho 1, 1 bit
		Branch = 1'b0;
		MemRead = 1'b0;
		MemToReg = 2'b00;
		ALUOp = 2'b00;
		MemWrite = 1'b0;
		ALUSrc = 1'b0;
		RegWrite = 1'b0;
		Jump = 1'b0;  
		Jal_Dest = 1'b0;
		
		//todos os valores declarados acima
		
		case(opcode) //switch para identificar as instrucoes
		
		// instrucoes tipo R, op 0
		
			6'b000000: begin 
				RegDest = 1'b1;
				RegWrite = 1'b1;
				ALUOp = 2'b10; //ULA deve acessar o funct
			
			end
			
			//lw
			
			6'b100011: begin 
				RegWrite = 1'b1;
				MemRead = 1'b1;
				MemToReg = 2'b01;
				ALUSrc = 1'b1;
				ALUOp = 2'b00; //Soma
				
			end
			
			//sw
			
			6'b101011: begin
				MemWrite = 1'b1;
				ALUSrc = 1'b1;
				ALUOp = 2'b00; //Soma
				
			end
			
			//beq
			
			6'b000100: begin 
				Branch = 1'b1;
				ALUOp = 2'b01; //subtracao
				
			end
			
			//jump
			
			6'b000010: begin
				Jump = 1'b1;
				
			end
			
			//jal
			
			6'b000011: begin
				Jump = 1'b1;
				RegWrite = 1'b1;
				MemToReg = 2'b10;
				Jal_Dest = 1'b1; //deve habilitar o pc+4 em $ra pra voltar depois
				
			end
			
			default: begin
				
				RegDest = 1'b0;   //muda nada, mantem
				Branch = 1'b0;
				MemRead = 1'b0;
				MemToReg = 2'b00;
				ALUOp = 2'b00;
				MemWrite = 1'b0;
				ALUSrc = 1'b0;
				RegWrite = 1'b0;
				Jump = 1'b0;  
				Jal_Dest = 1'b0;
			end
			
		endcase
		
	end
	
endmodule
