local module, L = BigWigs:ModuleDeclaration("Mephistroth", "Karazhan")

module.revision = 30003
module.enabletrigger = module.translatedName
module.toggleoptions = { "shacklescast", "shacklesdebuff", "shackleshatter", -1, "shardscd", "shardschannel", "shardscount", -1, "doomduration", "markdoom", -1, "nightmare", "marknightmare", -1, "vampaura", "vampcorruption", -1, "fearcast", "bosskill" }
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Tower of Karazhan"],
	AceLibrary("Babble-Zone-2.2")["Tower of Karazhan"],
	"Outland",
	"The Rock of Desolation"
}

local _, playerClass = UnitClass("player")

-- module defaults
module.defaultDB = {
	shacklescast = true,
	shacklesdebuff = true,
	shackleshatter = false,
	shardscd = true,
	shardschannel = true,
	shardscount = false,
	doomduration = playerClass == "MAGE" or playerClass == "DRUID",
	markdoom = true,
	nightmare = false,
	marknightmare = true,
	vampaura = playerClass == "SHAMAN" or playerClass == "PRIEST",
	vampcorruption = false,
	fearcast = playerClass == "SHAMAN",
}

L:RegisterTranslations("enUS", function()
	return {
		-- options
		cmd = "Mephistroth",

		shacklescast_cmd = "shacklescast",
		shacklescast_name = "Shackles Cast Alert",
		shacklescast_desc = "Warn when Mephistroth begins casting Shackles of the Legion.",

		shacklesdebuff_cmd = "shacklesdebuff",
		shacklesdebuff_name = "Shackles Debuff Alert",
		shacklesdebuff_desc = "Warn and timer when Shackles of the Legion lands.",

		shackleshatter_cmd = "shackleshatter",
		shackleshatter_name = "Shackle Shatter Tattle",
		shackleshatter_desc = "Tell who failed standing still.",

		shardscd_cmd = "shardscd",
		shardscd_name = "Shards of Hellfury CD Timer",
		shardscd_desc = "Shows timers for the 90s CD window followed by the 30s spawn window for the next Shards of Hellfury.",

		shardschannel_cmd = "shardschannel",
		shardschannel_name = "Shards of Hellfury Channel Time",
		shardschannel_desc = "Show time left before Channel enrage.",

		shardscount_cmd = "shardscount",
		shardscount_name = "Shards of Hellfury Count",
		shardscount_desc = "Count down defeated Shards (count is based on combat log range and may be off for you).",

		doomduration_cmd = "doomduration",
		doomduration_name = "Doom Duration Bar",
		doomduration_desc = "Show duration bar for current Doom victim to time their decurse.",

		markdoom_cmd = "markdoom",
		markdoom_name = "Mark Doom Target",
		markdoom_desc = "Mark a Doomed player with Triangle.",

		nightmare_cmd = "nightmare",
		nightmare_name = "Waking Nightmare Alert",
		nightmare_desc = "Show a warning message when a player falls asleep to Waking Nightmare (for OTs to pick up incoming Nightmare Crawlers).",

		marknightmare_cmd = "marknightmare",
		marknightmare_name = "Mark Waking Nightmare Target",
		marknightmare_desc = "Mark the player sleeping due to Waking Nightmare with Moon (so OTs see where the next Nightmare Crawler will spawn).",

		vampaura_cmd = "vampaura",
		vampaura_name = "Vampiric Aura alert",
		vampaura_desc = "Shows a purge alert whenever Vampiric Aura is up.",

		vampcorruption_cmd = "vampcorruption",
		vampcorruption_name = "Vampiric Corruption bar",
		vampcorruption_desc = "Shows a duration bar for Vampiric Corruption (50% melee haste after Vampiric Aura purge).",

		fearcast_cmd = "fearcast",
		fearcast_name = "Nathrezim Terror cast",
		fearcast_desc = "Shows an alert and a cast bar for incoming Nathrezim Terror (fear).",

		-- triggers
		trigger_engage = "I foresaw your arrival", -- CHAT_MSG_MONSTER_YELL

		trigger_shacklesDebuffYou = "You are afflicted by Shackles of the Legion",
		trigger_shacklesDebuffOther = "(.+) is afflicted by Shackles of the Legion",
		trigger_shacklesFadeYou = "Shackles of the Legion fades from you",

		trigger_shackleShatterYou = "Your Shackle Shatter .-its",
		trigger_shackleShatterOther = "(.+)'s Shackle Shatter .-its",

		trigger_doomDebuff = "(.+) ...? afflicted by Doom of Outland",
		trigger_doomDebuffFade = "Doom of Outland fades from (.+)%.",

		trigger_nightmareDebuff = "(.+) ...? afflicted by Waking Nightmare",
		trigger_nightmareDebuffFade = "Waking Nightmare fades from (.+)%.",

		trigger_vampiricAuraGain = "Mephistroth gains Vampiric Aura",
		trigger_vampiricAuraFade = "Vampiric Aura fades from Mephistroth",
		trigger_vampiricCorruption = "Mephistroth gains Vampiric Corruption",

		trigger_shacklesCast = "Mephistroth begins to cast Shackles of the Legion",
		trigger_shardsCast = "Mephistroth begins to cast Shards of Hellfury",
		trigger_shardsSummon = "My plan has long been in the making",
		trigger_shardsDeath = "Hellfury Shard dies",
		trigger_shardsFail = "Mephistroth gains Unfathomed Hatred",
		trigger_fearCast = "Mephistroth begins to cast Nathrezim Terror",

		-- messages & bars
		msg_shacklesCast = "Shackles of the Legion incoming! >>DO NOT MOVE<<",
		bar_shacklesCast = "Casting Shackles",
		msg_shacklesCastAlert = "Shackles Casting >>STOP MOVING<<",

		bar_shacklesDebuff = "Shackles of the Legion",
		msg_shacklesDebuffYou = "You are shackled! >>DO NOT MOVE<<",
		msg_shacklesDebuffOther = "%s is shackled!",

		msg_shackleShatter = " didn't keep still.",

		bar_shardsChannel = "Shard Enrage",
		bar_shardsCD = "Shards on CD",
		bar_shardsWindow = "Shards Spawn Window",
		bar_shardsCast = "Shards Incoming!",
		msg_shardsCast = "Hellfire Shards casting, spread out!",
		msg_shardsRemaining = " Shards remaining",
		msg_shardsOver = "Shards Phase Over",
		msg_shardsFail = "Shards Phase Failed - Unfathomed Hatred triggered",

		bar_doom = "Doom on %s >Decurse<",

		msg_nightmare = "Crawler spawning on %s",

		warning_vampiricAura = "Purge!",
		bar_vampiricCorruption = "boss hasted",

		msg_fearCast = "Fear incoming!",
		bar_fearCast = "Fear casting!",
	}
end)

