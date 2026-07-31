Scriptname Def_Actor extends ReferenceAlias

Bool Property isVictim = false Auto


Function Redress()
;	Int i
;	If (!Victim.IsDead() && Victim.Is3DLoaded() && !RessConfig.IsImmune(Victim)) ; check for other actions done or not and prevent redress until done.
;		Form Clothes
;		Int iNumSlots = McmConfig.SSPVicSet.Length - 1 	;Check for Armor uses one fewer MCM slots as Slot 0 by Weapon and our check uses [iSlot + 1] to account for this
;		While (i < McmConfig.SSPVicSet.Length)    		;Bane Updated to use Array Length in V26092023 - **NB Design Assumes all Strip Arrays are Intialised to the same length as SSPVicSet
;			Clothes = GetFormValue(Victim, "DefeatVictimClothes"+i+1)
;			If (Clothes && !Victim.GetWornForm(Armor.GetMaskForSlot(McmConfig.SSPagg[i] As Int)))
;				Victim.EquipItem(Clothes)
;			Endif
;			Clothes = GetFormValue(Victim, "DefeatVictimClothesNVN"+i+1)
;			If (Clothes && !Victim.GetWornForm(Armor.GetMaskForSlot(McmConfig.SSNVN[i] As Int)))
;				Victim.EquipItem(Clothes)
;			Endif
;			UnsetFormValue(Victim, "DefeatVictimClothes"+i+1)
;			UnsetFormValue(Victim, "DefeatVictimClothesNVN"+i+1)
;			i += 1
;		EndWhile
;	Endif
;	RessConfig.SetOldOutfit(Victim)
EndFunction

Event OnEffectStart(Actor Target, Actor Caster)
	Time = RessConfig.StateDuration
	SpamGuard = False
	;Bane 06/01/2023 Select a Surrender Pose Animation for this Follower
	strSurrenderPose = StringListGet(Player, "defeat_SurrenderAnims", Utility.RandomInt(0, StringListCount(Player, "defeat_SurrenderAnims") - 1))
EndEvent

Bool _is_calmed = False
Bool _calm_restore_player_teammate = False
Function Calm()
    If _is_calmed
        return
    EndIf
    _is_calmed = True
    Target.AddToFaction(CalmFaction)
    If GetActorReference().IsPlayerTeammate()
        GetActorReference().AddToFaction(RessConfig.FollowerFactions[0])
        _calm_restore_player_teammate = true
        GetActorReference().SetPlayerTeammate(False, False)
    EndIf
    Target.StopCombat()
    Target.StopCombatAlarm()
    If isVictim
        ActorUtil.AddPackageOverride(GetActorReference(), DoNothing, 100, 1)
        GetActorReference().EvaluatePackage()
    Endif
    StateCalm()
EndFunction
Function UnCalm()
    If !_is_calmed
        return
    EndIf
    _is_calmed = False
    GetActorReference().RemoveFromFaction(CalmFaction)
    StateUnCalm()
    If isVictim
        ActorUtil.RemovePackageOverride(GetActorReference(), DoNothing)
        GetActorReference().EvaluatePackage()
    Endif
    If _calm_restore_player_teammate
        GetActorReference().RemoveFromFaction(RessConfig.FollowerFactions[0])
        _calm_restore_player_teammate = False
        GetActorReference().SetPlayerTeammate(True, True)
    Endif
EndFunction
Function ApplyImmune(Actor Target)
	; todo
EndFunction

Bool _is_bleedout_knockdown_state = false
Function Knockdown(Bool IsBleedout = False)
    _initial_bleedout_state = IsBleedout
	GoToState("KnockdownState")
EndFunction

Function Reset()
	GoToState("Default")
EndFunction

State Default
	Event OnBeginState()
        UnCalm()
        UnsetStringValue(Target, "DefeatState")
        UnSetStringValue(Target, "DefeatType")
        defeat_skse_api.setActorState(Target, "ACTIVE")
	EndEvent

	Event OnEndState()
	EndEvent
EndState


Function StateCalm()
EndFunction
Function StateUnCalm()
EndFunction

