//#define MY_DEBUG

#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"

#ifdef MY_DEBUG
  #include "printf.h"
#endif

// Pinout  nRF24L01:
// 1  GND
// 2  3V3
// 3  CE
// 4  CSN
// 5  SCK
// 6  MOSI
// 7  MISO
// 8  IRQ


// Pinout Arduino Nano
//  9 CE
// 10 CSN
// 11 MOSI
// 12 MISO
// 13 SCK

/*
 * You can have multiple units receive the same broadcast (or multicast) message, 
 * if they are each configured to use the same receive address that the 
 * transmitters is sending to.
 * 
 * Remember that each can have up to 6 configured receive addresses, 
 * so one of the ways to use the device is to configure one receive address 
 * which is unique to a given device, and one receive address which is shared 
 * with other devices (eg: all receivers, so some subset of them). 
 * The transmitter can send to a single receiver by using its unique address, 
 * or to all of the receivers in the group by using the shared address. 
 * ("Multicast" may be a somewhat better description in that it goes to multiple 
 * receivers in this scenario, but it need not go to all receivers you can control 
 * the subset of receivers using a given shared address).
 * 
 * If you are sending a multicast message, it must not use ACK 
 * because multiple receivers would try to send their ACK packets 
 * at about the same time, which would collide. 
 * (Also: since the hardware defined packet structure does not 
 * have a "source" address, the way that Enhanced ShockBurst ACK works 
 * is that the receiver sends the ACK packet to its own address, 
 * and the transmitter must be configured to receive at the address 
 * it's sending to. 
 * Thus in multicast, a given receiver's address 
 * to which it will send an ACK is also the shared receive address for 
 * the other receivers). 
 * So ACK must be off for multicast (as your code says).
 */

enum commands {
    AreYouThere    = 0xAA,
    Stop           = 0x01,
    Start0         = 0x02,
    Start1         = 0x04,
    Start2         = 0x06,
    Start3         = 0x08,
    NewGame        = 0x11,
    RadioInfo      = 0x21,
    Configure      = 0x31,
    Time           = 0x41,
    Possess        = 0x42,
    StartSending   = 0x81,
    StopSending    = 0x82
};


// Function prototypes
void check_radio(void);
void error(int errNum);

//////////////////////////////////////////
// Hardware pin (Arduino) configuration //
//////////////////////////////////////////

// Radio nRF24
RF24 radio(9, 10); // Set up nRF24L01 radio on Arduino SPI bus plus
                   //
                   // Arduino pin    nRF24l01+ pin
                   //------------------------------
                   //  2 (IRQ2)          8 (IRQ)
                   //  9 (CE)            3 (CE)
                   // 10 (CSN)           4 (CSN)
                   // 11 (MOSI)          6 (MOSI)
                   // 12 (MISO)          7 (MISO)
                   // 13 (SCK)           5 (SCK)

 const byte rf24_interruptPin = 2;// IRQ #0 on Arduino Nano

// Push Buttons (All placed in Atmega328p Port D)
const byte stopButtonPin    = 3;
const byte start0ButtonPin  = 4;
const byte start1ButtonPin  = 5;
const byte start2ButtonPin  = 6;
const byte start3ButtonPin  = 7;

// Click on Push
const byte    clickPin         = A0;
unsigned      stopFrq          = 800;
unsigned      start0Frq        = 1000;
unsigned      start1Frq        = 1200;
unsigned      start2Frq        = 1400;
unsigned      start3Frq        = 1600;
unsigned      errFrqOn         = 600;
unsigned      errFrqOff        = 1800;

unsigned long clickDur         = 200UL;

///////////////////////////////////////////////////////////////////////////
// Arduino Pins 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13 Are already occupied //
///////////////////////////////////////////////////////////////////////////

byte buttonStatus = 0;
byte buttonMask   = B11111000;

static uint32_t message_count = 0;

