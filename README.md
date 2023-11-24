# Intel-8085
VHDL Description of Intel 8085 Microprocessor
-----------------------------------------------------------------------------------------------------------
An overall view of the intel-8085 datapath is available in the Internet. This view and datasheet are used to design datapath and controller. The design is written in Huffman Style.<br />


## 8085 Datapath Diagram:
![Untitled](https://github.com/AmirmahdiJoudi/Intel-8085/assets/79690242/3e4f052f-8eb4-4262-bbf4-50fa2206a9cd)

![Untitled](https://github.com/AmirmahdiJoudi/Intel-8085/assets/79690242/a991df61-843e-47ec-aee4-80b91201da71)


## 8085 Controller State Machine:
![Untitled](https://github.com/AmirmahdiJoudi/Intel-8085/assets/79690242/336d970d-3b00-4ed7-ab69-5b3aedd586a1)


## Implemented Instructions:
![Untitled](https://github.com/AmirmahdiJoudi/Intel-8085/assets/79690242/21cd76a3-5541-4c04-a273-79a3fe6f6ca0)


## Testbench
A memory unit is written. This unit prepares data 20 ns after readmem signal becomes 0. It reads from a hex file and writes data in a separate hex file.
All instructions waveforms are checked by available waveforms in tutorialspoint website. When to issue signals and how the waveforms are now, are exracted from tutorialspoint. There are 2 hex files: mem.hex which includes all instructions and mem1.hex which is the result of executing mem.hex .
Now we test the processor with reguested program. The assembly code is here: 10 data from address 0x0100 to 0x0109 are doubled:<br /><br />
MVI r=B, data=10<br />
LXI rp=DE, data_16=0x0100<br />
LDAX rp=DE<br />
ADD r=A<br />
STAX rp=DE<br />
DCR r=B<br />
INX rp=DE<br />
JNZ addr=0x0005<br />
<br />
The machine code is written in program.hex and the result is in programRes.hex.<br />
<br />
02   &#8594; 04       
05   &#8594; 04     
09   &#8594; 12      
0A  &#8594; 14  
10   &#8594; 20      
20   &#8594; 40       
11   &#8594; 22   
22   &#8594; 44     
33   &#8594; 66
44   &#8594; 88      
<br />
