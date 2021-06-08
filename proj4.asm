//DenkuOne
thdmux	.INT -1
arrmux	.INT -1
CNT	.INT 0
out1	.BYT 'F'
	.BYT 'i'
	.BYT 'b'
	.BYT 'o'
	.BYT 'n'
	.BYT 'a'
	.BYT 'c'
	.BYT 'c'
	.BYT 'i'
	.BYT ' '
	.BYT 'o'
	.BYT 'f'
	.BYT ' '
out2	.BYT ' '
	.BYT 'i'
	.BYT 's'
	.BYT ' '
out3	.BYT '\n'
cmma	.BYT ','
spce	.BYT ' '
arr	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	.INT 0
	LDA R4 arr
	//R3 stores the input
	//R4 stores array pointer
wh1	LDA R5 arr
	ADI R5 120
	SUB R5 R4
	BRZ R5 whe1
	TRP 2
	BRZ R3 whe1
	STR R3 R4
	//Create an activation record
	//Test for overflow
	MOV R7 SP
	ADI R7 -12 //Stack size here
	CMP R7 SL
	BLT R7 ovf
	//Set SP, FP, pfp, calculate return addr
	MOV R7 FP //pfp = R7
	MOV FP SP //FP = SP
	MOV R6 PC
	ADI R6 96 //Return address here
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	//Add input arguments here
	STR R3 SP
	ADI SP -4
	//Jump to function
	JMP fib
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7 //pfp = R0
	MOV SP FP //SP = FP
	MOV FP R0 //FP = pfp
	//Check underflow
	CMP R7 SB
	BGT R7 unf
	//End of activation record
	//Print1
	SUB R1 R1
	ADI R1 13 //Size of string
	LDA R2 out1 //Label to string
p1	LDB R3 R2
	TRP 3
	ADI R2 1
	ADI R1 -1
	BNZ R1 p1
	//Print x
	LDR R3 R4
	TRP 1
	ADI R4 4
	//Print2
	SUB R1 R1
	ADI R1 4 //Size of string
	LDA R2 out2 //Label to string
p2	LDB R3 R2
	TRP 3
	ADI R2 1
	ADI R1 -1
	BNZ R1 p2
	//Print y
	LDR R0 SP
	STR R0 R4
	MOV R3 R0
	TRP 1
	ADI R4 4
	LDB R3 out3
	TRP 3
	JMP wh1
whe1	LDA R0 arr
	MOV R1 R4
	ADI R1 -4
wh2	MOV R2 R1
	CMP R2 R0
	BLT R2 whe2
	LDR R3 R0
	TRP 1
	LDB R3 cmma
	TRP 3
	LDB R3 spce
	TRP 3
	LDR R3 R1
	TRP 1
	ADI R0 4
	ADI R1 -4
	MOV R2 R1
	CMP R2 R0
	BLT R2 whe2
	LDB R3 cmma
	TRP 3
	LDB R3 spce
	TRP 3
	JMP wh2
whe2	LDB R3 out3
	TRP 3
	TRP 3
//Part 3 Multithreading
//Main thread
	LCK thdmux
wh3	ADI R2 -4
	BRZ R2 whe3
	TRP 2
	BRZ R3 whe3
	RUN R2 nuth
	JMP wh3
whe3	ULK thdmux
	BLK
//Print from array
	LDA R0 arr
	LDA R1 arr
	LDR R2 CNT
	ADI R2 -4
	ADD R1 R2
wh4	MOV R2 R1
	CMP R2 R0
	BLT R2 whe4
	LDR R3 R0
	TRP 1
	LDB R3 cmma
	TRP 3
	LDB R3 spce
	TRP 3
	LDR R3 R1
	TRP 1
	ADI R0 4
	ADI R1 -4
	MOV R2 R1
	CMP R2 R0
	BLT R2 whe4
	LDB R3 cmma
	TRP 3
	LDB R3 spce
	TRP 3
	JMP wh4
whe4	LDB R3 out3
	TRP 3
	TRP 0
