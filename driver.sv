
class ram_drv;
ram_trans d_trans;
virtual ram_if.cb_drv vif;
mailbox #(ram_trans) gd;
mailbox #(ram_trans) dr;

covergroup cg;
write:coverpoint d_trans.write_en {bins b1[]={0,1};}
read:coverpoint d_trans.read_en {bins b1[]={0,1};}
data:coverpoint d_trans.write_data {bins b[]={[0:255]};}
address:coverpoint d_trans.add {bins b[]={[0:31]};}
endgroup

function new(mailbox #(ram_trans) gd,mailbox #(ram_trans) dr,virtual ram_if.cb_drv vif);
this.gd=gd;
this.dr=dr;
this.vif=vif;
cg=new();
endfunction

task start();
repeat(3) @(vif.drv);
for(int i=0;i<`num_transactions;i++)
begin
d_trans=new();
gd.get(d_trans);

if(vif.drv.rst==0)
begin
repeat(1) @(vif.drv);
vif.drv.write_en<=0;
vif.drv.read_en<=0;
vif.drv.write_data<=8'hz;
vif.drv.add<=0;
repeat(1) @(vif.drv);
$display("DRIVER WRITE OPERATION DRIVING DATA TO THE INTERFACE write_data=%0h, write_en=%0d, read_en=%0d,address=%0h", vif.drv.write_data, vif.drv.write_en, vif.drv.read_en, vif.drv.add, $time);
dr.put(d_trans);
end

else 
begin
repeat(1) @(vif.drv);
vif.drv.write_en<=d_trans.write_en;
vif.drv.read_en<=d_trans.read_en;
vif.drv.write_data<=d_trans.write_data;
vif.drv.add<=d_trans.add;
repeat(1) @(vif.drv);
$display("DRIVER WRITE OPERATION DRIVING DATA TO THE INTERFACE write_data=%0h, write_en=%0d, read_en=%0d,address=%0h", vif.drv.write_data, vif.drv.write_en, vif.drv.read_en, vif.drv.add, $time);
dr.put(d_trans);
cg.sample();
end

end
endtask
endclass



































