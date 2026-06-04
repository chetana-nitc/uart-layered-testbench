module uart_assert(uart_if vif);// SystemVerilog Assertions, this module gets interface instance as the parameter
//property: is it a rule that the simulator has to check
/* |=> is non overlapping implication operator
|-> is overlapping implication operator*/

  
  property tx_start;
    @(posedge vif.clk_50m)
    vif.Tx_en |=> vif.Tx_busy;/*if Tx_en is high, then Tx_busy should be high
    on the next clk*/
  endproperty
  
  assert property(tx_start);// continously monitor the property
    
   property valid_data;
     @(posedge vif.clk_50m)
     vif.ready |-> !$isunknown(vif.data_out);/*whenever ready is
     asserted, data_out should have valid byte in the same clk*/
   endproperty
    
   assert property(valid_data);
endmodule