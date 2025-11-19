local module, L = BigWigs:ModuleDeclaration("Ley-Watcher Incantagos", "Karazhan")

-- module variables
module.revision = 30003
module.enabletrigger = module.translatedName
module.toggleoptions = { "leyline", "affinity", "targetBlack", "targetBlue", "targetCrystal", "targetGreen", "targetMana", "targetRed", -1, "surgewarning", "surgesay", "surgetarget", "summonseeker", "summonwhelps", -1, "beam", "blizzard", "proximity", "cursewarning", "bosskill"}
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Tower of Karazhan"],
	AceLibrary("Babble-Zone-2.2")["Tower of Karazhan"],
}

-- module defaults
module.defaultDB = {
	leyline = true,
	affinity = true,
	targetBlack = false,
	targetBlue = false,
	targetCrystal = false,
	targetGreen = false,
	targetMana = false,
	targetRed = false,
	surgewarning = true,
	surgesay = true,
	surgetarget = false,
	summonseeker = true,
	summonwhelps = true,
	beam = true,
	blizzard = true,
	proximity = false,
	cursewarning = true,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "Incantagos",

		leyline_cmd = "leyline",
		leyline_name = "Ley-Line Disturbance Alert",
		leyline_desc = "Warns when Ley-Watcher Incantagos casts Ley-Line Disturbance (Affinity summon)",

		affinity_cmd = "affinity",
		affinity_name = "Affinity Alert",
		affinity_desc = "Displays the type of the summoned Affinity",

		targetBlack_cmd = "targetBlack",
		targetBlack_name = "Auto-Target Shadow",
		targetBlack_desc = "Auto-target Black Affinity (Shadow)",

		targetBlue_cmd = "targetBlue",
		targetBlue_name = "Auto-Target Frost",
		targetBlue_desc = "Auto-target Blue Affinity (Frost)",

		targetCrystal_cmd = "targetCrystal",
		targetCrystal_name = "Auto-Target Physical",
		targetCrystal_desc = "Auto-target Crystal Affinity (Physical)",

		targetGreen_cmd = "targetGreen",
		targetGreen_name = "Auto-Target Nature",
		targetGreen_desc = "Auto-target Green Affinity (Nature)",

		targetMana_cmd = "targetMana",
		targetMana_name = "Auto-Target Arcane",
		targetMana_desc = "Auto-target Mana Affinity (Arcane)",

		targetRed_cmd = "targetRed",
		targetRed_name = "Auto-Target Fire",
		targetRed_desc = "Auto-target Red Affinity (Fire)",

		surgewarning_cmd = "surgewarning",
		surgewarning_name = "Surge of Mana Alert",
		surgewarning_desc = "Warns when you or another player gets Surge of Mana (beam attack from Ley-Seeker adds)",

		surgesay_cmd = "surgesay",
		surgesay_name = "Surge of Mana Announce",
		surgesay_desc = "Call for help in /say when you get Surge of Mana",

		surgetarget_cmd = "surgetarget",
		surgetarget_name = "Surge of Mana Target",
		surgetarget_desc = "Auto-targets the latest Surge of Mana target for further action (healing, Hand of Freedom, etc)",

		summonseeker_cmd = "summonseeker",
		summonseeker_name = "Summon Ley-Seeker Alert",
		summonseeker_desc = "Warns when Ley-Watcher Incantagos summons Manascale Ley-Seeker",

		summonwhelps_cmd = "summonwhelps",
		summonwhelps_name = "Summon Whelps Alert",
		summonwhelps_desc = "Warns when Ley-Watcher Incantagos summons Manascale Whelps",

		beam_cmd = "beam",
		beam_name = "Guided Ley-Beam Alert",
		beam_desc = "Warns when players are affected by Guided Ley-Beam",

		blizzard_cmd = "blizzard",
		blizzard_name = "Blizzard Alert",
		blizzard_desc = "Warns when players are affected by Blizzard",

		proximity_cmd = "proximity",
		proximity_name = "Proximity Warning",
		proximity_desc = "Show Proximity Warning Frame",

		cursewarning_cmd = "cursewarning",
		cursewarning_name = "Curse of Manascale Warning",
		cursewarning_desc = "Warns when boss reaches 38%, as Curse of Manascale comes at 33%",



		trigger_leyLineCast = "Watcher Incantagos begins to cast (.+)Line Disturbance",
		bar_leyLineCast = "Next Affinity",
		bar_leyLineCD = "Next Possible Ley-Line Disturbance",
		msg_leyLine = "Affinity incoming!",
		warn_leyLine = "AFFINITY SOON",

		trigger_blackAffinity = "gains Black Affinity",
		trigger_blueAffinity = "gains Blue Affinity",
		trigger_crystalAffinity = "gains Crystal Affinity",
		trigger_greenAffinity = "gains Green Affinity",
		trigger_manaAffinity = "gains Mana Affinity",
		trigger_redAffinity = "gains Red Affinity",

		mob_blackAffinity = "Black Affinity",
		mob_blueAffinity = "Blue Affinity",
		mob_crystalAffinity = "Crystal Affinity",
		mob_greenAffinity = "Green Affinity",
		mob_manaAffinity = "Mana Affinity",
		mob_redAffinity = "Red Affinity",

		msg_blackAffinity = "BLACK AFFINITY - Priests and Warlocks handle this!",
		msg_blueAffinity = "BLUE AFFINITY - Mages handle this!",
		msg_crystalAffinity = "CRYSTAL AFFINITY - Warriors, Rogues, Paladins and Hunters handle this!",
		msg_greenAffinity = "GREEN AFFINITY - Shamans and Druids handle this!",
		msg_manaAffinity = "MANA AFFINITY - Mages and Druids handle this!",
		msg_redAffinity = "RED AFFINITY - Mages and Warlocks handle this!",

		bar_blackAffinity = "Black Affinity (Shadow)",
		bar_blueAffinity = "Blue Affinity (Frost)",
		bar_crystalAffinity = "Crystal Affinity (Physical)",
		bar_greenAffinity = "Green Affinity (Nature)",
		bar_manaAffinity = "Mana Affinity (Arcane)",
		bar_redAffinity = "Red Affinity (Fire)",

		warn_blackAffinity = "SHADOW",
		warn_blueAffinity = "FROST",
		warn_crystalAffinity = "PHYSICAL",
		warn_greenAffinity = "NATURE",
		warn_manaAffinity = "ARCANE",
		warn_redAffinity = "FIRE",

		trigger_surgeYou = "You are afflicted by Surge of Mana",
		trigger_surge = "(.+) is afflicted by Surge of Mana",
		msg_surgeYou = "Surge of Mana on YOU!",
		msg_surge = "Surge of Mana on %s",
		warn_surge = "SURGE OF MANA",
		yell_surge = "Help me! (Surge of Mana)",

		trigger_summonSeekerCast = "Watcher Incantagos begins to cast Summon Manascale Ley",
		bar_summonSeekerCast = "Ley-Seeker Summoning",
		msg_summonSeeker = "Manascale Ley-Seeker spawning in 2 sec!",

		trigger_summonWhelpsCast = "Watcher Incantagos begins to cast Summon Manascale Whelps",
		bar_summonWhelpsCast = "Whelps Summoning",
		msg_summonWhelps = "Manascale Whelps spawning in 2 sec!",

		trigger_leyBeamGain = "(.+) gain.? Guided Ley",
		trigger_leyBeamAfflicted = "afflicted by Guided Ley",
		bar_leyBeam = "Guided Ley-Beam in",
		msg_leyBeam = "LEY-BEAM on %s - AVOID THEM!",
		msg_leyBeamYou = "LEY-BEAM on YOU - GET AWAY FROM OTHERS!",
		yell_leyBeam = "Guided Ley-Beam on me! STAY AWAY!",
		warn_leyBeam = "IN BEAM, MOVE",
		
		trigger_blizzard = "You are afflicted by Blizzard", --CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE
		msg_blizzard = "Move out of Blizzard!",
		warn_blizzard = "MOVE",

		msg_curseWarning = "38% - CURSE OF MANASCALE coming at 33%!",
		
		trigger_berserk = "Watcher Incantagos gains Berserk",
		msg_berserk = "Ley-Watcher Incantagos goes Berserk!",
		warn_berserk = "BERSERK",
		
		trigger_seekerDeath = "Seeker dies",
		msg_seekerCount = "%d Ley-Seekers left.",
		msg_seekerDeath = "All Ley-Seekers dead.",
		msg_seekerWarn = "Kill all Ley-Seekers before 80% boss HP!",
	}
