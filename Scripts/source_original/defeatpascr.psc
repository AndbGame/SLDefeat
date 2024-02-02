Scriptname DefeatPAscr Extends Quest

DefeatMCMscr Property McmConfig Auto
DefeatConfig Property Defeat Auto
DefeatPostRscr Property PostRScr Auto Hidden
DefeatPlayer Property PlayerScr Auto

Import Game
Import Utility
Import Debug

Quest[] Property PostAssaultQsts Auto Hidden
Actor Property Player Auto
Bool Property Blackout Auto Hidden
FormList Property ForbiddenLocList Auto
String CustomEvent
GlobalVariable GameHour

;;
ImageSpaceModifier Property ISFadeOut Auto

Function Install()
	PostAssaultQsts = New Quest[10]
	PostAssaultQsts[0] = (GetFormFromFile(0xC1173, "SexLabDefeat.esp") As Quest) 	; LeftForDeadQST
	PostAssaultQsts[1] = (GetFormFromFile(0xC16D8, "SexLabDefeat.esp") As Quest)	; DefeatedQST
	PostAssaultQsts[2] = (GetFormFromFile(0x10EFF0, "SexLabDefeat.esp") As Quest) 	; SequesteredQST
	PostAssaultQsts[3] = (GetFormFromFile(0xF8B09, "SexLabDefeat.esp") As Quest) 	; FollowerKidnappingQST
	GameHour = (GetFormFromFile(0x00038, "Skyrim.esm") As GlobalVariable)
EndFunction
Function Configure()
EndFunction

Function Escape()
	PlayerScr.SetGetUpInRestored(False)
	If PlayerScr.IsPlayerKnokedOut()
		PlayerScr.CleanAggAliases()
		Defeat.FadeIn(3.0)
		GameHour.Mod(RandomFloat(1, 2))
		Defeat.DefeatPlayAnimation(Player, "Sit")
		PlayerScr.MiscScenes[1].ForceStart() ; SCEscape
	Else
		If (McmConfig.bEscape == "$Trauma")
	;		Defeat.Fadein(3.0)
			PlayerScr.MiscScenes[1].ForceStart() ; SCEscape
		Else
			Wait(3.0)
			Defeat.DefeatPlayAnimation(Player, "Stand")
			PlayerScr.Restored()
		Endif
	Endif
EndFunction

Event DARecoverSequence(string eventName, string strArg, float numArg, Form sender)
;	DefeatConfig.Log("DARecoverSequence - Player.HasKeywordString(DefeatActive) - "+Player.HasKeywordString("DefeatActive"))
	If Player.HasKeywordString("DefeatActive")
		PlayerScr.Restored()
	Endif
	UnregisterForModEvent("da_StartRecoverSequence")
EndEvent

Function PickEvent()
	actor SelectedAggrressor
	
	if !Defeat.LastSceneTheLast || Defeat.LastSceneTheLast.IsDead()
		if Defeat.LastSceneAggressors.Length > 0
			int ListLength = Defeat.LastSceneAggressors.Length
			while ListLength > 0
				ListLength -= 1
				if Defeat.LastSceneAggressors[ListLength] && !Defeat.LastSceneAggressors[ListLength].IsDead()
					SelectedAggrressor = Defeat.LastSceneAggressors[ListLength]
					ListLength = 0
				endif
			endwhile
		endif
	else
		SelectedAggrressor = Defeat.LastSceneTheLast
	endif
	
	Blackout = True
	If (PlayerScr.ForcedScene == "")
		If (Defeat.LastSceneTheLast && Defeat.LastSceneTheLast.IsDead()) ; Check if the last aggressor is dead in case of double ko or something and then triggers a simple escape
			Escape()
			Return
		Endif
		
		If Defeat.DAon
			If (RandomInt(1, 100) < McmConfig.DAsChance)
				RegisterForModEvent("da_StartRecoverSequence", "DARecoverSequence")
				Int DA = ModEvent.Create("da_ForceBlackout")
				ModEvent.PushString(DA, "ForceBlackout")
				ModEvent.PushString(DA, "None")
				ModEvent.PushFloat(DA, 1.0)
				ModEvent.PushForm(DA, Defeat.LastSceneTheLast)
				If ModEvent.Send(DA)
					RegisterForSingleUpdate(10.0)
					Return
				Endif
			Endif
		Endif

		String[] Events = New String[10]
		Int n = -1
		Int i

		; vv Check conditions vv
		DefeatConfig.Log("Outcome // Defeat.TheEvilFaction - "+Defeat.TheEvilFaction+" / Raped - "+Defeat.LastSceneRaped+" / Robbed - "+Defeat.LastSceneRobbed)
		; ^^ Check conditions ^^

		String EvilFaction = Defeat.TheEvilFaction
		If ((EvilFaction != "") && (EvilFaction != "Evil"))
			; Register faction events
			If (Defeat.TheEvilFaction == "Guard")
				If McmConfig.PAbEnabled[0] ; Jailed
					Faction CrimeFaction = Defeat.LastSceneTheLast.GetCrimeFaction()
					If CrimeFaction
						If ((CrimeFaction.GetCrimeGold() > 0) || (CrimeFaction.GetCrimeGoldViolent() > 0))
							CrimeFaction.SendPlayerToJail()
							PlayerScr.Restored()
							Defeat.DefeatPlayAnimation(Player, "Stand")
							Return
						Endif
					Endif
				Endif
			Elseif (EvilFaction == "Bandit")

			Elseif (EvilFaction == "Forsworn")

			Elseif (EvilFaction == "Silver Hand")

			Elseif (EvilFaction == "Thalmor")

			Elseif (EvilFaction == "Vampire")

			Elseif (EvilFaction == "Warlock")

			Elseif (EvilFaction == "Necromancer")

			Elseif (EvilFaction == "Bloodkin")

			Endif
		Endif

	;	If !ForbiddenLoc(Me.GetCurrentLocation())
		; Register misc events
		If (Chance(0) && OnlyEnemy(0, EvilFaction != "") && OnlyRaped(0, Defeat.LastSceneRaped)) && CheckCompatability("Left For Dead") ; LeftForDeadQST
			n += 1
			i = Events.Find("")
			Events[i] = "Left For Dead"
		Endif
		If (Chance(1) && OnlyEnemy(1, EvilFaction != "") && OnlyRaped(1, Defeat.LastSceneRaped)) && CheckCompatability("Defeated") ; DefeatedQST
			n += 1
			i = Events.Find("")
			Events[i] = "Defeated"
		Endif
		If (Defeat.SimpleSlaveryon && Chance(2) && OnlyEnemy(2, EvilFaction != "") && OnlyRaped(2, Defeat.LastSceneRaped)) && CheckCompatability("Simple Slavery") ; Simple slavery
			n += 1
			i = Events.Find("")
			Events[i] = "SSLV Entry"
		Endif

		if Defeat.SanguinesDebaucheryON && Chance(3) && CheckCompatability("SD+")
			if (StorageUtil.GetIntValue(Player, "_SD_iSanguineBlessings") > 0)  && (StorageUtil.GetIntValue(Player, "_SD_iEnslaved")==0)
				n += 1
				i = Events.Find("")
				Events[i] = "SDDreamworldPull"
			endif
		endif
		
		if Defeat.SanguinesDebaucheryON && Chance(4) && CheckCompatability("SD+")
			if !Defeat.LastSceneTheLast
				if Defeat.LastSceneAggressors.Length > 0
					int ListLength = Defeat.LastSceneAggressors.Length
					while ListLength > 0
						ListLength -= 1
						if Defeat.LastSceneAggressors[ListLength] && !Defeat.LastSceneAggressors[ListLength].IsDead()
							SelectedAggrressor = Defeat.LastSceneAggressors[ListLength]
							ListLength = 0
						endif
					endwhile
				endif
			else
				SelectedAggrressor = Defeat.LastSceneTheLast
			endif
			DefeatUtil2.SD_CheckIfSlaver(SelectedAggrressor)
			DefeatUtil2.SD_CheckIfSlaverCreature(SelectedAggrressor)
			DefeatConfig.Log("Sequence On: " + StorageUtil.GetIntValue(Player, "_SD_iEnslavementInitSequenceOn") + " is humanoid:  " + StorageUtil.GetIntValue( SelectedAggrressor, "_SD_bIsSlaverHumanoid"))
			if (Utility.RandomInt(1,100)<=StorageUtil.GetIntValue(Player, "_SD_iChanceEnslavement")) && (StorageUtil.GetIntValue(Player, "_SD_iEnslavementInitSequenceOn")!=1) && (StorageUtil.GetIntValue( SelectedAggrressor, "_SD_bIsSlaverHumanoid") == 1)
				n += 1
				i = Events.Find("")
				Events[i] = "PCSubEnslave"
			elseif (Utility.RandomInt(1,100)<=StorageUtil.GetIntValue(Player, "_SD_iChanceEnslavement")) && (StorageUtil.GetIntValue(Player, "_SD_iEnslavementInitSequenceOn")!=1) && (StorageUtil.GetIntValue( SelectedAggrressor, "_SD_bIsSlaverFalmer") == 1)
				n += 1
				i = Events.Find("")
				Events[i] = "PCSubEnslave"
			elseif (Utility.RandomInt(1,100)<=StorageUtil.GetIntValue(Player, "_SD_iChanceSprigganInfection")) && (StorageUtil.GetIntValue(Player, "_SD_iEnslavementInitSequenceOn")!=1) && (StorageUtil.GetIntValue( SelectedAggrressor, "_SD_bIsSpriggan") == 1)
				n += 1
				i = Events.Find("")
				Events[i] = "SDSprigganEnslave"
			elseif (Utility.RandomInt(1,100)<=StorageUtil.GetIntValue(Player, "_SD_iChanceEnslavement")) && (StorageUtil.GetIntValue(Player, "_SD_iEnslavementInitSequenceOn")!=1) && (StorageUtil.GetIntValue( SelectedAggrressor, "_SD_bIsSlaverCreature") == 1)
				n += 1
				i = Events.Find("")
				Events[i] = "PCSubEnslave"
			endif
		endif
		
		if Defeat.LeashGameON && Chance(5) && CheckCompatability("LeashGame - SimpleSlavery")
			if !Defeat.LastSceneTheLast
				if Defeat.LastSceneAggressors.Length > 0
					int ListLength = Defeat.LastSceneAggressors.Length
					while ListLength > 0
						ListLength -= 1
						if Defeat.LastSceneAggressors[ListLength] && !Defeat.LastSceneAggressors[ListLength].IsDead()
							SelectedAggrressor = Defeat.LastSceneAggressors[ListLength]
							ListLength = 0
						endif
					endwhile
				endif
			else
				SelectedAggrressor = Defeat.LastSceneTheLast
			endif
			n += 1
			i = Events.Find("")
			Events[i] = "LeashGame - SimpleSlavery"
		endif
		
		if Defeat.DeviouslyCursedLootON && Chance(6) && CheckCompatability("Cursed Loot Equip Devices")
			n += 1
			i = Events.Find("")
			Events[i] = "CursedLootEquipDevices"
		endif
		
		if Defeat.DDON && Chance(7) && CheckCompatability("Devious Devices Equip Devices")
			n += 1
			i = Events.Find("")
			Events[i] = "DDEquipDevices"
		endif
		
		DefeatConfig.Log("Events array // 1 - "+Events[0]+" / 2 - "+Events[1]+" / 3 - "+Events[2]+" / 4 - "+Events[3]+" / 5 - "+Events[4]+" / 6 - "+Events[5]+" / 7 - "+Events[6]+" / 8 - "+Events[7]+" / 9 - "+Events[8]+" / 10 - "+Events[9])
		If (n != -1) ; Nothing in the array to choose from
			TriggerEvent(Events, n, SelectedActor = SelectedAggrressor)
		Else
			Escape()
		Endif
	Elseif ((PlayerScr.ForcedScene == "Left For Dead")) ; Tamriel
		TriggerEvent(TheEvent = PostAssaultQsts[0])
	Elseif (PlayerScr.ForcedScene == "Defeated")
		TriggerEvent(TheEvent = PostAssaultQsts[1])
	Elseif (PlayerScr.ForcedScene == "End")
		Escape()
	Else
		TriggerEvent(ForceEvent = PlayerScr.ForcedScene)
	Endif
EndFunction
Function PickSecondEvent() ; Triggers a second event for events that allows it.
	String[] Events = New String[10]
	Int n = -1
	Int i
	String EvilFaction = Defeat.TheEvilFaction
	If ((EvilFaction != "") && (EvilFaction != "Evil"))
		If (EvilFaction == "Bandit")							; =============== Bandit

		Elseif (EvilFaction == "Forsworn")

		Elseif (EvilFaction == "Silver Hand")

		Elseif (EvilFaction == "Thalmor")

		Elseif (EvilFaction == "Vampire")

		Elseif (EvilFaction == "Warlock")

		Elseif (EvilFaction == "Necromancer")

		Elseif (EvilFaction == "Bloodkin")

		Endif
	Endif
	DefeatConfig.Log("Second Events array // 1 - "+Events[0]+" / 2 - "+Events[1]+" / 3 - "+Events[2]+" / 4 - "+Events[3]+" / 5 - "+Events[4]+" / 6 - "+Events[5]+" / 7 - "+Events[6]+" / 8 - "+Events[7]+" / 9 - "+Events[8]+" / 10 - "+Events[9])
	If (n != -1) ; Nothing in the array to choose from
		TriggerEvent(Events, n, Blackout = False, Restored = False)
	Endif
