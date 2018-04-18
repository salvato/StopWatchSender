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
LIBS:mysensors_arduino
LIBS:mysensors_radios
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ArduinoProMini IC?
U 1 1 5AD6FFE1
P 3800 2450
F 0 "IC?" H 3050 3700 40  0000 L BNN
F 1 "ArduinoProMini" H 4200 1050 40  0000 L BNN
F 2 "mysensors_arduino:pro_mini_china" H 3800 2450 30  0001 C CIN
F 3 "" H 3800 2450 60  0000 C CNN
	1    3800 2450
	1    0    0    -1  
$EndComp
$Comp
L NRF24L01 U?
U 1 1 5AD70163
P 6600 2400
F 0 "U?" H 6700 2650 60  0000 C CNN
F 1 "NRF24L01" H 6850 2150 60  0000 C CNN
F 2 "" H 6600 2250 60  0000 C CNN
F 3 "" H 6600 2250 60  0000 C CNN
	1    6600 2400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5AD702E3
P 6600 2750
F 0 "#PWR?" H 6600 2500 50  0001 C CNN
F 1 "GND" H 6600 2600 50  0000 C CNN
F 2 "" H 6600 2750 50  0001 C CNN
F 3 "" H 6600 2750 50  0001 C CNN
	1    6600 2750
	1    0    0    -1  
$EndComp
$Comp
L Barrel_Jack J?
U 1 1 5AD712E8
P 1800 1750
F 0 "J?" H 1800 1960 50  0000 C CNN
F 1 "Barrel_Jack" H 1800 1575 50  0000 C CNN
F 2 "" H 1850 1710 50  0001 C CNN
F 3 "" H 1850 1710 50  0001 C CNN
	1    1800 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 2650 5650 2650
Wire Wire Line
	5650 2650 5650 2300
Wire Wire Line
	5650 2300 6200 2300
Wire Wire Line
	4800 2550 5800 2550
Wire Wire Line
	5800 2550 5800 2400
Wire Wire Line
	5800 2400 6200 2400
Wire Wire Line
	4800 2750 5950 2750
Wire Wire Line
	5950 2750 5950 2500
Wire Wire Line
	5950 2500 6200 2500
Wire Wire Line
	4800 1550 7300 1550
Wire Wire Line
	7300 1550 7300 2400
Wire Wire Line
	7300 2400 7000 2400
Wire Wire Line
	4800 2250 5250 2250
Wire Wire Line
	5250 2250 5250 3100
Wire Wire Line
	7000 3100 7000 2500
Wire Wire Line
	4800 2350 5450 2350
Wire Wire Line
	5450 2350 5450 1750
Wire Wire Line
	5450 1750 7000 1750
Wire Wire Line
	7000 1750 7000 2300
Wire Wire Line
	5250 3100 7000 3100
Wire Wire Line
	2900 1350 2900 1000
Wire Wire Line
	2900 1000 6600 1000
Wire Wire Line
	6600 1000 6600 2050
Wire Wire Line
	2100 1650 2900 1650
Wire Wire Line
	2100 1850 2100 3900
Wire Wire Line
	2100 3450 2900 3450
$Comp
L GND #PWR?
U 1 1 5AD717D9
P 2100 3900
F 0 "#PWR?" H 2100 3650 50  0001 C CNN
F 1 "GND" H 2100 3750 50  0000 C CNN
F 2 "" H 2100 3900 50  0001 C CNN
F 3 "" H 2100 3900 50  0001 C CNN
	1    2100 3900
	1    0    0    -1  
$EndComp
Connection ~ 2100 3450
$EndSCHEMATC