end)

-- timer and icon variables
local timer = {
	firstLeyLine = { 35, 45 }, -- from fourth add kill
	leyLineCD = { 45, 55 },
	leyLineCast = 3,
	summonSeekerCast = 2,
	summonWhelpsCast = 2,
	affinity = 15,
	initalBeamCD = 28,
	beam = 13, -- 10 sec duration, starts 3 sec after initial targeting buff
}

local icon = {
	leyLine = "Spell_Arcane_PortalIronForge",
	greenAffinity = "Spell_Nature_AbolishMagic",
	blackAffinity = "Spell_Shadow_ShadowBolt",
	redAffinity = "Spell_Fire_FlameBolt",
	blueAffinity = "Spell_Frost_FrostBolt02",
	manaAffinity = "Spell_Nature_StarFall",
	crystalAffinity = "INV_Sword_04",
	surge = "Spell_Shadow_SiphonMana",
	beam = "Spell_Arcane_StarFire",
	blizzard = "Spell_Frost_IceStorm",
	berserk = "Spell_Nature_Reincarnation"
}

local color = {
	leyLine = "Blue",
	summonSeeker = "Yellow",
	summonWhelps = "Orange",
}

local syncName = {
	summonSeeker = "IncantagosSummonSeeker" .. module.revision,
	summonWhelps = "IncantagosSummonWhelps" .. module.revision,
	leyLine = "IncantagosLeyLine" .. module.revision,
	greenAffinity = "IncantagosGreenAffinity" .. module.revision,
	blackAffinity = "IncantagosBlackAffinity" .. module.revision,
	redAffinity = "IncantagosRedAffinity" .. module.revision,
	blueAffinity = "IncantagosBlueAffinity" .. module.revision,
	manaAffinity = "IncantagosManaAffinity" .. module.revision,
	crystalAffinity = "IncantagosCrystalAffinity" .. module.revision,
	beam = "IncantagosLeyBeam" .. module.revision,
	allSeekersDead = "IncantagosSeekersDead" .. module.revision,
}

