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
wire [31:0] atan[0:30] ;
assign atan[00]  = 32'b0110010010000111111011010101000 ;
assign atan[01]  = 32'b0011101101011000110011100000101 ;
assign atan[02]  = 32'b0001111101011011011101011111100 ;
assign atan[03]  = 32'b0000111111101010110111010100110 ;
assign atan[04]  = 32'b0000011111111101010101101110110 ;
assign atan[05]  = 32'b0000001111111111101010101011011 ;
assign atan[06]  = 32'b0000000111111111111101010101010 ;
assign atan[07]  = 32'b0000000011111111111111101010101 ;
assign atan[08]  = 32'b0000000001111111111111111101010 ;
assign atan[09]  = 32'b0000000000111111111111111111101 ;
assign atan[10]  = 32'b0000000000011111111111111111111 ;
assign atan[11]  = 32'b0000000000001111111111111111111 ;
assign atan[12]  = 32'b0000000000000111111111111111111 ;
assign atan[13]  = 32'b0000000000000011111111111111111 ;
assign atan[14]  = 32'b0000000000000001111111111111111 ;
assign atan[15]  = 32'b0000000000000000111111111111111 ;
assign atan[16]  = 32'b0000000000000000011111111111111 ;
assign atan[17]  = 32'b0000000000000000001111111111111 ;
assign atan[18]  = 32'b0000000000000000000111111111111 ;
assign atan[19]  = 32'b0000000000000000000011111111111 ;
assign atan[20]  = 32'b0000000000000000000001111111111 ;
assign atan[21]  = 32'b0000000000000000000000111111111 ;
assign atan[22]  = 32'b0000000000000000000000011111111 ;
assign atan[23]  = 32'b0000000000000000000000001111111 ;
assign atan[24]  = 32'b0000000000000000000000000111111 ;
assign atan[25]  = 32'b0000000000000000000000000011111 ;
assign atan[26]  = 32'b0000000000000000000000000001111 ;
assign atan[27]  = 32'b0000000000000000000000000001000 ;
assign atan[28]  = 32'b0000000000000000000000000000100 ;
assign atan[29]  = 32'b0000000000000000000000000000010 ;
assign atan[30]  = 32'b0000000000000000000000000000001 ;

blinker #(24) blink1(.clk(CLK), .led(LED1)) ;
blinker #(22) blink2(.clk(CLK), .led(LED2)) ;
blinker #(25) blink3(.clk(CLK), .led(LED3)) ;
blinker #(26) blink4(.clk(CLK), .led(LED4)) ;
blinker #(27) blink5(.clk(CLK), .led(LED5)) ;
blinker #(23) blinkRED(.clk(CLK), .led(red) ) ;
blinker #(24) blinkGREEN(.clk(CLK), .led(green)) ;

assign LEDR_N =  BTN_N ? ~red : 1 ;
assign LEDG_N =  BTN_N ? ~green : 1;


generate
  genvar i ;

  for (i = 0 ; i < 31; i = i + 1)
    begin : gen1
      
  end
endgenerate

endmodule
