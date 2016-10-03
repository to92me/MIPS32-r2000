#!/usr/bin/env python3
import sys 
# import binascii
import os
import re

from ufw.util import in_network

app_root_folder = sys.path[0] + "/"

file_name_footer = app_root_folder + "footer.vhd"
file_name_header = app_root_folder + "header.vhd"

print("file: ", str(sys.argv[1]))

if len(sys.argv) > 1:
    file_name_hex = sys.argv[1]
    file_name_binary = file_name_hex.split(".")[0] + ".bin"
    file_name_vhd = file_name_hex.split(".")[0] + ".vhd"

file_hex = None
file_bin = None
file_vhd = None
file_header = None
file_footer = None

try:
    file_hex = open(sys.argv[1], 'r')
except OSError as err:
    print("OS error: {0}".format(err))
    exit()



if os.path.exists(file_name_binary):
    print(file_name_binary, "already exists, removig file and creating new one")
    os.remove(file_name_binary) 
    #exit(-1)

if os.path.exists(file_name_vhd):
    print(file_name_vhd, "already exists, removig file and creating new one ")
    os.remove(file_name_vhd)
    #exit(-1)

try:
    file_bin = open(file_name_binary, 'w+')
except OSError as err:
    print("OS error: {0}".format(err))
    exit()

try:
    file_vhd = open(file_name_vhd, 'w+')
except OSError as err:
    print("OS error: {0}".format(err))
    exit()

try:
    file_footer = open(file_name_footer, 'r')
except OSError as err:
    print("OS error: {0}".format(err))
    exit()

try:
    file_header = open(file_name_header, 'r')
except OSError as err:
    print("OS error: {0}".format(err))
    exit()

# print code chunk before rom filling part
for line in file_header.readlines():
    file_vhd.write(line)

instructions_hex = file_hex.readlines()


i = 0
for instruction in instructions_hex:


    instruction = instruction.replace("\n", '')
    instruction = instruction.replace(' ','')

    if not instruction:
        break
    # print(instruction)

    binary32 = bin(int(instruction,16))[2:].zfill(32)
    file_bin.write(binary32 + "\n")
    binary8_3 = binary32[0:8]
    binary8_2 = binary32[8:16]
    binary8_1 = binary32[16:24]
    binary8_0 = binary32[24:32]
    file_vhd.write("rom_0(" + str(i + 3) + ")  <=  \"" + binary8_3 + "\";\n")
    file_vhd.write("rom_0(" + str(i + 2) + ")  <=  \"" + binary8_2 + "\";\n")
    file_vhd.write("rom_0(" + str(i + 1) + ")  <=  \"" + binary8_1 + "\";\n")
    file_vhd.write("rom_0(" + str(i + 0) + ")  <=  \"" + binary8_0 + "\";\n")
    i += 4 

for line in file_footer.readlines():
    file_vhd.write(line)


file_vhd.close()
file_header.close()
file_footer.close()
file_bin.close()
file_hex.close()