-- Proximity Plugin
module.proximityCheck = function(unit)
	return CheckInteractDistance(unit, 2)
end
module.proximitySilent = true

-- module functions
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "BeginsCastEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "BeginsCastEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS", "BuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "BuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "BuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "BuffEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "DebuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "DebuffEvent")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	if SUPERWOW_VERSION then
		self:RegisterCastEventsForUnitName("Ley-Watcher Incantagos", "IncantagosCastEvent")
	end

	self:ThrottleSync(5, syncName.summonSeeker)
	self:ThrottleSync(5, syncName.summonWhelps)
	self:ThrottleSync(5, syncName.leyLine)
	self:ThrottleSync(20, syncName.greenAffinity)
	self:ThrottleSync(20, syncName.blackAffinity)
	self:ThrottleSync(20, syncName.redAffinity)
	self:ThrottleSync(20, syncName.blueAffinity)
	self:ThrottleSync(20, syncName.manaAffinity)
	self:ThrottleSync(20, syncName.crystalAffinity)
	self:ThrottleSync(2, syncName.beam)
	self:ThrottleSync(5, syncName.allSeekersDead)
end

function module:OnSetup()
	self.started = nil
	self.curseWarned = nil
	self.hitEightyFive = nil
	self.bossHealth = 100
	self.seekersLeft = 4
