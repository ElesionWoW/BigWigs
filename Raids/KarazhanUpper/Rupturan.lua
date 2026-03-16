local module, L = BigWigs:ModuleDeclaration("Rupturan the Broken", "Karazhan")

module.revision = 30005
module.enabletrigger = module.translatedName
module.toggleoptions = { "boulderalert", "bouldermark", "bouldersay", "livingstone", "opportunity", -1, "igniteearth", "dirtmound", "dirtmoundmark", -1, "flamestrike", "flamestrikemove", "felheartalert", "felheartbar", "fragmentbars", "reform", "bosskill" }
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Tower of Karazhan"],
	AceLibrary("Babble-Zone-2.2")["Tower of Karazhan"],
	"Outland",
	"The Rock of Desolation",
}

local _, playerClass = UnitClass("player")
local opportunityThreshold = 25

module.defaultDB = {
	boulderalert = false,
	bouldermark = true,
	bouldersay = true,
	livingstone = true,
	opportunity = true,
	igniteearth = false,
	dirtmound = true,
	dirtmoundmark = false,
	flamestrike = true,
	flamestrikemove = true,
	felheartalert = true,
	felheartbar = playerClass == "HUNTER" or playerClass == "PRIEST" or playerClass == "WARLOCK",
	fragmentbars = true,
	reform = true,
}

-------------------------------------------------------------------------------
--  Localization
-------------------------------------------------------------------------------
L:RegisterTranslations("enUS", function() return {
	-- Options
	cmd = "Rupturan",

	boulderalert_cmd = "boulderalert",
	boulderalert_name = "Throw Boulder Alert",
	boulderalert_desc = "Gives a warning message with the target of an incoming Boulder.",
	
	bouldermark_cmd = "bouldermark",
	bouldermark_name = "Throw Boulder Mark",
	bouldermark_desc = "Mark the target of an incoming Boulder with Moon.",
	
	bouldersay_cmd = "bouldersay",
	bouldersay_name = "Throw Boulder Say",
	bouldersay_desc = "Alert your surroundings with a /say message if you are the target of an incoming Boulder.",

	livingstone_cmd = "livingstone",
	livingstone_name = "Living Stone Stomp",
	livingstone_desc = "Show time left until a Living Stone stomp after Crash Landing fades.",

	opportunity_cmd = "opportunity",
	opportunity_name = "Window of Opportunity",
	opportunity_desc = "Warns about remaining or incoming Living Stones below "..opportunityThreshold.."% boss HP to avoid Explode mechanic (when the boss dies the remaining Living Stones detonate)",

	igniteearth_cmd  = "igniteearth",
	igniteearth_name = "Ignite Earth",
	igniteearth_desc = "Show cooldown and cast bar for Ignite Earth (P1 flamestrike)",

	dirtmound_cmd = "dirtmound",
	dirtmound_name = "Dirt Mound Indicators",
	dirtmound_desc = "Warn when Dirt Mound Quake hits you and when one is spawned.",

	dirtmoundmark_cmd  = "dirtmoundmark",
	dirtmoundmark_name = "Mark Dirt Mound Target",
	dirtmoundmark_desc = "Mark the player Dirt Mound is chasing with a Diamond.",

	flamestrike_cmd = "flamestrike",
	flamestrike_name = "Flamestrike Cast",
	flamestrike_desc = "Warn when Flamestrike (Ignite Rock) is casting.",

	flamestrikemove_cmd = "flamestrikemove",
	flamestrikemove_name = "Flamestrike Alert",
	flamestrikemove_desc = "Warns when you stand in fire (Ignite Rock).",

	felheartalert_cmd = "felheartalert",
	felheartalert_name = "Felheart Mana Alert",
	felheartalert_desc = "Warns when Felheart has >80% mana (5 second CD).",

	felheartbar_cmd = "felheartbar",
	felheartbar_name = "Felheart Mana Bar",
	felheartbar_desc = "Adds a continuously updating mana bar for Felheart.",

	fragmentbars_cmd = "fragmentbars",
	fragmentbars_name = "Fragment Health Bars",
	fragmentbars_desc = "Show health bars for all 3 fragments in Phase 2.",

	reform_cmd = "reform",
	reform_name = "Reform Timer",
	reform_desc = "When you kill a Fragment, show show time left until Rupturan will be reformed.",

	-- Bars / Messages
	bar_ignite_earth_CD  = "Ignite Earth CD",
	bar_ignite_earth     = "Ignite Earth casting",
	bar_ignite_rock      = "Flamestrike casting",
	warn_ignite_rock     = "Incoming!",
	msg_flamestrike      = "Move out of Flamestrike!",
	warn_flamestrike     = "MOVE",
	bar_ls_earthstomp    = "Living Stone STOMP",
	msg_dm_quake         = "Dirt Mound Quake!  MOVE AWAY!",
	msg_dm_target_near   = "Get away from %s!",
	msg_dm_target_you    = "Dirt Mound chasing you!",
	bar_reform           = "Rupturan Reforming",
	msg_boulder          = "Boulder casting on %s",
	msg_boulderMiss      = "Boulder missed, no add",
	say_boulder          = "Boulder incoming on me!",
	bar_window           = "Window of Opportunity",
	msg_windowOpen       = "Kill Rupturan! - all Stones dead",
	msg_windowClosing    = "Stone incoming!",
	msg_windowClosed     = "Stone alive! DON'T kill Rupturan",
	msg_felheartMana     = "Felheart at %s%% mana!",
	bar_fragment	     = "Frag",

	-- Triggers
	trigger_start        = "All shall crumble",
	trigger_phase2       = "Let the cracks of this world destroy you",
	trigger_boss_dead    = "Perished... To dust",
	unit_felheart        = "Felheart",
	unit_fragment        = "Fragment of Rupturan",

	trigger_tb_cast      = "Rupturan the Broken begins to perform Throw Boulder",
	trigger_tb_hit       = "Rupturan the Broken's Throw Boulder hits (.+) for",
	trigger_tb_miss      = "Rupturan the Broken's Throw Boulder missed (.+)%.",
	trigger_ls_fades     = "Crash Landing fades from Living Stone",
	trigger_ls_die       = "Living Stone dies",
	trigger_igniteearth  = "Rupturan the Broken begins to cast Ignite Earth",
	trigger_dm_quake     = "Dirt Mound's Quake hits you for",
	trigger_dm_spawn     = "Rupturan commands the earth to crush (.+)!",
	trigger_dm_die       = "Dirt Mound dies",
	trigger_flamestrike  = "You are afflicted by Ignite Rock",
	trigger_igniterock   = "Fragment of Rupturan begins to cast Ignite Rock",
	trigger_reform       = "Fragment of Rupturan begins to cast Reform",
} end)

