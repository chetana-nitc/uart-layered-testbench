class transaction;
  rand bit [7:0] data;// rand: data can be randomized, bit: only 0 or 1 values
  covergroup uart_cg;//covergroup: object-like construct
    
    cp_data: coverpoint data/* cp_data: coverpoint name, it is the coverpoint
    for the var "data"*/
    
    { bins zero = {8'h00};
      bins max  = {8'hFF};

      bins low  = {[8'h01:8'h3F]};
      bins mid  = {[8'h40:8'hBF]};
      bins high = {[8'hC0:8'hFE]};
    }
  endgroup
  
  function new();/*constructor for transaction class, new() is used for class
  constructs and object allocation*/
    
    uart_cg=new();//creates covergroup instance
    
  endfunction
endclass