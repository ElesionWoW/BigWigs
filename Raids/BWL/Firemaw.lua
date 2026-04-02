
local module, L = BigWigs:ModuleDeclaration("Firemaw", "Blackwing Lair")

module.revision = 30085
module.enabletrigger = module.translatedName
module.toggleoptions = {"wingbuffet", "shadowflame", "sfzonealert", "sfzonebar", "sfexplosion", "flamebuffet", "stacks", "bosskill"}

-- module defaults
module.defaultDB = {
	wingbuffet = true,
	shadowflame = true,
	sfzonealert = true,
	sfzonebar = true,
	sfexplosion = true,
	flamebuffet = false,
	stacks = true,
}

L:RegisterTranslations("enUS", function() return {
	cmd = "Firemaw",
	
	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet Alert",
	wingbuffet_desc = "Warn for Wing Buffet",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame Alert",
	shadowflame_desc = "Warn for Shadow Flame casts (requires someone to have SuperWoW) and Shadow Flame CD",

	sfzonealert_cmd = "sfzonealert",
	sfzonealert_name = "Shadowflame Zone Alert",
	sfzonealert_desc = "Warns when new floor zones (Shadowflame Jet) spawn",

	sfzonebar_cmd = "sfzonebar",
	sfzonebar_name = "Shadowflame Zone Bar",
	sfzonebar_desc = "Shows timer bars for floor zones (Shadowflame Jet)",

	sfexplosion_cmd = "sfexplosion",
	sfexplosion_name = "Shadowflame Explosion Alert",
	sfexplosion_desc = "Warns when Shadowflame Explosions happen (unsoaked floor zones)",
	
	flamebuffet_cmd = "flamebuffet",
	flamebuffet_name = "Flame Buffet Alert",
	flamebuffet_desc = "Warn for Flame Buffet",
	
	stacks_cmd = "stacks",
	stacks_name = "High Flame Buffet Stacks Alert",
	stacks_desc = "Warn for High Flame Buffet Stacks",
	
	
	trigger_wingBuffet = "Firemaw begins to cast Wing Buffet.", --CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE
	bar_wingBuffetCast = "Casting Wing Buffet!",
	bar_wingBuffetCd = "Wing Buffet CD",
	msg_wingBuffetCast = "Casting Wing Buffet!",
	msg_wingBuffetSoon = "Wing Buffet in 2 seconds - Taunt now!",
	
	trigger_shadowFlameCast = "Firemaw begins to cast Shadow Flame.", --CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE - seems to no longer appear in logs since 1.18
	bar_shadowFlameCast = "Casting Shadow Flame!",
	msg_shadowFlameCast = "Casting Shadow Flame!",
	trigger_shadowFlameHit = "Firemaw's Shadow Flame hits", --CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE
	bar_shadowFlameCd = "Shadow Flame CD",
	
	msg_sfzone = "Look for new Floor Zones!",
	bar_sfzoneFind = "find new Zone(s)",
	bar_sfzone = "soak Floor Zone(s)",
	trigger_sfexplosion = "Shadowflame Jet's Shadowflame Explosion", --CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE // etc
	warn_sfexplosion = "Unsoaked Zone!",
	
	trigger_flameBuffet = "Firemaw's Flame Buffet", --CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE // CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE // CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE
		--Firemaw's Flame Buffet fails. (.+) is immune.
		--Firemaw's Flame Buffet was resisted by (.+).
		--Firemaw's Flame Buffet was resisted.
		--Firemaw's Flame Buffet hits (.+) for (.+) Fire damage.
		--Firemaw's Flame Buffet is absorbed by (.+).
		--You absorb Firemaw's Flame Buffet.
	bar_flameBuffet = "Flame Buffet",
	
	trigger_flameBuffetYou = "You are afflicted by Flame Buffet %((.+)%).", --CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE
	msg_flameBuffetYou = " Flame Buffet Stacks - Consider losing your stacks",
} end)