local timer = {
	boulderCast = 2,
	boulderCD = {13,16}, -- lowest 12.6, highest 16.8
	earthstomp = 5,
	igniteEarthCast = 3,
	igniteEarthCD = {15,19}, -- interval based on logs, rarely 14, mostly 16
	igniteRockCD = {20,53},
	igniteRock = 3,
	reform = 10,
}

local icon = {
	earthstomp	= "Ability_ThunderClap",
	quake		= "Spell_Nature_Earthquake",
	igniteEarth	= "Spell_Fire_Immolation",
	igniteRock	= "Spell_Fire_SelfDestruct",
	fire		= "Spell_Fire_Fire", -- warning when standing in Ignite Rock (confusing if same icon as incoming cast)
	reform		= "Spell_Nature_AstralRecalGroup",
	window		= "INV_Misc_PocketWatch_01",
	felheart	= "Spell_Holy_PrayerOfFortitude",
	fragment	= "Spell_Nature_StrengthOfEarthTotem02",
}

local syncName = {
	earthstomp = "RupturanEarthStomp"..module.revision,
	igniteEarth = "RupturanIgniteEarth"..module.revision,
	igniteRock = "RupturanIgniteRock"..module.revision,
	dm_spawn = "RupturanDirtMoundSpawn"..module.revision,
	phase2 = "RupturanPhaseTwo"..module.revision,
	reform = "RupturanReform"..module.revision,
	throwBoulderCast = "RupturanThrowBoulderCast"..module.revision,
	throwBoulderOutcome = "RupturanThrowBoulderOutcome"..module.revision,
	livingStoneDeath = "RupturanLivingStoneDeath"..module.revision,
}

