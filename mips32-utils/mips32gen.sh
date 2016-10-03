#!/bin/bash 

ASEMBLY_EXECUTABLE="asembler/assemble.py"
ROM_GENERATOR_EXECUTABLE="rom-generator/generator.py"
HEX_SUFFIX=".hex"
VHD_SUFFIX=".vhd"
BIN_SUFFIX=".bin"
CURRENT_FOLDER=$PWD

ASEMBLY_EXECUTABLE_DIR="${ASEMBLY_EXECUTABLE:0:${#ASEMBLY_EXECUTABLE} - ${#ASEMBLY_EXECUTABLE}}"
ROM_GENERATOR_EXECUTABLE_DIR="${ROM_GENERATOR_EXECUTABLE:0:${#ROM_GENERATOR_EXECUTABLE} - ${#ROM_GENERATOR_EXECUTABLE}}"

function PrintHelp {
    echo "    Usage: mips32gen <asm_file>" 
}


echo " __  __ ___ ____  ____ _________"
echo "|  \/  |_ _|  _ \\/ ___|___ /___ \\"
echo "| |\\/| || || |_) \\___ \\ |_ \\ __) |"
echo "| |  | || ||  __/ ___) |__) / __/ "
echo "|_|  |_|___|_|   |____/____/_____|"
echo "                                  "

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    PrintHelp 
    exit -1 
fi

FILE_ASM=$1
FOLDER_OUTPUT=$2 

if [ ! -f "$CURRENT_FOLDER/$ASEMBLY_EXECUTABLE" ] ; then 
    echo " $CURRENT_FOLDER/$ASEMBLY_EXECUTABLE does not exists" 
    exit -1
fi 

if [ ! -f "$CURRENT_FOLDER/$ROM_GENERATOR_EXECUTABLE" ] ; then 
	echo "$CURRENT_FOLDER/$ROM_GENERATOR_EXECUTABLE does not exists"
	exit -1
fi 

if [ ! -f "$FILE_ASM" ] ; then 
	echo "Input file $1 does not exists"
	exit -1 
fi 
FILE_ASM_NAME=$(basename "$FILE_ASM")
FILE_ASM_NAME_BASE="${FILE_ASM_NAME%.[^.]*}"
FILE_ASM_PATH="${FILE_ASM:0:${#FILE_ASM} - ${#FILE_ASM_NAME}}"

# echo $FILE_ASM_PATH
# # copy assembly file to assembly decoder folder  
# cp $FILE_ASM "$CURRENT_FOLDER/$ASEMBLY_EXECUTABLE_DIR"

# #ch dir to assembly folder
# cd "$CURRENT_FOLDER/$ASEMBLY_EXECUTABLE_DIR"

# create output file 
if [ ! -f "${FILE_ASM_PATH}${FILE_ASM_NAME_BASE}${HEX_SUFFIX}" ] ; then 
	touch "${FILE_ASM_PATH}${FILE_ASM_NAME_BASE}${HEX_SUFFIX}"
fi 

# execute assembly 
echo ""
echo "Generating hex file"
./"$ASEMBLY_EXECUTABLE" $FILE_ASM > "${FILE_ASM_PATH}${FILE_ASM_NAME_BASE}${HEX_SUFFIX}"
echo "done"
echo 

echo "Generating binary and vhd file"
echo
./"$ROM_GENERATOR_EXECUTABLE" "${FILE_ASM_PATH}${FILE_ASM_NAME_BASE}${HEX_SUFFIX}" 
echo
echo "done"

# mv "${ROM_GENERATOR_EXECUTABLE_DIR}${FILE_ASM_NAME_BASE}${VHD_SUFFIX}" "${FILE_ASM_PATH}/"
# mv "${ROM_GENERATOR_EXECUTABLE_DIR}${FILE_ASM_NAME_BASE}${BIN_SUFFIX}" "${FILE_ASM_PATH}/"