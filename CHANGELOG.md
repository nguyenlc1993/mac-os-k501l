##Changelog

####Initial version
_(compared with the old installation pack)_

* The installation pack is now moved to GitHub for better development.
* ACPI:
	- Migrated rename patches and IOReg injection patches to config.plist.
	- Moved deprecated patches to a subfolder.
	- Modified patch's headers and combined some of the patches.
	- Renamed patch files to show apply order and effect of the patches.
	- Regenerated CpuPm SSDT with ssdtPRGen.sh v18.2.
* EFI:
	- Updated Clover to r3469.
	- Removed _iclover_ theme.
	- Essential kexts and config.plist are removed.
		+ From now on, user will have to copy the essentials kexts and config.plist manually from _Kexts_ and _Config_ folder respectively.
* Config.plist:
	- Added DSDT rename patches and IOReg injection patches (by applying the new 'arbitrary device injection' features since Clover r3262).
	- Changed ig-platform-id to 0x16160002 instead of 0x16260006.
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