local spellIds = {
	igniteEarth		= 52040,
	throwBoulder	= 51289,
	igniteRock		= 51298,
	reform			= 51299,
}

local guid = {
	rupturan = "0xF13000EA39073D35",
	felheart = nil,
	fragmentA = nil,
	fragmentB = nil,
	fragmentC = nil,
}

-- keep track of players to later reset raid marks, and active Living Stones
local mound_chasing = nil
local boulder_victim = nil
local last_boulder = 0
local active_living_stones = 0
local last_mana_warn = 0

-------------------------------------------------------------------------------
--  Initialization
-------------------------------------------------------------------------------

module:RegisterYellEngage(L.trigger_start)

function module:OnEnable()
	-- Living Stone stomp countdown
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")

	-- Quake damage, Throw Boulder
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "SpellEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "SpellEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SpellEvent") -- also non-SuperWoW Ignite Earth & Ignite Rock cast

	-- Dirt Mound spawn target announcement (emote)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Event")

	-- phase2
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", "Event")

	-- Ignite Rock affliction
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")

	if SUPERWOW_VERSION or SetAutoloot then
		self:RegisterEvent("UNIT_CASTEVENT")
	else
		self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "SpellEvent") -- Reform cast
	end

	self:ThrottleSync(2, syncName.earthstomp)
	self:ThrottleSync(4, syncName.igniteEarth)
	self:ThrottleSync(1, syncName.igniteRock)
	self:ThrottleSync(2, syncName.dm_spawn)
	self:ThrottleSync(2, syncName.phase2)
	self:ThrottleSync(1, syncName.reform)
	self:ThrottleSync(5, syncName.throwBoulderCast)
	self:ThrottleSync(5, syncName.throwBoulderOutcome)
	self:ThrottleSync(0.5, syncName.livingStoneDeath)
end

-- function module:OnSetup()
-- end

function module:OnEngage()
	mound_chasing = nil
	boulder_victim = nil
	last_boulder = 0
	active_living_stones = 0
	last_mana_warn = 0
	self:RemoveFragmentBars()
end

function module:OnDisengage()
	-- clean up bars
	self:RemoveBar(L.bar_ls_earthstomp)
	self:CancelDelayedBar(L.bar_ignite_earth_CD)
	self:RemoveBar(L.bar_ignite_earth_CD)
	self:RemoveFragmentBars()
	self:RestorePreviousRaidTargetForPlayer(mound_chasing)
	self:RestorePreviousRaidTargetForPlayer(boulder_victim)
	self:CancelScheduledEvent("RupturanFindFelheart")
	self:CancelScheduledEvent("RupturanCheckFelheart")
	self:CancelScheduledEvent("RupturanFindFragments")
end

-------------------------------------------------------------------------------
--  Event Handler
--------------------------------------------------------------------------------

function module:Event(msg)
	-- Living Stone fade → start stomp timer
	if self.db.profile.livingstone and string.find(msg, L.trigger_ls_fades) then
		self:Sync(syncName.earthstomp)
		return
	end
	-- Dirt Mound spawn emote: capture player name
	local _,_,player = string.find(msg, L.trigger_dm_spawn)
	if player then
		self:Sync(syncName.dm_spawn .. " " .. player)
		return
	end
	if string.find(msg, L.trigger_phase2) then
		self:Sync(syncName.phase2)
		return
	end
	if string.find(msg, L.trigger_boss_dead) then
		self:SendBossDeathSync()
		return
	end
	if self.db.profile.flamestrikemove and string.find(msg, L.trigger_flamestrike) then
		self:WarningSign(icon.fire, 2, false, L.warn_flamestrike)
		self:Message(L.msg_flamestrike, "Important", true, "Info")
	end
end

function module:LowestFragmentCastTimeCoefficient()
	local coefficientA = BigWigs:GetCastTimeCoefficient(guid.fragmentA)
	local coefficientB = BigWigs:GetCastTimeCoefficient(guid.fragmentB)
	local coefficientC = BigWigs:GetCastTimeCoefficient(guid.fragmentC)
	
	return math.min(coefficientA, coefficientB, coefficientC)
end

