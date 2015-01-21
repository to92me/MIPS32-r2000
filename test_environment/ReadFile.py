from pack import OpcodePack
from pack import FuncPack

class ReadFile ():
    """read  file class insace it and call methodes"""
    def __init__(self):
        #TODO napraviri lep init deo :D
        self.file_opened = False
        print("it is inited")
        self.line_elements = []
        self.OpcodePack = OpcodePack()
        self.FuncPack = FuncPack() 

    def OpenFile(self, file_name):
        try:
            self.f = open(file_name,'r' )
            self.file_opened = True
        except:
            print("there is no ", file_name, " file ")
            self.file_opened = False
            exit() 

    def ReadFile(self):
        if self.file_opened == True:
            for self.line  in self.f:
                #print(self.line) 
                self.one_line = self.line  
                self.ParseLine()  
            else:
                return False
        return True 

    def ReadLine(self):
       if self.file_opened == True:
           self.one_line = self.f.readline()
           self.ParseLine() 
           return True 
       else:
           return False

    def ParseLine(self):
        if self.file_opened == True:
            for char in self.one_line:
                if char == ' ':
                    continue
                elif char == '-':
                    #print("this is commnet line")
                    return
                else:
                    self.ParseCommand()
                    return
        else:
            return
        
    def ParseCommand(self):
        line_list = self.one_line.split(' ')
        #print(line_list)
        for item in line_list:
            for char in item:
                if char.isspace():
                    continue
                else:
                    self.line_elements.append(item) 
                    break
                
        if len(self.line_elements):
            self.CheckCommnad()
            self.line_elements.clear()
        
        return 


    def CheckCommnad(self):
        if self.line_elements[0] != 'constant':
            #print("no constant", self.line_elements,"\n") 
            return
        else:
            self.GetData()
            return
            

    def GetData(self):
        asm_dat = self.line_elements[1]
        bin_dat = self.line_elements[5]
        asm_dat_list = asm_dat.split('_') 
       
        
        if asm_dat_list[1] == 'op':
            bin_dat_list = bin_dat.split('"')
            self.OpcodePack.SetOpcode(asm_dat_list[0], bin_dat_list[1])
        elif asm_dat_list[1] == 'fun':
            bin_dat_list = bin_dat.split('"')
            self.FuncPack.SetFunc(asm_dat_list[0], bin_dat_list[1]) 
            
        #print("asm dat is:", asm_dat)
        #print("bin dat is:", bin_dat)
        return 
            
    def GetOpcode(self):
        return(self.OpcodePack.GetOpcode())

    def GetOpcodeList(self):
        return(self.OpcodePack.GetOpcodeList())

    def GetFunc(self):
        return(self.FuncPack.GetFunc())

    def GetFuncList(self):
        return(self.FuncPack.GetFuncList())

    
        
