
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATtiny24
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny24
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Uc_Positive_24_Over=R3
	.DEF _Uc_Positive_24_Under=R2
	.DEF _Uc_Positive_12_Over=R5
	.DEF _Uc_Positive_12_Under=R4
	.DEF _Uc_Positive_6_Over=R7
	.DEF _Uc_Positive_6_Under=R6
	.DEF _Uc_Negative_12_Over=R9
	.DEF _Uc_Negative_12_Under=R8
	.DEF _Uc_Negative_6_Over=R11
	.DEF _Uc_Negative_6_Under=R10
	.DEF _Uint_Warning_Count=R12
	.DEF _Uint_Warning_Count_msb=R13

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x90,0x1


__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  0x02
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : AC_Power_Supply_Fix_Protect
;Version : 1.0
;Date    : 11/28/2018
;Author  :
;Company :
;Comments:
;Bao ve nguon AC 6VAC/1A, 12VAC/1A, 24VAC/6A
;Phat canh bao va bao ve nguon khi dong dien vuot 20%
;
;Chip type               : ATtiny24
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*******************************************************/
;
;#include <tiny24.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;
;#define ADC_POSITIVE_24 1
;#define ADC_POSITIVE_12 2
;#define ADC_POSITIVE_6  3
;#define ADC_NEGATIVE_6  4
;#define ADC_NEGATIVE_12 5
;#define ADC_SET 7
;
;#define CONTROL_24  PORTB.0
;#define CONTROL_UNDER_24    PORTB.2
;#define CONTROL_BUZZER  PORTB.1
;
;#define CONTROL_24_ON   CONTROL_24 = 0
;#define CONTROL_24_OFF  CONTROL_24 = 1
;
;#define CONTROL_UNDER_24_ON     CONTROL_UNDER_24 = 0
;#define CONTROL_UNDER_24_OFF    CONTROL_UNDER_24 = 1
;
;#define CONTROL_BUZZER_ON   CONTROL_BUZZER = 1
;#define CONTROL_BUZZER_OFF  CONTROL_BUZZER = 0
;
;#define ADC_POSITIVE_24_SET_OVER   300
;#define ADC_POSITIVE_12_SET_OVER   50
;#define ADC_POSITIVE_6_SET_OVER    52
;#define ADC_NEGATIVE_6_SET_OVER    52
;#define ADC_NEGATIVE_12_SET_OVER   52
;
;#define TIME_WARNING    400
;#define TIME_BUZZER     50
;
;bit Bit_Positive_24_Warning = 0;
;bit Bit_Positive_12_Warning = 0;
;bit Bit_Positive_6_Warning = 0;
;bit Bit_Negative_12_Warning = 0;
;bit Bit_Negative_6_Warning = 0;
;
;unsigned char   Uc_Positive_24_Over = 0;
;unsigned char   Uc_Positive_24_Under = 0;
;
;unsigned char   Uc_Positive_12_Over = 0;
;unsigned char   Uc_Positive_12_Under = 0;
;
;unsigned char   Uc_Positive_6_Over = 0;
;unsigned char   Uc_Positive_6_Under = 0;
;
;unsigned char   Uc_Negative_12_Over = 0;
;unsigned char   Uc_Negative_12_Under = 0;
;
;unsigned char   Uc_Negative_6_Over = 0;
;unsigned char   Uc_Negative_6_Under = 0;
;
;unsigned int    Uint_Warning_Count = TIME_WARNING;
;
;// Declare your global variables here
;
;// // Voltage Reference: AVCC pin
;// #define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0))
;
;// // Read the AD conversion result
;// unsigned int read_adc(unsigned char adc_input)
;// {
;//     ADMUX=(adc_input & 0x3f) | ADC_VREF_TYPE;
;//     // Delay needed for the stabilization of the ADC input voltage
;//     delay_us(10);
;//     // Start the AD conversion
;//     ADCSRA|=(1<<ADSC);
;//     // Wait for the AD conversion to complete
;//     while ((ADCSRA & (1<<ADIF))==0);
;//     ADCSRA|=(1<<ADIF);
;//     return ADCW;
;// }
;
;// Voltage Reference: 1.1V, AREF discon.
;#define ADC_VREF_TYPE ((1<<REFS1) | (0<<REFS0))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0069 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 006A ADMUX=(adc_input & 0x3f) | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x3F)
	ORI  R30,0x80
	OUT  0x7,R30
; 0000 006B // Delay needed for the stabilization of the ADC input voltage
; 0000 006C delay_us(10);
	__DELAY_USB 27
