`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Create Date: 02/26/2024 08:07:28 AM
// Module Name: FSM
//////////////////////////////////////////////////////////////////////////////////


module FSM(
    input [6:0] OPCODE,
    input RST,
    output reg PCWRITE,
    output reg REGWRITE,
    output reg MEM_WE2,
    output reg MEM_RDEN1,
    output reg MEM_RDEN2,
    output reg RESET,
    input CLK
    );
    
    typedef enum {ST_INIT, ST_FETCH, ST_EX}STATES; //define states
    STATES NS, PS;
    
    always_ff @ (posedge CLK) begin
    if (RST)
        PS <= ST_INIT;
    else PS <= NS;
    end
    
    always_comb begin
        PCWRITE = 1'b0; 
        REGWRITE = 1'b0;
        MEM_WE2 = 1'b0;
        MEM_RDEN1 = 1'b0;
        MEM_RDEN2 = 1'b0;
        RESET = 1'b0;
        NS = ST_INIT;
        
        case(PS)
            ST_INIT: begin
            RESET = 1;
            NS = ST_FETCH;
            
            end
            
            ST_FETCH: begin
                RESET = 0; //think we have to do this?
                MEM_RDEN1 = 1;
                NS = ST_EX;
                REGWRITE = 1'b0; //worked until last reg reset to 0 before adding this 
            end
            
            ST_EX: begin
                case(OPCODE)
                    7'b0110011: begin //R-type
                        PCWRITE = 1;
                        REGWRITE = 1;
                        MEM_WE2 = 0;
                        MEM_RDEN1 = 0; //?
                        MEM_RDEN2 = 0; //?
                        NS = ST_FETCH;
                        end
                    7'b0010011: begin //I-type
                        PCWRITE = 1;
                        REGWRITE = 1;
                        MEM_WE2 = 0;
                        MEM_RDEN1 = 1; //?
                        MEM_RDEN2 = 0; //?
                        NS = ST_FETCH;

                    end
                    
                    7'b1100011: begin //B-type
                        PCWRITE = 1;
                        REGWRITE = 0; //switched from 1 to 0
                        MEM_WE2 = 0;
                        MEM_RDEN1 = 1; //switched from 0 to 1
                        MEM_RDEN2 = 0; //?
                        NS = ST_FETCH;

                    end
                    
                    7'b0110111: begin //u-type LUI
                        PCWRITE = 1;
                        REGWRITE = 1;
                        MEM_WE2 = 0;
                        MEM_RDEN1 = 1;
                        MEM_RDEN2 = 0; //?
                        NS = ST_FETCH;
                        end
                    //default: REGWRITE = 1'b0;
                endcase 
                end //end ST_EX
            endcase //end state cases
        end //end always comb
    endmodule
