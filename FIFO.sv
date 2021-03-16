module regN_Asy(reset, clk, D, Q, WrEn);
  input reset, WrEn;
  input clk;
  parameter N = 1;

  input [N-1 : 0] D;
  output logic [N-1 : 0] Q;

  always @(posedge clk) begin
    if (reset) begin
      Q = 0;
    end
    else if(WrEn == 1'b1) begin
      Q = D;
    end
  end

endmodule
//****************************************************************************
//Shell of the FIFO
//****************************************************************************
module Reg_emulated_FIFO(WrEn, RdEn, WrClock, RdClock, Full, Empty, Data, Q, Reset);
  input logic WrEn, RdEn, WrClock, RdClock, Reset;
  output logic Full, Empty;

  parameter N = 1;
  input logic [N-1 : 0] Q;
  output logic [N-1 : 0] Data;
endmodule

//*****************************************************************************
//Memory Usage Counter, track the number of used emeory blocks(register in this case)
//*****************************************************************************
module Memroy_Usage_Counter(WrClock, RdClock, WrEn, RdEn, Count);
  input logic WrClock, RdClock, WrEn, RdEn;
  output logic [1:0] Count;

  counter(WrClock, RdClock, WrEn, RdEn, Count, Count);

endmodule
//WrEn and RdEn cannot be true simultaneously
module counter(WrClock, RdClock, WrEn, RdEn, NewCount, PreviousCount);
  input logic WrClock, RdClock, WrEn, RdEn;
  input logic [1:0] PreviousCount;
  output logic [1:0] NewCount;

  always@(posedge (WrClock&WrEn)) begin
    NewCount = PreviousCount + 2'b01;
  end

  always@(posedge (RdClock&RdEn)) begin
    NewCount = PreviousCount - 2'b01;
  end

endmodule
//****************************************************************************
//Mux
module two_to_four_decoder(in, out);
  input logic [1:0] in;
  output logic [3:0] out;

  always @(*) begin
    case(in)
      2'b00 : out <= 4'b0001;
      2'b01 : out <= 4'b0010;
      2'b10 : out <= 4'b0100;
      2'b11 : out <= 4'b1000;
    endcase
  end
endmodule
//*****************************************************************************
//Memory Blocks (Register Fiels)
//*****************************************************************************


