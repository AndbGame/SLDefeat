Scriptname DefeatUtil2 Hidden

String Function GetDDVersion() Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	return libs.GetVersionString() as string
EndFunction

Bool Function CheckBound(actor[] Targets) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	int ArrayLength = Targets.Length
	while ArrayLength > 0
		ArrayLength -= 1
		if libs.Config.beltedAnims.FilterQuest.IsBlockedAnal(Targets[ArrayLength])
			return True
		endif
		if libs.Config.beltedAnims.FilterQuest.IsBlockedVaginal(Targets[ArrayLength])
			return True
		endif
		if libs.Config.beltedAnims.FilterQuest.IsBlockedBreast(Targets[ArrayLength])
			return True
		endif
		if libs.Config.beltedAnims.FilterQuest.IsBlockedOral(Targets[ArrayLength])
			return True
		endif
		if libs.Config.beltedAnims.FilterQuest.HasArmbinder(Targets[ArrayLength])
			return True
		endif
		if libs.Config.beltedAnims.FilterQuest.HasYoke(Targets[ArrayLength])
			return True
		endif
		if libs.NeedsBoundAnim(Targets[ArrayLength])
			return True
		endif
	endwhile
	return False
EndFunction

sslBaseAnimation[] Function SelectValidDDAnimations(Actor[] actors, int count, bool forceaggressive = false, string includetag = "", string suppresstag = "") Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	return libs.SelectValidDDAnimations(actors, count, forceaggressive, includetag, suppresstag)
EndFunction

Bool Function LockDevice(Actor Target, Armor InventoryArmor) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	return libs.LockDevice(Target, InventoryArmor)
EndFunction

Bool Function EquipDevice(Actor Target, Armor InventoryDevice, Armor RenderedDevice, Keyword DDKeyword) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	libs.EquipDevice(Target, InventoryDevice, RenderedDevice, DDKeyword)
EndFunction

Bool Function UnlockDevice(actor RefActor, armor RefdeviceInventory, armor RefdeviceRendered = none, keyword Refzad_DeviousDevice = none, bool RefdestroyDevice = false, bool Refgenericonly = false) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	if libs.UnlockDevice(akActor = RefActor, deviceInventory = RefdeviceInventory, deviceRendered = RefdeviceRendered, zad_DeviousDevice = Refzad_DeviousDevice, destroyDevice = RefdestroyDevice, genericonly = Refgenericonly)
		return True
	else
		return False
	endif
EndFunction

Bool Function RemoveDevice(actor RefakActor, armor RefdeviceInventory, armor RefdeviceRendered, keyword Refzad_DeviousDevice, bool RefdestroyDevice=false, bool RefskipEvents=false, bool RefskipMutex=false) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	libs.RemoveDevice(RefakActor, RefdeviceInventory, RefdeviceRendered, Refzad_DeviousDevice)
EndFunction

Key Function GetDDKey(Armor RefInventoryItem) Global 
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	return libs.GetDeviceKey(RefInventoryItem)
EndFunction

String Function GetDeviceName(Armor DeviceInventory) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	return libs.GetDeviceName(DeviceInventory)
EndFunction

Bool Function IsGenericDevice(Actor Target, Keyword DDKeyword) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	bool TempBool = libs.IsGenericDevice(Target, DDKeyword)
	return TempBool
EndFunction

Armor Function GetWornDevice(Actor Target, Keyword DDKeyword) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	return libs.GetWornDevice(Target, DDKeyword)
EndFunction

Armor Function GetWornDeviceFuzzyMatch(Actor Target, Keyword DDKeyword) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	return libs.GetWornDeviceFuzzyMatch(Target, DDKeyword)
EndFunction

Armor Function GetRenderedDevice(Armor InventoryDevice) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	return libs.GetRenderedDevice(InventoryDevice)
EndFunction

Keyword Function GetDDKeyword(string KeyWordName) Global
	zadLibs libs = (Quest.GetQuest("zadQuest") As zadLibs)
	if KeyWordName == "zad_DeviousPlug"
		return libs.zad_DeviousPlug
	elseif KeyWordName == "zad_DeviousBelt"
		return libs.zad_DeviousBelt
	endif
EndFunction

Function SD_CheckIfSlaver(Actor Target) Global
	_sdqs_fcts_factions SD_fcts_factions = (Quest.GetQuest("_SD_controller") As _sdqs_fcts_factions)
	SD_fcts_factions.checkIfSlaver(Target)
EndFunction

Function SD_CheckIfSlaverCreature(Actor Target) Global
	_sdqs_fcts_factions SD_fcts_factions = (Quest.GetQuest("_SD_controller") As _sdqs_fcts_factions)
	SD_fcts_factions.checkIfSlaverCreature(Target)
EndFunction

Int Function DCUR_GetDeviceTheme() Global
	dcur_library dcur_libs = (Quest.GetQuest("dcur_mainlib") As dcur_library)
	return dcur_libs.dcumenu.equiptheme
EndFunction

Function DCUR_EquipRandomItem(Actor Target, Int Theme) Global
	dcur_library dcur_libs = (Quest.GetQuest("dcur_mainlib") As dcur_library)
	dcur_libs.dcur_EquipRandomItem(Target, Theme)
EndFunction

Float Function DFW_GetVulnerability(Actor Target) Global
	dfwDeviousFramework dfw = (Quest.GetQuest("_dfwDeviousFramework") As dfwDeviousFramework)
	float TempFloat = dfw.GetVulnerability(Target) as float
	return TempFloat
EndFunction

Actor Function GetCurrentFollower() Global
	Alias[] ttt = (Game.GetFormFromFile(0x750BA, "Skyrim.esm") as Quest).GetAliases()
	Debug.trace("DefeatUtil2 - Number of alias: " + ttt.Length)
	return ((Game.GetFormFromFile(0x750BA, "Skyrim.esm") as Quest).GetAlias(0) as ReferenceAlias).GetActorReference()
EndFunction

Armor Function GetDDArmbinder(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
			return (Game.GetFormFromFile(0x540F2, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor
		elseif Colour == "White"
			return (Game.GetFormFromFile(0x540F2, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor
		elseif Colour == "Red"
			return (Game.GetFormFromFile(0x540F2, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
			return (Game.GetFormFromFile(0x540F3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor
		elseif Colour == "White"
			return (Game.GetFormFromFile(0x540F3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor
		elseif Colour == "Red"
			return (Game.GetFormFromFile(0x540F3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor
		endif
	elseif Type == "Rope"
		if Colour == "Black"
			return (Game.GetFormFromFile(0x540F4, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor
		elseif Colour == "White"
			return (Game.GetFormFromFile(0x540F4, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor
		elseif Colour == "Red"
			return (Game.GetFormFromFile(0x540F4, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor
		endif
	endif
EndFunction

Armor Function GetDDGag(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Ball"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 8)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 7)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 8)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54102, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54103, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor
			endif
		endif
	elseif Type == "Ring"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54106, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54106, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54107, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54107, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54106, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54106, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54107, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54107, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54106, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54106, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54107, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54107, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor
			endif
		endif
	elseif Type == "Rope"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ; no colour
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ; no colour
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ; no colour
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ; no colour
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ; no colour
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54108, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ; no colour
			endif
		endif
	elseif Type == "Pony"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 9)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x3B22B, "Devious Devices - Expansion.esm") as Armor) ;Black Leather Gag (Pony) (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x3B229, "Devious Devices - Expansion.esm") as Armor) ;Black Ebonite Gag (Pony) (Harness)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x3B227, "Devious Devices - Expansion.esm") as Armor) ;Black Leather Gag (Pony) (Blinders)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x3B225, "Devious Devices - Expansion.esm") as Armor) ;Black Ebonite Gag (Pony) (Blinders)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x3B223, "Devious Devices - Expansion.esm") as Armor) ;Black Leather Gag (Pony) (Ears)
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x3B221, "Devious Devices - Expansion.esm") as Armor) ;Black Ebonite Gag (Pony) (Ears)
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x3B21F, "Devious Devices - Expansion.esm") as Armor) ;Black Leather Gag (Pony) (Strap)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x3B21D, "Devious Devices - Expansion.esm") as Armor) ;Black Ebonite Gag (Pony) (Strap)
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x3B21B, "Devious Devices - Expansion.esm") as Armor) ;Black Leather Gag (Pony)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x3B219, "Devious Devices - Expansion.esm") as Armor) ;Black Ebonite Gag (Pony)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 9)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x3BD1D, "Devious Devices - Expansion.esm") as Armor) ;White Leather Gag (Pony) (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x3BD1B, "Devious Devices - Expansion.esm") as Armor) ;White Ebonite Gag (Pony) (Harness)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x3BD15, "Devious Devices - Expansion.esm") as Armor) ;White Leather Gag (Pony) (Blinders)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x3BD13, "Devious Devices - Expansion.esm") as Armor) ;White Ebonite Gag (Pony) (Blinders)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x3BD0D, "Devious Devices - Expansion.esm") as Armor) ;White Leather Gag (Pony) (Ears)
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x3BD0B, "Devious Devices - Expansion.esm") as Armor) ;White Ebonite Gag (Pony) (Ears)
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x3BD05, "Devious Devices - Expansion.esm") as Armor) ;White Leather Gag (Pony) (Strap)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x3BD03, "Devious Devices - Expansion.esm") as Armor) ;White Ebonite Gag (Pony) (Strap)
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x3BCFD, "Devious Devices - Expansion.esm") as Armor) ;White Leather Gag (Pony)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x3BCFB, "Devious Devices - Expansion.esm") as Armor) ;White Ebonite Gag (Pony)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 9)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x3BD19, "Devious Devices - Expansion.esm") as Armor) ;Red Leather Gag (Pony) (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x3BD17, "Devious Devices - Expansion.esm") as Armor) ;Red Ebonite Gag (Pony) (Harness)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x3BD11, "Devious Devices - Expansion.esm") as Armor) ;Red Leather Gag (Pony) (Blinders)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x3BD0F, "Devious Devices - Expansion.esm") as Armor) ;Red Ebonite Gag (Pony) (Blinders)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x3BD09, "Devious Devices - Expansion.esm") as Armor) ;Red Leather Gag (Pony) (Ears)
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x3BD07, "Devious Devices - Expansion.esm") as Armor) ;Red Ebonite Gag (Pony) (Ears)
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x3BD01, "Devious Devices - Expansion.esm") as Armor) ;Red Leather Gag (Pony) (Strap)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x3BCFF, "Devious Devices - Expansion.esm") as Armor) ;Red Ebonite Gag (Pony) (Strap)
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x3BCF9, "Devious Devices - Expansion.esm") as Armor) ;Red Leather Gag (Pony)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x3BCF7, "Devious Devices - Expansion.esm") as Armor) ;Red Ebonite Gag (Pony)
			endif
		endif
	elseif Type == "Panel"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x4F92C, "Devious Devices - Expansion.esm") as Armor) ;Extreme Panel Gag Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0xD4F3, "Devious Devices - Expansion.esm") as Armor) ;Black Ebonite Gag (Panel) (Harness)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0xF054, "Devious Devices - Expansion.esm") as Armor) ;White Ebonite Gag (Panel) (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0xF051, "Devious Devices - Expansion.esm") as Armor) ;White Leather Gag (Panel) (Harness)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x11130, "Devious Devices - Expansion.esm") as Armor) ;Red Ebonite Gag (Panel) (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x1112D, "Devious Devices - Expansion.esm") as Armor) ;Red Leather Gag (Panel) (Harness)
			endif
		endif
	elseif Type == "Inflatable"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x56785, "Devious Devices - Expansion.esm") as Armor) ;Inflatable Panel Gag
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x4F92B, "Devious Devices - Expansion.esm") as Armor) ;Extreme Inflatable Gag Harness
		endif
	elseif Type == "Various(Metal)"
		if Colour == "Iron"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 5)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x1AB0E, "Devious Devices - Expansion.esm") as Armor) ;Iron Scold's Bridle (Light)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x1B072, "Devious Devices - Expansion.esm") as Armor) ;Iron Scold's Bridle
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x1B074, "Devious Devices - Expansion.esm") as Armor) ;Iron Scold's Bridle (Heavy)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x1F6C7, "Devious Devices - Expansion.esm") as Armor) ;Iron Gag (Ring)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x1F6C9, "Devious Devices - Expansion.esm") as Armor) ;Iron Gag (Bit)
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x1F6CB, "Devious Devices - Expansion.esm") as Armor) ;Iron Gag (Wood Bit)
			endif
		elseif Colour == "Rusty Iron"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 5)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x1B076, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Scold's Bridle (Light)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x1B077, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Scold's Bridle
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x1B079, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Scold's Bridle (Heavy)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x1FC37, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Gag (Bit)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x1FC39, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Gag (Wood Bit)
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x1FC57, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Gag (Choke Pear)
			endif
		endif
	endif
