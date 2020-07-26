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

	output P1A1,
  output P1A2,
  output P1A3,
  output P1A4,

	output P1A7,
	output P1A8,
	output P1A9,
  output P1A10,
  output P1B1,
  output P1B2,
  output P1B3,
  output P1B4,

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

//localparam FPSHIFT = 30 ;

`define _FP(_val, _shift) (_val * (1 <<< _shift))

wire red, green ;

blinker #(24) blink1(.clk(CLK), .led(LED1)) ;
blinker #(22) blink2(.clk(CLK), .led(LED2)) ;
blinker #(25) blink3(.clk(CLK), .led(LED3)) ;
blinker #(26) blink4(.clk(CLK), .led(LED4)) ;
blinker #(27) blink5(.clk(CLK), .led(LED5)) ;
blinker #(23) blinkRED(.clk(CLK), .led(red) ) ;
blinker #(24) blinkGREEN(.clk(CLK), .led(green)) ;

assign LEDR_N =  BTN_N ? ~red : 1 ;
assign LEDG_N =  BTN_N ? ~green : 1;

reg [20:0] counter ;
reg [15:0] hcounter ;

always @(posedge CLK)
begin
  counter <= counter + 1 ;
  if (counter == 0)
  begin
    hcounter <= hcounter + 1 ;
  end
end


wire [3:0] digitsel ;
wire [6:0] _7seg ;
wire signed [31:0] angle ;
wire signed [31:0] cosine ;
wire signed [31:0] sine ;

assign angle = `_FP(272,8) ;

cordic #(8) c1(.clk(CLK),.angle(angle),.cosine(cosine),.sine(sine)) ;

hexdisplay segdisplay(.clk(CLK), .value(sine), .enable(1), .segment(_7seg),.omask(digitsel)) ;

//assign lvalue = 16'habcd ;

assign {P1B1, P1B2, P1B3, P1B4} = {digitsel[0], digitsel[1], digitsel[2], digitsel[3]} ;
assign {P1A1, P1A2, P1A3, P1A4, P1A7, P1A8, P1A9} =  _7seg[6:0] ;

endmodule
