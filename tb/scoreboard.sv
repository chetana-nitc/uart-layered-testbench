class scoreboard;
  transaction expected_tr;
  transaction actual_tr;
  mailbox #(transaction) gen_scb_mbx;
  mailbox #(transaction) mon_scb_mbx;
  function new(mailbox #(transaction) gen_scb_mbx,mailbox #(transaction) mon_scb_mbx);
    this.gen_scb_mbx=gen_scb_mbx;
    this.mon_scb_mbx=mon_scb_mbx;
  endfunction
  task run();
    forever begin
      gen_scb_mbx.get(expected_tr);
      mon_scb_mbx.get(actual_tr);
      if(expected_tr.data==actual_tr.data) begin// compares the data
        $display("(scoreboard) Expected data= %h, Actual data= %h",expected_tr.data,actual_tr.data);
        $display("PASS");
      end
      else begin
        $display("(scoreboard) Expected data= %h, Actual data= %h",expected_tr.data,actual_tr.data);
        $display("FAIL");
      end
    end
  endtask
endclass
  