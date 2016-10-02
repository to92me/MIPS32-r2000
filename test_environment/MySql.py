import MySQLdb

class Database():
    "MySql database class for connecting and manageing data"
    def __init__ (self):
        try:
            self.db = MySQLdb.connect("192.168.0.1", "client", "tome", "mips_assembly")
            self.cur = self.db.cursor()
        except:
            print("could not connet to databse, check your connection to internet, \n if you have connection to internet than contact sql database maintaner ")
            exit()

    def __exit__ (self):
        try:
            self.db.__exit__()
        except:
            print("__exit__ phase has gone to hell")
            return False

    def ClearDatabseOpcode(self):
        try: 
            #self.cur.execute("delete from opcode")
            #self.cur.execute("alter table opcode auto_increment = 0")
            self.cur.execute("truncate table opcode")
        except:
            print("Err in cleaning opcode table")
            return False 
        return True

    def ClearDatabseFunc(self):
        try: 
            #self.cur.execute("delete from func")
            #self.cur.execute("alter table func auto_increment = 0")
            self.cur.execute("truncate table func") 
        except:
            print("Err in cleaning func table")
            return False  
        return True
            
    def OpcodeSearchForBin(self, asm):
        query = ("select bin from opcode where asm = '{0}'")
        try: 
            self.cur.execute(query.format(asm))
            self.rows = self.cur.fetchall()
        except:
            print("In OpcodeShearchForBin\nError in fetching from Database")
            return False
        if len(self.rows):
            self.row = self.rows[0]
            return (self.row[0])
        else:
            return False
        
    def OpcodeSearchForAsm(self, shin):
        query = ("select asm from opcode where bin = '{0}'")
        try: 
            self.cur.execute(query.format(shin))
            self.rows = self.cur.fetchall()
        except:
            print("in OpcodeShearchForAsm\nError in fetching from Database")
            return False
        if len(self.rows):
            self.row = self.rows[0]
            return (self.row[0])
        else:
            return False

    def FuncSearchForBin(self, asm):
        query = ("select bin from func where asm = '{0}'")
        try: 
            self.cur.execute(query.format(asm))
            self.rows = self.cur.fetchall()
        except:
            print("in FuncShearchForBin\n Error in fetching Databes")
            return False
        if len(self.rows):
            self.row = self.rows[0]
            return (self.row[0])
        else:
            return False
        
    def FuncSearchForAsm(self, shin):
        query = ("select asm from func where bin = '{0}'")
        try:
            self.cur.execute(query.format(shin))
            self.rows = self.cur.fetchall()
        except:
            print("in FuncShearchForAsm\nError in fetching Database")
            return False
        if len(self.rows):
            self.row = self.rows[0]
            return (self.row[0])
        else:
            return False

    def PutNewOpcode(self, asm, shin):
        query = ("insert into opcode value('{0}','{1}', NULL)")
        try: 
             self.cur.execute(query.format(asm, shin))
             self.db.commit()
        except:
            print("in PutNewOpcode\n Error in commiting to Databse")
            return False 
        return True 
     
    def PutNewFunc(self, asm, shin):
        query = ("insert into func value('{0}','{1}', NULL)")
        try: 
            self.cur.execute(query.format(asm, shin))
            self.db.commit()
        except:
            print("in PutNewFunc\n Error in commiting to Database")
            return False
        return True

     
