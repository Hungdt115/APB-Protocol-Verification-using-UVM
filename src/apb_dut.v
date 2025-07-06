//--------------------------------------------------------------------
//-- Module: apb_dut
//-- Description:
//--  This module implements a simple APB (Advanced Peripheral Bus) slave device.
//--  It features a state machine to handle APB transfers (IDLE, SETUP, ACCESS)
//--  and an internal 32-word (32-bit each) memory for read/write operations.
//--  The module responds to APB signals and manages the PREADY signal.
//--------------------------------------------------------------------
module apb_dut (
  input  bit         PSEL,
  input  bit         PENABLE,
  input  bit  [31:0] PADDR,
  input  bit         PWRITE,
  input  bit  [31:0] PWDATA,
  input  bit         PCLK,
  input  bit         PRESET, 

  output reg  [31:0] PRDATA,
  output reg         PREADY,
  output reg         PSLVERR
);

  //-- APB State Parameters
  parameter IDLE   = 2'b00;
  parameter SETUP  = 2'b01;
  parameter ACCESS = 2'b10;

  //-- Internal State Registers
  reg [1:0] ps, ns; // Current state (ps) and next state (ns)
  reg [31:0] mem [31:0]; // 32-word memory, each word is 32-bit

  //--------------------------------------------------------------------
  //-- State Register Logic
  //--------------------------------------------------------------------
  always @(posedge PCLK) begin
    if (PRESET) begin
      ps <= IDLE;
    end else begin
      ps <= ns;
    end
  end

  //--------------------------------------------------------------------
  //-- Next State and Output Logic
  //--------------------------------------------------------------------
  always @(*) begin
    // Default values
    ns      = ps;
    PREADY  = 1'b0; // Default PREADY to low
    PSLVERR = 1'b0; // Default PSLVERR to low

    case (ps)
      IDLE: begin
        if (PSEL == 1'b1 && PENABLE == 1'b0) begin
          ns = SETUP;
        end else begin
          ns = IDLE;
        end
      end

      SETUP: begin
        if (PSEL == 1'b1 && PENABLE == 1'b1) begin
          ns     = ACCESS;
          PREADY = 1'b1; // Assert PREADY for one cycle in ACCESS
          // Check for invalid address access
          if (PADDR >= 32) begin // Assuming memory size is 32 words (0-31)
            PSLVERR = 1'b1;
          end else begin
            // Perform memory operation only if address is valid
            if (PWRITE) begin
              mem[PADDR] = PWDATA;
            end else begin
              PRDATA = mem[PADDR];
            end
          end
        end else if (PSEL == 1'b1 && PENABLE == 1'b0) begin
          // Stay in SETUP state if PSEL is high but PENABLE is not yet high
          ns = SETUP;
        end else begin
          // If PSEL is low or PENABLE is high (invalid for SETUP without PSEL), go to IDLE
          ns = IDLE;
        end
      end

      ACCESS: begin
        PREADY = 1'b1; // PREADY remains high during ACCESS for single-cycle transfer
        // Check for invalid address access during ACCESS phase as well
        if (PADDR >= 32) begin
          PSLVERR = 1'b1;
        end

        if (PSEL == 1'b1 && PENABLE == 1'b0) begin
          // Next transfer starts immediately (PENABLE goes low, PSEL stays high)
          ns = SETUP;
        end else if (PSEL == 1'b0 && PENABLE == 1'b0) begin
          // Transfer ends (PSEL and PENABLE go low)
          ns = IDLE;
        end else begin
          // For any other combination (e.g., PSEL=1, PENABLE=1, or invalid states),
          // assume transfer completes and go to IDLE for simplicity.
          // A more robust design might handle multi-cycle transfers or error states.
          ns = IDLE;
        end
      end

      default: ns = IDLE;
    endcase
  end

endmodule
