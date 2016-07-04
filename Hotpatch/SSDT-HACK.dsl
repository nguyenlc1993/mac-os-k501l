/*
    This is SSDT-HACK written for ASUS K501LX/K501LB.
    
    Author: nguyenlc1993
    Credit: RehabMan for his awesome collection of tiny SSDT samples.
    
    By using this SSDT and an appropriate config.plist, you will get these benefits:
    
    - No need to patch/repatch DSDT anymore.
    - SSDT-HACK usually will work with further BIOS updates without having to be modified.
    - Floating region issue will be completely eliminated.
    - SSDT-HACK can be applied to K501LB model.
    
    How to install: just copy SSDT-HACK.aml to /EFI/CLOVER/ACPI/patched and config.plist to /EFI/CLOVER/.
    
    Below are the required DSDT fixes/patches in config.plist/ACPI/DSDT section:

    I. Mandatory DSDT Fixes:
    
    1. FixHPET_0010
    2. FixIPIC_0040
    3. FIX_RTC_20000
    4. FIX_TMR_40000
    5. NewWay_80000000
    
    Optional: Rtc8Allowed = YES
    
    II. Mandatory DSDT binary patches:
    
    1.  _OSI to XOSI (5F4F5349 -> 584F5349)
    2.  _PTS(1,N) to ZPTS(1,N) (5F50545301 -> 5A50545301)
    3.  _WAK(1,N) to ZWAK(1,N) (5F57414B01 -> 5A57414B01)
    4.  GPRW(2,N) to XPRW(2,N) (4750525702 -> 5850525702)
    5.  TACH(1,S) to TACZ(1,S) (5441434809 -> 5441435A09)
    6.  BIFA(0,N) to BIFZ(0,N) (4249464100 -> 4249465A00)
    7.  SMBR(3,S) to SMRZ(3,S) (534D42520B -> 534D525A0B)
    8.  SMBW(5,S) to SMWZ(5,S) (534D42570D -> 534D575A0D)
    9.  ECSB(7,N) to ECSZ(7,N) (4543534207 -> 4543535A07)
    10. _BIX(0,N) to ZBIX(0,N) (5F42495800 -> 5A42495800)
    11. _Q0B(0,N) to ZQ0B(0,N) (5F51304200 -> 5A51304200)
    12. _Q0C(0,N) to ZQ0C(0,N) (5F51304300 -> 5A51304300)
    13. _Q0D(0,N) to ZQ0D(0,N) (5F51304400 -> 5A51304400)
    14. _Q0E(0,N) to ZQ0E(0,N) (5F51304500 -> 5A51304500)
    15. _Q0F(0,N) to ZQ0F(0,N) (5F51304600 -> 5A51304600)
    16. _Q13(0,N) to ZQ13(0,N) (5F51313300 -> 5A51313300)
    17. _Q14(0,N) to ZQ14(0,N) (5F51313400 -> 5A51313400)
    18. _Q15(0,N) to ZQ15(0,N) (5F51313500 -> 5A51313500)
    19. Fix logic error in FBST (A00A4348 47530070 0A0260A1 04700160 -> A00A4348 47530070 0A0260A1 04700060)
    20. D029@1F,3 to MCHC@0 (5B820F44 30323908 5F414452 0C03001F 00 -> 5B820F4D 43484308 5F414452 0C000000 00)
    
    III. Other recommended DSDT patches:
    
    21. _DSM to XDSM (5F44534D -> 5844534D)
    22. EHC1 to EH01 (45484331 -> 45483031)
    23. EHC2 to EH02 (45484332 -> 45483032)
    24. GFX0 to IGPU (47465830 -> 49475055)
    25. B0D3 to HDAU (42304433 -> 48444155)
    26. HECI to IMEI (48454349 -> 494D4549)
*/

