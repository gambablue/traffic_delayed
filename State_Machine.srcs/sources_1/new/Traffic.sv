`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2024 05:28:25 PM
// Design Name: 
// Module Name: Traffic
// Project Name: 
// Target Device7888888888888s:^^^^^^^^^^^^^
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Traffic
(
    input logic clk,
    input logic rst,
//    input logic TA, // traffic on A or on B
//    input logic TB, // traffic on B
    input logic TAORB, // traffic on A = 1 or on B =0 
    output reg [5:0] led //light bits 
);
 //   typedef enum (s0,s1,s2,s3) state_t;
  //  int TIMER=0;
    typedef enum bit [1:0] {
        GREENRED = 2'b00,
        YELLOWRED = 2'b01,
        REDGREEN = 2'b10,
        REDYELLOW = 2'b11
    } state_t;
    
    state_t state_reg, state_next;
    reg [3:0] TIMER; 
    reg val = 0;
    always_ff @(posedge clk, posedge rst) 
        if (rst) state_reg <= GREENRED;
        else begin
            state_reg <= state_next;
            // TIMER <= TIMER+1;
            val <= val ^ 1;
        end
 
    always_ff @(posedge clk) 
        case (state_reg)
           GREENRED :  if (~TAORB) TIMER = 0;
           YELLOWRED : if (TIMER<5)  TIMER <= TIMER+1;
                      // else TIMER = 0;
            REDGREEN : if (~TAORB) TIMER <= 0;
                       else TIMER <= TIMER+1;
            REDYELLOW : if (TIMER<5) TIMER <= TIMER+1;
                        // else TIMER = 0;           
         endcase
 
    always_comb begin
//        led[5] <= val;  
//        led[4] <= val ;
//        led[3] <= val;
//        led[2] <= val;
//        led[1] <= val;          
        state_next = state_reg;
        led = 6'b001100;  // red yellow green - red yellow green
        case (state_reg)
           GREENRED :  if (TAORB)  state_next = GREENRED;
                       else begin
                            state_next = YELLOWRED;
                            //TIMER <= 0;
                            led  = 6'b010100;
                       end
           YELLOWRED : if (TIMER<5) begin 
                            state_next = YELLOWRED;
                            //TIMER <= TIMER+1;
                            led = 6'b010100;
                       end
                       else begin
                            state_next = REDGREEN;
                       //     TIMER <= 0;
                            led = 6'b100001;
                       end
            REDGREEN : if (~TAORB) begin 
                            state_next = REDGREEN;
                            //TIMER <= 0;
                            led = 6'b100001;
                        end
                        else begin
                            state_next = REDYELLOW;
                            //TIMER <= TIMER+1;
                            led = 6'b100010;
                        end
            REDYELLOW : if (TIMER<5)begin
                            state_next = REDYELLOW;
                            //TIMER <= TIMER+1;
                            led = 6'b100010;
                        end
                        else begin
                            if (TIMER>=5) state_next = GREENRED;
                         //   TIMER <= 0;
                            led = 6'b001100;               
                        end
             endcase
    end
endmodule