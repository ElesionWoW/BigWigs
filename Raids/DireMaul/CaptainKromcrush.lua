
local module, L = BigWigs:ModuleDeclaration("Captain Kromcrush", "Dire Maul")

module.revision = 30003
module.enabletrigger = module.translatedName
module.toggleoptions = {"retaliation", "adds", "fear", "bosskill"}
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Dire Maul"],
	AceLibrary("Babble-Zone-2.2")["Dire Maul"],
}

-- module defaults
module.defaultDB = {
	retaliation = true,
	adds = true,
	fear = true,
}

L:RegisterTranslations("enUS", function() return {
	cmd = "CaptainKromcrush",

	retaliation_cmd = "retaliation",
	retaliation_name = "Retaliation warnings",
	retaliation_desc = "Announces for his Retaliation ability",
	
	adds_cmd = "adds",
	adds_name = "Adds warnings",
	adds_desc = "Announces when adds are summoned",
	
	fear_cmd = "fear",
	fear_name = "Fear warnings",
	fear_desc = "Fear timer bars",
	
	fearTrigger = "afflicted by Intimidating Shout",
	fearTrigger2 = "Intimidating Shout fail",
	fearMessage = "Feared",
	fearBar = "Fear CD",
	
	retaliationUpTrigger = "Captain Kromcrush gains Retaliation",
	retaliationUpMessage = "Retaliation! Stop melee damage!",
	retaliationUpBar = "Retaliation",
	
	retaliationDownTrigger = "Retaliation fades from Captain Kromcrush",
	retaliationDownMessage = "Retaliation faded! Melee damage go!",
	
	retaliationHurtTrigger = "Captain Kromcrush's Retaliation hits you for",
	retaliationHurtMessage = "Stop Attacking!",
	
	addsTrigger = "Help me crush these punys",
	addsUpMessage = "Adds are up!",
} end)

local timer = {
	retaliation = 15,
	fear = 11.4,
}

local icon = {
	retaliation = "ability_warrior_challange",
	fear = "spell_shadow_possession",
	sheep = "spell_nature_polymorph",
	trap = "spell_frost_chainsofice",
	tremor = "spell_nature_tremortotem",
}

local syncName = {
}

local _, playerClass = UnitClass("player")

local lastFear = 0

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "Event")
	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
end

function module:OnSetup()

end

function module:OnEngage()
	if playerClass == "SHAMAN" and self.db.profile.fear then
		self:WarningSign(icon.tremor, 0.7)
		self:Sound("Beware")
	end
	self:Bar(L["fearBar"], timer.fear, icon.fear, true, "white")
end

function module:OnDisengage()

end

function module:Event(msg)
	if string.find(msg, L["fearTrigger"]) or string.find(msg, L["fearTrigger2"]) then
		self:Fear()
	end
	if string.find(msg, L["addsTrigger"]) then
		self:AddsUp()
	end
	if string.find(msg, L["retaliationUpTrigger"]) then
		self:RetaliationUp()
	end
	if string.find(msg, L["retaliationDownTrigger"]) then
		self:RetaliationDown()
	end
	if string.find(msg, L["retaliationHurtTrigger"]) then
		self:RetaliationHurt()
	end
end

function module:AddsUp()
	if not self.db.profile.adds then
		return
	end
	
	if playerClass == "PRIEST" or playerClass == "WARLOCK" then
		self:WarningSign(icon.fear, 0.7)
	end
	if playerClass == "MAGE" then
		self:WarningSign(icon.sheep, 0.7)
	end
	if playerClass == "HUNTER" then
		self:WarningSign(icon.trap, 0.7)
	end
	self:Message(L["addsUpMessage"], "Urgent", false, "Beware", false)
end

function module:Fear()
	if not self.db.profile.fear then
		return
	end
	
	if GetTime() > lastFear + 2 then
		lastFear = GetTime()
		self:Message(L["fearMessage"], "Attention", false, "Alarm", false)
		self:Bar(L["fearBar"], timer.fear, icon.fear, true, "white")
	end
end

function module:RetaliationUp()
	if self.db.profile.retaliation then
		self:Message(L["retaliationUpMessage"], "Important", false, "Beware", false)
		self:Bar(L["retaliationUpBar"], timer.retaliation, icon.retaliation, true, "red")
		self:WarningSign(icon.retaliation, timer.retaliation)
	end
end

function module:RetaliationDown()
	if self.db.profile.retaliation then
		self:Message(L["retaliationDownMessage"], "Important", false, "Long", false)
		self:RemoveBar(L["retaliationUpBar"])
		self:RemoveWarningSign(icon.retaliation)
	end
end

function module:RetaliationHurt()
	if self.db.profile.retaliation then
		self:Message(L["retaliationHurtMessage"], "Urgent", false, "Info", false)
	end
end


function module:Test()
	-- Initialize module state
	self:Engage()

	local events = {
		-- Fear
		{ time = 11.5, func = function()
			local msg = "You are afflicted by Intimidating Shout."
			print("Test: " .. msg)
			module:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		-- Add summon at 50%
		{ time = 15, func = function()
			local msg = "Help me crush these punys!"
			print("Test: " .. msg)
			module:TriggerEvent("CHAT_MSG_MONSTER_YELL", msg)
		end },
		-- Retaliation start
		{ time = 20, func = function()
			local msg = "Captain Kromcrush gains Retaliation."
			print("Test: " .. msg)
			module:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", msg)
		end },
		-- Retaliation hurt
		{ time = 24, func = function()
			local msg = "Captain Kromcrush's Retaliation hits you for 1716."
			print("Test: " .. msg)
			module:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		-- Retaliation hurt
		{ time = 25, func = function()
			local msg = "Captain Kromcrush's Retaliation hits you for 1682."
			print("Test: " .. msg)
			module:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		-- Retaliation end
		{ time = 35, func = function()
			local msg = "Retaliation fades from Captain Kromcrush."
			print("Test: " .. msg)
			module:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", msg)
		end },

		-- End of Test
		{ time = 40, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event at its absolute time
	for i, event in ipairs(events) do
		self:ScheduleEvent("KromcrushTest" .. i, event.func, event.time)
	end

	self:Message("Captain Kromcrush test started", "Positive")
	return true
end

-- Test command:
-- /run local m=BigWigs:GetModule("Captain Kromcrush"); BigWigs:SetupModule("Captain Kromcrush");m:Test();
