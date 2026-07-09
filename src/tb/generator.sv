
class ram_gen;
ram_trans gen_trans;

mailbox #(ram_trans) gd;

function new(mailbox #(ram_trans) mb);
this.gd=mb;
gen_trans=new();
endfunction

task start();
for(int i=0;i<`num_transactions;i++)begin
assert(gen_trans.randomize());
gd.put(gen_trans.copy());
$display("GENERATOR Randomized transaction write_data=%0h, write_en=%0d, read_en=%0d, address=%0h", gen_trans.write_data, gen_trans.write_en, gen_trans.read_en, gen_trans.add, $time);
end
endtask

endclass
 
