scriptName defeat_skse_api Hidden

Import Debug
Import StorageUtil



DefeatConfig function GetDefeatConfig() global
	return Game.GetFormFromFile(0x04B8D1, "SexLabDefeat.esp") as DefeatConfig
endFunction

Function setActorVulnerability(actor actorref, float Vulnerability) global native

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

    DefeatConfig defConfig = GetDefeatConfig()
    Bool DefeatAllowed2PC = true
    Bool DefeatAllowed2NvN = true

    If !actorref.HasKeyWordString("ActorTypeNPC")
        SexLabAllowed = SexLab.AllowedCreature(actorref.GetLeveledActorBase().GetRace())
        DefeatAllowed2PC = defConfig.AllowedCreature(actorref, "Player")
		DefeatAllowed2NvN = defConfig.AllowedCreature(actorref, "NVN")
    Endif

    

    responseActorExtraData(actorref, IgnoreActorOnHit, SexLabGender, SexLabSexuality, SexLabAllowed, RaceKey, DefeatAllowed2PC, DefeatAllowed2NvN)
EndFunction