end

function module:OnEngage()
	if self.db.profile.beam then
		self:Bar(L["bar_leyBeam"], timer.initalBeamCD, icon.beam, true, color.leyLine)
	end

	if self.db.profile.proximity then
		self:Proximity()
	end

	self.curseWarned = nil
	self.hitEightyFive = nil
	self.bossHealth = 100
	self.seekersLeft = 4

	-- Start health monitoring
	self:ScheduleRepeatingEvent("CheckBossHealth", self.CheckBossHealth, 1, self)
end

function module:OnDisengage()
	self:RemoveProximity()

	if self:IsEventScheduled("CheckBossHealth") then
		self:CancelScheduledEvent("CheckBossHealth")
	end
end

function module:IncantagosCastEvent(casterGuid, targetGuid, eventType, spellId, castTime)
	if eventType == "CHANNEL" and spellId == 51187 then
		if IsRaidLeader() or IsRaidOfficer() then
			SetRaidTarget(targetGuid, 8)
		end
	end
end

function module:CheckBossHealth()
	for i = 1, GetNumRaidMembers() do
		local targetString = "raid" .. i .. "target"
		local targetName = UnitName(targetString)

		if targetName == module.translatedName then
			local health = UnitHealth(targetString)
			local healthMax = UnitHealthMax(targetString)

			if health > 0 and healthMax > 0 then
				self.bossHealth = math.ceil((health / healthMax) * 100)

				if self.bossHealth <= 85 and not self.hitEightyFive then
					if self.seekersLeft > 0 then
						self:Message(L["msg_seekerWarn"], "Important", nil, "Beware")
					end
					self.hitEightyFive = true
				end
				if self.bossHealth <= 38 and not self.curseWarned then
					if self.db.profile.cursewarning then
						self:Message(L["msg_curseWarning"], "Important", nil, "Alarm")
					end
					self.curseWarned = true
				end
				break
			end
		end
	end
end

function module:BeginsCastEvent(msg)
	if string.find(msg, L["trigger_summonSeekerCast"]) then
		self:Sync(syncName.summonSeeker)
	elseif string.find(msg, L["trigger_summonWhelpsCast"]) then
		self:Sync(syncName.summonWhelps)
	elseif string.find(msg, L["trigger_leyLineCast"]) then
		self:Sync(syncName.leyLine)
	end
end

function module:BuffEvent(msg)
	if string.find(msg, L["trigger_greenAffinity"]) then
		self:Sync(syncName.greenAffinity)
	elseif string.find(msg, L["trigger_blackAffinity"]) then
		self:Sync(syncName.blackAffinity)
	elseif string.find(msg, L["trigger_redAffinity"]) then
		self:Sync(syncName.redAffinity)
	elseif string.find(msg, L["trigger_blueAffinity"]) then
		self:Sync(syncName.blueAffinity)
	elseif string.find(msg, L["trigger_manaAffinity"]) then
		self:Sync(syncName.manaAffinity)
	elseif string.find(msg, L["trigger_crystalAffinity"]) then
		self:Sync(syncName.crystalAffinity)
	elseif string.find(msg, L["trigger_berserk"]) then
		self:WarningSign(icon.berserk, 2, true, L["warn_berserk"])
		self:Message(L["msg_berserk"], "Urgent", true, "Murloc")
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS(msg)
	local _, _, player = string.find(msg, L["trigger_leyBeamGain"])
	if player then
		if player == "You" then
			player = UnitName("player")
			self:LeyBeamStarted(player) -- let's not miss a sync
		end
		self:Sync(syncName.beam .. " " .. player)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if string.find(msg, L["trigger_leyBeamAfflicted"]) then
		self:WarningSign(icon.beam, 5, true, L["warn_leyBeam"])
	elseif self.db.profile.blizzard and string.find(msg, L["trigger_blizzard"]) then
		self:WarningSign(icon.blizzard, 2, true, L["warn_blizzard"])
		self:Message(L["msg_blizzard"], "Important", true, "Info")
	elseif string.find(msg, L["trigger_surgeYou"]) then
		if self.db.profile.surgewarning then
			self:WarningSign(icon.surge, 2, false, L["warn_surge"])
			self:Message(L["msg_surgeYou"], "Attention", true, "Info")
		end
		if self.db.profile.surgesay then
			SendChatMessage(L["yell_surge"], "SAY")
		end
		if self.db.profile.surgetarget then
			TargetByName(UnitName("player"),true)
		end
	end