EndFunction
Function TriggerEvent(String[] Events = None, Int n = 0, String ForceEvent = "", Quest TheEvent = None, Bool Blackout = True, Bool Restored = True, Actor SelectedActor = None)
	Bool DoEvent = False
	If (!TheEvent && (ForceEvent == ""))
		Int Rand = RandomInt(0, n)
		If ((Events[Rand] == "Left For Dead") && PostAssaultQsts[0].Start())
			DefeatConfig.Log("Post assault / TriggerEvent chosen - Left For Dead")
			TheEvent = PostAssaultQsts[0]
			DoEvent = True
		Elseif ((Events[Rand] == "Defeated") && PostAssaultQsts[1].Start())
			DefeatConfig.Log("Post assault / TriggerEvent chosen - Defeated")
			TheEvent = PostAssaultQsts[1]
			DoEvent = True
		Elseif ((Events[Rand] != "Left For Dead") && (Events[Rand] != "Defeated"))
			CustomEvent = Events[Rand]
			DefeatConfig.Log("Post assault / TriggerEvent chosen - "+CustomEvent)
			DoEvent = True
		Endif
	Else
		If TheEvent
			If TheEvent.Start()
				PlayerScr.SetGetUpInRestored(False)
				DefeatConfig.Log("Post assault / TriggerEvent forced event - "+TheEvent.GetName())
				DoEvent = True
			Endif
		Else
			CustomEvent = ForceEvent
		Endif
	Endif
	If DoEvent
		If Blackout
			BlackOut()
		Endif
		If !Defeat.LastSceneRobbed
			Defeat.GetStrippedItems(Player)
		Endif
		If TheEvent
	  		PostRScr = (TheEvent As DefeatPostRscr)
			PostRScr.BeginQuest()
		Else
			Defeat.FadeIn()
			if CustomEvent == "PCSubEnslave"
				string str1 = SelectedActor.GetDisplayName()
				StorageUtil.SetIntValue(SelectedActor, "_SD_iForcedSlavery", 1)
				StorageUtil.SetIntValue(SelectedActor, "_SD_iSpeakingNPC", 1)
				SelectedActor.SendModEvent(CustomEvent)
				If Restored
					utility.wait(20)
					PlayerScr.Restored()
					SelectedActor.PushActorAway(Player, 1)
				Endif
				return
			elseif CustomEvent == "SDSprigganEnslave"
				SelectedActor.SendModEvent(CustomEvent)
				If Restored
					utility.wait(20)
					PlayerScr.Restored()
					SelectedActor.PushActorAway(Player, 1)
				Endif
				return
			elseif CustomEvent == "LeashGame - SimpleSlavery"
				Bool Continue = False
				Actor TempActor = StorageUtil.GetFormValue(none, "LeashFramework_CurrentMaster") as Actor
					if TempActor && !TempActor.IsDead() && TempActor.GetDistance(Player) < 3000
						SelectedActor = TempActor
						Continue = True
					else
						Actor TempActor2 = StorageUtil.GetFormValue(none, "LeashFramework_SavedMaster") as Actor
						if TempActor2 && !TempActor2.IsDead() && TempActor2.GetDistance(Player) < 3000
							SelectedActor = TempActor2
							Continue = True
						endif
					endif
				int iii = ModEvent.Create("Start_LeashGame_SimpleSlavery")
				ModEvent.PushForm(iii, SelectedActor as form)
				ModEvent.PushBool(iii, Continue)
				ModEvent.Send(iii)
				If Restored
					utility.wait(4)
					PlayerScr.Restored()
					SelectedActor.PushActorAway(Player, 1)
				Endif
				return
			elseif CustomEvent == "CursedLootEquipDevices"
				int NumberOfDevices = Utility.RandomInt(McmConfig.CursedLootMinDevices, McmConfig.CursedLootMaxDevices)
				Int DCUR_DeviceTheme = DefeatUtil2.DCUR_GetDeviceTheme()
				while NumberOfDevices > 0
					NumberOfDevices -= 1
					DefeatUtil2.DCUR_EquipRandomItem(Player, DCUR_DeviceTheme)
				endwhile
				Actor Follower = DefeatUtil2.GetCurrentFollower()
				if Follower && McmConfig.CursedLootFollowerSupport == True
					NumberOfDevices = Utility.RandomInt(McmConfig.CursedLootMinDevices, McmConfig.CursedLootMaxDevices)
					DCUR_DeviceTheme = DefeatUtil2.DCUR_GetDeviceTheme()
					while NumberOfDevices > 0
						NumberOfDevices -= 1
						DefeatUtil2.DCUR_EquipRandomItem(Follower, DCUR_DeviceTheme)
					endwhile
				endif
				Keyword TempDDKeywordHeavyBondage = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
				Keyword TempDDKeywordBoundCombatDisableKick = Game.GetFormFromFile(0x58391, "Devious Devices - Integration.esm") as Keyword ; BoundCombatDisableKick
				Int AggressorType = GetActorType(Defeat.LastSceneTheLast)
				if AggressorType == 0 ; human
					if  (Player.WornHasKeyword(TempDDKeywordHeavyBondage) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage)) && \
						(Player.WornHasKeyword(TempDDKeywordBoundCombatDisableKick) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBoundCombatDisableKick))
						if McmConfig.CursedLootTeleportationBoundChance >= Utility.RandomInt(0, 100)
							PostRScr = (PostAssaultQsts[0] As DefeatPostRscr)
							PostAssaultQsts[0].Start()
							Float PauseTicker = 5
							While (PostRScr.MiscAliasRefs.Length == 0) && PauseTicker >= 0
								PauseTicker -= 0.5
								Utility.Wait(0.5)
							endwhile
							PostRScr.BeginQuest()
							If Restored
								PlayerScr.Restored()
							Endif
							PauseTicker = 10
							While (UI.IsMenuOpen("Loading Menu") == True) && PauseTicker >= 0
								PauseTicker -= 1
								Utility.Wait(1)
							Endwhile
;							Player.PushActorAway(Player, 1)
							Debug.SendAnimationEvent(Player, "IdleForceDefaultState")
							return
						endif
					else
						if McmConfig.CursedLootTeleportationChance >= Utility.RandomInt(0, 100)
							PostRScr = (PostAssaultQsts[0] As DefeatPostRscr)
							PostAssaultQsts[0].Start()
							Float PauseTicker = 5
							While (PostRScr.MiscAliasRefs.Length == 0) && PauseTicker >= 0
								PauseTicker -= 0.5
								Utility.Wait(0.5)
							endwhile
							PostRScr.BeginQuest()
							If Restored
								PlayerScr.Restored()
							Endif
							PauseTicker = 10
							While (UI.IsMenuOpen("Loading Menu") == True) && PauseTicker >= 0
								PauseTicker -= 1
								Utility.Wait(1)
							Endwhile
;							Player.PushActorAway(Player, 1)
							Debug.SendAnimationEvent(Player, "IdleForceDefaultState")
							return
						endif
					endif
				else ; creature
					if  (Player.WornHasKeyword(TempDDKeywordHeavyBondage) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage)) && \
						(Player.WornHasKeyword(TempDDKeywordBoundCombatDisableKick) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBoundCombatDisableKick))
						if McmConfig.CursedLootTeleportationBoundChance >= Utility.RandomInt(0, 100)
							PostRScr = (PostAssaultQsts[1] As DefeatPostRscr)
							PostAssaultQsts[1].Start()
							Float PauseTicker = 5
							While (PostRScr.MiscAliasRefs.Length == 0) && PauseTicker >= 0
								PauseTicker -= 0.5
								Utility.Wait(0.5)
							endwhile
							PostRScr.BeginQuest()
							If Restored
								PlayerScr.Restored()
							Endif
							PauseTicker = 10
							While (UI.IsMenuOpen("Loading Menu") == True) && PauseTicker >= 0
								PauseTicker -= 1
								Utility.Wait(1)
							Endwhile
;							Player.PushActorAway(Player, 1)
							Debug.SendAnimationEvent(Player, "IdleForceDefaultState")
							return
						endif
					else
						if McmConfig.CursedLootTeleportationChance >= Utility.RandomInt(0, 100)
							PostRScr = (PostAssaultQsts[1] As DefeatPostRscr)
							PostAssaultQsts[1].Start()
							Float PauseTicker = 5
							While (PostRScr.MiscAliasRefs.Length == 0) && PauseTicker >= 0
								PauseTicker -= 0.5
								Utility.Wait(0.5)
							endwhile
							PostRScr.BeginQuest()
							If Restored
								PlayerScr.Restored()
							Endif
							PauseTicker = 10
							While (UI.IsMenuOpen("Loading Menu") == True) && PauseTicker >= 0
								PauseTicker -= 1
								Utility.Wait(1)
							Endwhile