EndFunction

Armor Function GetDDSuit(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Catsuit"
		if Colour == "Black"
			return (Game.GetFormFromFile(0x54674, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Catsuit
		elseif Colour == "White"
			return (Game.GetFormFromFile(0x54674, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;White Ebonite Catsuit
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54674, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Dark Red Ebonite Catsuit
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54674, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Red Ebonite Catsuit
			endif
		endif
	elseif Type == "Hobbled"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54677, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Hobble Dress (Extreme)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54677, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Black Leather Hobble Dress (Extreme) (Open)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54678, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Hobble Dress (Extreme)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54678, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Black Ebonite Hobble Dress (Extreme) (Open)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54677, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;White Leather Hobble Dress (Extreme)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54677, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;White Leather Hobble Dress (Extreme) (Open)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54678, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;White Ebonite Hobble Dress (Extreme)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54678, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;White Ebonite Hobble Dress (Extreme) (Open)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54677, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Leather Hobble Dress (Extreme)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54677, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Red Leather Hobble Dress (Extreme) (Open)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54678, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Ebonite Hobble Dress (Extreme)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54678, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Red Ebonite Hobble Dress (Extreme) (Open)
			endif
		endif
	elseif Type == "Straitjacket"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 18)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x5467D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Straitjacket
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x5467D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Black Leather Straitjacket (Open)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x5467D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Black Leather Straitjacket Dress (Topless)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x5467E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Straitjacket
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x5467E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Ebonite Straitjacket (Open)
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Straitjacket Dress, Elegant
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Black Leather Straitjacket Dress, Elegant (Open)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Black Leather Straitjacket Dress (Open)
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Black Leather Straitjacket Dress (Cleavage)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;Black Leather Straitjacket Dress, Elegant (Topless)
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Black Leather Straitjacket Dress
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;Black Leather Straitjacket Dress (Topless)
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Straitjacket Dress, Elegant
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Black Ebonite Straitjacket Dress, Elegant (Open)
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Black Ebonite Straitjacket Dress (Cleavage)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Black Ebonite Straitjacket Dress (Open)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;Black Ebonite Straitjacket Dress, Elegant (Topless)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Black Ebonite Straitjacket Dress
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;Black Ebonite Straitjacket Dress (Topless)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 18)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x5467D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;White Leather Straitjacket
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x5467D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;White Leather Straitjacket (Open)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x5467D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;White Leather Straitjacket Dress (Topless)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x5467E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;White Ebonite Straitjacket (Topless)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x5467E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;White Ebonite Straitjacket
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;White Leather Straitjacket Dress, Elegant
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;White Leather Straitjacket Dress, Elegant (Open)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;White Leather Straitjacket Dress (Cleavage)
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;White Leather Straitjacket Dress (Open)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;White Leather Straitjacket Dress, Elegant (Topless)
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(18) as Armor ;White Leather Straitjacket Dress
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(20) as Armor ;White Leather Straitjacket Dress (Topless)
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;White Ebonite Straitjacket Dress, Elegant
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;White Ebonite Straitjacket Dress, Elegant (Open)
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;White Ebonite Straitjacket Dress (Cleavage)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;White Ebonite Straitjacket Dress (Open)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;White Ebonite Straitjacket Dress, Elegant (Topless)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(18) as Armor ;White Ebonite Straitjacket Dress
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(20) as Armor ;White Ebonite Straitjacket Dress (Topless)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 18)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x5467D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Leather Straitjacket
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x5467D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Red Leather Straitjacket (Open)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x5467D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Red Leather Straitjacket Dress (Topless)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x5467E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Ebonite Straitjacket
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x5467E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Red Ebonite Straitjacket (Topless)
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Leather Straitjacket Dress, Elegant
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Red Leather Straitjacket Dress, Elegant (Open)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Red Leather Straitjacket Dress (Cleavage)
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Red Leather Straitjacket Dress (Open)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Red Leather Straitjacket Dress, Elegant (Topless)
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(17) as Armor ;Red Leather Straitjacket Dress
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x561A0, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(19) as Armor ;Red Leather Straitjacket Dress (Topless)
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Ebonite Straitjacket Dress, Elegant
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Red Ebonite Straitjacket Dress, Elegant (Open)
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Red Ebonite Straitjacket Dress (Cleavage)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Red Ebonite Straitjacket Dress (Open)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Red Ebonite Straitjacket Dress, Elegant (Topless)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(17) as Armor ;Red Ebonite Straitjacket Dress
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x561A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(19) as Armor ;Red Ebonite Straitjacket Dress (Topless)
			endif
		endif
	endif
EndFunction

Armor Function GetDDHood(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Hood"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 4)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Black Ebonite Hood
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Black Leather Hood
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Black Ebonite Mask (Open Eyes)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Black Ebonite Mask (Open Face)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Black Ebonite Mask (Open)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 4)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;White Leather Hood
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;White Ebonite Hood
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;White Ebonite Mask (Open Eyes)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;White Ebonite Mask (Open Face)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;White Ebonite Mask (Open)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 4)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Ebonite Hood
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Red Ebonite Mask (Open Eyes)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Red Ebonite Mask (Open)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Red Ebonite Mask (Open Face)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x56784, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(17) as Armor ;Red Leather Hood
			endif
		endif
	elseif Type == "BlindFold"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54698, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Blindfold
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54698, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Leather Blindfold (Custom)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54699, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Blindfold
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54699, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Black Ebonite Blindfold (Custom)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54698, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;White Leather Blindfold
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54698, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;White Leather Blindfold (Custom)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54699, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;White Ebonite Blindfold
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54699, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;White Ebonite Blindfold (Custom)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54698, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Red Leather Blindfold
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54698, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Red Leather Blindfold (Custom)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54699, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Ebonite Blindfold
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54699, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Red Ebonite Blindfold (Custom)
			endif
		endif
	elseif Type == "Gasmask"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x3D2CE, "Devious Devices - Expansion.esm")) as Armor ;Black Ebonite Gas Mask
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x3D9FB, "Devious Devices - Expansion.esm")) as Armor ;Black Ebonite Gas Mask (tube)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x3DA19, "Devious Devices - Expansion.esm")) as Armor ;Black Ebonite Gas Mask (filter)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x3DA37, "Devious Devices - Expansion.esm")) as Armor ;Black Ebonite Gas Mask (rebreather)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x3D9DB, "Devious Devices - Expansion.esm")) as Armor ;White Ebonite Gas Mask
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x3D9F7, "Devious Devices - Expansion.esm")) as Armor ;White Ebonite Gas Mask (tube)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x3DA15, "Devious Devices - Expansion.esm")) as Armor ;White Ebonite Gas Mask (filter)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x3DA33, "Devious Devices - Expansion.esm")) as Armor ;White Ebonite Gas Mask (rebreather)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 7)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x3D9CB, "Devious Devices - Expansion.esm")) as Armor ;Dark Red Ebonite Gas Mask
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x3D9D9, "Devious Devices - Expansion.esm")) as Armor ;Red Ebonite Gas Mask
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x3D9E7, "Devious Devices - Expansion.esm")) as Armor ;Dark Red Ebonite Gas Mask (tube)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x3D9F5, "Devious Devices - Expansion.esm")) as Armor ;Red Ebonite Gas Mask (tube)
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x3DA05, "Devious Devices - Expansion.esm")) as Armor ;Dark Red Ebonite Gas Mask (filter)
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x3DA13, "Devious Devices - Expansion.esm")) as Armor ;Red Ebonite Gas Mask (filter)
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x3DA23, "Devious Devices - Expansion.esm")) as Armor ;Dark Red Ebonite Gas Mask (rebreather)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x3DA31, "Devious Devices - Expansion.esm")) as Armor ;Red Ebonite Gas Mask (rebreather)
			endif
		endif
	endif
