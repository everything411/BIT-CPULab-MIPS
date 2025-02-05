//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2009 Xilinx Inc.
//
//  Project  : Programmable Wave Generator
//  Module   : clk_gen.v
//  Parent   : wave_gen.v
//  Children : None
//
//  Description: 
//     This module is the clock generator for the design.
//     It takes in a single clock input (nominally 100MHz), and generates
//     three output clocks using a single clock generator:
//        clk_rx   - running at the same frequency as the input clock
//        clk_tx   - either running at the same frequency as the input clock
//                   or running at 31/32 times the frequency
//        clk_samp - a decimated version of clk_tx using a BUFHCE (from
//                   clk_tx)
//                 - running at 1/prescale the frequency of clk_tx
//
//
//  Parameters:
//     None
//
//  Notes       : 
//
//  Multicycle and False Paths
//     None

`timescale 1ns/1ps


module clk_gen (
  input             clk_pin,         // Input clock pin - IBUFGDS is in core
  input             rst_i,           // Asynchronous input from IBUF

  input             rst_clk_tx,      // For clock divider
  
  input      [15:0] pre_clk_tx,      // Current divider

  output            clk_rx,          // Receive clock
  output            clk_tx,          // Transmit clock
  output            clk_samp,        // Sample clock
  output            clk_vga,
  output            en_clk_samp,     // Enable for clk_samp
  output            clock_locked     // Locked signal from MMCM
);

//***************************************************************************
// Function definitions
//***************************************************************************

//***************************************************************************
// Parameter definitions
//***************************************************************************

//***************************************************************************
// Reg declarations
//***************************************************************************

//***************************************************************************
// Wire declarations
//***************************************************************************
  
//***************************************************************************
// Code
//***************************************************************************

  // Instantiate the prescale divider
  // reg clk_nul;

  clk_div clk_div_i0 (
    .clk_tx          (clk_tx),
    .rst_clk_tx      (rst_clk_tx),
    .pre_clk_tx      (pre_clk_tx),
    .en_clk_samp     (en_clk_samp)
  );

  // Instantiate clk_core - generated by the Clocking Wizard

    clk_core clk_core_i0
     (
     // Clock in ports
      .clk_in1(clk_pin),      // input clk_in1
      // Clock out ports
      .clk_out1(clk_rx),     // output clk_out1
      .clk_out2(clk_tx),     // output clk_out2
      .clk_out3(clk_vga),
      // Status and control signals
      .reset(rst_i), // input reset
      .locked(clock_locked));      // output locked
  // Insert Clock Core here

  BUFHCE #(
   .INIT_OUT(0)  // Initial output value
  )
  BUFHCE_clk_samp_i0
  (
     .O        (clk_samp),   // 1-bit The output of the BUFH
     .CE       (en_clk_samp),// 1-bit Enables propagation of signal from I to O
     .I        (clk_tx)      // 1-bit The input to the BUFH
  ); // BUFHCE
  


endmodule