;							Player.PushActorAway(Player, 1)
							Debug.SendAnimationEvent(Player, "IdleForceDefaultState")
							return
						endif
					endif
				endif
				
				Escape()
				return
			elseif CustomEvent == "DDEquipDevices"
				StorageUtil.StringListClear(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip")
				StorageUtil.StringListClear(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip")
				StorageUtil.FormListClear(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords")
				StorageUtil.StringListClear(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquip")
				StorageUtil.StringListClear(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquip")
				Keyword TempDDKeywordHeavyBondage = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
				Keyword TempDDKeywordGag = Game.GetFormFromFile(0x7EB8, "Devious Devices - Assets.esm") as Keyword ; Gag
				Keyword TempDDKeywordSuit = Game.GetFormFromFile(0x2AFA3, "Devious Devices - Assets.esm") as Keyword ; Suit
				Keyword TempDDKeywordHood = Game.GetFormFromFile(0x2AFA2, "Devious Devices - Assets.esm") as Keyword ; Hood
				Keyword TempDDKeywordBelt = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
				Keyword TempDDKeywordBra = Game.GetFormFromFile(0x3DFA, "Devious Devices - Assets.esm") as Keyword ; Bra
				Keyword TempDDKeywordHarness = Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword ; Harness
				Keyword TempDDKeywordCorset = Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword ; Corset
				Keyword TempDDKeywordCollar = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
				Keyword TempDDKeywordPlugVag = Game.GetFormFromFile(0x1DD7C, "Devious Devices - Assets.esm") as Keyword ; PlugVaginal
				Keyword TempDDKeywordPlugAnal = Game.GetFormFromFile(0x1DD7D, "Devious Devices - Assets.esm") as Keyword ; PlugAnal
				Keyword TempDDKeywordPiercingVag = Game.GetFormFromFile(0x23E70, "Devious Devices - Assets.esm") as Keyword ; PiercingVaginal
				Keyword TempDDKeywordPiercingNipp = Game.GetFormFromFile(0xCA39, "Devious Devices - Assets.esm") as Keyword ; PiercingNipple
				Keyword TempDDKeywordBoots = Game.GetFormFromFile(0x27F29, "Devious Devices - Assets.esm") as Keyword ; Boots
				Keyword TempDDKeywordGloves = Game.GetFormFromFile(0x2AFA1, "Devious Devices - Assets.esm") as Keyword ; Gloves
				Keyword TempDDKeywordArmCuffs = Game.GetFormFromFile(0x3DF9, "Devious Devices - Assets.esm") as Keyword ; ArmCuffs
				Keyword TempDDKeywordLegCuffs = Game.GetFormFromFile(0x3DF8, "Devious Devices - Assets.esm") as Keyword ; LegCuffs
				Keyword TempDDKeywordBoundCombatDisableKick = Game.GetFormFromFile(0x58391, "Devious Devices - Integration.esm") as Keyword ; BoundCombatDisableKick
				
				if !Player.WornHasKeyword(TempDDKeywordHeavyBondage) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage)
					if McmConfig.DDPaUseArmbinder == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Armbinder")
					elseif McmConfig.DDPaUseArmbinder == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Armbinder")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage, False)
				endif
				
				if !Player.WornHasKeyword(TempDDKeywordHeavyBondage) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage)
					if McmConfig.DDPaUseYoke == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Yoke")
					elseif McmConfig.DDPaUseYoke == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Yoke")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordGloves) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordGloves)
					if McmConfig.DDPaUseMittens == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Mittens")
					elseif McmConfig.DDPaUseMittens == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Mittens")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordGloves, False)
				endif
				
				if !Player.WornHasKeyword(TempDDKeywordHeavyBondage) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage)
					if McmConfig.DDPaUseElbowShackles == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "ElbowShackles")
					elseif McmConfig.DDPaUseElbowShackles == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "ElbowShackles")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage, False)
				endif
				
				if !Player.WornHasKeyword(TempDDKeywordGag) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordGag)
					if McmConfig.DDPaUseGag == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Gag")
					elseif McmConfig.DDPaUseGag == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Gag")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordGag, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordSuit) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordSuit)
					if McmConfig.DDPaUseSuit == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Suit")
					elseif McmConfig.DDPaUseSuit == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Suit")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordSuit, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordHood) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHood)
					if McmConfig.DDPaUseHood == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Hood")
					elseif McmConfig.DDPaUseHood == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Hood")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHood, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordBelt) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBelt)
					if McmConfig.DDPaUseChastityBelt == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Belt")
					elseif McmConfig.DDPaUseChastityBelt == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Belt")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBelt, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordBra) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBra)
					if McmConfig.DDPaUseChastityBra == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Bra")
					elseif McmConfig.DDPaUseChastityBra == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Bra")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBra, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordHarness) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHarness)
					if McmConfig.DDPaUseHarness == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Harness")
					elseif McmConfig.DDPaUseHarness == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Harness")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHarness, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordCorset) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordCorset)
					if McmConfig.DDPaUseCorset == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Corset")
					elseif McmConfig.DDPaUseCorset == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Corset")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordCorset, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordCollar) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordCollar)
					if McmConfig.DDPaUseCollar == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Collar")
					elseif McmConfig.DDPaUseCollar == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Collar")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordCollar, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordPlugVag) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordPlugVag)
					if McmConfig.DDPaUsePlugVaginal == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "PlugVaginal")
					elseif McmConfig.DDPaUsePlugVaginal == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "PlugVaginal")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordPlugVag, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordPlugAnal) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordPlugAnal)
					if McmConfig.DDPaUsePlugAnal == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "PlugAnal")
					elseif McmConfig.DDPaUsePlugAnal == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "PlugAnal")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordPlugAnal, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordPiercingVag) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordPiercingVag)
					if McmConfig.DDPaUsePiercingVaginal == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "PiercingVaginal")
					elseif McmConfig.DDPaUsePiercingVaginal == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "PiercingVaginal")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordPiercingVag, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordPiercingNipp) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordPiercingNipp)
					if McmConfig.DDPaUsePiercingNipple == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "PiercingNipple")
					elseif McmConfig.DDPaUsePiercingNipple == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "PiercingNipple")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordPiercingNipp, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordBoots) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBoots)
					if McmConfig.DDPaUseBoots == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Boots")
					elseif McmConfig.DDPaUseBoots == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Boots")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBoots, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordGloves) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordGloves)
					if McmConfig.DDPaUseGloves == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "Gloves")
					elseif McmConfig.DDPaUseGloves == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "Gloves")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordGloves, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordArmCuffs) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordArmCuffs)
					if McmConfig.DDPaUseArmCuffs == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "ArmCuffs")
					elseif McmConfig.DDPaUseArmCuffs == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "ArmCuffs")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordArmCuffs, False)
				endif
				if !Player.WornHasKeyword(TempDDKeywordLegCuffs) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordLegCuffs)
					if McmConfig.DDPaUseLegCuffs == 1
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "LegCuffs")
					elseif McmConfig.DDPaUseLegCuffs == 2
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "LegCuffs")
					endif
				else
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordLegCuffs, False)
				endif
				if McmConfig.DDPaArmAndLegShacklesChance > Utility.RandomInt(0, 100)
					if !Player.WornHasKeyword(TempDDKeywordHeavyBondage)
						if !Player.WornHasKeyword(TempDDKeywordLegCuffs) && !Player.WornHasKeyword(TempDDKeywordCollar)
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquip", "ArmLegShackles")
						elseif !Player.WornHasKeyword(TempDDKeywordLegCuffs)
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquip", "ArmShackles")
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquip", "LegShackles")
						endif
					endif
				endif
				if McmConfig.DDPaConsistantStyle
					BuildConsistantData()
				endif
				Int NumberOfDevicesEquipped = 0
				Int NumberOfDevicesTotal = Utility.RandomInt(McmConfig.DDMinDevices, McmConfig.DDMaxDevices)
				While StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquip") > 0
					if EquipPreferedDevice(StorageUtil.StringListPluck(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquip", 0, ""))
					endif
				endwhile
				PlayerScr.DefeatLog("[Defeat] - Always List: " + StorageUtil.StringListToArray(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip"))
				While StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip") > 0
					Int TempListIndex = Utility.RandomInt(0, StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip") - 1)
					if StorageUtil.StringListGet(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", TempListIndex) == "PlugVaginal" && McmConfig.DDPaPlugsWithBelt
						StorageUtil.StringListRemove(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "PlugVaginal")
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquip", "PlugVaginal")
					elseif StorageUtil.StringListGet(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", TempListIndex) == "PlugAnal" && McmConfig.DDPaPlugsWithBelt
						StorageUtil.StringListRemove(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", "PlugAnal")
						StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquip", "PlugAnal")
					else
						if EquipPreferedDevice(StorageUtil.StringListPluck(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquip", TempListIndex, ""))
							NumberOfDevicesEquipped += 1
						endif
					endif
				endwhile
				While NumberOfDevicesEquipped < NumberOfDevicesTotal
					if StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip") > 0
						Int TempListIndex = Utility.RandomInt(0, StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip") - 1)
						if StorageUtil.StringListGet(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", TempListIndex) == "PlugVaginal" && McmConfig.DDPaPlugsWithBelt
							StorageUtil.StringListRemove(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "PlugVaginal")
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquip", "PlugVaginal")
						elseif StorageUtil.StringListGet(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", TempListIndex) == "PlugAnal" && McmConfig.DDPaPlugsWithBelt
							StorageUtil.StringListRemove(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", "PlugAnal")
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquip", "PlugAnal")
						else
							if EquipPreferedDevice(StorageUtil.StringListPluck(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquip", TempListIndex, ""))
								NumberOfDevicesEquipped += 1
							else
							endif
						endif
					else
						NumberOfDevicesEquipped = NumberOfDevicesTotal
					endif
				endwhile
				While StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquip") > 0
					if EquipPreferedDevice(StorageUtil.StringListPluck(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquip", 0, ""))
					endif
				endwhile
				
				Actor Follower = DefeatUtil2.GetCurrentFollower()
				if Follower && McmConfig.DDPaFollowerSupport == True
					StorageUtil.StringListClear(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower")
					StorageUtil.StringListClear(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower")
					StorageUtil.FormListClear(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower")
					StorageUtil.StringListClear(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquipFollower")
					StorageUtil.StringListClear(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquipFollower")
					if !Follower.WornHasKeyword(TempDDKeywordHeavyBondage) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordHeavyBondage)
						if McmConfig.DDPaUseArmbinder == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Armbinder")
						elseif McmConfig.DDPaUseArmbinder == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Armbinder")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordHeavyBondage, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordGag) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordGag)
						if McmConfig.DDPaUseGag == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Gag")
						elseif McmConfig.DDPaUseGag == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Gag")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordGag, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordSuit) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordSuit)
						if McmConfig.DDPaUseSuit == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Suit")
						elseif McmConfig.DDPaUseSuit == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Suit")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordSuit, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordHood) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordHood)
						if McmConfig.DDPaUseHood == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Hood")
						elseif McmConfig.DDPaUseHood == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Hood")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordHood, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordBelt) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordBelt)
						if McmConfig.DDPaUseChastityBelt == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Belt")
						elseif McmConfig.DDPaUseChastityBelt == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Belt")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordBelt, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordBra) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordBra)
						if McmConfig.DDPaUseChastityBra == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Bra")
						elseif McmConfig.DDPaUseChastityBra == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Bra")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordBra, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordHarness) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordHarness)
						if McmConfig.DDPaUseHarness == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Harness")
						elseif McmConfig.DDPaUseHarness == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Harness")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordHarness, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordCorset) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordCorset)
						if McmConfig.DDPaUseCorset == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Corset")
						elseif McmConfig.DDPaUseCorset == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Corset")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordCorset, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordCollar) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordCollar)
						if McmConfig.DDPaUseCollar == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Collar")
						elseif McmConfig.DDPaUseCollar == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Collar")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordCollar, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordPlugVag) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordPlugVag)
						if McmConfig.DDPaUsePlugVaginal == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "PlugVaginal")
						elseif McmConfig.DDPaUsePlugVaginal == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "PlugVaginal")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordPlugVag, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordPlugAnal) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordPlugAnal)
						if McmConfig.DDPaUsePlugAnal == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "PlugAnal")
						elseif McmConfig.DDPaUsePlugAnal == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "PlugAnal")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordPlugAnal, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordPiercingVag) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordPiercingVag)
						if McmConfig.DDPaUsePiercingVaginal == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "PiercingVaginal")
						elseif McmConfig.DDPaUsePiercingVaginal == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "PiercingVaginal")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordPiercingVag, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordPiercingNipp) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordPiercingNipp)
						if McmConfig.DDPaUsePiercingNipple == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "PiercingNipple")
						elseif McmConfig.DDPaUsePiercingNipple == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "PiercingNipple")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordPiercingNipp, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordBoots) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordBoots)
						if McmConfig.DDPaUseBoots == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Boots")
						elseif McmConfig.DDPaUseBoots == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Boots")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordBoots, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordGloves) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordGloves)
						if McmConfig.DDPaUseGloves == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "Gloves")
						elseif McmConfig.DDPaUseGloves == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "Gloves")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordGloves, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordArmCuffs) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordArmCuffs)
						if McmConfig.DDPaUseArmCuffs == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "ArmCuffs")
						elseif McmConfig.DDPaUseArmCuffs == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "ArmCuffs")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordArmCuffs, False)
					endif
					if !Follower.WornHasKeyword(TempDDKeywordLegCuffs) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordLegCuffs)
						if McmConfig.DDPaUseLegCuffs == 1
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "LegCuffs")
						elseif McmConfig.DDPaUseLegCuffs == 2
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "LegCuffs")
						endif
					else
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeywordLegCuffs, False)
					endif
					if McmConfig.DDPaArmAndLegShacklesChance >= Utility.RandomInt(0, 100)
						if !Follower.WornHasKeyword(TempDDKeywordHeavyBondage)
							if !Follower.WornHasKeyword(TempDDKeywordLegCuffs) && !Follower.WornHasKeyword(TempDDKeywordCollar)
								StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquipFollower", "ArmLegShackles")
							elseif !Follower.WornHasKeyword(TempDDKeywordLegCuffs)
								StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquipFollower", "ArmShackles")
								StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquipFollower", "LegShackles")
							endif
						endif
					endif
					if McmConfig.DDPaConsistantStyle
						BuildConsistantDataFollower(Follower)
					endif
					NumberOfDevicesEquipped = 0
					NumberOfDevicesTotal = Utility.RandomInt(McmConfig.DDMinDevices, McmConfig.DDMaxDevices)
					PlayerScr.DefeatLog("[Defeat] - NumberOfDevicesTotal: " + NumberOfDevicesTotal)
					While StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquipFollower") > 0
						if EquipPreferedDeviceFollower(Follower, StorageUtil.StringListPluck(none, "Defeat_LRGPatch_PostAssault_TempData_ForceItemsToEquipFollower", 0, ""))
							PlayerScr.DefeatLog("[Defeat] - NumberOfDevicesEquipped: " + NumberOfDevicesEquipped)
						endif
					endwhile
					While StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower") > 0
						Int TempListIndex = Utility.RandomInt(0, StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower") - 1)
						if StorageUtil.StringListGet(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", TempListIndex) == "PlugVaginal" && McmConfig.DDPaPlugsWithBelt
							StorageUtil.StringListRemove(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "PlugVaginal")
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquipFollower", "PlugVaginal")
						elseif StorageUtil.StringListGet(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", TempListIndex) == "PlugAnal" && McmConfig.DDPaPlugsWithBelt
							StorageUtil.StringListRemove(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", "PlugAnal")
							StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquipFollower", "PlugAnal")
						else
							if EquipPreferedDeviceFollower(Follower, StorageUtil.StringListPluck(none, "Defeat_LRGPatch_PostAssault_TempData_AlwaysItemsToEquipFollower", TempListIndex, ""))
								NumberOfDevicesEquipped += 1
								PlayerScr.DefeatLog("[Defeat] - NumberOfDevicesEquipped: " + NumberOfDevicesEquipped)
							endif
						endif
					endwhile
					While NumberOfDevicesEquipped < NumberOfDevicesTotal
						if StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower") > 0
							Int TempListIndex = Utility.RandomInt(0, StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower") - 1)
							if StorageUtil.StringListGet(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", TempListIndex) == "PlugVaginal" && McmConfig.DDPaPlugsWithBelt
								StorageUtil.StringListRemove(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "PlugVaginal")
								StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquipFollower", "PlugVaginal")
							elseif StorageUtil.StringListGet(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", TempListIndex) == "PlugAnal" && McmConfig.DDPaPlugsWithBelt
								StorageUtil.StringListRemove(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", "PlugAnal")
								StorageUtil.StringListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquipFollower", "PlugAnal")
							else
								if EquipPreferedDeviceFollower(Follower, StorageUtil.StringListPluck(none, "Defeat_LRGPatch_PostAssault_TempData_RandomItemsToEquipFollower", TempListIndex, ""))
									NumberOfDevicesEquipped += 1
									PlayerScr.DefeatLog("[Defeat] - NumberOfDevicesEquipped: " + NumberOfDevicesEquipped)
								else
								endif
							endif
						else
							NumberOfDevicesEquipped = NumberOfDevicesTotal
						endif
					endwhile
					While StorageUtil.StringListCount(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquipFollower") > 0
						if EquipPreferedDeviceFollower(Follower, StorageUtil.StringListPluck(none, "Defeat_LRGPatch_PostAssault_TempData_PostItemsToEquipFollower", 0, ""))
							PlayerScr.DefeatLog("[Defeat] - NumberOfDevicesEquipped: " + NumberOfDevicesEquipped)
						endif
					endwhile
				endif
				Int AggressorType = GetActorType(Defeat.LastSceneTheLast)
				if AggressorType == 0 ; human
					if  (Player.WornHasKeyword(TempDDKeywordHeavyBondage) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage)) && \
						(Player.WornHasKeyword(TempDDKeywordBoundCombatDisableKick) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBoundCombatDisableKick))
						if McmConfig.DDPaTeleportationBoundChance >= Utility.RandomInt(0, 100)
							PostRScr = (PostAssaultQsts[0] As DefeatPostRscr)
							PostAssaultQsts[0].Start()
							Float PauseTicker = 5
							While (PostRScr.MiscAliasRefs.Length == 0) && PauseTicker >= 0
								PauseTicker -= 0.5
								Utility.Wait(0.5)
							endwhile
							PostRScr.BeginQuest()
							If Restored
								PlayerScr.Restored()
							Endif
							PauseTicker = 10
							While (UI.IsMenuOpen("Loading Menu") == True) && PauseTicker >= 0
								PauseTicker -= 1
								Utility.Wait(1)
							Endwhile
;							Player.PushActorAway(Player, 1)
							Debug.SendAnimationEvent(Player, "IdleForceDefaultState")
							return
						endif
					else
						if McmConfig.DDPaTeleportationChance >= Utility.RandomInt(0, 100)
							PostRScr = (PostAssaultQsts[0] As DefeatPostRscr)
							PostAssaultQsts[0].Start()
							Float PauseTicker = 5
							While (PostRScr.MiscAliasRefs.Length == 0) && PauseTicker >= 0
								PauseTicker -= 0.5
								Utility.Wait(0.5)
							endwhile
							PostRScr.BeginQuest()
							If Restored
								PlayerScr.Restored()
							Endif
							PauseTicker = 10
							While (UI.IsMenuOpen("Loading Menu") == True) && PauseTicker >= 0
								PauseTicker -= 1
								Utility.Wait(1)
							Endwhile
;							Player.PushActorAway(Player, 1)
							Debug.SendAnimationEvent(Player, "IdleForceDefaultState")
							return
						endif
					endif
				else ; creature
					if  (Player.WornHasKeyword(TempDDKeywordHeavyBondage) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordHeavyBondage)) && \
						(Player.WornHasKeyword(TempDDKeywordBoundCombatDisableKick) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeywordBoundCombatDisableKick))
						if McmConfig.DDPaTeleportationBoundChance >= Utility.RandomInt(0, 100)
							PostRScr = (PostAssaultQsts[1] As DefeatPostRscr)
							PostAssaultQsts[1].Start()
							Float PauseTicker = 5
							While (PostRScr.MiscAliasRefs.Length == 0) && PauseTicker >= 0
								PauseTicker -= 0.5
								Utility.Wait(0.5)
							endwhile
							PostRScr.BeginQuest()
							If Restored
								PlayerScr.Restored()
							Endif
							PauseTicker = 10
							While (UI.IsMenuOpen("Loading Menu") == True) && PauseTicker >= 0
								PauseTicker -= 1
								Utility.Wait(1)
							Endwhile
;							Player.PushActorAway(Player, 1)
							Debug.SendAnimationEvent(Player, "IdleForceDefaultState")
							return
						endif
					else
						if McmConfig.DDPaTeleportationChance >= Utility.RandomInt(0, 100)
							PostRScr = (PostAssaultQsts[1] As DefeatPostRscr)
							PostAssaultQsts[1].Start()
							Float PauseTicker = 5
							While (PostRScr.MiscAliasRefs.Length == 0) && PauseTicker >= 0
								PauseTicker -= 0.5
								Utility.Wait(0.5)
							endwhile
							PostRScr.BeginQuest()
							If Restored
								PlayerScr.Restored()
							Endif
							PauseTicker = 10
							While (UI.IsMenuOpen("Loading Menu") == True) && PauseTicker >= 0
								PauseTicker -= 1
								Utility.Wait(1)
							Endwhile
;							Player.PushActorAway(Player, 1)
							Debug.SendAnimationEvent(Player, "IdleForceDefaultState")
							return
						endif
					endif
				endif
				Escape()
				return
			endif
			SendModEvent(CustomEvent)
		Endif
		If Restored
			PlayerScr.Restored()
		Endif
	Elseif Blackout ; Make sure to not trigger escape for secondary events.
		DefeatConfig.Log("Post assault / No post assault events, trigger escape event")
		Escape()
	Endif
EndFunction

Bool Function ForbiddenLoc(Location TheLoc)
	If TheLoc
		Int n = TheLoc.GetNumKeywords()
		Int i
		While (i < n)
			If ForbiddenLocList.HasForm(TheLoc.GetNthKeyword(i))
				Return True
			Endif
			i += 1
		Endwhile
	Endif
	Return False
EndFunction

Bool Function Chance(Int Slot)
	Return (RandomInt(0, 100) < McmConfig.PAfrequency[Slot])
EndFunction
Bool Function OnlyEnemy(Int Slot, Bool IsEnemy)
	If !McmConfig.PAbOnlyEnemy[Slot]
		Return True
	Endif
	Return IsEnemy
EndFunction
Bool Function OnlyRaped(Int Slot, Bool BeenRaped)
	If !McmConfig.PAbOnlyRaped[Slot]
		Return True
	Endif
	Return BeenRaped
EndFunction
Bool Function OnlyEvil(Bool TheOption)
	Return (TheOption && (Defeat.TheEvilFaction == ""))
EndFunction
Bool Function OnlySecondary(Int Slot)
	Return McmConfig.PAbSecondary[Slot]
EndFunction

Function BlackOut()
	SendModEvent("DefeatPostAssault", "BlackOutBegin")
	Defeat.DefeatPlayAnimation(Player, "Lie")
;	Player.PushActorAway(Player, 0.1)
;	ISFadeOut.Apply()
	Defeat.FadeOut(3.0)
	Wait(3.0)
;	Wait(1)
;	FadeOutGame(True, True, 0, 3) ; Fade out
;	Wait(1)
;	FadeOutGame(False, True, 6, 3) ; Fade in
EndFunction
Event OnUpdate()
	If Player.HasKeywordString("DefeatActive")
		PlayerScr.Restored()
	Endif
EndEvent
Keyword Property ActorTypeNPC Auto
Faction Property FalmerFaction Auto
Faction Property CreatureFaction Auto

Bool Function CheckCompatability(string EventName)
	; Defeated
	; Left For Dead
	; Simple Slavery
	; SD+
	; LeashGame - SimpleSlavery
	PlayerScr.DefeatLog("[Defeat] - CheckCompatability for " + EventName)
	Faction ZbfSlaveStateFaction = None
	if Game.GetModByName("ZaZAnimationPack.esm") != 255
		ZbfSlaveStateFaction = (Game.GetFormFromFile(0x96b1, "ZaZAnimationPack.esm") As Faction)
	endif
	if EventName == "Defeated"
		if StorageUtil.GetIntValue(PLayer, "_SD_iEnslaved") == 1
			PlayerScr.DefeatLog("[Defeat] - Defeated not allowed(SD Enslaved)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_CurrentMaster")
			PlayerScr.DefeatLog("[Defeat] - Defeated not allowed(Leash Framework - Current Master)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_SavedMaster")
			PlayerScr.DefeatLog("[Defeat] - Defeated not allowed(Leash Framework - Saved Master)")
			return False
		elseif Defeat.Zazon == True
			if Player.GetFactionRank(ZbfSlaveStateFaction) >= 0
				PlayerScr.DefeatLog("[Defeat] - Defeated not allowed(ZBF Enslaved)")
				return False
			endif
		endif
	elseif EventName == "Left For Dead"
		if StorageUtil.GetIntValue(PLayer, "_SD_iEnslaved") == 1
			PlayerScr.DefeatLog("[Defeat] - Left For Dead not allowed(SD Enslaved)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_CurrentMaster")
			PlayerScr.DefeatLog("[Defeat] - Left For Dead not allowed(Leash Framework - Current Master)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_SavedMaster")
			PlayerScr.DefeatLog("[Defeat] - Left For Dead not allowed(Leash Framework - Saved Master)")
			return False
		elseif Defeat.Zazon == True
			if Player.GetFactionRank(ZbfSlaveStateFaction) >= 0
				PlayerScr.DefeatLog("[Defeat] - Left For Dead not allowed(ZBF Enslaved)")
				return False
			endif
		endif
	elseif EventName == "Simple Slavery"
		if StorageUtil.GetIntValue(PLayer, "_SD_iEnslaved") == 1
			PlayerScr.DefeatLog("[Defeat] - Simple Slavery not allowed(SD Enslaved)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_CurrentMaster")
			PlayerScr.DefeatLog("[Defeat] - Simple Slavery not allowed(Leash Framework - Current Master)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_SavedMaster")
			PlayerScr.DefeatLog("[Defeat] - Simple Slavery not allowed(Leash Framework - Saved Master)")
			return False
		elseif McmConfig.AllowCreaturePostAssaultSelection != 0
			if Defeat.LastSceneTheLast
				if Defeat.LastSceneTheLast.IsInFaction(CreatureFaction)
					if McmConfig.AllowCreaturePostAssaultSelection == 2
						PlayerScr.DefeatLog("[Defeat] - Simple Slavery not allowed(No Creatures)")
						return False
					elseif McmConfig.AllowCreaturePostAssaultSelection == 1 && !Defeat.LastSceneTheLast.IsInFaction(FalmerFaction)
						PlayerScr.DefeatLog("[Defeat] - Simple Slavery not allowed(Falmer Only)")
						return False
					endif
				endif
			endif
		elseif Defeat.Zazon == True
			if Player.GetFactionRank(ZbfSlaveStateFaction) >= 0
				PlayerScr.DefeatLog("[Defeat] - Simple Slavery not allowed(ZBF Enslaved)")
				return False
			endif
		endif
	elseif EventName == "SD+"
		if StorageUtil.GetFormValue(none, "LeashFramework_CurrentMaster")
			PlayerScr.DefeatLog("[Defeat] - SD+ not allowed(Leash Framework - Current Master)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_SavedMaster")
			PlayerScr.DefeatLog("[Defeat] - SD+ not allowed(Leash Framework - Saved Master)")
			return False
		endif
	elseif EventName == "LeashGame - SimpleSlavery"
		if StorageUtil.GetIntValue(PLayer, "_SD_iEnslaved") == 1
			PlayerScr.DefeatLog("[Defeat] - Leash Game - SimpleSlavery not allowed(SD Enslaved)")
			return False
		elseif McmConfig.AllowCreaturePostAssaultSelection != 0
			if Defeat.LastSceneTheLast
				if Defeat.LastSceneTheLast.IsInFaction(CreatureFaction)
					if McmConfig.AllowCreaturePostAssaultSelection == 2
						PlayerScr.DefeatLog("[Defeat] - Leash Game - SimpleSlavery not allowed(No Creatures)")
						return False
					elseif McmConfig.AllowCreaturePostAssaultSelection == 1 && !Defeat.LastSceneTheLast.IsInFaction(FalmerFaction)
						PlayerScr.DefeatLog("[Defeat] - Leash Game - SimpleSlavery not allowed(Falmer Only)")
						return False
					endif
				endif
			endif
		elseif Defeat.Zazon == True
			if Player.GetFactionRank(ZbfSlaveStateFaction) >= 0
				PlayerScr.DefeatLog("[Defeat] - Leash Game - SimpleSlavery not allowed(ZBF Enslaved)")
				return False
			endif
		endif
	elseif EventName == "Cursed Loot Equip Devices"
		if StorageUtil.GetIntValue(PLayer, "_SD_iEnslaved") == 1
			PlayerScr.DefeatLog("[Defeat] - Cursed Loot Equip Devices not allowed(SD Enslaved)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_CurrentMaster")
			PlayerScr.DefeatLog("[Defeat] - Cursed Loot Equip Devices not allowed(Leash Framework - Current Master)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_SavedMaster")
			PlayerScr.DefeatLog("[Defeat] - Cursed Loot Equip Devices not allowed(Leash Framework - Saved Master)")
			return False
		elseif McmConfig.AllowCreaturePostAssaultSelection != 0
			if Defeat.LastSceneTheLast
				if Defeat.LastSceneTheLast.IsInFaction(CreatureFaction)
					if McmConfig.AllowCreaturePostAssaultSelection == 2
						PlayerScr.DefeatLog("[Defeat] - Cursed Loot Equip Devices not allowed(No Creatures)")
						return False
					elseif McmConfig.AllowCreaturePostAssaultSelection == 1 && !Defeat.LastSceneTheLast.IsInFaction(FalmerFaction)
						PlayerScr.DefeatLog("[Defeat] - Cursed Loot Equip Devices not allowed(Falmer Only)")
						return False
					endif
				endif
			endif
		elseif Defeat.Zazon == True
			if Player.GetFactionRank(ZbfSlaveStateFaction) >= 0
				PlayerScr.DefeatLog("[Defeat] - Cursed Loot Equip Devices not allowed(ZBF Enslaved)")
				return False
			endif
		endif
	elseif EventName == "Devious Devices Equip Devices"
		if StorageUtil.GetIntValue(PLayer, "_SD_iEnslaved") == 1
			PlayerScr.DefeatLog("[Defeat] - Devious Devices Equip Devices not allowed(SD Enslaved)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_CurrentMaster")
			PlayerScr.DefeatLog("[Defeat] - Devious Devices Equip Devices not allowed(Leash Framework - Current Master)")
			return False
		elseif StorageUtil.GetFormValue(none, "LeashFramework_SavedMaster")
			PlayerScr.DefeatLog("[Defeat] - Devious Devices Equip Devices not allowed(Leash Framework - Saved Master)")
			return False
		elseif McmConfig.AllowCreaturePostAssaultSelection != 0
			if Defeat.LastSceneTheLast
				if Defeat.LastSceneTheLast.IsInFaction(CreatureFaction)
					if McmConfig.AllowCreaturePostAssaultSelection == 2
						PlayerScr.DefeatLog("[Defeat] - Devious Devices Equip Devices not allowed(No Creatures)")
						return False
					elseif McmConfig.AllowCreaturePostAssaultSelection == 1 && !Defeat.LastSceneTheLast.IsInFaction(FalmerFaction)
						PlayerScr.DefeatLog("[Defeat] - Devious Devices Equip Devices not allowed(Falmer Only)")
						return False
					endif
				endif
			endif
		elseif Defeat.Zazon == True
			if Player.GetFactionRank(ZbfSlaveStateFaction) >= 0
				PlayerScr.DefeatLog("[Defeat] - Devious Devices Equip Devices not allowed(ZBF Enslaved)")
				return False
			endif
		endif
	endif
	PlayerScr.DefeatLog("[Defeat] - " + EventName + " Allowed")
	return True
EndFunction

bool Function EquipPreferedDevice(String DeviceName)
	PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceName: " + DeviceName)
	String DeviceStyle
	String DeviceColour
	if DeviceName == "Armbinder"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaArmbinderStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaArmbinderStyle
			endif
			if McmConfig.DDPaArmbinderColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Armbinder", DeviceStyle, McmConfig.DDPaArmbinderColour)
					DeviceColour = McmConfig.DDPaArmbinderColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			Armor DeviceInventory = DefeatUtil2.GetDDArmbinder(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Yoke"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x2AFA3, "Devious Devices - Assets.esm") as Keyword ; Suit
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if !Player.WornHasKeyword(TempDDKeyword2) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2)
				; Not wearing Suit. Can use all Yokes, includind Breast Yoke. (Breas Yoke has Suit keyword)
				if McmConfig.DDPaYokeStyle == "Any"
					if McmConfig.DDPaConsistantStyle
						if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
							DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke")
							DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke", Utility.RandomInt(1, TempInt - 1))
						endif
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					DeviceStyle = McmConfig.DDPaYokeStyle
				endif
				if McmConfig.DDPaYokeColour == "Any"
					if McmConfig.DDPaConsistantStyle
						if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
							DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle)
							DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
						endif
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					if McmConfig.StyleHasColour("NoBreast", DeviceStyle, McmConfig.DDPaYokeColour)
						DeviceColour = McmConfig.DDPaYokeColour
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				endif
			else
				; wearing Suit. Can use Yokes without Breasts. (Breas Yoke has Suit keyword)
				if McmConfig.DDPaYokeStyle == "Any"
					if McmConfig.DDPaConsistantStyle
						if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
							DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast")
							DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast", Utility.RandomInt(1, TempInt - 1))
						endif
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					DeviceStyle = McmConfig.DDPaYokeStyle
				endif
				if McmConfig.DDPaYokeColour == "Any"
					if McmConfig.DDPaConsistantStyle
						if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
							DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle)
							DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
						endif
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					if McmConfig.StyleHasColour("YokeNoBreast", DeviceStyle, McmConfig.DDPaYokeColour)
						DeviceColour = McmConfig.DDPaYokeColour
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				endif
			endif
			Armor DeviceInventory = DefeatUtil2.GetDDYoke(DeviceStyle, DeviceColour)
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if ((DeviceRendered.HasKeyword(TempDDKeyword2) && !Player.WornHasKeyword(TempDDKeyword2)) || !DeviceRendered.HasKeyword(TempDDKeyword2))
				StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(Player, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
				if DeviceRendered.HasKeyword(TempDDKeyword2)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2)
				endif
				return True
			endif
		endif
	elseif DeviceName == "Mittens"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x2AFA1, "Devious Devices - Assets.esm") as Keyword ; Gloves
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaMittensStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						if StorageUtil.StringListCount(none, "Defeat_LRGPatch_ConsistentMatch_" + StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
							String MatchedStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_ConsistentMatch_" + StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"), 0)
							if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", MatchedStyle)
								DeviceStyle = MatchedStyle
							else
								Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens")
								DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", Utility.RandomInt(1, TempInt - 1))
							endif
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens")
							DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", Utility.RandomInt(1, TempInt - 1))
						endif
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaMittensStyle
			endif
			if McmConfig.DDPaMittensColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Mittens", DeviceStyle, McmConfig.DDPaMittensColour)
					DeviceColour = McmConfig.DDPaMittensColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			Armor DeviceInventory = DefeatUtil2.GetDDMittens(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "ElbowShackles"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaElbowShacklesStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaElbowShacklesStyle
			endif
			if McmConfig.DDPaElbowShacklesColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("ElbowShackles", DeviceStyle, McmConfig.DDPaYokeColour)
					DeviceColour = McmConfig.DDPaElbowShacklesColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			Armor DeviceInventory
			if StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2) ; Player has Collar
				DeviceInventory = DefeatUtil2.GetDDElbowShackles("", "", ForceInt = 0)
			else
				DeviceInventory = DefeatUtil2.GetDDElbowShackles("", "", ForceInt = Utility.RandomInt(1, 2))
			endif
			;we cant wear both harness or corset (same slot). Adding both keywords
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if ((DeviceRendered.HasKeyword(TempDDKeyword2) && !Player.WornHasKeyword(TempDDKeyword2)) || !DeviceRendered.HasKeyword(TempDDKeyword2))
				StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(Player, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
				if DeviceRendered.HasKeyword(TempDDKeyword2)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2)
				endif
				return True
			endif
		endif
	elseif DeviceName == "Gag"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x7EB8, "Devious Devices - Assets.esm") as Keyword ; Gag
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaGagStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaGagStyle
			endif
			if McmConfig.DDPaGagColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Gag", DeviceStyle, McmConfig.DDPaGagColour)
					DeviceColour = McmConfig.DDPaGagColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDGag(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Suit"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x2AFA3, "Devious Devices - Assets.esm") as Keyword ; Suit
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword3 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		Keyword TempDDKeyword4 = Game.GetFormFromFile(0x58391, "Devious Devices - Integration.esm") as Keyword ; BoundCombatDisableKick
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaSuitStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaSuitStyle
			endif
			if McmConfig.DDPaSuitColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Suit", DeviceStyle, McmConfig.DDPaSuitColour)
					DeviceColour = McmConfig.DDPaSuitColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDSuit(DeviceStyle, DeviceColour)
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if  ((DeviceRendered.HasKeyword(TempDDKeyword2) && !Player.WornHasKeyword(TempDDKeyword2) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2)) || !DeviceRendered.HasKeyword(TempDDKeyword2)) && \
				((DeviceRendered.HasKeyword(TempDDKeyword3) && !Player.WornHasKeyword(TempDDKeyword3) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword3)) || !DeviceRendered.HasKeyword(TempDDKeyword3))
				StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(Player, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", Game.GetFormFromFile(0x2AFA3, "Devious Devices - Assets.esm") as Keyword)
				if DeviceRendered.HasKeyword(Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword)
				endif
				if DeviceRendered.HasKeyword(TempDDKeyword4)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword4)
				endif
				return True
			endif
		endif
	elseif DeviceName == "Hood"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x2AFA2, "Devious Devices - Assets.esm") as Keyword ; Hood
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaHoodStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaHoodStyle
			endif
			if McmConfig.DDPaHoodColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Hood", DeviceStyle, McmConfig.DDPaHoodColour)
					DeviceColour = McmConfig.DDPaHoodColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDHood(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Belt"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaChastityBeltStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaChastityBeltStyle
			endif
			DeviceStyle = "Any"
			if McmConfig.DDPaChastityBeltColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Belt", DeviceStyle, McmConfig.DDPaChastityBeltColour)
					DeviceColour = McmConfig.DDPaChastityBeltColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDChastityBelt(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Bra"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DFA, "Devious Devices - Assets.esm") as Keyword ; Bra
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaChastityBraStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaChastityBraStyle
			endif
			if McmConfig.DDPaChastityBraColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Bra", DeviceStyle, McmConfig.DDPaChastityBraColour)
					DeviceColour = McmConfig.DDPaChastityBraColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDChastityBra(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Harness"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword ; Harness
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword ; Corset
		Keyword TempDDKeyword3 = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		Keyword TempDDKeyword4 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if  !Player.WornHasKeyword(TempDDKeyword) && !Player.WornHasKeyword(TempDDKeyword2) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2)
			if McmConfig.DDPaHarnessStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaHarnessStyle
			endif
			if McmConfig.DDPaHarnessColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Harness", DeviceStyle, McmConfig.DDPaHarnessColour)
					DeviceColour = McmConfig.DDPaHarnessColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			if StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword4)
				if StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword)
					DeviceInventory = DefeatUtil2.GetDDHarnessNoBeltNoCollar(DeviceStyle, DeviceColour)
				else
					DeviceInventory = DefeatUtil2.GetDDHarnessNoBelt(DeviceStyle, DeviceColour)
				endif
			elseif StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword)
				DeviceInventory = DefeatUtil2.GetDDHarnessNoCollar(DeviceStyle, DeviceColour)
			else
				DeviceInventory = DefeatUtil2.GetDDHarness(DeviceStyle, DeviceColour)
			endif
			;we cant wear both harness or corset (same slot). Adding both keywords
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if  ((DeviceRendered.HasKeyword(TempDDKeyword3) && !Player.WornHasKeyword(TempDDKeyword3)) || !DeviceRendered.HasKeyword(TempDDKeyword3)) && \
				((DeviceRendered.HasKeyword(TempDDKeyword4) && !Player.WornHasKeyword(TempDDKeyword4)) || !DeviceRendered.HasKeyword(TempDDKeyword4))
				StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(Player, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword) ; harness
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword) ; corset
				if DeviceRendered.HasKeyword(TempDDKeyword4)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword4)
				endif
				if DeviceRendered.HasKeyword(Game.GetFormFromFile(0x3DF7, "Devious Devices - Integration.esm") as Keyword)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", Game.GetFormFromFile(0x3DF7, "Devious Devices - Integration.esm") as Keyword)
				endif
				return True
			endif
		endif
	elseif DeviceName == "Corset"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword ; Harness
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword ; Corset
		Keyword TempDDKeyword3 = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		Keyword TempDDKeyword4 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if  !Player.WornHasKeyword(TempDDKeyword) && !Player.WornHasKeyword(TempDDKeyword2) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2)
			if McmConfig.DDPaCorsetStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaCorsetStyle
			endif
			if McmConfig.DDPaCorsetColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Corset", DeviceStyle, McmConfig.DDPaCorsetColour)
					DeviceColour = McmConfig.DDPaCorsetColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			if StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword4)
				DeviceInventory = DefeatUtil2.GetDDCorsetNoBelt(DeviceStyle, DeviceColour)
			else
				DeviceInventory = DefeatUtil2.GetDDCorset(DeviceStyle, DeviceColour)
			endif
			;we cant wear both harness or corset (same slot). Adding both keywords
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if  ((DeviceRendered.HasKeyword(TempDDKeyword3) && !Player.WornHasKeyword(TempDDKeyword3)) || !DeviceRendered.HasKeyword(TempDDKeyword3)) && \
				((DeviceRendered.HasKeyword(TempDDKeyword4) && !Player.WornHasKeyword(TempDDKeyword4)) || !DeviceRendered.HasKeyword(TempDDKeyword4))
				StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(Player, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword) ; corset
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword) ; harness
				if DeviceRendered.HasKeyword(TempDDKeyword4)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword4)
				endif
				return True
			endif
		endif
	elseif DeviceName == "Collar"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaCollarStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaCollarStyle
			endif
			if McmConfig.DDPaCollarColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Collar", DeviceStyle, McmConfig.DDPaCollarColour)
					DeviceColour = McmConfig.DDPaCollarColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDCollar(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; Collar
			return True
		endif
	elseif DeviceName == "PlugVaginal"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x1DD7C, "Devious Devices - Assets.esm") as Keyword ; PlugVaginal
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if  !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) && \
			(McmConfig.DDPaPlugsWithBelt == False || (McmConfig.DDPaPlugsWithBelt == True && (Player.WornHasKeyword(TempDDKeyword2) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2))))
			if McmConfig.DDPaPlugVaginalStyle == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PlugVaginal")
				DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PlugVaginal", Utility.RandomInt(1, TempInt - 1))
			else
				DeviceStyle = McmConfig.DDPaPlugVaginalStyle
			endif
			if McmConfig.DDPaPlugVaginalColour == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugVaginal_" + DeviceStyle)
				DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugVaginal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
			else
				if McmConfig.StyleHasColour("PlugVaginal", DeviceStyle, McmConfig.DDPaPlugVaginalColour)
					DeviceColour = McmConfig.DDPaPlugVaginalColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugVaginal_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugVaginal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDPlugVaginal(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; PlugVaginal
			return True
		endif
	elseif DeviceName == "PlugAnal"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x1DD7D, "Devious Devices - Assets.esm") as Keyword ; PlugAnal
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) && \
			(McmConfig.DDPaPlugsWithBelt == False || (McmConfig.DDPaPlugsWithBelt == True && (Player.WornHasKeyword(TempDDKeyword2) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2))))
			if McmConfig.DDPaPlugAnalStyle == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PlugAnal")
				DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PlugAnal", Utility.RandomInt(1, TempInt - 1))
			else
				DeviceStyle = McmConfig.DDPaPlugAnalStyle
			endif
			if McmConfig.DDPaPlugAnalColour == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugAnal_" + DeviceStyle)
				DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugAnal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
			else
				if McmConfig.StyleHasColour("PlugAnal", DeviceStyle, McmConfig.DDPaPlugAnalColour)
					DeviceColour = McmConfig.DDPaPlugAnalColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugAnal_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugAnal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDPlugAnal(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; PlugAnal
			return True
		endif
	elseif DeviceName == "PiercingVaginal"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x23E70, "Devious Devices - Assets.esm") as Keyword ; PiercingVaginal
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaPiercingVaginalStyle == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PiercingVaginal")
				DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PiercingVaginal", Utility.RandomInt(1, TempInt - 1))
			else
				DeviceStyle = McmConfig.DDPaPiercingVaginalStyle
			endif
			if McmConfig.DDPaPiercingVaginalColour == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingVaginal_" + DeviceStyle)
				DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingVaginal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
			else
				if McmConfig.StyleHasColour("PiercingVaginal", DeviceStyle, McmConfig.DDPaPiercingVaginalColour)
					DeviceColour = McmConfig.DDPaPiercingVaginalColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingVaginal_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingVaginal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDPiercingVaginal(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; PiercingVaginal
			return True
		endif
	elseif DeviceName == "PiercingNipple"
		Keyword TempDDKeyword = Game.GetFormFromFile(0xCA39, "Devious Devices - Assets.esm") as Keyword ; PiercingNipple
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaPiercingNippleStyle == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PiercingNipple")
				DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PiercingNipple", Utility.RandomInt(1, TempInt - 1))
			else
				DeviceStyle = McmConfig.DDPaPiercingNippleStyle
			endif
			if McmConfig.DDPaPiercingNippleColour == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingNipple_" + DeviceStyle)
				DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingNipple_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
			else
				if McmConfig.StyleHasColour("PiercingNipple", DeviceStyle, McmConfig.DDPaPiercingNippleColour)
					DeviceColour = McmConfig.DDPaPiercingNippleColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingNipple_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingNipple_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDPiercingNipple(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; PiercingNipple
			return True
		endif
	elseif DeviceName == "Boots"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x27F29, "Devious Devices - Assets.esm") as Keyword ; Boots
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaBootsStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaBootsStyle
			endif
			if McmConfig.DDPaBootsColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Boots", DeviceStyle, McmConfig.DDPaBootsColour)
					DeviceColour = McmConfig.DDPaBootsColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDBoots(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; Boots
			return True
		endif
	elseif DeviceName == "Gloves"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x2AFA1, "Devious Devices - Assets.esm") as Keyword ; Gloves
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaGlovesStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaGlovesStyle
			endif
			if McmConfig.DDPaGlovesColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Gloves", DeviceStyle, McmConfig.DDPaGlovesColour)
					DeviceColour = McmConfig.DDPaGlovesColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDGloves(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; Gloves
			return True
		endif
	elseif DeviceName == "ArmCuffs"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DF9, "Devious Devices - Assets.esm") as Keyword ; ArmCuffs
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaArmCuffsStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaArmCuffsStyle
			endif
			if McmConfig.DDPaArmCuffsColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("ArmCuffs", DeviceStyle, McmConfig.DDPaArmCuffsColour)
					DeviceColour = McmConfig.DDPaArmCuffsColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDArmCuffs(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; ArmCuffs
			return True
		endif
	elseif DeviceName == "LegCuffs"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DF8, "Devious Devices - Assets.esm") as Keyword ; LegCuffs
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			if McmConfig.DDPaLegCuffsStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaLegCuffsStyle
			endif
			if McmConfig.DDPaLegCuffsColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("LegCuffs", DeviceStyle, McmConfig.DDPaLegCuffsColour)
					DeviceColour = McmConfig.DDPaLegCuffsColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDLegCuffs(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; LegCuffs
			return True
		endif
	elseif DeviceName == "ArmShackles"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x63AD9, "Devious Devices - Assets.esm") as Keyword ; CuffsFront
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			DeviceStyle = "Iron"
			DeviceColour = ""
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDArmShackles(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; ArmShackles
			return True
		endif
	elseif DeviceName == "LegShackles"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DF8, "Devious Devices - Assets.esm") as Keyword ; LegCuffs
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x5F4BB, "Devious Devices - Integration.esm") as Keyword ; AnkleShackles
		Keyword TempDDKeyword3 = Game.GetFormFromFile(0x58391, "Devious Devices - Integration.esm") as Keyword ; BoundCombatDisableKick
		if !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
			DeviceStyle = "NoBall"
			DeviceColour = ""
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDLegShackles(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(Player, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; LegCuffs
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword3) ; LegCuffs
			return True
		endif
	elseif DeviceName == "ArmLegShackles"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x3DF8, "Devious Devices - Assets.esm") as Keyword ; LegCuffs
		Keyword TempDDKeyword3 = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		Keyword TempDDKeyword4 = Game.GetFormFromFile(0x3DF9, "Devious Devices - Assets.esm") as Keyword ; ArmCuffs
		Keyword TempDDKeyword5 = Game.GetFormFromFile(0x58391, "Devious Devices - Integration.esm") as Keyword ; BoundCombatDisableKick
		if  !Player.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword)
				DeviceStyle = "Iron"
				DeviceColour = ""
				PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
				Armor DeviceInventory
				DeviceInventory = DefeatUtil2.GetDDArmLegShackles(DeviceStyle, DeviceColour)
				Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
				if  ((DeviceRendered.HasKeyword(TempDDKeyword2) && !Player.WornHasKeyword(TempDDKeyword2)) || !DeviceRendered.HasKeyword(TempDDKeyword2)) && \
					((DeviceRendered.HasKeyword(TempDDKeyword3) && !Player.WornHasKeyword(TempDDKeyword3)) || !DeviceRendered.HasKeyword(TempDDKeyword3)) && \
					((DeviceRendered.HasKeyword(TempDDKeyword4) && !Player.WornHasKeyword(TempDDKeyword4)) || !DeviceRendered.HasKeyword(TempDDKeyword4))
						StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
						DefeatUtil2.LockDevice(Player, DeviceInventory)
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword) ; HeavyBondage
						if DeviceRendered.HasKeyword(TempDDKeyword2)
							StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword2)
						endif
						if DeviceRendered.HasKeyword(TempDDKeyword3)
							StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword3)
						endif
						if DeviceRendered.HasKeyword(TempDDKeyword4)
							StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword4)
						endif
						if DeviceRendered.HasKeyword(TempDDKeyword5)
							StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywords", TempDDKeyword5)
						endif
						return True
				endif
		endif
	endif
	return False