local timer = {
	wingBuffetFirstCd = 30,
	wingBuffetCd = 29, --30sec - 1sec cast
	wingBuffetCast = 1,
	
	shadowFlameFirstCd = 16,
	shadowFlameCd = 14, --16 - 2sec cast
	shadowFlameCast = 2,
	
	sfzonePre = 4,
	sfzoneDur = 8,
	
	flameBuffet = {1.913,4.936}, --saw 1.913 to 4.936
}
local icon = {
	wingBuffet = "INV_Misc_MonsterScales_14",
	shadowFlame = "Spell_Fire_Incinerate",
	flameBuffet = "Spell_Fire_Fireball",
	sfzone = "spell_shadow_antishadow",
	sfexplosion = "Spell_Fire_SelfDestruct",
}
local color = {
	wingBuffetCd = "Cyan",
	wingBuffetCast = "Blue",
	
	shadowFlameCd = "Orange",
	shadowFlameCast = "Red",
	sfzone = "Black",
	
	flameBuffet = "Black"
}
local syncName = {
	wingBuffet = "FiremawWingBuffet"..module.revision,
	shadowFlameCast = "FiremawShadowflame"..module.revision,
	shadowFlameHit = "FiremawShadowflameHit"..module.revision,
	sfexplosion = "FiremawShadowflameExplosion"..module.revision,
	flameBuffet = "FiremawFlameBuffet"..module.revision,
}
local spellId = {
	shadowFlame = 22539,
}

local zoneWarned = false

function module:OnEnable()
	--self:RegisterEvent("CHAT_MSG_SAY", "Event") --Debug
	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event") --trigger_flameBuffet, trigger_sfexplosion, trigger_shadowFlameHit
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event") --trigger_flameBuffet, trigger_sfexplosion, trigger_shadowFlameHit
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event") --trigger_wingBuffet, trigger_shadowFlameCast, trigger_flameBuffet, trigger_sfexplosion, trigger_shadowFlameHit
	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event") --trigger_flameBuffetYou
	
	if SUPERWOW_VERSION or SetAutoloot then
		self:RegisterEvent("UNIT_CASTEVENT")
	end
	
	self:ThrottleSync(3, syncName.wingBuffet)
	self:ThrottleSync(3, syncName.shadowFlameCast)
	self:ThrottleSync(3, syncName.shadowFlameHit)
	self:ThrottleSync(1.5, syncName.sfexplosion)
	self:ThrottleSync(1.5, syncName.flameBuffet)
end

function module:OnSetup()
	self.started = nil
end

function module:OnEngage()
	if self.db.profile.wingbuffet then
		self:Bar(L["bar_wingBuffetCd"], timer.wingBuffetFirstCd, icon.wingBuffet, true, color.wingBuffetCd)
		self:DelayedMessage(timer.wingBuffetFirstCd - 2, L["msg_wingBuffetSoon"], "Attention", false, nil, false)
	end
	
	if self.db.profile.shadowflame then
		self:Bar(L["bar_shadowFlameCd"], timer.shadowFlameCd, icon.shadowFlame, true, color.shadowFlameCd)
	end
	
	if self.db.profile.flamebuffet then
		self:IntervalBar(L["bar_flameBuffet"], timer.flameBuffet[1], timer.flameBuffet[2], icon.flameBuffet, true, color.flameBuffet)
	end
end

function module:OnDisengage()
end

function module:Event(msg)
	if msg == L["trigger_wingBuffet"] then
		self:Sync(syncName.wingBuffet)
	
	elseif msg == L["trigger_shadowFlameCast"] then
		self:Sync(syncName.shadowFlameCast)
	
	elseif string.find(msg, L["trigger_shadowFlameHit"]) then
		self:Sync(syncName.shadowFlameHit)
	
	elseif string.find(msg, L["trigger_sfexplosion"]) then
		self:Sync(syncName.sfexplosion)
	
	elseif string.find(msg, L["trigger_flameBuffet"]) then
		self:Sync(syncName.flameBuffet)
	
	elseif string.find(msg, L["trigger_flameBuffetYou"]) and self.db.profile.stacks then
		local _,_,stacks,_ = string.find(msg, L["trigger_flameBuffetYou"])
		local stacksNum = tonumber(stacks)
		if stacksNum >= 8 then
			self:FlameBuffetStacks(stacksNum)
		end
	end
end

function module:UNIT_CASTEVENT(caster,target,action,spell,castTime)
	if spell == spellId.shadowFlame and action == "START" then
		self:Sync(syncName.shadowFlameCast)
		self:DelayedSync(castTime/1000, syncName.shadowFlameHit)
		return
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.wingBuffet and self.db.profile.wingbuffet then
		self:WingBuffet()
	elseif sync == syncName.shadowFlameCast and self.db.profile.shadowflame then
		self:RemoveBar(L["bar_shadowFlameCd"])
		self:Bar(L["bar_shadowFlameCast"], timer.shadowFlameCast, icon.shadowFlame, true, color.shadowFlameCast)
		self:Message(L["msg_shadowFlameCast"], "Urgent", false, nil, false)
	elseif sync == syncName.shadowFlameHit then
		self:ShadowFlameHit()
	elseif sync == syncName.sfexplosion then
		self:ShadowflameExplosion()
	elseif sync == syncName.flameBuffet and self.db.profile.flamebuffet then
		self:FlameBuffet()
	end