local timer = {
	shacklesInitialCD = { 68, 96 }, -- 60 to 120 ?
	shacklesCD = { 40, 70 },
	shacklesCast = 2.5,
	shacklesDebuff = 6,
	shardsCast = 6,
	shardsCD = 90, --lowest observed in logs: 92s cast-to-cast
	shardsWindow = 30, --highest observed in logs: 120s cast-to-cast
	shardsCD_bar_delay = 25,
	shardsChannel = 2.5 + 25, -- cast time + channel duration, logs: ~28s total
	doom = 8,
	vampiricAura = 15,
	vampiricCorruption = 15,
	fearCast = 2.5,
}

local icon = {
	shackles = "INV_Belt_18",
	shardsCD = "Spell_Fire_Fire",
	shardsChannel = "Spell_Fire_SoulBurn",
	doom = "Spell_Shadow_NightOfTheDead",
	vampiricAura = "Spell_Shadow_VampiricAura",
	vampiricCorruption = "Ability_Druid_ChallangingRoar",
	fear = "Spell_Shadow_DeathCoil",
}

local syncName = {
	shacklesCast = "MephistrothShacklesCast" .. module.revision,
	shacklesDebuff = "MephistrothShacklesDebuff" .. module.revision,
	shackleShatter = "MephistrothShackleShatter" .. module.revision,
	shardsCD = "MephistrothShardsOfHellfuryCD" .. module.revision,
	shardsChannel = "MephistrothShardsOfHellfuryChannel" .. module.revision,
	shardsChannelEnd = "MephistrothShardsOfHellfuryChannelEnd" .. module.revision,
	doomGain = "MephistrothDoomGain" .. module.revision,
	doomFade = "MephistrothDoomFade" .. module.revision,
	nightmareGain = "MephistrothNightmareGain" .. module.revision,
	nightmareFade = "MephistrothNightmareFade" .. module.revision,
	vampiricAuraGain = "MephistrothVAGain" .. module.revision,
	vampiricAuraFade = "MephistrothVAFade" .. module.revision,
	vampiricCorruptionGain = "MephistrothVCGain" .. module.revision,
	fearCast = "MephistrothFearCast" .. module.revision,
}

