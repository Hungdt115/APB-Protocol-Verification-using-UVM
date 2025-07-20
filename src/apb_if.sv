//----------------------------------------------------------------------
// Title      : APB Interface
// Description: 
//   This file defines the Advanced Peripheral Bus (APB) interface.
//   It includes all standard APB signals and provides modports for
//   master, slave, and monitor roles to specify signal directions.
//----------------------------------------------------------------------

interface apb_if;

  //--------------------------------------------------------------------
  // Clock and Reset Signals
  //--------------------------------------------------------------------
  logic PCLK;
  logic PRESETn;

  //--------------------------------------------------------------------
  // APB Control Signals
  //--------------------------------------------------------------------
  logic       PSEL;
  logic       PENABLE;
  logic       PWRITE;
  logic [3:0] PSTRB;
  logic [2:0] PPROT;

  //--------------------------------------------------------------------
  // APB Address and Data Signals
  //--------------------------------------------------------------------
  logic [31:0] PADDR;
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;

  //--------------------------------------------------------------------
  // APB Response Signals
  //--------------------------------------------------------------------
  logic PREADY;
  logic PSLVERR;

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
    output PPROT,

    input  PRDATA,
    input  PREADY,
    input  PSLVERR,

    input  PCLK,
    input  PRESETn
  );

  //--------------------------------------------------------------------
  // Modport for APB Slave
  //--------------------------------------------------------------------
  modport slave (
    input  PADDR,
    input  PWDATA,
    input  PWRITE,
    input  PSEL,
    input  PENABLE,
    input  PSTRB,
    input  PPROT,

    input  PCLK,
    input  PRESETn,

    output PRDATA,
    output PREADY,
    output PSLVERR
  );

  //--------------------------------------------------------------------
  // Modport for APB Monitor
  //--------------------------------------------------------------------
  modport monitor (
    input  PADDR,
    input  PWDATA,
    input  PWRITE,
    input  PSEL,
    input  PENABLE,
    input  PSTRB,
    input  PPROT,

    input  PRDATA,
    input  PREADY,
    input  PSLVERR,

    input  PCLK,
    input  PRESETn
  );

endinterface : apb_if

