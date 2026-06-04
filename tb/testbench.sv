
`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "assertions.sv"
module top;
  logic [7:0]ledr;
  logic Tx2;
  uart_if vif();
  uart dut(.data_in(vif.data_in),
           .Tx_en(vif.Tx_en),
           .clear(1'b0),
           .clk_50m(vif.clk_50m),
           .Tx(vif.Tx),
           .Tx_busy(vif.Tx_busy),
           .Rx(vif.Rx),
           .Rx_en(vif.Rx_en),
           .ready(vif.ready),
           .ready_clr(vif.ready_clr),
           .data_out(vif.data_out),
           .LEDR(ledr),
           .Tx2(Tx2));
  uart_assert asrt(vif);// dut instance
  
  assign vif.Rx=vif.Tx;
  mailbox #(transaction) gen_drv_mbx;
  mailbox #(transaction) gen_scb_mbx;
  mailbox #(transaction) mon_scb_mbx;
  generator gen;// creating mailbox handles
  driver drv;
  monitor mon;
  scoreboard scb;
  
  always@(posedge vif.ready) begin// clear ready after one cycle
    @(posedge vif.clk_50m);
    vif.ready_clr=1;/* after one cylce, ready will go low, this is saying that
    receiver has seen the valid data, wait for the next valid one*/
    @(posedge vif.clk_50m);
    vif.ready_clr=0;
  end
  
  initial begin
    vif.clk_50m=0;
    forever #10 vif.clk_50m=~vif.clk_50m;// 50MHz clk 
  end
  
  initial begin
    $dumpfile("dump.vcd");// create a waveform file dump.vcd
    $dumpvars(0, top);/* 0: dump everything recursively, top: all modules/instances beneath top module*/
end
  
  initial begin
    vif.Tx_en=0;// active high
    vif.Rx_en=0;// active low enable
    vif.ready_clr=0;
    
    
   
    gen_drv_mbx=new();// mailbox objects
    gen_scb_mbx=new();
    mon_scb_mbx=new();
    
    gen=new(gen_drv_mbx,gen_scb_mbx);
    drv=new(gen_drv_mbx,vif);
    mon=new(mon_scb_mbx,vif);
    scb=new(gen_scb_mbx,mon_scb_mbx);
    
    fork // all the tasks run simultaneously
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none /* join_none: doesn't wait for these processed to
    finish, goes to the next statement*/
    
    #5000000 
    $display("Coverage = %0.2f%%", $get_coverage());/*coverage
    percentage (float) with 2 decimals*/
    $finish;
  end
endmodule
    
    
    
  
           