EndFunction

bool Function EquipPreferedDeviceFollower(Actor TargetActor, String DeviceName)
	PlayerScr.DefeatLog("[Defeat] - EquipPreferedDeviceFollower - TargetActor: " + TargetActor.GetDisplayName() + " DeviceName: " + DeviceName)
	String DeviceStyle
	String DeviceColour
	if DeviceName == "Armbinder"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaArmbinderStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Armbinder", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaArmbinderStyle
			endif
			if McmConfig.DDPaArmbinderColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Armbinder", DeviceStyle, McmConfig.DDPaArmbinderColour)
					DeviceColour = McmConfig.DDPaArmbinderColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Armbinder_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			Armor DeviceInventory = DefeatUtil2.GetDDArmbinder(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(TargetActor, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Yoke"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x2AFA3, "Devious Devices - Assets.esm") as Keyword ; Suit
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if !TargetActor.WornHasKeyword(TempDDKeyword2) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2)
				; Not wearing Suit. Can use all Yokes, includind Breast Yoke. (Breas Yoke has Suit keyword)
				if McmConfig.DDPaYokeStyle == "Any"
					if McmConfig.DDPaConsistantStyle
						if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
							DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke")
							DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke", Utility.RandomInt(1, TempInt - 1))
						endif
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Yoke", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					DeviceStyle = McmConfig.DDPaYokeStyle
				endif
				if McmConfig.DDPaYokeColour == "Any"
					if McmConfig.DDPaConsistantStyle
						if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
							DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle)
							DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
						endif
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					if McmConfig.StyleHasColour("Yoke", DeviceStyle, McmConfig.DDPaYokeColour)
						DeviceColour = McmConfig.DDPaYokeColour
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Yoke_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				endif
			else
				; wearing Suit. Can use Yokes without Breasts. (Breas Yoke has Suit keyword)
				if McmConfig.DDPaYokeStyle == "Any"
					if McmConfig.DDPaConsistantStyle
						if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
							DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast")
							DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast", Utility.RandomInt(1, TempInt - 1))
						endif
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "YokeNoBreast", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					DeviceStyle = McmConfig.DDPaYokeStyle
				endif
				if McmConfig.DDPaYokeColour == "Any"
					if McmConfig.DDPaConsistantStyle
						if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
							DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle)
							DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
						endif
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					if McmConfig.StyleHasColour("Yoke", DeviceStyle, McmConfig.DDPaYokeColour)
						DeviceColour = McmConfig.DDPaYokeColour
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "YokeNoBreast_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				endif
			endif
			Armor DeviceInventory = DefeatUtil2.GetDDYoke(DeviceStyle, DeviceColour)
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if ((DeviceRendered.HasKeyword(TempDDKeyword2) && !TargetActor.WornHasKeyword(TempDDKeyword2)) || !DeviceRendered.HasKeyword(TempDDKeyword2))
				StorageUtil.FormListAdd(TargetActor, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
				if DeviceRendered.HasKeyword(TempDDKeyword2)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2)
				endif
				return True
			endif
			return True
		endif
	elseif DeviceName == "Mittens"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x2AFA1, "Devious Devices - Assets.esm") as Keyword ; Gloves
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaMittensStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						if StorageUtil.StringListCount(none, "Defeat_LRGPatch_ConsistentMatch_" + StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
							String MatchedStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_ConsistentMatch_" + StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"), 0)
							if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", MatchedStyle)
								DeviceStyle = MatchedStyle
							else
								Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens")
								DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", Utility.RandomInt(1, TempInt - 1))
							endif
						else
							Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens")
							DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", Utility.RandomInt(1, TempInt - 1))
						endif
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Mittens", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaMittensStyle
			endif
			if McmConfig.DDPaMittensColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Mittens", DeviceStyle, McmConfig.DDPaMittensColour)
					DeviceColour = McmConfig.DDPaMittensColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Mittens_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			Armor DeviceInventory = DefeatUtil2.GetDDMittens(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(TargetActor, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "ElbowShackles"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaElbowShacklesStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ElbowShackles", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaElbowShacklesStyle
			endif
			if McmConfig.DDPaElbowShacklesColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("ElbowShackles", DeviceStyle, McmConfig.DDPaYokeColour)
					DeviceColour = McmConfig.DDPaElbowShacklesColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ElbowShackles_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			Armor DeviceInventory
			if StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2) ; TargetActor has Collar
				DeviceInventory = DefeatUtil2.GetDDElbowShackles("", "", ForceInt = 0)
			else
				DeviceInventory = DefeatUtil2.GetDDElbowShackles("", "", ForceInt = Utility.RandomInt(1, 2))
			endif
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if ((DeviceRendered.HasKeyword(TempDDKeyword2) && !TargetActor.WornHasKeyword(TempDDKeyword2)) || !DeviceRendered.HasKeyword(TempDDKeyword2))
				StorageUtil.FormListAdd(TargetActor, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
				if DeviceRendered.HasKeyword(TempDDKeyword2)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2)
				endif
				return True
			endif
		endif
	elseif DeviceName == "Gag"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x7EB8, "Devious Devices - Assets.esm") as Keyword ; Gag
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaGagStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gag", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaGagStyle
			endif
			if McmConfig.DDPaGagColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Gag", DeviceStyle, McmConfig.DDPaGagColour)
					DeviceColour = McmConfig.DDPaGagColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gag_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDGag(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(TargetActor, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Suit"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x2AFA3, "Devious Devices - Assets.esm") as Keyword ; Suit
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword3 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaSuitStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Suit", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaSuitStyle
			endif
			if McmConfig.DDPaSuitColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Suit", DeviceStyle, McmConfig.DDPaSuitColour)
					DeviceColour = McmConfig.DDPaSuitColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Suit_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDSuit(DeviceStyle, DeviceColour)
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if  ((DeviceRendered.HasKeyword(TempDDKeyword2) && !TargetActor.WornHasKeyword(TempDDKeyword2) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2)) || !DeviceRendered.HasKeyword(TempDDKeyword2)) && \
				((DeviceRendered.HasKeyword(TempDDKeyword3) && !TargetActor.WornHasKeyword(TempDDKeyword3) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword3)) || !DeviceRendered.HasKeyword(TempDDKeyword3))
				StorageUtil.FormListAdd(TargetActor, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", Game.GetFormFromFile(0x2AFA3, "Devious Devices - Assets.esm") as Keyword)
				if DeviceRendered.HasKeyword(Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword)
				endif
				return True
			endif
		endif
	elseif DeviceName == "Hood"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x2AFA2, "Devious Devices - Assets.esm") as Keyword ; Hood
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaHoodStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Hood", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaHoodStyle
			endif
			if McmConfig.DDPaHoodColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Hood", DeviceStyle, McmConfig.DDPaHoodColour)
					DeviceColour = McmConfig.DDPaHoodColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Hood_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDHood(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Belt"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaChastityBeltStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Belt", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Belt", DeviceStyle, McmConfig.DDPaChastityBeltColour)
					DeviceColour = McmConfig.DDPaChastityBeltColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			DeviceStyle = "Any"
			if McmConfig.DDPaChastityBeltColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Belt_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceColour = McmConfig.DDPaChastityBeltColour
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDChastityBelt(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Bra"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DFA, "Devious Devices - Assets.esm") as Keyword ; Bra
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaChastityBraStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Bra", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Bra", DeviceStyle, McmConfig.DDPaChastityBraColour)
					DeviceColour = McmConfig.DDPaChastityBraColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			if McmConfig.DDPaChastityBraColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Bra_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceColour = McmConfig.DDPaChastityBraColour
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory = DefeatUtil2.GetDDChastityBra(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			return True
		endif
	elseif DeviceName == "Harness"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword ; Harness
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword ; Corset
		Keyword TempDDKeyword3 = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		Keyword TempDDKeyword4 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if  !TargetActor.WornHasKeyword(TempDDKeyword) && !TargetActor.WornHasKeyword(TempDDKeyword2) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2)
			if McmConfig.DDPaHarnessStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Harness", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaHarnessStyle
			endif
			if McmConfig.DDPaHarnessColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Harness", DeviceStyle, McmConfig.DDPaHarnessColour)
					DeviceColour = McmConfig.DDPaHarnessColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Harness_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			if StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword4)
				if StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", Game.GetFormFromFile(0x3DF7, "Devious Devices - Integration.esm") as Keyword)
					DeviceInventory = DefeatUtil2.GetDDHarnessNoBeltNoCollar(DeviceStyle, DeviceColour)
				else
					DeviceInventory = DefeatUtil2.GetDDHarnessNoBelt(DeviceStyle, DeviceColour)
				endif
			elseif StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", Game.GetFormFromFile(0x3DF7, "Devious Devices - Integration.esm") as Keyword)
				DeviceInventory = DefeatUtil2.GetDDHarnessNoCollar(DeviceStyle, DeviceColour)
			else
				DeviceInventory = DefeatUtil2.GetDDHarness(DeviceStyle, DeviceColour)
			endif
			;we cant wear both harness or corset (same slot). Adding both keywords
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if  ((DeviceRendered.HasKeyword(TempDDKeyword3) && !TargetActor.WornHasKeyword(TempDDKeyword3)) || !DeviceRendered.HasKeyword(TempDDKeyword3)) && \
				((DeviceRendered.HasKeyword(TempDDKeyword4) && !TargetActor.WornHasKeyword(TempDDKeyword4)) || !DeviceRendered.HasKeyword(TempDDKeyword4))
				StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword) ; harness
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword) ; corset
				if DeviceRendered.HasKeyword(TempDDKeyword4)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword4)
				endif
				if DeviceRendered.HasKeyword(Game.GetFormFromFile(0x3DF7, "Devious Devices - Integration.esm") as Keyword)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", Game.GetFormFromFile(0x3DF7, "Devious Devices - Integration.esm") as Keyword)
				endif
				return True
			endif
		endif
	elseif DeviceName == "Corset"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword ; Harness
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword ; Corset
		Keyword TempDDKeyword3 = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		Keyword TempDDKeyword4 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if  !TargetActor.WornHasKeyword(TempDDKeyword) && !TargetActor.WornHasKeyword(TempDDKeyword2) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2)
			if McmConfig.DDPaCorsetStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Corset", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaCorsetStyle
			endif
			if McmConfig.DDPaCorsetColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Corset", DeviceStyle, McmConfig.DDPaCorsetColour)
					DeviceColour = McmConfig.DDPaCorsetColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Corset_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			if StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword4)
				DeviceInventory = DefeatUtil2.GetDDCorsetNoBelt(DeviceStyle, DeviceColour)
			else
				DeviceInventory = DefeatUtil2.GetDDCorset(DeviceStyle, DeviceColour)
			endif
			;we cant wear both harness or corset (same slot). Adding both keywords
			Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
			if  ((DeviceRendered.HasKeyword(TempDDKeyword3) && !TargetActor.WornHasKeyword(TempDDKeyword3)) || !DeviceRendered.HasKeyword(TempDDKeyword3)) && \
				((DeviceRendered.HasKeyword(TempDDKeyword4) && !TargetActor.WornHasKeyword(TempDDKeyword4)) || !DeviceRendered.HasKeyword(TempDDKeyword4))
				StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
				DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword) ; corset
				StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword) ; harness
				if DeviceRendered.HasKeyword(TempDDKeyword4)
					StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword4)
				endif
				return True
			endif
		endif
	elseif DeviceName == "Collar"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaCollarStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Collar", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaCollarStyle
			endif
			if McmConfig.DDPaCollarColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Collar", DeviceStyle, McmConfig.DDPaCollarColour)
					DeviceColour = McmConfig.DDPaCollarColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Collar_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDCollar(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; Collar
			return True
		endif
	elseif DeviceName == "PlugVaginal"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x1DD7C, "Devious Devices - Assets.esm") as Keyword ; PlugVaginal
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if  !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) && \
			(McmConfig.DDPaPlugsWithBelt == False || (McmConfig.DDPaPlugsWithBelt == True && (TargetActor.WornHasKeyword(TempDDKeyword2) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2))))
			if McmConfig.DDPaPlugVaginalStyle == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PlugVaginal")
				DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PlugVaginal", Utility.RandomInt(1, TempInt - 1))
			else
				DeviceStyle = McmConfig.DDPaPlugVaginalStyle
			endif
			if McmConfig.DDPaPlugVaginalColour == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugVaginal_" + DeviceStyle)
				DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugVaginal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
			else
				if McmConfig.StyleHasColour("PlugVaginal", DeviceStyle, McmConfig.DDPaPlugVaginalColour)
					DeviceColour = McmConfig.DDPaPlugVaginalColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugVaginal_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugVaginal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDPlugVaginal(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; PlugVaginal
			return True
		endif
	elseif DeviceName == "PlugAnal"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x1DD7D, "Devious Devices - Assets.esm") as Keyword ; PlugAnal
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword ; Belt
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) && \
			(McmConfig.DDPaPlugsWithBelt == False || (McmConfig.DDPaPlugsWithBelt == True && (TargetActor.WornHasKeyword(TempDDKeyword2) || StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2))))
			if McmConfig.DDPaPlugAnalStyle == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PlugAnal")
				DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PlugAnal", Utility.RandomInt(1, TempInt - 1))
			else
				DeviceStyle = McmConfig.DDPaPlugAnalStyle
			endif
			if McmConfig.DDPaPlugAnalColour == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugAnal_" + DeviceStyle)
				DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugAnal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
			else
				if McmConfig.StyleHasColour("PlugAnal", DeviceStyle, McmConfig.DDPaPlugAnalColour)
					DeviceColour = McmConfig.DDPaPlugAnalColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugAnal_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PlugAnal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDPlugAnal(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; PlugAnal
			return True
		endif
	elseif DeviceName == "PiercingVaginal"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x23E70, "Devious Devices - Assets.esm") as Keyword ; PiercingVaginal
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaPiercingVaginalStyle == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PiercingVaginal")
				DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PiercingVaginal", Utility.RandomInt(1, TempInt - 1))
			else
				DeviceStyle = McmConfig.DDPaPiercingVaginalStyle
			endif
			if McmConfig.DDPaPiercingVaginalColour == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingVaginal_" + DeviceStyle)
				DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingVaginal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
			else
				if McmConfig.StyleHasColour("PiercingVaginal", DeviceStyle, McmConfig.DDPaPiercingVaginalColour)
					DeviceColour = McmConfig.DDPaPiercingVaginalColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingVaginal_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingVaginal_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDPiercingVaginal(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; PiercingVaginal
			return True
		endif
	elseif DeviceName == "PiercingNipple"
		Keyword TempDDKeyword = Game.GetFormFromFile(0xCA39, "Devious Devices - Assets.esm") as Keyword ; PiercingNipple
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaPiercingNippleStyle == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PiercingNipple")
				DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "PiercingNipple", Utility.RandomInt(1, TempInt - 1))
			else
				DeviceStyle = McmConfig.DDPaPiercingNippleStyle
			endif
			if McmConfig.DDPaPiercingNippleColour == "Any"
				Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingNipple_" + DeviceStyle)
				DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingNipple_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
			else
				if McmConfig.StyleHasColour("PiercingNipple", DeviceStyle, McmConfig.DDPaPiercingNippleColour)
					DeviceColour = McmConfig.DDPaPiercingNippleColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingNipple_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "PiercingNipple_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDPiercingNipple(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; PiercingNipple
			return True
		endif
	elseif DeviceName == "Boots"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x27F29, "Devious Devices - Assets.esm") as Keyword ; Boots
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaBootsStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Boots", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaBootsStyle
			endif
			if McmConfig.DDPaBootsColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Boots", DeviceStyle, McmConfig.DDPaBootsColour)
					DeviceColour = McmConfig.DDPaBootsColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Boots_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDBoots(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; Boots
			return True
		endif
	elseif DeviceName == "Gloves"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x2AFA1, "Devious Devices - Assets.esm") as Keyword ; Gloves
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaGlovesStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "Gloves", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaGlovesStyle
			endif
			if McmConfig.DDPaGlovesColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("Gloves", DeviceStyle, McmConfig.DDPaGlovesColour)
					DeviceColour = McmConfig.DDPaGlovesColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "Gloves_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDGloves(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; Gloves
			return True
		endif
	elseif DeviceName == "ArmCuffs"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DF9, "Devious Devices - Assets.esm") as Keyword ; ArmCuffs
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaArmCuffsStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "ArmCuffs", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaArmCuffsStyle
			endif
			if McmConfig.DDPaArmCuffsColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("ArmCuffs", DeviceStyle, McmConfig.DDPaArmCuffsColour)
					DeviceColour = McmConfig.DDPaArmCuffsColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "ArmCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDArmCuffs(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; ArmCuffs
			return True
		endif
	elseif DeviceName == "LegCuffs"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DF8, "Devious Devices - Assets.esm") as Keyword ; LegCuffs
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			if McmConfig.DDPaLegCuffsStyle == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs", StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower"))
						DeviceStyle = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs")
						DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs", Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs")
					DeviceStyle = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDStyle_" + "LegCuffs", Utility.RandomInt(1, TempInt - 1))
				endif
			else
				DeviceStyle = McmConfig.DDPaLegCuffsStyle
			endif
			if McmConfig.DDPaLegCuffsColour == "Any"
				if McmConfig.DDPaConsistantStyle
					if StorageUtil.StringListHas(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle, StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower"))
						DeviceColour = StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
					else
						Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle)
						DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
					endif
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			else
				if McmConfig.StyleHasColour("LegCuffs", DeviceStyle, McmConfig.DDPaLegCuffsColour)
					DeviceColour = McmConfig.DDPaLegCuffsColour
				else
					Int TempInt = StorageUtil.StringListCount(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle)
					DeviceColour = StorageUtil.StringListGet(none, "Defeat_LRGPatch_MCMSettings_DDColour_" + "LegCuffs_" + DeviceStyle, Utility.RandomInt(1, TempInt - 1))
				endif
			endif
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDLegCuffs(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; LegCuffs
			return True
		endif
	elseif DeviceName == "ArmShackles"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x63AD9, "Devious Devices - Assets.esm") as Keyword ; CuffsFront
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			DeviceStyle = "Iron"
			DeviceColour = ""
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDArmShackles(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; ArmShackles
			return True
		endif
	elseif DeviceName == "LegShackles"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x3DF8, "Devious Devices - Assets.esm") as Keyword ; LegCuffs
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x5F4BB, "Devious Devices - Integration.esm") as Keyword ; AnkleShackles
		if !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
			DeviceStyle = "NoBall"
			DeviceColour = ""
			PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
			Armor DeviceInventory
			DeviceInventory = DefeatUtil2.GetDDLegShackles(DeviceStyle, DeviceColour)
			StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
			DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
			StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; LegCuffs
			return True
		endif
	elseif DeviceName == "ArmLegShackles"
		Keyword TempDDKeyword = Game.GetFormFromFile(0x5226C, "Devious Devices - Integration.esm") as Keyword ; HeavyBondage
		Keyword TempDDKeyword2 = Game.GetFormFromFile(0x3DF8, "Devious Devices - Assets.esm") as Keyword ; LegCuffs
		Keyword TempDDKeyword3 = Game.GetFormFromFile(0x3DF7, "Devious Devices - Assets.esm") as Keyword ; Collar
		Keyword TempDDKeyword4 = Game.GetFormFromFile(0x3DF9, "Devious Devices - Assets.esm") as Keyword ; ArmCuffs
		if  !TargetActor.WornHasKeyword(TempDDKeyword) && !StorageUtil.FormListHas(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword)
				DeviceStyle = "Iron"
				DeviceColour = ""
				PlayerScr.DefeatLog("[Defeat] - EquipPreferedDevice - DeviceStyle:" + DeviceStyle + " DeviceColour: " + DeviceColour)
				Armor DeviceInventory
				DeviceInventory = DefeatUtil2.GetDDArmLegShackles(DeviceStyle, DeviceColour)
				Armor DeviceRendered = DefeatUtil2.GetRenderedDevice(DeviceInventory)
				if  ((DeviceRendered.HasKeyword(TempDDKeyword2) && !TargetActor.WornHasKeyword(TempDDKeyword2)) || !DeviceRendered.HasKeyword(TempDDKeyword2)) && \
					((DeviceRendered.HasKeyword(TempDDKeyword3) && !TargetActor.WornHasKeyword(TempDDKeyword3)) || !DeviceRendered.HasKeyword(TempDDKeyword3)) && \
					((DeviceRendered.HasKeyword(TempDDKeyword4) && !TargetActor.WornHasKeyword(TempDDKeyword4)) || !DeviceRendered.HasKeyword(TempDDKeyword4))
						StorageUtil.FormListAdd(Player, "zad_libs_ForceSilent", DeviceInventory)
						DefeatUtil2.LockDevice(TargetActor, DeviceInventory)
						StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword) ; HeavyBondage
						if DeviceRendered.HasKeyword(TempDDKeyword2)
							StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword2)
						endif
						if DeviceRendered.HasKeyword(TempDDKeyword3)
							StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword3)
						endif
						if DeviceRendered.HasKeyword(TempDDKeyword4)
							StorageUtil.FormListAdd(none, "Defeat_LRGPatch_PostAssault_TempData_EquippedKeywordsFollower", TempDDKeyword4)
						endif
						return True
				endif
		endif
	endif
	return False
