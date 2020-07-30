`define _CALCSTEP(FREQ) ((0.0 + ((FREQ * FPMULT * SINEROMSIZE )/BOARD_CLOCKSPEED)))


module  frequency_generator #(parameter FPMULT = 65536, SINEROMSIZE = 1024) (clk, stepsize, sinevale);
  input  clk;
  input [15:0] stepsize ;
  output [15:0] sinevalue;

        reg [$clog2(FPMULT) + $clog2(SINEROMSIZE) - 1:0] fpaddress = 0;

        always @(posedge clk) begin
                fpaddress <= fpaddress + stepsize  ;
        end

        //wire [15:0] sromvalue ;
        //sineROM #(SINEROMSIZE) rom(.clk(clk),.address(fpaddress[23:16]),.svalue(sromvalue)) ;
        //assign sinevalue = gain[3] == 0 ? sromvalue<<gain : sromvalue>>(gain ^ 4'd15);
        cordic #(.WIDTH(32),.FPSHIFT(28)) cfq(.clk(clk),.angle(radianAngle),.cosine(cosine),.sine(sine),.finalAngle(finalAngle)) ;

endmodule
