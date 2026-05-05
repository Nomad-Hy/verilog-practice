//1bit full adder

module full_adder_1bit(input a, input b,input cin, output sum, output cout );
  
  assign sum=a^b^cin;
  assign cout=(a&b)||(a&cin)||(b&cin);
  
endmodule
