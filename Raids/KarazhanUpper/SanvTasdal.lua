local module, L = BigWigs:ModuleDeclaration("Sanv Tas'dal", "Karazhan")

-- module variables
module.revision = 30002
module.enabletrigger = module.translatedName
module.toggleoptions = { "phaseshifted", "overflowinghatred", "addphase", "curseoftherift", "keepcurse", "riftfeedback", "bosskill" }
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Tower of Karazhan"],
	AceLibrary("Babble-Zone-2.2")["Tower of Karazhan"],
	"Outland",
	"The Rock of Desolation"
}

-- module defaults
module.defaultDB = {
	phaseshifted = true,
	overflowinghatred = true,
	addphase = true,
	curseoftherift = false,
	keepcurse = true,
	riftfeedback = false,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "SanvTasdal",

		phaseshifted_cmd = "phaseshifted",
		phaseshifted_name = "Phase Shifted Alert",
		phaseshifted_desc = "Warns when players get affected by Phase Shifted",

		overflowinghatred_cmd = "overflowinghatred",
		overflowinghatred_name = "Overflowing Hatred Alert",
		overflowinghatred_desc = "Warns when Sanv Tas'dal begins casting Overflowing Hatred",

		addphase_cmd = "addphase",
		addphase_name = "Add-Phase Timer",
		addphase_desc = "Shows a timer bar for the add phase at 40%",
		
		curseoftherift_cmd = "curseoftherift",
		curseoftherift_name = "Curse Timer",
		curseoftherift_desc = "Shows a timer for repeated Curse of the Rift applications",

		keepcurse_cmd = "keepcurse",
		keepcurse_name = "Curse Alert",
		keepcurse_desc = "Shows a message to maintain Curse of the Rift on the last Curse application before the next Rift Feedback",

		riftfeedback_cmd = "riftfeedback",
		riftfeedback_name = "Rift Feedback CD",
		riftfeedback_desc = "Shows a timer for the minimum CD of Rift Feedback",


		trigger_phaseShiftedYou = "You are afflicted by Phase Shifted",
		trigger_phaseShiftedOther = "(.+) is afflicted by Phase Shifted",
		trigger_phaseShiftedFade = "Phase Shifted fades from you",
		trigger_phaseShiftedFadeOther = "Phase Shifted fades from (.+)",
		msg_phaseShiftedYou = "Phase Shifted - Kill Netherwalkers!",
		msg_phaseShiftedOther = "%s has Phase Shifted.",
		bar_phaseShiftedExpires = "Phase Shifted",
		warn_phaseShifted = "KILL WALKERS",

		trigger_overflowingHatredCast = "Sanv Tas'dal begins to cast Overflowing Hatred",
		bar_overflowingHatredCast = "Overflowing Hatred",
		msg_overflowingHatred = "Get away from boss! - Overflowing Hatred casting",
		warn_overflowingHatred = "HIDE",

		msg_portalsOpen = "80% HP - Portals Opening",
		msg_addPhase = "40% HP - Add Phase",
		bar_addPhase = "Add Phase",

		trigger_Enrage = "Sanv Tas'dal gains Enrage",
		msg_Enrage = "Enrage - Tranq now!",

		trigger_curseRift = "afflicted by Curse of the Rift",
		trigger_curseRiftImmune = "Curse of the Rift fails%.", -- triggers only on raid member immunity messages. Does not account for "Sanv Tas'dal's Curse of the Rift failed. You are immune." but it shouldn't be necessary
		bar_curseRift = "next Curse",
		
		trigger_riftFeedback = "Sanv Tas'dal's Rift Feedback",
		bar_riftFeedback = "Rift Feedback CD",
		msg_keepCurse = "Keep the Curse - Feedback soon!",
	}
end)

-- timer and icon variables
local timer = {
	phaseShiftedDuration = 25,
	overflowingHatredCast = 6,
	addPhase = 50,
	curseRift = 15, -- very reliable 15-16s interval
	riftFeedback = 45, -- lots of 47s and 53s cast-to-cast observed in logs; going with minimum CD because the only relevant info is when to keep Curse
}

local icon = {
	phaseShifted = "Spell_Shadow_AbominationExplosion",
	overflowingHatred = "Spell_Fire_Incinerate",
	addPhase = "Spell_Arcane_TeleportOrgrimmar",
	curseRift = "Spell_Shadow_GrimWard",
	riftFeedback = "Spell_Nature_Wispsplode",
}

local syncName = {
	phaseShifted = "SanvTasdalPhaseShifted" .. module.revision,
	phaseShiftedFade = "SanvTasdalPhaseShiftedFade" .. module.revision,
	overflowingHatred = "SanvTasdalOverflowingHatred" .. module.revision,
	curseRift = "SanvTasdalCurseRift" .. module.revision,
	riftFeedback = "SanvTasdalRiftFeedback" .. module.revision,
}

