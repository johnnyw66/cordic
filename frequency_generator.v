`define _CALCSTEP(_FREQ, _CIRCLEBITSIZE, _BOARD_CLOCKSPEED) ((0.0 + ((_FREQ * (1<<16) * (1 << _CIRCLEBITSIZE) )/_BOARD_CLOCKSPEED)))


module  frequency_generator #(parameter FPS = 16, CIRCLEBITSIZE = 10) (clk, stepsize, sinevalue);
  input  clk;
  input [15:0] stepsize ;
  output signed [31:0] sinevalue;

  reg signed [31:0] cosine ;
  reg signed [31:0] finalAngle ;
  reg  [31:0] radianAngle ;

  reg [FPS + CIRCLEBITSIZE - 1:0] fpaddress = 0;

  always @(posedge clk) begin
    fpaddress <= fpaddress + stepsize  ;
    radianAngle <= fpaddress[23:16] ;
  end

//  assign radianAngle = fpaddress[23:16] ;

  cordic #(.WIDTH(32),.FPSHIFT(28)) cfq(.clk(clk),.angle(radianAngle),.cosine(cosine),.sine(sinevalue),.finalAngle(finalAngle)) ;

endmodule
