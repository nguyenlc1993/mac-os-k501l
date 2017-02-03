## Changelog
#### v2.0
In this version, hotpatch now becomes the official method of ACPI patching. This method now uses 2 SSDTs, namely SSDT-HACK-K501L and SSDT-BATT-ASUS, together with a proper config.plist.

The package was also updated to provide support for macOS Sierra.

* ACPI (now renamed to SSDT):
	- Regenerated SSDT.aml with ssdtPRGen.sh v21.4.
	- Added 2 hotpatch SSDTs with source files (.dsl).
* Kexts:
	- Updated kexts to their latest versions.
	- Renamed kexts:
		+ AppleGraphicsPowerManagement\_K501LX to AppleGraphicsPowerManagement\_Broadwell.
		+ X86PlatformPlugin\_K501LX to X86PlatformPlugin\_Broadwell.
		+ AppleHDARealtekALC233 to AppleHDARealtekALC3236.
	- Added ApplePS2SmartTouchpad.kext v4.7b5 that works with Sierra.
	- Removed AtherosARPT.kext.
* Config:
	- Used DSDT fixes (AddPNLF and FixSBUS) as replacements of patches in hotpatch SSDT.
	- Replaced arbitrary injection with traditional configurations in Devices and Graphics sections.
	- Removed most of SMBIOS values (only keep ProductName = MacBookPro12,1). These values can be generated with the latest version of Clover Configurator.
* Other:
	- Removed EFI folder. Now it is recommended to install Clover using setup.
	- Moved DSDT patches and SMBIOS generator scripts to a new folder named Legacy. This folder will be available in source repository only (not include in release).

#### v1.1
* ACPI:
	- Removed 'fix warning' patches in Generic Fixes, as they are unnecessary.
	- Updated patch's descriptions.
	- Recompiled DSDT.aml with RehabMan's latest iasl (version 20160422-64)
	- Regenerated SSDT.aml with ssdtPRGen.sh v18.8.
* EFI:
	- Updated Clover to revision 3577.
	- Used Other folder for essential kexts.
	- config.plist:
		+ Changed boot timeout to 3 seconds.
		+ Kext patches: Renamed ALC233 to ALC3236.
		+ Set InjectSystemID to Yes by default.
* Kexts:
	- Updated kexts to their latest versions.
	- Modified AppleHDARealtekALC233.kext to disable Line In port due to audio issues with Headphone port.
* Hotpatch (experimental):
	- Added SSDT-HACK and modified config.plist for testing 'hotpatch' method. Details can be found in SSDT-HACK.dsl.
		
#### v1.0
(compared with the old installation pack)

* The installation pack is now moved to GitHub for better development.
* ACPI:
	- Migrated rename patches and IOReg injection patches to config.plist.
	- Moved deprecated patches to a subfolder.
	- Modified patch's headers and combined some of the patches.
	- Renamed patch files to show apply order and effect of the patches.
	- Regenerated CpuPm SSDT with ssdtPRGen.sh v18.2.
* EFI:
	- Updated Clover to r3469.
	- Removed iclover theme.
	- Essential kexts and config.plist are removed.
		+ From now on, user will have to copy the essentials kexts and config.plist manually from Kexts and Config folder respectively.
* Config.plist:
	- Added DSDT rename patches and IOReg injection patches (by applying the new 'arbitrary device injection' features since Clover r3262).
	- Added patch to AppleIntelBDWFramebuffer.kext.
	- Updated SMBIOS properties.
* Kexts:
	- Updated kexts to their latest versions.
	- Fixed 10.11.4 dependency-missing error in AppleHDARealtekALC233.kext.
	- Fixed FakeSMC.kext to show correct SMC version.
	- Added AtherosARPT.kext, AppleGraphicsPowerManagement\_K501LX.kext and X86PlatformPlugin\_K501LX.kext.
* Tools:
	- Removed the tools from the installation pack, as they increased the size of the pack. An external download link for the essential tools is provided.
	- Removed Clover Configurator and Kext Utility.
	- Added EFI Mounter, Property List Editor and KCPM Utility Pro.
	- Added two scripts to generate serials for MacBookPro12,1 and MacBookAir7,2 model.
