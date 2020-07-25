module  blinker (

        output led,
        input clk
);

parameter WIDTH = 32 ;

reg [WIDTH - 1 : 0] counter ;

always @(posedge clk) begin
  counter <= counter + 1;
end

assign led = counter[WIDTH - 1] ;

endmodule
