
class ram_score;
ram_trans rs_trans,ms_trans;

mailbox #(ram_trans) rs;
mailbox #(ram_trans) ms;

logic [`DATA_WIDTH-1:0] mem_rs [`DATA_DEPTH-1:0];
logic [`DATA_WIDTH-1:0] mem_ms [`DATA_DEPTH-1:0];

int MATCH;
int MISMATCH;

function  new(mailbox #(ram_trans)  rs,mailbox #(ram_trans) ms);
this.rs=rs;
this.ms=ms;
endfunction

task start();
for(int i=0;i<`num_transactions;i++)
begin
rs_trans=new();
ms_trans=new();
fork 
begin
rs.get(rs_trans);
mem_rs[rs_trans.add]=rs_trans.read_data_out;
$display("############SCOREBOARD REF data_out=%0h, ADDRESS=%0h ###############", mem_rs[rs_trans.add], rs_trans.add, $time);
end
begin
ms.get(ms_trans);
mem_ms[ms_trans.add]=ms_trans.read_data_out;
$display("############SCOREBOARD MON data_out=%0h, ADDRESS=%0h ###############", mem_ms[ms_trans.add], ms_trans.add, $time);
end
join
if(i!=(`num_transactions-1))
compare_report();
end
endtask

task compare_report();
if(mem_rs[rs_trans.add]===mem_ms[ms_trans.add])
begin
 $display("SCOREBOARD REF data_out=%0h, MON data_out=%0h", mem_rs[rs_trans.add], mem_ms[ms_trans.add], $time);
 ++MATCH;
 $display("DATA MATCH SUCCESSFUL. MATCH count = %0d",MATCH);
 end
else
begin
$display("SCOREBOARD REF data_out=%0h, MON data_out=%0h", mem_rs[rs_trans.add], mem_ms[ms_trans.add], $time);
 ++MISMATCH;
 $display("DATA MATCH FAILURE. MISMATCH count = %0d",MISMATCH);
 end
endtask

endclass


