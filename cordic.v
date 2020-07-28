
module  cordic  (
	input clk,
	input signed [WIDTH-1:0] angle,
	output signed [WIDTH-1:0] cosine,
	output signed [WIDTH-1:0] sine,
	output signed [WIDTH-1:0] finalAngle,
	output [1:0] currentQuad
);

parameter WIDTH = 32 ;
parameter FPSHIFT = 10 ;

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




// Initialise Rotation
localparam finalGainFP = `_FP(0.6072529350088814,FPSHIFT) ;
localparam zeroFP = `_FP(0,FPSHIFT) ;


initial begin
	$display("begin") ;
end



wire [1:0] quad ;
wire  signed [15:0] vx,vy,startingAngle ;

wire [31:0] startingAngles [3:0] ;
wire [31:0] startingVx [3:0] ;
wire [31:0] startingVy [3:0] ;

assign quad = (angle > `_FP(`_DEG2RADIANS(270),FPSHIFT) ? 2'd3 : (angle > `_FP(`_DEG2RADIANS(180),FPSHIFT) ? 2'd2 : (angle > `_FP(`_DEG2RADIANS(90),FPSHIFT) ? 2'd1 : 2'd0))) ;

// starting Angle depends on quad of required angle

assign startingAngles[0] = `_FP(`_DEG2RADIANS(0), FPSHIFT) ;
assign startingAngles[1] = `_FP(`_DEG2RADIANS(90), FPSHIFT) ;
assign startingAngles[2] = `_FP(`_DEG2RADIANS(180), FPSHIFT) ;
assign startingAngles[3] = `_FP(`_DEG2RADIANS(270), FPSHIFT) ;

//assign vx = (quad == 2'd2 || quad == 2'd0)  ? zeroFP : (quad == 2'd3 ? -finalGainFP : finalGainFP) ;
//assign vy = (quad == 2'd3 || quad == 2'd1)  ? zeroFP : (quad == 2'd2 ? -finalGainFP : finalGainFP) ;

assign startingVx[0] = zeroFP ;
assign startingVx[1] = finalGainFP ;
assign startingVx[2] = zeroFP;
assign startingVx[3] = -finalGainFP ;

assign startingVy[0] = finalGainFP ;
assign startingVy[1] = zeroFP ;
assign startingVy[2] = -finalGainFP;
assign startingVy[3] = zeroFP ;

assign startVx = startingVx[quad] ;
assign startVy = startingVy[quad] ;



//cordic_update(.vx(startVx), .vy(startVy),.atan(atan[0]),.currentAngle(startingAngle), .nTheta(nAngle),.nx(nx), .ny(ny)) ;
//cordic_update(.vx(nx), .vy(ny),.atan(atan[1]),.currentAngle(nAngle), .nTheta(nAngle),.nx(nx), .ny(ny)) ;



//assign sine = sVx[quad] ;
//assign cosine = sVy[quad] ;
//assign finalAngle = 0 ;

assign currentQuad = quad ;
assign sine = startingVx[quad] ;
assign cosine = startingVy[quad] ;
assign startingAngle = startingAngles[quad] ;
assign finalAngle = startingAngle ;

endmodule
