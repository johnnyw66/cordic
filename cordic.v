
module  cordic  (
	input clk,
	input signed [WIDTH-1:0] angle,
	output signed [WIDTH-1:0] cosine,
	output signed [WIDTH-1:0] sine,
	output signed reg [WIDTH-1:0] finalAngle,
	output [1:0] currentQuad
);

parameter WIDTH = 32 ;
parameter FPSHIFT = 28 ;

wire [31:0] atan[0:30] ;
assign atan[00]  = 32'b0001100100100001111110110101010 ;
assign atan[01]  = 32'b0000111011010110001100111000001 ;
assign atan[02]  = 32'b0000011111010110110111010111111 ;
assign atan[03]  = 32'b0000001111111010101101110101001 ;
assign atan[04]  = 32'b0000000111111111010101011011101 ;
assign atan[05]  = 32'b0000000011111111111010101010110 ;
assign atan[06]  = 32'b0000000001111111111111010101010 ;
assign atan[07]  = 32'b0000000000111111111111111010101 ;
assign atan[08]  = 32'b0000000000011111111111111111010 ;
assign atan[09]  = 32'b0000000000001111111111111111111 ;
assign atan[10]  = 32'b0000000000000111111111111111111 ;
assign atan[11]  = 32'b0000000000000011111111111111111 ;
assign atan[12]  = 32'b0000000000000001111111111111111 ;
assign atan[13]  = 32'b0000000000000000111111111111111 ;
assign atan[14]  = 32'b0000000000000000011111111111111 ;
assign atan[15]  = 32'b0000000000000000001111111111111 ;
assign atan[16]  = 32'b0000000000000000000111111111111 ;
assign atan[17]  = 32'b0000000000000000000011111111111 ;
assign atan[18]  = 32'b0000000000000000000001111111111 ;
assign atan[19]  = 32'b0000000000000000000000111111111 ;
assign atan[20]  = 32'b0000000000000000000000011111111 ;
assign atan[21]  = 32'b0000000000000000000000001111111 ;
assign atan[22]  = 32'b0000000000000000000000000111111 ;
assign atan[23]  = 32'b0000000000000000000000000011111 ;
assign atan[24]  = 32'b0000000000000000000000000001111 ;
assign atan[25]  = 32'b0000000000000000000000000000111 ;
assign atan[26]  = 32'b0000000000000000000000000000011 ;
assign atan[27]  = 32'b0000000000000000000000000000010 ;
assign atan[28]  = 32'b0000000000000000000000000000001 ;
assign atan[29]  = 32'b0000000000000000000000000000000 ;
assign atan[30]  = 32'b0000000000000000000000000000000 ;




// Initialise Rotation
localparam finalGainFP = `_FP(0.6072529350088814,FPSHIFT) ;
localparam zeroFP = `_FP(0,FPSHIFT) ;


initial begin
	$display("begin") ;
end



wire [1:0] quad ;
wire  signed [31:0] vx,vy,startingAngle ;
wire signed [31:0] startVx, startVy ;


wire signed [31:0] startingAngles [3:0] ;
wire signed [31:0] startingVx [3:0] ;
wire signed [31:0] startingVy [3:0] ;

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
assign startingAngle = startingAngles[quad] ;
assign currentQuad = quad ;


wire signed [31:0] x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31 ;
wire signed [31:0] y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y20,y21,y22,y23,y24,y25,y26,y27,y28,y29,y30,y31 ;
wire signed [31:0] angle1,angle2,angle3,angle4,angle5,angle6,angle7,angle8,angle9,angle10,angle11,angle12,angle13,angle14,angle15,angle16,angle17,angle18,angle19,angle20,angle21,angle22,angle23,angle24,angle25,angle26,angle27,angle28,angle29,angle30,angle31 ;

