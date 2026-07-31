Scriptname Def_NPCDefeated extends Def_Scene

ReferenceAlias Property Player Auto
ReferenceAlias Property Target1 Auto
ReferenceAlias Property Target2 Auto
ReferenceAlias Property Actor1 Auto
ReferenceAlias Property Actor2 Auto
ReferenceAlias Property Actor3 Auto
ReferenceAlias Property Actor4 Auto
ReferenceAlias Property Actor5 Auto


Event OnInit()
    ; Run once when quest initializes (game start/quest start)
    Debug.Trace("Def_NPCDefeated OnInit called!")
    
    ; Register for a single update to run setup code once (avoids double-run)
    RegisterForUpdate(0.1) ; Register for a tiny update
EndEvent

Event OnUpdate()
    ; This runs once due to the registration above
    Debug.Trace("Def_NPCDefeated OnUpdate called!")
    
    ; Do your main setup here (e.g., Player.AddSpell(MySpell))
    
    ; Unregister if you don't need further updates
    UnregisterForUpdate()
EndEvent

Event OnPlayerLoadGame()
    ; Run every time the player loads a save
    Debug.Trace("Def_NPCDefeated OnPlayerLoadGame called!")
EndEvent

Function StartKnockdown(Actor Target, Actor Aggressor = None)
    Debug.Trace("Def_NPCDefeated StartKnockdown " + Target + " by " + Aggressor)
	Target1.ForceRefTo(Target)
	If(Aggressor)
		Actor1.ForceRefTo(Aggressor)
	EndIf
	If Target1.GetActorReference()
		if (SetStage(20))
			;
		Else
    		Debug.Trace("Def_NPCDefeated SetStage(20) fail " + Target + " by " + Aggressor)
			Stop()
		EndIf
	Else
		Stop()
	EndIf
EndFunction

Function applyRapeBounty()
	Actor Perpetrator = Actor1
	If ((Perpetrator == Player) && RessConfig.HasBeenRapedBy(Victim, Perpetrator) && Victim.GetParentCell() != Perpetrator.GetParentCell() && (Victim.GetBaseObject() as ActorBase).IsUnique()) ; Put a bounty only if the player isn't near the victim
		Faction CrimeFaction = Victim.GetCrimeFaction()
		If CrimeFaction && (Utility.RandomInt(1, 100) <= McmConfig.ChanceOfBountyPagg)
			CrimeFaction.ModCrimeGold(500, True)
			RessConfig.UILib.ShowNotification("${"+Victim.GetLeveledActorBase().GetName()+"} placed a bounty of 500 gold on you for rape!", "#CD4C4C")
		Endif
	Endif
EndFunction

Function ResetScene()
    Debug.Trace("Def_NPCDefeated ResetScene")
	GetDefActor(Target1).Reset()
	GetDefActor(Target2).Reset()
	GetDefActor(Actor1).Reset()
	GetDefActor(Actor2).Reset()
	GetDefActor(Actor3).Reset()
	GetDefActor(Actor4).Reset()
	GetDefActor(Actor5).Reset()
	Target1.Clear()
	Target2.Clear()
	Actor1.Clear()
	Actor2.Clear()
	Actor3.Clear()
	Actor4.Clear()
	Actor5.Clear()
EndFunction

Function ProcessKnockdown()
	GoToState("ProcessKnockdownState")
EndFunction

Function ProcessDoNothing()
	GoToState("ProcessDoNothingState")
EndFunction

Def_Actor Function GetDefActor(ReferenceAlias _alias)
	return (_alias as Def_Actor)
EndFunction

Event OnUpdate()
	StateOnUpdate()
EndEvent

Function StateOnUpdate()
EndFunction

State ProcessKnockdownState
	Float _end_time

	Event OnBeginState()
    	Debug.Trace("Def_NPCDefeated ProcessKnockdownState Started")
		_end_time = Utility.GetCurrentGameTime() + (McmConfig.KDTimeNVN/(24*60*60))
		
;			If (Duration > 0.0)
;				StateDuration = Duration
;			Else
;				If (Type == "Player Aggressor")
;					StateDuration = McmConfig.KDTimePagg
;				Elseif (Type == "Follower")
;					StateDuration = McmConfig.KDTimeNVN
;				Elseif (Type == "NPC")
;					StateDuration = McmConfig.KDTimeNVN
;				Endif
;			Endif

		Target1.Calm()
		Target1.Knockdown()
		RegisterForSingleUpdate(1.0)
	EndEvent

	Event OnEndState()
    	Debug.Trace("Def_NPCDefeated ProcessKnockdownState Stopped")
		UnregisterForUpdate()
	EndEvent

	Function StateOnUpdate()
		If (Utility.GetCurrentGameTime() > _end_time)
			SetStage(100)
			return
		EndIf
		RegisterForSingleUpdate(3.0)
	EndFunction
EndState

State ProcessDoNothingState

	Event OnBeginState()
    	Debug.Trace("Def_NPCDefeated ProcessDoNothingState Started")
		Target1.UnCalm()
	EndEvent

	Event OnEndState()
    	Debug.Trace("Def_NPCDefeated ProcessDoNothingState Stopped")
	EndEvent
EndState