end


function module:WingBuffet()
	self:CancelDelayedMessage(L["msg_wingBuffetSoon"])
	self:RemoveBar(L["bar_wingBuffetCd"])
	
	self:Bar(L["bar_wingBuffetCast"], timer.wingBuffetCast, icon.wingBuffet, true, color.wingBuffetCast)
	
	self:DelayedBar(timer.wingBuffetCast, L["bar_wingBuffetCd"], timer.wingBuffetCd, icon.wingBuffet, true, color.wingBuffetCd)
	self:DelayedMessage(timer.wingBuffetCast + timer.wingBuffetCd - 2, L["msg_wingBuffetSoon"], "Attention", false, nil, false)
end

function module:ShadowFlameHit()
	if self.db.profile.shadowflame then
		self:RemoveBar(L["bar_shadowFlameCd"])

		self:Bar(L["bar_shadowFlameCd"], timer.shadowFlameCd, icon.shadowFlame, true, color.shadowFlameCd)
	end

	if self.db.profile.sfzonealert then
		self:Message(L["msg_sfzone"], "Core")
	end
	if self.db.profile.sfzonebar then
		self:Bar(L["bar_sfzoneFind"], timer.sfzonePre, icon.sfzone, true, color.sfzone)
		self:DelayedBar(timer.sfzonePre, L["bar_sfzone"], timer.sfzoneDur, icon.sfzone, true, color.sfzone)
	end
	zoneWarned = false
end

function module:FlameBuffet()
	self:IntervalBar(L["bar_flameBuffet"], timer.flameBuffet[1], timer.flameBuffet[2], icon.flameBuffet, true, color.flameBuffet)
end

function module:FlameBuffetStacks(stacksNum)
	--don't bother if you are tanking
	if UnitName("Target") == "Firemaw" and UnitName("TargetTarget") == UnitName("Player") then return end
	
	self:Message(stacksNum..L["msg_flameBuffetYou"], "Personal", false, nil, false)
	self:WarningSign(icon.flameBuffet, 0.7)
	self:Sound("Info")
end

function module:ShadowflameExplosion()
	if self.db.profile.sfexplosion then	 
		self:WarningSign(icon.sfexplosion, 1, false, L["warn_sfexplosion"])
		if zoneWarned then
			self:Sound("Alarm")
		else
			self:Sound("Beware")
			zoneWarned = true
		end
	end
end

function module:Test() -- missing Wing Buffet and Flame Buffet
	self:Engage()
	
	-- test characters
	local player = UnitName("player")
	local raid1 = UnitName("raid1") or "Raid1"
	local raid2 = UnitName("raid2") or "Raid2"
	
	local events = {
		-- First Cast Event
		{ time = 16, func = function()
			--[[ defunct
			local msg = "Firemaw begins to cast Shadow Flame."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", msg)
			]]--
		end },

		-- First Hit
		{ time = 18, func = function()
			local msg = "Firemaw's Shadow Flame hits "..raid1.." for 3319 Shadow damage."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", msg)
		end },

		-- First Explosion
		{ time = 22, func = function()
			local msg = "Shadowflame Jet's Shadowflame Explosion hits "..raid2.." for 601 Fire damage. (200 resisted)"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", msg)
		end },

		-- Second Explosion
		{ time = 24, func = function()
			local msg = "Shadowflame Jet's Shadowflame Explosion hits you for 374 Fire damage. (325 absorbed)"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", msg)
		end },

		-- Third Explosion
		{ time = 30, func = function()
			local msg = "Shadowflame Jet's Shadowflame Explosion hits "..raid1.." for 739 Fire damage."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", msg)
		end },

		-- Second Cast Event
		{ time = 31.8, func = function()
			print("Test: Shadow Flame cast event")
			self:UNIT_CASTEVENT("Firemaw","Tester","START",22539,2000)
		end },

		-- Second Hit
		{ time = 33.5, func = function()
			local msg = "Firemaw's Shadow Flame hits you for 3319 Shadow damage."
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", msg)
		end },

		-- First Explosion
		{ time = 37.5, func = function()
			local msg = "Shadowflame Jet's Shadowflame Explosion hits "..raid2.." for 186 Fire damage. (556 resisted)"
			print("Test: " .. msg)
			self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", msg)
		end },

		-- End of Test
		{ time = 40, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}
	
	-- Schedule each event
	for i, event in ipairs(events) do
		self:ScheduleEvent("FiremawTest" .. i, event.func, event.time)
	end

	self:Message(module.translatedName .. " test started", "Positive")
	return true
end

-- Test command: /run BigWigs:GetModule("Firemaw"):Test()
