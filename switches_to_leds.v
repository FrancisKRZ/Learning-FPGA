`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
// 
// Create Date: 09/29/2024 02:34:35 PM
// Design Name: RM_CH1
// Module Name: switches_to_leds
// Project Name: 
// Target Devices: Basys 3 Artix-7
// Tool Versions: 2024.1
// Description: 
// 
// Dependencies: N/A
// 
// Revision: N/A
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// ---- Project 1 & 2 LED ----
// // Data Controller for the Switches to LEDs using Boolean Logic
// module led_and(input [15:0] sw, output [15:0] led);

//     assign led = sw[0] & sw[15] ? 16'hFFFF : 16'h0000; 

// endmodule

// // Top-Level Module (main) Integrating data component and data controller
// module switches_to_leds(input clk, rst, input [15:0] sw, output [15:0] led);

//     // data_controller instantiation
// //    data_controller DC ( .clk(clk), .rst(rst), .sw(sw), .led(led) );
//     led_and LA (.sw(sw), .led(led) );
    
//  endmodule


// ---- Project 4 Flip Flop LED ----
module LED_Toggle_TOP(input clk, input btnL, btnR, output [15:0] led);

    // Flip-Flops
    reg [7:0] left_led_status = 8'b0;
    reg [7:0] right_led_status = 8'b0;


    // Clock cycle(s)
    always @(posedge clk ) begin
        
        // btnL <= btnR;

        if (btnL == 1'b0 && btnR == 1'b1) begin

            left_led_status = ~left_led_status;
            right_led_status = ~right_led_status;
        end

    end

    assign led[15:8] = left_led_status;
    assign led[7:0] = right_led_status;


endmodule

