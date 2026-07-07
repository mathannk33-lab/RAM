
class test;
env en;
virtual ram_if vif_drv;
virtual ram_if vif_mon;
virtual ram_if vif_ref;

function new(virtual ram_if vif_drv,virtual ram_if vif_mon,virtual ram_if vif_ref);
this.vif_drv=vif_drv;
this.vif_mon=vif_mon;
this.vif_ref=vif_ref;
endfunction

task start();
en=new(vif_drv,vif_mon,vif_ref);
en.build();
en.start();
endtask

endclass

class test1 extends test;
 ram_trans1 trans;
  function new(virtual ram_if vif_drv,virtual ram_if vif_mon,virtual ram_if vif_ref);
    super.new(vif_drv,vif_mon,vif_ref);
  endfunction

  task start();
    en=new(vif_drv,vif_mon,vif_ref);
    en.build;
    begin 
    trans = new();
    en.gen.gen_trans= trans;
    end
    en.start;
  endtask
endclass


class test2 extends test;
 ram_trans2 trans;
  function new(virtual ram_if vif_drv,virtual ram_if vif_mon,virtual ram_if vif_ref);
    super.new(vif_drv,vif_mon,vif_ref);
  endfunction

  task start();
    en=new(vif_drv,vif_mon,vif_ref);
    en.build;
    begin 
    trans = new();
    en.gen.gen_trans= trans;
    end
    en.start;
  endtask
endclass


class test3 extends test;
 ram_trans3 trans;
  function new(virtual ram_if vif_drv,virtual ram_if vif_mon,virtual ram_if vif_ref);
    super.new(vif_drv,vif_mon,vif_ref);
  endfunction

  task start();
    en=new(vif_drv,vif_mon,vif_ref);
    en.build;
    begin 
    trans = new();
    en.gen.gen_trans= trans;
    end
    en.start;
  endtask
endclass


class test4 extends test;
 ram_trans4 trans;
  function new(virtual ram_if vif_drv,virtual ram_if vif_mon,virtual ram_if vif_ref);
    super.new(vif_drv,vif_mon,vif_ref);
  endfunction

  task start();
    en=new(vif_drv,vif_mon,vif_ref);
    en.build;
    begin 
    trans = new();
    en.gen.gen_trans= trans;
    end
    en.start;
  endtask
endclass

class test5 extends test;
 ram_trans5 trans;
  function new(virtual ram_if vif_drv,virtual ram_if vif_mon,virtual ram_if vif_ref);
    super.new(vif_drv,vif_mon,vif_ref);
  endfunction

  task start();
    en=new(vif_drv,vif_mon,vif_ref);
    en.build;
    begin 
    trans = new();
    en.gen.gen_trans= trans;
    end
    en.start;
  endtask
endclass

class test_regression extends test;
 ram_trans  trans0;
 ram_trans1 trans1;
 ram_trans2 trans2;
 ram_trans3 trans3;
 ram_trans4 trans4;
 ram_trans5 trans5;
  function new(virtual ram_if vif_drv,
               virtual ram_if vif_mon,
               virtual ram_if vif_ref);
    super.new(vif_ref,vif_mon,vif_ref);
  endfunction

  task start();
    //$display("child test");
    en=new(vif_drv,vif_mon,vif_ref);
    en.build;
///////////////////////////////////////////////////////
    begin 
    trans0 = new();
    en.gen.gen_trans= trans0;
    end
    en.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans2 = new();
    en.gen.gen_trans= trans2;
    end
    en.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin 
    trans1 = new();
    en.gen.gen_trans= trans1;
    end
    en.start;
//////////////////////////////////////////////////////
begin
trans4=new();
en.gen.gen_trans=trans4;
end
en.start;
////////////////////////////////////////////////////
begin
trans3=new();
en.gen.gen_trans=trans3;
end
en.start;
///////////////////////////////////////////////////
begin
trans5=new();
en.gen.gen_trans=trans5;
end
en.start;
//////////////////////////////////////////////////
  endtask
endclass

