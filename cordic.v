
module cordic (
	input clk,
	input angle,
	output sine,
	output cosine
);

parameter WIDTH = 32 ;

wire [4:0] tan[31:0] ;
assign tan[0] = 0 ;
assign tan[1] = 0 ;
assign tan[2] = 0 ;
assign tan[5] = 0 ;

generate
  genvar i ;

  for (i = 0 ; i < 32; i = i + 1)
    begin : gen1

  end
endgenerate

assign sine = tan[0] ;
assign cosine = tan[0] ;

endmodule
