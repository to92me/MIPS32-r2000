from MySql import Database 
from ReadFile import ReadFile

print("progress:")
print("   connecting to Database")
db = Database()

print("   in  Pakage file") 
package = ReadFile();
 
package.OpenFile('Definitions_pkg.vhd')
print("   opening Package file OK ")

package.ReadFile()
print("   reading Package file OK ") 

print("parsing")  
opcode_list = package.GetOpcodeList()
print("        -> opcodes OK :", len(opcode_list))
func_list = package.GetFuncList()
print("        -> funcs OK   :", len(func_list))

print("   clearing database")
db.ClearDatabseFunc()
print("        -> func table OK")
db.ClearDatabseOpcode() 
print("        -> Opcde table OK")

print("   sending data to databes")
for item in opcode_list:
    db.PutNewOpcode(item[0], item[1])
print("        -> Opcodes OK")
      
for item in func_list:
    db.PutNewFunc(item[0],item[1])
print("        -> Funcs OK")

