module statemachine(reset, full_1, full_2, empty_1, empty_2, reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error);

  input logic reset, full_1, full_2, empty_1, empty_2;
  output logic reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error;

  always@(*) begin
      casex({reset, full_1, full_2, empty_1, empty_2})
        5'b1xxxx : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b1100000;//Reset Stage
        //Error Stage, recived unexpected feedbacks and reset both FIFOs
        5'b011xx : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b1100001;
        5'b0101x : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b1100001;
        5'b001x1 : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b1100001;
        //Filling FIFO_1
        5'b00011 : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b0000100;
        5'b00001 : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b0000100;
        5'b01001 : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b0010010;
        5'b01000 : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b0001001;
        //Emptying FIFO_2
        5'b00110 : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b0001100;
        5'b00100 : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, Error} = 7'b0010001;
      endcase
   end
endmodule
