class apb_transaction extends uvm_sequence_item;
  
  `uvm_object_utils(apb_transaction)
  
  rand bit [31:0] PADDR;
  rand bit [31:0] PWDATA;
  
  bit PWRITE;
  bit PENABLE;
  bit PSEL;
  bit PRESETn;
  bit [0:3] PSTRB; 
  bit [31:0] PRDATA;
  bit PSLVERR;
  bit PREADY;
 
  constraint c1{soft PADDR[31:0]>=32'd0; PADDR[31:0] <32'd32;};
 
  //Constructor
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction 

  //convert2string
  function string convert2string();
    return $sformatf("PADDR=%0h, PWDATA=%0h, PWRITE=%0b, PENABLE=%0b, PSEL=%0b, PRESETn=%0b, PSTRB=%0b, PRDATA=%0h, PSLVERR=%0b, PREADY=%0b",
                     PADDR, PWDATA, PWRITE, PENABLE, PSEL, PRESETn, PSTRB, PRDATA, PSLVERR, PREADY);
  endfunction
 
endclass
