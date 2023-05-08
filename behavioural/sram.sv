module sram(
  input HSEL,
  input HRESETn,
  input [31:0] HADDR,
  input [31:0] HWDATA,
  input HWRITE, HREADY,
  input [1:0] HTRANS,
  
  output [31:0] HRDATA
);

localparam No_Transfer = 2'b0;
  
logic write_enable, read_enable;
logic en;
assign en = '0;

  always_comb begin
    if ( HREADY && HSEL && (HTRANS != No_Transfer) ) begin
      write_enable = HWRITE;
      read_enable  = !HWRITE;
    end
  end

  sram256x32 ram_1(
             .CS(HSEL),
             .AD(HADDR[9:2]),
             .NRST(HRESETn),
             .DI(HWDATA),
             .DO(HRDATA),
             .WR(write_enable),
             .RD(read_enable),
             .EN(en)
  );

endmodule
