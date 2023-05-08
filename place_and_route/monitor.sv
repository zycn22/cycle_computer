// This special monitor file monitors signals in the system.sv module

initial
   $timeformat(0,2, " s", 10 );

always #1s
   $display("%t",$time );

always @( negedge nCrank )
   $display("                   Crank" );

always @( negedge nFork )
   $display("                         Fork" );

initial
   $monitor("           Mode %0d",mode_index );