EndFunction

Armor Function GetDDChastityBelt(String Type, String Colour, Int ForceInt = -1) Global
	if Colour == "Iron"
		return (Game.GetFormFromFile(0xEB5D, "Devious Devices - Integration.esm")) as Armor
	elseif Colour == "Steel"
		return (Game.GetFormFromFile(0x9A7B, "Devious Devices - Integration.esm")) as Armor
	elseif Colour == "Gold"
		return (Game.GetFormFromFile(0x3FFFD, "Devious Devices - Expansion.esm")) as Armor
	elseif Colour == "Silver"
		return (Game.GetFormFromFile(0x40000, "Devious Devices - Expansion.esm")) as Armor
	elseif Colour == "Black"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x5845E, "Devious Devices - Expansion.esm")) as Armor
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x58630, "Devious Devices - Expansion.esm")) as Armor
		endif
	elseif Colour == "White"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x5845C, "Devious Devices - Expansion.esm")) as Armor
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x5862C, "Devious Devices - Expansion.esm")) as Armor
		endif
	elseif Colour == "Red"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x5845A, "Devious Devices - Expansion.esm")) as Armor
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x5862E, "Devious Devices - Expansion.esm")) as Armor
		endif
	endif
EndFunction

Armor Function GetDDChastityBra(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Metal"
		if Colour == "Steel"
			return (Game.GetFormFromFile(0x1775A, "Devious Devices - Integration.esm")) as Armor
		elseif Colour == "Gold"
			return (Game.GetFormFromFile(0x3FFFF, "Devious Devices - Expansion.esm")) as Armor
		elseif Colour == "Silver"
			return (Game.GetFormFromFile(0x40002, "Devious Devices - Expansion.esm")) as Armor
		elseif Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x58462, "Devious Devices - Expansion.esm")) as Armor
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x58626, "Devious Devices - Expansion.esm")) as Armor
			endif
		elseif Colour == "White"
			return (Game.GetFormFromFile(0x58460, "Devious Devices - Expansion.esm")) as Armor
		elseif Colour == "Red"
			return (Game.GetFormFromFile(0x58458, "Devious Devices - Expansion.esm")) as Armor
		endif
	elseif Type == "Chain"
		if Colour == "Iron"
			return (Game.GetFormFromFile(0x1C0BE, "Devious Devices - Expansion.esm")) as Armor ;Iron Chain Harness (Bra)
		elseif Colour == "Rusty Iron"
			return (Game.GetFormFromFile(0x1E690, "Devious Devices - Expansion.esm")) as Armor ;Rusty Iron Chain Harness (Bra)
		endif
	endif
EndFunction

