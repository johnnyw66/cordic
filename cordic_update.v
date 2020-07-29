module cordic_update( input wire clk,
                      input wire signed [31:0] wantedAngle,
                      input wire [4:0] iterate,
                      input wire signed [31:0] x,
                      input wire signed [31:0] y,
                      input wire signed [31:0] currentAngle,
                      input wire signed [31:0] atan,

                      output reg signed [31:0] nx,
                      output reg signed [31:0] ny,
                      output reg signed [31:0] nangle);

                always @(posedge clk)
                begin
                      nx <= x - {dir ? -(y >>> iterate) : (y >>> iterate)};
                      ny <= y + {dir ? -(x >>> iterate) : (x >>> iterate)};
                      nangle <= currentAngle - {dir ? -atan : atan};

                end

              wire  [0:0] dir;
              assign dir = (currentAngle < wantedAngle) ;



endmodule
