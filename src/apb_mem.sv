//==============================================================================
//  Module      : apb_mem
//  Description : Simple APB Slave supporting PSTRB write mask
//                Outputs PRDATA on read, supports byte write via PSTRB
//                Currently does not generate PSLVERR
//==============================================================================

module apb_mem (
    //--------------------------------------------------------------------------
    // APB Interface Ports
    //--------------------------------------------------------------------------
    input  logic        PCLK,     // APB clock
    input  logic        PRESETn,  // APB active-low reset
    input  logic        PSEL,     // APB select
    input  logic        PENABLE,  // APB enable
    input  logic        PWRITE,   // APB write/read control
    input  logic [31:0] PADDR,    // APB address
    input  logic [31:0] PWDATA,   // APB write data
    input  logic [ 3:0] PSTRB,    // APB byte write strobe
    output logic        PREADY,   // APB ready signal
    output logic [31:0] PRDATA,   // APB read data
    output logic        PSLVERR   // APB slave error
);

  //--------------------------------------------------------------------------
  // Internal Memory Declaration
  // 256 words of 32-bit each (can be changed based on design requirement)
  //--------------------------------------------------------------------------
  logic [31:0] mem[0:255];

  //--------------------------------------------------------------------------
  // Internal State Definitions
  //--------------------------------------------------------------------------
  logic [1:0] apb_st;

  localparam SETUP = 2'd0;
  localparam W_ENABLE = 2'd1;
  localparam R_ENABLE = 2'd2;

  //--------------------------------------------------------------------------
  // APB Protocol State Machine
  //--------------------------------------------------------------------------
  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      apb_st  <= SETUP;
      PRDATA  <= 32'd0;
      PREADY  <= 1;
      PSLVERR <= 0;

      // Initialize memory with default values (0,1,2,...)
      for (int i = 0; i < 256; i++) begin
        mem[i] <= i;
      end
    end else begin
      case (apb_st)
        //==================================================================
        // SETUP STATE
        // Wait for transfer to begin (PSEL=1 && PENABLE=0)
        //==================================================================
        SETUP: begin
          PRDATA  <= 32'd0;
          PSLVERR <= 0;

          if (PSEL && !PENABLE) begin
            if (PWRITE) apb_st <= W_ENABLE;
            else begin
              apb_st <= R_ENABLE;
              //PRDATA <= mem[PADDR];
            end
          end
        end

        //==================================================================
        // W_ENABLE STATE
        // Perform write with byte strobe (PSTRB)
        //==================================================================
        W_ENABLE: begin
          if (PSEL && PENABLE && PWRITE) begin
            for (int i = 0; i < 4; i++) begin
              if (PSTRB[i]) mem[PADDR][8*i+:8] <= PWDATA[8*i+:8];
            end
            PREADY <= 1;
          end
          apb_st <= SETUP;
        end

        //==================================================================
        // R_ENABLE STATE
        // Read already performed in SETUP, just go back to SETUP
        //==================================================================
        R_ENABLE: begin
          PRDATA <= mem[PADDR];
          PREADY <= 1; 
          apb_st <= SETUP;
        end

      endcase
    end
  end

endmodule