; 0000 006D // Start the AD conversion
; 0000 006E ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 006F // Wait for the AD conversion to complete
; 0000 0070 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0071 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0072 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0073 }
; .FEND
;
;void    PROTECT(void)
; 0000 0076 {
_PROTECT:
; .FSTART _PROTECT
; 0000 0077     unsigned int Uint_ADC_value;
; 0000 0078     unsigned int Uint_ADC_set_value;
; 0000 0079 
; 0000 007A     Uint_ADC_value = read_adc(ADC_POSITIVE_24);
	RCALL __SAVELOCR4
;	Uint_ADC_value -> R16,R17
;	Uint_ADC_set_value -> R18,R19
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x0
; 0000 007B     if(Uint_ADC_value > ADC_POSITIVE_24_SET_OVER)
	__CPWRN 16,17,301
	BRLO _0x6
; 0000 007C     {
; 0000 007D         Uc_Positive_24_Over++;
	INC  R3
; 0000 007E         if(Uc_Positive_24_Over > 10)
	LDI  R30,LOW(10)
	CP   R30,R3
	BRSH _0x7
; 0000 007F         {
; 0000 0080             Uc_Positive_24_Over = 11;
	LDI  R30,LOW(11)
	MOV  R3,R30
; 0000 0081             Uc_Positive_24_Under = 0;
	CLR  R2
; 0000 0082             Bit_Positive_24_Warning = 1;
	SBI  0x13,0
; 0000 0083         }
; 0000 0084     }
_0x7:
; 0000 0085     else
	RJMP _0xA
_0x6:
; 0000 0086     {
; 0000 0087         Uc_Positive_24_Under++;
	INC  R2
; 0000 0088         if(Uc_Positive_24_Under > 10)
	LDI  R30,LOW(10)
	CP   R30,R2
	BRSH _0xB
; 0000 0089         {
; 0000 008A             Uc_Positive_24_Under = 11;
	LDI  R30,LOW(11)
	MOV  R2,R30
; 0000 008B             Uc_Positive_24_Over = 0;
	CLR  R3
; 0000 008C             Bit_Positive_24_Warning = 0;
	CBI  0x13,0
; 0000 008D         }
; 0000 008E     }
_0xB:
_0xA:
; 0000 008F 
; 0000 0090     Uint_ADC_value = read_adc(ADC_POSITIVE_12);
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x0
; 0000 0091     if(Uint_ADC_value > ADC_POSITIVE_12_SET_OVER)
	__CPWRN 16,17,51
	BRLO _0xE
; 0000 0092     {
; 0000 0093         Uc_Positive_12_Over++;
	INC  R5
; 0000 0094         if(Uc_Positive_12_Over > 10)
	LDI  R30,LOW(10)
	CP   R30,R5
	BRSH _0xF
; 0000 0095         {
; 0000 0096             Uc_Positive_12_Over = 11;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 0097             Uc_Positive_12_Under = 0;
	CLR  R4
; 0000 0098             Bit_Positive_12_Warning = 1;
	SBI  0x13,1
; 0000 0099         }
; 0000 009A     }
_0xF:
; 0000 009B     else
	RJMP _0x12
_0xE:
; 0000 009C     {
; 0000 009D         Uc_Positive_12_Under++;
	INC  R4
; 0000 009E         if(Uc_Positive_12_Under > 10)
	LDI  R30,LOW(10)
	CP   R30,R4
	BRSH _0x13
; 0000 009F         {
; 0000 00A0             Uc_Positive_12_Under = 11;
	LDI  R30,LOW(11)
	MOV  R4,R30
; 0000 00A1             Uc_Positive_12_Over = 0;
	CLR  R5
; 0000 00A2             Bit_Positive_12_Warning = 0;
	CBI  0x13,1
; 0000 00A3         }
; 0000 00A4     }
_0x13:
_0x12:
; 0000 00A5 
; 0000 00A6     Uint_ADC_value = read_adc(ADC_POSITIVE_6);
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x0
; 0000 00A7     if(Uint_ADC_value > ADC_POSITIVE_6_SET_OVER)
	RCALL SUBOPT_0x1
	BRLO _0x16
; 0000 00A8     {
; 0000 00A9         Uc_Positive_6_Over++;
	INC  R7
; 0000 00AA         if(Uc_Positive_6_Over > 10)
	LDI  R30,LOW(10)
	CP   R30,R7
	BRSH _0x17
; 0000 00AB         {
; 0000 00AC             Uc_Positive_6_Over = 11;
	LDI  R30,LOW(11)
	MOV  R7,R30
; 0000 00AD             Uc_Positive_6_Under = 0;
	CLR  R6
; 0000 00AE             Bit_Positive_6_Warning = 1;
	SBI  0x13,2
; 0000 00AF         }
; 0000 00B0     }
_0x17:
; 0000 00B1     else
	RJMP _0x1A
_0x16:
; 0000 00B2     {
; 0000 00B3         Uc_Positive_6_Under++;
	INC  R6
; 0000 00B4         if(Uc_Positive_6_Under > 10)
	LDI  R30,LOW(10)
	CP   R30,R6
	BRSH _0x1B
; 0000 00B5         {
; 0000 00B6             Uc_Positive_6_Under = 11;
	LDI  R30,LOW(11)
	MOV  R6,R30
; 0000 00B7             Uc_Positive_6_Over = 0;
	CLR  R7
; 0000 00B8             Bit_Positive_6_Warning = 0;
	CBI  0x13,2
; 0000 00B9         }
; 0000 00BA     }
_0x1B:
_0x1A:
; 0000 00BB 
; 0000 00BC 
; 0000 00BD     Uint_ADC_value = read_adc(ADC_NEGATIVE_12);
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x0
; 0000 00BE     if(Uint_ADC_value > ADC_NEGATIVE_12_SET_OVER)
	RCALL SUBOPT_0x1
	BRLO _0x1E
; 0000 00BF     {
; 0000 00C0         Uc_Negative_12_Over++;
	INC  R9
; 0000 00C1         if(Uc_Negative_12_Over > 10)
	LDI  R30,LOW(10)
	CP   R30,R9
	BRSH _0x1F
; 0000 00C2         {
; 0000 00C3             Uc_Negative_12_Over = 11;
	LDI  R30,LOW(11)
	MOV  R9,R30
; 0000 00C4             Uc_Negative_12_Under = 0;
	CLR  R8
; 0000 00C5             Bit_Negative_12_Warning = 1;
	SBI  0x13,3
; 0000 00C6         }
; 0000 00C7     }
_0x1F:
; 0000 00C8     else
	RJMP _0x22
_0x1E:
; 0000 00C9     {
; 0000 00CA         Uc_Negative_12_Under++;
	INC  R8
; 0000 00CB         if(Uc_Negative_12_Under > 10)
	LDI  R30,LOW(10)
	CP   R30,R8
	BRSH _0x23
; 0000 00CC         {
; 0000 00CD             Uc_Negative_12_Under = 11;
	LDI  R30,LOW(11)
	MOV  R8,R30
; 0000 00CE             Uc_Negative_12_Over = 0;
	CLR  R9
; 0000 00CF             Bit_Negative_12_Warning = 0;
	CBI  0x13,3
; 0000 00D0         }
; 0000 00D1     }
_0x23:
_0x22:
; 0000 00D2 
; 0000 00D3 
; 0000 00D4     Uint_ADC_value = read_adc(ADC_NEGATIVE_6);
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x0
; 0000 00D5     if(Uint_ADC_value > ADC_NEGATIVE_6_SET_OVER)
	RCALL SUBOPT_0x1
	BRLO _0x26
; 0000 00D6     {
; 0000 00D7         Uc_Negative_6_Over++;
	INC  R11
; 0000 00D8         if(Uc_Negative_6_Over > 10)
	LDI  R30,LOW(10)
	CP   R30,R11
	BRSH _0x27
; 0000 00D9         {
; 0000 00DA             Uc_Negative_6_Over = 11;
	LDI  R30,LOW(11)
	MOV  R11,R30
; 0000 00DB             Uc_Negative_6_Under = 0;
	CLR  R10
; 0000 00DC             Bit_Negative_6_Warning = 1;
	SBI  0x13,4
; 0000 00DD         }
; 0000 00DE     }
_0x27:
; 0000 00DF     else
	RJMP _0x2A
_0x26:
; 0000 00E0     {
; 0000 00E1         Uc_Negative_6_Under++;
	INC  R10
; 0000 00E2         if(Uc_Negative_6_Under > 10)
	LDI  R30,LOW(10)
	CP   R30,R10
	BRSH _0x2B
; 0000 00E3         {
; 0000 00E4             Uc_Negative_6_Under = 11;
	LDI  R30,LOW(11)
	MOV  R10,R30
; 0000 00E5             Uc_Negative_6_Over = 0;
	CLR  R11
; 0000 00E6             Bit_Negative_6_Warning = 0;
	CBI  0x13,4
; 0000 00E7         }
; 0000 00E8     }
_0x2B:
_0x2A:
; 0000 00E9 
; 0000 00EA     if(Bit_Negative_6_Warning || Bit_Negative_12_Warning || Bit_Positive_12_Warning || Bit_Positive_6_Warning)
	SBIC 0x13,4
	RJMP _0x2F
	SBIC 0x13,3
	RJMP _0x2F
	SBIC 0x13,1
	RJMP _0x2F
	SBIS 0x13,2
	RJMP _0x2E
_0x2F:
; 0000 00EB     {
; 0000 00EC         CONTROL_UNDER_24_OFF;
	SBI  0x18,2
; 0000 00ED         Uint_Warning_Count = 0;
	CLR  R12
	CLR  R13
; 0000 00EE     }
; 0000 00EF     else if(Uint_Warning_Count >= TIME_WARNING)
	RJMP _0x33
_0x2E:
	RCALL SUBOPT_0x2
	BRLO _0x34
; 0000 00F0     {
; 0000 00F1         CONTROL_UNDER_24_ON;
	CBI  0x18,2
; 0000 00F2     }
; 0000 00F3 
; 0000 00F4     if(Bit_Positive_24_Warning)
_0x34:
_0x33:
	SBIS 0x13,0
	RJMP _0x37
; 0000 00F5     {
; 0000 00F6         CONTROL_24_OFF;
	SBI  0x18,0
; 0000 00F7         Uint_Warning_Count = 0;
	CLR  R12
	CLR  R13
; 0000 00F8     }
; 0000 00F9     else if(Uint_Warning_Count >= TIME_WARNING)
	RJMP _0x3A
_0x37:
	RCALL SUBOPT_0x2
	BRLO _0x3B
; 0000 00FA     {
; 0000 00FB         CONTROL_24_ON;
	CBI  0x18,0
; 0000 00FC     }
; 0000 00FD 
; 0000 00FE      if(Uint_Warning_Count < TIME_WARNING)
_0x3B:
_0x3A:
	RCALL SUBOPT_0x2
	BRSH _0x3E
; 0000 00FF      {
; 0000 0100 
; 0000 0101         if(Uint_Warning_Count % TIME_BUZZER == 0)   CONTROL_BUZZER = !CONTROL_BUZZER;
	MOVW R26,R12
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL __MODW21U
	SBIW R30,0
	BRNE _0x3F
	SBIS 0x18,1
	RJMP _0x40
	CBI  0x18,1
	RJMP _0x41
_0x40:
	SBI  0x18,1
_0x41:
; 0000 0102         Uint_Warning_Count++;
_0x3F:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0103      }
; 0000 0104      else
	RJMP _0x42
_0x3E:
; 0000 0105      {
; 0000 0106         CONTROL_BUZZER_OFF;
	CBI  0x18,1
; 0000 0107      }
_0x42:
; 0000 0108      delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0109 }
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;void main(void)
; 0000 010C {
_main:
; .FSTART _main
; 0000 010D // Declare your local variables here
; 0000 010E 
; 0000 010F // Crystal Oscillator division factor: 1
; 0000 0110 #pragma optsize-
; 0000 0111 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0112 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0113 #ifdef _OPTIMIZE_SIZE_
; 0000 0114 #pragma optsize+
; 0000 0115 #endif
; 0000 0116 
; 0000 0117 // Input/Output Ports initialization
; 0000 0118 // Port A initialization
; 0000 0119 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 011A DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	OUT  0x1A,R30
; 0000 011B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 011C PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 011D 
; 0000 011E // Port B initialization
; 0000 011F // Function: Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 0120 DDRB=(0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 0121 // State: Bit3=T Bit2=T Bit1=0 Bit0=0
; 0000 0122 PORTB=(0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0123 
; 0000 0124 // Timer/Counter 0 initialization
; 0000 0125 // Clock source: System Clock
; 0000 0126 // Clock value: Timer 0 Stopped
; 0000 0127 // Mode: Normal top=0xFF
; 0000 0128 // OC0A output: Disconnected
; 0000 0129 // OC0B output: Disconnected
; 0000 012A TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x30,R30
; 0000 012B TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 012C TCNT0=0x00;
	OUT  0x32,R30
; 0000 012D OCR0A=0x00;
	OUT  0x36,R30
; 0000 012E OCR0B=0x00;
	OUT  0x3C,R30
; 0000 012F 
; 0000 0130 // Timer/Counter 1 initialization
; 0000 0131 // Clock source: System Clock
; 0000 0132 // Clock value: Timer1 Stopped
; 0000 0133 // Mode: Normal top=0xFFFF
; 0000 0134 // OC1A output: Disconnected
; 0000 0135 // OC1B output: Disconnected
; 0000 0136 // Noise Canceler: Off
; 0000 0137 // Input Capture on Falling Edge
; 0000 0138 // Timer1 Overflow Interrupt: Off
; 0000 0139 // Input Capture Interrupt: Off
; 0000 013A // Compare A Match Interrupt: Off
; 0000 013B // Compare B Match Interrupt: Off
; 0000 013C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 013D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 013E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 013F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0140 ICR1H=0x00;
	OUT  0x25,R30
; 0000 0141 ICR1L=0x00;
	OUT  0x24,R30
; 0000 0142 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0143 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0144 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0145 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0146 
; 0000 0147 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0148 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0149 
; 0000 014A // Timer/Counter 1 Interrupt(s) initialization
; 0000 014B TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	OUT  0xC,R30
; 0000 014C 
; 0000 014D // External Interrupt(s) initialization
; 0000 014E // INT0: Off
; 0000 014F // Interrupt on any change on pins PCINT0-7: Off
; 0000 0150 // Interrupt on any change on pins PCINT8-11: Off
; 0000 0151 MCUCR=(0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0152 GIMSK=(0<<INT0) | (0<<PCIE1) | (0<<PCIE0);
	OUT  0x3B,R30
; 0000 0153 
; 0000 0154 // USI initialization
; 0000 0155 // Mode: Disabled
; 0000 0156 // Clock source: Register & Counter=no clk.
; 0000 0157 // USI Counter Overflow Interrupt: Off
; 0000 0158 USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<<USICS0) | (0<<USICLK) | (0<<USITC);
	OUT  0xD,R30
; 0000 0159 
; 0000 015A // Analog Comparator initialization
; 0000 015B // Analog Comparator: Off
; 0000 015C // The Analog Comparator's positive input is
; 0000 015D // connected to the AIN0 pin
; 0000 015E // The Analog Comparator's negative input is
; 0000 015F // connected to the AIN1 pin
; 0000 0160 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0161 // Digital input buffer on AIN0: On
; 0000 0162 // Digital input buffer on AIN1: On
; 0000 0163 DIDR0=(0<<ADC1D) | (0<<ADC2D);
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 0164 
; 0000 0165 // // ADC initialization
; 0000 0166 // // ADC Clock frequency: 1000.000 kHz
; 0000 0167 // // ADC Voltage Reference: AVCC pin
; 0000 0168 // // ADC Bipolar Input Mode: Off
; 0000 0169 // // ADC Auto Trigger Source: ADC Stopped
; 0000 016A // // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 016B // // ADC4: On, ADC5: On, ADC6: On, ADC7: On
; 0000 016C // DIDR0=(0<<ADC7D) | (0<<ADC6D) | (0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
; 0000 016D // ADMUX=ADC_VREF_TYPE;
; 0000 016E // ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
; 0000 016F // ADCSRB=(0<<BIN) | (0<<ADLAR) | (0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
; 0000 0170 // ADC initialization
; 0000 0171 // ADC Clock frequency: 1000,000 kHz
; 0000 0172 // ADC Voltage Reference: 1.1V, AREF discon.
; 0000 0173 // ADC Bipolar Input Mode: Off
; 0000 0174 // ADC Auto Trigger Source: ADC Stopped
; 0000 0175 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 0176 // ADC4: On, ADC5: On, ADC6: On, ADC7: On
; 0000 0177 DIDR0=(0<<ADC7D) | (0<<ADC6D) | (0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	OUT  0x1,R30
; 0000 0178 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(128)
	OUT  0x7,R30
; 0000 0179 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 017A ADCSRB=(0<<BIN) | (0<<ADLAR) | (0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 017B 
; 0000 017C 
; 0000 017D CONTROL_BUZZER_ON;
	SBI  0x18,1
; 0000 017E delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
; 0000 017F CONTROL_BUZZER_OFF;
	CBI  0x18,1
; 0000 0180 delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0181 
; 0000 0182 while (1)
_0x49:
; 0000 0183       {
; 0000 0184       // Place your code here
; 0000 0185         PROTECT();
	RCALL _PROTECT
; 0000 0186       }
	RJMP _0x49
; 0000 0187 }
_0x4C:
	RJMP _0x4C
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	RCALL _read_adc
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	__CPWRN 16,17,53
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R12,R30
	CPC  R13,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
