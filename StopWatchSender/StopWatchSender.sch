EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:switches
LIBS:relays
LIBS:motors
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:libraryIUT
LIBS:mysensors_arduino
LIBS:mysensors_connectors
LIBS:mysensors_logic
LIBS:mysensors_mcu
LIBS:mysensors_memories
LIBS:mysensors_network
LIBS:mysensors_radios
LIBS:mysensors_regulators
LIBS:mysensors_security
LIBS:mysensors_sensors
LIBS:StopWatchSender-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "StopWatch_Sender"
Date "2018-04-19"
Rev "0.0.1"
Comp "Gabriele Salvato"
Comment1 "Stopwatch for Score Panels"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L NRF24L01 U1
U 1 1 5AD8A206
P 7250 2700
F 0 "U1" H 7350 2950 60  0000 C CNN
F 1 "NRF24L01" H 7500 2450 60  0000 C CNN
F 2 "mysensors_radios:NRF24L01" H 7250 2550 60  0000 C CNN
F 3 "" H 7250 2550 60  0000 C CNN
	1    7250 2700
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 5AD8A303
P 4900 4250
F 0 "D1" H 4900 4350 50  0000 C CNN
F 1 "LED" H 4900 4150 50  0000 C CNN
F 2 "LEDs:LED_D4.0mm" H 4900 4250 50  0001 C CNN
F 3 "" H 4900 4250 50  0001 C CNN
	1    4900 4250
	0    -1   -1   0   
$EndComp
$Comp
L R R1
U 1 1 5AD8A41E
P 4900 3950
F 0 "R1" V 4980 3950 50  0000 C CNN
F 1 "R" V 4900 3950 50  0000 C CNN
F 2 "Resistors_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 4830 3950 50  0001 C CNN
F 3 "" H 4900 3950 50  0001 C CNN
	1    4900 3950
	1    0    0    -1  
$EndComp
$Comp
L CP C1
U 1 1 5AD8A4DD
P 7250 2000
F 0 "C1" H 7275 2100 50  0000 L CNN
F 1 "CP" H 7275 1900 50  0000 L CNN
F 2 "Capacitors_THT:CP_Radial_D4.0mm_P1.50mm" H 7288 1850 50  0001 C CNN
F 3 "" H 7250 2000 50  0001 C CNN
	1    7250 2000
	-1   0    0    1   
$EndComp
$Comp
L +5V #PWR01
U 1 1 5AD8AA5B
P 1200 1050
F 0 "#PWR01" H 1200 900 50  0001 C CNN
F 1 "+5V" H 1200 1190 50  0000 C CNN
F 2 "" H 1200 1050 50  0001 C CNN
F 3 "" H 1200 1050 50  0001 C CNN
	1    1200 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1200 1050 1200 1700
Wire Wire Line
	1200 1700 1600 1700
Text Label 3500 1600 0    60   ~ 0
nRF_IRQ
Text Label 7650 2700 0    60   ~ 0
nRF_IRQ
Text Label 3500 2700 0    60   ~ 0
nRF_MISO
Text Label 6850 2600 2    60   ~ 0
nRF_MISO
Text Label 6850 2700 2    60   ~ 0
nRF_MOSI
Text Label 3500 2600 0    60   ~ 0
nRF_MOSI
Text Label 6850 2800 2    60   ~ 0
nRF_SCK
Text Label 3500 2800 0    60   ~ 0
nRF_SCK
Text Label 3500 2300 0    60   ~ 0
nRF_CE
Text Label 7650 2800 0    60   ~ 0
nRF_CE
Text Label 3500 2400 0    60   ~ 0
nRF_CSN
Text Label 7650 2600 0    60   ~ 0
nRF_CSN
Text Label 1600 1400 2    60   ~ 0
3.3V
Text Label 7250 2350 2    60   ~ 0
3.3V
$Comp
L GND #PWR02
U 1 1 5AD8C1C6
P 7250 3050
F 0 "#PWR02" H 7250 2800 50  0001 C CNN
F 1 "GND" H 7250 2900 50  0000 C CNN
F 2 "" H 7250 3050 50  0001 C CNN
F 3 "" H 7250 3050 50  0001 C CNN
	1    7250 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 2350 7250 2150
$Comp
L GND #PWR04
U 1 1 5AD8C98E
P 7650 1850
F 0 "#PWR04" H 7650 1600 50  0001 C CNN
F 1 "GND" H 7650 1700 50  0000 C CNN
F 2 "" H 7650 1850 50  0001 C CNN
F 3 "" H 7650 1850 50  0001 C CNN
	1    7650 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 1850 7650 1850
Text Label 3500 1700 0    60   ~ 0
PB_Stop
Text Label 3500 1800 0    60   ~ 0
PB_Start0
Text Label 3500 1900 0    60   ~ 0
PB_Start1
Text Label 3500 2000 0    60   ~ 0
PB_Start2
Text Label 3500 2100 0    60   ~ 0
PB_Start3
NoConn ~ 1600 3200
NoConn ~ 1600 3300
NoConn ~ 3500 3700
NoConn ~ 3500 3100
NoConn ~ 3500 3200
NoConn ~ 3500 3300
NoConn ~ 3500 3400
NoConn ~ 3500 3500
NoConn ~ 3500 3600
Text Label 3500 2200 0    60   ~ 0
R_LedClick
Text Label 4900 3800 1    60   ~ 0
R_LedClick
$Comp
L GND #PWR05
U 1 1 5AD8D2F2
P 4900 4400
F 0 "#PWR05" H 4900 4150 50  0001 C CNN
F 1 "GND" H 4900 4250 50  0000 C CNN
F 2 "" H 4900 4400 50  0001 C CNN
F 3 "" H 4900 4400 50  0001 C CNN
	1    4900 4400
	1    0    0    -1  
