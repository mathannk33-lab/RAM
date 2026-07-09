
class ram_trans;
rand logic write_en;
rand logic read_en;
rand logic [`DATA_WIDTH-1:0]write_data;
rand logic [ADDRESS_WIDTH-1:0]add; 
logic [`DATA_WIDTH-1:0]read_data_out;

//constraint c{{write_en,read_en}!=2'b11;}
constraint c5{unique{write_data};}
constraint c6{unique{add};}

virtual function ram_trans copy();
copy =new();
copy.write_en=this.write_en;
copy.read_en=this.read_en;
copy.write_data=this.write_data;
copy.add=this.add;
endfunction

endclass

class ram_trans1 extends ram_trans;
constraint c{{write_en,read_en}==2'b01;}
virtual function ram_trans copy();
ram_trans copy1;
copy1=new();
copy1.write_en=this.write_en;
copy1.read_en=this.read_en;
copy1.write_data=this.write_data;
copy1.add=this.add;
return copy1;
endfunction

endclass

class ram_trans2 extends ram_trans;
constraint c1{{write_en,read_en}==2'b10;}
virtual function ram_trans copy();
ram_trans copy2;
copy2=new();
copy2.write_en=this.write_en;
copy2.read_en=this.read_en;
copy2.write_data=this.write_data;
copy2.add=this.add;
return copy2;
endfunction

endclass

class ram_trans3 extends ram_trans;
constraint c{{write_en,read_en}==2'b10;}
constraint c1{unique{add};}
virtual function ram_trans copy();
ram_trans copy3;
copy3=new();
copy3.write_en=this.write_en;
copy3.read_en=this.read_en;
copy3.write_data=this.write_data;
copy3.add=this.add;
return copy3;
endfunction
endclass


class ram_trans4 extends ram_trans;
constraint c{{write_en,read_en}==2'b01;}
constraint c1{unique{add};}
virtual function ram_trans copy();
ram_trans copy4;
copy4=new();
copy4.write_en=this.write_en;
copy4.read_en=this.read_en;
copy4.write_data=this.write_data;
copy4.add=this.add;
return copy4;
endfunction
endclass


class ram_trans5 extends ram_trans;
bit [1:0] prev;
bit first=1;
constraint c{{write_en,read_en}inside {2'b10,2'b01};}
constraint c3{add ==1;}
constraint c2{
if(!first)
{write_en,read_en}!=prev;
}

function void post_randomize();
prev={write_en,read_en};
first=0;
endfunction

virtual function ram_trans copy();
ram_trans copy5;
copy5=new();
copy5.write_en=this.write_en;
copy5.read_en=this.read_en;
copy5.write_data=this.write_data;
copy5.add=this.add;
return copy5;
endfunction
endclass


















































 