local guid = {
	sanv = "0xF13000EA4D05DA44",
}

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CastEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "CastEvent")
	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:ThrottleSync(3, syncName.phaseShifted)
	self:ThrottleSync(3, syncName.phaseShiftedFade)
	self:ThrottleSync(3, syncName.overflowingHatred)
	self:ThrottleSync(3, syncName.curseRift)
	self:ThrottleSync(3, syncName.riftFeedback)
end

function module:OnSetup()
	self.hitEighty = nil
	self.hitForty = nil
	self.nextFeedback = nil
end

function module:OnEngage()
	self.hitEighty = nil
	self.hitForty = nil
	self.nextFeedback = nil
	
	-- Start health monitoring
	self:ScheduleRepeatingEvent("CheckBossHealth", self.CheckBossHealth, 0.5, self)
end

function module:OnDisengage()
	if self:IsEventScheduled("CheckBossHealth") then
		self:CancelScheduledEvent("CheckBossHealth")
	end
end

function module:AfflictionEvent(msg)
	-- Phase Shifted
	if string.find(msg, L["trigger_phaseShiftedYou"]) then
		self:Sync(syncName.phaseShifted .. " " .. UnitName("player"))
	else
		local _, _, player = string.find(msg, L["trigger_phaseShiftedOther"])
		if player then
			self:Sync(syncName.phaseShifted .. " " .. player)
		end
	end
	
	-- Curse of the Rift
	if string.find(msg, L["trigger_curseRift"]) or string.find(msg, L["trigger_curseRiftImmune"])then
		self:Sync(syncName.curseRift)
	end
end

function module:CastEvent(msg)
	if string.find(msg, L["trigger_overflowingHatredCast"]) then
		self:Sync(syncName.overflowingHatred)
	elseif string.find(msg, L["trigger_riftFeedback"]) then
		self:Sync(syncName.riftFeedback)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if string.find(msg, L["trigger_phaseShiftedFade"]) then
		self:Sync(syncName.phaseShiftedFade .. " " .. UnitName("player"))
		self:RemoveBar(L["bar_phaseShiftedExpires"])
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	local _, _, player = string.find(msg, L["trigger_phaseShiftedFadeOther"])
	if player then
		self:Sync(syncName.phaseShiftedFade .. " " .. player)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if string.find(msg, L["trigger_Enrage"]) then
		self:Message(L["msg_Enrage"], "Important")
		local _, playerClass = UnitClass("player")
		if playerClass == "HUNTER" then
			self:Sound("Alert")
		end
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.phaseShifted and rest then
		self:PhaseShifted(rest)
	elseif sync == syncName.phaseShiftedFade and rest then
		self:PhaseShiftedFade(rest)
	elseif sync == syncName.overflowingHatred then
		self:OverflowingHatred()
	elseif sync == syncName.curseRift then
		self:CurseOfTheRift()
	elseif sync == syncName.riftFeedback then
		self:RiftFeedback()
	end
end

function module:PhaseShifted(player)
	if self.db.profile.phaseshifted and self.hitEighty then
		if player == UnitName("player") then
			self:Message(L["msg_phaseShiftedYou"], "Important", true, "Alarm")
			self:WarningSign(icon.phaseShifted, 5, false, L["warn_phaseShifted"])
			-- Add personal expiration bar with yellow color
			self:Bar(L["bar_phaseShiftedExpires"], timer.phaseShiftedDuration, icon.phaseShifted, true, "yellow")
		else
			self:Message(string.format(L["msg_phaseShiftedOther"], player), "Urgent")
		end
	end
end

function module:PhaseShiftedFade(player)
	-- Removed raid mark functionality
end

function module:OverflowingHatred()
	if self.db.profile.overflowinghatred then
		self:Message(L["msg_overflowingHatred"], "Important", nil, "Alarm")
		self:WarningSign(icon.overflowingHatred, 3, true, L["warn_overflowingHatred"])
		self:Bar(L["bar_overflowingHatredCast"], timer.overflowingHatredCast, icon.overflowingHatred, true, "Red")
	end
end

function module:CheckBossHealth()
	if UnitExists(guid.sanv) then
		local percent = UnitHealth(guid.sanv)/UnitHealthMax(guid.sanv) * 100

		if percent <= 80 and not self.hitEighty then
			self:Message(L["msg_portalsOpen"], "Attention", nil, "Alarm")
			self.hitEighty = true
		end
		if percent <= 40 and not self.hitForty then
			self:AddPhase()
			self.hitForty = true
			self:CancelScheduledEvent("CheckBossHealth")
		end
	end
end

function module:AddPhase()
	self:Message(L["msg_addPhase"], "Attention", nil, "Alarm")
	self:RemoveBar(L["bar_curseRift"])
	self:RemoveBar(L["bar_overflowingHatredCast"])
	if self.db.profile.addphase then
		self:Bar(L["bar_addPhase"], timer.addPhase, icon.addPhase, true, "blue")
	end
	self.nextFeedback = GetTime() + timer.addPhase + 10
