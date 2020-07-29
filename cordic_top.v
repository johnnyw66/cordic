/*
 *
 */
`default_nettype none

module top (
	input  CLK,
	output LEDR_N,
	output LEDG_N,

	output P1A1,
  output P1A2,
  output P1A3,
  output P1A4,

	output P1A7,
	output P1A8,
	output P1A9,
//  output P1A10,

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

localparam WIDTH = 32 ;
localparam FPSHIFT = 28 ;

`define _FP(_val, _shift) (_val * (1 <<< _shift))
`define _UFP(_val, _shift) (_val >>> _shift)
`define _DEG2RADIANS(_deg) (_deg * 3.1415926535 / 180.0)
`define _RADIANS2DEG(_rad) (_rad * 180.0 /  3.1415926535)

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
wire signed [WIDTH - 1:0] angle1degrad ;

reg signed [WIDTH - 1:0] anglerad ;
reg signed [WIDTH - 1:0] cosine ;
reg signed [WIDTH - 1:0] sine ;
reg signed [WIDTH - 1:0] finalAngle ;
reg [1:0] currentQuad ;
reg [14:0] radcounter ;

assign angle1degrad =  `_FP(`_DEG2RADIANS(1),FPSHIFT) ;
//assign anglerad = `_FP(`_DEG2RADIANS(45),FPSHIFT) ;


  always @(posedge CLK)
  begin
    radcounter <= radcounter + 1 ;
    if (radcounter == 0)
    begin
      anglerad <= anglerad + angle1degrad ;
      if (anglerad > `_FP(`_DEG2RADIANS(360),FPSHIFT))
        begin
        anglerad <= 0 ;
      end
    end
  end

cordic #(.WIDTH(32),.FPSHIFT(28)) c1(.clk(CLK),.angle(anglerad),.cosine(cosine),.sine(sine),.finalAngle(finalAngle),.currentQuad(currentQuad)) ;

wire [0:0] dir ;
assign dir = (2 > 3) ;

hexdisplay segdisplay(.clk(CLK), .value(anglerad), .enable(1), .segment(_7seg),.omask(digitsel)) ;

//assign lvalue = 16'habcd ;

assign {P1B1, P1B2, P1B3, P1B4} = {digitsel[0], digitsel[1], digitsel[2], digitsel[3]} ;
assign {P1A1, P1A2, P1A3, P1A4, P1A7, P1A8, P1A9} =  _7seg[6:0] ;

endmodule
