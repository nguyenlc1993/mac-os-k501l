/* 
 * ---- Tiny SSDT Collection ----
 *
 * 1. Summary
 *     Name: SSDT-HACK-K501L
 *     Author: nguyenlc1993
 *     Source:
 *       - RehabMan's laptop DSDT patches.
 *       - EMlyDinEsH's DSDT patches for ASUS laptops.
 *     Credit: RehabMan for his awesome collection of tiny SSDTs.
 * 2. Purposes
 *     This SSDT contains a set of patches for ASUS K501LX/K501LB laptop, namely:
 *       - _OSI fix.
 *       - _PRW instant wake fix.
 *       - _PTS fix.
 *       - _WAK fix.
 *       - Disable discrete graphics.
 *       - ASUS Fn hot keys patch.
 *       - WiFi/Bluetooth resume after wake patch.
 * 3. Requirements
 *     Other SSDTs: None.
 *     Clover DSDT Fixes:
 *       - AddDTGP_0001
 *       - AddPNLF_1000000
 *       - FIX_RTC_20000
 *       - FIX_TMR_40000
 *       - FixHPET_0010
 *       - FixIPIC_0040
 *       - FixSBUS_0080
 *       - NewWay_80000000
 *     Clover DSDT Patches:
 *       - _DSM to XDSM (5F44534D -> 5844534D)
 *       - EHC1 to EH01 (45484331 -> 45483031)
 *       - EHC2 to EH02 (45484332 -> 45483032)
 *       - GFX0 to IGPU (47465830 -> 49475055)
 *       - B0D3 to HDAU (42304433 -> 48444155)
 *       - HECI to IMEI (48454349 -> 494D4549)
 *       - _OSI to XOSI (5F4F5349 -> 584F5349)
 *       - _PTS(1,N) to ZPTS(1,N) (5F505453 01 -> 5A505453 01)
 *       - _WAK(1,N) to ZWAK(1,N) (5F57414B 01 -> 5A57414B 01)
 *       - GPRW(2,N) to XPRW(2,N) (47505257 02 -> 58505257 02)
 *       - _Q0B(0,N) to ZQ0B(0,N) (5F513042 00 -> 5A513042 00)
 *       - _Q0C(0,N) to ZQ0C(0,N) (5F513043 00 -> 5A513043 00)
 *       - _Q0D(0,N) to ZQ0D(0,N) (5F513044 00 -> 5A513044 00)
 *       - _Q0E(0,N) to ZQ0E(0,N) (5F513045 00 -> 5A513045 00)
 *       - _Q0F(0,N) to ZQ0F(0,N) (5F513046 00 -> 5A513046 00)
 *       - _Q13(0,N) to ZQ13(0,N) (5F513133 00 -> 5A513133 00)
 *       - _Q14(0,N) to ZQ14(0,N) (5F513134 00 -> 5A513134 00)
 *       - _Q15(0,N) to ZQ15(0,N) (5F513135 00 -> 5A513135 00)
 *       - D029@1F,3 to MCHC@0 (5B820F44 30323908 5F414452 0C03001F 00
 *         -> 5B820F4D 43484308 5F414452 0C000000 00)
 * 4. Notes
 *     - The basic DSDT patches (PNLF, SMBUS, etc.) are replaced
 *       by Clover's DSDT fix mask.
 *     - The battery patch is provided in a separate SSDT.
 *     - Patch to fix airplane LED is in research.
 */
DefinitionBlock ("", "SSDT", 2, "HACK", "K501L", 0)
{
    // Original objects
    External (\OWLD, MethodObj)
    External (\OBTD, MethodObj)
    External (\_SB.ATKP, IntObj)
    External (\_SB.KBLV, FieldUnitObj)
    External (\_SB.ATKD, DeviceObj)
    External (\_SB.ATKD.IANE, MethodObj)
    External (\_SB.PCI0, DeviceObj)
    External (\_SB.PCI0.LPCB, DeviceObj)
    External (\_SB.PCI0.LPCB.EC0, DeviceObj)
    External (\_SB.PCI0.LPCB.EC0.WRAM, MethodObj)
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
    
    // Resume WiFi/Bluetooth state after wake
    Method (WBRS, 0, NotSerialized)
    {
        // Check WiFi status bit
        If (WBST & One)
        {
            \OWLD (One)
        }
        Else
        {
            \OWLD (Zero)
        }
        Sleep (0x0DAC)
        // Check Bluetooth status bit
        If ((WBST >> One) & One)
        {
            \OBTD (One)
        }
        Else
        {
            \OBTD (Zero)
        }
    }

    // _OSI fix, simulate Windows 2012
    Method (XOSI, 1, NotSerialized) 
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
    
    // _PRW instant wake fix
    Method (GPRW, 2, NotSerialized)
    {
        If (0x6D == Arg0) { Return (Package (0x02) { 0x6D, 0x00 }) }
        If (0x0D == Arg0) { Return (Package (0x02) { 0x0D, 0x00 }) }
        Return (XPRW (Arg0, Arg1))
    }

    // _PTS fix
    Method (_PTS, 1, NotSerialized)
    {
        If (Arg0 != 0x05)
        {
            ZPTS (Arg0)
        }
    }

    // _WAK fix
    Method (_WAK, 1, NotSerialized)
    {
        If ((Arg0 < One) || (Arg0 > 0x05))
        {
            Arg0 = 0x03
        }
        Local0 = ZWAK (Arg0)
        WBRS ()
        Return (Local0)
    }

    // Disable discrete graphics if present
    Device (HK01)
    {
        Name (_HID, "HACK0001")
        Method (_INI, 0, NotSerialized)
        {
            If (CondRefOf (\_SB.PCI0.RP05.PEGP._OFF))
            {
                \_SB.PCI0.RP05.PEGP._OFF ()
            }
        }
    }
    
    // ASUS Fn hotkey patches
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
    
    // 16-level keyboard backlit patch
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
}