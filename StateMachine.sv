module statemachine(reset, full_1, full_2, empty_1, empty_2, reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, current_stage, next_stage);

  input logic reset, full_1, full_2, empty_1, empty_2;
  input logic [1:0] current_stage;

  output logic reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2;
  output logic [1:0] next_stage;

  always@(*) begin
    if(reset == 1'b1) begin
      {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b11, 2'b00, 2'b00, 2'b00};
    end
    else begin
      casex({current_stage, full_1, full_2, empty_1, empty_2})
        {2'b00, 2'b00, 2'b11} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b00, 2'b10, 2'b00};//Reset successed, start filling FIFO_1
        {2'b00, 2'b00, 2'b01} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b00, 2'b10, 2'b00};//Data recived by FIFO_1, but FIFO_1 is not filled yet
        {2'b00, 2'b10, 2'b01} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b00, 2'b00, 2'b01};//FIFO_1 is filled. FIFO_2 is still at initial stage.
        //Start read from FIFO_1 while write to FIFO_2
        {2'b01, 2'b10, 2'b01} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b10, 2'b01, 2'b01};//Start read from FIFO_1 while write to FIFO_2
        {2'b01, 2'b00, 2'b00} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b10, 2'b01, 2'b01};//Read from FIFO_1 and remove data from FIFO_1. FIFO_2 is not empty anymore
        {2'b01, 2'b00, 2'b10} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b00, 2'b01, 2'b00};//FIFO_1 is emptied and FIFO_2 is not filled yet> (Read speed is faster than write).Pause sending data to DDR until FIFO_2is filled
        {2'b01, 2'b01, 2'b10} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b00, 2'b00, 2'b10};//FIFO_2 is filled and FIFO_1 is emptied. Ready to switch to read-FIFO_2 and write-FIFO_1
        ///Start read from FIFO_2 while write to FIFO_1
        {2'b10, 2'b01, 2'b10} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b01, 2'b10, 2'b10};
        {2'b10, 2'b00, 2'b00} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b01, 2'b10, 2'b10};//Read from FIFO_2 and remove data from FIFO_2. FIFO_1 is not empty anymore
        {2'b10, 2'b00, 2'b01} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b00, 2'b01, 2'b00};//FIFO_2 is emptied and FIFO_1 is not filled yet (Read speed is faster than write).Pause sending data to DDR until FIFO_2is filled
        {2'b01, 2'b10, 2'b01} : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b00, 2'b00, 2'b00, 2'b01};//FIFO_1 is filled and FIFO_2 is emptied. Ready to switch to read-FIFO_1 and write-FIFO_2

        default : {reset_1, reset_2, RdEn_1, RdEn_2, WrEn_1, WrEn_2, next_stage} = {2'b11, 2'b00, 2'b00, 2'b11};//2'b11 is the error stage. We are not supposed to trigger the default stage unless some unexpected feedbacks from FIFOs are recived. 

      endcase
    end
  end
endmodule
