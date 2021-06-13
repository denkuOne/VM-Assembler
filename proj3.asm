//DenkuOne
SIZE	.INT 7
tenth	.INT 0
data	.INT 0
opdv	.INT 0
cnt	.INT 0
flag	.INT 0
c	.BYT ' '
	.BYT ' '
	.BYT ' '
	.BYT ' '
	.BYT ' '
	.BYT ' '
	.BYT ' '
//"Operand is %d\n"
oprdis	.BYT 'O'
	.BYT 'p'
	.BYT 'e'
	.BYT 'r'
	.BYT 'a'
	.BYT 'n'
	.BYT 'd'
	.BYT ' '
	.BYT 'i'
	.BYT 's'
	.BYT ' '
nulin	.BYT '\n'
//"Number too Big\n"
numbbg	.BYT 'N'
	.BYT 'u'
	.BYT 'm'
	.BYT 'b'
	.BYT 'e'
	.BYT 'r'
	.BYT ' '
	.BYT 't'
	.BYT 'o'
	.BYT 'o'
	.BYT ' '
	.BYT 'b'
	.BYT 'i'
	.BYT 'g'
	.BYT '\n'
//" is not a number\n"
isanum	.BYT ' '
	.BYT 'i'
	.BYT 's'
	.BYT ' '
	.BYT 'n'
	.BYT 'o'
	.BYT 't'
	.BYT ' '
	.BYT 'a'
	.BYT ' '
	.BYT 'n'
	.BYT 'u'
	.BYT 'm'
	.BYT 'b'
	.BYT 'e'
	.BYT 'r'
	.BYT '\n'
//reset(1, 0, 0, 0);
	ADI R0 1
	MOV R7 SP
	ADI R7 -24
	CMP R7 SL
	BLT R7 ovf
	MOV R7 FP
	MOV FP SP
	MOV R6 PC
	ADI R6 168
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	STR R0 SP
	ADI SP -4
	STR R1 SP
	ADI SP -4
	STR R2 SP
	ADI SP -4
	STR R3 SP
	ADI SP -4
	JMP reset
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7
	MOV SP FP
	MOV FP R0
	CMP R7 SB
	BGT R7 unf
//getdata();
	MOV R7 SP
	ADI R7 -8
	CMP R7 SL
	BLT R7 ovf
	MOV R7 FP
	MOV FP SP
	MOV R6 PC
	ADI R6 72
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	JMP getdata
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7
	MOV SP FP
	MOV FP R0
	CMP R7 SB
	BGT R7 unf
//while (c[0] != '@')
wl1	LDB R0 c
	ADI R0 -64
	BRZ R0 w1e
// if (c[0] == '+' || c[0] == '-')
	LDB R0 c
	ADI R0 -43
	BRZ R0 st1
	ADI R0 -2
	BNZ R0 el1
// getdata()
st1	MOV R7 SP
	ADI R7 -8
	CMP R7 SL
	BLT R7 ovf
	MOV R7 FP
	MOV FP SP
	MOV R6 PC
	ADI R6 72
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	JMP getdata
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7
	MOV SP FP
	MOV FP R0
	CMP R7 SB
	BGT R7 unf
	JMP wl2
el1	LDA R0 c
	LDB R1 c
	ADI R0 1
	STB R1 R0 //c[1] = c[0];
	SUB R0 R0
	ADI R0 43
	STB R0 c //c[0] = '+';
	LDR R1 cnt
	ADI R1 1
	STR R1 cnt //cnt++;
//while(data)
wl2	LDR R2 data
	BRZ R2 w2e
// if(c[cnt - 1] == '\n')
	LDA R1 c
	LDR R0 cnt
	ADI R0 -1
	ADD R1 R0
	LDB R0 R1
	ADI R0 -10
	BNZ R0 el2
	SUB R0 R0
	STR R0 data //data = 0
	ADI R0 1
	STR R0 tenth //tenth = 1
	LDR R2 cnt
	ADI R2 -2
	STR R2 cnt //cnt = cnt - 2
//while(!flag && cnt != 0)
wl3	LDR R0 flag
	BNZ R0 w3e
	LDR R3 cnt
	BRZ R3 w3e
	LDB R0 c
	LDR R1 tenth
	LDA R4 c
	ADD R4 R3
	LDB R2 R4
//opd(c[0], tenth, c[cnt]);
	MOV R7 SP
	ADI R7 -20
	CMP R7 SL
	BLT R7 ovf
	MOV R7 FP
	MOV FP SP
	MOV R6 PC
	ADI R6 144
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	STB R0 SP
	ADI SP -4
	STR R1 SP
	ADI SP -4
	STB R2 SP
	ADI SP -4
	JMP opd
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7
	MOV SP FP
	MOV FP R0
	CMP R7 SB
	BGT R7 unf
	LDR R2 cnt
	ADI R2 -1
	STR R2 cnt //cnt--;
	LDR R1 tenth
	SUB R0 R0
	ADI R0 10
	MUL R1 R0
	STR R1 tenth // tenth *= 10;
	JMP wl3
//if (!flag)
w3e	LDR R0 flag
	BNZ R0 wl2
//print(oprdis);
	SUB R1 R1
	ADI R1 11
	LDA R2 oprdis
pr1	LDB R3 R2
	TRP 3
	ADI R2 1
	ADI R1 -1
	BNZ R1 pr1
	LDR R3 opdv
	TRP 1
	LDB R3 nulin
	TRP 3
	JMP wl2
//getdata()
el2	MOV R7 SP
	ADI R7 -8
	CMP R7 SL
	BLT R7 ovf
	MOV R7 FP
	MOV FP SP
	MOV R6 PC
	ADI R6 72
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	JMP getdata
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7
	MOV SP FP
	MOV FP R0
	CMP R7 SB
	BGT R7 unf
	JMP wl2
