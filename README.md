# BigWigs Golden Edition
Big updates to K40 and MC (**check your boss settings!**), small fixes and updates here and there. Mostly tested.
## Karazhan 40 - Highlights
* Trash - many additional mobs and mechanics (including "don't move" and "don't cast")
* Keeper - accurate Owl phase timer
* Incantagos - Affinity auto-targeting, Surge of Mana victim bars, Blizzard warning
* Anomalus - Floor Zone warnings
* Echo - additional warnings, optional timers to align Resto Pot usage
* Chess - accurate cast bars (hide, SBV), Curse CD (to allign hide phases)
* Sanv - bar for add phase duration
* Rupturan - alert when you stand in fire
* Mephistroth - Doom bar, purge alert, better Shards handling, sound cue on Shackle fade
## Future Ideas
* Dire Maul North - Alert on Eye summoning (similar to Stratholme).
* Chess - Keep track of major piece health and announce every % below 5.
## Karazhan 40 - Full Changelog
Relative to pepopo978's BigWigs.
### General
* Fixed various triggers and unit tests being based on formatted logs, eg " (1)".
* Changed a few sound effects.
* Added BigWigs:BuffNameByIndex(buffIndex) to Core.lua allowing to distinguish between buffs/debuffs with the same icon (loads the buffs into a virtual tooltip to read their name).
* Fixed some settings potentially breaking other (seemingly independent) features.
* Debuff-based warnings that require immediate player action (eg bomb, corruption, etc) are now triggered locally to avoid issues with synchronization and throttling.
### Trash
* Reworked instructions on Unstable Mana and Mana Buildup.
* Added Shadowclaw Rager, Shadowclaw Darkbringer, Manascale Suppressor, Manascale Drake, Lingering Arcanist, Lingering Astrologist, Lingering Magus, Karazhan Protector Golem, Warbringer Overseer.
### Keeper Gnarlmoon
* Added Owl Gaze warning (default: on).
* The first Owl kill correctly shortens the Owl Phase if more than 10 seconds are left.
* Ending the Owl Phase early will unschedule delayed warning messages.
* Fixed Blue Moon warning sign.
* Ravens warning can now be turned on and off during the encounter.
* Print Troubleshoot Info (default: off): Owl deaths
### Incantagos
* Added warning sign to Affinity summon.
* Proximity window is now off by default.
* Added Blizzard warning (default: on).
* Added Affinity auto-targeting (default: off).
* Shortened some overly verbose Affinity messages.
* Added Berserk warning (always on).
* Added personal bars for every Surge of Mana victim (default: on; click bar to target victim, if paladin also to cast Hand of Freedom), /say announcement by victims (default: on).
* Keep track of initial Ley-Seeker adds and warn if any are alive when boss it at 85% HP (always on).
* Based the initial CD bar for Ley-Line Disturbance on the death of the fourth add and shortened CD bar (lowest observed in logs is 45s instead of 55s).
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
### Sanv Tas'dal
* Added alerts for Portal Opening and Enrage (always on).
* Added timer bar for add phase (default: on).
* Phase Shifted alerts now only trigger below 80% boss HP.
### Rupturan
* Added personal warning to move out of Ignite Rock flamestrike area (default: on).
* Added Reform timers when Fragments are defeated (default: on).
* Added alternate triggers to no longer depend on SuperWoW cast events.
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

Kruul is unchanged for now.

# BigWigs (legacy description)
BigWigs is a World of Warcraft AddOn to predict certain AI behaviour to improve the players performance.<br>
This Modification is built for Patch 1.12.1.

## How to install
Either clone the repository to your WoW/Interface/Addons folder, or download manually via github (click on Clone or Download -> Download ZIP. Do not forget to rename the directory to "BigWigs" afterwards.

## Contributing
If you would like to contribute, just open a pull request.

## Language support
Currently, only english clients are supported. In general, the Addon can work with other languages, but this support is only provided on a best-effort basis. It is much effort to support those languages. Feel free to contribute if you would like to have support for other languages.