//Child Threads
nuth	LCK thdmux
	ULK thdmux
	MOV R4 R3 //Move X to R4
	//Create an activation record
	//Test for overflow
	MOV R7 SP
	ADI R7 -12 //Stack size here
	CMP R7 SL
	BLT R7 ovf
	//Set SP, FP, pfp, calculate return addr
	MOV R7 FP //pfp = R7
	MOV FP SP //FP = SP
	MOV R6 PC
	ADI R6 96 //Return address here
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	//Add input arguments here
	STR R3 SP
	ADI SP -4
	//Jump to function
	JMP fib
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7 //pfp = R0
	MOV SP FP //SP = FP
	MOV FP R0 //FP = pfp
	//Check underflow
	CMP R7 SB
	BGT R7 unf
	//End of activation record
//Print results here
//Print part 1
	SUB R1 R1
	ADI R1 13 //Size of string
	LDA R2 out1 //Label to string
p3	LDB R3 R2
	TRP 3
	ADI R2 1
	ADI R1 -1
	BNZ R1 p3
//Print x
	MOV R3 R4
	TRP 1
//Print part 2
	SUB R1 R1
	ADI R1 4 //Size of string
	LDA R2 out2 //Label to string
p4	LDB R3 R2
	TRP 3
	ADI R2 1
	ADI R1 -1
	BNZ R1 p4
//Print y
	LDR R0 SP
	MOV R3 R0
	TRP 1
//Print part 3
	LDB R3 out3
	TRP 3
//Store results in array
	LDA R1 arr
	LCK arrmux
	LDR R2 CNT
	ADD R1 R2 //Find current offset
	STR R4 R1 //Store x
	ADI R1 4
	STR R0 R1 //Store y
	ADI R2 8
	STR R2 CNT //Store current CNT
	ULK arrmux
	END
	TRP 0
//Fibonacci Function
fib	MOV R7 SP
	ADI R7 4
	LDR R1 R7 //R1 = n
	MOV R2 R1
	ADI R2 -1
	BGT R2 recurs
	LDR R7 FP
	STR R1 FP
	JMR R7
	//Test for overflow
recurs	MOV R7 SP
	ADI R7 -16 //Stack size here
	CMP R7 SL
	BLT R7 ovf
	//Push n to stack
	ADI R1 -1
	STR R1 SP
	ADI SP -4
	//Call fib
	//Set SP, FP, pfp, calculate return addr
	MOV R7 FP //pfp = R7
	MOV FP SP //FP = SP
	MOV R6 PC
	ADI R6 96 //Return address here
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	//Add input arguments here
	STR R1 SP
	ADI SP -4
	//Jump to function
	JMP fib
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7 //pfp = R0
	MOV SP FP //SP = FP
	MOV FP R0 //FP = pfp
	//Check underflow
	CMP R7 SB
	BGT R7 unf
	//Load n from stack
	MOV R7 SP
	LDR R0 R7 //R0 = fib call ans 1
	ADI R7 4
	LDR R1 R7 //R1 = n
	STR R0 R7
	ADI R1 -1
	//Call fib again
	//Test for overflow
	MOV R7 SP
	ADI R7 -12 //Stack size here
	CMP R7 SL
	BLT R7 ovf
	//Set SP, FP, pfp, calculate return addr
	MOV R7 FP //pfp = R7
	MOV FP SP //FP = SP
	MOV R6 PC
	ADI R6 96 //Return address here
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	//Add input arguments here
	STR R1 SP
	ADI SP -4
	//Jump to function
	JMP fib
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7 //pfp = R0
	MOV SP FP //SP = FP
	MOV FP R0 //FP = pfp
	//Check underflow
	CMP R7 SB
	BGT R7 unf
	//Load ret and prev ret
	MOV R7 SP
	LDR R0 R7
	ADI R7 4
	LDR R1 R7
	//Add and return
	ADD R0 R1
	LDR R7 FP
	STR R0 FP
	JMR R7
//Overflow function
ovf	SUB R3 R3
	ADI R3 666
	TRP 1
	TRP 0
//Underflow function
unf	SUB R3 R3
	ADI R3 -666
	TRP 1
	TRP 0
