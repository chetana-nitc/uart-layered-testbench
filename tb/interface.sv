interface uart_if;//interface is a SystemVerilog condtruct that is used to bundle the related signals together
  logic clk_50m;

  //Tx side signals
  logic [7:0]data_in;
  logic Tx_en;
  
  logic Tx;
  logic Tx_busy;
  //Rx side signals
  logic Rx;
  logic Rx_en;
  logic ready;
  logic ready_clr;
 
  
  logic [7:0]data_out;
  
endinterface
  