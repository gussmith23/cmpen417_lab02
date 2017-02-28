module testbench
#(
  parameter PART1_CYCLES = 6,
  parameter PART2_CYCLES = 2,
  parameter PERIOD = 4,
  parameter MAX_RAND = 10
);

  reg signed [17:0] A1, a1, B1, b1;
  reg signed [17:0] A2, a2, B2, b2;
  wire signed [35:0] re1, im1, re2, im2;
  reg clk;

  // calculates (A+a*i)*(B+b*i) = re + im*i
  part1 p1(clk,A1,a1,B1,b1,re1,im1);
  part2 p2(clk,A2,a2,B2,b2,re2,im2);

  initial clk = 0;
  always #(PERIOD/2) clk = ~clk;
  initial #1000 $finish();

  reg signed [27:0] A1_var, a1_var, B1_var, b1_var, A2_var, a2_var, B2_var, b2_var;
  reg signed [35:0] re1_expect, im1_expect, re2_expect, im2_expect;

  always #100 begin
    A1_var = $random % MAX_RAND;
    a1_var = $random % MAX_RAND;
    B1_var = $random % MAX_RAND;
    b1_var = $random % MAX_RAND;
    A2_var = $random % MAX_RAND;
    a2_var = $random % MAX_RAND;
    B2_var = $random % MAX_RAND;
    b2_var = $random % MAX_RAND;
    re1_expect = (A1_var*B1_var - a1_var*b1_var);
    im1_expect = (A1_var*b1_var + a1_var*B1_var);
    re2_expect = (A2_var*B2_var - a2_var*b2_var);
    im2_expect = (A2_var*b2_var + a2_var*B2_var);
  end

  always @ (A1_var, a1_var, B1_var, b1_var) begin
    A1 <= A1_var;
    a1 <= a1_var;
    B1 <= B1_var;
    b1 <= b1_var;
  end

  always @ (A2_var, a2_var, B2_var, b2_var) begin
    A2 <= A2_var;
    a2 <= a2_var;
    B2 <= B2_var;
    b2 <= b2_var;
  end

  always @ (A1_var, a1_var, B1_var, b1_var) begin
    #(PART1_CYCLES*PERIOD);
    if (re1 != re1_expect) $display("ERROR: Part 1: %d != %d", re1, re1_expect); 
    if (im1 != im1_expect) $display("ERROR: Part 1: %d != %d", im1, im1_expect); 
  end

  always @ (A2_var, a2_var, B2_var, b2_var) begin
    #(PART2_CYCLES*PERIOD);
    if (re2 != re2_expect) $display("ERROR: Part 2: %d != %d", re2, re2_expect); 
    if (im2 != im2_expect) $display("ERROR: Part 2: %d != %d", im2, im2_expect); 
  end

endmodule