end

function module:DebuffEvent(msg)
	local _, _, player = string.find(msg, L["trigger_surge"])
	if player then
		if self.db.profile.surgewarning then
			self:Message(string.format(L["msg_surge"], player), "Attention", true, "Info")			
		end
		if self.db.profile.surgetarget then
			TargetByName(player,true)
			self:WarningSign(icon.surge, 1, false, L["warn_surge"])
		end
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if string.find(msg, L["trigger_seekerDeath"]) then
		self.seekersLeft = self.seekersLeft -1
		if self.seekersLeft == 0 then
			self:Sync(syncName.allSeekersDead)
		elseif self.seekersLeft > 0 then
			self:Message(string.format(L["msg_seekerCount"], self.seekersLeft), "Positive")	
		end
	end
end


function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.summonSeeker then
		self:SummonSeeker()
	elseif sync == syncName.summonWhelps then
		self:SummonWhelps()
	elseif sync == syncName.leyLine then
		self:LeyLine()
	elseif sync == syncName.greenAffinity then
		self:GreenAffinity()
	elseif sync == syncName.blackAffinity then
		self:BlackAffinity()
	elseif sync == syncName.redAffinity then
		self:RedAffinity()
	elseif sync == syncName.blueAffinity then
		self:BlueAffinity()
	elseif sync == syncName.manaAffinity then
		self:ManaAffinity()
	elseif sync == syncName.crystalAffinity then
		self:CrystalAffinity()
	elseif sync == syncName.beam and rest and rest ~= UnitName("player") then
		self:LeyBeamStarted(rest)
	elseif sync == syncName.allSeekersDead then
		self:AllSeekersDead()
	end
end

function module:SummonSeeker()
	if self.db.profile.summonseeker then
		self:Message(L["msg_summonSeeker"], "Attention")
	end
end

function module:SummonWhelps()
	if self.db.profile.summonwhelps then
		self:Message(L["msg_summonWhelps"], "Attention")
	end
end

function module:LeyLine()
	if self.db.profile.leyline then
		self:Message(L["msg_leyLine"], "Important", true, "Beware")
		self:WarningSign(icon.leyLine, 3, false, L["warn_leyLine"])
		self:RemoveBar(L["bar_leyLineCD"])
		self:Bar(L["bar_leyLineCast"], timer.leyLineCast, icon.leyLine, true, color.leyLine)
		self:IntervalBar(L["bar_leyLineCD"], timer.leyLineCD[1], timer.leyLineCD[2], icon.leyLine, true, color.leyLine)
	end
end

function module:BlackAffinity()
	if self.db.profile.affinity then
		self:Message(L["msg_blackAffinity"], "Important", true, "Alarm")
		self:WarningSign(icon.blackAffinity, 5, true, L["warn_blackAffinity"])
		self:Bar(L["bar_blackAffinity"], timer.affinity, icon.blackAffinity)
	end
	if self.db.profile.targetBlack then
		TargetByName(L["mob_blackAffinity"],true)
	end
end

function module:BlueAffinity()
	if self.db.profile.affinity then
		self:Message(L["msg_blueAffinity"], "Important", true, "Alarm")
		self:WarningSign(icon.blueAffinity, 5, true, L["warn_blueAffinity"])
		self:Bar(L["bar_blueAffinity"], timer.affinity, icon.blueAffinity)
	end
	if self.db.profile.targetBlue then
		TargetByName(L["mob_blueAffinity"],true)
	end
