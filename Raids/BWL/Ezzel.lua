local module, L = BigWigs:ModuleDeclaration("Ezzel Darkbrewer", "Blackwing Lair")

-- module variables
module.revision = 30138
module.enabletrigger = module.translatedName
module.toggleoptions = { "charge", "chargemark", "precharge", "chemicalRage", "acid", "transmute", "tongues", "bosskill" }

-- module defaults
module.defaultDB = {
	charge = true,
	chargemark = true,
	precharge = true,
	chemicalRage = true,
	acid = true,
	transmute = true,
	tongues = true,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "EzzelDarkbrewer",

		charge_cmd = "charge",
		charge_name = "Charge Alert",
		charge_desc = "Alerts about incoming Charges",

		chargemark_cmd = "chargemark",
		chargemark_name = "Charge Mark",
		chargemark_desc = "Mark Charge victims with Triangle",

		precharge_cmd = "precharge",
		precharge_name = "Charge Soon Alert",
		precharge_desc = "Warns a few seconds before an upcoming Charge",

		chemicalRage_cmd = "chemicalRage",
		chemicalRage_name = "Chemical Rage",
		chemicalRage_desc = "Shows a bar while the boss has 80% damage reduction",

		acid_cmd = "acid",
		acid_name = "Acid Alert",
		acid_desc = "Warns when you are standing in Acid",

		transmute_cmd = "transmute",
		transmute_name = "Transmute to Gold Alert",
		transmute_desc = "Warns when the boss begins to cast Transmute to Gold (wipe mechanic)",

		tongues_cmd = "tongues",
		tongues_name = "Curse of Tongues Alert",
		tongues_desc = "Warns 5% before the boss begins to cast Transmute if Curse of Tongues is not on the boss",

		trigger_charge = "Raka begins charging (.+)!",
		bar_charge = "Charge on %s",
		say_charge = "Charge On Me!",
		warn_charge = "HIDE",
		msg_preCharge = "Charge soon!",

		trigger_concussion = "Ezzel Darkbrewer .+ Concussion%.",
		msg_chemicalRage = "Chemical Rage - 80% damage reduction until he hits a pillar",
		bar_chemicalRage = "Damage Reduction active",

		trigger_acid = "You are affliced by Acid Bomb",
		trigger_acidTick = "You suffer (.+) damage from Ezzel Darkbrewer's Acid Bomb",
		warn_acid = "ACID - MOVE",

		trigger_transmute = "Ezzel Darkbrewer begins to cast Transmute to Gold",
		bar_transmute = "Kill Boss",
		warn_tongues = "CoT missing!",
	}
end)

-- timer and icon variables
local timer = {
	charge = 8,
	transmute = 8,
}

local icon = {
	charge = "ABILITY_MOUNT_MOUNTAINRAM",
	chemicalRage = "Spell_Nature_AncestralGuardian",
	acid = "ABILITY_CREATURE_POISON_06",
	transmute = "SPELL_HOLY_HARMUNDEADAURA",
	tongues = "Spell_Shadow_CurseOfTounges",
}

local syncName = {
	charge = "EzzelCharge" .. module.revision,
	concussion = "EzzelConcussion" .. module.revision,
	transmute = "EzzelTransmute" .. module.revision,
}

local spellId = {
	tongues = 11719,
}

local guid = {
	ezzel = "0xF13000FE7C279933",
}

local nextHealthThreshold = 80

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CastEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "CastEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "EnemyDebuffEvent")
	
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:ThrottleSync(3, syncName.charge)
	self:ThrottleSync(3, syncName.concussion)
	self:ThrottleSync(3, syncName.transmute)
end

function module:OnSetup()
end

function module:OnEngage()
	if self.core:IsModuleActive("Blackwing Alchemist", "Blackwing Lair") then
		self.core:DisableModule("Blackwing Alchemist", "Blackwing Lair")
	end

	nextHealthThreshold = 80
	-- Start health monitoring
	self:ScheduleRepeatingEvent("CheckBossHealth", self.CheckBossHealth, 0.5, self)
end

function module:OnDisengage()
end

function module:AfflictionEvent(msg)
	if self.db.profile.acid and (string.find(msg, L["trigger_acid"]) or string.find(msg, L["trigger_acidTick"]) )then
		self:Sound("Info")
		self:WarningSign(icon.acid, 1, false, L["warn_acid"])
	end
end

function module:CastEvent(msg)
	if string.find(msg, L["trigger_transmute"]) then
		self:Sync(syncName.transmute)
	end
