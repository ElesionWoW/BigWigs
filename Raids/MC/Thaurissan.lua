local module, L = BigWigs:ModuleDeclaration("Sorcerer-Thane Thaurissan", "Molten Core")

-- module variables
module.revision = 30000
module.enabletrigger = module.translatedName
module.toggleoptions = { "runes", "bosskill" }

-- module defaults
module.defaultDB = {
	runes = true,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "Thaurissan",

		runes_cmd = "runes",
		runes_name = "Runes",
		runes_desc = "Warns about Runes of Detonation and Combustion",

		trigger_detonation = "afflicted by Rune of Detonation",
		trigger_combustion = "afflicted by Rune of Combustion",
		trigger_you = "You are afflicted",
		msg_detonation = "Get out of the Zone - Rune of Detonation",
		msg_combustion = "Get into the Zone - Rune of Combustion",
		bar_detonation = "Detonation (get out)",
		bar_combustion = "Combustion (get in)",
	}
end)

-- timer and icon variables
local timer = {
	runeCooldown = 20,
	runeDuration = 6,
}

local icon = {
	detonation = "Spell_Shadow_Teleport",
	combustion = "Spell_Fire_SealOfFire",
}

local color = {
	detonation = "Blue",
	combustion = "Orange",
}

local syncName = {
	detonation = "MCThaurissanDetonation" .. module.revision,
	combustion = "MCThaurissanCombusion" .. module.revision,
}

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")

	self:ThrottleSync(10, syncName.detonation)
	self:ThrottleSync(10, syncName.combustion)
end

function module:OnSetup()
	self.started = nil
end

function module:OnEngage()
	if self.db.profile.runes then
		self:Bar(L["bar_detonation"], timer.runeCooldown + timer.runeDuration, icon.detonation, true, color.detonation)
	end
end

function module:OnDisengage()
	self:CancelDelayedBar(L["bar_detonation"])
	self:CancelDelayedBar(L["bar_combustion"])
end

function module:AfflictionEvent(msg)
	-- Rune of Detonation
	if string.find(msg, L["trigger_detonation"]) then
		self:Sync(syncName.detonation)
		if string.find(msg, L["trigger_you"]) then
			self:DetonationSelf()
		end
	end
	
	-- Rune of Combustion
	if string.find(msg, L["trigger_combustion"]) then
		self:Sync(syncName.combustion)
		if string.find(msg, L["trigger_you"]) then
			self:CombustionSelf()
		end
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.detonation then
		self:DetonationCast()
	elseif sync == syncName.combustion then
		self:CombustionCast()
	end
end

function module:CombustionCast()
	-- schedule next opposite rune
	if self.db.profile.runes then
		self:DelayedBar(timer.runeDuration, L["bar_detonation"], timer.runeCooldown, icon.detonation, true, color.detonation)
	end
end

function module:DetonationCast()
	-- schedule next opposite rune
	if self.db.profile.runes then
		self:DelayedBar(timer.runeDuration, L["bar_combustion"], timer.runeCooldown, icon.combustion, true, color.combustion)
	end
end

function module:CombustionSelf()
	if self.db.profile.runes then
		-- adjust timer for precision
		self:Bar(L["bar_combustion"], timer.runeDuration, icon.combustion, true, color.combustion)
		-- put up warning message since player is affected
		self:Message(L["msg_combustion"], "Urgent", true, "Beware")
	end
end

function module:DetonationSelf()
	if self.db.profile.runes then
		-- adjust timer for precision
		self:Bar(L["bar_detonation"], timer.runeDuration, icon.detonation, true, color.detonation)
		-- put up warning message since player is affected
		self:Message(L["msg_detonation"], "Urgent", true, "Beware")
	end
end

function module:Test()
	-- Initialize module state
	self:Engage()

	local events = {
		-- Late first cast
		{ time = 20.5, func = function()
			local msg = "You are afflicted by Rune of Detonation"
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },
		{ time = 20.5, func = function()
			local msg = "Raider is afflicted by Rune of Detonation"
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },
		
		-- Early second cast
		{ time = 40, func = function()
			local msg = "You are afflicted by Rune of Combustion."
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },
		{ time = 40, func = function()
			local msg = "Sorcerer-Thane Thaurissan's Rune of Combustion fails. Raider is immune."
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },
		
		-- Third cast
		{ time = 60, func = function()
			local msg = "Sorcerer-Thane Thaurissan's Rune of Detonation was resisted by you."
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },
		{ time = 60, func = function()
			local msg = "Raider is afflicted by Rune of Detonation"
			print("Test: " .. msg)
			module:AfflictionEvent(msg)
		end },
		
		-- End of Test
		{ time = 65, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event at its absolute time
	for i, event in ipairs(events) do
		self:ScheduleEvent("ThaurissanTest" .. i, event.func, event.time)
	end

	self:Message("Thaurissan test started", "Positive")
	return true
end

-- Test command:
-- /run local m=BigWigs:GetModule("Sorcerer-Thane Thaurissan"); BigWigs:SetupModule("Sorcerer-Thane Thaurissan");m:Test();
