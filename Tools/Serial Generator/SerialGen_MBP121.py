# Serial Generator For MacBookPro12,1 SMBIOS by nguyenlc1993
# Based on the work of many people at InsanelyMac, as well as my research about Apple part serials.
# Original thread: http://www.insanelymac.com/forum/topic/303073-pattern-of-mlb-main-logic-board/
# Usage: python SerialGen.py [-hq]

import os, random, sys
from datetime import date
from xml.etree import ElementTree
from xml.etree.ElementTree import Element, SubElement

# Title and version
SCRIPT_TITLE = 'Serial Generator For MacBookPro12,1 SMBIOS by nguyenlc1993'
SCRIPT_VERSION = '1.0'

# Basic constants
WEEKS_IN_A_YEAR = 52
BASE34 = '0123456789ABCDEFGHJKLMNPQRSTUVWXYZ'
MINIMUM_DATE = date(2015, 3, 9)
MAXIMUM_DATE = date.today()
TARGET_PRODUCT_NAME = 'MacBookPro12,1'

# Constants for system serial generation
SSN_GEN_COUNT = 5
SSN_BASE_YEAR = 2010
SSN_LOCATION_CODE = ['C02',]
SSN_YEAR_CODE = 'CDFGHJKLMNPQRTVWXY'
SSN_WEEK_CODE = '123456789CDFGHJKLMNPQRTVWX'
SSN_MODEL_CODE = ['FVH3', 'FVH5', 'FVH8']

# Constants for MLB generation
BSN_GEN_COUNT = 5
BSN_WEEK_DIFF = -2
BSN_EEE_CODE = [
    'GDVN', 'GDVQ', 'GDVR', 'GDVT', 'GDVV', 'GDVW', 'GDVY',
    'GDW1', 'GDW2', 'GDW3', 'GDW4', 'GDW5', 'GDW6',
    'GQ0T', 'GQ0V', 'GQ0W', 'GQ0X', 'GQ0Y',
    'GQ10', 'GQ11', 'GQ12', 'GQ13'
]
BSN_16THDIGIT_CODE = ['1', 'A']

# Constant for config.plist generation
CONFIG_DEFAULTPATH = os.path.join(os.path.expanduser('~'), 'Desktop', 'config.plist')
CONFIG_HEADER = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
'''

# Property List of SMBIOS
SMBIOS_PROPS = {
    'BiosReleaseDate' : '02/11/16',
    'BiosVendor' : 'Apple Inc.',
    'BiosVersion' : 'MBP121.88Z.0167.B16.1602111810',
    'Board-ID' : 'Mac-E43C1C25D4880AD6',
    'BoardManufacturer' : 'Apple Inc.',
    'BoardSerialNumber' : '0123456789ABCDEFG',
    'BoardType' : '10',
    'ChassisAssetTag' : 'MacBook-Aluminum',
    'ChassisManufacturer' : 'Apple Inc.',
    'ChassisType' : '10',
    'Family' : 'MacBook Pro',
    'Manufacturer' : 'Apple Inc.',
    'Mobile' : True,
    'ProductName' : 'MacBookPro12,1',
    'SerialNumber' : '0123456789AB',
    'SmUUID' : '',
    'Trust' : True,
    'Version' : '1.0'
}

# Program UI

PHASE1_HEADER = '1. Generate System Serial'
PHASE1_INSTRUCTION = '''
In this phase, the script will generate {0} random system serial(s) for {1} configuration, each will be assigned with an index number.
You will have to manually check whether any of those generated serials can be used on your Hackintosh by doing the following steps:

- Visit https://selfsolve.apple.com
- Enter the serial you want to check, enter the CAPTCHA code, then click Continue.
-- If the website displayed 'Your Service and Support Coverage' following a bunch of information, then the serial was used on a real Mac, and should not be used on your Hackintosh.
-- If the website displayed 'We're sorry, the number you have provided cannot be found in our records. Please verify the number and try again, or contact us.', then the serial is available, and can be used on your Hackintosh. :D
-- If the website displayed 'We're sorry, but this serial number is not valid. Please check your information and try again.', then the serial was either blacklisted or failed the validation check by Apple. In this case, send feedback to me so I will try to fix the script.