DefinitionBlock ("", "SSDT", 2, "HACK", "K501LX", 0)
{
    // Original objects    
    External (\OWLD, MethodObj)
    External (\OBTD, MethodObj)
    External (\BSLF, IntObj)
    External (\_SB.ATKP, IntObj)
    External (\_SB.KBLV, FieldUnitObj)
    External (\_SB.ATKD, DeviceObj)
    External (\_SB.ATKD.IANE, MethodObj)
    External (\_SB.PCI0, DeviceObj)
    External (\_SB.PCI0.LPCB, DeviceObj)
    External (\_SB.PCI0.LPCB.EC0, DeviceObj)
    External (\_SB.PCI0.LPCB.EC0.ECAV, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.GBTT, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.BATP, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.SWTC, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.WRAM, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.MUEC, MutexObj)
    External (\_SB.PCI0.LPCB.EC0.ECOR, OpRegionObj)
    External (\_SB.PCI0.LPCB.EC0.SMBX, OpRegionObj)
    External (\_SB.PCI0.LPCB.EC0.SMB2, OpRegionObj)
    External (\_SB.PCI0.LPCB.EC0.ADD2, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.ADDR, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.BCN2, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.BCNT, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.CMD2, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.CMDB, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.DA20, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.DA21, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.DAT0, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.DAT1, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.PRT2, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.PRTC, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.SST2, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.SSTS, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC0.RDBL, IntObj)
    External (\_SB.PCI0.LPCB.EC0.RDBT, IntObj)
    External (\_SB.PCI0.LPCB.EC0.RDQK, IntObj)
    External (\_SB.PCI0.LPCB.EC0.RDWD, IntObj)
    External (\_SB.PCI0.LPCB.EC0.RCBT, IntObj)
    External (\_SB.PCI0.LPCB.EC0.WRBL, IntObj)
    External (\_SB.PCI0.LPCB.EC0.WRBT, IntObj)
    External (\_SB.PCI0.LPCB.EC0.WRQK, IntObj)
    External (\_SB.PCI0.LPCB.EC0.WRWD, IntObj)
    External (\_SB.PCI0.LPCB.EC0.SDBT, IntObj)
    External (\_SB.PCI0.LPCB.EC0.SBBY, IntObj)   
    External (\_SB.PCI0.BAT0, DeviceObj)
    External (\_SB.PCI0.BAT0._BIF, MethodObj)
    External (\_SB.PCI0.BAT0.BIXT, PkgObj)
    External (\_SB.PCI0.BAT0.NBIX, PkgObj)
    External (\_SB.PCI0.BAT0.PBIF, PkgObj)
    External (\_SB.PCI0.SBUS, DeviceObj)
    External (\_SB.PCI0.RP05.PEGP._OFF, MethodObj)
    
    // Renamed objects
    External (\XPRW, MethodObj)
    External (\ZPTS, MethodObj)
    External (\ZWAK, MethodObj)
    
    /* WBST: WiFi/Bluetooth on/off status.
     * 0: Both are off.
     * 1: WiFi is on, Bluetooth is off.
     * 2: WiFi is off, Bluetooth is on.
     * 3: Both are on.
     */
    Name (WBST, 3)
    
    Method (WBRS, 0, NotSerialized) // Resume WiFi/Bluetooth state after wake
    {
        If (WBST & One) // Check WiFi status bit
        {
            \OWLD (One)
        }
        Else
        {
            \OWLD (Zero)
        }
        Sleep (0x0DAC)
        If ((WBST >> One) & One) // Check Bluetooth status bit
        {
            \OBTD (One)
        }
        Else
        {
            \OBTD (Zero)
        }
    }

    Method (XOSI, 1, NotSerialized) // Simulate "Windows 2012"
    {
        Local0 = Package()
        {
            "Windows",              // generic Windows query
            "Windows 2001",         // Windows XP
            "Windows 2001 SP2",     // Windows XP SP2
            //"Windows 2001.1",     // Windows Server 2003
            //"Windows 2001.1 SP1", // Windows Server 2003 SP1
            "Windows 2006",         // Windows Vista
            "Windows 2006 SP1",     // Windows Vista SP1
            "Windows 2006.1",       // Windows Server 2008
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            "Windows 2012",         // Windows 8/Windows Server 2012
            //"Windows 2013",       // Windows 8.1/Windows Server 2012 R2
            //"Windows 2015",       // Windows 10/Windows Server TP
        }
        Return ((Ones != Match (Local0, MEQ, Arg0, MTR, Zero, Zero)))
    }

    Method (GPRW, 2, NotSerialized) // Instant wake fix
    {
        If (0x6D == Arg0) { Return (Package (0x02) { 0x6D, 0x00 }) }
        If (0x0D == Arg0) { Return (Package (0x02) { 0x0D, 0x00 }) }
        Return (XPRW (Arg0, Arg1))
    }

    Method (_PTS, 1, NotSerialized) // Include _PTS fix
    {
        If (Arg0 != 0x05)
        {
            ZPTS (Arg0)
        }
    }

    Method (_WAK, 1, NotSerialized) // Include _WAK fix
    {
        If ((Arg0 < One) || (Arg0 > 0x05))
        {
            Arg0 = 0x03
        }
        Local0 = ZWAK (Arg0)
        WBRS ()
        Return (Local0)
    }
    
    // Brightness fix
    Scope (_SB)
    {
        Device (PNLF)
        {
            Name (_ADR, Zero)
            Name (_HID, EisaId ("APP0002"))
            Name (_CID, "backlight")
            Name (_UID, 0x0A)
            Name (_STA, 0x0B)
            Method (_INI, 0, NotSerialized)
            {
                // Disable discrete graphics if present
                If (CondRefOf (\_SB.PCI0.RP05.PEGP._OFF))
                {
                    \_SB.PCI0.RP05.PEGP._OFF ()
                }
            }
        }
    }
    
    // SMBUS fix
    Scope (_SB.PCI0.SBUS)
    {
        Device (BUS0)
        {
            Name (_CID, "smbus")
            Name (_ADR, Zero)
            Device (DVL0)
            {
                Name (_ADR, 0x57)
                Name (_CID, "diagsvault")
                Method (_DSM, 4, NotSerialized)
                {
                    If (!Arg2) { Return (Buffer () { 0x03 }) }
                    Return (Package () { "address", 0x57 })
                }
            }
        }
    }
    
    // Fn hotkey patches
    Scope (_SB.PCI0.LPCB.EC0)
    {
        Method (_Q0B, 0, NotSerialized) // F2
        {
            WBST = (WBST + 1) % 4
            If (WBST & One)
            {
                \OWLD (One)
                \_SB.ATKD.IANE (0x5E)
            }
            Else
            {
                \OWLD (Zero)
                \_SB.ATKD.IANE (0x5F)
            }
            Sleep (0x0DAC)
            If ((WBST >> One) & One)
            {
                \OBTD (One)
                \_SB.ATKD.IANE (0x7D)
            }
            Else
            {
                \OBTD (Zero)
                \_SB.ATKD.IANE (0x7E)
            }
        }

        Method (_Q0C, 0, NotSerialized)  // F3
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x50)
            }
        }

        Method (_Q0D, 0, NotSerialized)  // F4
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x51)
            }
        }

        Method (_Q0E, 0, NotSerialized)  // F5
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x20)
            }
        }

        Method (_Q0F, 0, NotSerialized)  // F6
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x10)
            }
        }

        Method (_Q13, 0, NotSerialized)  // F10
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x32)
            }
        }

        Method (_Q14, 0, NotSerialized)  // F11
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x31)
            }
        }

        Method (_Q15, 0, NotSerialized)  // F12
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x30)
            }
        }
    }
    
    // 16-level keyboard backlit
    Scope (_SB.ATKD)
    {
        Name (KBPW, Buffer (0x10)
        {
            0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
            0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF 
        })
        Name (BOFF, Zero)
        Method (GKBL, 1, NotSerialized)
        {
            If (Arg0 == 0xFF)
            {
                Return (BOFF)
            }

            Return (KBLV)
        }

        Method (SKBL, 1, NotSerialized)
        {
            If ((Arg0 == 0xED) || (Arg0 == 0xFD))
            {
                If (((Arg0 == 0xED) && (BOFF == 0xEA)) || ((Arg0 == 0xFD) && (BOFF == 0xFA)))
                {
                    Local0 = Zero
                    BOFF = Arg0
                }
                Else
                {
                    Return (BOFF)
                }
            }
            ElseIf ((Arg0 == 0xEA) || (Arg0 == 0xFA))
            {
                Local0 = KBLV
                BOFF = Arg0
            }
            Else
            {
                Local0 = Arg0
                KBLV = Arg0
            }

            Local1 = DerefOf (KBPW [Local0])
            ^^PCI0.LPCB.EC0.WRAM (0xF8B1, Local1)
            Return (Local0)
        }
    }

    // Battery status fix
    Scope (_SB.PCI0.LPCB.EC0)
    {
        Field (ECOR, ByteAcc, Lock, Preserve)
        {
            Offset (0x93), 
            TH00,   8, 
            TH01,   8, 
            TH10,   8, 
            TH11,   8, 
            Offset (0xC4), 
            XC30,   8, 
            XC31,   8, 
            Offset (0xE4), 
            YC30,   8, 
            YC31,   8, 
            Offset (0xF4), 
            B0S0,   8, 
            B0S1,   8, 
            Offset (0xFC), 
            B1S0,   8, 
            B1S1,   8
        }

        Field (SMBX, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            BA00,   8, 
            BA01,   8, 
            BA02,   8, 
            BA03,   8, 
            BA04,   8, 
            BA05,   8, 
            BA06,   8, 
            BA07,   8, 
            BA08,   8, 
            BA09,   8, 
            BA0A,   8, 
            BA0B,   8, 
            BA0C,   8, 
            BA0D,   8, 
            BA0E,   8, 
            BA0F,   8, 
            BA10,   8, 
            BA11,   8, 
            BA12,   8, 
            BA13,   8, 
            BA14,   8, 
            BA15,   8, 
            BA16,   8, 
            BA17,   8, 
            BA18,   8, 
            BA19,   8, 
            BA1A,   8, 
            BA1B,   8, 
            BA1C,   8, 
            BA1D,   8, 
            BA1E,   8, 
            BA1F,   8
        }

        Field (SMB2, ByteAcc, NoLock, Preserve)
        {
            Offset (0x04), 
            BB00,   8, 
            BB01,   8, 
            BB02,   8, 
            BB03,   8, 
            BB04,   8, 
            BB05,   8, 
            BB06,   8, 
            BB07,   8, 
            BB08,   8, 
            BB09,   8, 
            BB0A,   8, 
            BB0B,   8, 
            BB0C,   8, 
            BB0D,   8, 
            BB0E,   8, 
            BB0F,   8, 
            BB10,   8, 
            BB11,   8, 
            BB12,   8, 
            BB13,   8, 
            BB14,   8, 
            BB15,   8, 
            BB16,   8, 
            BB17,   8, 
            BB18,   8, 
            BB19,   8, 
            BB1A,   8, 
            BB1B,   8, 
            BB1C,   8, 
            BB1D,   8, 
            BB1E,   8, 
            BB1F,   8
        }

        Method (\B1B2, 2, NotSerialized)
        {
            Return ((Arg0 | (Arg1 << 0x08)))
        }

        Method (RDBA, 0, Serialized)
        {
            Name (TEMP, Buffer (0x20) {})
            TEMP [Zero] = BA00
            TEMP [One] = BA01
            TEMP [0x02] = BA02
            TEMP [0x03] = BA03
            TEMP [0x04] = BA04
            TEMP [0x05] = BA05
            TEMP [0x06] = BA06
            TEMP [0x07] = BA07
            TEMP [0x08] = BA08
            TEMP [0x09] = BA09
            TEMP [0x0A] = BA0A
            TEMP [0x0B] = BA0B
            TEMP [0x0C] = BA0C
            TEMP [0x0D] = BA0D
            TEMP [0x0E] = BA0E
            TEMP [0x0F] = BA0F
            TEMP [0x10] = BA10
            TEMP [0x11] = BA11
            TEMP [0x12] = BA12
            TEMP [0x13] = BA13
            TEMP [0x14] = BA14
            TEMP [0x15] = BA15
            TEMP [0x16] = BA16
            TEMP [0x17] = BA17
            TEMP [0x18] = BA18
            TEMP [0x19] = BA19
            TEMP [0x1A] = BA1A
            TEMP [0x1B] = BA1B
            TEMP [0x1C] = BA1C
            TEMP [0x1D] = BA1D
            TEMP [0x1E] = BA1E
            TEMP [0x1F] = BA1F
            Return (TEMP)
        }

        Method (WRBA, 1, Serialized)
        {
            Name (TEMP, Buffer (0x20) {})
            TEMP = Arg0
            BA00 = DerefOf (TEMP [Zero])
            BA01 = DerefOf (TEMP [One])
            BA02 = DerefOf (TEMP [0x02])
            BA03 = DerefOf (TEMP [0x03])
            BA04 = DerefOf (TEMP [0x04])
            BA05 = DerefOf (TEMP [0x05])
            BA06 = DerefOf (TEMP [0x06])
            BA07 = DerefOf (TEMP [0x07])
            BA08 = DerefOf (TEMP [0x08])
            BA09 = DerefOf (TEMP [0x09])
            BA0A = DerefOf (TEMP [0x0A])
            BA0B = DerefOf (TEMP [0x0B])
            BA0C = DerefOf (TEMP [0x0C])
            BA0D = DerefOf (TEMP [0x0D])
            BA0E = DerefOf (TEMP [0x0E])
            BA0F = DerefOf (TEMP [0x0F])
            BA10 = DerefOf (TEMP [0x10])
            BA11 = DerefOf (TEMP [0x11])
            BA12 = DerefOf (TEMP [0x12])
            BA13 = DerefOf (TEMP [0x13])
            BA14 = DerefOf (TEMP [0x14])
            BA15 = DerefOf (TEMP [0x15])
            BA16 = DerefOf (TEMP [0x16])
            BA17 = DerefOf (TEMP [0x17])
            BA18 = DerefOf (TEMP [0x18])
            BA19 = DerefOf (TEMP [0x19])
            BA1A = DerefOf (TEMP [0x1A])
            BA1B = DerefOf (TEMP [0x1B])
            BA1C = DerefOf (TEMP [0x1C])
            BA1D = DerefOf (TEMP [0x1D])
            BA1E = DerefOf (TEMP [0x1E])
            BA1F = DerefOf (TEMP [0x1F])
        }

        Method (RDBB, 0, Serialized)
        {
            Name (TEMP, Buffer (0x20) {})
            TEMP [Zero] = BB00
            TEMP [One] = BB01
            TEMP [0x02] = BB02
            TEMP [0x03] = BB03
            TEMP [0x04] = BB04
            TEMP [0x05] = BB05
            TEMP [0x06] = BB06
            TEMP [0x07] = BB07
            TEMP [0x08] = BB08
            TEMP [0x09] = BB09
            TEMP [0x0A] = BB0A
            TEMP [0x0B] = BB0B
            TEMP [0x0C] = BB0C
            TEMP [0x0D] = BB0D
            TEMP [0x0E] = BB0E
            TEMP [0x0F] = BB0F
            TEMP [0x10] = BB10
            TEMP [0x11] = BB11
            TEMP [0x12] = BB12
            TEMP [0x13] = BB13
            TEMP [0x14] = BB14
            TEMP [0x15] = BB15
            TEMP [0x16] = BB16
            TEMP [0x17] = BB17
            TEMP [0x18] = BB18
            TEMP [0x19] = BB19
            TEMP [0x1A] = BB1A
            TEMP [0x1B] = BB1B
            TEMP [0x1C] = BB1C
            TEMP [0x1D] = BB1D
            TEMP [0x1E] = BB1E
            TEMP [0x1F] = BB1F
            Return (TEMP)
        }

        Method (WRBB, 1, Serialized)
        {
            Name (TEMP, Buffer (0x20) {})
            TEMP = Arg0
            BB00 = DerefOf (TEMP [Zero])
            BB01 = DerefOf (TEMP [One])
            BB02 = DerefOf (TEMP [0x02])
            BB03 = DerefOf (TEMP [0x03])
            BB04 = DerefOf (TEMP [0x04])
            BB05 = DerefOf (TEMP [0x05])
            BB06 = DerefOf (TEMP [0x06])
            BB07 = DerefOf (TEMP [0x07])
            BB08 = DerefOf (TEMP [0x08])
            BB09 = DerefOf (TEMP [0x09])
            BB0A = DerefOf (TEMP [0x0A])
            BB0B = DerefOf (TEMP [0x0B])
            BB0C = DerefOf (TEMP [0x0C])
            BB0D = DerefOf (TEMP [0x0D])
            BB0E = DerefOf (TEMP [0x0E])
            BB0F = DerefOf (TEMP [0x0F])
            BB10 = DerefOf (TEMP [0x10])
            BB11 = DerefOf (TEMP [0x11])
            BB12 = DerefOf (TEMP [0x12])
            BB13 = DerefOf (TEMP [0x13])
            BB14 = DerefOf (TEMP [0x14])
            BB15 = DerefOf (TEMP [0x15])
            BB16 = DerefOf (TEMP [0x16])
            BB17 = DerefOf (TEMP [0x17])
            BB18 = DerefOf (TEMP [0x18])
            BB19 = DerefOf (TEMP [0x19])
            BB1A = DerefOf (TEMP [0x1A])
            BB1B = DerefOf (TEMP [0x1B])
            BB1C = DerefOf (TEMP [0x1C])
            BB1D = DerefOf (TEMP [0x1D])
            BB1E = DerefOf (TEMP [0x1E])
            BB1F = DerefOf (TEMP [0x1F])
        }

        Method (TACH, 1, Serialized)
        {
            Name (_T_0, Zero)
            If (ECAV ())
            {
                While (One)
                {
                    _T_0 = Arg0
                    If (_T_0 == Zero)
                    {
                        Local0 = B1B2 (TH00, TH01)
                        Break
                    }
                    ElseIf (_T_0 == One)
                    {
                        Local0 = B1B2 (TH10, TH11)
                        Break
                    }
                    Else
                    {
                        Return (Ones)
                    }

                    Break
                }

                Local0 *= 0x02
                If (Local0 != Zero)
                {
                    Local0 = (0x0041CDB4 / Local0)
                    Return (Local0)
                }
                Else
                {
                    Return (Ones)
                }
            }
            Else
            {
                Return (Ones)
            }
        }

        Method (BIFA, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Local0 = B1B2 (B1S0, B1S1)
                }
                Else
                {
                    Local0 = B1B2 (B0S0, B0S1)
                }
            }
            Else
            {
                Local0 = Ones
            }

            Return (Local0)
        }

        Method (SMBR, 3, Serialized)
        {
            Local0 = Package (0x03)
                {
                    0x07, 
                    Zero, 
                    Zero
                }
            If (!ECAV ())
            {
                Return (Local0)
            }

            If (Arg0 != RDBL)
            {
                If (Arg0 != RDWD)
                {
                    If (Arg0 != RDBT)
                    {
                        If (Arg0 != RCBT)
                        {
                            If (Arg0 != RDQK)
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            Acquire (MUEC, 0xFFFF)
            Local1 = PRTC
            Local2 = Zero
            While (Local1 != Zero)
            {
                Stall (0x0A)
                Local2++
                If (Local2 > 0x03E8)
                {
                    Local0 [Zero] = SBBY
                    Local1 = Zero
                }
                Else
                {
                    Local1 = PRTC
                }
            }

            If (Local2 <= 0x03E8)
            {
                Local3 = (Arg1 << One)
                Local3 |= One
                ADDR = Local3
                If (Arg0 != RDQK)
                {
                    If (Arg0 != RCBT)
                    {
                        CMDB = Arg2
                    }
                }

                WRBA (Zero)
                PRTC = Arg0
                Local0 [Zero] = SWTC (Arg0)
                If (DerefOf (Local0 [Zero]) == Zero)
                {
                    If (Arg0 == RDBL)
                    {
                        Local0 [One] = BCNT
                        Local0 [0x02] = RDBA ()
                    }

                    If (Arg0 == RDWD)
                    {
                        Local0 [One] = 0x02
                        Local0 [0x02] = B1B2 (DAT0, DAT1)
                    }

                    If (Arg0 == RDBT)
                    {
                        Local0 [One] = One
                        Local0 [0x02] = DAT0
                    }

                    If (Arg0 == RCBT)
                    {
                        Local0 [One] = One
                        Local0 [0x02] = DAT0
                    }
                }
            }

            Release (MUEC)
            Return (Local0)
        }

        Method (SMBW, 5, Serialized)
        {
            Local0 = Package (0x01)
                {
                    0x07
                }
            If (!ECAV ())
            {
                Return (Local0)
            }

            If (Arg0 != WRBL)
            {
                If (Arg0 != WRWD)
                {
                    If (Arg0 != WRBT)
                    {
                        If (Arg0 != SDBT)
                        {
                            If (Arg0 != WRQK)
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            Acquire (MUEC, 0xFFFF)
            Local1 = PRTC
            Local2 = Zero
            While (Local1 != Zero)
            {
                Stall (0x0A)
                Local2++
                If (Local2 > 0x03E8)
                {
                    Local0 [Zero] = SBBY
                    Local1 = Zero
                }
                Else
                {
                    Local1 = PRTC
                }
            }

            If (Local2 <= 0x03E8)
            {
                WRBA (Zero)
                Local3 = (Arg1 << One)
                ADDR = Local3
                If (Arg0 != WRQK)
                {
                    If (Arg0 != SDBT)
                    {
                        CMDB = Arg2
                    }
                }

                If (Arg0 == WRBL)
                {
                    BCNT = Arg3
                    WRBA (Arg4)
                }

                If (Arg0 == WRWD)
                {
                    DAT0 = Arg4
                    DAT1 = (Arg4 >> 0x08)
                }

                If (Arg0 == WRBT)
                {
                    DAT0 = Arg4
                }

                If (Arg0 == SDBT)
                {
                    DAT0 = Arg4
                }

                PRTC = Arg0
                Local0 [Zero] = SWTC (Arg0)
            }

            Release (MUEC)
            Return (Local0)
        }

        Method (ECSB, 7, NotSerialized)
        {
            Local1 = Package (0x05)
                {
                    0x11, 
                    Zero, 
                    Zero, 
                    Zero, 
                    Buffer (0x20) {}
                }
            If (Arg0 > One)
            {
                Return (Local1)
            }

            If (ECAV ())
            {
                Acquire (MUEC, 0xFFFF)
                If (Arg0 == Zero)
                {
                    Local0 = PRTC
                }
                Else
                {
                    Local0 = PRT2
                }

                Local2 = Zero
                While (Local0 != Zero)
                {
                    Stall (0x0A)
                    Local2++
                    If (Local2 > 0x03E8)
                    {
                        Local1 [Zero] = SBBY
                        Local0 = Zero
                    }
                    ElseIf (Arg0 == Zero)
                    {
                        Local0 = PRTC
                    }
                    Else
                    {
                        Local0 = PRT2
                    }
                }

                If (Local2 <= 0x03E8)
                {
                    If (Arg0 == Zero)
                    {
                        ADDR = Arg2
                        CMDB = Arg3
                        If ((Arg1 == 0x0A) || (Arg1 == 0x0B))
                        {
                            BCNT = DerefOf (Arg6 [Zero])
                            WRBA (DerefOf (Arg6 [One]))
                        }
                        Else
                        {
                            DAT0 = Arg4
                            DAT1 = Arg5
                        }

                        PRTC = Arg1
                    }
                    Else
                    {
                        ADD2 = Arg2
                        CMD2 = Arg3
                        If ((Arg1 == 0x0A) || (Arg1 == 0x0B))
                        {
                            BCN2 = DerefOf (Arg6 [Zero])
                            WRBB (DerefOf (Arg6 [One]))
                        }
                        Else
                        {
                            DA20 = Arg4
                            DA21 = Arg5
                        }

                        PRT2 = Arg1
                    }

                    Local0 = 0x7F
                    If (Arg0 == Zero)
                    {
                        While (PRTC)
                        {
                            Sleep (One)
                            Local0--
                        }
                    }
                    Else
                    {
                        While (PRT2)
                        {
                            Sleep (One)
                            Local0--
                        }
                    }

                    If (Local0)
                    {
                        If (Arg0 == Zero)
                        {
                            Local0 = SSTS
                            Local1 [One] = DAT0
                            Local1 [0x02] = DAT1
                            Local1 [0x03] = BCNT
                            Local1 [0x04] = RDBA ()
                        }
                        Else
                        {
                            Local0 = SST2
                            Local1 [One] = DA20
                            Local1 [0x02] = DA21
                            Local1 [0x03] = BCN2
                            Local1 [0x04] = RDBB ()
                        }

                        Local0 &= 0x1F
                        If (Local0)
                        {
                            Local0 += 0x10
                        }

                        Local1 [Zero] = Local0
                    }
                    Else
                    {
                        Local1 [Zero] = 0x10
                    }
                }

                Release (MUEC)
            }

            Return (Local1)
        }
    }

    Scope (_SB.PCI0.BAT0)
    {
        Method (_BIX, 0, NotSerialized)
        {
            If (!^^LPCB.EC0.BATP (Zero))
            {
                Return (NBIX)
            }

            If (^^LPCB.EC0.GBTT (Zero) == 0xFF)
            {
                Return (NBIX)
            }

            _BIF ()
            BIXT [One] = DerefOf (PBIF [Zero])
            BIXT [0x02] = DerefOf (PBIF [One])
            BIXT [0x03] = DerefOf (PBIF [0x02])
            BIXT [0x04] = DerefOf (PBIF [0x03])
            BIXT [0x05] = DerefOf (PBIF [0x04])
            BIXT [0x06] = DerefOf (PBIF [0x05])
            BIXT [0x07] = DerefOf (PBIF [0x06])
            BIXT [0x0E] = DerefOf (PBIF [0x07])
            BIXT [0x0F] = DerefOf (PBIF [0x08])
            BIXT [0x10] = DerefOf (PBIF [0x09])
            BIXT [0x11] = DerefOf (PBIF [0x0A])
            BIXT [0x12] = DerefOf (PBIF [0x0B])
            BIXT [0x13] = DerefOf (PBIF [0x0C])
            If (DerefOf (BIXT [One]) == One)
            {
                BIXT [One] = Zero
                Local0 = DerefOf (BIXT [0x05])
                BIXT [0x02] = (DerefOf (BIXT [0x02]) * Local0)
                BIXT [0x03] = (DerefOf (BIXT [0x03]) * Local0)
                BIXT [0x06] = (DerefOf (BIXT [0x06]) * Local0)
                BIXT [0x07] = (DerefOf (BIXT [0x07]) * Local0)
                BIXT [0x0E] = (DerefOf (BIXT [0x0E]) * Local0)
                BIXT [0x0F] = (DerefOf (BIXT [0x0F]) * Local0)
                Divide (DerefOf (BIXT [0x02]), 0x03E8, Local0, BIXT [0x02])
                Divide (DerefOf (BIXT [0x03]), 0x03E8, Local0, BIXT [0x03])
                Divide (DerefOf (BIXT [0x06]), 0x03E8, Local0, BIXT [0x06])
                Divide (DerefOf (BIXT [0x07]), 0x03E8, Local0, BIXT [0x07])
                Divide (DerefOf (BIXT [0x0E]), 0x03E8, Local0, BIXT [0x0E])
                Divide (DerefOf (BIXT [0x0F]), 0x03E8, Local0, BIXT [0x0F])
            }

            BIXT [0x08] = B1B2 (^^LPCB.EC0.XC30, ^^LPCB.EC0.XC31)
            BIXT [0x09] = 0x0001869F
            Return (BIXT)
        }
    }
}

