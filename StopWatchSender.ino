#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"
#include "printf.h"

// Function prototypes
void check_radio(void);

// Hardware configuration
RF24 radio(9, 10); // Set up nRF24L01 radio on Arduino SPI bus plus Arduino pins 9(CE) & 10 (CSN)
                   // MOSI on Arduino Pin 11 MISO on Arduino pin 12 SCL on Arduino Pin 13
const byte rf24_interruptPin = 2;// IRQ #0 on Arduino Nano
const byte startButtonPin    = 3;
const byte stopButtonPin     = 4;

byte buttonStatus = 0;

static uint32_t message_count = 0;

byte address[][5] = { 0x01,0x23,0x45,0x67,0x89 , 
                      0x01,0x23,0x45,0x67,0x89
                    };

unsigned long transmissionTime;
unsigned long receiveTime;

/********************** Setup *********************/
8void 
setup() {
    Serial.begin(115200);
    printf_begin();

    pinMode(startButtonPin, INPUT_PULLUP);
    pinMode(stopButtonPin,  INPUT_PULLUP);
    
    Serial.print(F("\n\rRF24/examples/pingpair_irq\n\rSENDER: "));

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
    buttonStatus = (digitalRead(startButtonPin) << 1) | digitalRead(stopButtonPin);
    if(buttonStatus) {
        if(buttonStatus < 0x03) {
            transmissionTime = millis();
            radio.startWrite(&buttonStatus, sizeof(buttonStatus), 0);
            if(buttonStatus & 0x02)
                Serial.print("Start ");
            if(buttonStatus & 0x01)
                Serial.print("Stop  ");
        }
        else {
          Serial.print("Error ");
          Serial.println(buttonStatus);
        }
        delay(50);
        while(buttonStatus) {
            buttonStatus = (digitalRead(startButtonPin) << 1) | digitalRead(stopButtonPin); 
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
