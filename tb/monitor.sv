class monitor;
  transaction tr;
  mailbox #(transaction) mon_scb_mbx;
  virtual uart_if vif;
  function new(mailbox #(transaction) mon_scb_mbx,virtual uart_if vif);//constructor
    this.mon_scb_mbx=mon_scb_mbx;
    this.vif=vif;
  endfunction
  task run();
    forever begin
      @(posedge vif.ready);// ready: receiver has received a vadid data byte
      tr=new();
      tr.data=vif.data_out;
      $display("(monitor) Received data=%h",tr.data);
      mon_scb_mbx.put(tr);
    
    end
  endtask
endclass