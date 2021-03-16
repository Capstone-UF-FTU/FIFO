module TB_TB_StartOfDataWriteCycle;

reg WrEn, RdEn, reset;
reg WrClock, RdClock;
reg [15:0] Data;

wire Full, Empty;
wire [15:0] Q;

/******************************************************/  
//Clock module, generate square waves
  initial begin
    WrClock = 0;
    #5;
    forever begin
      WrClock = 1;
      #5;
      WrClock = 0;
      #5;
    end
  end
/******************************************************/

/******************************************************/  
//Clock module, generate square waves
  initial begin
    RdClock = 0;
    #2;
    forever begin
      RdClock = 1;
      #5;
      RdClock = 0;
      #5;
    end
  end
/************************************************************************************************/
//Reg_emulated_FIFO MUT1(.WrEn(), .RdEn(), .WrClock(), .RdClock(), .Full(), .Empty(), .Data(), .Q(), .Reset());
/************************************************************************************************/

  initial begin
    reset = 1'b1; RdEn = 1'b0; WrEn = 1'b0; #2;
    reset = 1'b0; RdEn = 1'b0; WrEn = 1'b0; #1;
    reset = 1'b0; RdEn = 1'b0; WrEn = 1'b1; Data = 16'd2; #10;
    reset = 1'b0; RdEn = 1'b0; WrEn = 1'b1; Data = 16'd3; #10;
    reset = 1'b0; RdEn = 1'b0; WrEn = 1'b1; Data = 16'd4; #10;
    reset = 1'b0; RdEn = 1'b0; WrEn = 1'b1; Data = 16'd5; #10;
    reset = 1'b0; RdEn = 1'b0; WrEn = 1'b1; Data = 16'd6; #10;
    $stop;
  end

endmodule
