interface ram_if(input bit clk,input bit rst);
logic write_en,read_en;
logic [7:0] write_data;
logic [7:0] read_data_out;
logic [4:0] add;

clocking drv @(posedge clk);
default input #0 output #0;
output write_en,read_en,write_data,add;
input rst;
endclocking 

clocking mon @(posedge clk);
default input #0 output #0;
input read_data_out;
endclocking 

clocking ref_cb @(posedge clk);
default input #0 output #0;
input rst;
endclocking

modport cb_drv(clocking drv);
modport cb_ref(clocking ref_cb,input rst);
modport cb_mon(clocking mon);

endinterface

