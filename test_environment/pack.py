

class OpcodePack():
    "OPcode list "
    def __init__(self):
        self.data = []
        #print("opcode inited")
        self.counter = 0
        
    def SetOpcode(self, asm_dat, bin_dat):
        self.data.append([asm_dat, bin_dat])
        self.counter += 1 
        #print(self.counter," opcode", asm_dat, bin_dat )

    def GetOpcode(self):
        ret_list = self.data.popleft();
        return ret_list

    def GetOpcodeList(self):
        return self.data

    def GetOpcodeListSize(self):
        return (len(self.data)) 
    

class FuncPack():
    "Func list"
    def __init__(self):
        self.data = []
        self.counter = 0 

    def SetFunc(self, asm_dat, bin_dat):
        self.data.append([asm_dat, bin_dat])
        self.counter += 1 
        #print(self.counter," func: ",asm_dat, bin_dat)

    def GetFunc(self):
        ret_list = self.data.popleft()
        return ret_list

    def GetFuncList(self):
        return self.data

    def GetFuncListsize(self):
        return (len(self.data))
