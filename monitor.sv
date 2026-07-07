
class ram_mon;
ram_trans m_trans;
mailbox #(ram_trans)ms;
virtual ram_if.cb_mon vif;

covergroup cg;
dataout: coverpoint m_trans.read_data_out{bins b={[0:255]};}
endgroup

function new(mailbox #(ram_trans)ms ,virtual ram_if.cb_mon vif);
this.ms=ms;
this.vif=vif;
cg=new();
endfunction

task start();
repeat(4) @(vif.mon);
for(int i=0;i<`num_transactions;i++)begin
m_trans=new();
repeat(1) @(vif.mon);
repeat(1) @(vif.mon);
m_trans.read_data_out=vif.mon.read_data_out;
ms.put(m_trans);
$display("MONITOR PASSING THE DATA TO SCOREBOARD data_out=%0h",m_trans.read_data_out, $time);
cg.sample();
//$display("OUTPUT FUNCTIONAL COVERAGE = %0d",cg.get_coverage());
end
endtask

endclass

