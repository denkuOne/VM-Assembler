//BRYCE MARTIN
A	.BYT 'A'
B	.BYT 'B'
C	.BYT 'C'
E	.BYT 'E'
I	.BYT 'I'
M	.BYT 'M'
N	.BYT 'N'
R	.BYT 'R'
T	.BYT 'T'
Y	.BYT 'Y'
nulin	.BYT '\n'
com	.BYT ','
space	.BYT ' '

a1	.INT 1
a2	.INT 2
a3	.INT 3
a4	.INT 4
a5	.INT 5
a6	.INT 6

b1	.INT 300
b2	.INT 150
b3	.INT 50
b4	.INT 20
b5	.INT 10
b6	.INT 5

c1	.INT 500
c2	.INT 2
c3	.INT 5
c4	.INT 10
//Start of program
	LDB R3 M
	TRP 3
	LDB R3 A
	TRP 3
	LDB R3 R
	TRP 3
	LDB R3 T
	TRP 3
	LDB R3 I
	TRP 3
	LDB R3 N
	TRP 3
	LDB R3 com
	TRP 3
	LDB R3 space
	TRP 3
	LDB R3 B
	TRP 3
	LDB R3 R
	TRP 3
	LDB R3 Y
	TRP 3
	LDB R3 C
	TRP 3
	LDB R3 E
	TRP 3
	LDB R3 nulin
	TRP 3
	TRP 3
//Addition of all elements in array b
//Final result is saved in R0
	LDR R0 b1
	LDR R4 b2
	ADD R0 R4
	MOV R3 R0
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	LDR R4 b3
	ADD R0 R4
	MOV R3 R0
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	LDR R4 b4
	ADD R0 R4
	MOV R3 R0
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	LDR R4 b5
	ADD R0 R4
	MOV R3 R0
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	LDR R4 b6
	ADD R0 R4
	MOV R3 R0
	TRP 1
	LDB R3 nulin
	TRP 3
	TRP 3
//Multiplication of all elements in array a
//Final result is stored in R1
	LDR R1 a1
	LDR R4 a2
	MUL R1 R4
	MOV R3 R1
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	LDR R4 a3
	MUL R1 R4
	MOV R3 R1
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	LDR R4 a4
	MUL R1 R4
	MOV R3 R1
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	LDR R4 a5
	MUL R1 R4
	MOV R3 R1
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	LDR R4 a6
	MUL R1 R4
	MOV R3 R1
	TRP 1
	LDB R3 nulin
	TRP 3
	TRP 3
//Division of all elements in array b by results of the summation of b
	MOV R3 R0
	LDR R4 b1
	DIV R3 R4
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	MOV R3 R0
	LDR R4 b2
	DIV R3 R4
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	MOV R3 R0
	LDR R4 b3
	DIV R3 R4
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	MOV R3 R0
	LDR R4 b4
	DIV R3 R4
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	MOV R3 R0
	LDR R4 b5
	DIV R3 R4
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	MOV R3 R0
	LDR R4 b6
	DIV R3 R4
	TRP 1
	LDB R3 nulin
	TRP 3
	TRP 3
//Subtract result of multiplication of array a by each element in array c
	MOV R3 R1
	LDR R4 c1
	SUB R3 R4
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	MOV R3 R1
	LDR R4 c2
	SUB R3 R4
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	MOV R3 R1
	LDR R4 c3
	SUB R3 R4
	TRP 1
	LDB R3 space
	TRP 3
	TRP 3
	MOV R3 R1
	LDR R4 c4
	SUB R3 R4
	TRP 1
	LDB R3 nulin
	TRP 3
	TRP 0 //End of program