function module:UNIT_CASTEVENT(caster,target,action,spellId,castTime)
	if spellId == spellIds.igniteEarth and action == "START" then
		self:Sync(syncName.igniteEarth .. " " .. (castTime / 1000))
		return
	end
	if spellId == spellIds.throwBoulder and action == "START" then
		self:Sync(syncName.throwBoulderCast .. " " .. UnitName(target))
		return
	end
	if spellId == spellIds.igniteRock and action == "START" then
		-- check if perhaps other fragments have quicker casts (missing CoT) and sync the lowest cast time to warn about the first Ignite Rock
		local shortestCast = timer.igniteRock * self:LowestFragmentCastTimeCoefficient() * 1000
		if castTime > shortestCast then
			castTime = shortestCast
		end
		self:Sync(syncName.igniteRock .. " " .. (castTime / 1000))
		return
	end
	if spellId == spellIds.reform and action == "START" then
		self:Sync(syncName.reform)
		return
	end
end

function module:SpellEvent(msg)
	-- non-SuperWoW Ignite Earth cast
	if string.find(msg, L.trigger_igniteearth) and not SUPERWOW_VERSION then
		local castTime = timer.igniteEarthCast * BigWigs:GetCastTimeCoefficient(guid.rupturan)
		self:Sync(syncName.igniteEarth .. " " .. castTime)
		return
	end

	-- Quake hit on you
	if string.find(msg, L.trigger_dm_quake) then
		self:DirtMoundQuake() -- personal damage, no syncing
		return
	end

	-- Throw Boulder cast
	if string.find(msg, L.trigger_tb_cast) and not SUPERWOW_VERSION then
		self:ScheduleEvent("RupturanDelayedTargetCheck", self.DelayedTargetCheck, 0.2, self)
		return
	end
	
	-- Throw Boulder hit
	local _,_,player = string.find(msg, L.trigger_tb_hit)
	if player then
		player = player == "you" and UnitName("player") or player
		if player == boulder_victim then
			self:Sync(syncName.throwBoulderOutcome .. " hit")
		end
		return
	end
	
	-- Throw Boulder miss
	local _,_,player = string.find(msg, L.trigger_tb_miss)
	if player then
		player = player == "you" and UnitName("player") or player
		if player == boulder_victim then
			self:Sync(syncName.throwBoulderOutcome .. " miss")
		end
		return
	end

	-- non-SuperWoW Ignite Rock cast
	if string.find(msg, L.trigger_igniterock) and not SUPERWOW_VERSION  then
		-- sync lowest cast time among all Fragments (one might be missing CoT)
		local castTime = timer.igniteRock * self:LowestFragmentCastTimeCoefficient()
		self:Sync(syncName.igniteRock .. " " .. castTime)
		return
	end

	-- non-SuperWoW Reform cast
	if string.find(msg, L.trigger_reform) then
		self:Sync(syncName.reform)
		return
	end
end

function module:OnEnemyDeath(msg)
	if string.find(msg, L.trigger_ls_die) then
		self:Sync(syncName.livingStoneDeath)
	end
end

function module:DelayedTargetCheck()
	local target = BigWigs:GetTargetByName(module.translatedName, 1)
	if target then
		self:Sync(syncName.throwBoulderCast .. " " .. target)
	end
end

--------------------------------------------------------------------------------
--  Sync handler
--------------------------------------------------------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.earthstomp then
		self:CrashLandingFades()

	elseif sync == syncName.igniteEarth and rest then
		local castTime = tonumber(rest)
		self:IgniteEarth(castTime)

	elseif sync == syncName.dm_spawn and rest then
		self:DirtMoundSpawn(rest)

	elseif sync == syncName.phase2 then
		self:Phase2()

	elseif sync == syncName.igniteRock and rest then
		local castTime = tonumber(rest)
		self:IgniteRock(castTime)

	elseif sync == syncName.reform then
		self:Reform()

	elseif sync == syncName.throwBoulderCast and rest then
		self:ThrowBoulder(rest)

	elseif sync == syncName.throwBoulderOutcome and rest then
		self:ThrowBoulderOutcome(rest)

	elseif sync == syncName.livingStoneDeath then
		active_living_stones = active_living_stones - 1
		self:CheckOpportunity()
	end
end

