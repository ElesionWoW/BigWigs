local module, L = BigWigs:ModuleDeclaration("Selenaxx Foulheart", "Timbermaw Hold")

-- module variables
module.revision = 30138
module.enabletrigger = module.translatedName
module.toggleoptions = { "rainoffire", "bosskill" }

-- module defaults
module.defaultDB = {
	rainoffire = true,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "Selenaxx",

		rainoffire_cmd = "rainoffire",
		rainoffire_name = "Rain of Destruction zone",
		rainoffire_desc = "Personal warning when you stand in Rain of Destruction",

		trigger_engage = "The master's plan shall not be interrupted!",

		trigger_rainoffire = "You are afflicted by Rain of Destruction",
		trigger_rainoffireTick = "You suffer .+ Fire damage from Selenaxx Foulheart's Rain of Destruction",
		warn_rainoffire = "MOVE",
		trigger_rainoffireFade = "Rain of Destruction fades from you.",
	}
end)

-- timer and icon variables
local timer = {
	rainoffire = 10,
}

local icon = {
	rainoffire = "Spell_Shadow_RainOfFire",
}

local syncName = {
}

local guid = {
	selenaxx = "0xF13000F5DC279589",
}

local spellId = {
}

module:RegisterYellEngage(L["trigger_engage"])

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "FadesEvent")
end

function module:OnSetup()
end

function module:OnEngage()
end

function module:OnDisengage()
end

function module:AfflictionEvent(msg)
	if self.db.profile.rainoffire then
		if string.find(msg, L["trigger_rainoffire"]) then
			self:Sound("Info")
			self:WarningSign(icon.rainoffire, timer.rainoffire, false, L["warn_rainoffire"])
			return
		elseif string.find(msg, L["trigger_rainoffireTick"]) then
			self:Sound("Info")
			return
		end
	end
end

function module:FadesEvent(msg)
	if self.db.profile.rainoffire and msg == L["trigger_rainoffireFade"] then
		self:RemoveWarningSign(icon.rainoffire)
		self:Sound("Long")
	end
end

function module:Test()
	self:Engage()

	-- test characters
	local player = UnitName("player")
	local raid1 = UnitName("raid1") or "Raid1"
	local raid2 = UnitName("raid2") or "Raid2"

	local events = {
		-- Zone 1
		{ time = 2, func = function()
			local msg = "You are afflicted by Rain of Destruction."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 3, func = function()
			local msg = "You suffer 1080 Fire damage from Selenaxx Foulheart's Rain of Destruction."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 4, func = function()
			local msg = "You suffer 1200 Fire damage from Selenaxx Foulheart's Rain of Destruction."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 4.8, func = function()
			local msg = "Rain of Destruction fades from you."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
		end },

		-- Zone 2
		{ time = 15, func = function()
			local msg = "You are afflicted by Rain of Destruction."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 16, func = function()
			local msg = "You suffer 1320 Fire damage from Selenaxx Foulheart's Rain of Destruction."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 16.2, func = function()
			local msg = "Rain of Destruction fades from you."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
		end },

		-- End of Test
		{ time = 20, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event
	for i, event in ipairs(events) do
		self:ScheduleEvent("SelenaxxTest" .. i, event.func, event.time)
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end

-- Test command: /run BigWigs:GetModule("Selenaxx Foulheart"):Test()