$EndComp
$Comp
L Conn_01x02_Male J1
U 1 1 5AD8D3A1
P 4100 4050
F 0 "J1" H 4100 4150 50  0000 C CNN
F 1 "Conn_01x02_Male" H 4100 3850 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02_Pitch2.54mm" H 4100 4050 50  0001 C CNN
F 3 "" H 4100 4050 50  0001 C CNN
	1    4100 4050
	0    1    1    0   
$EndComp
$Comp
L GND #PWR06
U 1 1 5AD8D652
P 4100 4250
F 0 "#PWR06" H 4100 4000 50  0001 C CNN
F 1 "GND" H 4100 4100 50  0000 C CNN
F 2 "" H 4100 4250 50  0001 C CNN
F 3 "" H 4100 4250 50  0001 C CNN
	1    4100 4250
	1    0    0    -1  
$EndComp
Text Label 3500 3000 0    60   ~ 0
Click_Amp
Text Label 4000 4250 3    60   ~ 0
Click_Amp
$Comp
L PWR_FLAG #FLG07
U 1 1 5AD8D983
P 5300 800
F 0 "#FLG07" H 5300 875 50  0001 C CNN
F 1 "PWR_FLAG" H 5300 950 50  0000 C CNN
F 2 "" H 5300 800 50  0001 C CNN
F 3 "" H 5300 800 50  0001 C CNN
	1    5300 800 
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG08
U 1 1 5AD8D9B6
P 5750 800
F 0 "#FLG08" H 5750 875 50  0001 C CNN
F 1 "PWR_FLAG" H 5750 950 50  0000 C CNN
F 2 "" H 5750 800 50  0001 C CNN
F 3 "" H 5750 800 50  0001 C CNN
	1    5750 800 
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR09
U 1 1 5AD8DA5D
P 5750 800
F 0 "#PWR09" H 5750 550 50  0001 C CNN
F 1 "GND" H 5750 650 50  0000 C CNN
F 2 "" H 5750 800 50  0001 C CNN
F 3 "" H 5750 800 50  0001 C CNN
	1    5750 800 
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR010
U 1 1 5AD8DDA9
P 5300 800
F 0 "#PWR010" H 5300 650 50  0001 C CNN
F 1 "+5V" H 5300 940 50  0000 C CNN
F 2 "" H 5300 800 50  0001 C CNN
F 3 "" H 5300 800 50  0001 C CNN
	1    5300 800 
	-1   0    0    1   
$EndComp
NoConn ~ 3500 1400
NoConn ~ 3500 1500
$Comp
L Conn_01x06 J2
U 1 1 5AD9B7F7
P 6000 3550
F 0 "J2" H 6000 3850 50  0000 C CNN
F 1 "Conn_01x06" H 6000 3150 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x06_Pitch2.54mm" H 6000 3550 50  0001 C CNN
F 3 "" H 6000 3550 50  0001 C CNN
	1    6000 3550
	0    1    1    0   
$EndComp
Text Label 5800 3350 1    60   ~ 0
PB_Stop
Text Label 5900 3350 1    60   ~ 0
PB_Start0
Text Label 6000 3350 1    60   ~ 0
PB_Start1
Text Label 6100 3350 1    60   ~ 0
PB_Start2
Text Label 6200 3350 1    60   ~ 0
PB_Start3
$Comp
L GND #PWR011
U 1 1 5AD9B9F1
P 5400 3550
F 0 "#PWR011" H 5400 3300 50  0001 C CNN
F 1 "GND" H 5400 3400 50  0000 C CNN
F 2 "" H 5400 3550 50  0001 C CNN
F 3 "" H 5400 3550 50  0001 C CNN
	1    5400 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 3350 5400 3350
Wire Wire Line
	5400 3350 5400 3550
$Comp
L ArduinoProMini IC1
U 1 1 5AD8A133
P 2500 2500
F 0 "IC1" H 1750 3750 40  0000 L BNN
F 1 "ArduinoProMini" H 2900 1100 40  0000 L BNN
F 2 "mysensors_arduino:pro_mini" H 2500 2500 30  0001 C CIN
F 3 "" H 2500 2500 60  0000 C CNN
	1    2500 2500
	1    0    0    -1  
$EndComp
NoConn ~ 2050 -400
$Comp
L GND #PWR?
U 1 1 5AD9C43E
P 1050 3700
F 0 "#PWR?" H 1050 3450 50  0001 C CNN
F 1 "GND" H 1050 3550 50  0000 C CNN
F 2 "" H 1050 3700 50  0001 C CNN
F 3 "" H 1050 3700 50  0001 C CNN
	1    1050 3700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5AD9C41E
P 1350 3700
F 0 "#PWR?" H 1350 3450 50  0001 C CNN
F 1 "GND" H 1350 3550 50  0000 C CNN
F 2 "" H 1350 3700 50  0001 C CNN
F 3 "" H 1350 3700 50  0001 C CNN
	1    1350 3700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 5AD8C6A1
P 1600 3700
F 0 "#PWR03" H 1600 3450 50  0001 C CNN
F 1 "GND" H 1600 3550 50  0000 C CNN
F 2 "" H 1600 3700 50  0001 C CNN
F 3 "" H 1600 3700 50  0001 C CNN
	1    1600 3700
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 3600 1350 3600
Wire Wire Line
	1350 3600 1350 3700
Wire Wire Line
	1600 3500 1050 3500
Wire Wire Line
	1050 3500 1050 3700
$EndSCHEMATC
