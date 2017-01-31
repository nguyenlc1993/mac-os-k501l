/* 
 * ---- Tiny SSDT Collection ----
 *
 * 1. Summary
 *     Name: SSDT-BATT-ASUS
 *     Author: nguyenlc1993
 *     Source:
 *       - https://github.com/RehabMan/Laptop-DSDT-Patch/blob/master/battery/battery_ASUS-G75vw.txt
 *     Credit: RehabMan for his awesome collection of tiny SSDTs.
 * 2. Purposes
 *     This SSDT will enable ACPIBatteryManager.kext to work with ASUS laptop's battery
 *     by correcting field units related to battery to 8-bit length (ByteAcc).
 * 3. Requirements
 *     Other SSDTs: None.
 *     Clover DSDT Patches:
 *       - TACH(1,S) to TACZ(1,S) (54414348 09 -> 5441435A 09)
 *       - BIFA(0,N) to BIFZ(0,N) (42494641 00 -> 4249465A 00)
 *       - SMBR(3,S) to SMRZ(3,S) (534D4252 0B -> 534D525A 0B)
 *       - SMBW(5,S) to SMWZ(5,S) (534D4257 0D -> 534D575A 0D)
 *       - ECSB(7,N) to ECSZ(7,N) (45435342 07 -> 4543535A 07)
 *       - _BIX(0,N) to ZBIX(0,N) (5F424958 00 -> 5A424958 00)
 *       - Fix logic error in FBST (A00A4348 47530070 0A0260A1 04700160 -> A00A4348 47530070 0A0260A1 04700060)
 * 4. Notes
 *     
 */
DefinitionBlock ("", "SSDT", 2, "HACK", "BattAsus", 0)
{
    // External declaration
    External (\BSLF, IntObj)
    External (\_SB.PCI0, DeviceObj)
    External (\_SB.PCI0.LPCB, DeviceObj)
    External (\_SB.PCI0.LPCB.EC0, DeviceObj)
    External (\_SB.PCI0.LPCB.EC0.ECAV, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.GBTT, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.BATP, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.SWTC, MethodObj)
    External (\_SB.PCI0.LPCB.EC0.MUEC, MutexObj)
    External (\_SB.PCI0.LPCB.EC0.ECOR, OpRegionObj)
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

    // Operation region and utility methods
    Scope (_SB.PCI0.LPCB.EC0)
    {
        Field (ECOR, ByteAcc, Lock, Preserve)
        {
            Offset (0x93), 
            TH00, 8, TH01, 8, // TAH0
            TH10, 8, TH11, 8, // TAH1
            Offset (0xB0),
            B0P0, 8, B0P1, 8, // B0PN
            Offset (0xBE),
            B0T0, 8, B0T1, 8, // B0TM
            B010, 8, B011, 8, // B0C1
            B020, 8, B021, 8, // B0C2
            B030, 8, B031, 8, // B0C3
            B040, 8, B041, 8, // B0C4
            Offset (0xD0),
            B1P0, 8, B1P1, 8, // B1PN
            Offset (0xDE),
            B1T0, 8, B1T1, 8, // B1TM
            B110, 8, B111, 8, // B1C1
            B120, 8, B121, 8, // B1C2
            B130, 8, B131, 8, // B1C3
            B140, 8, B141, 8, // B1C4
            Offset (0xF4), 
            B0N0, 8, B0N1, 8, // B0SN
            Offset (0xFC), 
            B1N0, 8, B1N1, 8, // B1SN
        }
        
        // FieldUnit: BDAT | Offset: 0x1C | Length: 256
        // FieldUnit: BDA2 | Offset: 0x44 | Length: 256
        
        Method (\B1B2, 2, NotSerialized)
        {
            Return ((Arg0 | (Arg1 << 0x08)))
        }
        
        Method (RE1B, 1, NotSerialized)
        {
            OperationRegion (ERAM, EmbeddedControl, Arg0, One)
            Field (ERAM, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }
            Return (BYTE)
        }

        Method (RECB, 2, Serialized)
        {
            Arg1 >>= 0x03
            Name (TEMP, Buffer (Arg1) {})
            Arg1 += Arg0
            Local0 = Zero
            While (Arg0 < Arg1)
            {
                TEMP [Local0] = RE1B (Arg0)
                Arg0++
                Local0++
            }
            Return (TEMP)
        }

        Method (WE1B, 2, NotSerialized)
        {
            OperationRegion (ERAM, EmbeddedControl, Arg0, One)
            Field (ERAM, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }
            BYTE = Arg1
        }

        Method (WECB, 3, Serialized)
        {
            Arg1 >>= 0x03
            Name (TEMP, Buffer (Arg1) {})
            TEMP = Arg2
            Arg1 += Arg0
            Local0 = Zero
            While (Arg0 < Arg1)
            {
                WE1B (Arg0, DerefOf (TEMP [Local0]))
                Arg0++
                Local0++
            }
        }
    }
    
    // Battery fix
    Scope (_SB.PCI0.LPCB.EC0)
    {
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
                    Local0 = B1B2 (B1N0, B1N1)
                }
                Else
                {
                    Local0 = B1B2 (B0N0, B0N1)
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

                WECB (0x1C, 0x100, Zero)
                PRTC = Arg0
                Local0 [Zero] = SWTC (Arg0)
                If (DerefOf (Local0 [Zero]) == Zero)
                {
                    If (Arg0 == RDBL)
                    {
                        Local0 [One] = BCNT
                        Local0 [0x02] = RECB (0x1C, 0x100)
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
                WECB (0x1C, 0x100, Zero)
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
                    WECB (0x1C, 0x100, Arg4)
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
                            WECB (0x1C, 0x100, DerefOf (Arg6 [One]))
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
                            WECB (0x44, 0x100, DerefOf (Arg6 [One]))
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
                            Local1 [0x04] = RECB (0x1C, 0x100)
                        }
                        Else
                        {
                            Local0 = SST2
                            Local1 [One] = DA20
                            Local1 [0x02] = DA21
                            Local1 [0x03] = BCN2
                            Local1 [0x04] = RECB (0x44, 0x100)
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

            BIXT [0x08] = B1B2 (^^LPCB.EC0.B030, ^^LPCB.EC0.B031)
            BIXT [0x09] = 0x0001869F
            Return (BIXT)
        }
    }
}

