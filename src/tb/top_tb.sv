`include "ram.sv"
`include "interface_ram.sv"
module top_tb;
bit clk;
bit rst;

import package_ram::*;
initial begin
clk=0;
forever #10 clk=~clk;
end

initial begin
rst=0;
repeat(1) @(posedge clk) ;
rst=1;
repeat(4) @(posedge clk);
rst=0;
repeat(4)@(posedge clk);
rst=1;
repeat(405) @(posedge clk);
rst=0;
end

ram_if inf(clk,rst);
RAM dut(clk,rst,inf.add,inf.write_data,inf.write_en,inf.read_en,inf.read_data_out);

//test ram_test=new(inf.cb_drv,inf.cb_mon,inf.cb_ref);
//test1 ram_test1=new(inf.cb_drv,inf.cb_mon,inf.cb_ref);
//test2 ram_test2=new(inf.cb_drv,inf.cb_mon,inf.cb_ref);
//test3 ram_test3=new(inf.cb_drv,inf.cb_mon,inf.cb_ref);
//test4 ram_test4=new(inf.cb_drv,inf.cb_mon,inf.cb_ref);
//test5 ram_test5=new(inf.cb_drv,inf.cb_mon,inf.cb_ref);
test_regression ram_test6=new(inf.cb_drv,inf.cb_mon,inf.cb_ref);

initial
begin
//ram_test.start();
//ram_test2.start();
//ram_test1.start();
//ram_test3.start();
//ram_test4.start();
//ram_test5.start();
ram_test6.start();
$finish;
end

endmodule