Armor Function GetDDHarness(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Slave Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Leather Slave Harness, No Collar
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Black Leather Chastity Harness, No Collar
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;White Leather Chastity Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;White Leather Slave Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;White Leather Slave Harness, No Collar
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;White Leather Chastity Harness, No Collar
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Leather Slave Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Red Leather Chastity Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Red Leather Slave Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Red Leather Chastity Harness, No Collar
			endif
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Ebonite Slave Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Ebonite Chastity Harness, No Collar
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Black Ebonite Chastity Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Black Ebonite Slave Harness
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;White Ebonite Chastity Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;White Ebonite Slave Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;White Ebonite Slave Harness, No Collar
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;White Ebonite Chastity Harness, No Collar
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Red Ebonite Chastity Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Red Ebonite Chastity Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Red Ebonite Slave Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Red Ebonite Slave Harness, No Collar
			endif
		endif
	elseif Type == "Rope"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 31)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(62) as Armor ;Black Full Top Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(63) as Armor ;Black Hishi Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(64) as Armor ;Black Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(65) as Armor ;Black Pentagram Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(66) as Armor ;Black Simple Chaotic Rope Harness
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(67) as Armor ;Black Top Chaotic Rope Harness
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(68) as Armor ;Black Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(69) as Armor ;Black Pentagram Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(70) as Armor ;Black Simple Chaotic Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(71) as Armor ;Black Top Chaotic Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(72) as Armor ;Black Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(73) as Armor ;Black Pentagram Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(74) as Armor ;Black Simple Rope Corset
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(75) as Armor ;Black Top Rope Corset
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(76) as Armor ;Black Chaotic Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(77) as Armor ;Black Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(78) as Armor ;Black Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(79) as Armor ;Black Chaotic Top Rope Corset (Exp)
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(80) as Armor ;Black Rope Corset (Exp)
			elseif TempInt == 19
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(81) as Armor ;Black Pentagram Rope Corset (Exp)
			elseif TempInt == 20
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(82) as Armor ;Black Simple Rope Corset (Exp)
			elseif TempInt == 21
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(83) as Armor ;Black Top Rope Corset (Exp)
			elseif TempInt == 22
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(84) as Armor ;Black Extreme Rope Harness
			elseif TempInt == 23
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(85) as Armor ;Black Full Top Rope Harness
			elseif TempInt == 24
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(86) as Armor ;Black Hishi Karada Rope Harness
			elseif TempInt == 25
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(87) as Armor ;Black Pentagram Crotch Rope Harness
			elseif TempInt == 26
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(88) as Armor ;Black Pentagram Rope Harness
			elseif TempInt == 27
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(89) as Armor ;Black Simple Crotch Rope Harness
			elseif TempInt == 28
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(90) as Armor ;Black Simple Rope Harness
			elseif TempInt == 29
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(91) as Armor ;Black Top Crotch Rope Harness
			elseif TempInt == 30
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(92) as Armor ;Black Top Rope Harness
			elseif TempInt == 31
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(126) as Armor ;Black Rope Harness
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 31)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(93) as Armor ;White Full Top Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(94) as Armor ;White Hishi Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(95) as Armor ;White Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(96) as Armor ;White Pentagram Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(97) as Armor ;White Simple Chaotic Rope Harness
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(98) as Armor ;White Top Chaotic Rope Harness
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(99) as Armor ;White Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(100) as Armor ;White Pentagram Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(101) as Armor ;White Simple Chaotic Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(102) as Armor ;White Top Chaotic Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(103) as Armor ;White Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(104) as Armor ;White Pentagram Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(105) as Armor ;White Simple Rope Corset
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(106) as Armor ;White Top Rope Corset
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(107) as Armor ;White Chaotic Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(108) as Armor ;White Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(109) as Armor ;White Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(110) as Armor ;White Chaotic Top Rope Corset (Exp)
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(111) as Armor ;White Rope Corset (Exp)
			elseif TempInt == 19
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(112) as Armor ;White Pentagram Rope Corset (Exp)
			elseif TempInt == 20
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(113) as Armor ;White Simple Rope Corset (Exp)
			elseif TempInt == 21
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(114) as Armor ;White Top Rope Corset (Exp)
			elseif TempInt == 22
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(115) as Armor ;White Extreme Rope Harness
			elseif TempInt == 23
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(116) as Armor ;White Full Top Rope Harness
			elseif TempInt == 24
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(117) as Armor ;White Hishi Karada Rope Harness
			elseif TempInt == 25
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(118) as Armor ;White Pentagram Crotch Rope Harness
			elseif TempInt == 26
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(119) as Armor ;White Pentagram Rope Harness
			elseif TempInt == 27
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(120) as Armor ;White Simple Crotch Rope Harness
			elseif TempInt == 28
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(121) as Armor ;White Simple Rope Harness
			elseif TempInt == 29
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(122) as Armor ;White Top Crotch Rope Harness
			elseif TempInt == 30
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(123) as Armor ;White Top Rope Harness
			elseif TempInt == 31
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(124) as Armor ;White Rope Harness
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 31)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(31) as Armor ;Red Full Top Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(32) as Armor ;Red Hishi Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(33) as Armor ;Red Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(34) as Armor ;Red Pentagram Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(35) as Armor ;Red Simple Chaotic Rope Harness
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(36) as Armor ;Red Top Chaotic Rope Harness
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(37) as Armor ;Red Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(38) as Armor ;Red Pentagram Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(39) as Armor ;Red Simple Chaotic Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(40) as Armor ;Red Top Chaotic Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(41) as Armor ;Red Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(42) as Armor ;Red Pentagram Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(43) as Armor ;Red Simple Rope Corset
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(44) as Armor ;Red Top Rope Corset
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(45) as Armor ;Red Chaotic Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(46) as Armor ;Red Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(47) as Armor ;Red Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(48) as Armor ;Red Chaotic Top Rope Corset (Exp)
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(49) as Armor ;Red Rope Corset (Exp)
			elseif TempInt == 19
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(50) as Armor ;Red Pentagram Rope Corset (Exp)
			elseif TempInt == 20
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(51) as Armor ;Red Simple Rope Corset (Exp)
			elseif TempInt == 21
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(52) as Armor ;Red Top Rope Corset (Exp)
			elseif TempInt == 22
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(53) as Armor ;Red Extreme Rope Harness
			elseif TempInt == 23
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(54) as Armor ;Red Full Top Rope Harness
			elseif TempInt == 24
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(55) as Armor ;Red Hishi Karada Rope Harness
			elseif TempInt == 25
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(56) as Armor ;Red Pentagram Crotch Rope Harness
			elseif TempInt == 26
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(57) as Armor ;Red Pentagram Rope Harness
			elseif TempInt == 27
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(58) as Armor ;Red Simple Crotch Rope Harness
			elseif TempInt == 28
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(59) as Armor ;Red Simple Rope Harness
			elseif TempInt == 29
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(60) as Armor ;Red Top Crotch Rope Harness
			elseif TempInt == 30
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(61) as Armor ;Red Top Rope Harness
			elseif TempInt == 31
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(125) as Armor ;Red Rope Harness
			endif
		elseif Colour == "Default"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 31)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Full Top Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Hishi Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Pentagram Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Simple Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Top Chaotic Rope Harness
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Chaotic Rope Harness
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Pentagram Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Simple Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Top Chaotic Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Chaotic Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Pentagram Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Simple Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;Top Rope Corset
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Rope Corset
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;Chaotic Top Rope Corset (Exp)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(17) as Armor ;Chaotic Rope Corset (Exp)
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(18) as Armor ;Pentagram Rope Corset (Exp)
			elseif TempInt == 19
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(19) as Armor ;Simple Rope Corset (Exp)
			elseif TempInt == 20
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(20) as Armor ;Top Rope Corset (Exp)
			elseif TempInt == 21
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(21) as Armor ;Rope Corset (Exp)
			elseif TempInt == 22
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(22) as Armor ;Extreme Rope Harness
			elseif TempInt == 23
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(23) as Armor ;Full Top Rope Harness
			elseif TempInt == 24
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(24) as Armor ;Hishi Karada Rope Harness
			elseif TempInt == 25
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(25) as Armor ;Pentagram Crotch Rope Harness
			elseif TempInt == 26
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(26) as Armor ;Pentagram Rope Harness
			elseif TempInt == 27
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(27) as Armor ;Simple Crotch Rope Harness
			elseif TempInt == 28
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(28) as Armor ;Simple Rope Harness
			elseif TempInt == 29
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(29) as Armor ;Top Crotch Rope Harness
			elseif TempInt == 30
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(30) as Armor ;Top Rope Harness
			elseif TempInt == 31
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(127) as Armor ;Rope Harness
			endif
		endif
	elseif Type == "Chain"
		if Colour == "Iron"
			return (Game.GetFormFromFile(0x1C0B7, "Devious Devices - Expansion.esm") as Armor) ;Iron Chain Harness (Body)
		elseif Colour == "Rusty Iron"
			return (Game.GetFormFromFile(0x1E68D, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Chain Harness (Body)
		endif
	endif
EndFunction

Armor Function GetDDHarnessNoBelt(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Slave Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Leather Slave Harness, No Collar
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;White Leather Slave Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;White Leather Slave Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;White Leather Slave Harness, No Collar
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Leather Slave Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Red Leather Slave Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Red Leather Slave Harness
			endif
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Ebonite Slave Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Black Ebonite Slave Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Black Ebonite Slave Harness
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;White Ebonite Slave Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;White Ebonite Slave Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;White Ebonite Slave Harness, No Collar
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Red Ebonite Slave Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Red Ebonite Slave Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Red Ebonite Slave Harness, No Collar
			endif
		endif
	elseif Type == "Rope"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 14)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(64) as Armor ;Black Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(65) as Armor ;Black Pentagram Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(66) as Armor ;Black Simple Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(67) as Armor ;Black Top Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(68) as Armor ;Black Chaotic Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(69) as Armor ;Black Pentagram Chaotic Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(70) as Armor ;Black Simple Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(71) as Armor ;Black Top Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(72) as Armor ;Black Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(73) as Armor ;Black Pentagram Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(74) as Armor ;Black Simple Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(75) as Armor ;Black Top Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(88) as Armor ;Black Pentagram Rope Harness
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(90) as Armor ;Black Simple Rope Harness
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(92) as Armor ;Black Top Rope Harness
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 14)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(95) as Armor ;White Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(96) as Armor ;White Pentagram Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(97) as Armor ;White Simple Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(98) as Armor ;White Top Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(99) as Armor ;White Chaotic Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(100) as Armor ;White Pentagram Chaotic Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(101) as Armor ;White Simple Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(102) as Armor ;White Top Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(103) as Armor ;White Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(104) as Armor ;White Pentagram Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(105) as Armor ;White Simple Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(106) as Armor ;White Top Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(119) as Armor ;White Pentagram Rope Harness
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(121) as Armor ;White Simple Rope Harness
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(123) as Armor ;White Top Rope Harness
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 14)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(33) as Armor ;Red Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(34) as Armor ;Red Pentagram Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(35) as Armor ;Red Simple Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(36) as Armor ;Red Top Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(37) as Armor ;Red Chaotic Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(38) as Armor ;Red Pentagram Chaotic Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(39) as Armor ;Red Simple Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(40) as Armor ;Red Top Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(41) as Armor ;Red Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(42) as Armor ;Red Pentagram Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(43) as Armor ;Red Simple Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(44) as Armor ;Red Top Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(57) as Armor ;Red Pentagram Rope Harness
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(59) as Armor ;Red Simple Rope Harness
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(61) as Armor ;Red Top Rope Harness
			endif
		elseif Colour == "Default"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 14)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Pentagram Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Simple Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Top Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Pentagram Chaotic Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Simple Chaotic Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Top Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Pentagram Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Simple Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;Top Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(26) as Armor ;Pentagram Rope Harness
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(28) as Armor ;Simple Rope Harness
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(30) as Armor ;Top Rope Harness
			endif
		endif
	elseif Type == "Chain"
		if Colour == "Iron"
			return (Game.GetFormFromFile(0x1C0B7, "Devious Devices - Expansion.esm") as Armor) ;Iron Chain Harness (Body)
		elseif Colour == "Rusty Iron"
			return (Game.GetFormFromFile(0x1E68D, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Chain Harness (Body)
		endif
	endif
EndFunction

Armor Function GetDDHarnessNoCollar(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06054686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Leather Slave Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06054686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Black Leather Chastity Harness, No Collar
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06054686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;White Leather Slave Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06054686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;White Leather Chastity Harness, No Collar
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06054686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Leather Slave Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06054686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Red Leather Chastity Harness, No Collar
			endif
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06054687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Ebonite Slave Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06054687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Ebonite Chastity Harness, No Collar
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06054687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;White Ebonite Slave Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06054687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;White Ebonite Chastity Harness, No Collar
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06054687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Red Ebonite Chastity Harness, No Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06054687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Red Ebonite Slave Harness, No Collar
			endif
		endif
	elseif Type == "Rope"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 31)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(62) as Armor ;Black Full Top Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(63) as Armor ;Black Hishi Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(64) as Armor ;Black Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(65) as Armor ;Black Pentagram Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(66) as Armor ;Black Simple Chaotic Rope Harness
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(67) as Armor ;Black Top Chaotic Rope Harness
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(68) as Armor ;Black Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(69) as Armor ;Black Pentagram Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(70) as Armor ;Black Simple Chaotic Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(71) as Armor ;Black Top Chaotic Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(72) as Armor ;Black Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(73) as Armor ;Black Pentagram Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(74) as Armor ;Black Simple Rope Corset
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(75) as Armor ;Black Top Rope Corset
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(76) as Armor ;Black Chaotic Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(77) as Armor ;Black Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(78) as Armor ;Black Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(79) as Armor ;Black Chaotic Top Rope Corset (Exp)
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(80) as Armor ;Black Rope Corset (Exp)
			elseif TempInt == 19
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(81) as Armor ;Black Pentagram Rope Corset (Exp)
			elseif TempInt == 20
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(82) as Armor ;Black Simple Rope Corset (Exp)
			elseif TempInt == 21
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(83) as Armor ;Black Top Rope Corset (Exp)
			elseif TempInt == 22
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(84) as Armor ;Black Extreme Rope Harness
			elseif TempInt == 23
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(85) as Armor ;Black Full Top Rope Harness
			elseif TempInt == 24
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(86) as Armor ;Black Hishi Karada Rope Harness
			elseif TempInt == 25
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(87) as Armor ;Black Pentagram Crotch Rope Harness
			elseif TempInt == 26
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(88) as Armor ;Black Pentagram Rope Harness
			elseif TempInt == 27
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(89) as Armor ;Black Simple Crotch Rope Harness
			elseif TempInt == 28
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(90) as Armor ;Black Simple Rope Harness
			elseif TempInt == 29
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(91) as Armor ;Black Top Crotch Rope Harness
			elseif TempInt == 30
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(92) as Armor ;Black Top Rope Harness
			elseif TempInt == 31
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(126) as Armor ;Black Rope Harness
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 31)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(93) as Armor ;White Full Top Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(94) as Armor ;White Hishi Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(95) as Armor ;White Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(96) as Armor ;White Pentagram Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(97) as Armor ;White Simple Chaotic Rope Harness
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(98) as Armor ;White Top Chaotic Rope Harness
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(99) as Armor ;White Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(100) as Armor ;White Pentagram Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(101) as Armor ;White Simple Chaotic Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(102) as Armor ;White Top Chaotic Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(103) as Armor ;White Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(104) as Armor ;White Pentagram Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(105) as Armor ;White Simple Rope Corset
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(106) as Armor ;White Top Rope Corset
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(107) as Armor ;White Chaotic Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(108) as Armor ;White Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(109) as Armor ;White Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(110) as Armor ;White Chaotic Top Rope Corset (Exp)
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(111) as Armor ;White Rope Corset (Exp)
			elseif TempInt == 19
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(112) as Armor ;White Pentagram Rope Corset (Exp)
			elseif TempInt == 20
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(113) as Armor ;White Simple Rope Corset (Exp)
			elseif TempInt == 21
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(114) as Armor ;White Top Rope Corset (Exp)
			elseif TempInt == 22
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(115) as Armor ;White Extreme Rope Harness
			elseif TempInt == 23
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(116) as Armor ;White Full Top Rope Harness
			elseif TempInt == 24
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(117) as Armor ;White Hishi Karada Rope Harness
			elseif TempInt == 25
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(118) as Armor ;White Pentagram Crotch Rope Harness
			elseif TempInt == 26
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(119) as Armor ;White Pentagram Rope Harness
			elseif TempInt == 27
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(120) as Armor ;White Simple Crotch Rope Harness
			elseif TempInt == 28
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(121) as Armor ;White Simple Rope Harness
			elseif TempInt == 29
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(122) as Armor ;White Top Crotch Rope Harness
			elseif TempInt == 30
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(123) as Armor ;White Top Rope Harness
			elseif TempInt == 31
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(124) as Armor ;White Rope Harness
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 31)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(31) as Armor ;Red Full Top Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(32) as Armor ;Red Hishi Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(33) as Armor ;Red Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(34) as Armor ;Red Pentagram Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(35) as Armor ;Red Simple Chaotic Rope Harness
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(36) as Armor ;Red Top Chaotic Rope Harness
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(37) as Armor ;Red Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(38) as Armor ;Red Pentagram Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(39) as Armor ;Red Simple Chaotic Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(40) as Armor ;Red Top Chaotic Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(41) as Armor ;Red Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(42) as Armor ;Red Pentagram Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(43) as Armor ;Red Simple Rope Corset
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(44) as Armor ;Red Top Rope Corset
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(45) as Armor ;Red Chaotic Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(46) as Armor ;Red Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(47) as Armor ;Red Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(48) as Armor ;Red Chaotic Top Rope Corset (Exp)
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(49) as Armor ;Red Rope Corset (Exp)
			elseif TempInt == 19
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(50) as Armor ;Red Pentagram Rope Corset (Exp)
			elseif TempInt == 20
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(51) as Armor ;Red Simple Rope Corset (Exp)
			elseif TempInt == 21
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(52) as Armor ;Red Top Rope Corset (Exp)
			elseif TempInt == 22
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(53) as Armor ;Red Extreme Rope Harness
			elseif TempInt == 23
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(54) as Armor ;Red Full Top Rope Harness
			elseif TempInt == 24
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(55) as Armor ;Red Hishi Karada Rope Harness
			elseif TempInt == 25
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(56) as Armor ;Red Pentagram Crotch Rope Harness
			elseif TempInt == 26
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(57) as Armor ;Red Pentagram Rope Harness
			elseif TempInt == 27
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(58) as Armor ;Red Simple Crotch Rope Harness
			elseif TempInt == 28
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(59) as Armor ;Red Simple Rope Harness
			elseif TempInt == 29
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(60) as Armor ;Red Top Crotch Rope Harness
			elseif TempInt == 30
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(61) as Armor ;Red Top Rope Harness
			elseif TempInt == 31
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(125) as Armor ;Red Rope Harness
			endif
		elseif Colour == "Default"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 31)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Full Top Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Hishi Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Pentagram Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Simple Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Top Chaotic Rope Harness
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Chaotic Rope Harness
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Pentagram Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Simple Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Top Chaotic Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Chaotic Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Pentagram Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Simple Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;Top Rope Corset
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Rope Corset
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 16
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;Chaotic Top Rope Corset (Exp)
			elseif TempInt == 17
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(17) as Armor ;Chaotic Rope Corset (Exp)
			elseif TempInt == 18
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(18) as Armor ;Pentagram Rope Corset (Exp)
			elseif TempInt == 19
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(19) as Armor ;Simple Rope Corset (Exp)
			elseif TempInt == 20
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(20) as Armor ;Top Rope Corset (Exp)
			elseif TempInt == 21
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(21) as Armor ;Rope Corset (Exp)
			elseif TempInt == 22
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(22) as Armor ;Extreme Rope Harness
			elseif TempInt == 23
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(23) as Armor ;Full Top Rope Harness
			elseif TempInt == 24
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(24) as Armor ;Hishi Karada Rope Harness
			elseif TempInt == 25
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(25) as Armor ;Pentagram Crotch Rope Harness
			elseif TempInt == 26
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(26) as Armor ;Pentagram Rope Harness
			elseif TempInt == 27
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(27) as Armor ;Simple Crotch Rope Harness
			elseif TempInt == 28
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(28) as Armor ;Simple Rope Harness
			elseif TempInt == 29
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(29) as Armor ;Top Crotch Rope Harness
			elseif TempInt == 30
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(30) as Armor ;Top Rope Harness
			elseif TempInt == 31
				return (Game.GetFormFromFile(0x06054688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(127) as Armor ;Rope Harness
			endif
		endif
	endif
EndFunction

Armor Function GetDDHarnessNoBeltNoCollar(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x06054686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Leather Slave Harness, No Collar
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x06054686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;White Leather Slave Harness, No Collar
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x06054686, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Leather Slave Harness, No Collar
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x06054687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Ebonite Slave Harness, No Collar
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x06054687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;White Ebonite Slave Harness, No Collar
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x06054687, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Red Ebonite Slave Harness, No Collar
		endif
	elseif Type == "Rope"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 14)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(64) as Armor ;Black Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(65) as Armor ;Black Pentagram Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(66) as Armor ;Black Simple Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(67) as Armor ;Black Top Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(68) as Armor ;Black Chaotic Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(69) as Armor ;Black Pentagram Chaotic Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(70) as Armor ;Black Simple Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(71) as Armor ;Black Top Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(72) as Armor ;Black Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(73) as Armor ;Black Pentagram Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(74) as Armor ;Black Simple Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(75) as Armor ;Black Top Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(88) as Armor ;Black Pentagram Rope Harness
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(90) as Armor ;Black Simple Rope Harness
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(92) as Armor ;Black Top Rope Harness
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 14)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(95) as Armor ;White Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(96) as Armor ;White Pentagram Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(97) as Armor ;White Simple Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(98) as Armor ;White Top Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(99) as Armor ;White Chaotic Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(100) as Armor ;White Pentagram Chaotic Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(101) as Armor ;White Simple Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(102) as Armor ;White Top Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(103) as Armor ;White Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(104) as Armor ;White Pentagram Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(105) as Armor ;White Simple Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(106) as Armor ;White Top Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(119) as Armor ;White Pentagram Rope Harness
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(121) as Armor ;White Simple Rope Harness
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(123) as Armor ;White Top Rope Harness
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 14)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(33) as Armor ;Red Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(34) as Armor ;Red Pentagram Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(35) as Armor ;Red Simple Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(36) as Armor ;Red Top Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(37) as Armor ;Red Chaotic Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(38) as Armor ;Red Pentagram Chaotic Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(39) as Armor ;Red Simple Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(40) as Armor ;Red Top Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(41) as Armor ;Red Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(42) as Armor ;Red Pentagram Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(43) as Armor ;Red Simple Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(44) as Armor ;Red Top Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(57) as Armor ;Red Pentagram Rope Harness
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(59) as Armor ;Red Simple Rope Harness
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(61) as Armor ;Red Top Rope Harness
			endif
		elseif Colour == "Default"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 14)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Pentagram Chaotic Rope Harness
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Simple Chaotic Rope Harness
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Top Chaotic Rope Harness
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Chaotic Rope Harness
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Pentagram Chaotic Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Simple Chaotic Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Top Chaotic Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Chaotic Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Pentagram Rope Corset
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Simple Rope Corset
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;Top Rope Corset
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Rope Corset
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(26) as Armor ;Pentagram Rope Harness
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(28) as Armor ;Simple Rope Harness
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x54688, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(30) as Armor ;Top Rope Harness
			endif
		endif
	endif
