# SL Defeat — Andb Patch

Papyrus script patch for **SexLab Defeat**, combining the **Dynamic Defeat LRG** patch, **Bane’s Defeat updates**, and **Andb’s SKSE-backed rework** of hit processing, NPC-vs-NPC (NvN) scenes, and actor state handling.

This repository contains the modified Defeat scripts and a local Papyrus build setup. It is **not** a standalone mod — it replaces scripts on top of an existing SexLab Defeat installation and expects a matching SKSE plugin that implements `defeat_skse_api`.

## Lineage

| Layer | Source | Notes |
| --- | --- | --- |
| Base | SexLab Defeat v5.3.5 (Goubo) | Original mod |
| Maintained update | Defeat V5.3.6 (Bane, 2024-08-06) | Bugfixes / SE maintenance |
| Community patch | Dynamic Defeat LRG Patch 1.6.3 | Dynamic defeat meter, vulnerability, expanded post-assault |
| This patch | Andb (`andb_lrg`) | SKSE hit pipeline, NvN/gangbang natives, state API, animation helpers |

Branch of record: `andb_lrg`.

## What this patch changes

### SKSE-driven combat & knockdown

Vanilla Defeat relies heavily on Papyrus `OnHit`. This patch moves that path to a native plugin:

- Player knockdown / knockout / standing struggle events arrive through `defeat_skse_api` instead of scripted hit spam.
- Actor states (`ACTIVE`, `Knockdown`, `Trauma`, `Exhausted`, `Surrender`, `Yield`, `Tied`, …) are tracked via natives (`setActorState`, `tryExchangeActorState`, `getActorState`).
- Extra actor data used during hit checks (SexLab gender/sexuality, race key, DFW vulnerability, ignore lists) is requested/cached through the plugin.

Papyrus surface: `Scripts/Source/defeat_skse_api.psc`.

### NPC vs NPC (NvN)

NvN assault flow is reworked to query the SKSE plugin for scene aggressors and gangbang participants:

- `queryNvNScene` — choose an aggressor for a downed NPC
- `getNearestActorsForGangBang` — find additional aggressors for NvN gangbang
- Atomic state exchange (`tryExchangeActorState`) to avoid racey double-claims during assaults

### Dynamic Defeat / Vulnerability (from LRG)

Retained and integrated from Dynamic Defeat LRG:

- **Dynamic Defeat** — progressive defeat meter with weapon-type / power-attack / back-hit multipliers
- **Vulnerability** — Devious Devices gear increases knockdown chance (optional DFW vulnerability)
- Expanded MCM options for both systems
- `DefeatUtil2` compatibility helpers (DD, SD+, DCUR, DFW, ignored-weapon list, etc.)
- Richer post-assault outcomes (DD / Cursed Loot device equip, Simple Slavery, SD events, and related integrations)

### Animation selection

`defeat_select_sl_anim_interface` adds experimental SexLab animation picking when `DisableScale` is on, including scale-aware Soft/regular actor tagging for mixed-size scenes.

### Other fixes

- Safer actor state restore after knockdown / trauma / exhaust / surrender / yield (delayed `ACTIVE` restore)
- NvN gangbang and scene timing improvements
- ConsoleUtil debugging hooks used during development

## Requirements

### Required

- [SKSE](https://skse.silverlock.org/) (SE/AE matching your game)
- **SexLab Defeat** (Bane edit / V5.3.6 recommended)
- **SexLab Framework** and Defeat’s usual soft dependencies (SkyUI, PapyrusUtil / JContainers as used by your Defeat package, etc.)
- **Andb Defeat SKSE plugin** — native DLL that exports the functions declared in `defeat_skse_api.psc`  
  *(shipped separately; the `SKSE/` tree is gitignored in this repo)*

### Optional (used by LRG / MCM integrations)

- Devious Devices
- Devious Framework (DFW vulnerability)
- Deviously Cursed Loot
- Simple Slavery / related frameworks
- SexLab Aroused, Zaz Animation Pack, and other mods already supported by stock Defeat

## Installation (players)

1. Install SexLab Defeat (Bane) and its requirements.
2. Install the Andb SKSE plugin for Defeat.
3. Install this patch **after** Defeat / LRG so its `.pex` scripts override the originals.
4. Ensure load order keeps `SexLabDefeat.esp` (or your package’s ESP) as usual; this patch is script-level and does not replace the ESP by itself.
5. Start the game, open the Defeat MCM, and confirm Dynamic Defeat / Vulnerability / NvN options as desired.

Clean-save guidance from upstream Defeat still applies when upgrading major script revisions.

## Building from source (developers)

### Layout

```
SLDefeat/
├── Scripts/Source/     # Patched Papyrus sources
├── PAPYRUS/            # Local compiler + imported SRC_* dependencies (gitignored)
├── Build.ps1           # Compile Scripts/Source → Scripts/*.pex
├── UpdatePapyrus.ps1   # Helper to refresh Papyrus includes
└── include.txt         # Include path list for the compiler
```

### Compile

1. Populate `PAPYRUS/` with `PapyrusCompiler.exe`, `Flags.flg`, and the `SRC_*` folders listed in `include.txt`.
2. From the repo root:

```powershell
.\Build.ps1
```

The script compiles only sources newer than their `.pex`, unless `FORCE_RECOMPILE` is set inside `Build.ps1`.

Optional: if `Scripts/source_original/<Script>.psc` exists, `Build.ps1` also writes a git-style patch under `Scripts/diff/`.

## Repository status

Active development branch: **`andb_lrg`**.

Work-in-progress scripts (may be present untracked / unfinished):

- `Def_Actor.psc`
- `Def_NPCDefeated.psc` / `Def_NPCDefeated_QF.psc`
- `Def_Scene.psc` / `Def_SceneManager.psc`

These sketch a newer NPC-defeated scene framework hooked from `defeat_skse_api.npcKnockDownEvent` and are not a finished public feature yet.

## Credits

- **Goubo** — SexLab Defeat
- **Bane** — Defeat V5.3.6 maintenance edit
- **AndrewLRG (LRG)** — Dynamic Defeat LRG Patch
- **Andb** — SKSE integration, NvN/gangbang natives bridge, animation interface, and ongoing script fixes

All trademarks and original mod content belong to their respective authors. This project is a derivative script patch and should be used together with the original mods under their licenses / distribution terms (typically LoversLab for Defeat).

## License / distribution

Distribute only in accordance with the original SexLab Defeat and LRG patch permissions. Do not claim ownership of Goubo’s, Bane’s, or LRG’s work. The Andb-specific script and SKSE API changes in this repository are provided as a patch for personal / community use unless stated otherwise by the author.
