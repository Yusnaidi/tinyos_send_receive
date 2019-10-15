COMPONENT=BasicSendReceiveAppC

CFLAGS += -DCC2420_DEF_RFPOWER=3
PFLAGS += -DCC2420_DEF_CHANNEL=21
CFLAGS += -I$(TOSDIR)/lib/printf

include $(MAKERULES)

# 	   Index   Tx Power  Tx Current
#               [dBm]       [mA]
#		1		-25			8.5
#		2		-15			9.9
#		3		-10			11.2
#		4		-7			12.5
#		5		-5			13.9
#		6		-3			15.2
#		7		-1			16.5
#		8		0			17.4