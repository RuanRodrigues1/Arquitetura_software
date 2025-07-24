/*
PROJETO: Processador MIPS Monociclo

AUTORES: DAVI PIRES, JUAN PABOLLO, VITHOR DE CASTRO, RUAN RODRIGUES

DISCIPLINA: Arquitetura e Organização de Computadores

SEMESTRE: 2025.1

ARQUIVO: mips_processor.v (Módulo Top-Level)
*/

module mips_processor(
    input wire clock,
    input wire reset,
	 output wire [31:0] ula_result_out, d_mem_read_out, current_pc_value_out // saidas
);

    //sinais de dados

    wire [31:0] pc_current, pc_next, pc_plus_4; // dados do PC
    wire [31:0] instruction; // instrucao
    wire [31:0] read_data_1, read_data_2; // dados lidos do registrador
	 wire [31:0] sign_extended_immediate, zero_extended_immediate, extended_immediate; // imediato extendido para 32 bits
	 wire [31:0] alu_in_1, alu_in_2, alu_result; // entradas + saida principal da ula
    wire [31:0] mem_read_data, write_back_data; // dado lido / dado a ser escrito
    wire [31:0] jump_address, branch_address, branch_address_offset; // endereco de jump / endereco da branch + offset da branch
    wire [4:0]  write_reg_addr, final_write_reg_addr; // onde o dado sera escrito no regfile
    wire [31:0] pc_next_temp, pc_next_jal; // pc_next temporarios
	 wire [31:0] data_to_reg_temp, data_to_reg_final; // dado a ser escrito (temporario), sera decidido com um mux em caso de JAL

	 //sinais de controle
    wire        reg_dest, branch, mem_read, mem_to_reg, mem_write;
	 wire [1:0]  alu_src;
    wire        reg_write, jump, jal_dest, jr_sel;
    wire [2:0]  alu_op; // tipo de operacao, recebido pela unidade de controle da ULA
    wire [3:0]  alu_control; // operacao a ser feita na ULA
    wire        zero_flag;
    wire        pc_src; // flag, define se PC recebe branch ou pc + 4
	 
	 assign pc_plus_4 = pc_current + 4;

   //selecao do endereco do PC, pc+4 ou branch
    assign pc_src = (alu_op == 3'b011) ? branch & ~zero_flag : branch & zero_flag; // Branch BNE / BEQ
	 
    assign branch_address = pc_plus_4 + branch_address_offset; // endereco da branch = proximo endereco + offset
	 
    assign pc_next_temp = pc_src ? branch_address : pc_plus_4; // proximo pc (temp/auxiliar), recebe branch ou pc + 4
    
    // jump
    assign jump_address = jr_sel ? read_data_1 : {pc_plus_4[31:28], instruction[25:0], 2'b00}; // em caso de jump, em caso de jr recebe dado lido, senao endereco da instrucao
	 
	 assign pc_next = jump ? jump_address : pc_next_temp; // se flag jump for ativada, pc_next recebe jump

    // pc inst
    PC pc_unit ( .clock(clock), .reset(reset), .next_PC(pc_next), .PC(pc_current) );
	 
	 assign current_pc_value_out = pc_current;
    
    // somador do pc+4
    //somador_PC_4 pc_adder ( .PC(pc_current), .somador_out(pc_plus_4) );
    
    // memoria de instrucoes
    i_mem instruction_memory ( .pc_adress(pc_current), .inst_out(instruction) );


    // sinais para o controle
    ctrl control_unit (
        .instrucao(instruction), .RegDest(reg_dest), .Branch(branch), .MemRead(mem_read),
        .MemToReg(mem_to_reg), .ALUOp(alu_op), .MemWrite(mem_write), .ALUSrc(alu_src),
        .RegWrite(reg_write), .Jump(jump), .Jal_Dest(jal_dest), .jr_sel(jr_sel)
    );

    //MUX: Define se dado sera escrito no rt ou no rd (intrucoes tipo R, ou I)
    mux2x1 reg_dest_mux( .entrada0(instruction[20:16]), .entrada1(instruction[15:11]), .seletor(reg_dest), .saida(write_reg_addr) );
	 
    //MUX: define se dado sera escrito no rt/rd (conforme mux anterior), ou no $ra em caso de JAL
    mux2x1 jal_dest_mux( .entrada0(write_reg_addr), .entrada1(5'b11111), .seletor(jal_dest), .saida(final_write_reg_addr) );

    // banco de registradores
    regfile register_file (
        .clock(clock), .reset(reset), .RegWrite(reg_write), .ReadAddr1(instruction[25:21]),
        .ReadAddr2(instruction[20:16]), .WriteAddr(final_write_reg_addr), .WriteData(write_back_data),
        .ReadData1(read_data_1), .ReadData2(read_data_2)
    );
    
    // extensor de sinal
    extensor_de_sinal sign_extender ( .imediato(instruction[15:0]), .extensor_out(sign_extended_immediate) );
	 
	 assign zero_extended_immediate = {16'b0, instruction[15:0]};
	 
	 assign extended_immediate = (alu_op == 3'b100) ? zero_extended_immediate : sign_extended_immediate; // ALUOp 100 usa extensor zero (ORI...)
	 
	 
	 // Unidade de controle da ULA, decide a operacao a ser realizada na ULA
	 ULA_CTRL ula_control ( .ALUOp (alu_op), .func(instruction[5:0]), .ula_op_out(alu_control) );

	 wire [31:0] shamt_extended = {27'b0, instruction[10:6]}; // Shamt extendido para 32 bits

    // MUX para a primeira entrada da ULA
    assign alu_in_1 = (alu_src == 2'b10) ? read_data_2:// Casos especificos (SLL, SRA...), usa rt (read_data_2)
							 (alu_src == 2'b11) ? read_data_2:
														 read_data_1;

    // MUX para a segunda entrada da ULA
    assign alu_in_2 = (alu_src == 2'b00) ? read_data_2: // Instrucoes gerais tipo R
							 (alu_src == 2'b11) ? read_data_1: // Especifico para Shift Logical Variable, inverte in_1 com in_2
							 (alu_src == 2'b01) ? extended_immediate : // Instrucoes tipo I
							 shamt_extended; // Caso especifico para usar shamt (SLL, SRA...)
	 
    //instancia da ula
    ULA alu ( .in1(alu_in_1), .in2(alu_in_2), .OP(alu_control), .result(alu_result), .Zero_flag(zero_flag) );
	 
	 assign ula_result_out = alu_result; // saida do processador
    
    // Shift left 2 (Multiplica imediato por 4 para calcular offset da branch)
	 assign branch_address_offset = extended_immediate << 2;


    // data memory
    d_mem data_memory (
        .clock(clock), .MemWrite(mem_write), .MemRead(mem_read),
        .Address(alu_result), .WriteData(read_data_2), .ReadData(mem_read_data)
    );
	 
	assign d_mem_read_out = mem_read_data; // saida do processador

        
    // salvar PC + 4
	assign pc_next_jal = pc_plus_4;
	
    // mux que seleciona o que sera escrito entre a memoria lida, e o resultado da ULA
	assign data_to_reg_temp = mem_to_reg ? mem_read_data : alu_result;
	
	// Caso especial de LUI
   assign data_to_reg_final = (alu_op == 3'b111) ? {instruction[15:0], 16'b0} : data_to_reg_temp;
	
   // mux para jal, define se escreve o dado do mux anterior, ou PC + 4 caso chame JAL
	assign write_back_data = jal_dest ? pc_next_jal : data_to_reg_final;

endmodule