local spellIds = {
	shacklesCast = 51916,
	shackleShatter = 51917,
	shardsCast = 51942,
	shardsChannel = 51947,
	shardsFinish = 51948,
	fear = 51907,
}

local fail_shards = 6

module:RegisterYellEngage(L.trigger_engage)

--------------------------------------------------------------------------------
--  Module OnEnable
--------------------------------------------------------------------------------

function module:OnSetup()
	self.started = nil
end

-- should sync enables
function module:OnEnable()
	if SUPERWOW_STRING or SetAutoloot then
		self:RegisterEvent("UNIT_CASTEVENT", "MephistrothCastEvent")
	else
		self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "CastEvent") --Shackles
		self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "CastEvent") --Shards Phase
		self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CastEvent") --Nathrezim Terror cast
		self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "CastEvent") --Shards of Hellfury cast
		self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "CastEvent") --Shackle Shatter hits
	end

	-- Debuff landing
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "DebuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "DebuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "DebuffEvent")
	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "EnemyBuffEvent")

	-- Debuff fading
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "FadeEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "FadeEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "FadeEvent")

	self:ThrottleSync(2, syncName.shacklesCast)
	self:ThrottleSync(2, syncName.shacklesDebuff)
	self:ThrottleSync(1, syncName.shackleShatter)
	self:ThrottleSync(5, syncName.shardsCD)
	self:ThrottleSync(5, syncName.shardsChannel)
	self:ThrottleSync(5, syncName.shardsChannelEnd)
	self:ThrottleSync(5, syncName.doomGain)
	self:ThrottleSync(5, syncName.doomFade)
	self:ThrottleSync(5, syncName.nightmareGain)
	self:ThrottleSync(5, syncName.nightmareFade)
	self:ThrottleSync(5, syncName.vampiricAuraGain)
	self:ThrottleSync(5, syncName.vampiricAuraFade)
	self:ThrottleSync(5, syncName.vampiricCorruptionGain)
	self:ThrottleSync(5, syncName.fearCast)
end

function module:OnEngage()
	fail_shards = 6
end

--------------------------------------------------------------------------------
--  Cast Event
--------------------------------------------------------------------------------
function module:MephistrothCastEvent(casterGuid, targetGuid, eventType, spellId, castTime)
	-- if not self.db.profile.shacklescast then return end
	-- todo: I believe shackles is a channel but don't know for sure yet
	if spellId == spellIds.shacklesCast and (eventType == "START" or eventType == "CHANNEL") then
		self:Sync(syncName.shacklesCast .. " " .. (castTime / 1000))
	elseif spellId == spellIds.shackleShatter then
		self:Sync(syncName.shackleShatter .. " " .. UnitName(casterGuid))
	elseif spellId == spellIds.shardsCast and eventType == "START" then
		self:Sync(syncName.shardsCD)
	elseif spellId == spellIds.shardsChannel then
		if eventType == "CHANNEL" then
			self:Sync(syncName.shardsChannel .. " " .. (castTime / 1000))
		end
	elseif spellId == spellIds.shardsFinish and eventType == "CAST" then
		-- todo: shard completed, good spot for an enrage indication
	elseif spellId == spellIds.fear and eventType == "START" then
		self:Sync(syncName.fearCast)
	end
end

function module:CastEvent(msg)
	if string.find(msg, L.trigger_shacklesCast) then
		self:Sync(syncName.shacklesCast .. " " .. timer.shacklesCast)
		return
	end

	if string.find(msg, L.trigger_shardsCast) then
		self:Sync(syncName.shardsCD)
		return
	end
	
	if string.find(msg, L.trigger_shardsSummon) then
		self:Sync(syncName.shardsChannel .. " " .. timer.shardsChannel)
		return
	end

	if string.find(msg, L.trigger_fearCast) then
		self:Sync(syncName.fearCast)
		return
	end

	if string.find(msg, L.trigger_shackleShatterYou) then
		self:Sync(syncName.shackleShatter .. " " .. UnitName("player"))
		return
	end
	local _, _, player = string.find(msg, L.trigger_shackleShatterOther)
	if player then
		self:Sync(syncName.shackleShatter .. " " .. player)
		return
	end
