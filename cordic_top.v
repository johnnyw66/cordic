/*
 *
 */

`default_nettype none

module top (
	input  CLK,
	input RX,
	output TX,
	output LEDR_N,
	output LEDG_N,

	output P1A1,  // AUDIO
	output P1A4,  // AudioL
	output P1A7,  // LATCH
	input  P1A8,  // GPD1
	input  P1A9,  // GPD3

  input BTN_N,
  input BTN1,
  input BTN2,
  input BTN3,

	output LED1,
	output LED2,
	output LED3,
	output LED4,
	output LED5
);

wire red,green ;

blinker #(24) blink1(.clk(CLK), .led(LED1)) ;
blinker #(22) blink2(.clk(CLK), .led(LED2)) ;
blinker #(25) blink3(.clk(CLK), .led(LED3)) ;
blinker #(26) blink4(.clk(CLK), .led(LED4)) ;
blinker #(27) blink5(.clk(CLK), .led(LED5)) ;
blinker #(23) blinkRED(.clk(CLK), .led(red) ) ;
blinker #(24) blinkGREEN(.clk(CLK), .led(green)) ;

assign LEDR_N =  BTN_N ? ~red : 1 ;
assign LEDG_N =  BTN_N ? ~green : 1;


endmodule
