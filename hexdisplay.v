//  x x x 3 x x 0 x x				
//  2 e d a f c g b 1
// letters = 7 segment display (active high)
// numbers = digit select (active low)
module hexdisplay
(
 input clk,
 input [15:0] value,
 input enable,
 output [6:0] segment,
 output [3:0] omask
);

reg [15:0] counter ;
reg [1:0] digit ;

always @(posedge clk)
begin
	counter <= counter + 16'd1 ;
	if (counter == 0)
	begin
		digit <= digit + 2'd1 ;
	end
end

assign omask = digit == 0 ? 4'b1110 : 
						digit == 1 ? 4'b1101 : 
							digit == 2 ? 4'b1011 : 
							4'b0111 ;

						
hexseg seg0(.value(
						digit == 0 ? value[3:0] : 
							digit == 1 ? value[7:4] : 
								digit == 2 ? value[11:8] : value[15:12]
						),
						.enable(enable),
						.segment(segment)) ;


endmodule
