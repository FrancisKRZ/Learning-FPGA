`timescale 1ns / 100ps


// Project 4.a ---- Debouncing a Switch
// In this project we'll be fixing the issue of 
// inconsistent LED states signal glitches.

// The 'Debounce Top' module will have
// SW -> [ <unfiltered glitches> -> [ 1) Debounce Switch] -> <filtered> -> [ 2) Previous project] ] -> LED

// Given our clock speed of 450 MHz, to be able to count 40 ns
// we'll have:  period / 40 = 20000000 
// as our wait time basis for our debounce filter.

// Debounce Module Top
module Debounce_TOP(input i_Clk, i_btnL, i_btnR, i_btnC, output [15:0] o_led);

    //wire w_Debounced_Switch;
    wire w_Debounced_btnL;
    wire w_Debounced_btnR;
    wire w_Debounced_btnC;

    // 1) Debounce Switch Left
    Debounce_Filter #(
        .DEBOUNCE_LIMIT(2250000)) 
        Debounce_Inst_L(
            .i_Clk(i_Clk), .i_Bouncy(i_btnL), .o_Debounced(w_Debounced_btnL)
        );

    // Debounce Switch Right
    Debounce_Filter #(
        .DEBOUNCE_LIMIT(2250000)) 
    Debounce_Inst_R(
        .i_Clk(i_Clk), .i_Bouncy(i_btnR), .o_Debounced(w_Debounced_btnR)
        );

    // Debounce Switch Center
    Debounce_Filter #(
        .DEBOUNCE_LIMIT(2250000))
        Debounce_Inst_C(
            .i_Clk(i_Clk), .i_Bouncy(i_btnC), .o_Debounced(w_Debounced_btnC)
        );


    // 2) Previous Project
    LED_Toggle_TOP LED_Toggle_Inst(
        .i_Clk(i_Clk),  
                        .i_btnL(w_Debounced_btnL), 
                        .i_btnR(w_Debounced_btnR), 
                        .i_btnC(w_Debounced_btnC), 
        .o_led(o_led)
        );

endmodule

// Debounce Filter Module
module Debounce_Filter #(
    // parameters
    parameter DEBOUNCE_LIMIT = 20) 
    (
    // ports
    input i_Clk, i_Bouncy, output o_Debounced
    );

    // Ceiling Log Base 2 $clog2
    // This allows to dynamically size the r_Count register
    // based on the input parameter, determining the number 
    // of binary digits needed to implement the counter.
    reg [$clog2(DEBOUNCE_LIMIT)-1:0] r_Count = 0;
    reg r_State = 1'b0;

    always @(posedge i_Clk) begin
        
        if (i_Bouncy !== r_State && r_Count < DEBOUNCE_LIMIT-1)
        begin
            r_Count <= r_Count + 1;
        end

        else if (r_Count == DEBOUNCE_LIMIT-1)
        begin
            r_State <= i_Bouncy;
            r_Count <= 0;
        end

        else
        begin
            r_Count <= 0;
        end

    end

    assign o_Debounced = r_State;
    
endmodule



module LED_Toggle_TOP(  input i_Clk, 
                        input i_btnL, i_btnR, i_btnC, 
                        output [15:0] o_led );

    // Flip-Flops
    reg [7:0] left_led_status = 8'hFF;
    reg [7:0] right_led_status = 8'hFF;


    // Clock cycle(s)
    always @(posedge i_Clk ) begin
        
        // Reset LED state
        if (i_btnC == 1'b1) begin
            left_led_status = 8'hFF;
            right_led_status = 8'hFF;
        end 

        // btnL >= btnR : Turn off left LEDs
        if (i_btnL == 1'b1 && i_btnR == 1'b0) begin
            left_led_status = ~left_led_status;
        end
        
        // btnL <= btnR : Turn off right LEDs
        else if (i_btnL == 1'b0 && i_btnR == 1'b1) begin
            right_led_status = ~right_led_status;    
        end

        // btnL === btnR : Swap < left <-> right > LEDs
        else if (i_btnL == 1'b1 && i_btnR == 1'b1) begin
            right_led_status = ~right_led_status;
            left_led_status = ~left_led_status;
        end

    end

    // If / After the loop ends, assign LED states
    assign o_led[15:8] = left_led_status;
    assign o_led[7:0] = right_led_status;


endmodule
