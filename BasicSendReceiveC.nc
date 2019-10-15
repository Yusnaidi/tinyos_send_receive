/*
 * Copyright (c) 2019 Universiti Teknologi Malaysia (UTM)
 * Author: Yusnaidi Md Yusof <yusnaidi.kl@utm.my> <https://people.utm.my/yusnaidi>
 * Date: 2019/10/14
 * Version: 0.0.1
 * Published under the terms of the MIT License.
 *
 * All rights reserved.
 *
 * PERMISSION IS HEREBY GRANTED, FREE OF CHARGE, TO ANY PERSON OBTAINING A COPY
 * OF THIS SOFTWARE AND ASSOCIATED DOCUMENTATION FILES (THE "SOFTWARE"), TO DEAL
 * IN THE SOFTWARE WITHOUT RESTRICTION, INCLUDING WITHOUT LIMITATION THE RIGHTS
 * TO USE, COPY, MODIFY, MERGE, PUBLISH, DISTRIBUTE, SUBLICENSE, AND/OR SELL
 * COPIES OF THE SOFTWARE, AND TO PERMIT PERSONS TO WHOM THE SOFTWARE IS FURNISHED
 * TO DO SO, SUBJECT TO THE FOLLOWING CONDITIONS:
 * 
 * THE ABOVE COPYRIGHT NOTICE AND THIS PERMISSION NOTICE SHALL BE INCLUDED IN ALL
 * COPIES OR SUBSTANTIAL PORTIONS OF THE SOFTWARE.
 *
 * IN NO EVENT SHALL THE UNIVERSITI TEKNOLOGI MALAYSIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITI 
 * TEKNOLOGI MALAYSIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITI TEKNOLOGI MALAYSIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE IS PROVIDED "AS IS", 
 * WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
 * TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 * NONINFRINGEMENT. IN NO EVENT SHALL THE UNIVERSITI TEKNOLOGI MALAYSIA BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH 
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 *
 * This program demonstrate a basic wireless communication between nodes. In this program,
 * one node (it can be more than one) is programmed to just send a message to another 
 * node (set as node 2). Node 2 is programmed to just received a message sent by the sender node. 
 * The communication is said to be unicast. 
 * 
 * The program can be run using the 'printf' java tool provided by the tinyos. 
 * 
 * To test the program, compile and run one mote as:
 * $make telosb install,1 bsl,/dev/ttyUSB0
 * and watch the output as:
 * $java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:telosb | tee output.txt 
 * 
 * Then, compile and run another mote (node 2) as:
 * $make telosb install,2 bsl,/dev/ttyUSB1
 * and watch the output as:
 * $java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB1:telosb | tee output.txt 
 *
 * Sample output:
 *
 * On node 1:
 * Node 1 booted.
 * Data will be sent every 1 sec ...
 * Node:1 SEND data: feed
 * Send done!
 * Node:1 SEND data: feed
 * Send done!
 * Node:1 SEND data: feed
 * Send done!
 * Node:1 SEND data: feed
 * Send done!
 * ...
 *
 * On node 2:
 * Node 2 booted.
 * Node:2 RECEIVED data: feed from node:1
 * Node:2 RECEIVED data: feed from node:1
 * Node:2 RECEIVED data: feed from node:1
 * Node:2 RECEIVED data: feed from node:1
 * Node:2 RECEIVED data: feed from node:1
 * ...
 */

#include <Timer.h>
#include "printf.h"
#include "BasicSendReceive.h"

module BasicSendReceiveC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
}
implementation {

  #define UNICAST_ADDR 2

  message_t pkt;
  bool busy = FALSE;
  
  event void Boot.booted() {
    call AMControl.start();
    printf("Node %d booted.\n", TOS_NODE_ID);
    printfflush();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
      if(TOS_NODE_ID != UNICAST_ADDR){
         printf("Data will be sent every 1 sec ... \n");
         printfflush();
      }
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    if (!busy) {
       BasicSendReceiveMsg* btrpkt = (BasicSendReceiveMsg*)(call Packet.getPayload(&pkt, sizeof(BasicSendReceiveMsg)));
       if(btrpkt == NULL) {
	       return;
       }
       btrpkt->nodeid = TOS_NODE_ID; //this node sending message
       btrpkt->data = 0xFEED;
       if(TOS_NODE_ID != 2){ //node 2 will not send any data, only receive
         if (call AMSend.send(UNICAST_ADDR, &pkt, sizeof(BasicSendReceiveMsg)) == SUCCESS) { //unicastly send packet to node 2
           call Leds.led1Toggle();
           printf("Node:%d SEND data: %x\n", btrpkt->nodeid, btrpkt->data);
           printfflush();
           busy = TRUE;
         }
       }
    }
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
    if(err == SUCCESS){
      printf("Send done!\n");
      printfflush();
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){ //anyone can receive message including node 2
    if (len == sizeof(BasicSendReceiveMsg)) {
       BasicSendReceiveMsg* btrpkt = (BasicSendReceiveMsg*)payload;
       call Leds.led2Toggle();
       printf("Node:%d RECEIVED data: %x from node: %d\n", TOS_NODE_ID, btrpkt->data, btrpkt->nodeid);
       printfflush();
    }
    return msg;
  }
}