end

function module:OnEnemyDeath(msg)
	if string.find(msg, L.trigger_shardsDeath) then
		fail_shards = fail_shards - 1
		if fail_shards == 0 then
			fail_shards = 6
			self:Sync(syncName.shardsChannelEnd)
		elseif self.db.profile.shardscount then
			self:Message(fail_shards..L.msg_shardsRemaining, "Positive")
		end
	end
end

--------------------------------------------------------------------------------
--  Debuff landing
--------------------------------------------------------------------------------
function module:DebuffEvent(msg)
	-- Shackle debuff
	if string.find(msg, L.trigger_shacklesDebuffYou) then
		local player = UnitName("player")
		self:ShacklesDebuff(player) -- let's not miss a sync
		self:Sync(syncName.shacklesDebuff .. " " .. player)
		return
	end
	local _, _, player = string.find(msg, L.trigger_shacklesDebuffOther)
	if player then
		self:Sync(syncName.shacklesDebuff .. " " .. player)
		return
	end

	-- Doom of Outland debuff
	local _, _, player = string.find(msg, L.trigger_doomDebuff)
	if player then
		player = player == "You" and UnitName("player") or player
		self:Sync(syncName.doomGain .. " " .. player)
		return
	end

	-- Waking Nightmare debuff
	local _, _, player = string.find(msg, L.trigger_nightmareDebuff)
	if player then
		player = player == "You" and UnitName("player") or player
		self:Sync(syncName.nightmareGain .. " " .. player)
		return
	end
end

function module:EnemyBuffEvent(msg)
	-- Vampiric Aura
	if string.find(msg, L.trigger_vampiricAuraGain) then
		self:Sync(syncName.vampiricAuraGain)
	end
	
	-- Vampiric Corruption
	if string.find(msg, L.trigger_vampiricCorruption) then
		self:Sync(syncName.vampiricCorruptionGain)
	end
	
	-- Unfathomed Hatred (shard fail)
	if string.find(msg, L.trigger_shardsFail) then
		if self.db.profile.shardschannel then
			self:Message(L.msg_shardsFail, "Important", true, "Alert")
		end
	end
end

--------------------------------------------------------------------------------
--  Debuff fades
--------------------------------------------------------------------------------
function module:FadeEvent(msg)
	-- Shackles fade from You
	if string.find(msg, L.trigger_shacklesFadeYou) then
		-- fear will remove shackles, best to keep the bar for calls as some people will not get feared
		-- self:RemoveBar(L.bar_shacklesDebuff)
		self:RemoveWarningSign(icon.shackles)
		if self.db.profile.shacklesdebuff then
			self:Sound("Long")
		end
	end
	
	-- Doom fades from any player
	local _, _, player = string.find(msg, L.trigger_doomDebuffFade)
	if player then
		player = player == "you" and UnitName("player") or player
		self:Sync(syncName.doomFade .. " " .. player)
	end
	
	-- Waking Nightmare fades from any player
	local _, _, player = string.find(msg, L.trigger_nightmareDebuffFade)
	if player then
		player = player == "you" and UnitName("player") or player
		self:Sync(syncName.nightmareFade .. " " .. player)
	end
	
	-- Vampiric Aura fades from boss
	if string.find(msg, L.trigger_vampiricAuraFade) then
		self:Sync(syncName.vampiricAuraFade)
	end
end

