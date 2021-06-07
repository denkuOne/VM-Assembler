*/
* All code written by BRYCE MARTIN
*/

#include <iostream>
#include <fstream>
#include <regex>
#include <map>

//Allocate 10 KiB for VM memory
#define MEM_SIZE 15360

//This struct is what the VM will access, it contains everything the vm needs to run an .asm program
struct program_memory{
    std::string name;
    int total_bytes;
    int starting_address;
    char memory[MEM_SIZE];
};

int getOpcode(std::string input);
bool validateDataBlock(bool data_done, bool messages, int* error, int line);
void inputReg(std::string reg, std::regex regist, int* error, int line, char* addr, bool messages, bool isdestination);
void inputImm(std::string imm, int* error, int line, char* addr, bool messages);
void retrieveLabel(std::string label, int* error, int line, int* addr, bool messages);
void insertLabel(std::string in, std::regex regist, int* error, int line, int rel_addr, bool messages);

//Global map can be accessed from anywhere
std::map<std::string, int> symbolt;

/**
*   The assemble function takes in any .asm file and assmbles it into a
*   struct that the vm can run as a program.
**/
program_memory assemble(std::string asmloc, bool messages){
    /**
    Regex declarations here, these make parsing the .asm code lines very straightforward
    The instruction regex handles the following instruction types with or without leading labels:
    OPC label
    OPC Rx
    OPC Rx label
    OPC Rx Rx
    OPC Rx immediate
    The labelmatcher regex handles only Op-codes with or without labels:
    OPC
    **/ 
    std::regex instruction("(\\w*)*?\\s?([A-Z]{3}|OR) ?(R\\d+|[A-Z]{2})?,? ?(-?\\w+)( //.*)?");
    std::regex labelmatcher("(\\w*)*?\\s?([A-Z]{3}|OR)(.*)");
    std::regex byt("(\\w*?)?\\s*\\.BYT ('.'|'\\\\n')( //.*)?");
    std::regex intg("(\\w*?)?\\s*\\.INT (-?\\d+)( //.*)?");
    std::regex regist("R([0-7])|([A-Z]{2})");
    std::regex comment("\\s?(//.*)");
    std::regex name("(.+?).asm");

    //Returned struct to VM
    program_memory output;

    if(!std::regex_match(asmloc, name)){
        throw "Input file must be an assembly file (.asm)";
    }else{
        std::regex_token_iterator<std::string::iterator> baseN (asmloc.begin(), asmloc.end(), name, 1);
        output.name = *baseN;
    }

    //Variables needed for opening and reading a file
    std::ifstream filein;
    std::string line;

    //Variables used in the program
    int line_count = 0;
    int error_count = 0;
    int codenum = 0;
    int relAddress = 0;    
    char *memAddress;
    bool data_done = false;

    //Temp variables (Consider using unique_ptr for these to destroy them properly and free space)
    std::string label;
    std::string code;
    std::string arg1;
    std::string arg2;

    //Open the file and check that it exists and can be opened
    filein.open(asmloc, std::ios::in);
    if(filein.is_open()){
        if(messages) std::cout << "Running Assembler now...\n";
        //Read the file line by line, this is also where the assembly takes place
        while(getline(filein,line)){
            line_count += 1;
            //This block reads the data section of a .asm file and records every label and its memAddress
            //and also increments the memAddress counter
            if(std::regex_match(line, intg)){
                if(validateDataBlock(data_done, messages, &error_count, line_count)){
                    std::regex_token_iterator<std::string::iterator> labels (line.begin(), line.end(), intg, 1);
                    label = *labels;

                    //Add labels to table
                    insertLabel(label, regist, &error_count, line_count, relAddress, messages);
                    relAddress += 4;
                }
            }else if(std::regex_match(line, byt)){
                if(validateDataBlock(data_done, messages, &error_count, line_count)){
                    std::regex_token_iterator<std::string::iterator> labels (line.begin(), line.end(), byt, 1);
                    label = *labels;

                    //Add labels to table
                    insertLabel(label, regist, &error_count, line_count, relAddress, messages);
                    relAddress += 1;
                }
            }else if(std::regex_match(line, labelmatcher)){
                //This block reads the instruction section of a .asm file and finds the memAddress of the first instruction
                //it also records every label and its corresponding memAddress
                if(data_done == false){
                    output.starting_address = relAddress;
                    data_done = true;
                }
                std::regex_token_iterator<std::string::iterator> labels (line.begin(), line.end(), labelmatcher, 1);
                label = *labels;

                //Add labels to table and check for register looking labels
                insertLabel(label, regist, &error_count, line_count, relAddress, messages);

                relAddress += 12;

            //This block prints an error message to the screen when an unexpected line of text is found in the given .asm file                    
            }else if(!std::regex_match(line, comment)){
                if(messages) std::cout << "Unrecognized entry. Line #" << line_count << std::endl;
                error_count ++;  
            }
        }
        //First pass complete

        if(error_count > 0){
            if(messages){
                std::cout << error_count;
                throw " error(s) occured during the first pass.";
            } else throw "Add flag -m to see description of error(s).";
        }

        //Set the seeker back to the first line of the file for second pass
        filein.clear();
        filein.seekg(0, filein.beg);

        //Allocates the needed number of bytes for the assembly program
        memAddress = output.memory;

        //Reused variables are reset       
        line_count = 0;
        data_done = false;

        //Second pass
        while(getline(filein,line)){
            line_count += 1;
            //Dump actual .INT and .BYT values into memory
            if(std::regex_match(line, intg) && !data_done){
                std::regex_token_iterator<std::string::iterator> labels (line.begin(), line.end(), intg, 2);
                arg1 = *labels;
                *((int*) memAddress) = std::stoi(arg1);
                memAddress += 4; 
            }else if(std::regex_match(line, byt) && !data_done) {
                std::regex_token_iterator<std::string::iterator> labels (line.begin(), line.end(), byt, 2);
                arg1 = *labels;
                if(arg1 == "\'\\n\'"){
                    *memAddress = '\n';
                }else{
                    *memAddress = arg1.at(1);
                }
                memAddress += 1;                
            }else if(std::regex_match(line, labelmatcher)){
                //Replace Op codes, registers and labels with addresses in memory
                if(data_done == false){
                    data_done = true;
                }
                if(std::regex_match(line, instruction)){
                    std::regex_token_iterator<std::string::iterator> labels (line.begin(), line.end(), instruction, {2, 3, 4});
                    code = *labels;
                    arg1 = *++labels;
                    arg2 = *++labels;
                }else{
                    std::regex_token_iterator<std::string::iterator> labels (line.begin(), line.end(), labelmatcher, 2);
                    code = *labels;
                }
                //Evaluate op code
                codenum = getOpcode(code);
                if(codenum != 0){
                    if(std::regex_match(arg2, regist) && codenum >= 9 && codenum <= 12){
                        codenum += 13;
                    }
                    *((int*) memAddress) = codenum;
                    memAddress += 4;
                }else{
                    if(messages) std::cout << "Unknown op code " << code << ". Line #" << line_count << std::endl;
                    error_count++;
                }

                //Evaluate arguments based on instructions
                switch(codenum){
                    case 1: { //JMP
                        retrieveLabel(arg2, &error_count, line_count, (int*) memAddress, messages);
                        break;
                    }
                    case 2: { //JMR
                        inputReg(arg2, regist, &error_count, line_count, memAddress, messages, false);
                        break;
                    }
                    case 3: { //BNZ
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, false);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);
                        break;
                    } 
                    case 4: { //BGT
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, false);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);
                        break;                        
                    }
                    case 5: { //BLT
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, false);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);
                        break;
                    } 
                    case 6: { //BRZ
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, false);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);
                        break;
                    } 
                    case 7: { //MOV
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);
                        break;
                    } 
                    case 8: { //LDA
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);
                        break;
                    } 
                    case 9: { //STR
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, false);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);
                        break;
                    }
                    case 10: { //LDR
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);
                        break;
                    }
                    case 11: { //STB
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, false);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);                        
                        break;
                    } 
                    case 12: { //LDB
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);                      
                        break;
                    } 
                    case 13: { //ADD
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                                                
                        break;
                    }
                    case 14: { //ADI
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputImm(arg2, &error_count, line_count, memAddress + 4, messages);                        
                        break;
                    }
                    case 15: { //SUB
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                        
                        break;
                    }
                    case 16: { //MUL
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                        
                        break;
                    }
                    case 17: { //DIV
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                        
                        break;
                    }
                    case 18: { //AND
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                        
                        break;
                    }
                    case 19: { //OR
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);
                        break;
                    }
                    case 20: { //CMP
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                        
                        break;
                    }
                    case 21: { //TRP
                        inputImm(arg2, &error_count, line_count, memAddress, messages);                        
                        break;
                    }
                    case 22: { //STR: 2 reg args
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, false);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                             
                        break;
                    }
                    case 23: { //LDR: 2 reg args
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                         
                        break;
                    }
                    case 24: { //STB: 2 reg args
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, false);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                         
                        break;
                    }
                    case 25: { //LDB: 2 reg args
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        inputReg(arg2, regist, &error_count, line_count, memAddress + 4, messages, false);                         
                        break;
                    }
                    case 26: { //Multithread RUN
                        inputReg(arg1, regist, &error_count, line_count, memAddress, messages, true);
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress + 4), messages);
                        break;
                    }
                    //case 27: Multithread END
                    //case 28: Multithread BLK
                    case 29: { //Multithread LCK
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress), messages);
                        break;
                    }
                    case 30: { //Multithread ULK
                        retrieveLabel(arg2, &error_count, line_count, (int*)(memAddress), messages);
                        break;
                    }
                }
                memAddress += 8;   
            }
            if((int)(memAddress - output.memory) > MEM_SIZE){
                throw "More VM memory must be allocated to assemble this file.";
            }
        }
        filein.close();
    } else {
        throw "Assembly file not found!";
    }
    if(error_count > 0){
        if(messages){
            std::cout << error_count;
            throw " error(s) occured during assembly.";
        }
        else throw "Add flag -m to see description of error(s).";
    }else{
        if(messages) std::cout << line_count << " lines of code assembled successfully." << std::endl;        

        output.total_bytes = relAddress;

        return output; 
    }
}