EndFunction

Armor Function GetDDCorset(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A6, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Restrictive Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A6, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Leather Restrictive Chastity Corset
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A6, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;White Leather Restrictive Chastity Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A6, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;White Leather Restrictive Corset
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A6, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Red Leather Restrictive Chastity Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A6, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Red Leather Restrictive Corset
			endif
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A7, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Restrictive Chastity Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A7, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Black Ebonite Restrictive Corset
			endif
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x546A7, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;White Ebonite Restrictive Corset
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A7, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Ebonite Restrictive Chastity Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A7, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Red Ebonite Restrictive Corset
			endif
		endif
	elseif Type == "Rope"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 15)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(32) as Armor ;Black Chaotic Rope Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(33) as Armor ;Black Pentagram Chaotic Rope Corset
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(34) as Armor ;Black Simple Chaotic Rope Corset
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(35) as Armor ;Black Top Chaotic Rope Corset
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(36) as Armor ;Black Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(37) as Armor ;Black Pentagram Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(38) as Armor ;Black Simple Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(39) as Armor ;Black Top Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(40) as Armor ;Black Chaotic Rope Corset (Exp)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(41) as Armor ;Black Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(42) as Armor ;Black Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(43) as Armor ;Black Chaotic Top Rope Corset (Exp)
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(44) as Armor ;Black Rope Corset (Exp)
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(45) as Armor ;Black Pentagram Rope Corset (Exp)
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(46) as Armor ;Black Simple Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(47) as Armor ;Black Top Rope Corset (Exp)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 15)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(48) as Armor ;White Chaotic Rope Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(49) as Armor ;White Pentagram Chaotic Rope Corset
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(50) as Armor ;White Simple Chaotic Rope Corset
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(51) as Armor ;White Top Chaotic Rope Corset
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(52) as Armor ;White Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(53) as Armor ;White Pentagram Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(54) as Armor ;White Simple Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(55) as Armor ;White Top Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(56) as Armor ;White Chaotic Rope Corset (Exp)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(57) as Armor ;White Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(58) as Armor ;White Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(59) as Armor ;White Chaotic Top Rope Corset (Exp)
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(60) as Armor ;White Rope Corset (Exp)
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(61) as Armor ;White Pentagram Rope Corset (Exp)
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(62) as Armor ;White Simple Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(63) as Armor ;White Top Rope Corset (Exp)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 15)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;Red Chaotic Rope Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(17) as Armor ;Red Pentagram Chaotic Rope Corset
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(18) as Armor ;Red Simple Chaotic Rope Corset
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(19) as Armor ;Red Top Chaotic Rope Corset
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(20) as Armor ;Red Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(21) as Armor ;Red Pentagram Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(22) as Armor ;Red Simple Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(23) as Armor ;Red Top Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(24) as Armor ;Red Chaotic Rope Corset (Exp)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(25) as Armor ;Red Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(26) as Armor ;Red Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(27) as Armor ;Red Chaotic Top Rope Corset (Exp)
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(28) as Armor ;Red Rope Corset (Exp)
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(29) as Armor ;Red Pentagram Rope Corset (Exp)
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(30) as Armor ;Red Simple Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(31) as Armor ;Red Top Rope Corset (Exp)
			endif
		elseif Colour == "Default"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 15)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Pentagram Chaotic Rope Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Simple Chaotic Rope Corset
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Top Chaotic Rope Corset
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Chaotic Rope Corset
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Pentagram Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Simple Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Top Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Rope Corset
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Chaotic Pentagram Rope Corset (Exp)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Chaotic Simple Rope Corset (Exp)
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Chaotic Top Rope Corset (Exp)
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Chaotic Rope Corset (Exp)
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;Pentagram Rope Corset (Exp)
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Simple Rope Corset (Exp)
			elseif TempInt == 14
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;Top Rope Corset (Exp)
			elseif TempInt == 15
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Rope Corset (Exp)
			endif
		endif
	endif