end

function module:EnemyDebuffEvent(msg)
	if string.find(msg, L["trigger_concussion"]) then
		self:Sync(syncName.concussion)
	end
end

function module:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	local _, _, player = string.find(msg, L["trigger_charge"])
	if player then
		self:Sync(syncName.charge .. " " .. player)
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.transmute then
		self:TransmuteToGold()
	elseif sync == syncName.concussion then
		self:RemoveBar(L["bar_chemicalRage"])
	elseif sync == syncName.charge and rest then
		self:Charge(rest)
	end
end

function module:TransmuteToGold()
	if not self.db.profile.transmute then return end

	self:Bar(L["bar_transmute"], timer.transmute * BigWigs:GetCastTimeCoefficient(guid.ezzel), icon.transmute)
	self:Sound("Beware")
end

function module:Charge(player)
	if self.db.profile.charge then
		self:Bar(string.format(L["bar_charge"],player), timer.charge * BigWigs:GetCastTimeCoefficient(guid.ezzel), icon.charge)
		if player == UnitName("player") then
			self:WarningSign(icon.charge, 4, true, L["warn_charge"])
			self:Sound("RunAway")
			SendChatMessage(L["say_charge"], "SAY")
		else
			self:Sound("Alarm")
		end
	end

	if self.db.profile.chargemark then
		self:SetRaidTargetForPlayer(player, "Triangle")
		self:ScheduleEvent("RemoveChargeMark", self.RestoreInitialRaidTargetForPlayer, timer.charge * BigWigs:GetCastTimeCoefficient(guid.ezzel), self, player)
	end

	if self.db.profile.chemicalRage then
		self:Bar(L["bar_chemicalRage"], 600, icon.chemicalRage, true, "Cyan")
		self:Message(L["msg_chemicalRage"], "Core", nil, false)
	end
end

function module:CheckBossHealth(testValue)
	local percent = BigWigs:GetHealthPercent(guid.ezzel) or testValue or 100
	if percent < 15 then
		if self.db.profile.tongues and not BigWigs:AuraIsPresent(guid.ezzel, spellId.tongues) then
			self:WarningSign(icon.tongues, 1, false, L["warn_tongues"])
			self:Sound("Alert")
		end
		self:CancelScheduledEvent("CheckBossHealth")
	end
	if percent < nextHealthThreshold then
		if self.db.profile.precharge then
			self:Message(L["msg_preCharge"], "Attention")
		end
		nextHealthThreshold = nextHealthThreshold - 25
	end
end

function module:Test()
	self:Engage()
	
	-- test characters
	local player = UnitName("player")
	local raid1 = UnitName("raid1") or "Raid1"
	local raid2 = UnitName("raid2") or "Raid2"
	
	local events = {
		-- Acid
		{ time = 2, func = function()
			local msg = "You are affliced by Acid Bomb"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 3, func = function()
			local msg = "You suffer 450 Nature damage from Ezzel Darkbrewer's Acid Bomb."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },
		{ time = 4, func = function()
			local msg = "You suffer 0 Nature damage from Ezzel Darkbrewer's Acid Bomb. (405 absorbed)"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
		end },

		-- Charge
		{ time = 7, func = function()
			print("Test: boss at 79% HP")
			self:CheckBossHealth(79)
		end },
		{ time = 8, func = function()
			local msg = "Ton'Raka begins charging "..raid1.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
		end },
		{ time = 17, func = function()
			local msg = "Ezzel Darkbrewer is afflicted by Concussion."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", msg)
		end },
		{ time = 21, func = function()
			print("Test: boss at 54% HP")
			self:CheckBossHealth(54)
		end },
		{ time = 22, func = function()
			local msg = "Ton'Raka begins charging "..player.."!"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
		end },
		{ time = 31, func = function()
			local msg = "Ezzel Darkbrewer gains Concussion."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", msg)
		end },

		-- Transmute
		{ time = 33, func = function()
			print("Test: boss at 14% HP")
			self:CheckBossHealth(14)
		end },
		{ time = 34, func = function()
			local msg = "Ezzel Darkbrewer begins to cast Transmute to Gold."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", msg)
		end },

		-- End of Test
		{ time = 44, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}
	
	-- Schedule each event
	for i, event in ipairs(events) do
		self:ScheduleEvent("EzzelTest" .. i, event.func, event.time)
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end

-- Test command: /run BigWigs:GetModule("Ezzel Darkbrewer"):Test()
