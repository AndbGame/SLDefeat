Scriptname DefeatPlayer_Widget2 extends ReferenceAlias

DefeatPlayer DefPlayerScr
Actor PlayerRef

Event OnInit()
	RegisterForModEvent("DefeatStartDynamicWidget", "OnDefeatStartDynamicWidget")
	DefPlayerScr = Self.GetOwningQuest().GetAlias(0) as DefeatPlayer
	PlayerRef = Game.GetPlayer()
	GoToState("Disabled")
EndEvent

State Running
	Event OnBeginState()
		OnUpdate()
	EndEvent
	
	Event OnUpdate()
		DefPlayerScr.DefeatLog("[Defeat] - DefeatPlayer_Widget2 - OnUpdate")
		if PlayerRef.IsInCombat()
			DefPlayerScr.UpdateDynamicWidget(-DefPlayerScr.McmConfig.DynamicDefeatDepleteOverTime / 100)
		else
			DefPlayerScr.UpdateDynamicWidget(-DefPlayerScr.McmConfig.DynamicDefeatDepleteOverTime / 100 * 5)
		endif
		if DefPlayerScr.StruggleBar.Percent <= 0
			DefPlayerScr.StartDynamicWidget(False)
			GoToState("Disabled")
			return
		endif
		RegisterForSingleUpdate(2)
	EndEvent
	
	Event OnEndState()
	EndEvent
EndState

State Disabled

	Event OnDefeatStartDynamicWidget(string eventName, string argString, float argNum, form sender)
		GoToState("Running")
	EndEvent
	
EndState

Event OnDefeatStartDynamicWidget(string eventName, string argString, float argNum, form sender)
EndEvent