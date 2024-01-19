scriptName defeat_skse_api Hidden
; ---
; Event OnSLDefeatPlayerKnockDown (ObjectReference akAggressor, string eventName)
; ---
; On Player Knock Downed. Must be attached to ReferenceAlias of Player
; `eventName` can be:
;   - "KNONKDOWN"
;   - "KNONKOUT"
;   - "STANDING_STRUGGLE"
;
; ---
; Event OnSLDefeatQueryActor 
; ---
;

Import Debug
Import StorageUtil

; Set state of actor for processing: "ACTIVE", "DISACTIVE"
Function setActorState(actor Actorref, string _state) global native

; 'Temporary' workaround interface for request->response extradata for Hit processing. This data is cashed, and requests no more than once every few minutes per actor
Function responseActorExtraData(actor actorref, Bool IgnoreActorOnHit, int SexLabGender, int SexLabSexuality, Bool SexLabAllowed, String SexLabRaceKey, Float DFWVulnerability) global native
Function requestActorExtraData(actor actorref) global
    SexLabFramework SexLab = SexLabUtil.GetAPI()
    SexLab.Stats.SeedActor(actorref)

	Bool IgnoreActorOnHit = false;StorageUtil.FormListHas(none, "Defeat_IgnoreActor_OnHit", actorref)
	int SexLabGender = SexLab.GetGender(actorref)
	int SexLabSexuality = 0
    Bool SexLabAllowed = true
    String RaceKey = ""
    Float DFWVulnerability = 0.0

    DefeatPlayer DefPlayerScr = Quest.GetQuest("DefeatPlayerQST").GetAlias(0) as DefeatPlayer

    ;If Game.GetPlayer() == actorref && DefPlayerScr.RessConfig.DeviousFrameworkON && DefPlayerScr.McmConfig.KDWayVulnerabilityUseDFW
    ;    DFWVulnerability = DefeatUtil2.DFW_GetVulnerability(actorref)
    ;EndIf

    If !actorref.HasKeyWordString("ActorTypeNPC")
        SexLabAllowed = SexLab.AllowedCreature(actorref.GetLeveledActorBase().GetRace())
        RaceKey = sslCreatureAnimationSlots.GetRaceKey(actorref.GetLeveledActorBase().GetRace())
    Else
        If DefPlayerScr.McmConfig.SexualityPvic
            SexLabSexuality = SexLab.GetSexuality(actorref)
        Endif
    Endif

    

    responseActorExtraData(actorref, IgnoreActorOnHit, SexLabGender, SexLabSexuality, SexLabAllowed, RaceKey, DFWVulnerability)
EndFunction