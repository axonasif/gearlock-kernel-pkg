
#######################################################################################################
#####=============================== Package/Extension Information ===============================#####

NAME="Kernel" #Package/Extension Name

TYPE="Package" #Specify (Package / Extension)

AUTHOR="AXON" #Your name as the Developer/Owner/Packer

VERSION="1.0" #Specify the Version of this package/extension

SHORTDESC="Bakes you a cake @_@" #Provide a short description about this package/extension

C_EXTNAME="" #For Specifing a custom name for your extension script ($NAME is used if not defined)

#####=============================== Package/Extension Information ===============================#####
#######################################################################################################




#------------------------------------------------------------------------------------------------------




#######################################################################################################
######=============================== Package/Extension Functions ===============================######

REQSYNC="yes" #Require Sync (Deafult - yes)

REQREBOOT="yes" #(Deafult - no) Use if your package/extension modifies any major system file

GEN_UNINS="yes" #(Deafult - no) If you want GearLock to generate a uninstallation script itself

SHOW_PROG="yes" #(Default - yes) Whether to show extraction progress while loading the pkg/extension

######=============================== Package/Extension Functions ===============================######
#######################################################################################################




#------------------------------------------------------------------------------------------------------




#######################################################################################################
######========================================== Banner =========================================######
                          #Do not edit me unless you know what you're doing#
geco "${BBLUE}\c"
cat << EOF
  ______   ______   ______   ______   ______   ______   ______   ______   ______   ______   ______   ______ 
 /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/ 
 
  ._.   ___                                                             
  | |  / /   *Name: $NAME
  |_|  \ \   *Version: $VERSION
  |-|  < <   *Author: $AUTHOR
  | |  / /   *Type: $TYPE
  |_|  \_\_  *ShortDesc: $SHORTDESC
  
  ______   ______   ______   ______   ______   ______   ______   ______   ______   ______   ______   ______ 
 /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/  /_____/ 
EOF
geco "${RC}\c"

######========================================== Banner =========================================######
#######################################################################################################