end

function module:CrystalAffinity()
	if self.db.profile.affinity then
		self:Message(L["msg_crystalAffinity"], "Important", true, "Alarm")
		self:WarningSign(icon.crystalAffinity, 5, true, L["warn_crystalAffinity"])
		self:Bar(L["bar_crystalAffinity"], timer.affinity, icon.crystalAffinity)
	end
	if self.db.profile.targetCrystal then
		TargetByName(L["mob_crystalAffinity"],true)
	end
end

function module:GreenAffinity()
	if self.db.profile.affinity then
		self:Message(L["msg_greenAffinity"], "Important", true, "Alarm")
		self:WarningSign(icon.greenAffinity, 5, true, L["warn_greenAffinity"])
		self:Bar(L["bar_greenAffinity"], timer.affinity, icon.greenAffinity)
	end
	if self.db.profile.targetGreen then
		TargetByName(L["mob_greenAffinity"],true)
	end
end

function module:ManaAffinity()
	if self.db.profile.affinity then
		self:Message(L["msg_manaAffinity"], "Important", true, "Alarm")
		self:WarningSign(icon.manaAffinity, 5, true, L["warn_manaAffinity"])
		self:Bar(L["bar_manaAffinity"], timer.affinity, icon.manaAffinity)
	end
	if self.db.profile.targetMana then
		TargetByName(L["mob_manaAffinity"],true)
	end
end

function module:RedAffinity()
	if self.db.profile.affinity then
		self:Message(L["msg_redAffinity"], "Important", true, "Alarm")
		self:WarningSign(icon.redAffinity, 5, true, L["warn_redAffinity"])
		self:Bar(L["bar_redAffinity"], timer.affinity, icon.redAffinity)
	end
	if self.db.profile.targetRed then
		TargetByName(L["mob_redAffinity"],true)
	end
end

function module:LeyBeamStarted(player)
	if not self.db.profile.beam then return end
	-- Combined self and other beam handling into one function
	if player == UnitName("player") then
		self:Message(L["msg_leyBeamYou"], "Important", true, "Alarm")
		self:WarningSign(icon.beam, 3, true, L["msg_leyBeamYou"])
		SendChatMessage(L["yell_leyBeam"], "SAY")
	else
		self:Message(string.format(L["msg_leyBeam"], player), "Important")
	end

	-- Add a timer bar for the beam duration
	self:Bar(player .. ": " .. L["beam_name"], timer.beam, icon.beam)
end

function module:AllSeekersDead()
	self.seekersLeft = 0
	self:Message(L["msg_seekerDeath"], "Positive")
	
	if self.db.profile.leyline then
		self:IntervalBar(L["bar_leyLineCD"], timer.firstLeyLine[1], timer.firstLeyLine[2], icon.leyLine, true, color.leyLine)
	end
end

