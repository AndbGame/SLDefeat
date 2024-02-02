Scriptname DefeatPlayerBleedOut extends ReferenceAlias

DefeatPlayer Property PlayerScr Auto

Actor kPlayer
Location kLocation

Event OnEnterBleedOut()
	kPlayer = GetReference() As actor
	If kPlayer
		kLocation = kPlayer.GetCurrentLocation()
		If kLocation && kLocation.GetName() == "Apocrypha"
			Return
		EndIf
		PlayerScr.TriggerBleedOut()
	Endif
EndEvent