EndFunction

Function BuildConsistantData()
	PlayerScr.DefeatLog("[Defeat] - BuildConsistantData - Start")
	StorageUtil.UnSetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour")
	StorageUtil.UnSetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle")
	Int BlackCount = 0
	Int WhiteCount = 0
	Int RedCount = 0
	Int LeatherCount = 0
	Int EboniteCount = 0
	Int RopeCount = 0
	Bool UseEquippedColour = False
	Bool UseEquippedStyle = False
	Armor DeviceInventory
	if StorageUtil.GetFormValue(Player, "zad_Equipped" + "Suit" + "_Inventory")
		DeviceInventory = StorageUtil.GetFormValue(Player, "zad_Equipped" + "Suit" + "_Inventory") as Armor
		String DeviceInventoryName = DeviceInventory.GetName()
		if McmConfig.Language == "English"
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Suit Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Suit Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Suit Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Suit Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Suit White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Suit Red")
			endif
		else
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Suit Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Suit Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Suit Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Suit Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Suit White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Suit Red")
			endif
		endif
	endif
	if StorageUtil.GetFormValue(Player, "zad_Equipped" + "StraitJacket" + "_Inventory")
		DeviceInventory = StorageUtil.GetFormValue(Player, "zad_Equipped" + "StraitJacket" + "_Inventory") as Armor
		String DeviceInventoryName = DeviceInventory.GetName()
		if McmConfig.Language == "English"
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Red")
			endif
		else
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - StraitJacket Red")
			endif
		endif
	endif
	if StorageUtil.GetFormValue(Player, "zad_Equipped" + "HobbleSkirt" + "_Inventory")
		DeviceInventory = StorageUtil.GetFormValue(Player, "zad_Equipped" + "HobbleSkirt" + "_Inventory") as Armor
		String DeviceInventoryName = DeviceInventory.GetName()
		if McmConfig.Language == "English"
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Red")
			endif
		else
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - HobbleSkirt Red")
			endif
		endif
	endif
	if StorageUtil.GetFormValue(Player, "zad_Equipped" + "Corset" + "_Inventory")
		DeviceInventory = StorageUtil.GetFormValue(Player, "zad_Equipped" + "Corset" + "_Inventory") as Armor
		String DeviceInventoryName = DeviceInventory.GetName()
		if McmConfig.Language == "English"
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Corset Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Corset Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Corset Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Corset Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Corset White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Corset Red")
			endif
		else
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Corset Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Corset Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Corset Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Corset Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Corset White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Corset Red")
			endif
		endif
	endif
	if StorageUtil.GetFormValue(Player, "zad_Equipped" + "Harness" + "_Inventory")
		DeviceInventory = StorageUtil.GetFormValue(Player, "zad_Equipped" + "Harness" + "_Inventory") as Armor
		String DeviceInventoryName = DeviceInventory.GetName()
		if McmConfig.Language == "English"
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Harness Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Harness Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Harness Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Harness Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Harness White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Harness Red")
			endif
		else
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Harness Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Harness Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Harness Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Harness Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Harness White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Harness Red")
			endif
		endif
	endif
	if StorageUtil.GetFormValue(Player, "zad_Equipped" + "Gloves" + "_Inventory")
		DeviceInventory = StorageUtil.GetFormValue(Player, "zad_Equipped" + "Gloves" + "_Inventory") as Armor
		String DeviceInventoryName = DeviceInventory.GetName()
		if McmConfig.Language == "English"
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Gloves White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Red")
			endif
		else
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Gloves White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Gloves Red")
			endif
		endif
	endif
	if StorageUtil.GetFormValue(Player, "zad_Equipped" + "Boots" + "_Inventory")
		DeviceInventory = StorageUtil.GetFormValue(Player, "zad_Equipped" + "Boots" + "_Inventory") as Armor
		String DeviceInventoryName = DeviceInventory.GetName()
		if McmConfig.Language == "English"
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Boots Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Boots Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Boots Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Boots Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Boots White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Boots Red")
			endif
		else
			if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
				LeatherCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Boots Leather")
			elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
				EboniteCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Boots Ebonite")
			elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
				RopeCount += 1
				UseEquippedStyle = True
				PlayerScr.DefeatLog("[Defeat] - Boots Rope")
			endif
			if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
				BlackCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Boots Black")
			elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
				WhiteCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Boots White")
			elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
				RedCount += 1
				UseEquippedColour = True
				PlayerScr.DefeatLog("[Defeat] - Boots Red")
			endif
		endif
	endif
	if UseEquippedColour == False
		If McmConfig.DDPaSuitColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaSuitColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaSuitColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaHoodColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaHoodColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaHoodColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaHarnessColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaHarnessColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaHarnessColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaCorsetColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaCorsetColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaCorsetColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaBootsColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaBootsColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaBootsColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaGlovesColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaGlovesColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaGlovesColour == "Red"
			RedCount += 1
		endif
	endif
	if UseEquippedStyle == False
		If McmConfig.DDPaHarnessStyle == "Leather"
			LeatherCount += 1
		elseIf McmConfig.DDPaHarnessStyle == "Ebonite"
			EboniteCount += 1
		elseIf McmConfig.DDPaHarnessStyle == "Rope"
			RopeCount += 1
		endif
		If McmConfig.DDPaCorsetStyle == "Leather"
			LeatherCount += 1
		elseIf McmConfig.DDPaCorsetStyle == "Ebonite"
			EboniteCount += 1
		elseIf McmConfig.DDPaCorsetStyle == "Rope"
			RopeCount += 1
		endif
		If McmConfig.DDPaBootsStyle == "Leather"
			LeatherCount += 1
		elseIf McmConfig.DDPaBootsStyle == "Ebonite"
			EboniteCount += 1
		elseIf McmConfig.DDPaBootsStyle == "Rope"
			RopeCount += 1
		endif
		If McmConfig.DDPaGlovesStyle == "Leather"
			LeatherCount += 1
		elseIf McmConfig.DDPaGlovesStyle == "Ebonite"
			EboniteCount += 1
		elseIf McmConfig.DDPaGlovesStyle == "Rope"
			RopeCount += 1
		endif
	endif
	Int TotalCount = BlackCount + WhiteCount + RedCount
	PlayerScr.DefeatLog("[Defeat] - TotalCount: " + TotalCount)
	PlayerScr.DefeatLog("[Defeat] - BlackCount: " + BlackCount)
	PlayerScr.DefeatLog("[Defeat] - WhiteCount: " + WhiteCount)
	PlayerScr.DefeatLog("[Defeat] - RedCount: " + RedCount)
	if TotalCount > 0
		Int RandomInt = Utility.RandomInt(1, TotalCount)
		if RandomInt <= BlackCount
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour", "Black")
			PlayerScr.DefeatLog("[Defeat] - Black")
		else
			RandomInt -= BlackCount
		endif
		if (RandomInt <= WhiteCount) && StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour", "") == ""
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour", "White")
			PlayerScr.DefeatLog("[Defeat] - White")
		elseif StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour", "") == ""
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour", "Red")
			PlayerScr.DefeatLog("[Defeat] - Red")
		endif
	else
		Int RandomInt = Utility.RandomInt(0, 2)
		if RandomInt == 0
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour", "Black")
			PlayerScr.DefeatLog("[Defeat] - Random Black")
		elseif RandomInt == 1
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour", "White")
			PlayerScr.DefeatLog("[Defeat] - Random White")
		elseif RandomInt == 2
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColour", "Red")
			PlayerScr.DefeatLog("[Defeat] - Random Red")
		endif
	endif
	TotalCount = LeatherCount + EboniteCount + RopeCount
	PlayerScr.DefeatLog("[Defeat] - TotalCount: " + TotalCount)
	PlayerScr.DefeatLog("[Defeat] - LeatherCount: " + LeatherCount)
	PlayerScr.DefeatLog("[Defeat] - EboniteCount: " + EboniteCount)
	PlayerScr.DefeatLog("[Defeat] - RopeCount: " + RopeCount)
	if TotalCount > 0
		Int RandomInt = Utility.RandomInt(1, TotalCount)
		if RandomInt <= LeatherCount
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle", "Leather")
			PlayerScr.DefeatLog("[Defeat] - Leather")
		else
			RandomInt -= LeatherCount
		endif
		if (RandomInt <= EboniteCount) && StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle", "") == ""
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle", "Ebonite")
			PlayerScr.DefeatLog("[Defeat] - Ebonite")
		elseif StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle", "") == ""
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle", "Rope")
			PlayerScr.DefeatLog("[Defeat] - Rope")
		endif
	else
		Int RandomInt = Utility.RandomInt(0, 2)
		if RandomInt == 0
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle", "Leather")
			PlayerScr.DefeatLog("[Defeat] - Random Leather")
		elseif RandomInt == 1
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle", "Ebonite")
			PlayerScr.DefeatLog("[Defeat] - Random Ebonite")
		elseif RandomInt == 2
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyle", "Rope")
			PlayerScr.DefeatLog("[Defeat] - Random Rope")
		endif
	endif
	PlayerScr.DefeatLog("[Defeat] - BuildConsistantData - End")
