README for BasicSendReceive

Author/Contact:

  yusnaidi.kl@utm.my

Description:

 This program demonstrate a basic wireless communication between nodes. In this program,
 one node (it can be more than one) is programmed to just send a message to another 
 node (set as node 2). Node 2 is programmed to just received a message sent by the sender node. 
 The communication is said to be unicast. 
  
 The program can be run using the 'printf' java tool provided by the tinyos. 
  
 To test the program, compile and run one mote as:
 $make telosb install,1 bsl,/dev/ttyUSB0
 and watch the output as:
 $java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:telosb | tee output.txt 
  
 Then, compile and run another mote (node 2) as:
 $make telosb install,2 bsl,/dev/ttyUSB1
 and watch the output as:
 $java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB1:telosb | tee output.txt 
 
 Sample output:
 
 On node 1:
 Node 1 booted.
 Data will be sent every 1 sec ...
 Node:1 SEND data: feed
 Send done!
 Node:1 SEND data: feed
 Send done!
 Node:1 SEND data: feed
 Send done!
 Node:1 SEND data: feed
 Send done!
 ...
 
 On node 2:
 Node 2 booted.
 Node:2 RECEIVED data: feed from node:1
 Node:2 RECEIVED data: feed from node:1
 Node:2 RECEIVED data: feed from node:1
 Node:2 RECEIVED data: feed from node:1
 Node:2 RECEIVED data: feed from node:1
 ...


Tools:

  None

Known bugs/limitations:

  None.