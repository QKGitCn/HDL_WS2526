`timescale 1ns / 1ps
/*
bram_seq_writer.v

Writes 32-bit values 0..MAX_VALUE into BRAM Port B, i.e., write d0 to word[0], d1 to word[1], d2 to word[2]... 

But keep in mind that the BRAM is byte-addressable. BRAM Port B address is treated as BYTE address for 32-bit data,

Behavior:
  - run=0: idle, internal counter reset to 0
  - run=1: write one word per clk with a sequence of 0-MAX_VALUE
  - then stop, assert done pulse for 1 cycle, busy goes low
  - to re-run: set run=0 then run=1 again

TASK:
  - fill in the blank marked by "?", you will find descriptions for the signals that are used to implement this block
  - do not modify the other part of this code
  - follow the instruction and create a customized IP of this bram_seq_writer

*/

module bram_seq_writer #(
  parameter integer ADDR_WIDTH = 32,
  parameter integer MAX_VALUE  = 1000
)(
  input  wire                   clk,
  input  wire                   rst_n,      // active-low reset

  input  wire                   run,        // 1=start/keep running, 0=reset/idle
  output reg                    busy,
  output reg                    done,       // 1-cycle pulse when finished

  // BRAM Port B (native) - 32-bit
  output reg                    bram_enb,
  output reg  [3:0]             bram_web,    // byte write enables; 4'hF = full 32-bit write
  output reg  [ADDR_WIDTH-1:0]  bram_addrb,
  output reg  [31:0]            bram_dinb,
  input  wire [31:0]            bram_doutb   // unused (write-only)
);

  // State encoding
  localparam S_IDLE   = 2'd0;
  localparam S_WRITE  = 2'd1;
  localparam S_FINISH = 2'd2;

  reg [1:0] state;

  // Enough bits to count 0..MAX_VALUE
  // For MAX_VALUE=1000, CNT_W=10 bits.
  localparam integer CNT_W = $clog2(MAX_VALUE + 1);
  
  reg [CNT_W-1:0] count; // a counter to count the value that should be written to dedicated addresses.

  always @(posedge clk) begin
    if (!rst_n) begin
      state      <= S_IDLE; // initialize all the signals
      count      <= ?
      bram_enb   <= ?
      bram_web   <= ?
      bram_addrb <= ?
      bram_dinb  <= ?
      busy       <= ?
      done       <= ?
    end else begin
      done <= ?;

      case (state)
        S_IDLE: begin
          busy     <= ?
          bram_enb <= ?
          bram_web <= ?

          // Reset pointer
          if (!run) begin
            count <= ?
          end else begin
            // Start writing
            state <= ?;
          end
        end

        S_WRITE: begin
          if (!run) begin
            // Stop/reset immediately if run goes low
            state    <=?
            count    <= ?
            busy     <= ?
            bram_enb <= ?
            bram_web <= ?
          end else begin
            busy     <= ?
            bram_enb <= ?
            bram_web <= ?

            // BYTE address for 32-bit words: convert?
            bram_addrb <= ?
            bram_dinb  <= ?

            if (count == MAX_VALUE[CNT_W-1:0]) begin
              state <= ?     // last write happens this cycle, no more writing
            end else begin
              count <= count + 1'b1; // next word
            end
          end
        end

        S_FINISH: begin
          bram_enb <= ?
          bram_web <= ?
          busy     <= ?
          done     <= ?          // 1-cycle done pulse

          // Wait for run to drop so restart is deterministic
          if (!run) begin
            state <= ?
            count <= ?
          end
        end

        default: begin
          state <= S_IDLE;
        end
      endcase
    end
  end

endmodule
