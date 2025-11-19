local module, L = BigWigs:ModuleDeclaration("Sanv Tas'dal", "Karazhan")

-- module variables
module.revision = 30002
module.enabletrigger = module.translatedName
module.toggleoptions = { "phaseshifted", "overflowinghatred", "addphase", "bosskill" }
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
	}
end)

-- timer and icon variables
local timer = {
	phaseShiftedDuration = 25,
	overflowingHatredCast = 6,
	addPhase = 50,
}

local icon = {
	phaseShifted = "Spell_Shadow_AbominationExplosion",
	overflowingHatred = "Spell_Fire_Incinerate",
	addPhase = "Spell_Arcane_TeleportOrgrimmar"
}

local color = {
	red = "Red",
}

local syncName = {
	phaseShifted = "SanvTasdalPhaseShifted" .. module.revision,
	phaseShiftedFade = "SanvTasdalPhaseShiftedFade" .. module.revision,
	overflowingHatred = "SanvTasdalOverflowingHatred" .. module.revision,
}

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "BeginsCastEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "BeginsCastEvent")
	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:ThrottleSync(3, syncName.phaseShifted)
	self:ThrottleSync(3, syncName.phaseShiftedFade)
	self:ThrottleSync(3, syncName.overflowingHatred)
end

function module:OnSetup()
	self.bossHealth = 100
	self.hitEighty = nil
	self.hitFourty = nil
end

function module:OnEngage()
	self.bossHealth = 100
	self.hitEighty = nil
	self.hitFourty = nil
	
	-- Start health monitoring
	self:ScheduleRepeatingEvent("CheckBossHealth", self.CheckBossHealth, 1, self)
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
end

function module:BeginsCastEvent(msg)
	if string.find(msg, L["trigger_overflowingHatredCast"]) then
		self:Sync(syncName.overflowingHatred)
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
		self:Bar(L["bar_overflowingHatredCast"], timer.overflowingHatredCast, icon.overflowingHatred, true, color.red)
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

				if self.bossHealth <= 80 and not self.hitEighty then
					self:Message(L["msg_portalsOpen"], "Attention", nil, "Alarm")
					self.hitEighty = true
				end
				if self.bossHealth <= 40 and not self.hitFourty then
					self:Message(L["msg_addPhase"], "Attention", nil, "Alarm")
					if self.db.profile.addphase then
						self:Bar(L["bar_addPhase"], timer.addPhase, icon.addPhase, true, "blue")
					end
					self.hitFourty = true
				end
				break
			end
		end
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

		-- Add Overflowing Hatred test
		{ time = 12, func = function()
			local msg = "Sanv Tas'dal begins to cast Overflowing Hatred"
			print("Test: " .. msg)
			module:BeginsCastEvent(msg)
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

		-- Add another Overflowing Hatred test
		{ time = 27, func = function()
			local msg = "Sanv Tas'dal begins to cast Overflowing Hatred"
			print("Test: " .. msg)
			module:BeginsCastEvent(msg)
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

		{ time = 36, func = function()
			local msg = "Sanv Tas'dal gains Enrage."
			print("Test: " .. msg)
			module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
		end },

		{ time = 40, func = function()
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