EndFunction

Armor Function GetDDCorsetNoBelt(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x546A6, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Restrictive Corset
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x546A6, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;White Leather Restrictive Corset
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x546A6, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Red Leather Restrictive Corset
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x546A7, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Black Ebonite Restrictive Corset
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x546A7, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;White Ebonite Restrictive Corset
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x546A7, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Red Ebonite Restrictive Corset
		endif
	elseif Type == "Rope"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 7)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(32) as Armor ;Black Chaotic Rope Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(33) as Armor ;Black Pentagram Chaotic Rope Corset
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(34) as Armor ;Black Simple Chaotic Rope Corset
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(35) as Armor ;Black Top Chaotic Rope Corset
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(36) as Armor ;Black Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(37) as Armor ;Black Pentagram Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(38) as Armor ;Black Simple Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(39) as Armor ;Black Top Rope Corset
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 7)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(48) as Armor ;White Chaotic Rope Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(49) as Armor ;White Pentagram Chaotic Rope Corset
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(50) as Armor ;White Simple Chaotic Rope Corset
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(51) as Armor ;White Top Chaotic Rope Corset
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(52) as Armor ;White Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(53) as Armor ;White Pentagram Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(54) as Armor ;White Simple Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(55) as Armor ;White Top Rope Corset
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 7)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;Red Chaotic Rope Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(17) as Armor ;Red Pentagram Chaotic Rope Corset
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(18) as Armor ;Red Simple Chaotic Rope Corset
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(19) as Armor ;Red Top Chaotic Rope Corset
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(20) as Armor ;Red Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(21) as Armor ;Red Pentagram Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(22) as Armor ;Red Simple Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(23) as Armor ;Red Top Rope Corset
			endif
		elseif Colour == "Default"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 7)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Pentagram Chaotic Rope Corset
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Simple Chaotic Rope Corset
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Top Chaotic Rope Corset
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Chaotic Rope Corset
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Pentagram Rope Corset
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Simple Rope Corset
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Top Rope Corset
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x546A8, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Rope Corset
			endif
		endif
	endif
EndFunction

Armor Function GetDDBoots(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x5468F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Restrictive Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x5468F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Black Leather High Heels
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x5468F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;White Leather Restrictive Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x5468F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;White Leather High Heels
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x5468F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Leather Restrictive Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x5468F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Red Leather High Heels
			endif
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Restrictive Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Black Ebonite Catsuit Ballet Boots
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(36) as Armor ;Black Ebonite Catsuit Boots
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(54) as Armor ;Black Ebonite High Heels
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;White Ebonite Restrictive Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(33) as Armor ;White Ebonite Catsuit Ballet Boots
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(50) as Armor ;White Ebonite Catsuit Boots
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(52) as Armor ;White Ebonite High Heels
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 5)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Ebonite Restrictive Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(25) as Armor ;Dark Red Ebonite Catsuit Ballet Boots
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(32) as Armor ;Red Ebonite Catsuit Ballet Boots
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(41) as Armor ;Dark Red Ebonite Catsuit Boots
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(48) as Armor ;Red Ebonite Catsuit Boots
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54690, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(53) as Armor ;Red Ebonite High Heels
			endif
		endif
	elseif Type == "Metal"
		if Colour == "Iron"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 4)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54691, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Iron Ring Slave Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54691, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Iron Ballet Boots
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54691, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Iron Ballet Boots (Reinforced)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54691, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Rusty Iron Ballet Boots
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54691, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Rusty Iron Ballet Boots (Reinforced)
			endif
		endif
	elseif Type == "Pony"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x0604A1E7, "Devious Devices - Expansion.esm") as Armor) ;Black Ebonite Pony Play Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x060116F6, "Devious Devices - Expansion.esm") as Armor) ;Black Ebonite Pony Boots
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x060116F1, "Devious Devices - Expansion.esm") as Armor) ;Black Leather Pony Boots
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x060116FE, "Devious Devices - Expansion.esm") as Armor) ;White Ebonite Pony Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x060116FA, "Devious Devices - Expansion.esm") as Armor) ;White Leather Pony Boots
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x06011706, "Devious Devices - Expansion.esm") as Armor) ;Red Ebonite Pony Boots
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x06011702, "Devious Devices - Expansion.esm") as Armor) ;Red Leather Pony Boots
			endif
		endif
	endif
EndFunction

