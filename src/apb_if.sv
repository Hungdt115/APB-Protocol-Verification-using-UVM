//----------------------------------------------------------------------
// Title: APB Interface
// Description:
//   This file defines the Advanced Peripheral Bus (APB) interface.
//   It includes all standard APB signals and defines modports for
//   master, slave, and monitor roles to specify signal directions.
//----------------------------------------------------------------------
interface apb_if();

  //--------------------------------------------------------------------
  // Clock and Reset Signals
  //--------------------------------------------------------------------
  bit PCLK;
  bit PRESET;


  //--------------------------------------------------------------------
  // APB Control Signals
  //--------------------------------------------------------------------
  bit       PSEL;
  bit       PENABLE;
  bit       PWRITE;
  bit [3:0] PSTRB;
  bit [2:0] PPROT;


  //--------------------------------------------------------------------
  // APB Address and Data Signals
  //--------------------------------------------------------------------
  logic [31:0] PADDR;
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;


  //--------------------------------------------------------------------
  // APB Response Signals
  //--------------------------------------------------------------------
  bit PREADY;
  bit PSLVERR;


  //--------------------------------------------------------------------
  // Modport for APB Master
  //--------------------------------------------------------------------
  modport master (
    output PADDR,
    output PWDATA,
    output PWRITE,
    output PSEL,
    output PENABLE,
    output PSTRB,

    input PRDATA,
    input PREADY,
    input PSLVERR,
    input PCLK,
    input PRESET
  );


  //--------------------------------------------------------------------
  // Modport for APB Slave
  //--------------------------------------------------------------------
  modport slave (
    input PADDR,
    input PWDATA,
    input PWRITE,
    input PSEL,
    input PENABLE,
    input PSTRB,
    input PCLK,
    input PRESET,

    output PRDATA,
    output PREADY,
    output PSLVERR
  );


  //--------------------------------------------------------------------
  // Modport for APB Monitor
  //--------------------------------------------------------------------
  modport monitor (
    input PADDR,
    input PWDATA,
    input PWRITE,
    input PSEL,
    input PENABLE,
    input PSTRB,
    input PRDATA,
    input PREADY,
    input PSLVERR,
    input PCLK,
    input PRESET
  );

endinterface : apb_if