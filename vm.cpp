*/
* All code written by BRYCE MARTIN
*/

#include <regex>
#include "assembler.cpp"

struct IR{
    int opCode;
    int arg1;
    int arg2;
};

int initializeThread(bool* threadpool, char* base, int start_addr, int* registers);
bool childThreadsRunning(bool* threadpool);
void incrementPC(int* PC, program_memory in);
void memOut(program_memory program);
void stackOut(int* registers, void* base);
void registerOut(int* registers);
IR fetchInst(IR in, void* base, int* PC);

int main(int argc, char* argv[]){
    program_memory program; 

    try{
        if(argc == 1){
            std::cout << "To use vm.out pass an assembly (.asm) file as an argument" << std::endl;
            exit(EXIT_SUCCESS);
        }else if(argc == 2){      
            program = assemble(argv[1], false);
        }else if(argc >= 3){
            std::string temp = argv[2];
            if(temp == "-m"){
                program = assemble(argv[1], true);
            }else if(temp == "-b"){
                program = assembleWithBin(argv[1]);
            }else{
                std::cout << "Unrecognized flag " << temp << "; Try -m or -b" << std::endl;
                program = assemble(argv[1], true);
            }
            std::cout << "Running assembly program "<< program.name << " now...\n" << std::endl;
        }
    } catch (const char* msg){
        std::cout << msg << std::endl;
        std::cout << "Terminating now..." << std::endl;        
        exit(EXIT_FAILURE);
    }

    //Setup
    int r[13]; 
    int *PC = &r[8];
    void* base = program.memory;

    bool threadpool[5];
    int current_thread = 0;

    bool running = true;
    IR ir;

    //Initialize thread 0
    initializeThread(threadpool, (char*) base, program.starting_address, r);

    while(running){
        if(threadpool[current_thread]){
            //Load current thread's register set
            memcpy(&r, ((char*)base + MEM_SIZE - (current_thread * 1024) - 53), sizeof(r));
            ir = fetchInst(ir, base, PC);
            incrementPC(PC, program);

            switch(ir.opCode){
                case 1: { //JMP
                    *PC = ir.arg1;
                    break;
                } case 2: { //JMR
                    *PC = r[ir.arg1];
                    break;
                } case 3: { //BNZ
                    if(r[ir.arg1] != 0) *PC = ir.arg2;
                    break;
                } case 4: { //BGT
                    if(r[ir.arg1] > 0) *PC = ir.arg2;
                    break;
                } case 5: { //BLT
                    if(r[ir.arg1] < 0) *PC = ir.arg2;
                    break;
                } case 6: { //BRZ
                    if(r[ir.arg1] == 0) *PC = ir.arg2;
                    break;
                } case 7: { //MOV
                    r[ir.arg1] = r[ir.arg2];
                    break;
                } case 8: { //LDA
                    r[ir.arg1] = ir.arg2;
                    break;
                } case 9: { //STR
                    *(int*)((char*) base + ir.arg2) = r[ir.arg1];
                    break;
                } case 10: { //LDR
                    r[ir.arg1] = *(int*)((char*) base + ir.arg2);
                    break;
                } case 11: { //STB
                    *((char*) base + ir.arg2) = (char) r[ir.arg1];
                    break;
                } case 12: { //LDB
                    r[ir.arg1] = *((char*) base + ir.arg2);
                    break;
                } case 13: { //ADD
                    r[ir.arg1] = r[ir.arg1] + r[ir.arg2];
                    break;
                } case 14: { //ADI
                    r[ir.arg1] = r[ir.arg1] + ir.arg2;
                    break;
                } case 15: { //SUB
                    r[ir.arg1] = r[ir.arg1] - r[ir.arg2];
                    break;
                } case 16: { //MUL
                    r[ir.arg1] = r[ir.arg1] * r[ir.arg2];
                    break;
                } case 17: { //DIV
                    r[ir.arg1] = r[ir.arg1] / r[ir.arg2];
                    break;
                } case 18: { //AND
                    r[ir.arg1] = r[ir.arg1] & r[ir.arg2];
                    break;
                } case 19: { //OR
                    r[ir.arg1] = r[ir.arg1] | r[ir.arg2];
                    break;
                } case 20: { //CMP
                    if(r[ir.arg1] == r[ir.arg2]) r[ir.arg1] = 0;
                    else if(r[ir.arg1] > r[ir.arg2]) r[ir.arg1] = 1; 
                    else if(r[ir.arg1] < r[ir.arg2]) r[ir.arg1] = -1;
                    break;
                } case 21: { //TRP
                    switch (ir.arg1)
                    {
                        case 0: {
                            std::cout << std::endl;
                            exit(EXIT_SUCCESS);
                            break;
                        } case 1: {
                            std::cout << (int) r[3];
                            break;
                        } case 2: {
                            std::cin >> r[3];
                            break;
                        } case 3: {
                            std::cout << (char) r[3];
                            break;
                        } case 4: {
                            r[3] = getchar();
                            break;
                        } case 97: {
                            memOut(program);
                            break;
                        } case 98: {
                            stackOut(r, program.memory);
                            break;
                        } case 99: {
                            registerOut(r);
                            break;
                        }                
                    }
                    break;
                } case 22: { //STR: 2 reg args
                    *(int*)((char*) base + r[ir.arg2]) = r[ir.arg1];
                    break;
                } case 23: { //LDR: 2 reg arg
                    r[ir.arg1] = *(int*)((char*) base + r[ir.arg2]);
                    break;
                } case 24: { //STB: 2 reg args
                    *((char*) base + r[ir.arg2]) = (char) r[ir.arg1];
                    break;
                } case 25: { //LDB: 2 reg args
                    r[ir.arg1] = *((char*) base + r[ir.arg2]);
                    break;
                } case 26: { //Multithread RUN
                    r[ir.arg1] = initializeThread(threadpool, (char*) base, ir.arg2, r);
                    break;
                } case 27: { //Multithread END
                    if(current_thread != 0) threadpool[current_thread] = false;
                    break;
                } case 28: { //Multithread BLK
                    if(current_thread == 0 && childThreadsRunning(threadpool)){
                        *PC -=  12;
                    }
                    break;
                } case 29: { //Multithread LCK
                    if(*(int*)((char*) base + ir.arg1) == -1){
                        *(int*)((char*) base + ir.arg1) = current_thread;
                    }else *PC -=  12;
                    break;
                } case 30: { //Multithread ULK
                    if(*(int*)((char*) base + ir.arg1) == current_thread){
                        *(int*)((char*) base + ir.arg1) = -1;
                    }
                    break;
                }
            }
            //Context Switch here
            //Store current register set
            memcpy(((char*)base + MEM_SIZE - (current_thread * 1024) - 53), &r, sizeof(r));

            //Next thread
            current_thread = (current_thread + 1) % 5;
        }else current_thread = (current_thread + 1) % 5;
    }
    return 0;
}