//reset(1, 0, 0, 0);
w2e	SUB R0 R0
	SUB R1 R1
	SUB R2 R2
	SUB R3 R3
	ADI R0 1
	MOV R7 SP
	ADI R7 -24
	CMP R7 SL
	BLT R7 ovf
	MOV R7 FP
	MOV FP SP
	MOV R6 PC
	ADI R6 168
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	STR R0 SP
	ADI SP -4
	STR R1 SP
	ADI SP -4
	STR R2 SP
	ADI SP -4
	STR R3 SP
	ADI SP -4
	JMP reset
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7
	MOV SP FP
	MOV FP R0
	CMP R7 SB
	BGT R7 unf
//getdata();
	MOV R7 SP
	ADI R7 -8
	CMP R7 SL
	BLT R7 ovf
	MOV R7 FP
	MOV FP SP
	MOV R6 PC
	ADI R6 72
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	JMP getdata
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7
	MOV SP FP
	MOV FP R0
	CMP R7 SB
	BGT R7 unf
	JMP wl1
w1e	TRP 0
//flush()
flush	SUB R1 R1
	STR R1 data
	TRP 4
wlf	MOV R2 R3
	ADI R2 -10
	BRZ R2 nd2
	TRP 4
	STB R3 c
	JMP wlf
nd2	LDR R7 FP
	JMR R7
//getdata()
getdata	LDR R0 cnt //R0 = cnt
	LDR R1 SIZE //R1 = SIZE
	CMP R0 R1
	BLT R0 ifg
elg	SUB R1 R1
	ADI R1 15 //Size of string
	LDA R2 numbbg //Label to string
png	LDB R3 R2
	TRP 3
	ADI R2 1
	ADI R1 -1
	BNZ R1 png
//flush()
	MOV R7 SP
	ADI R7 -8
	CMP R7 SL
	BLT R7 ovf
	MOV R7 FP
	MOV FP SP
	MOV R6 PC
	ADI R6 72
	STR R6 FP
	ADI SP -4
	STR R7 SP
	ADI SP -4
	JMP flush
	MOV R7 FP
	ADI R7 -4
	LDR R0 R7
	MOV SP FP
	MOV FP R0
	CMP R7 SB
	BGT R7 unf
	//End
	LDR R7 FP
	JMR R7
ifg	LDA R1 c //R1 = *c
	LDR R2 cnt //R2 = cnt
	ADD R1 R2 //c[cnt]
	TRP 4 //getchar()
	STB R3 R1 //c[cnt] = getchar()
	ADI R2 1
	STR R2 cnt //cnt++
	//End
	LDR R7 FP
	JMR R7
//opd(char s, int k, char j)
opd	MOV R7 SP
	ADI R7 4
	LDB R2 R7 //R2 = j
	ADI R7 4
	LDR R1 R7 //R1 = k
	MOV R4 R2
	SUB R6 R6 //R6 = t
	//Switch statement for j
	ADI R4 -48
	BRZ R4 nd1
	ADI R4 -1
	BRZ R4 one
	ADI R4 -1
	BRZ R4 two
	ADI R4 -1
	BRZ R4 three
	ADI R4 -1
	BRZ R4 four
	ADI R4 -1
	BRZ R4 five
	ADI R4 -1
	BRZ R4 six
	ADI R4 -1
	BRZ R4 seven
	ADI R4 -1
	BRZ R4 eight
	ADI R4 -1
	BRZ R4 nine
	MOV R3 R2
	TRP 3
	SUB R0 R0
	ADI R0 17 //Size of string
	LDA R5 isanum //Label to string
pin	LDB R3 R5
	TRP 3
	ADI R5 1
	ADI R0 -1
	BNZ R0 pin
	SUB R0 R0
	ADI R0 1
	STR R0 flag //flag = 1
	JMP nd1
one	ADI R6 1
	JMP nd1
two	ADI R6 2
	JMP nd1
three	ADI R6 3
	JMP nd1
four	ADI R6 4
	JMP nd1
five	ADI R6 5
	JMP nd1
six	ADI R6 6
	JMP nd1
seven	ADI R6 7
	JMP nd1
eight	ADI R6 8
	JMP nd1
nine	ADI R6 9
nd1	LDR R0 flag
	BNZ R0 nd4 //if(!flag)
	//Test if x == '+'
	MOV R7 SP
	ADI R7 12
	LDB R0 R7 //R0 = s
	ADI R0 -43
	BRZ R0 if1
elp	SUB R4 R4
	ADI R4 -1
	MUL R4 R1
	MUL R6 R4
	JMP nd4
if1	MUL R6 R1
	ADD R5 R6
nd4	LDR R5 opdv
	ADD R5 R6 //opdv += t
	STR R5 opdv
	LDR R7 FP
	JMR R7
//reset(int w, int x, int y, int z)
reset	MOV R6 SP
	ADI R6 4
	LDR R3 R6 //R3 = z
	ADI R6 4
	LDR R2 R6 //R2 = y
	ADI R6 4
	LDR R1 R6 //R1 = x
	ADI R6 4
	LDR R0 R6 //R0 = w
	SUB R4 R4 //R4 = int k = 0
	LDA R5 c
frk	LDR R6 SIZE
	CMP R6 R4
	BRZ R6 nd3
	SUB R6 R6
	STB R6 R5
	ADI R4 1
	ADI R5 1
	JMP frk
nd3	STR R0 data
	STR R1 opdv
	STR R2 cnt
	STR R3 flag
	LDR R7 FP
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