When one of those serials is available for your Hackintosh (the second case), input the index number of that serial, then the seript will continue to generate the board serial.
'''.format(SSN_GEN_COUNT, TARGET_PRODUCT_NAME)
PHASE1_INSTRUCTION2 = 'List of generated system serials (please remember to check them):'
PHASE1_PROMPTMSG = 'Choose your system serial (1 - {0}, 0 to regenerate): '.format(SSN_GEN_COUNT)
PHASE1_ENDMSG = 'Your chosen system serial is {0}. Now go to Phase 2.'

PHASE2_HEADER = '2. Generate Board Serial (a.k.a MLB serial)'
PHASE2_INSTRUCTION = '''
In this phase, the script will generate {0} random board serial(s) corresponding with the chosen system serial above, each will be assigned with an index number.
You can choose any serial you prefer, as they are generated in the same way.
The generation algorithm is mainly based on my hypothesis of Apple part serial format, which is still incomplete and not certainly 100% correct.
Fortunately, Apple has relaxed their MLB validation check, so these serials may work. But you may still have to call Apple support later to whitelist the board serial.
'''.format(BSN_GEN_COUNT)
PHASE2_INSTRUCTION2 = 'List of generated board serials:'
PHASE2_PROMPTMSG = 'Choose your board serial (1 - {0}, 0 to regenerate): '.format(BSN_GEN_COUNT)
PHASE2_ENDMSG = 'Your chosen board serial is {0}. Now go to Phase 3.'

PHASE3_HEADER = '3. Generate config.plist'
PHASE3_INSTRUCTION = '''
In this phase, the script will generate a config.plist file which contains only SMBIOS keys for {0} configuration.
Your chosen system serial and board serial will be used in this config.plist (SerialNumber and BoardSerialNumber keys respectively).
If your BIOS has SId bug (inconsistent system UUID), then you may have to generate your own UUID as below:
- Open Terminal, run uuidgen several times to get your UUID.
- Set config.plist -> SMBIOS -> SmUUID key to your generated UUID.
- Add 'InjectSystemID' key to config.plist -> SystemParameters section and set it to Yes.
ROM value will be taken from your system UUID by default (last 12 hexadecimal digits). You may want to set your own ROM value in config.plist -> RtVariables -> ROM key.
If you have already generated your own config.plist with SMBIOS keys, you can skip this phase. Just enter the chosen serials to your config.plist.
'''.format(TARGET_PRODUCT_NAME)
PHASE3_PROMPTMSG = 'Do you want to create config.plist on your Desktop (y/n)? '

SCRIPT_ENDMSG = 'All done! Have a nice day.'

# Runtime variables
SCRIPT_FILENAME = ''
SCRIPT_DISPLAYUSAGE = False
SCRIPT_DISPLAYINSTRUCTION = True

# Functions to get input
def getUnsignedInt(msg, limit = sys.maxint):
    if limit < 0:
        raise ValueError
    print msg,
    valid = False
    while not valid:
        buf = raw_input()
        if str.isdigit(buf):
            value = int(buf)
            valid = (value <= limit)
        if valid:
            return value
        else:
            print 'Invalid! Enter again: ',

def getYesNo(msg):
    print msg,
    valid = False
    while not valid:
        buf = raw_input()
        if buf.upper() in ['Y', 'YES']:
            value = True
            valid = True
        elif buf.upper() in ['N', 'NO']:
            value = False
            valid = True
        if valid:
            return value
        else:
            print 'Invalid! Enter again: ',

# Funstions related to year-week
def getRandomYearWeek(minDate, maxDate):
    rDate = date.fromordinal(random.choice(range(MINIMUM_DATE.toordinal(), MAXIMUM_DATE.toordinal())))
    year = rDate.year
    week = int(rDate.isocalendar()[1])
    if week > WEEKS_IN_A_YEAR:
        week -= WEEKS_IN_A_YEAR
        if rDate.month == 12:
            year += 1
    return (year, week)

def getYWFromSSN(systemSerial):
    iYear = SSN_YEAR_CODE.find(systemSerial[3])
    iWeek = SSN_WEEK_CODE.find(systemSerial[4])
    year = iYear // 2 + SSN_BASE_YEAR
    week = iWeek + 1
    if iYear % 2 == 1:
        week += WEEKS_IN_A_YEAR // 2
    return (year, week)

# Functions to generate system serial
def getSSNLocationCode():
    return random.choice(SSN_LOCATION_CODE)

def getSSNYWCode(year, week):
    iYear = (year - SSN_BASE_YEAR) * 2
    iWeek = week - 1
    if week > (WEEKS_IN_A_YEAR // 2):
        iYear += 1
        iWeek -= (WEEKS_IN_A_YEAR // 2)
    sYWCode = SSN_YEAR_CODE[iYear] + SSN_WEEK_CODE[iWeek]
    return sYWCode

def getSSNUnitNumberCode():
    return random.choice(BASE34[:27]) + random.choice(BASE34) + random.choice(BASE34[1:])

def getSSNModelCode():
    return random.choice(SSN_MODEL_CODE)

def getRandomSSN(year, week):
    return getSSNLocationCode() + getSSNYWCode(year, week) + getSSNUnitNumberCode() + getSSNModelCode()

# Functions to generate board serial
def getBSNLocationCode(systemSerial):
    return systemSerial[0:3]

def getBSNYWCode(systemSerial):
    year = getYWFromSSN(systemSerial)[0]
    week = getYWFromSSN(systemSerial)[1]
    week += BSN_WEEK_DIFF
    if week <= 0:
        year -= 1
        week += WEEKS_IN_A_YEAR
    elif week > WEEKS_IN_A_YEAR:
        year += 1
        week -= WEEKS_IN_A_YEAR
    ywCode = '{0:01}{1:02}'.format(year - SSN_BASE_YEAR, week)
    return ywCode

def getBSNWeekdayCode():
    return random.choice('2345')

def getBSNUnitNumberCode():
    nCode = '0000'
    while nCode.count('0') > 2:
        nCode = '0' + random.choice(BASE34) + random.choice(BASE34) + random.choice(BASE34)
    else:
        return nCode

def getBSNEEECode():
    return random.choice(BSN_EEE_CODE)

def getBSNCCCode():
    return random.choice(BSN_16THDIGIT_CODE) + random.choice(BASE34)

def getRandomBSN(systemSerial):
    return getBSNLocationCode(systemSerial) + getBSNYWCode(systemSerial) + getBSNWeekdayCode() + getBSNUnitNumberCode() + getBSNEEECode() + getBSNCCCode()

# Functions to write config.plist
def indentXML(elem, level = 0):
  i = '\n' + level * '\t'
  if len(elem):
    if not elem.text or not elem.text.strip():
      elem.text = i + '\t'
    if not elem.tail or not elem.tail.strip():
      elem.tail = i
    for elem in elem:
      indentXML(elem, level+1)
    if not elem.tail or not elem.tail.strip():
      elem.tail = i
  else:
    if level and (not elem.tail or not elem.tail.strip()):
      elem.tail = i

def writeConfigFile():
    configRoot = Element('plist', {'version' : '1.0'})
    configDict = SubElement(configRoot, 'dict')
    SubElement(configDict, 'key').text = 'SMBIOS'
    smbiosDict = SubElement(configDict, 'dict')
    # Write SMBIOS dict.
    smbiosKeys = SMBIOS_PROPS.keys()
    smbiosKeys.sort()
    for key in smbiosKeys:
        SubElement(smbiosDict, 'key').text = key
        if isinstance(SMBIOS_PROPS[key], str):
            SubElement(smbiosDict, 'string').text = SMBIOS_PROPS[key]
        elif isinstance(SMBIOS_PROPS[key], bool):
            SubElement(smbiosDict, 'true')
    # Write SystemParameters dict.
    SubElement(configDict, 'key').text = 'SystemParameters'
    sysParamDict = SubElement(configDict, 'dict')
    SubElement(sysParamDict, 'key').text = 'InjectSystemID'
    SubElement(sysParamDict, 'false')
    indentXML(configRoot)
    configTree = ElementTree.ElementTree(configRoot)
    with open(CONFIG_DEFAULTPATH, 'w') as f:
        f.write(CONFIG_HEADER)
        configTree.write(f, 'utf-8')

# Main functions
def clearScreen():
    os.system('cls' if os.name == 'nt' else 'clear')

def setupParameters():
    global SCRIPT_FILENAME, SCRIPT_DISPLAYUSAGE, SCRIPT_DISPLAYINSTRUCTION
    argList = []
    for arg in sys.argv: argList.append(str(arg).strip())
    SCRIPT_FILENAME = os.path.basename(argList[0])
    SCRIPT_DISPLAYUSAGE = '-h' in argList
    SCRIPT_DISPLAYINSTRUCTION = not '-q' in argList

def printUsage():
    print 'Usage: python {0} [-hq]'.format(SCRIPT_FILENAME)
    print '\t-h\tDisplay this help message.'
    print '\t-q\tRun the script in quick mode (no instruction).'

def printProgramTitle():
    print '{0} (v{1})'.format(SCRIPT_TITLE, SCRIPT_VERSION)
    print

def phase1_SSN():
    global SMBIOS_PROPS
    generatedSSN = list(range(SSN_GEN_COUNT))
    print PHASE1_HEADER
    if SCRIPT_DISPLAYINSTRUCTION: print PHASE1_INSTRUCTION
    choice = 0
    while choice == 0:
        if SCRIPT_DISPLAYINSTRUCTION: print PHASE1_INSTRUCTION2

        for i in range(0, SSN_GEN_COUNT):
            yw = getRandomYearWeek(MINIMUM_DATE, MAXIMUM_DATE)
            generatedSSN[i] = getRandomSSN(yw[0], yw[1])
            print '{0:2} - {1}'.format(i + 1, generatedSSN[i])
        choice = getUnsignedInt(PHASE1_PROMPTMSG, SSN_GEN_COUNT)
    else:
        choice -= 1
        SMBIOS_PROPS['SerialNumber'] = generatedSSN[choice]
        print PHASE1_ENDMSG.format(generatedSSN[choice])
        print

def phase2_BSN():
    global SMBIOS_PROPS
    generatedBSN = list(range(BSN_GEN_COUNT))
    print PHASE2_HEADER
    if SCRIPT_DISPLAYINSTRUCTION: print PHASE2_INSTRUCTION
    choice = 0
    while choice == 0:
        if SCRIPT_DISPLAYINSTRUCTION: print PHASE2_INSTRUCTION2
        for i in range(0, BSN_GEN_COUNT):
            generatedBSN[i] = getRandomBSN(SMBIOS_PROPS['SerialNumber'])
            print '{0:2} - {1}'.format(i + 1, generatedBSN[i])
        choice = getUnsignedInt(PHASE2_PROMPTMSG, BSN_GEN_COUNT)
    else:
        choice -= 1
        SMBIOS_PROPS['BoardSerialNumber'] = generatedBSN[choice]
        print PHASE2_ENDMSG.format(generatedBSN[choice])
        print

def phase3_config():
    print PHASE3_HEADER
    if SCRIPT_DISPLAYINSTRUCTION: print PHASE3_INSTRUCTION
    choice = getYesNo(PHASE3_PROMPTMSG)
    if choice == True:
        writeConfigFile()
        print 'config.plist has been generated on your Desktop folder!'
    else:
        print 'Skipped! Remember to set these keys in your config.plist -> SMBIOS section:'
        print
        print '{0}: {1}'.format('SerialNumber', SMBIOS_PROPS['SerialNumber'])
        print '{0}: {1}'.format('BoardSerialNumber', SMBIOS_PROPS['BoardSerialNumber'])
    print

# Main program
def main():
    setupParameters()
    if SCRIPT_DISPLAYUSAGE:
        printUsage()
    else:
        clearScreen()
        printProgramTitle()
        phase1_SSN()
        phase2_BSN()
        phase3_config()
        print SCRIPT_ENDMSG

main()
