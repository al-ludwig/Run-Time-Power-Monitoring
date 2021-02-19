// Top level testbench contains the interface, DUT and test handles which 
// can be used to start test components once the DUT comes out of reset. Or
// the reset can also be a part of the test class in which case all you need
// to do is start the test's run method.

`include "../../sources_1/new/test.sv"
module tb;
  reg clk;
  
  always #10 clk = ~clk;
  reg_if _if (clk);
  
//  reg_ctrl u0 ( .clk (clk),
//            	.addr (_if.addr),
//               	.rstn(_if.rstn),
//            	.sel  (_if.sel),
//               	.wr (_if.wr),
//            	.wdata (_if.wdata),
//            	.rdata (_if.rdata),
//            	.ready (_if.ready));
  
//  reg_ctrlTWO u0 ( .clk (clk),
//            	.addr (_if.addr),
//               	.rstn(_if.rstn),
//            	.sel  (_if.sel),
//               	.wr (_if.wr),
//            	.wdata (_if.wdata),
//            	.rdata (_if.rdata),
//            	.ready (_if.ready));,

  Single_port_RAM_VHDL ram ( .RAM_CLOCK (clk),
                            .RAM_ADDR (_if.addr),
                            .RAM_RESTN (_if.rstn),
                            .RAM_DATA_IN (_if.wdata),
                            .RAM_DATA_OUT (_if.rdata),
                            .RAM_WR (_if.wr));
  
  initial begin
    test t0;
    
    clk <= 0;
    _if.rstn <= 0;
    #20 _if.rstn <= 1;
    
    t0 = new;
    t0.e0.vif = _if;
    t0.run();
    
    // Once the main stimulus is over, wait for some time
    // until all transactions are finished and then end 
    // simulation. Note that $finish is required because
    // there are components that are running forever in 
    // the background like clk, monitor, driver, etc
    #1000000 $finish; //=1ms
  end
  
  // Simulator dependent system tasks that can be used to 
  // dump simulation waves.
  //initial begin
    //$dumpvars;
    //$dumpfile("dump.vcd");
  //end
endmodule