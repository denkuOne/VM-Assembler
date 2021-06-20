
# Assembler-and-VM

この下に日本語の説明あります。

Assembler and Virtual Machine for a fictitious hardware. Assembly code is passed to the VM which is assembled and ran on simulated hardware. This code was written for a school project and is not necessarily useful for anything but educational purposes.

# About the Code
vm.cpp contains the code which emulates a processor at a high abstraction. It follows the 5-stage architecture fetch, decode, execute, memory and write back but is not pipe lined. The code consists of a large while loop that executes all 5 of the stages mentioned above before the next instruction is fed into the CPU. A large switch statement is used to define the behavior of every single available instruction in my fictional assembly language. The vm also supports simple multi-threading by breaking up memory between a total of 5 possible threads and context switching between every single active thread per instruction.
assembler.cpp contains the code which reads user created assembly code and assembles it into a machine code. The machine code is passed to the vm through a struct that contains some data regarding the assembled file and a large array of memory with the machine code loaded inside. The assembler conducts robust error checking throughout the assembly process to warn the user regarding unrecognizable assembly code syntax.

![ISA](https://user-images.githubusercontent.com/85288181/121529414-569bdf80-ca37-11eb-8603-64fc71debd7f.jpg)

大学の時、仮想のコンピューターアーキテクチャのプログラムを書きました。実行できるアセンブリー語は上の図で説明されています。プログラムの部分は四つあって、アセンブラー、シンボルテーブル、プロセッサー、アセンブリコードです。アセンブラーとシンボルテーブルは両方assembler.cppに含まれ、プロセッサーはvm.cppに含まれています。アセンブリコードは別のファイルにあります。もちろん、vm.exeを実行すると、アセンブリコードの入力は必要です。すると、実行の連続は以下、

１入力したアセンブリコードを機械語に変化します。　まずアセンブリの書き方の間違えを探します。次はラベルで繋いでいる行目を探し、シンボルテーブルに登録します。最後に行目を一列ずつ二進法に変化します。
２変化した機械語を仮想のプロセッサーで実行します。

もし入力されたアセンブリに書き間違えがあったら、アセンブラはエラー表示して、実行が止まります。エラーは表示されると、書き間違えある行目の番号も表示されるからディバッグは楽です。

# 「proj1.asm」
This assembly program demonstrates working arithmetic, and IO commands. It also demonstrates how to put and load variables from memory.

このコードは、算数とメモリー書き込みと読み込みを示します。

# 「proj2.asm」
This assembly program demonstrates working with arrays using register based addressing

このコードは、アレイの操作を示します。

# 「proj3.asm」
This assembly program is a manually compiled implementation of the example.c program and implements function calls using the run-time stack.

このコードは、コールスタック使用、手動でアセンブリ言語にコンパイルされた「example.c」を示します。

# 「proj4.asm」
Demonstrates recursion by implementing a Fibonacci sequence calculator
It also demonstrates multi-threading by running up to five Fibonacci calculations simultaneously.

このコードは、再帰を使用、フィボナッチ数の計算を示します。
その上、仮想のプロセッサーのスレッド可能も示します。

# ビデオ Demo
https://youtu.be/35O4qbdu8D0