end

function module:CurseOfTheRift()
	if self.db.profile.curseoftherift then
		self:RemoveBar(L["bar_curseRift"])
		self:Bar(L["bar_curseRift"], timer.curseRift, icon.curseRift, true, "White")
	end

	if self.nextFeedback and self.db.profile.keepcurse and self.nextFeedback - GetTime() < timer.curseRift then
		self:Message(L["msg_keepCurse"], "Positive", nil, "Info")
	end
end

function module:RiftFeedback()
	self.nextFeedback = GetTime() + timer.riftFeedback
	
	if self.db.profile.riftfeedback then
		self:RemoveBar(L["bar_riftFeedback"])
		self:Bar(L["bar_riftFeedback"], timer.riftFeedback, icon.riftFeedback, true, "Blue")	
	end
end

function module:Test()
	-- Initialize module state
	self:OnSetup()
	self:Engage()

	-- Store original player name
	local originalPlayer = UnitName("player")
	local testPlayerName1 = UnitName("raid1") or "TestPlayer1"
	local testPlayerName2 = UnitName("raid2") or "TestPlayer2"

	local events = {
		{ time = 4, func = function()
			self.hitEighty = true
		end },

		-- Phase Shifted events
		{ time = 5, func = function()
			local msg = testPlayerName1 .. " is afflicted by Phase Shifted"
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },

		{ time = 10, func = function()
			local msg = "Phase Shifted fades from " .. testPlayerName1
			print("Test: " .. msg)
			module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
		end },

		{ time = 15, func = function()
			local msg = "You are afflicted by Phase Shifted"
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },

		{ time = 27, func = function()
			local msg = "Phase Shifted fades from you"
			print("Test: " .. msg)
			module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
		end },

		{ time = 30, func = function()
			local msg = testPlayerName2 .. " is afflicted by Phase Shifted"
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },

		{ time = 35, func = function()
			local msg = testPlayerName2 .. " dies"
			print("Test: " .. msg)
			module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
		end },

		-- Curse of the Rift when others have FAP active
		{ time = 7, func = function() 
			local msg = "Sanv Tas'dal's Curse of the Rift fails. "..testPlayerName2.." is immune."
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },

		-- Test Curse of the Rift when others get it
		{ time = 22, func = function() 
			local msg = testPlayerName1 .. " is afflicted by Curse of the Rift"
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },

		-- Curse of the Rift when the player gets it
		{ time = 37, func = function()
			local msg = "You are afflicted by Curse of the Rift"
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },

		-- Curse of the Rift after Add Phase
		{ time = 84, func = function() 
			local msg = "Sanv Tas'dal's Curse of the Rift fails. "..testPlayerName2.." is immune."
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },

		-- Add Overflowing Hatred test
		{ time = 12, func = function()
			local msg = "Sanv Tas'dal begins to cast Overflowing Hatred"
			print("Test: " .. msg)
			module:CastEvent(msg)
		end },

		-- Add another Overflowing Hatred test
		{ time = 27, func = function()
			local msg = "Sanv Tas'dal begins to cast Overflowing Hatred"
			print("Test: " .. msg)
			module:CastEvent(msg)
		end },

		{ time = 29, func = function()
			print("Test: Forcing Add Phase (40%)")
			module:AddPhase()
			module.hitForty = true
		end },

		{ time = 36, func = function()
			local msg = "Sanv Tas'dal gains Enrage."
			print("Test: " .. msg)
			module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
		end },

		-- Rift Feedback hits
		{ time = 42, func = function()
			local msg = "Sanv Tas'dal's Rift Feedback hits "..testPlayerName1.." for 0 Arcane damage. (3000 resisted)"
			print("Test: " .. msg)
			module:CastEvent(msg)
		end },
		
		-- Test Rift Feedback resists
		{ time = 45, func = function()
			local msg = "Sanv Tas'dal's Rift Feedback was resisted by " .. testPlayerName2
			print("Test: " .. msg)
			module:CastEvent(msg)
		end },
		
		-- Rift Feedback after Add Phase
		{ time = 88, func = function()
			local msg = "Sanv Tas'dal's Rift Feedback was resisted by " .. testPlayerName1
			print("Test: " .. msg)
			module:CastEvent(msg)
		end },

		{ time = 95, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event at its absolute time
	for i, event in ipairs(events) do
		self:ScheduleEvent("SanvTasdalTest" .. i, event.func, event.time)
	end

	self:Message("Sanv Tasdal test started", "Positive")
	return true
end

-- Test command:
-- /run local m=BigWigs:GetModule("Sanv Tas'dal"); BigWigs:SetupModule("Sanv Tas'dal");m:Test();