bool childThreadsRunning(bool* threadpool){
    for(int i = 1; i < 5; i++){
        if(threadpool[i]){
            return true;    
        }
    }
    return false;
}

int initializeThread(bool* threadpool, char*base, int start_addr, int* registers){
    bool available = false;
    int i = 0;
    int threadout = -1;
    
    //Find available thread
    while(!available && i < 5){
        if(!threadpool[i]){
            available = true;
            threadpool[i] = true;
            //Return thread ID
            threadout = i;
        } i++;
    }

    if(available){
        int rset[13];
                        
        //Set registers
        rset[0] = registers[0];
        rset[1] = registers[1];
        rset[2] = registers[2];
        rset[3] = registers[3];
        rset[4] = registers[4];
        rset[5] = registers[5];
        rset[6] = registers[6];
        rset[7] = registers[7];
        rset[8] = start_addr;
        rset[9] = MEM_SIZE - (threadout * 1024) - 1025; //Allocate 1 kibi of stack memory per thread
        rset[10] = MEM_SIZE - (threadout * 1024) - 57;
        rset[11] = 0;
        rset[12] = MEM_SIZE - (threadout * 1024) - 57;

        //Save registers in memory
        memcpy(((char*)base + MEM_SIZE - (threadout * 1024) - 53), &rset, sizeof(rset));
    }
    return threadout;    
}

IR fetchInst(IR in, void* base, int* PC){
    in.opCode = *(int*)((char*) base + *PC);
    in.arg1 = *(int*)((char*) base + *PC + 4);
    in.arg2 = *(int*)((char*) base + *PC + 8);
    return in;
}

void incrementPC(int* PC, program_memory in){
    *PC += 12;
    if(*PC > in.total_bytes){
        std::cout << "!!Program counter advanced beyond memory bounds!!" << std::endl;
        exit(EXIT_FAILURE);
    }
}

void registerOut(int* registers){
    //Dump the register values
    std::cout << "Register out:" << std::endl;
    for(int i = 0; i < 13; i++){
        std::cout << "R" << i << " = " << *(registers + i);
        if(i == 8) std::cout << "\t*PC*";
        if(i == 9) std::cout << "\t*SL*";
        if(i == 10) std::cout << "\t*SP*";
        if(i == 11) std::cout << "\t*FP*";
        if(i == 12) std::cout << "\t*SB*";
        std::cout << std::endl;
    }
    std::cout << std::endl;
    std::cout << std::endl;
}

void stackOut(int* registers, void* base){
    //Dump the stack contents here
    std::cout << std::endl << "Stack out:" << std::endl;
    for(int i = registers[10]; i <= registers[12]; i+=4){
        std::cout << *(int*)((char*) base + i) << std::endl;
    }
    std::cout << std::endl;
    std::cout << std::endl;
}

void memOut(program_memory program){
    //Dump the variable memory
   int ii = 0;
   std::cout << "Memory out:" << std::endl;
   for(char *i = program.memory; i < program.memory + program.starting_address; i++){
       std::cout << std::bitset<8>(*i) << " ";
       ii++;
       if(ii % 4 == 0) std::cout << std::endl;
   }
   std::cout << std::endl;
   std::cout << std::endl;
}
