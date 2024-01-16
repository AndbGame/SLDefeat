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

Function setActorVulnerability(actor actorref, float Vulnerability) global native

; Set state of actor for processing: "ACTIVE", "DISACTIVE"
Function setActorState(actor Actorref, string _state) global native

Function DefeatQTEMeterInit(string WidgetRoot) global native

; 'Temporary' workaround interface for request->response extradata for Hit processing. This data is cashed, and requests no more than once every few minutes per actor
Function responseActorExtraData(actor actorref, Bool IgnoreActorOnHit, int SexLabGender, int SexLabSexuality, Bool SexLabAllowed, String SexLabRaceKey, Bool DefeatAllowed2PC, Bool DefeatAllowed2NvN) global native
Function requestActorExtraData(actor actorref) global
    SexLabFramework SexLab = SexLabUtil.GetAPI()
    SexLab.Stats.SeedActor(actorref)

	Bool IgnoreActorOnHit = StorageUtil.FormListHas(none, "Defeat_IgnoreActor_OnHit", actorref)
	int SexLabGender = SexLab.GetGender(actorref)
	int SexLabSexuality = SexLab.GetSexuality(actorref)
    Bool SexLabAllowed = true

    String RaceKey = sslCreatureAnimationSlots.GetRaceKey(actorref.GetLeveledActorBase().GetRace())

    If !actorref.HasKeyWordString("ActorTypeNPC")
        SexLabAllowed = SexLab.AllowedCreature(actorref.GetLeveledActorBase().GetRace())
    Endif

    

    responseActorExtraData(actorref, IgnoreActorOnHit, SexLabGender, SexLabSexuality, SexLabAllowed, RaceKey, false, false)
EndFunction