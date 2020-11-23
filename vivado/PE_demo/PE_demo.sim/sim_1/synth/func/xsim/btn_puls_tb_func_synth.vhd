-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Mon Nov 23 14:42:52 2020
-- Host        : DESKTOP-LG337B8 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/Users/Alexander/Documents/Master_Embedded/SoC_Lab/Run-Time-Power-Monitoring/vivado/PE_demo/PE_demo.sim/sim_1/synth/func/xsim/btn_puls_tb_func_synth.vhd
-- Design      : btn_puls
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity btn_puls is
  port (
    RESET_n : in STD_LOGIC;
    CLK : in STD_LOGIC;
    btn : in STD_LOGIC;
    PULS : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of btn_puls : entity is true;
end btn_puls;

architecture STRUCTURE of btn_puls is
  signal CLK_IBUF : STD_LOGIC;
  signal CLK_IBUF_BUFG : STD_LOGIC;
  signal FSM_sequential_state_i_1_n_0 : STD_LOGIC;
  signal FSM_sequential_state_reg_n_0 : STD_LOGIC;
  signal PULS_OBUF : STD_LOGIC;
  signal PULS_i_1_n_0 : STD_LOGIC;
  signal RESET_n_IBUF : STD_LOGIC;
  signal btn_IBUF : STD_LOGIC;
  signal signal_level_last : STD_LOGIC;
  signal signal_level_last_i_1_n_0 : STD_LOGIC;
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of FSM_sequential_state_reg : label is "iSTATE:0,iSTATE0:1";
begin
CLK_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => CLK_IBUF,
      O => CLK_IBUF_BUFG
    );
CLK_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => CLK,
      O => CLK_IBUF
    );
FSM_sequential_state_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => btn_IBUF,
      I1 => signal_level_last,
      I2 => FSM_sequential_state_reg_n_0,
      O => FSM_sequential_state_i_1_n_0
    );
FSM_sequential_state_reg: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK_IBUF_BUFG,
      CE => '1',
      CLR => PULS_i_1_n_0,
      D => FSM_sequential_state_i_1_n_0,
      Q => FSM_sequential_state_reg_n_0
    );
PULS_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => PULS_OBUF,
      O => PULS
    );
PULS_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => RESET_n_IBUF,
      O => PULS_i_1_n_0
    );
PULS_reg: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK_IBUF_BUFG,
      CE => '1',
      CLR => PULS_i_1_n_0,
      D => FSM_sequential_state_reg_n_0,
      Q => PULS_OBUF
    );
RESET_n_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => RESET_n,
      O => RESET_n_IBUF
    );
btn_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => btn,
      O => btn_IBUF
    );
signal_level_last_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0220"
    )
        port map (
      I0 => RESET_n_IBUF,
      I1 => FSM_sequential_state_reg_n_0,
      I2 => signal_level_last,
      I3 => btn_IBUF,
      O => signal_level_last_i_1_n_0
    );
signal_level_last_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK_IBUF_BUFG,
      CE => signal_level_last_i_1_n_0,
      D => btn_IBUF,
      Q => signal_level_last,
      R => '0'
    );
end STRUCTURE;
