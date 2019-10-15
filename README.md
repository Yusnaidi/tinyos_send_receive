# tinyos_send_receive
nesC TinyOS program to demonstrate basic wireless communication using TelosB sensor motes 

 This program demonstrate a basic wireless communication between nodes. In this program,
 one node (it can be more than one) is programmed to just send a message to another 
 node (set as node 2). Node 2 is programmed to just received a message sent by the sender node. 
 The communication is said to be unicast. 
  
 The program can be run using the 'printf' java tool provided by the tinyos. 
  
 To test the program, compile and run one mote as:<br>
 $make telosb install,1 bsl,/dev/ttyUSB0<br>
 and watch the output as:<br>
 $java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:telosb | tee output-node1.txt<br> 
  
 Then, compile and run another mote (node 2) as:<br>
 $make telosb install,2 bsl,/dev/ttyUSB1<br>
 and watch the output as:<br>
 $java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB1:telosb | tee output-node2.txt 
 
 Sample output:
 
 On node 1:<br>
 Node 1 booted.<br>
 Data will be sent every 1 sec ...<br>
 Node:1 SEND data: feed<br>
 Send done!<br>
 Node:1 SEND data: feed<br>
 Send done!<br>
 Node:1 SEND data: feed<br>
 Send done!<br>
 Node:1 SEND data: feed<br>
 Send done!<br>
 ...
 
 On node 2:<br>
 Node 2 booted.<br>
 Node:2 RECEIVED data: feed from node:1<br>
 Node:2 RECEIVED data: feed from node:1<br>
 Node:2 RECEIVED data: feed from node:1<br>
 Node:2 RECEIVED data: feed from node:1<br>
 Node:2 RECEIVED data: feed from node:1<br>
 ...
