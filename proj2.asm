//BRYCE MARTIN
//R1 R2 R3 are temp registers
//R0 = i
//R4 holds modulus mask of 0x00000001
SIZE	.INT 10
ARR	.INT 10
	.INT 2
	.INT 3
	.INT 4
	.INT 15
	.INT -6
	.INT 7
	.INT 8
	.INT 9
	.INT 10
sum	.INT 0
mask	.INT 1
zero	.INT 0
intsiz	.INT 4
DAGS	.BYT 'D'
	.BYT 'A'
	.BYT 'G'
	.BYT 'S'
GADS	.INT -99
d	.BYT 'd'
e	.BYT 'e'
i	.BYT 'i'
m	.BYT 'm'
n	.BYT 'n'
o	.BYT 'o'
s	.BYT 's'
S	.BYT 'S'
u	.BYT 'u'
v	.BYT 'v'
space	.BYT ' '
nulin	.BYT '\n'
grth	.BYT '>'
lsth	.BYT '<'
equal	.BYT '='
minus	.BYT '-'
	LDR R4 mask //Load modulus mask
while	MOV R1 R0
	LDR R2 SIZE
	CMP R1 R2
	BRZ R1 endw
	//Add current ARR element and save in sum
	LDR R1 sum
	LDA R2 ARR
	LDR R3 intsiz
	MUL R3 R0
	ADD R2 R3
	LDR R3 R2
	ADD R1 R3
	STR R1 sum
	MOV R2 R1
	//Do modulus operator on previous value
	AND R2 R4
	//Increment i
	ADI R0 1
	//Branch to "else" if result is odd
	BGT R2 else
	//Stay if result is even
	MOV R3 R1
	TRP 1
	//Print " is even\n"
	LDB R3 space
	TRP 3
	LDB R3 i
	TRP 3
	LDB R3 s
	TRP 3
	LDB R3 space
	TRP 3
	LDB R3 e
	TRP 3
	LDB R3 v
	TRP 3
	LDB R3 e
	TRP 3
	LDB R3 n
	TRP 3
	LDB R3 nulin
	TRP 3
	JMP while
else	MOV R3 R1 //Start here is result is odd
	TRP 1
	//Print " is odd\n"
	LDB R3 space
	TRP 3
	LDB R3 i
	TRP 3
	LDB R3 s
	TRP 3
	LDB R3 space
	TRP 3
	LDB R3 o
	TRP 3
	LDB R3 d
	TRP 3
	TRP 3
	LDB R3 nulin
	TRP 3
	JMP while
endw	LDB R3 S //Print "Sum is %d"
	TRP 3
	LDB R3 u
	TRP 3
	LDB R3 m
	TRP 3
	LDB R3 space
	TRP 3
	LDB R3 i
	TRP 3
	LDB R3 s
	TRP 3
	LDB R3 space
	TRP 3
	LDR R3 sum
	TRP 1
	LDB R3 nulin
	TRP 3
	TRP 3
//END OF PROGRAM 1
	//Place DAGS in GADS
	LDR R0 DAGS
	STR R0 GADS
	//Load GADS addr in R1
	LDA R1 GADS
	//Load D into R2
	LDB R2 R1
	//Find address of G
	ADI R1 2
	//Load G into R0
	LDB R0 R1
	//Place D in G's place
	STB R2 R1
	//Place G in D's place
	STB R0 GADS
	//R0 = i
	LDR R0 zero
while2	MOV R2 R0
	LDR R1 intsiz
	CMP R2 R1
	BRZ R2 endw2
	LDA R4 DAGS //R4 = DAGS addr
	LDA R5 GADS //R5 = GADS addr
	ADD R4 R0 //DAGS addr + i
	ADD R5 R0 //GADS addr + i
	LDB R2 R4 //R2 = *DAGS
	LDB R1 R5 //R1 = *GADS
	MOV R7 R2
	CMP R7 R1
	BLT R7 smalr
	BGT R7 largr
	//The following executes if DAGS[i] = GADS[i]
	LDB R6 equal
	JMP join
	//The following executes if DAGS[i] <  GADS[i]
smalr	LDB R6 lsth
	JMP join
	//The following executes if DAGS[i] > GADS[i]
largr	LDB R6 grth
	//The end of the while loop prints "DAGS[i] >=< GADS[i]"
join	MOV R3 R2
	TRP 3
	LDB R3 space
	TRP 3
	MOV R3 R6
	TRP 3
	LDB R3 space
	TRP 3
	MOV R3 R1
	TRP 3
	LDB R3 minus
	TRP 3
	TRP 3
	ADI R0 1 //i++
	JMP while2
	//Load DAGS and GADS values and print "*DAGS - *GADS = ANSWR"
endw2	LDB R3 nulin
	TRP 3
	TRP 3
	LDR R0 DAGS
	LDR R1 GADS
	MOV R3 R0
	TRP 1
	LDB R3 space
	TRP 3
	LDB R3 minus
	TRP 3
	LDB R3 space
	TRP 3
	MOV R3 R1
	TRP 1
	LDB R3 space
	TRP 3
	LDB R3 equal
	TRP 3
	LDB R3 space
	TRP 3
	SUB R0 R1
	MOV R3 R0
	TRP 1
	LDB R3 nulin
	TRP 3
//END OF PROGRAM 2
	TRP 0