function module:Test()
	-- Initialize module state
	self:OnSetup()
	self:Engage()

	local events = {
		-- First Ley-Line around 1:15
		{ time = 4, func = function()
			print("Test: Ley-Watcher Incantagos begins to cast Ley-Line Disturbance")
			module:BeginsCastEvent("Ley-Watcher Incantagos begins to cast Ley-Line Disturbance.")
		end },
		{ time = 5, func = function()
			print("Test: You are afflicted by Guided Ley-Beam")
			module:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE("You are afflicted by Guided Ley-Beam (1).")
		end },
		{ time = 6, func = function()
			print("Test: simulate cast event")
			if SUPERWOW_VERSION then
				local _, guid = UnitExists("player")
				module:IncantagosCastEvent(nil, guid, "CHANNEL", 51187, 0)
			end
		end },

		-- Summon Seeker
		{ time = 7, func = function()
			print("Test: Ley-Watcher Incantagos begins to cast Summon Manascale Ley-Seeker")
			module:BeginsCastEvent("Ley-Watcher Incantagos begins to cast Summon Manascale Ley-Seeker.")
		end },
		-- Kill one initial Seeker
		{ time = 8, func = function()
			print("Manascale Ley-Seeker dies.")
			module:CHAT_MSG_COMBAT_HOSTILE_DEATH("Manascale Ley-Seeker dies.")
		end },
		-- Ley-Beam
		{ time = 10, func = function()
			print("Test: " .. UnitName("player") .. " gains Guided Ley-Beam")
			module:CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS(UnitName("player") .. " gains Guided Ley-Beam (1).")

			-- clear skull
			if IsRaidLeader() or IsRaidOfficer() then
				SetRaidTarget("player", 0)
			end
		end },
		-- kill final initial Ley-Seeker 
		{ time = 12, func = function()
			self.seekersLeft = 1
			print("Set seekers to 1, Manascale Ley-Seeker dies.")
			module:CHAT_MSG_COMBAT_HOSTILE_DEATH("Manascale Ley-Seeker dies.")
		end },
		{ time = 15, func = function()
			print("Test: Stormhide gains Guided Ley-Beam")
			module:CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS("Stormhide gains Guided Ley-Beam (1).")
		end },

		{ time = 20, func = function()
			print("Test: You gain Guided Ley-Beam")
			module:CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS("You gain Guided Ley-Beam (1).")
		end },

		-- Summon Whelps
		{ time = 25, func = function()
			print("Test: Ley-Watcher Incantagos begins to cast Summon Manascale Whelps")
			module:BeginsCastEvent("Ley-Watcher Incantagos begins to cast Summon Manascale Whelps.")
		end },

		-- Blizzard
		{ time = 26, func = function()
			print("Test: You are afflicted by Blizzard")
			module:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE("You are afflicted by Blizzard.")
		end },

		-- Affinities
		{ time = 27, func = function()
			print("Test: Player1 gains Green Affinity")
			module:BuffEvent("Player1 gains Green Affinity (1).")
		end },
		{ time = 33, func = function()
			print("Test: Player1 gains Black Affinity")
			module:BuffEvent("Player1 gains Black Affinity (1).")
		end },
		{ time = 39, func = function()
			print("Test: Player1 gains Red Affinity")
			module:BuffEvent("Player1 gains Red Affinity (1).")
		end },
		{ time = 45, func = function()
			print("Test: Player1 gains Blue Affinity")
			module:BuffEvent("Player1 gains Blue Affinity (1).")
		end },
		{ time = 51, func = function()
			print("Test: Player1 gains Mana Affinity")
			module:BuffEvent("Player1 gains Mana Affinity (1).")
		end },
		{ time = 57, func = function()
			print("Test: Player1 gains Crystal Affinity")
			module:BuffEvent("Player1 gains Crystal Affinity (1).")
		end },

		-- Second Ley-Line about 55s after first one
		{ time = 65, func = function()
			print("Test: Ley-Watcher Incantagos begins to cast Ley-Line Disturbance")
			module:BeginsCastEvent("Ley-Watcher Incantagos begins to cast Ley-Line Disturbance.")
		end },
		
		-- Surge of Mana
		{ time = 29, func = function()
			print("Test: You are afflicted by Surge of Mana")
			module:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE("You are afflicted by Surge of Mana.")
		end },
		{ time = 35, func = function()
			print("Test: "..UnitName("raid1").." is afflicted by Surge of Mana")
			module:DebuffEvent(UnitName("raid1").." is afflicted by Surge of Mana.")
		end },

		{ time = 70, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event at its absolute time
	for i, event in ipairs(events) do
		self:ScheduleEvent("IncantagosTest" .. i, event.func, event.time)
	end

	self:Message("Ley-Watcher Incantagos test started", "Positive")
	return true
end

-- /run local m=BigWigs:GetModule("Ley-Watcher Incantagos"); BigWigs:SetupModule("Ley-Watcher Incantagos");m:Test();
