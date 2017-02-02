## Changelog
#### v1.1
(Under construction)

#### v1.0.1
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
		
#### Initial version
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
