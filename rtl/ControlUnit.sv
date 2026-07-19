import alupkg::*;
module Control(
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic funct7b30, funct7b25,

    output logic regw,
    output logic alusrc,
    output logic memw,
    output logic [1:0] res_src, a_src,
    output logic branch, jump, jalr_flag,
    output alu_op_e alu_control
);
    always_comb begin
        regw = 0;
        alusrc = 0;
        memw = 0;
        res_src = 2'b00;
        a_src = 2'b00;
        branch = 0;
        jump = 0;
        jalr_flag = 0;
        alu_control = NONE;

        case(opcode)
            7'b0110011: begin  //R-Type instructions
                regw = 1;
                case(funct3)
                    3'b000: begin
                        if(funct7b25) alu_control = MUL;
                        else if(funct7b30) alu_control = SUB;
                        else alu_control = ADD;
                    end
                    3'b001: begin
                        if (funct7b25) alu_control = MULH;
                        else alu_control = SLL;
                    end
                    3'b010: begin
                        if (funct7b25) alu_control = MULHSU;
                        else alu_control = SLT;
                    end
                    3'b011: begin
                        if (funct7b25) alu_control = MULHU;
                        else alu_control = SLTU;
                    end
                    3'b100: begin
                        if (funct7b25) alu_control = DIV;
                        else alu_control = XOR;
                    end
                    3'b101: begin
                        if(funct7b25) alu_control = DIVU;
                        else if(funct7b30) alu_control = SRA;
                        else alu_control = SRL;
                    end
                    3'b110: begin
                        if (funct7b25) alu_control = REM;
                        else alu_control = OR;
                    end
                    3'b111: begin
                        if (funct7b25) alu_control = REMU;
                        else alu_control = AND;
                    end
                endcase
            end
            7'b0010011: begin  //I-Type instructions
                regw = 1;
                alusrc = 1;
                case(funct3)
                    3'b000: alu_control = ADD;
                    3'b001: alu_control = SLL;
                    3'b010: alu_control = SLT;
                    3'b011: alu_control = SLTU;
                    3'b100: alu_control = XOR;
                    3'b101: begin
                        if(funct7b30) alu_control = SRA;
                        else alu_control = SRL;
                    end
                    3'b110: alu_control = OR;
                    3'b111: alu_control = AND;
                endcase
            end
            7'b0000011: begin //L-type instructions
                regw = 1;
                alusrc = 1;
                res_src = 2'b01; 
                alu_control = ADD;
            end
            7'b0100011: begin //S-type instructions
                alusrc = 1;
                res_src = 2'b01;
                memw = 1;
                alu_control = ADD;
            end
            7'b1100011: begin //B-type instructions
                branch = 1;
                alu_control = SUB;
            end
            7'b1101111, 7'b1100111: begin //JAL and JALR
                jump = 1;
                regw = 1;
                res_src = 2'b10; 
                
                if (opcode == 7'b1100111) begin 
                    alusrc = 1;   
                    jalr_flag = 1; 
                    alu_control = ADD; 
                end else begin
                    jalr_flag = 0;
                end
            end
            7'b0110111: begin //LUI
                a_src = 2'b10;
                alusrc = 1;
                regw = 1;
                alu_control = ADD;
            end
            7'b0010111: begin //AUIPC
                a_src = 2'b01;
                alusrc = 1;
                alu_control = ADD;
                regw = 1;
            end
        endcase
    end
endmodule