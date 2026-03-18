# BigWigs Golden Edition
Big updates to K40 and MC (**check your boss settings!**), small fixes and updates here and there. Mostly tested.

Updates are summarized in the [changelog](https://github.com/ElesionWoW/BigWigs/blob/master/documentation/changelog.txt). Details are in individual commits.
## Karazhan 40 - Highlights
* Trash - many additional mobs and mechanics (including "don't move" and "don't cast")
* Keeper - accurate Owl phase timer, identification of Owl health by location
* Incantagos - target Affinities automatically or by clicking on the timer bar, Surge of Mana victim bars, Blizzard warning
* Anomalus - Floor Zone warnings
* Echo - additional warnings, optional timers to align Resto Pot usage
* Chess - accurate cast bars (hide, SBV), Curse CD (to allign hide phases), MC announcements, hide pre-warning (HP based), Void Zone damage alerts
* Sanv - bar for add phase duration, warn about last Curse before Feedback
* Rupturan - Boulder target warnings, P1 kill window, alert when you stand in fire, monitoring of Felheart mana, Fragment health bars
* Mephistroth - Doom bar, purge alert, better Shards handling, sound cue on Shackle fade
## Other Feature Highlights
* Announcing bars to /raid now requires a Shift-click to prevent accidental spam.
* AQ40 - C'Thun map fix, vastly improved monitoring of Stomach Tentacles; improved map coordinates (by [DCV-2142](https://github.com/DCV-2142/BigWigs))
* MC - warning about tank knockback at Ragnaros, improved information at Thaurissan
* ZG & AQ20 - minor fixes
* DM North - Kromcrush fixes, new Eye of Kilrogg module
* Naxx - improved health monitoring at Maexxna and Thaddius P1
## Future Ideas
* ClickBar - Update more modules, add class-based CC options to all mind-control effects.
* MonitorBar - Update more modules: Thekal (health), Moam (mana).
* Mandokir & Buru - Properly fix rare concat errors.
* Thaurissan - Are timer bars for Knockback CD feasible and helpful?
* Rend Blackhand - Fix the event timer bars.
* CommonAura plugin - Add a timer bar for temporary flying mounts.
* CommonAura plugin - Add a timer bar for Tranquility from raid members.
* CandyBar library - Potentially unregister Mouse4 and Mouse5 so they aren't captured anymore if the cursor happens to be above a bar.
* Core - figure out a (non-SuperWoW) way to capture buffs/debuffs/stacks refreshing since it doesn't trigger a combat log entry.
## Karazhan 40 - Full Changelog
Relative to pepopo978's BigWigs.
### General
* Boss settings have their own "Karazhan40" menu category (separate from K10).
* Fixed various triggers and unit tests being based on formatted logs, eg " (1)".
* Changed a few sound effects.
* Added BigWigs:BuffNameByIndex(buffIndex) to Core.lua allowing to distinguish between buffs/debuffs with the same icon (loads the buffs into a virtual tooltip to read their name).
* Fixed some settings potentially breaking other (seemingly independent) features.
* Debuff-based warnings that require immediate player action (eg bomb, corruption, etc) are now triggered locally to avoid issues with synchronization and throttling.
### Trash
* Reworked instructions on Unstable Mana and Mana Buildup.
* Added Shadowclaw Rager, Shadowclaw Darkbringer, Manascale Suppressor, Manascale Drake, Lingering Arcanist, Lingering Astrologist, Lingering Magus, Karazhan Protector Golem, Warbringer Overseer.
### Keeper Gnarlmoon
* Accurate Owl health monitoring by location (eg "Red Front") through HP bars (default: on), replacing the Owl HP frame.
* Added Owl Gaze warning (default: on).
* The first Owl kill correctly shortens the Owl Phase if more than 10 seconds are left.
* Ending the Owl Phase early will unschedule delayed warning messages.
* Fixed Blue Moon warning sign.
* Print Troubleshoot Info (default: off): Owl deaths
### Incantagos
* Added warning sign to Affinity summon.
* Proximity window is now off by default.
* Added Blizzard warning (default: on).
* Added Affinity auto-targeting (default: off). Can also click the Affinity timer bar to target.
* Shortened some overly verbose Affinity messages.
* Added Berserk warning (always on).
* Added personal bars for every Surge of Mana victim (default: on; click bar to target victim, if paladin also to cast Hand of Freedom), /say announcement by victims (default: on).
* Keep track of initial Ley-Seeker adds and warn if any are alive when boss it at 85% HP (always on).
* Based the initial CD bar for Ley-Line Disturbance on the death of the fourth add and shortened CD bar (lowest observed in logs is 45s instead of 55s).
* Added cooldown bar for the next wave of summons (default: off) (idea by [DCV-2142](https://github.com/DCV-2142/BigWigs)).
### Anomalus
* Added message on /raid when using Death Wish and dropping below 200 AR (always on).
* Personal Arcane Overload (bomb) warnings will now always show. The Arcane Overload setting now only handles other players, skull marking, cooldown bars.
* Added Arcane Overload Say setting (default: on) to turn /say messages on bomb on or off.
* Added yell on gaining Arcane Dampening (default: off).
* Added warning on Unstable Magic floor zones and support for soaking them when Dampening is active (default: on). Special warning for Bomb + floor zone (always on).
* Print Troubleshoot Info (default: off): Bomb gains, deaths to floor zones
### Echo of Medivh
* Added Potion Strategy (default: off) for staggered bars/messages to time Restorative Potion and other dispels correctly. Yells for emergency dispel 2 seconds after general dispel if you still have Doom.
* Added Guardian's Ire stack counter with time-out bar (default: off) for interrupters.
* Added various boss cast warnings for interrupters (all default: off): Frost Nova, Shadow Bolt, Pyroblast, Flamestrike.
* Added Medivh's Fury warning message (always on) to keep track of cast haste.
* Added Arcane Focus alert (default: off) for MT dispellers.
* Added Flamestrike warning (default: on).
* Corruption Alert displays an additional warning if spreads are happening.
* Print Troubleshoot Info (default: off): Corruption gains (not throttled), successful Shadow Bolt casts
* Added duration bar for Corruption victim (clickable to target; default: off) for assigned healers.
### Chess
* Added announcements and health bars for mindcontrol victims (default: on).
* Added announcement when Rook/Bishop/Knight hit 8% HP (hide pre-warning; default: on).
* Added handling for Knight's Glory. The bar for the King's Fury cast time is shortened if applied. The warning sign is now displayed for the same duration as the cast time as well.
* Added warning for Knight's Glory (default: off) due to Knight proximity to Bishop or King so tanks can reposition.
* Added warning and accurate timer bar for Shadow Bolt Volley cast (default: on).
* Added warning for Empowered Shadow Bolt casts for Bishop tank (default: off).
* Added timer bar for King's Curse cooldown (default: on).
* Print Troubleshoot Info (default: off): King's Fury casts, King's Fury hide fails, Dark Subservience /bow fails
* Moved Dark Subservience cast messages to their own setting (default: off unless Shaman) to reduce spam.
* Dark Subservience affliction warnings are now split between self (default: on) and others (default: off) to further reduce spam.
* "Dark Subservience on You" will also give a pre-warning based on Queen starting to cast, even if cast warnings are disabled.
* Added audio feedback on King's Fury end and successful /bow.
* Added Queen's Fury magnitude alerts showing stack count and rough tick damage (default: off).
* Added personal alerts when taking Void Zone damage (default: on).
### Sanv Tas'dal
* Added alerts for Portal Opening and Enrage (always on).
* Added timer bar for add phase (default: on).
* Phase Shifted alerts now only trigger below 80% boss HP.
* Added Curse cooldown (default: off) and Rift Feedback cooldown (default: off) bars (largely by [DCV-2142](https://github.com/DCV-2142/BigWigs)).
* Added warning to the last Curse before a Rift Feedback (default: on).
### Rupturan
* Added personal warning to move out of Ignite Rock flamestrike area (default: on).
* Added Reform timers when Fragments are defeated (default: on).
* Added alternate triggers to no longer depend on SuperWoW cast events.
* Added Throw Boulder mechanic - warn about the current target (default: off), mark the current target with Moon (default: on), announce incoming Boulder and Boulder miss to /say if you are the target (default: on)
* Added Window of Opportunity handling below 25% HP boss HP in phase 1 by keeping track of Living Stone spawns to avoid Explode (default: on).
* Added alert for high Felheart mana (default: on).
* Added Felheart mana bar (default: on for priests, warlocks, hunters).
* Added Ignite Earth timers (P1 flamestrike; default: off) (idea by [DCV-2142](https://github.com/DCV-2142/BigWigs)).
* Added health bars for Fragments in P2 (default: on).
* Improved non-SuperWoW accuracy of Ignite Earth and Ignite Rock cast durations.
### Mephistroth
* Added duration bar for Doom (default: on for druid/mage, off for everyone else), which is clickable to decurse the current Doom victim.
* Added purge alert for Vampiric Aura (default: on for shaman/priest, off for everyone else).
* Added duration bar for Vampiric Corruption (boss haste after purge; default: off).
* Added warning and cast bar for Nathrezim Terror (default: on for shaman, off for everyone else).
* Added sound cue to Shackle fade.
* Reworked Shards handling: Added cast bar to incoming Shards. 120s CD bar split into 90s hard CD and 30s spawn window. Based Shard count on Shard death instead of channel fail (which may happen due to other reasons). Added counter for Shards remaining (default: off). Added messages for Shard phase win (6 shards dead) and fail (boss casting Unfathomed Hatred) for clarity.
* Tattle option also prints to the default chat window.
* Added alternate triggers to greatly reduce the reliance on SuperWoW cast events.
* Added mark (default: on) and alert with sound cue (default: off) about the current Waking Nightmare target to indicate Crawler spawn point for OTs.
* Added bars for minimum Shackles cooldown (default: on) and Fear cooldown (default: off) (largely by [DCV-2142](https://github.com/DCV-2142/BigWigs)).

Kruul is unchanged for now.
## Internal Changes
Check out the documentation subfolder for further information on many features.
* Full support for forking.
* New helper functions added to Core: BuffNameByIndex(), GetUnitIdByName(), GetTargetByName(), GetGUIDByName(), OffsetGUID(), RaidTargetLookup(), FormatLargeNumber(), BuffIsPresent(), DebuffIsPresent(), AuraIsPresent(), GetCastTimeCoefficient(), GetHealthPercent().
* Colors plugin provides raid target colors. Added ColorizeString().
* Expanded Bars plugin to add emphasis toggle, streamlined OnClick handling, and a new dynamically updating MonitorBar (click to target mob).
* Updated Babble-Zone and Babble-Boss libraries with TWoW custom names.
## Design Principles for Contributing
* Avoid relying on client mods. - Where possible provide alternate triggers that don't require client mods (like SuperWoW).
* Give players options. - Create sensible and granular settings. If a feature is only relevant to few people, do still include it but default it to off.
* Provide actionable information that is easy to parse. - BigWigs should serve relevant information in high-pressure situations without distracting users. Examples: For an alert "Run away - Corruption!" is better than "There is Corruption of Medivh on you, you should get out of the raid". For a bar text "Alice MC" is more helpful than "Chains of Kel'Thuzad on Alice". [sidenote: this is mostly for new features; for old features there is value in keeping alerts people have grown used to]
* Calls to action should have sound cues. - Not everyone plays with sound, but those that do rely on it.
* Field-test your updates. - Never push major updates that you haven't verified in-game.

If you (broadly) heed those principles I do welcome well-crafted pull requests! But please be patient and don't expect immediate reactions. BigWigs is a low-priority project for me.

Frequent contributors: [DCV-2142](https://github.com/DCV-2142/BigWigs)

# BigWigs (legacy description)
BigWigs is a World of Warcraft AddOn to predict certain AI behaviour to improve the players performance.<br>
This Modification is built for Patch 1.12.1.

## How to install
Either clone the repository to your WoW/Interface/Addons folder, or download manually via github (click on Clone or Download -> Download ZIP. Do not forget to rename the directory to "BigWigs" afterwards.

## Language support
Currently, only english clients are supported. In general, the Addon can work with other languages, but this support is only provided on a best-effort basis. It is much effort to support those languages. Feel free to contribute if you would like to have support for other languages.