Armor Function GetDDGloves(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x54C14, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Restrictive Gloves
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x54C14, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;White Leather Restrictive Gloves
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x54C14, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Leather Restrictive Gloves
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54C15, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Restrictive Gloves
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54C15, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Black Ebonite Catsuit Long Gloves
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54C15, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;White Ebonite Restrictive Gloves
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54C15, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;White Ebonite Catsuit Long Gloves
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54C15, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Ebonite Restrictive Gloves
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54C15, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Dark Red Ebonite Catsuit Long Gloves
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54C15, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Red Ebonite Catsuit Long Gloves
			endif
		endif
	endif
EndFunction

Armor Function GetDDArmCuffs(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x5469C, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Cuffs (Arms)
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x5469C, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;White Leather Cuffs (Arms)
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x5469C, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Leather Cuffs (Arms)
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x5469D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Cuffs (Arms)
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x5469D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;White Ebonite Cuffs (Arms)
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x5469D, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Ebonite Cuffs (Arms)
		endif
	elseif Type == "Metal"
		if Colour == "Steel"
				return (Game.GetFormFromFile(0x5469E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Steel Cuffs (Padded) (Arms)
		elseif Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x5469E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Lustrous Cuffs (Padded) (Arms)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x5469E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Black Cuffs (Padded) (Arms)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x5469E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;White Lustrous Cuffs (Padded) (Arms)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x5469E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;White Cuffs (Padded) (Arms)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x5469E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Lustrous Cuffs (Padded) (Arms)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x5469E, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Red Cuffs (Padded) (Arms)
			endif
		endif
	elseif Type == "Chain"
		if Colour == "Iron"
			return (Game.GetFormFromFile(0x1C0BC, "Devious Devices - Expansion.esm") as Armor) ;Iron Chain Harness (Arms)
		elseif Colour == "Rusty Iron"
			return (Game.GetFormFromFile(0x1E68A, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Chain Harness (Arms)
		endif
	elseif Type == "Rope"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x5469F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Rope Arm Cuffs
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x5469F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;White Rope Arm Cuffs
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x5469F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Rope Arm Cuffs
		elseif Colour == "Default"
				return (Game.GetFormFromFile(0x5469F, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Rope Arm Cuffs
		endif
	endif
EndFunction

Armor Function GetDDLegCuffs(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x546A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Cuffs (Legs)
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x546A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;White Leather Cuffs (Legs)
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x546A1, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Leather Cuffs (Legs)
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x546A2, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Cuffs (Legs)
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x546A2, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;White Ebonite Cuffs (Legs)
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x546A2, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Ebonite Cuffs (Legs)
		endif
	elseif Type == "Metal"
		if Colour == "Steel"
				return (Game.GetFormFromFile(0x546A3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Steel Cuffs (Padded) (Legs)
		elseif Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Lustrous Cuffs (Padded) (Legs)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Black Cuffs (Padded) (Legs)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;White Lustrous Cuffs (Padded) (Legs)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;White Cuffs (Padded) (Legs)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x546A3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Lustrous Cuffs (Padded) (Legs)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x546A3, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Red Cuffs (Padded) (Legs)
			endif
		endif
	elseif Type == "Chain"
		if Colour == "Iron"
			return (Game.GetFormFromFile(0x1C0BA, "Devious Devices - Expansion.esm") as Armor) ;Iron Chain Harness (Legs)
		elseif Colour == "Rusty Iron"
			return (Game.GetFormFromFile(0x1E694, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Chain Harness (Legs)
		endif
	elseif Type == "Rope"
		if Colour == "Black"
				return (Game.GetFormFromFile(0x546A4, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Rope Leg Cuffs
		elseif Colour == "White"
				return (Game.GetFormFromFile(0x546A4, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;White Rope Leg Cuffs
		elseif Colour == "Red"
				return (Game.GetFormFromFile(0x509C8, "Devious Devices - Expansion.esm") as Armor)								;Red Rope Leg Cuffs
		elseif Colour == "Default"
				return (Game.GetFormFromFile(0x546A4, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Rope Leg Cuffs
		endif
	endif
EndFunction

Armor Function GetDDCollar(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Leather"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Leather Collar (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Leather Collar
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Leather Collar (Posture)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Black Leather Restrictive Collar
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;White Leather Collar (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;White Leather Collar
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;White Leather Collar (Posture)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;White Leather Restrictive Collar
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 3)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Red Leather Collar (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Red Leather Collar
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Red Leather Collar (Posture)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54693, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Red Leather Restrictive Collar
			endif
		endif
	elseif Type == "Ebonite"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 7)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Ebonite Collar (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Black Ebonite Collar
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Black Ebonite Collar (Posture)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Black Ebonite Restrictive Collar
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;Black Ebonite Catsuit Collar
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(28) as Armor ;Black Ebonite Collar (Simple)
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(31) as Armor ;Black Ebonite Collar (Studded)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(34) as Armor ;Black Ebonite Collar (Spiked)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 7)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;White Ebonite Collar (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;White Ebonite Collar
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;White Ebonite Collar (Posture)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;White Ebonite Restrictive Collar
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(25) as Armor ;White Ebonite Catsuit Collar
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(30) as Armor ;White Ebonite Collar (Simple)
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(33) as Armor ;White Ebonite Collar (Studded)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(36) as Armor ;White Ebonite Collar (Spiked)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 8)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Red Ebonite Collar (Harness)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Red Ebonite Collar
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Red Ebonite Collar (Posture)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Red Ebonite Restrictive Collar
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(17) as Armor ;Dark Red Ebonite Catsuit Collar
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(24) as Armor ;Red Ebonite Catsuit Collar
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(29) as Armor ;Red Ebonite Collar (Simple)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(32) as Armor ;Red Ebonite Collar (Studded)
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54694, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(35) as Armor ;Red Ebonite Collar (Spiked)
			endif
		endif
	elseif Type == "Metal"
		if Colour == "Iron"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 13)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Steel Collar (Padded) (Posture)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Steel Collar (Padded)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Iron Collar (Nipple Chain)
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Iron Collar
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Rusty Iron Collar
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Rusty Iron Collar (Nipple Chain)
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Iron Collar (Short Chain)
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Iron Collar (Medium Chain)
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Iron Collar (Lengthy Chain)
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Iron Collar (Long Chain)
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(12) as Armor ;Rusty Iron Collar (Short Chain)
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(13) as Armor ;Rusty Iron Collar (Medium Chain)
			elseif TempInt == 12
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(14) as Armor ;Rusty Iron Collar (Lengthy Chain)
			elseif TempInt == 13
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(15) as Armor ;Rusty Iron Collar (Long Chain)
			endif
		elseif Colour == "Golden"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(16) as Armor ;Golden Collar (Padded) (Posture)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(18) as Armor ;Golden Collar (Padded)
			endif
		elseif Colour == "Silver"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(17) as Armor ;Silver Collar (Padded) (Posture)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(19) as Armor ;Silver Collar (Padded)
			endif
		elseif Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(22) as Armor ;Black Collar (Padded) (Posture)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(25) as Armor ;Black Collar (Padded)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(26) as Armor ;Black Lustrous Collar (Padded) (Posture)
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;White Lustrous Collar (Padded) (Posture)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(21) as Armor ;White Collar (Padded) (Posture)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(24) as Armor ;White Collar (Padded)
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Red Lustrous Collar (Padded) (Posture)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(20) as Armor ;Red Collar (Padded) (Posture)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x54695, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(23) as Armor ;Red Collar (Padded)
			endif
		endif
	elseif Type == "Rope"
		if Colour == "Black"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54696, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Black Rope Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54696, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Black Rope Collar
			endif
		elseif Colour == "White"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54696, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;White Rope Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54696, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;White Rope Collar
			endif
		elseif Colour == "Red"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54696, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Red Rope Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54696, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Red Rope Collar
			endif
		elseif Colour == "Default"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x54696, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Rope Collar
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x54696, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Rope Collar
			endif
		endif
	endif
EndFunction

Armor Function GetDDPlugVaginal(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Iron"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Plug (Iron) (Vaginal)
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Plug (Locking) (Vaginal)
		endif
	elseif Type == "Pear"
		if Colour == "Iron"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x1BB4D, "Devious Devices - Expansion.esm") as Armor) ;Iron Pear of Anguish (Bell) (Vaginal)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x1B5E8, "Devious Devices - Expansion.esm") as Armor) ;Iron Pear of Anguish (Chain) (Vaginal)
			endif
		elseif Colour == "Rusty Iron"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 1)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x1FC4B, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Pear of Anguish (Chain) (Vaginal)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x1FC47, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Pear of Anguish (Bell) (Vaginal)
			endif
		endif
	elseif Type == "Wood"
		return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Plug (Primitive) (Vaginal)
	elseif Type == "Soulgem"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 7)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Plug (Soulgem) (Vaginal)
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Plug (Shocker) (Vaginal)
		elseif TempInt == 2
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Plug (Greater Soulgem) (Vaginal)
		elseif TempInt == 3
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Plug (Grand Soulgem) (Vaginal)
		elseif TempInt == 4
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Plug (Black Soulgem) (Vaginal)
		elseif TempInt == 5
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(10) as Armor ;Plug (Filled Soulgem) (Vaginal)
		elseif TempInt == 6
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Plug (Chaos) (Vaginal)
		elseif TempInt == 7
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(11) as Armor ;Plug (Shock) (Vaginal)
		endif
	elseif Type == "Leather"
		Int DefaultWeight = 1
		Int DeviousToysWeight = 12
		String ModName = ""
		Int TotalWeight = DefaultWeight
		If Game.GetModByName("DeviousToys.esp") != 255
			TotalWeight += DeviousToysWeight
		endif
		Int RandomWeight = Utility.RandomInt(1, TotalWeight)
		If (RandomWeight <= DefaultWeight) && ModName == ""
			ModName = "Default"
		else
			RandomWeight -= DefaultWeight
		endif
		If Game.GetModByName("DeviousToys.esp") != 255
			If RandomWeight <= DeviousToysWeight && ModName == ""
				ModName = "DeviousToys"
			else
				RandomWeight -= DeviousToysWeight
			endif
		endif
		If ModName == "Default"
			return (Game.GetFormFromFile(0x546AB, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Plug (Inflatable) (Vaginal)
		elseif ModName == "DeviousToys"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 11)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x73F4, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 01
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x7963, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 02
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x7964, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 03
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x7965, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 04
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x7966, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 05
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x7967, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 06
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x7968, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 07
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x7969, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 08
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x796A, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 09
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x796B, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 10
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x796C, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 11
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x796D, "DeviousToys.esp") as Armor) ;DDT Vaginal Plug 12
			endif
		endif
	endif
EndFunction

Armor Function GetDDPlugAnal(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Iron"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Plug (Iron) (Anal)
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Plug (Locking) (Anal)
		endif
	elseif Type == "Pear"
		if Colour == "Iron"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x1B5E5, "Devious Devices - Expansion.esm") as Armor) ;Iron Pear of Anguish (Bell) (Anal)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x1B5E3, "Devious Devices - Expansion.esm") as Armor) ;Iron Pear of Anguish (Sign) (Anal)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x1B5E1, "Devious Devices - Expansion.esm") as Armor) ;Iron Pear of Anguish (Chain) (Anal)
			endif
		elseif Colour == "Rusty Iron"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 2)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x1FC49, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Pear of Anguish (Chain) (Anal)
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x1FC45, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Pear of Anguish (Sign) (Anal)
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x1FC43, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Pear of Anguish (Bell) (Anal)
			endif
		endif
	elseif Type == "Wood"
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Plug (Primitive) (Anal)
	elseif Type == "Soulgem"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 5)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Plug (Soulgem) (Anal)
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(5) as Armor ;Plug (Greater Soulgem) (Anal)
		elseif TempInt == 2
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(6) as Armor ;Plug (Grand Soulgem) (Anal)
		elseif TempInt == 3
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(7) as Armor ;Plug (Black Soulgem) (Anal)
		elseif TempInt == 4
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(8) as Armor ;Plug (Filled Soulgem) (Anal)
		elseif TempInt == 5
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(9) as Armor ;Plug (Shock) (Anal)
		endif
	elseif Type == "Leather"
		Int DefaultWeight = 1
		Int DeviousToysWeight = 12
		String ModName = ""
		Int TotalWeight = DefaultWeight
		If Game.GetModByName("DeviousToys.esp") != 255
			TotalWeight += DeviousToysWeight
		endif
		Int RandomWeight = Utility.RandomInt(1, TotalWeight)
		If (RandomWeight <= DefaultWeight) && ModName == ""
			ModName = "Default"
		else
			RandomWeight -= DefaultWeight
		endif
		If Game.GetModByName("DeviousToys.esp") != 255
			If RandomWeight <= DeviousToysWeight && ModName == ""
				ModName = "DeviousToys"
			else
				RandomWeight -= DeviousToysWeight
			endif
		endif
		If ModName == "Default"
			return (Game.GetFormFromFile(0x546AA, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Plug (Inflatable) (Anal)
		elseif ModName == "DeviousToys"
			Int TempInt
			if ForceInt != -1
				TempInt = ForceInt
			else
				TempInt = Utility.RandomInt(0, 11)
			endif
			if TempInt == 0
				return (Game.GetFormFromFile(0x12C6, "DeviousToys.esp") as Armor) ;DDT Anal Plug 01
			elseif TempInt == 1
				return (Game.GetFormFromFile(0x4E06, "DeviousToys.esp") as Armor) ;DDT Anal Plug 02
			elseif TempInt == 2
				return (Game.GetFormFromFile(0x4E07, "DeviousToys.esp") as Armor) ;DDT Anal Plug 03
			elseif TempInt == 3
				return (Game.GetFormFromFile(0x4E08, "DeviousToys.esp") as Armor) ;DDT Anal Plug 04
			elseif TempInt == 4
				return (Game.GetFormFromFile(0x4E09, "DeviousToys.esp") as Armor) ;DDT Anal Plug 05
			elseif TempInt == 5
				return (Game.GetFormFromFile(0x4E0A, "DeviousToys.esp") as Armor) ;DDT Anal Plug 06
			elseif TempInt == 6
				return (Game.GetFormFromFile(0x4E0B, "DeviousToys.esp") as Armor) ;DDT Anal Plug 07
			elseif TempInt == 7
				return (Game.GetFormFromFile(0x4E0C, "DeviousToys.esp") as Armor) ;DDT Anal Plug 08
			elseif TempInt == 8
				return (Game.GetFormFromFile(0x4E0D, "DeviousToys.esp") as Armor) ;DDT Anal Plug 09
			elseif TempInt == 9
				return (Game.GetFormFromFile(0x4E0E, "DeviousToys.esp") as Armor) ;DDT Anal Plug 10
			elseif TempInt == 10
				return (Game.GetFormFromFile(0x4E0F, "DeviousToys.esp") as Armor) ;DDT Anal Plug 11
			elseif TempInt == 11
				return (Game.GetFormFromFile(0x4E10, "DeviousToys.esp") as Armor) ;DDT Anal Plug 12
			endif
		endif
	endif
EndFunction

Armor Function GetDDPiercingVaginal(String Type, String Colour, Int ForceInt = -1) Global
	Int TempInt
	if ForceInt != -1
		TempInt = ForceInt
	else
		TempInt = Utility.RandomInt(0, 2)
	endif
	if TempInt == 0
		return (Game.GetFormFromFile(0x546AE, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Jeweled Piercings (Clitoral) (Soulgem)
	elseif TempInt == 1
		return (Game.GetFormFromFile(0x546AE, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Jeweled Piercings (Clitoral) (Common Soulgem)
	elseif TempInt == 2
		return (Game.GetFormFromFile(0x546AE, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Jeweled Piercings (Clitoral) (Shock)
	endif
EndFunction

Armor Function GetDDPiercingNipple(String Type, String Colour, Int ForceInt = -1) Global
	Int TempInt
	if ForceInt != -1
		TempInt = ForceInt
	else
		TempInt = Utility.RandomInt(0, 4)
	endif
	if TempInt == 0
		return (Game.GetFormFromFile(0x546AD, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(0) as Armor ;Jeweled Piercings (Nipples) (Soulgem)
	elseif TempInt == 1
		return (Game.GetFormFromFile(0x546AD, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(1) as Armor ;Jeweled Piercings (Nipples) (Common Soulgem)
	elseif TempInt == 2
		return (Game.GetFormFromFile(0x546AD, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(2) as Armor ;Jeweled Piercings (Nipples) (Shock)
	elseif TempInt == 3
		return (Game.GetFormFromFile(0x546AD, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(3) as Armor ;Iron Piercings (Nipples)
	elseif TempInt == 4
		return (Game.GetFormFromFile(0x546AD, "Devious Devices - Expansion.esm") as LeveledItem).GetNthForm(4) as Armor ;Rusty Iron Piercings (Nipples)
	endif
EndFunction

Armor Function GetDDLegShackles(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "NoBall"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x2F517, "Devious Devices - Expansion.esm") as Armor) ;Iron Fetters (Chain)
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x2F51C, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Fetters (Chain)
		endif
	elseif Type == "Ball"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 3)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x2F51E, "Devious Devices - Expansion.esm") as Armor) ;Iron Fetters (Ball & Chain)
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x2FA83, "Devious Devices - Expansion.esm") as Armor) ;Iron Fetters (Ball & Chain) (Long)
		elseif TempInt == 2
			return (Game.GetFormFromFile(0x2FA87, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Fetters (Ball & Chain)
		elseif TempInt == 3
			return (Game.GetFormFromFile(0x2FA89, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Fetters (Ball & Chain) (Long)
		endif
	endif
EndFunction

Armor Function GetDDArmShackles(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Iron"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x37C17, "Devious Devices - Expansion.esm") as Armor) ;Iron Handcuffs
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x3817D, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Handcuffs
		endif
	endif
EndFunction

Armor Function GetDDArmLegShackles(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Iron"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x2FA8B, "Devious Devices - Expansion.esm") as Armor) ;Iron Prisoner Chains
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x2FA8F, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Prisoner Chains
		endif
	endif
EndFunction

Armor Function GetDDMittens(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Metal"
		Int TempInt
		if ForceInt != -1
			TempInt = ForceInt
		else
			TempInt = Utility.RandomInt(0, 1)
		endif
		if TempInt == 0
			return (Game.GetFormFromFile(0x1C0C2, "Devious Devices - Expansion.esm") as Armor) ;Iron Chain Harness (Wrists)
		elseif TempInt == 1
			return (Game.GetFormFromFile(0x201BF, "Devious Devices - Expansion.esm") as Armor) ;Rusty Iron Chain Harness (Wrists)
		endif
	elseif Type == "Leather"
		If Colour == "Black"
			return (Game.GetFormFromFile(0x2324D, "Devious Devices - Expansion.esm") as Armor) ;Black Leather Paw Bondage Mittens
		elseif Colour == "White"
			return (Game.GetFormFromFile(0x237B8, "Devious Devices - Expansion.esm") as Armor) ;White Leather Paw Bondage Mittens
		elseif Colour == "Red"
			return (Game.GetFormFromFile(0x237B5, "Devious Devices - Expansion.esm") as Armor) ;Red Leather Paw Bondage Mittens
		endif
	endif
EndFunction

Armor Function GetDDYoke(String Type, String Colour, Int ForceInt = -1) Global
	if Type == "Iron"
		return (Game.GetFormFromFile(0x4F18C, "Devious Devices - Integration.esm") as Armor) ;Iron Yoke
	elseif Type == "Steel"
		return (Game.GetFormFromFile(0x3D2E1, "Devious Devices - Expansion.esm") as Armor) ;Steel Yoke
	elseif Type == "Wood"
		return (Game.GetFormFromFile(0x24B0, "Devious Devices - Expansion.esm") as Armor) ;Wooden Yoke
	elseif Type == "Breast"
		return (Game.GetFormFromFile(0x3C7FB, "Devious Devices - Expansion.esm") as Armor) ;Iron Breast Yoke
	endif
EndFunction

Armor Function GetDDElbowShackles(String Type, String Colour, Int ForceInt = -1) Global
	Int TempInt
	if ForceInt != -1
		TempInt = ForceInt
	else
		TempInt = Utility.RandomInt(0, 2)
	endif
	if TempInt == 0
		return (Game.GetFormFromFile(0x53629, "Devious Devices - Expansion.esm") as Armor) ;Elbow Shackles
	elseif TempInt == 1
		return (Game.GetFormFromFile(0x53625, "Devious Devices - Expansion.esm") as Armor) ;Hooked Elbow Shackles
	elseif TempInt == 2
		return (Game.GetFormFromFile(0x530C1, "Devious Devices - Expansion.esm") as Armor) ;Elbow Shackles with Collar
	endif
EndFunction