--------------------------------------------------------------------------------
--  Sync handler
--------------------------------------------------------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.shacklesCast then
		local castTime = tonumber(rest)
		self:ShacklesCast(castTime)
	elseif sync == syncName.shacklesDebuff and rest and rest ~= UnitName("player") then
		self:ShacklesDebuff(rest)
	elseif sync == syncName.shackleShatter and rest then
		self:ShackleShatter(rest)

	elseif sync == syncName.shardsCD then
		self:ShardsCD()
	elseif sync == syncName.shardsChannel and rest then
		local castTime = tonumber(rest)
		self:ShardsChannel(castTime)
	elseif sync == syncName.shardsChannelEnd then
		self:RemoveBar(L.bar_shardsChannel)
		if self.db.profile.shardschannel then
			self:Message(L.msg_shardsOver, "Positive", true, "Long")
		end

	elseif sync == syncName.doomGain and rest then
		self:DoomGain(rest)
	elseif sync == syncName.doomFade and rest then
		self:DoomFade(rest)

	elseif sync == syncName.nightmareGain and rest then
		self:NightmareGain(rest)
	elseif sync == syncName.nightmareFade and rest then
		self:NightmareFade(rest)

	elseif sync == syncName.vampiricAuraGain then
		if self.db.profile.vampaura then
			self:WarningSign(icon.vampiricAura, timer.vampiricAura, false, L.warning_vampiricAura)
		end
	elseif sync == syncName.vampiricAuraFade then
		self:RemoveWarningSign(icon.vampiricAura)
	elseif sync == syncName.vampiricCorruptionGain then
		if self.db.profile.vampcorruption then
			self:Bar(L.bar_vampiricCorruption, timer.vampiricCorruption, icon.vampiricCorruption, true, "Yellow")
		end

	elseif sync == syncName.fearCast then
		if self.db.profile.fearcast then
			self:Message(L.msg_fearCast, "Core")
			self:Bar(L.bar_fearCast, timer.fearCast, icon.fear, true, "Cyan")
		end
	end
end

--------------------------------------------------------------------------------
--  Alerts & Bars
--------------------------------------------------------------------------------
function module:ShacklesCast(castTime)
	if not self.db.profile.shacklescast then
		return
	end
	self:Sound("Beware")
	self:WarningSign(icon.shackles, castTime, true, L.msg_shacklesCastAlert)
	self:Bar(L.bar_shacklesCast, castTime, icon.shackles, true, "Red")
end

function module:ShacklesDebuff(player)
	if not self.db.profile.shacklesdebuff then
		return
	end
	-- 0.5 leeway added to encourage people not to move too early
	if player == UnitName("player") then
		self:WarningSign(icon.shackles, timer.shacklesDebuff + 0.5, true, L.msg_shacklesDebuffYou)
		self:Sound("Alarm")
	end
	self:Bar(L.bar_shacklesDebuff, timer.shacklesDebuff + 0.5, icon.shackles)
end

function module:ShackleShatter(player)
	if not self.db.profile.shackleshatter then
		return
	end
	player = player == UnitName("player") and "You" or player
	local message = player .. L.msg_shackleShatter
	self:Message(message, "Important", false, nil, false)
	print(message)
end

function module:ShardsCD()
	fail_shards = 6
	
	if not self.db.profile.shardscd then
		return
	end
	-- clean up any left-over bars relating to shard CD
	self:RemoveBar(L.bar_shardsCD)
	self:CancelDelayedBar(L.bar_shardsWindow)
	self:RemoveBar(L.bar_shardsWindow)
	-- warn and cast bar
	self:Message(L.msg_shardsCast, "Important", false, nil, false)
	self:Bar(L.bar_shardsCast, timer.shardsCast, icon.shardsCD)
	-- schedule new CD bars
	self:DelayedBar(timer.shardsCD_bar_delay, L.bar_shardsCD, timer.shardsCD-timer.shardsCD_bar_delay, icon.shardsCD, true, "ItemQuality0")
	self:DelayedBar(timer.shardsCD, L.bar_shardsWindow, timer.shardsWindow, icon.shardsCD, true, "Orange")
end

function module:ShardsChannel(castTime)
	if not self.db.profile.shardschannel then
		return
	end
	self:Sound("Alarm")
	self:Bar(L.bar_shardsChannel, castTime, icon.shardsChannel, true, "Red")
end

function module:DoomGain(player)
	if self.db.profile.markdoom then
		self:SetRaidTargetForPlayer(player, 4) -- green triangle
	end
	
	if self.db.profile.doomduration then
		local barText = string.format(L.bar_doom, player)
		self:Bar(barText, timer.doom, icon.doom, true, "Purple")
		
		-- Set the bar to target player and cast Remove Curse when clicked
		local raidIndex = nil
		for i = 1,40 do
			local unit = "raid"..i
			if UnitExists(unit) and UnitName(unit) == player then
				raidIndex = unit
				break
			end
		end
		
		self:SetCandyBarOnClick("BigWigsBar " .. barText, function(name, button, playerName, target)
			if SUPERWOW_VERSION or SetAutoloot then
				if playerClass == "MAGE" then
					CastSpellByName("Remove Lesser Curse", target)
				elseif playerClass == "DRUID" then
					CastSpellByName("Remove Curse", target)
				end
			else
				TargetByName(playerName, true)
				if playerClass == "MAGE" then
					CastSpellByName("Remove Lesser Curse")
				elseif playerClass == "DRUID" then
					CastSpellByName("Remove Curse")
				end
			end
		end, player, raidIndex)
	end