function module:CrashLandingFades()
	if not self.db.profile.livingstone then return end

	self:Sound("Alarm")
	self:Bar(L.bar_ls_earthstomp, timer.earthstomp, icon.earthstomp)
end

function module:IgniteEarth(castTime)
	if not self.db.profile.igniteearth then return end
	
	castTime = castTime or (timer.igniteEarthCast * BigWigs:GetCastTimeCoefficient(guid.rupturan))

	-- Remove any ongoing CD bar
	self:CancelDelayedBar(L.bar_ignite_earth_CD)
	self:RemoveBar(L.bar_ignite_earth_CD)

	-- Put up cast bar
	self:Bar(L.bar_ignite_earth, castTime, icon.igniteEarth)
	self:Sound("Info")
	-- Schedule CD bar to show after cast finishes
	self:DelayedIntervalBar(castTime, L.bar_ignite_earth_CD, timer.igniteEarthCD[1]-castTime, timer.igniteEarthCD[2]-castTime, icon.igniteEarth, true, "ItemQuality0")
end

function module:DirtMoundQuake()
	if not self.db.profile.dirtmound then return end

	self:Message(L.msg_dm_quake, "Important", true, "Info")
end

function module:DirtMoundSpawn(player)
	if not player then return end

	if self.db.profile.dirtmoundmark then
		self:RestorePreviousRaidTargetForPlayer(mound_chasing)
		self:SetRaidTargetForPlayer(player, 3) -- diamond
		mound_chasing = player
	end

	if not self.db.profile.dirtmound then return end
	if player == UnitName("player") then
		-- you're the target: big warning
		self:WarningSign(icon.quake, 5, true, L.msg_dm_target_you)
		self:Sound("RunAway")
		SendChatMessage("Popcorn On Me !", "SAY")
	else
		-- someone else: warn if you’re nearby
		for i=1,GetNumRaidMembers() do
			local unit = "raid"..i
			if UnitName(unit) == player and CheckInteractDistance(unit, 2) then
				self:Message(format(L.msg_dm_target_near, player), "Important", true, "Alarm")
				break
			end
		end
	end
end

function module:Phase2()
	-- cancel P1 bars
	self:CancelDelayedBar(L.bar_ignite_earth_CD)
	self:RemoveBar(L.bar_ignite_earth_CD)
	self:RemoveBar(L.bar_window)
	-- clear popcorn mark
	self:RestorePreviousRaidTargetForPlayer(mound_chasing)
	mound_chasing = nil
	-- start looking for adds
	guid.felheart = nil
	self:FindFelheart()
	guid.fragmentA = nil
	guid.fragmentB = nil
	guid.fragmentC = nil
	self:FindFragments()
end

function module:IgniteRock(castTime)
	if not self.db.profile.flamestrike then return end
	castTime = castTime or (timer.igniteRock * self:LowestFragmentCastTimeCoefficient())

	self:Sound("Alarm")
	self:WarningSign(icon.igniteRock, 3, true, L.warn_ignite_rock)
	self:Bar(L.bar_ignite_rock, castTime, icon.igniteRock)
end

function module:Reform()
	if not self.db.profile.reform then return end

	self:Bar(L.bar_reform, timer.reform, icon.reform)
end

function module:ThrowBoulder(targetName)
	boulder_victim = targetName
	last_boulder = GetTime()
	
	if self.db.profile.boulderalert then
		self:Message(string.format(L.msg_boulder, targetName), "Attention")
	end

	if self.db.profile.bouldermark then
		self:SetRaidTargetForPlayer(targetName, "Moon")
	end

	if targetName == UnitName("player") and self.db.profile.bouldersay then
		SendChatMessage(L.say_boulder, "SAY")
	end
	
	if self:GetHealth() <= opportunityThreshold and self.db.profile.opportunity then
		self:Bar(L.bar_window, timer.boulderCast - 0.3, icon.window, true, "White")
		if not self.db.profile.boulderalert then -- don't double up on messages
			self:Message(L.msg_windowClosing, "Urgent", true, "Beware")
		end
	end
end

