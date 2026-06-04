class generator;
  transaction tr;//declaring object handle
  mailbox #(transaction) gen_drv_mbx;/* mailbox: built-in SystemVerilog
  communication system between classes, #(tr): parameterization, 
  that means mailbox can hold transacation handles only*/
  
  mailbox #(transaction) gen_scb_mbx;
  function new(mailbox #(transaction) gen_drv_mbx,mailbox #(transaction) gen_scb_mbx);// constructor 
    
    this.gen_drv_mbx=gen_drv_mbx;/* this: keyword, it tells that the class
    member(lhs) is the same as parameter(rhs)*/
    
    this.gen_scb_mbx=gen_scb_mbx;
  endfunction
  int count=1000;
  task run();// this exectues when run is called for the class object
    
    repeat(count) begin// equivalent to for() loop
      
      tr=new();// create new object (here, also the covergroup object)
      assert(tr.randomize());
      tr.uart_cg.sample();// records the current value of data
      $display("(generator) Generated data =%h",tr.data);
      gen_drv_mbx.put(tr);// data put in mailbox
      gen_scb_mbx.put(tr);
    end
  endtask
 
endclass