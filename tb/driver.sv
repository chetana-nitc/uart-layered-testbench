class driver;
  transaction tr;
  mailbox #(transaction) gen_drv_mbx;
  virtual uart_if vif;/* class cannot directly access module signals, virtual
  interface creates a handle tothe interface*/
  
  function new(mailbox #(transaction) gen_drv_mbx,virtual uart_if vif);
    this.gen_drv_mbx=gen_drv_mbx;
    this.vif=vif;
  endfunction
  
  task run();
    forever begin
      gen_drv_mbx.get(tr);// get data from generator
      $display("(driver) Driving data=%h",tr.data);
      wait(!vif.Tx_busy);/* wait till Tx is not busy (prev transmission to
      finish*/
      vif.data_in=tr.data;//data_in to Tx = generated data
      
      @(posedge vif.clk_50m);
      vif.Tx_en=1;// assert Tx_en: driver tell that it's ready to transmit
      
      @(posedge vif.clk_50m);
      vif.Tx_en=0;// deassert Tx_en
      
      wait(vif.Tx_busy);/* after Tx_en is high for one pulse, UART starts
      transmitting*/
      wait(!vif.Tx_busy);// finish transmission
      end
  endtask
endclass