byte address[][5] = { 0x01,0x23,0x45,0x67,0x89 , 
                      0x01,0x23,0x45,0x67,0x89
                    };

#ifdef MY_DEBUG
unsigned long transmissionTime;
unsigned long receiveTime;
#endif

/********************** Setup *********************/
void 
setup() {
  
#ifdef MY_DEBUG
    Serial.begin(115200);
    printf_begin();
#endif

    // All the pins are HIGH if no push button has been pressed
    pinMode(stopButtonPin,   INPUT_PULLUP);
    pinMode(start0ButtonPin, INPUT_PULLUP);
    pinMode(start1ButtonPin, INPUT_PULLUP);
    pinMode(start2ButtonPin, INPUT_PULLUP);
    pinMode(start3ButtonPin, INPUT_PULLUP);
    
#ifdef MY_DEBUG
    Serial.println(F("StopWatchSender"));
#endif

    // Setup and configure rf radio
    radio.begin();  

    radio.setPALevel(RF24_PA_MAX);
    radio.setDataRate(RF24_250KBPS);

    radio.enableDynamicPayloads();// Enable dynamically-sized payloads
    radio.setAutoAck(false);      // Disable Auto Ack   

#ifdef MY_DEBUG
    radio.printDetails();         // Dump the configuration of the rf unit for debugging
#endif
    
    // Open pipes to other node for communication
    radio.openWritingPipe(address[0]);
    radio.openReadingPipe(1, address[1]);
     
    // Attach interrupt handler to interrupt #2 
    // (using pin D2) on BOTH the sender and receiver
    attachInterrupt(digitalPinToInterrupt(rf24_interruptPin), check_radio, LOW);             
}



/********************** Main Loop *********************/
void 
loop() {
    // Reading Port D at once
    buttonStatus = !PIND & buttonMask;
    if(buttonStatus) {
#ifdef MY_DEBUG
        transmissionTime = millis();
#endif
        radio.startWrite(&buttonStatus, sizeof(buttonStatus), 0);
        noTone(clickPin);
        if(buttonStatus      & 1 << stopButtonPin)
          tone(clickPin, stopFrq, clickDur);
        else if(buttonStatus & 1 << start0ButtonPin)
          tone(clickPin, start0Frq, clickDur);
        else if(buttonStatus & 1 << start1ButtonPin)
          tone(clickPin, start1Frq, clickDur);
        else if(buttonStatus & 1 << start2ButtonPin)
          tone(clickPin, start2Frq, clickDur);
        else if(buttonStatus & 1 << start3ButtonPin)
          tone(clickPin, start3Frq, clickDur);
        delay(50);
        while(buttonStatus) {
          buttonStatus = !PIND & buttonMask;
        }
        delay(50);
    }
}


/******* Interrupt Service Routine *********************/
void 
check_radio(void) { // Interrupt Service routine
#ifdef MY_DEBUG
    receiveTime = millis();
#endif
    bool tx, fail, rx;
    radio.whatHappened(tx, fail, rx);// What happened?
    
#ifdef MY_DEBUG
    if(tx) { // Have we successfully transmitted?
        Serial.println(F(" Send OK ")); 
    }
#endif    
    if(fail) { // Have we failed to transmit?
      error(10);
#ifdef MY_DEBUG
        Serial.println(F(" Send Failed !"));
#endif
    }
    
    if(rx || radio.available()) {// Did we receive a message?
        radio.read(&message_count,sizeof(message_count));
#ifdef MY_DEBUG
        Serial.print(F(" Return Time: "));
        Serial.println(receiveTime-transmissionTime);
#endif
    }
}


void
error(int errNum) {
  noTone(clickPin);
  for(int i=0; i< errNum; i++) {
    tone(clickPin, errFrqOn, clickDur);
    delay(clickDur);
    tone(clickPin, errFrqOff, clickDur);
    delay(clickDur);
  }
}

