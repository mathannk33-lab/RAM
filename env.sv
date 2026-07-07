
class env;
virtual ram_if vif_drv;
virtual ram_if vif_mon;
virtual ram_if vif_ref;
mailbox #(ram_trans) dr;
mailbox #(ram_trans) rs;
mailbox #(ram_trans) ms;
mailbox #(ram_trans) gd;

ram_gen gen;
ram_drv drv;
ram_ref ref_ob;
ram_mon mon;
ram_score score;

function new(virtual ram_if vif_drv,virtual ram_if vif_mon,virtual ram_if vif_ref);
this.vif_drv=vif_drv;
this.vif_mon=vif_mon;
this.vif_ref=vif_ref;
endfunction 

task build();
dr=new();
rs=new();
ms=new();
gd=new();

gen=new(gd);
drv=new(gd,dr,vif_drv);
mon=new(ms,vif_mon );
ref_ob=new(dr,rs,vif_ref);
score=new(rs,ms);
endtask

task start();
fork
gen.start();
drv.start();
ref_ob.start();
mon.start();
score.start();
join
score.compare_report();
endtask

endclass