program_memory assembleWithBin(std::string name){
    program_memory output;
    std::ofstream fileout;
     
    try{
        output = assemble(name, true);
    } catch (const char* msg){
        throw msg;
    }
    
    std::cout << "Writing .bin file now... " << std::endl;
    fileout.open(output.name + ".bin");
    for(char* i = output.memory; i < output.memory + MEM_SIZE; i++)
        fileout << std::bitset<8>(*i);
    fileout.close();
    std::cout << "Finished writing .bin file!" << std::endl;

    return output;
}

//Implements a binary search on a sorted array of opCode names and their corresponding opCode numbers
int getOpcode(std::string input){
    static std::array<std::string, 26> opCodeNames = {
        "ADD", "ADI", "AND", "BGT", "BLK", "BLT", "BNZ", "BRZ", 
        "CMP", "DIV", "END", "JMP", "JMR", "LCK", "LDA", "LDB", 
        "LDR", "MOV", "MUL", "OR", "RUN", "STB", "STR", "SUB", 
        "TRP", "ULK"
    };
    static std::array<int, 26> opCodeNumbers = {
        13, 14, 18, 4, 28, 5, 3, 6,
        20, 17, 27, 1, 2, 29, 8, 12, 
        10, 7, 16, 19, 26, 11, 9, 15, 
        21, 30
    };

    int pointer = 12;
    int upper = 25;
    int lower = 0;
    
    while(lower <= pointer && pointer <= upper){
        if(opCodeNames[pointer] < input){
            lower = pointer + 1;
            pointer = lower + (upper - lower)/2;
        }else if(input < opCodeNames[pointer]){
            upper = pointer - 1;
            pointer = upper - (upper - lower)/2;
        }else return opCodeNumbers[pointer];
    }
    return 0;
}

