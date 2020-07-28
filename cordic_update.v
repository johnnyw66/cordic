module cordic_update (input wire clk,
                      input wire signed [5:0]  iterate,
                      input wire signed [31:0] x,
                      input wire signed [31:0] y,
                      input wire signed [31:0] z,
                      input wire signed [31:0] atan,
                      output reg signed [31:0] x_next,
                      output reg signed [31:0] y_next,
                      output reg signed [31:0] z_next);

                //always @(posedge clk)
                //begin
                      //x_next <= x - {z < 0 ? -(y >>> iterate) : (y >>> iterate)};
                      //y_next <= y + {z < 0 ? -(x >>> iterate) : (x >>> iterate)};
                      //z_next <= z - {z < 0 ? -atan : atan};
                //end

  assign x_next = x - {z < 0 ? -(y >>> iterate) : (y >>> iterate)};
  assign y_next = y + {z < 0 ? -(x >>> iterate) : (x >>> iterate)};
  assign z_next = z - {z < 0 ? -atan : atan};

endmodule