function module:ThrowBoulderOutcome(outcome)
	if outcome == "hit" then
		active_living_stones = active_living_stones + 1
		if self:GetHealth() <= opportunityThreshold and self.db.profile.opportunity then
			self:RemoveBar(L.bar_window)
			self:Message(L.msg_windowClosed, "Important", nil, "Alert")
		end
	end

	if outcome == "miss" then
		if self.db.profile.boulderalert then
			self:Message(L.msg_boulderMiss, "Positive", true, "Long")
		end
		if boulder_victim == UnitName("player") and self.db.profile.bouldersay then
			SendChatMessage(L.msg_boulderMiss, "SAY")
		end
		self:CheckOpportunity()
	end

	-- clear victim
	self:RestorePreviousRaidTargetForPlayer(boulder_victim)
	boulder_victim = nil
end

function module:GetHealth()
	local health = 100 -- set to 9 to test window of opportunity
	if UnitExists(guid.rupturan) then
		health = math.floor((UnitHealth(guid.rupturan)/UnitHealthMax(guid.rupturan)) * 100)
	end
	return health
end

function module:CheckOpportunity()
	if self:GetHealth() > opportunityThreshold or (not self.db.profile.opportunity) then return end

	local windowHigh = last_boulder + timer.boulderCD[2] + timer.boulderCast - GetTime()
	if active_living_stones == 0 and windowHigh > 3 then
		self:Bar(L.bar_window, windowHigh, icon.window, true, "White")
		self:Message(L.msg_windowOpen, "Positive")
	end
end

function module:FindFelheart()
	local found = BigWigs:GetGUIDByName(L.unit_felheart, 1)
	if found then
		guid.felheart = found
		if self.db.profile.felheartalert then
			self:ScheduleRepeatingEvent("RupturanCheckFelheart", self.CheckFelheart, 0.5, self)
		end		
		if self.db.profile.felheartbar then
			self:MonitorBar("Felheart Mana", icon.felheart, guid.felheart, "mana", L.unit_felheart)
		end
	else
		self:ScheduleEvent("RupturanFindFelheart", self.FindFelheart, 0.5, self)
	end
end

function module:CheckFelheart()
	if self.db.profile.felheartalert and guid.felheart and UnitExists(guid.felheart) then
		local percent = math.ceil(UnitMana(guid.felheart)/UnitManaMax(guid.felheart) * 100)
		if percent >= 80 and last_mana_warn + 5 < GetTime() then
			self:Message(string.format(L.msg_felheartMana, percent), "Core", nil, "Beware")
			last_mana_warn = GetTime()
		end
	else
		-- if alert disabled or Felheart doesn't currently exist stop checking
		self:CancelScheduledEvent("RupturanCheckFelheart")
	end
end

function module:FindFragments()
	local newFragment = BigWigs:GetGUIDByName(L.unit_fragment, 1, {guid.fragmentA, guid.fragmentB, guid.fragmentC}) -- can replace unit name for testing
	if newFragment then
		if not guid.fragmentA then
			guid.fragmentA = newFragment
		elseif not guid.fragmentB then
			guid.fragmentB = newFragment
		elseif not guid.fragmentC then
			guid.fragmentC = newFragment
			self:CreateFragmentBars()
			return
		end
	end
	self:ScheduleEvent("RupturanFindFragments", self.FindFragments, 0.2, self)
end

function module:CreateFragmentBars()
	if self.db.profile.fragmentbars then
		self:MonitorBar("fragmentA", icon.fragment, guid.fragmentA, "health", L.bar_fragment, true)
		self:MonitorBar("fragmentB", icon.fragment, guid.fragmentB, "health", L.bar_fragment, true)
		self:MonitorBar("fragmentC", icon.fragment, guid.fragmentC, "health", L.bar_fragment, true)
	end
end

function module:RemoveFragmentBars()
	self:RemoveBar("fragmentA")
	self:RemoveBar("fragmentB")
	self:RemoveBar("fragmentC")
end

-------------------------------------------------------------------------------
--  Testing
-------------------------------------------------------------------------------