cordic_update cu0 (.clk(clk), .wantedAngle(angle),.iterate(0), .x(startVx), .y(startVy), .currentAngle(startingAngle), .atan(atan[0]), .nangle(angle1), .nx(x1), .ny(y1)) ;
cordic_update cu1 (.clk(clk), .wantedAngle(angle),.iterate(1), .x(x1), .y(y1), .currentAngle(angle1), .atan(atan[1]), .nangle(angle2), .nx(x2), .ny(y2)) ;
cordic_update cu2 (.clk(clk), .wantedAngle(angle),.iterate(2), .x(x2), .y(y2), .currentAngle(angle2), .atan(atan[2]), .nangle(angle3), .nx(x3), .ny(y3)) ;
cordic_update cu3 (.clk(clk), .wantedAngle(angle),.iterate(3), .x(x3), .y(y3), .currentAngle(angle3), .atan(atan[3]), .nangle(angle4), .nx(x4), .ny(y4)) ;
cordic_update cu4 (.clk(clk), .wantedAngle(angle),.iterate(4), .x(x4), .y(y4), .currentAngle(angle4), .atan(atan[4]), .nangle(angle5), .nx(x5), .ny(y5)) ;
cordic_update cu5 (.clk(clk), .wantedAngle(angle),.iterate(5), .x(x5), .y(y5), .currentAngle(angle5), .atan(atan[5]), .nangle(angle6), .nx(x6), .ny(y6)) ;
cordic_update cu6 (.clk(clk), .wantedAngle(angle),.iterate(6), .x(x6), .y(y6), .currentAngle(angle6), .atan(atan[6]), .nangle(angle7), .nx(x7), .ny(y7)) ;
cordic_update cu7 (.clk(clk), .wantedAngle(angle),.iterate(7), .x(x7), .y(y7), .currentAngle(angle7), .atan(atan[7]), .nangle(angle8), .nx(x8), .ny(y8)) ;
cordic_update cu8 (.clk(clk), .wantedAngle(angle),.iterate(8), .x(x8), .y(y8), .currentAngle(angle8), .atan(atan[8]), .nangle(angle9), .nx(x9), .ny(y9)) ;
cordic_update cu9 (.clk(clk), .wantedAngle(angle),.iterate(9), .x(x9), .y(y9), .currentAngle(angle9), .atan(atan[9]), .nangle(angle10), .nx(x10), .ny(y10)) ;
cordic_update cu10 (.clk(clk), .wantedAngle(angle),.iterate(10), .x(x10), .y(y10), .currentAngle(angle10), .atan(atan[10]), .nangle(angle11), .nx(x11), .ny(y11)) ;
cordic_update cu11 (.clk(clk), .wantedAngle(angle),.iterate(11), .x(x11), .y(y11), .currentAngle(angle11), .atan(atan[11]), .nangle(angle12), .nx(x12), .ny(y12)) ;
cordic_update cu12 (.clk(clk), .wantedAngle(angle),.iterate(12), .x(x12), .y(y12), .currentAngle(angle12), .atan(atan[12]), .nangle(angle13), .nx(x13), .ny(y13)) ;
cordic_update cu13 (.clk(clk), .wantedAngle(angle),.iterate(13), .x(x13), .y(y13), .currentAngle(angle13), .atan(atan[13]), .nangle(angle14), .nx(x14), .ny(y14)) ;
cordic_update cu14 (.clk(clk), .wantedAngle(angle),.iterate(14), .x(x14), .y(y14), .currentAngle(angle14), .atan(atan[14]), .nangle(angle15), .nx(x15), .ny(y15)) ;
cordic_update cu15 (.clk(clk), .wantedAngle(angle),.iterate(15), .x(x15), .y(y15), .currentAngle(angle15), .atan(atan[15]), .nangle(angle16), .nx(x16), .ny(y16)) ;
cordic_update cu16 (.clk(clk), .wantedAngle(angle),.iterate(16), .x(x16), .y(y16), .currentAngle(angle16), .atan(atan[16]), .nangle(angle17), .nx(x17), .ny(y17)) ;
cordic_update cu17 (.clk(clk), .wantedAngle(angle),.iterate(17), .x(x17), .y(y17), .currentAngle(angle17), .atan(atan[17]), .nangle(angle18), .nx(x18), .ny(y18)) ;
cordic_update cu18 (.clk(clk), .wantedAngle(angle),.iterate(18), .x(x18), .y(y18), .currentAngle(angle18), .atan(atan[18]), .nangle(angle19), .nx(x19), .ny(y19)) ;
cordic_update cu19 (.clk(clk), .wantedAngle(angle),.iterate(19), .x(x19), .y(y19), .currentAngle(angle19), .atan(atan[19]), .nangle(angle20), .nx(x20), .ny(y20)) ;
cordic_update cu20 (.clk(clk), .wantedAngle(angle),.iterate(20), .x(x20), .y(y20), .currentAngle(angle20), .atan(atan[20]), .nangle(angle21), .nx(x21), .ny(y21)) ;
cordic_update cu21 (.clk(clk), .wantedAngle(angle),.iterate(21), .x(x21), .y(y21), .currentAngle(angle21), .atan(atan[21]), .nangle(angle22), .nx(x22), .ny(y22)) ;
cordic_update cu22 (.clk(clk), .wantedAngle(angle),.iterate(22), .x(x22), .y(y22), .currentAngle(angle22), .atan(atan[22]), .nangle(angle23), .nx(x23), .ny(y23)) ;
cordic_update cu23 (.clk(clk), .wantedAngle(angle),.iterate(23), .x(x23), .y(y23), .currentAngle(angle23), .atan(atan[23]), .nangle(angle24), .nx(x24), .ny(y24)) ;
cordic_update cu24 (.clk(clk), .wantedAngle(angle),.iterate(24), .x(x24), .y(y24), .currentAngle(angle24), .atan(atan[24]), .nangle(angle25), .nx(x25), .ny(y25)) ;
cordic_update cu25 (.clk(clk), .wantedAngle(angle),.iterate(25), .x(x25), .y(y25), .currentAngle(angle25), .atan(atan[25]), .nangle(angle26), .nx(x26), .ny(y26)) ;
cordic_update cu26 (.clk(clk), .wantedAngle(angle),.iterate(26), .x(x26), .y(y26), .currentAngle(angle26), .atan(atan[26]), .nangle(angle27), .nx(x27), .ny(y27)) ;
cordic_update cu27 (.clk(clk), .wantedAngle(angle),.iterate(27), .x(x27), .y(y27), .currentAngle(angle27), .atan(atan[27]), .nangle(angle28), .nx(x28), .ny(y28)) ;
cordic_update cu28 (.clk(clk), .wantedAngle(angle),.iterate(28), .x(x28), .y(y28), .currentAngle(angle28), .atan(atan[28]), .nangle(angle29), .nx(x29), .ny(y29)) ;
cordic_update cu29 (.clk(clk), .wantedAngle(angle),.iterate(29), .x(x29), .y(y29), .currentAngle(angle29), .atan(atan[29]), .nangle(angle30), .nx(x30), .ny(y30)) ;
cordic_update cu30 (.clk(clk), .wantedAngle(angle),.iterate(30), .x(x30), .y(y30), .currentAngle(angle30), .atan(atan[30]), .nangle(angle31), .nx(x31), .ny(y31)) ;

always @(posedge clk)
begin
	sine <= x31 ;
	cosine <= y31 ;
	finalAngle <= angle31  ;
end


endmodule