//Places a destination register into memory and does validity checks
//The only difference between this and the function above is that R8 *PC* cannot be written to
void inputReg(std::string reg, std::regex regist, int* error, int line, char* addr, bool messages, bool isdestination){
    if(std::regex_match(reg, regist)){
        std::regex_token_iterator<std::string::iterator> regout (reg.begin(), reg.end(), regist, {1, 2});
        std::string regnum = *regout;
        std::string alias = *++regout;
        int* ptr = (int*) addr;

        if(regnum != ""){
            *ptr = std::stoi(regnum);
        }
        if(alias != ""){
            if(alias == "FP") *ptr = 11;
            else if(alias == "SB") *ptr = 12;
            else if(alias == "SL") *ptr = 9;
            else if(alias == "SP") *ptr = 10;
            else if(alias == "PC"){
                if(isdestination){
                    if(messages) std::cout << "PC cannot be a destination register. Line #" << line << std::endl;
                }else *ptr = 8;
            }else{
                if(messages) std::cout << alias << " is an invalid register alias. Line #" << line << std::endl;
                *error += 1;
            }
        }
    }else{
        if(messages) std::cout << reg << " is not a valid register. Line #" << line << std::endl;
        *error += 1;
    }
}

//Places an immediate value into memory and does a validity check
void inputImm(std::string imm, int* error, int line, char* addr, bool messages){
    int* ptr = (int*) addr;
    try{
        *ptr = std::stoi(imm);
    } catch (const std::invalid_argument){
        if(messages) std::cout << imm << "is not a valid immediate argument. Line #" << line << std::endl;
        *error += 1;
    }
}

//Places the address of a label inside of the map into memory and does a validity check
void retrieveLabel(std::string label, int* error, int line, int* addr, bool messages){
    std::map<std::string, int>::iterator out;
    out = symbolt.find(label);

    if(out == symbolt.end()){
        if(messages) std::cout << label << " is not listed in symbol table. Line #" << line << std::endl;
        *error += 1; 
    } else{
        *addr = symbolt.find(label)->second;
    }
}

//This function places labels and their corresponding addresses into the map
void insertLabel(std::string in, std::regex regist, int* error, int line, int rel_addr, bool messages){   
    if(std::regex_match(in, regist)){
        if(messages) std::cout << "Label " << in << " has the same name as a register. Line #" << line <<std::endl;
        *error += 1;
    } else if(in != ""){
        //Function will ignore any instructions or data entries without labels 
        std::pair<std::map<std::string, int>::iterator, bool> errr;
        errr = symbolt.insert(std::pair<std::string, int>(in, rel_addr));

        if(errr.second == false){
            if(messages) std::cout << in << " already exists in symbol table. Line #" << line << std::endl;
            *error += 1;
        }
    }
}

//This function adds to the error count if a .BYT or .INT code is found after the first instruction
bool validateDataBlock(bool data_done, bool messages, int* error, int line){
    if(data_done){
        if(messages) std::cout << "Unexpected data entry after first instruction. Line #" << line << std::endl;
        *error += 1;
        return false;
    }else return true;
}
