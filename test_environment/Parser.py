
# import Asm
# import ReadFile
from SyntaxCheck import Parser
from MySql import Database
import sys


db = Database()
file_name = str(sys.argv[1])
output_file = "assembly.asm"
file_name = "test.asm"
db.PutNewOpcode('OR', 1011)

pars = Parser()
pars.OpenFile(file_name, output_file)
for i in range(0, 20):
    print(i)
    pars.ReadLine()
    print("__________\n")
        

#print("argumet is: ", str(sys.argv[1]))