State KnockdownState
	Bool _is_set_no_bleedout_recovery = false

	Event OnBeginState()
        defeat_skse_api.setActorState(Target, "Knockdown")
		RegisterForAnimationEvent(Victim, "staggerStop")
		RegisterForAnimationEvent(Victim, "GetUpEnd")
		RegisterForAnimationEvent(Victim, "BleedoutStop")

        SetStringValue(Target, "DefeatState", "Knockdown")
        SetStringValue(Target, "DefeatType", Type)

        If !_initial_bleedout_state
            DefeatPlayAnimation(Target, "Bleedout")
            _initial_bleedout_state = false
        Else
            If !Target.GetNoBleedoutRecovery()
                Target.SetNoBleedoutRecovery(True)
                _is_set_no_bleedout_recovery = true
            Endif
        Endif
	EndEvent

	Event OnEndState()
        If _is_set_no_bleedout_recovery
            Target.SetNoBleedoutRecovery(False)
            _is_set_no_bleedout_recovery = false
        Endif
	EndEvent

	Event OnActivate(ObjectReference akActionRef)
		Victim.Say(RessConfig.TopicToSay[2], Victim) ; Death moan
	EndEvent
	Event OnHit(ObjectReference akAggressor, Form akSrc, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		If !SpamGuard
			SpamGuard = True
			Actor Aggressor = (akAggressor As Actor)
			If ((Aggressor == Player) && abBashAttack)
				RessConfig.Knockout(Victim, Aggressor)
			Else
				Victim.Say(RessConfig.TopicToSay[2], Victim) ; Death moan
			Endif
			Victim.StopCombatAlarm() ;Was StopCombat
			Utility.Wait(0.5)
			SpamGuard = False
		Endif
	EndEvent
	Event OnAnimationEvent(ObjectReference akSource, string asEventName)
		Victim.Say(RessConfig.TopicToSay[2], Victim) ; Death moan
		RessConfig.DefeatPlayAnimation(Victim, "Bleedout")
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
		RessConfig.Knockdown(Victim)
	EndEvent
	Event OnEffectFinish(Actor Target, Actor Caster)
		Redress()
		RessConfig.Knockdown(Victim, Enter = False)
	EndEvent

EndState

State Trauma
	Event OnBeginState()
		RegisterForSingleUpdate(Time)
		RegisterForAnimationEvent(Victim, "staggerStop")
		RegisterForAnimationEvent(Victim, "GetUpEnd")
	EndEvent
	Event OnUpdate()
		If (Player.HasKeyWordString("DefeatActive") && Victim.HasKeyWordString("DefeatFollower")) ; If the player is still in a scene and the trauma victim is a follower, extend the state.
			RegisterForSingleUpdate(Time)
		Else
			Dispel()
		Endif
	EndEvent
	Event OnActivate(ObjectReference akActionRef)
		Victim.Say(RessConfig.TopicToSay[2], Victim) ; Death moan
		RessConfig.Trauma(Victim)
	EndEvent
	Event OnHit(ObjectReference akAggressor, Form akSrc, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		If !SpamGuard
			SpamGuard = True
			Actor Aggressor = (akAggressor As Actor)
			If ((Aggressor == Player) && abBashAttack)
				RessConfig.Knockout(Victim, Aggressor)
			Else
				Victim.Say(RessConfig.TopicToSay[2], Victim) ; Death moan
			Endif
			Utility.Wait(2)
			SpamGuard = False
		Endif
	EndEvent
	Event OnAnimationEvent(ObjectReference akSource, string asEventName)
		RessConfig.Trauma(Victim)
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
		Victim.Say(RessConfig.TopicToSay[2], Victim) ; Death moan
		RessConfig.Trauma(Victim)
	EndEvent
	Event OnEffectFinish(Actor Target, Actor Caster)
		Redress()
		RessConfig.Trauma(Victim, Enter = False)
		Bounty()
	EndEvent
EndState

State Exhausted
	Event OnBeginState()
		RegisterForSingleUpdate(Time)
		RegisterForAnimationEvent(Victim, "staggerStop")
		RegisterForAnimationEvent(Victim, "GetUpEnd")
		Victim.DamageActorValue("Stamina", Victim.GetActorValue("Stamina"))
	EndEvent
	Event OnUpdate()
		If (Player.HasKeyWordString("DefeatActive") && Victim.HasKeyWordString("DefeatFollower")) ; If the player is still in a scene and the exausted victim is a follower, extend the state.
			RegisterForSingleUpdate(Time)
		Else
			Dispel()
		Endif
	EndEvent
	Event OnActivate(ObjectReference akActionRef)
		Victim.Say(RessConfig.TopicToSay[2], Victim) ; Death moan
		RessConfig.Exhausted(Victim)
	EndEvent
	Event OnHit(ObjectReference akAggressor, Form akSrc, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		If !SpamGuard
			SpamGuard = True
			Actor Aggressor = (akAggressor As Actor)
			If ((Aggressor == Player) && abBashAttack)
				RessConfig.Knockout(Victim, Aggressor)
			Else
				Victim.Say(RessConfig.TopicToSay[2], Victim) ; Death moan
			Endif
			Utility.Wait(2)
			SpamGuard = False
		Endif
	EndEvent
	Event OnAnimationEvent(ObjectReference akSource, string asEventName)
		Victim.Say(RessConfig.TopicToSay[2], Victim) ; Death moan
		RessConfig.Exhausted(Victim)
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
		RessConfig.Exhausted(Victim)
	EndEvent
	Event OnEffectFinish(Actor Target, Actor Caster)
		Redress()
		RessConfig.Exhausted(Victim, Enter = False)
		Bounty()
	EndEvent
EndState

State Surrender
	Event OnBeginState()
		Utility.Wait(5.0)
		RessConfig.DefeatPlayAnimation(Victim, "Surrender")
		RegisterForSingleUpdate(Utility.RandomFloat(2.0, 5.0)) ;Bane 06/01/23 DeSync Multiple Followers Surrendering
	EndEvent
	Event OnUpdate()
		If Victim.HasKeyWordString("DefeatCollateral")
			SendAnimationEvent(Victim, strSurrenderPose) ;Bane 06/01/23 Use a randomly selected Surrender pose for this instance
			bHasSurrendered = True
		Elseif !Player.HasKeyWordString("DefeatActive")
			Dispel()
			Return
		ElseIf !bHasSurrendered ;Bane 06/01/2023 - Apply the selected Surrender pose to stop followers from just standing around looking bored during surrender
			SendAnimationEvent(Victim, strSurrenderPose)
			bHasSurrendered = True
		Endif
		RegisterForSingleUpdate(5)
	EndEvent
	Event OnEffectFinish(Actor Target, Actor Caster)
		Redress()
		RessConfig.Surrender(Victim, Enter = False)
	EndEvent
EndState

State Yield
	Event OnBeginState()
		RegisterForUpdate(5)
	EndEvent
	Event OnUpdate()
		If (!Player.HasLos(Victim) || Player.IsInCombat() || Player.GetDistance(Victim) > 1000.0)
			Dispel()
		Elseif !Victim.GetAnimationVariableBool("bIsSynced")
			RessConfig.CoverSelf(Victim)
		Endif
	EndEvent
	Event OnHit(ObjectReference akAggressor, Form akSrc, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		If !SpamGuard
			SpamGuard = True
			Actor Aggressor = (akAggressor As Actor)
			If Aggressor
				If ((Aggressor == Player) && abBashAttack)
					RessConfig.Knockdown(Victim)
				Else
					If ((Victim.GetActorValue("Aggression") < 2) || (Victim.GetActorValue("Confidence") < 3))
						Victim.Say(RessConfig.TopicToSay[3], Player) ; Flee
						SendAnimationEvent(Victim, strSurrenderPose) ;Bane 06/01/23 Use a randomly selected Yield pose for this instance
					Else
						Dispel()
					Endif
				Endif
			Endif
			Utility.Wait(2)
			SpamGuard = False
		Endif
	EndEvent
	Event OnEffectFinish(Actor Target, Actor Caster)
		RessConfig.Yield(Victim, Enter = False)
		Redress()
	EndEvent
EndState

State Escape
	Event OnBeginState()
		RegisterForSingleUpdate(Time)
	EndEvent
	Event OnUpdate()
		If (Player.HasKeyWordString("DefeatActive") && Victim.HasKeyWordString("DefeatFollower")) ; If the player is still in a scene and the trauma victim is a follower, extend the state.
			RegisterForSingleUpdate(Time)
		Else
			Dispel()
		Endif
	EndEvent
	Event OnActivate(ObjectReference akActionRef)
		Victim.Say(RessConfig.TopicToSay[3], Victim) ; Flee
	EndEvent
	Event OnHit(ObjectReference akAggressor, Form akSrc, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		If !SpamGuard
			SpamGuard = True
			Actor Aggressor = (akAggressor As Actor)
			If ((Aggressor == Player) && abBashAttack)
				RessConfig.Knockout(Victim, Aggressor)
			Else
				Victim.Say(RessConfig.TopicToSay[3], Victim) ; Flee
			Endif
			Utility.Wait(2)
			SpamGuard = False
		Endif
	EndEvent
	Event OnEffectFinish(Actor Target, Actor Caster)
		Redress()
		RessConfig.Escape(Victim, Enter = False)
		Bounty()
	EndEvent
EndState

State Weakenings
	Event OnBeginState()
		RegisterForSingleUpdate(Time)
	EndEvent
	Event OnUpdate()
		Dispel()
	EndEvent
	Event OnEffectFinish(Actor Target, Actor Caster)
		RessConfig.Weakenings(Victim, RemoveSpl = True)
	EndEvent
EndState

State Satisfied
	Event OnBeginState()
		RegisterForSingleUpdate(Time)
	EndEvent
	Event OnUpdate()
		Dispel()
	EndEvent
	Event OnEffectFinish(Actor Target, Actor Caster)
		RessConfig.SetSatisfied(Victim, Satisfied = False)
	EndEvent
EndState