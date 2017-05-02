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


enum commands {
  AreYouThere    = 0xAA,
  Stop           = 0x01,
  Start          = 0x02,
  NewPeriod      = 0x11,
  RadioInfo      = 0x21,
  StopSending    = 0x81
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
const byte start14ButtonPin = 5;

/////////////////////////////////////////////////////////////////////
// Arduino Pins 2, 3, 4, 5, 9, 10, 11, 12, 13 Are already occupied //
/////////////////////////////////////////////////////////////////////

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
    pinMode(start14ButtonPin, INPUT_PULLUP);
    
    Serial.println(F("/home/gabriele/qtprojects/Arduino/StopWatchSender"));

    // Setup and configure rf radio
    radio.begin();  

    radio.setPALevel(RF24_PA_MAX);
    radio.setDataRate(RF24_250KBPS);

    radio.enableAckPayload();     // We will be using the Ack Payload feature, so please enable it
    radio.enableDynamicPayloads();// Ack payloads are dynamic payloads
    radio.printDetails();         // Dump the configuration of the rf unit for debugging
    
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
    buttonStatus = (digitalRead(start14ButtonPin) << 2) | 
                   (digitalRead(startButtonPin)   << 1) | 
                    digitalRead(stopButtonPin);
    if(buttonStatus) {
        if(buttonStatus < 0x07) {
            transmissionTime = millis();
            radio.startWrite(&buttonStatus, sizeof(buttonStatus), 0);
        }
        else {
          Serial.print("Error ");
          Serial.println(buttonStatus);
        }
        delay(50);
        while(buttonStatus) {
          buttonStatus = (digitalRead(start14ButtonPin) << 2) | 
                         (digitalRead(startButtonPin)   << 1) | 
                          digitalRead(stopButtonPin);
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
        Serial.print(F(" Send OK ")); 
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