function module:Test()
	local print = function (s) DEFAULT_CHAT_FRAME:AddMessage(s) end
	BigWigs:EnableModule(self:ToString())
	self:RegisterEvent("UNIT_CASTEVENT")

	local player = UnitName("player")
	local _,playerGuid = UnitExists("player")
	local raid1 = UnitName("player") or "Raid1"
	local raid2 = UnitName("player") or "Raid2"
	local tests = {
		-- after  1s, simulate the “Crash Landing fades from Living Stone” fade event
		{0,
		"Engage:",
		"CHAT_MSG_MONSTER_YELL",
		"All shall crumble... To dust."},
		{0.5,
		"First Ignite Earth:",
		"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
		"Rupturan the Broken begins to cast Ignite Earth."},
		{1,
		"First Throw Boulder:",
		"UNIT_CASTEVENT",
		{"caster",playerGuid,"START",spellIds.throwBoulder,2000} },
		{4,
		"Boulder Hits:",
		"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
		"Rupturan the Broken's Throw Boulder hits you for 1351."},
		{5,
		"Crash Land test:",
		"CHAT_MSG_SPELL_AURA_GONE_OTHER",
		"Crash Landing fades from Living Stone."},
		{7,
		"Living Stone dies:",
		"CHAT_MSG_COMBAT_HOSTILE_DEATH",
		"Living Stone dies."},
		-- after  2s, simulate the quake damage event
		{11,
		"Quake damage test:",
		"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
		"Dirt Mound's Quake hits you for 717 Nature damage."},
		-- after  3s, simulate the dirt mound spawn on *you*
		{13,
		"Emote player test:",
		"CHAT_MSG_RAID_BOSS_EMOTE",
		"Rupturan commands the earth to crush "..player.."!"},
		{14,
		"Second Throw Boulder:",
		"UNIT_CASTEVENT",
		{"caster",playerGuid,"START",spellIds.throwBoulder,2000} },
		{16,
		"Boulder Misses:",
		"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
		"Rupturan the Broken's Throw Boulder missed you."},
		{17,
		"Emote raid1 test:",
		"CHAT_MSG_RAID_BOSS_EMOTE",
		"Rupturan commands the earth to crush "..raid1.."!"},
		{18,
		"Second Ignite Earth:",
		"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
		"Rupturan the Broken begins to cast Ignite Earth."},
		{20,
		"Emote raid2 test:",
		"CHAT_MSG_RAID_BOSS_EMOTE",
		"Rupturan commands the earth to crush "..raid2.."!"},
		{22,
		"Phase 2 change:",
		"CHAT_MSG_MONSTER_YELL",
		"Let the cracks of this world destroy you.."},
		{25,
		"Ignite Rock Cast SuperWoW:",
		"UNIT_CASTEVENT",
		{"player", "player", "START", spellIds.igniteRock, 3000} },
		{25.5,
		"Ignite Rock Cast vanilla:",
		"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
		"Fragment of Rupturan begins to cast Ignite Rock." },
		{30,
		"Ignite Rock Affliction:",
		"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
		"You are afflicted by Ignite Rock." },
		{34,
		"Reform Cast SuperWoW:",
		"UNIT_CASTEVENT",
		{"player", "player", "START", spellIds.reform, 10000} },
		{34.5,
		"Reform Cast vanilla 1-1:",
		"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF",
		"Fragment of Rupturan begins to cast Reform." },
		{34.6,
		"Reform Cast vanilla 1-2:",
		"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF",
		"Fragment of Rupturan begins to cast Reform." },
		{37,
		"Reform Cast vanilla 2:",
		"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF",
		"Fragment of Rupturan begins to cast Reform." },
		{40,
		"Boss kill:",
		"CHAT_MSG_COMBAT_HOSTILE_DEATH",
		"Rupturan the Broken dies."},
	}

	for i, t in ipairs(tests) do
		if type(t[2]) == "string" then
			local t1,t2,t3,t4 = t[1],t[2],t[3],t[4]
			self:ScheduleEvent("RupturanTest"..i, function()
				print(t2)
				if type(t4) == "table" then
					self:TriggerEvent(t3, unpack(t4))
				else
					self:TriggerEvent(t3, t4)
				end
			end, t1)
		else
			self:ScheduleEvent("RupturanTest"..i, t[2], t[1])
		end
	end

	self:Message("Rupturan test started", "Positive")
	return true
end
-- /run BigWigs:GetModule("Rupturan the Broken"):Test()

-- to test the Window of Opportunity functionality set health inside GetHealth() temporarily to 9
-- no test for Felheart mana alert and mana bar available