EndFunction

Function BuildConsistantDataFollower(Actor TargetActor)
	PlayerScr.DefeatLog("[Defeat] - BuildConsistantDataFollower - Start")
	StorageUtil.UnSetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower")
	StorageUtil.UnSetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower")
	Int BlackCount = 0
	Int WhiteCount = 0
	Int RedCount = 0
	Int LeatherCount = 0
	Int EboniteCount = 0
	Int RopeCount = 0
	Bool UseEquippedColour = False
	Bool UseEquippedStyle = False
	Armor DeviceInventory
	
	Keyword TempKeyword = Game.GetFormFromFile(0x2AFA3, "Devious Devices - Assets.esm") as Keyword
	If TargetActor.WornHasKeyword(TempKeyword) ; Suit
		DeviceInventory = DefeatUtil2.GetWornDeviceFuzzyMatch(TargetActor, TempKeyword)
		if DeviceInventory
			String DeviceInventoryName = DeviceInventory.GetName()
			if McmConfig.Language == "English"
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Suit Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Suit Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Suit Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Suit Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Suit White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Suit Red")
				endif
			else
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Suit Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Suit Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Suit Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Suit Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Suit White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Suit Red")
				endif
			endif
		endif
	endif
	
	TempKeyword = Game.GetFormFromFile(0x27F28, "Devious Devices - Assets.esm") as Keyword ; Corset
	If TargetActor.WornHasKeyword(TempKeyword)
		DeviceInventory = DefeatUtil2.GetWornDeviceFuzzyMatch(TargetActor, TempKeyword)
		if DeviceInventory
			String DeviceInventoryName = DeviceInventory.GetName()
			if McmConfig.Language == "English"
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Corset Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Corset Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Corset Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Corset Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Corset White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Corset Red")
				endif
			else
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Corset Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Corset Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Corset Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Corset Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Corset White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Corset Red")
				endif
			endif
		endif
	endif
	
	TempKeyword = Game.GetFormFromFile(0x17C43, "Devious Devices - Assets.esm") as Keyword ; Harness
	If TargetActor.WornHasKeyword(TempKeyword)
		DeviceInventory = DefeatUtil2.GetWornDeviceFuzzyMatch(TargetActor, TempKeyword)
		if DeviceInventory
			String DeviceInventoryName = DeviceInventory.GetName()
			if McmConfig.Language == "English"
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Harness Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Harness Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Harness Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Harness Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Harness White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Harness Red")
				endif
			else
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Harness Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Harness Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Harness Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Harness Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Harness White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Harness Red")
				endif
			endif
		endif
	endif
	
	TempKeyword = Game.GetFormFromFile(0x2AFA1, "Devious Devices - Assets.esm") as Keyword ; Gloves
	If TargetActor.WornHasKeyword(TempKeyword)
		DeviceInventory = DefeatUtil2.GetWornDeviceFuzzyMatch(TargetActor, TempKeyword)
		if DeviceInventory
			String DeviceInventoryName = DeviceInventory.GetName()
			if McmConfig.Language == "English"
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Gloves White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Red")
				endif
			else
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Gloves White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Gloves Red")
				endif
			endif
		endif
	endif
	
	TempKeyword = Game.GetFormFromFile(0x27F29, "Devious Devices - Assets.esm") as Keyword ; Boots
	If TargetActor.WornHasKeyword(TempKeyword)
		DeviceInventory = DefeatUtil2.GetWornDeviceFuzzyMatch(TargetActor, TempKeyword)
		if DeviceInventory
			String DeviceInventoryName = DeviceInventory.GetName()
			if McmConfig.Language == "English"
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Boots Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Boots Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Boots Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Boots Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Boots White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Boots Red")
				endif
			else
				if StringUtil.Find(DeviceInventoryName, "Leather") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedLeather) != -1
					LeatherCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Boots Leather")
				elseif StringUtil.Find(DeviceInventoryName, "Ebonite") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedEbonite) != -1
					EboniteCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Boots Ebonite")
				elseif StringUtil.Find(DeviceInventoryName, "Rope") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRope) != -1
					RopeCount += 1
					UseEquippedStyle = True
					PlayerScr.DefeatLog("[Defeat] - Boots Rope")
				endif
				if StringUtil.Find(DeviceInventoryName, "Black") != -1 || StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedBlack) != -1
					BlackCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Boots Black")
				elseif StringUtil.Find(DeviceInventoryName, "White") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedWhite) != -1
					WhiteCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Boots White")
				elseif StringUtil.Find(DeviceInventoryName, "Red") != -1 ||  StringUtil.Find(DeviceInventoryName, McmConfig.LocalisedRed) != -1
					RedCount += 1
					UseEquippedColour = True
					PlayerScr.DefeatLog("[Defeat] - Boots Red")
				endif
			endif
		endif
	endif
	
	if UseEquippedColour == False
		If McmConfig.DDPaSuitColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaSuitColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaSuitColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaHoodColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaHoodColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaHoodColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaHarnessColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaHarnessColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaHarnessColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaCorsetColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaCorsetColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaCorsetColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaBootsColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaBootsColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaBootsColour == "Red"
			RedCount += 1
		endif
		If McmConfig.DDPaGlovesColour == "Black"
			BlackCount += 1
		elseIf McmConfig.DDPaGlovesColour == "White"
			WhiteCount += 1
		elseIf McmConfig.DDPaGlovesColour == "Red"
			RedCount += 1
		endif
	endif
	if UseEquippedStyle == False
		If McmConfig.DDPaHarnessStyle == "Leather"
			LeatherCount += 1
		elseIf McmConfig.DDPaHarnessStyle == "Ebonite"
			EboniteCount += 1
		elseIf McmConfig.DDPaHarnessStyle == "Rope"
			RopeCount += 1
		endif
		If McmConfig.DDPaCorsetStyle == "Leather"
			LeatherCount += 1
		elseIf McmConfig.DDPaCorsetStyle == "Ebonite"
			EboniteCount += 1
		elseIf McmConfig.DDPaCorsetStyle == "Rope"
			RopeCount += 1
		endif
		If McmConfig.DDPaBootsStyle == "Leather"
			LeatherCount += 1
		elseIf McmConfig.DDPaBootsStyle == "Ebonite"
			EboniteCount += 1
		elseIf McmConfig.DDPaBootsStyle == "Rope"
			RopeCount += 1
		endif
		If McmConfig.DDPaGlovesStyle == "Leather"
			LeatherCount += 1
		elseIf McmConfig.DDPaGlovesStyle == "Ebonite"
			EboniteCount += 1
		elseIf McmConfig.DDPaGlovesStyle == "Rope"
			RopeCount += 1
		endif
	endif
	Int TotalCount = BlackCount + WhiteCount + RedCount
	PlayerScr.DefeatLog("[Defeat] - TotalCount: " + TotalCount)
	PlayerScr.DefeatLog("[Defeat] - BlackCount: " + BlackCount)
	PlayerScr.DefeatLog("[Defeat] - WhiteCount: " + WhiteCount)
	PlayerScr.DefeatLog("[Defeat] - RedCount: " + RedCount)
	if TotalCount > 0
		Int RandomInt = Utility.RandomInt(1, TotalCount)
		if RandomInt <= BlackCount
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower", "Black")
			PlayerScr.DefeatLog("[Defeat] - Black")
		else
			RandomInt -= BlackCount
		endif
		if (RandomInt <= WhiteCount) && StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower", "") == ""
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower", "White")
			PlayerScr.DefeatLog("[Defeat] - White")
		elseif StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower", "") == ""
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower", "Red")
			PlayerScr.DefeatLog("[Defeat] - Red")
		endif
	else
		Int RandomInt = Utility.RandomInt(0, 2)
		if RandomInt == 0
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower", "Black")
			PlayerScr.DefeatLog("[Defeat] - Random Black")
		elseif RandomInt == 1
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower", "White")
			PlayerScr.DefeatLog("[Defeat] - Random White")
		elseif RandomInt == 2
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantColourFollower", "Red")
			PlayerScr.DefeatLog("[Defeat] - Random Red")
		endif
	endif
	TotalCount = LeatherCount + EboniteCount + RopeCount
	PlayerScr.DefeatLog("[Defeat] - TotalCount: " + TotalCount)
	PlayerScr.DefeatLog("[Defeat] - LeatherCount: " + LeatherCount)
	PlayerScr.DefeatLog("[Defeat] - EboniteCount: " + EboniteCount)
	PlayerScr.DefeatLog("[Defeat] - RopeCount: " + RopeCount)
	if TotalCount > 0
		Int RandomInt = Utility.RandomInt(1, TotalCount)
		if RandomInt <= LeatherCount
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower", "Leather")
			PlayerScr.DefeatLog("[Defeat] - Leather")
		else
			RandomInt -= LeatherCount
		endif
		if (RandomInt <= EboniteCount) && StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower", "") == ""
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower", "Ebonite")
			PlayerScr.DefeatLog("[Defeat] - Ebonite")
		elseif StorageUtil.GetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower", "") == ""
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower", "Rope")
			PlayerScr.DefeatLog("[Defeat] - Rope")
		endif
	else
		Int RandomInt = Utility.RandomInt(0, 2)
		if RandomInt == 0
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower", "Leather")
			PlayerScr.DefeatLog("[Defeat] - Random Leather")
		elseif RandomInt == 1
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower", "Ebonite")
			PlayerScr.DefeatLog("[Defeat] - Random Ebonite")
		elseif RandomInt == 2
			StorageUtil.SetStringValue(none, "Defeat_LRGPatch_PostAssault_TempData_ConsistantStyleFollower", "Rope")
			PlayerScr.DefeatLog("[Defeat] - Random Rope")
		endif
	endif
	PlayerScr.DefeatLog("[Defeat] - BuildConsistantDataFollower - End")
EndFunction

Int Function GetActorType(Actor TargetActor) ; 0 - Human; 1 - Creature
	if TargetActor.IsInFaction(CreatureFaction)
		return 1
	else
		return 0
	endif
EndFunction