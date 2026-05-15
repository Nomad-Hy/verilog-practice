module comparator_4bit(input [3:0]a,input [3:0]b,output gt,lt,eq);
  
  assign gt=a>b;
  assign lt=a<b;
  assign eq=a==b;
  
endmodule