end

function module:DoomFade(player)
	if self.db.profile.markdoom then
		self:RestorePreviousRaidTargetForPlayer(player)
	end
	
	self:RemoveBar(string.format(L.bar_doom, player))
end

function module:NightmareGain(player)
	if self.db.profile.marknightmare then
		self:SetRaidTargetForPlayer(player, 5) -- white moon
	end
	
	if self.db.profile.nightmare then
		self:Message(string.format(L.msg_nightmare, player), "Magenta", true, "Murloc")
	end
end

function module:NightmareFade(player)
	if self.db.profile.marknightmare then
		self:RestorePreviousRaidTargetForPlayer(player)
	end
end


--------------------------------------------------------------------------------
--  Tests
--------------------------------------------------------------------------------
function module:Test()
	BigWigs:EnableModule("Mephistroth")

	-- simulate engage
	self:Engage()

	-- 1) simulate the cast starting (START event)
	-- self:UNIT_CASTEVENT("player", "player", "START", spellIds.shacklesCast, 2)
	-- or CHANNEL:
	-- self:MephistrothCastEvent(nil, "player", "CHANNEL", spellIds.shacklesCast, 2)
	self:ScheduleEvent(self:ToString() .. "ShacklesDebuffTest0", function()
		local msg = "Mephistroth begins to cast Shackles of the Legion!"
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_RAID_BOSS_EMOTE", msg)
	end, 0.5)

	-- after cast finishes, simulate the debuff landing
	self:ScheduleEvent(self:ToString() .. "ShacklesDebuffTest1", function()
		local msg = "You are afflicted by Shackles of the Legion."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
	end, 3)
	self:ScheduleEvent(self:ToString() .. "ShacklesDebuffTest2", function()
		local msg = "Shackles of the Legion fades from you."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
	end, 3 + 6)

	self:ScheduleEvent(self:ToString() .. "ShacklesDebuffTest3", function()
		self:DebuffEvent("Ehawne is afflicted by Shackles of the Legion.")
	end, 3 + 8)

	self:ScheduleEvent(self:ToString() .. "ShacklesDebuffTest4", function()
		self:DebuffEvent("Ehawne is afflicted by Shackles of the Legion (1).")
	end, 3 + 15)

	self:ScheduleEvent(self:ToString() .. "ShacklesDebuffTest5", function()
		self:DebuffEvent("Milkpress is afflicted by Shackles of the Legion (1).")
	end, 3 + 23)

	self:ScheduleEvent(self:ToString() .. "ShacklesDebuffTest6", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "START", spellIds.shacklesCast, 4000)
	end, 3 + 28) -- test this!

	self:ScheduleEvent(self:ToString() .. "ShackleShatterTest1", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "raid1", "player", "CAST", spellIds.shackleShatter, 2000)
		local msg = UnitName("raid1").."'s Shackle Shatter hits Tester for 6160 Shadow damage."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", msg)	
	end, 3 + 30)
	self:ScheduleEvent(self:ToString() .. "ShackleShatterTest2", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "CAST", spellIds.shackleShatter, 2000)
		local msg = "Your Shackle Shatter hits Tester for 7005 Shadow damage."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", msg)	
	end, 3 + 32)

	-- Shard Spawn
	self:ScheduleEvent(self:ToString() .. "ShardsCDTest1", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "START", spellIds.shardsCast, 6000)
		local msg = "Mephistroth begins to cast Shards of Hellfury."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", msg)		
	end, 3 + 36)
	self:ScheduleEvent(self:ToString() .. "ShardsChannelTest1", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "CHANNEL", spellIds.shardsChannel, 25000)
		local msg = "My plan has long been in the making, your pathetic power has no place here!"
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_MONSTER_YELL", msg)	
	end, 3 + 42)

	-- simulate hellfire shards ending their channel, naturally or by dying
	self:ScheduleEvent(self:ToString() .. "ShardsChannelTest1_1", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "FAIL", spellIds.shardsChannel, 2000)
		local msg = "Hellfury Shard dies."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", msg)
	end, 3 + 47)
	self:ScheduleEvent(self:ToString() .. "ShardsChannelTest1_2", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "FAIL", spellIds.shardsChannel, 2000)
		local msg = "Hellfury Shard dies."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", msg)
	end, 3 + 48)
	self:ScheduleEvent(self:ToString() .. "ShardsChannelTest1_3", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "FAIL", spellIds.shardsChannel, 2000)
		local msg = "Hellfury Shard dies."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", msg)
	end, 3 + 48)
	self:ScheduleEvent(self:ToString() .. "ShardsChannelTest1_4", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "FAIL", spellIds.shardsChannel, 2000)
		local msg = "Hellfury Shard dies."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", msg)
	end, 3 + 49)
	self:ScheduleEvent(self:ToString() .. "ShardsChannelTest1_5", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "FAIL", spellIds.shardsChannel, 2000)
		local msg = "Hellfury Shard dies."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", msg)
	end, 3 + 49)
	self:ScheduleEvent(self:ToString() .. "ShardsChannelTest1_6", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "FAIL", spellIds.shardsChannel, 2000)
		local msg = "Hellfury Shard dies."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", msg)
	end, 3 + 51)

	self:ScheduleEvent(self:ToString() .. "DoomTest1", function()
		local msg = UnitName("raid1").." is afflicted by Doom of Outland."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", msg)
	end, 3 + 54)
	self:ScheduleEvent(self:ToString() .. "DoomTest2", function()
		local msg = "Doom of Outland fades from "..UnitName("raid1").."."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", msg)
	end, 3 + 57)

	self:ScheduleEvent(self:ToString() .. "DoomTest3", function()
		local msg = "You are afflicted by Doom of Outland."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
	end, 3 + 60)
	self:ScheduleEvent(self:ToString() .. "DoomTest4", function()
		local msg = "Doom of Outland fades from you."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
	end, 3 + 63)

	self:ScheduleEvent(self:ToString() .. "VampTest1", function()
		local msg = "Mephistroth gains Vampiric Aura."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS",msg)
	end, 3 + 65)
	self:ScheduleEvent(self:ToString() .. "VampTest2", function()
		local msg = "Vampiric Aura fades from Mephistroth."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER",msg)
	end, 3 + 67)
	self:ScheduleEvent(self:ToString() .. "VampTest3", function()
		local msg = "Mephistroth gains Vampiric Corruption."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS",msg)
	end, 3 + 67)

	self:ScheduleEvent(self:ToString() .. "FearTest", function()
		local msg = "Mephistroth begins to cast Nathrezim Terror."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",msg)
	end, 3 + 70)

	self:ScheduleEvent(self:ToString() .. "ShardFailTest", function()
		local msg = "Mephistroth gains Unfathomed Hatred."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS",msg)
	end, 3 + 72)

	self:ScheduleEvent(self:ToString() .. "NightmareTest1", function()
		local msg = UnitName("raid1").." is afflicted by Waking Nightmare."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", msg)
	end, 3 + 74)
	self:ScheduleEvent(self:ToString() .. "NightmareTest2", function()
		local msg = "Waking Nightmare fades from "..UnitName("raid1").."."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", msg)
	end, 3 + 77)

	self:ScheduleEvent(self:ToString() .. "NightmareTest3", function()
		local msg = "You are afflicted by Waking Nightmare."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", msg)
	end, 3 + 80)
	self:ScheduleEvent(self:ToString() .. "NightmareTest4", function()
		local msg = "Waking Nightmare fades from you."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", msg)
	end, 3 + 83)

	-- Shard Spawn
	self:ScheduleEvent(self:ToString() .. "ShardsCDTest2", function()
		BigWigs:TriggerEvent("UNIT_CASTEVENT", "player", "player", "START", spellIds.shardsCast, 6000)
		local msg = "Mephistroth begins to cast Shards of Hellfury."
		print("Test: " .. msg)
		self:TriggerEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", msg)		
	end, 3 + 36 + 105)

	-- after the normal debuff duration, simulate fade
	-- self:ScheduleEvent(self:ToString() .. "ShacklesFadeTest", function()
	--   self:FadeEvent("Shackles of the Legion fades from " .. UnitName("player"))
	-- end, 3 + timer.shacklesDebuff + 0.1)

	BigWigs:Print("Mephistroth Shackles self‑test running...")
end
-- /run BigWigs:GetModule("Mephistroth"):Test()
