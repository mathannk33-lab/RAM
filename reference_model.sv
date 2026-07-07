
class ram_ref;
ram_trans r_trans;
mailbox #(ram_trans) dr;
virtual ram_if.cb_ref vif;
mailbox #(ram_trans) rs;
reg [`DATA_WIDTH-1:0] mem [`DATA_DEPTH-1:0];

function new(mailbox #(ram_trans)dr,mailbox #(ram_trans) rs,virtual ram_if.cb_ref vif);
this.rs=rs;
this.dr=dr;
this.vif=vif;
endfunction

task start();
for(int i=0;i<`num_transactions;i++)
begin
r_trans=new();
dr.get(r_trans);
if(vif.rst==0)
r_trans.read_data_out=8'hz;
else
repeat (1) @(vif.ref_cb);
begin
if(r_trans.write_en)begin
mem[r_trans.add]=r_trans.write_data;
$display("REFERENCE MODEL DATA IN MEMORY MEM[%0h]=%0h",r_trans.add,mem[r_trans.add],$time);
end

if(r_trans.read_en)begin
r_trans.read_data_out=mem[r_trans.add];
$display("REFERENCE MODEL DATA IN MEMORY MEM[%0h]=%0h",r_trans.add,mem[r_trans.add],$time);
end

rs.put(r_trans);
end
end
endtask

endclass


