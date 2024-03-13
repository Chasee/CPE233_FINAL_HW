`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Create Date: 02/26/2024 08:07:28 AM
// Module Name: DCDR
//////////////////////////////////////////////////////////////////////////////////


module DCDR(
    input [6:0] OPCODE,
    input THIRTY,
    input BR_EQ,
    input BR_LT,
    input BR_LTU,
    input [2:0] FUNCT,
    output reg [3:0] ALU_FUN,
    output reg ALU_SRCA,
    output reg [1:0] ALU_SRCB,
    output reg [2:0] PCSOURCE,
    output reg [1:0] RF_WR_SEL
    );
    
    always_comb begin
    ALU_FUN = 4'b0;
    ALU_SRCA = 1'b0;
    ALU_SRCB = 2'b0;
    PCSOURCE = 2'b0;
    RF_WR_SEL = 2'b0;
    case(OPCODE)
        7'b0110011: begin //R-type
            ALU_SRCA = 1'b0;
            ALU_SRCB = 2'b0;
            PCSOURCE = 3'b0;
            RF_WR_SEL = 2'b11;
            ALU_FUN = {THIRTY, FUNCT}; end
            
        7'b0010011: begin //I-type
            ALU_SRCA = 1'b0;
            ALU_SRCB = 2'b01;
            PCSOURCE = 3'b0;
            RF_WR_SEL = 2'b11;
            case(FUNCT)  
                3'b101: ALU_FUN = {THIRTY, FUNCT}; 
                default: ALU_FUN = {1'b0, FUNCT}; 
            endcase end
            
        7'b1100011: begin //B-type
            ALU_SRCA = 1'b0;
            ALU_SRCB = 2'b0;
            PCSOURCE = 3'b010; //only this necessary
            RF_WR_SEL = 2'b11;
            ALU_FUN = {THIRTY, FUNCT}; 
            end
            
        7'b0110111: begin //U-type LUI
            ALU_SRCA = 1'b1;
            ALU_SRCB = 2'b0;
            PCSOURCE = 3'b000; //only this necessary
            RF_WR_SEL = 2'b11;
            ALU_FUN = 4'b1001; 
            end
endcase 
    
    end
endmodule
