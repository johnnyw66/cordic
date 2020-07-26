//  x x x 3 x x 0 x x				
//  2 e d a f c g b 1
// letters = 7 segment display (active high)
// numbers = digit select (active low)


`define _Bseg 7'd1
`define _Gseg 7'd2
`define _Cseg 7'd4
`define _Fseg 7'd8
`define _Aseg 7'd16
`define _Dseg 7'd32
`define _Eseg 7'd64

`define DIGIT0	(`_Aseg | `_Bseg | `_Cseg | `_Dseg | `_Eseg | `_Fseg)
`define DIGIT1	(`_Bseg | `_Cseg)
`define DIGIT2	(`_Aseg | `_Bseg | `_Dseg | `_Eseg | `_Gseg)
`define DIGIT3	(`_Aseg | `_Bseg | `_Cseg | `_Dseg | `_Gseg)
`define DIGIT4	(`_Bseg | `_Cseg | `_Fseg | `_Gseg)
`define DIGIT5	(`_Aseg | `_Fseg | `_Gseg | `_Cseg | `_Dseg)
`define DIGIT6	(`_Aseg | `_Cseg | `_Dseg | `_Eseg | `_Fseg | `_Gseg)
`define DIGIT7	(`_Aseg | `_Bseg | `_Cseg )
`define DIGIT8	(`_Aseg | `_Bseg | `_Cseg | `_Dseg | `_Eseg | `_Fseg | `_Gseg)
`define DIGIT9	(`_Aseg | `_Bseg | `_Cseg | `_Dseg | `_Fseg | `_Gseg)
`define DIGITA	(`_Aseg | `_Bseg | `_Cseg | `_Eseg | `_Fseg | `_Gseg)
`define DIGITB	(`_Cseg | `_Dseg | `_Eseg | `_Fseg | `_Gseg)
`define DIGITC	(`_Aseg | `_Dseg | `_Eseg | `_Fseg)
`define DIGITD	(`_Bseg | `_Cseg | `_Dseg | `_Eseg | `_Gseg)
`define DIGITE	(`_Aseg |  `_Eseg | `_Dseg | `_Fseg | `_Gseg)
`define DIGITF	(`_Aseg |  `_Eseg | `_Fseg | `_Gseg)

module hexseg
(
 input [3:0] value,
 input enable,
 output reg [6:0] segment  
);


always @(value,enable)
begin
		if (enable) begin
		
			case (value)
					4'd0: segment = `DIGIT0 ;
					4'd1: segment = `DIGIT1 ;
					4'd2: segment = `DIGIT2 ;
					4'd3: segment = `DIGIT3 ;
					4'd4: segment = `DIGIT4 ;
					4'd5: segment = `DIGIT5 ;
					4'd6: segment = `DIGIT6 ;
					4'd7: segment = `DIGIT7 ;
					4'd8: segment = `DIGIT8 ;
					4'd9: segment = `DIGIT9 ;
					4'd10: segment = `DIGITA ;
					4'd11: segment = `DIGITB ;
					4'd12: segment = `DIGITC ;
					4'd13: segment = `DIGITD ;
					4'd14: segment = `DIGITE ;
					4'd15: segment = `DIGITF ;
			endcase
		end
	else
		segment = 7'd0 ;

end


endmodule
