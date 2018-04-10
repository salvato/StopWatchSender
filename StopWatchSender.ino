#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"
#include "printf.h"

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
    Start          = 0x02,
    Start24        = 0x04,
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

// Hardware pin (Arduino) configuration
// Radio nRF24
RF24 radio(9, 10); // Set up nRF24L01 radio on Arduino SPI bus plus Arduino pins 9(CE) & 10 (CSN)
                   // MOSI on Arduino Pin 11 MISO on Arduino pin 12 SCL on Arduino Pin 13
const byte rf24_interruptPin = 2;// IRQ #0 on Arduino Nano

// Push Buttons
const byte stopButtonPin    = 3;
const byte startButtonPin   = 4;
const byte start24ButtonPin = 5;
const byte clickPin         = 6;
unsigned   startFrq         = 1000;
unsigned   stopFrq          = 800;
unsigned   start24Frw       = 1200;
unsigned long clickDur      = 200UL;

////////////////////////////////////////////////////////////////////////
// Arduino Pins 2, 3, 4, 5, 6, 9, 10, 11, 12, 13 Are already occupied //
////////////////////////////////////////////////////////////////////////

byte buttonStatus = 0;

static uint32_t message_count = 0;

byte address[][5] = { 0x01,0x23,0x45,0x67,0x89 , 
                      0x01,0x23,0x45,0x67,0x89
                    };

unsigned long transmissionTime;
unsigned long receiveTime;

/********************** Setup *********************/
void 
setup() {
    Serial.begin(115200);
    printf_begin();

    pinMode(stopButtonPin,    INPUT_PULLUP);
    pinMode(startButtonPin,   INPUT_PULLUP);
    pinMode(start24ButtonPin, INPUT_PULLUP);
    
    Serial.println(F("/home/gabriele/qtprojects/Arduino/StopWatchSender"));

    // Setup and configure rf radio
    radio.begin();  

    radio.setPALevel(RF24_PA_MAX);
    radio.setDataRate(RF24_250KBPS);

    radio.enableDynamicPayloads();// Enable dynamically-sized payloads
    radio.setAutoAck(false);      // Disable Auto Ack   
    //radio.printDetails();         // Dump the configuration of the rf unit for debugging
    
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
    buttonStatus = (!digitalRead(start24ButtonPin) << 2) | 
                   (!digitalRead(startButtonPin)   << 1) | 
                    !digitalRead(stopButtonPin);
    if(buttonStatus) {
        if(buttonStatus < 0x07) {
            transmissionTime = millis();
            radio.startWrite(&buttonStatus, sizeof(buttonStatus), 0);
        }
        else {
          Serial.print("Error ");
          Serial.println(buttonStatus);
        }
        noTone(clickPin);
        if(buttonStatus & 0x04)
          tone(clickPin, start24Frw, clickDur);
        else if(buttonStatus & 0x02)
          tone(clickPin, startFrq, clickDur);
        else if(buttonStatus & 0x01)
          tone(clickPin, stopFrq, clickDur);
        delay(50);
        while(buttonStatus) {
          buttonStatus = (!digitalRead(start24ButtonPin) << 2) | 
                         (!digitalRead(startButtonPin)   << 1) | 
                          !digitalRead(stopButtonPin);

        }
        delay(50);
    }
}


/******* Interrupt Service Routine *********************/
void 
check_radio(void) { // Interrupt Service routine
    receiveTime = millis();
    bool tx, fail, rx;
    radio.whatHappened(tx, fail, rx);// What happened?
    
    if(tx) { // Have we successfully transmitted?
        //Serial.println(F(" Send OK ")); 
    }
    
    if(fail) { // Have we failed to transmit?
        Serial.println(F(" Send Failed !"));  
    }
    
    if(rx || radio.available()) {// Did we receive a message?
        radio.read(&message_count,sizeof(message_count));
        Serial.print(F(" Return Time: "));
        Serial.println(receiveTime-transmissionTime);
    }
}


