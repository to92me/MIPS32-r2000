from MySql import Database


class Parser():
    def __init__(self):
        self.a_open = False
        self.b_open = False
        self.line_elements = []
        self.db = Database()

    def OpenFile(self, file_name1, file_name2):
        try:
            self.a = open(file_name1, 'r')
            self.a_open = True
        except:
            print("Error  404 file not found")
            exit()
        try:
            self.b = open(file_name2, 'w')
            self.b_open = True
        except:
            print("Error opening assembly.asm file")
            exit()

    def ReadFile(self):
        if self.a_open is True:
            print(" TODO ")
        else:
            print("Error  file not opened")
            return False
        return True

    def ReadLine(self):
        if (self.a_open is True):
            self.one_line = self.a.readline()
            self.CheckCommentLine()
            return True
        else:
            return False

    def CheckCommentLine(self):
        for char in self.one_line:
            if char == ' ':
                continue
            elif char == '#':
                print("this is commnet line")
                return
            else:
                self.ParsLine()
                # print("parsing")
                return

    def ParsLine(self):
        help_list = []
        line_list = self.one_line.split(' ')
        # print(line_list)
        for item in line_list:
            for char in item:
                if char.isspace() or char == ' ':
                    continue
                else:
                    help_list.append(item)
                    break

        if len(help_list):
            self.CheckForComment(help_list)
            print(self.line_elements)
            self.CheckAssCommand()
            self.line_elements.clear()

    def CheckForComment(self, help_list):
        for item in help_list:
            for char in item:
                if char == '#':
                    return
                else:
                    self.line_elements.append(item)
                    break

    def CheckAssCommand(self):
        command = self.line_elements.pop(0)
        print(command)
        bin_dat = self.db.OpcodeSearchForBin(command)
        if bin_dat is False:
            bin_dat = self.db.FuncSearchForBin(command)
            if bin_dat is False:
                print("SYNTAX ERROR")
                return
            else:
                print(bin_dat)
                self.ParseFunc()
        else:
            print(bin_dat)
            self.ParseOpcode()
        return

    def ParseOpcode(self):
        element = self.line_elements.pop(0)
        if element[0] != '$':
            print("TODO") 
        print("opcod")
        return

    def ParseFunc(self):
        print("func")
        return 
        


# TODO ako je opcode ide se dalje sa parsovanjem da li je sa addressama ili
# nije proverti tacnost sintakse da li ok
# TODO loger
# raise Error

