local module, L = BigWigs:ModuleDeclaration("King", "Karazhan")

-- module variables
module.revision = 30004
module.enabletrigger = module.translatedName
module.toggleoptions = { "kingsfury", "kingscursecd", "voidzone", -1, "subservienceyou", "subservienceothers", "subserviencecast", "marksubservience", "decursebow", "throttlebow", "charmingpresence", "markmindcontrol", "queensfury", -1, "shieldbashbar", "knightsglory", "bishoptonguesalert", "bishopvolley", "empoweredsb", -1, "printchess", "bosskill" }
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Tower of Karazhan"],
	AceLibrary("Babble-Zone-2.2")["Tower of Karazhan"],
}
module.wipemobs = { "Knight", "Bishop", "Rook" }

local _, playerClass = UnitClass("player")

-- module defaults
module.defaultDB = {
	kingsfury = true,
	kingscursecd = true,
	voidzone = true,
	subservienceyou = true,
	subservienceothers = false,
	subserviencecast = playerClass == "SHAMAN",
	marksubservience = true,
	decursebow = playerClass == "MAGE" or playerClass == "DRUID",
	throttlebow = true,
	charmingpresence = playerClass == "SHAMAN",
	markmindcontrol = true,
	queensfury = false,
	shieldbashbar = false,
	knightsglory = false,
	bishoptonguesalert = true,
	bishopvolley = true,
	empoweredsb = false,
	printchess = false,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "ChessEvent",

		kingsfury_cmd = "kingsfury",
		kingsfury_name = "King's Fury Alert",
		kingsfury_desc = "Warns when the King begins to cast King's Fury",

		kingscursecd_cmd = "kingscursecd",
		kingscursecd_name = "King's Curse Cooldown",
		kingscursecd_desc = "Shows a timer bar about the earliest possible King's Curse (41-50s)",

		voidzone_cmd = "voidzone",
		voidzone_name = "Void Zone Alert",
		voidzone_desc = "Warns when King casts Blunder (Void Zone)",

		subservienceyou_cmd = "subservienceyou",
		subservienceyou_name = "Dark Subservience on You",
		subservienceyou_desc = "Warns when you are afflicted by Dark Subservience or when the Queen is casting it on you",

		subservienceothers_cmd = "subservienceothers",
		subservienceothers_name = "Dark Subservience on Others",
		subservienceothers_desc = "Warns when others are afflicted by Dark Subservience",

		subserviencecast_cmd = "subserviencecast",
		subserviencecast_name = "Dark Subservience Casts",
		subserviencecast_desc = "Shows incoming cast messages for Dark Subservience (for Grounding Totem)",

		marksubservience_cmd = "marksubservience",
		marksubservience_name = "Mark Subservience Target",
		marksubservience_desc = "Marks players affected by Dark Subservience with Skull raid icon (requires assistant or leader)",

		decursebow_cmd = "decursebow",
		decursebow_name = "Decurse Reminder for Bowing Players",
		decursebow_desc = "Shows a notification with decurse button for players who need to bow",

		throttlebow_cmd = "throttlebow",
		throttlebow_name = "Throttle /bow",
		throttlebow_desc = "Throttle the Visual Display of other people's /bow",

		charmingpresence_cmd = "charmingpresence",
		charmingpresence_name = "Charming Presence Timer",
		charmingpresence_desc = "Shows a timer for when the Queen will cast Charming Presence",

		markmindcontrol_cmd = "markmindcontrol",
		markmindcontrol_name = "Mark Mind Controlled Target",
		markmindcontrol_desc = "Marks players affected by King's Curse with X raid icon (requires assistant or leader)",

		queensfury_cmd = "queensfury",
		queensfury_name = "Queen's Fury Magnitude",
		queensfury_desc = "Warns about the current magnitude of Queen's Fury (ramping-up aoe in phase 3)",

		shieldbashbar_cmd = "shieldbashbar",
		shieldbashbar_name = "Shield Bash CD Bar",
		shieldbashbar_desc = "Shows a cooldown bar for Rook's Shield Bash",

		knightsglory_cmd = "knightsglory",
		knightsglory_name = "Knight's Glory Alert",
		knightsglory_desc = "Warns when King or Bishop gain Knight's Glory (15yd proximity aura, +50% cast speed)",

		bishoptonguesalert_cmd = "bishoptonguesalert",
		bishoptonguesalert_name = "Bishop Curse of Tongues Alert",
		bishoptonguesalert_desc = "Alerts when the Bishop needs Curse of Tongues applied",

		bishopvolley_cmd = "bishopvolley",
		bishopvolley_name = "Bishop Shadow Bolt Volley Alert",
		bishopvolley_desc = "Shows an accurate timer bar when Bishop is casting Shadow Bolt Volley",

		empoweredsb_cmd = "empoweredsb",
		empoweredsb_name = "Bishop Empowered Shadow Bolt Alert",
		empoweredsb_desc = "Warns when Bishop begins to cast an Empowered Shadow Bolt so the tank can back off",

		printchess_cmd = "printchess",
		printchess_name = "Troubleshoot Info",
		printchess_desc = "Print information to your main chat window: King's Fury cast start, King's Fury hide fails, Dark Subservience /bow fails",


		trigger_kingCastFury = "King begins to cast King(.+)Fury", -- they used special character apostrophe for this and queen's Fury
		trigger_voidzone = "King casts Blunder.",

		trigger_subservienceYou = "You are afflicted by Dark Subservience",
		trigger_subservienceOther = "(.+) is afflicted by Dark Subservience",
		trigger_subservienceFade = "Dark Subservience fades from (.+)",
		trigger_subservienceFailed = "Dark Subservience fails. Grounding Totem", --not observed in logs since April 2025

		trigger_kingscurseYou = "You are afflicted by King's Curse", --unused
		trigger_kingscurseOther = "(.+) is afflicted by King's Curse",
		trigger_kingscurseFade = "King's Curse fades from (.+)",

		trigger_charmingPresenceYou = "You are afflicted by Charming Presence",
		trigger_charmingPresenceOther = "(.+) is afflicted by Charming Presence",
		trigger_charmingPresenceFade = "Charming Presence fades from (.+)",
		
		trigger_queensfury = "Queen gains (.+) Fury %((%d+)%)%.",

		trigger_knightsGloryGain = "(.+) gains Knight",
		trigger_knightsGloryFade = "Glory fades from (.+)%.",
		trigger_tonguesGain = "(.+) gains Curse of Tongues",
		trigger_tonguesAfflicted = "(.+) is afflicted by Curse of Tongues",
		trigger_tonguesFade = "Curse of Tongues fades from (.+)%.",
		
		trigger_bishopVolleyCast = "Bishop begins to cast Shadow Bolt Volley",
		trigger_empoweredCast = "Bishop begins to cast Empowered Shadow Bolt",

		msg_kingCastFury = "King's Fury! - go hide",
		msg_kingCastFuryFast = "Hasted King's Fury! - HIDE",
		msg_kingFurySafe = "Safe!",
		msg_voidzone = "Void Zone MOVE!",

		msg_subservienceYou = "YOU need to go Bow to the Queen!",
		msg_subservienceOther = "%s needs to go Bow!",
		msg_queenCastingSubservience = "Queen began casting on %s!",
		msg_queenCastingSubservienceYou = "Dark Subservience incoming! Get ready to /bow (unless grounded).",
		msg_queenSubservienceTotem = "Totem ate cast instead of %s!",
		msg_queenSubservienceTotemYou = "Safe from /bow! Totem ate cast.",
		msg_queensfury = "Queen's Fury %s ticking for ",

		warning_bow = "BOW TO THE QUEEN!",
		warn_kingsfury = "HIDE",

		bar_subservience = "Go right in front of Queen and Bow! >Click Me<",
		bar_kingsfury = "King's Fury - Hide!",
		bar_charmingpresence = "Next Charming Presence",
		bar_decursebow = "Decurse %s >Click Me<",
		bar_curseCD = "possible King's Curse",

		bishop_name = "Bishop",
		bishop_needsTongues = "Bishop needs Curse of Tongues!",
		
		msg_gloryGain = "Knight too close to the %s!",
		msg_gloryFade = "Knight far enough away from the %s",
		
		bar_bishopVolley = "Volley incoming",
		msg_bishopVolley = "Shadow Bolt Volley incoming",
		msg_empoweredCast = "Empowered SB casting - tank too close!",

		trigger_kingsFuryHit = "Fury hits (.+) for (.+) Holy damage.",
		trigger_subservienceHit = "(.+) suffers (.+) Shadow damage from Queen's Dark Subservience",
		
		bar_shieldbash = "Shield Bash CD",
	}
end)

-- timer and icon variables
local timer = {
	subservience = 8, -- duration of subservience debuff
	kingsfury = 5, -- duration of king's fury cast
	charmingpresence = 12, -- queen casts every 12 seconds
	throttlebow = 1.5, -- bow throttle rate
	bishopScan = 5, -- check bishop debuffs every 5 seconds
	voidzone = 2, -- duration for void zone warning sign
	sbvolley = 3, --base cast time of Shadow Bolt Volley
	cursecd = {41,50}, --based on logs, removing outliers directly after Fury
	shieldbash = 11, -- rook shield bash cooldown
}

local icon = {
	subservience = "Spell_BrokenHeart", -- icon for subservience
	kingsfury = "Spell_Holy_HolyNova", -- icon for king's fury
	charmingpresence = "Spell_Shadow_ShadowWordDominate", -- icon for charming presence
	kingscurse = "Spell_Shadow_GrimWard", -- icon for King's curse
	voidzone = "spell_shadow_antishadow", -- icon for void zone
	sbvolley = "Spell_Shadow_ShadowBolt",
	shieldbash = "Ability_Warrior_ShieldBash", -- icon for shield bash
}

local kingsCurseTexture = "Interface\\Icons\\Spell_Shadow_GrimWard"

local syncName = {
	subservience = "ChessSubservience" .. module.revision,
	queenCastingSubservience = "ChessQueenCastingSubservience" .. module.revision,
	kingCastFury = "ChessKingCastFury" .. module.revision,
	subservienceFailed = "ChessSubservienceFailed" .. module.revision,
	charmingPresence = "ChessCharmingPresence" .. module.revision,
	queensfury = "ChessQueensFury" .. module.revision,
	bishopNoCurse = "ChessBishopNoCurse" .. module.revision,
	voidzone = "ChessVoidZone" .. module.revision,
	kingGloryGain = "ChessKingGloryGain" .. module.revision,
	kingGloryFade = "ChessKingGloryFade" .. module.revision,
	bishopGloryGain = "ChessBishopGloryGain" .. module.revision,
	bishopGloryFade = "ChessBishopGloryFade" .. module.revision,
	bishopTonguesGain = "ChessBishopTonguesGain" .. module.revision,
	bishopTonguesFade = "ChessBishopTonguesFade" .. module.revision,
	sbvolleyCast = "ChessSbvolleyCast" .. module.revision,
	curseHappened = "ChessCurseHappened" .. module.revision,
	shieldbash = "ChessShieldBash" .. module.revision,
}

local spellIds = {
	subservience = 41647, -- Dark Subservience
	charmingpresence = 41644,
	kingscurse = 41635,
	blunder = 52667, -- Void Zone
	shieldbash = 51219, -- Shield Bash
}

local bowed = {}
local bishopHasTongues = 0
local bishopHasGlory = 0
local kingHasGlory = 0

local baseChatFrameOnEvent = ChatFrame_OnEvent

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "FadesEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "FadesEvent")

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "CastEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CastEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "CastEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "EnemyDebuffEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "EnemyDebuffEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "SpellHitEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "SpellHitEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SpellHitEvent")

	if self.db.profile.bishoptonguesalert then
		self:ScheduleRepeatingEvent("BishopDebuffScan", self.ScanBishopDebuffs, timer.bishopScan, self)
	end

	-- install wrapper exactly once
	if not self.origChatFrameOnEvent and self.db.profile.throttlebow then
		self.origChatFrameOnEvent = ChatFrame_OnEvent

		ChatFrame_OnEvent = function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
			local msg, who = arg1, arg2

			if not self.origChatFrameOnEvent then
				-- something went wrong, just call the original function
				baseChatFrameOnEvent(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
				ChatFrame_OnEvent = baseChatFrameOnEvent
				return
			end

			-- only throttle OTHER players’ /bow emote when we’re engaged
			if self.engaged and event == "CHAT_MSG_TEXT_EMOTE" and who ~= UnitName("player") and string.find(msg, "^.- bow") then
				local now = GetTime()
				if not bowed[who] or now - bowed[who] >= timer.throttlebow then
					bowed[who] = now
					self.origChatFrameOnEvent(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
				end
			else
				-- everything else goes through as normal
				self.origChatFrameOnEvent(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
			end
		end
	end

	if SUPERWOW_VERSION then
		self:RegisterCastEventsForUnitName("Queen", "QueenCastEvent")
		self:RegisterCastEventsForUnitName("King", "KingCastEvent")
		self:RegisterCastEventsForUnitName("Rook", "RookCastEvent")
	end

	self:ThrottleSync(1, syncName.subservience)
	self:ThrottleSync(2, syncName.queenCastingSubservience)
	self:ThrottleSync(2, syncName.kingCastFury)
	self:ThrottleSync(2, syncName.subservienceFailed)
	self:ThrottleSync(2, syncName.charmingPresence)
	self:ThrottleSync(5, syncName.queensfury)
	self:ThrottleSync(2, syncName.bishopNoCurse)
	self:ThrottleSync(2, syncName.voidzone)
	self:ThrottleSync(1, syncName.kingGloryGain)
	self:ThrottleSync(1, syncName.kingGloryFade)
	self:ThrottleSync(1, syncName.bishopGloryGain)
	self:ThrottleSync(1, syncName.bishopGloryFade)
	self:ThrottleSync(2, syncName.bishopTonguesGain)
	self:ThrottleSync(2, syncName.bishopTonguesFade)
	self:ThrottleSync(5, syncName.sbvolleyCast)
	self:ThrottleSync(5, syncName.curseHappened)
	self:ThrottleSync(5, syncName.shieldbash)
end

function module:OnSetup()
	self.started = nil
end

function module:OnDisable()
	if self.origChatFrameOnEvent and self.db.profile.throttlebow then
		-- remove the wrapper
		ChatFrame_OnEvent = self.origChatFrameOnEvent
		self.origChatFrameOnEvent = nil
	end
end

function module:OnEngage()
	bowed = {}
	bishopHasTongues = 0
	bishopHasGlory = 1
	kingHasGlory = 1

	self.queenTarget = ""

	self:ShieldBash()
end

function module:OnDisengage()
	self:CancelScheduledEvent("BishopDebuffScan")
end

function module:QueenCastEvent(casterGuid, targetGuid, eventType, spellId, castTime)
	if spellId == spellIds.subservience and eventType == "START" then
		self.queenTarget = UnitName(targetGuid) or ""
		self:Sync(syncName.queenCastingSubservience .. " " .. self.queenTarget)
	elseif spellId == spellIds.charmingpresence and eventType == "CAST" then
		self:Sync(syncName.charmingPresence)
	end
end

function module:KingCastEvent(casterGuid, targetGuid, eventType, spellId, castTime)
	if spellId == spellIds.blunder and eventType == "CAST" then
		local voidZoneTarget = UnitName(targetGuid) or ""
		if voidZoneTarget then
			self:Sync(syncName.voidzone .. " " .. voidZoneTarget)
		end
	end
end

function module:RookCastEvent(casterGuid, targetGuid, eventType, spellId, castTime)
	if spellId == spellIds.shieldbash and eventType == "CAST" then
		self:Sync(syncName.shieldbash)
	end
end

function module:CastEvent(msg)
	if string.find(msg, L["trigger_subservienceFailed"]) and self.queenTarget ~= "" then
		self:Sync(syncName.subservienceFailed .. " " .. self.queenTarget)
	elseif string.find(msg, L["trigger_kingCastFury"]) then
		self:Sync(syncName.kingCastFury)
		if self.db.profile.printchess then
			print(msg)
		end
	elseif string.find(msg, L["trigger_bishopVolleyCast"]) then
		self:Sync(syncName.sbvolleyCast)
	elseif self.db.profile.empoweredsb and string.find(msg, L["trigger_empoweredCast"]) then
		self:Message(L["msg_empoweredCast"], "Urgent", nil, "Info")		
	end
end

function module:AfflictionEvent(msg)
	-- Dark Subservience
	if string.find(msg, L["trigger_subservienceYou"]) then
		local player = UnitName("player")
		self:Subservience(player) -- let's not miss a sync
		self:Sync(syncName.subservience .. " " .. player)
		return
	else
		local _, _, player = string.find(msg, L["trigger_subservienceOther"])
		if player then
			self:Sync(syncName.subservience .. " " .. player)
			return
		end
	end
	if self.db.profile.printchess then
		local _,_,player,amount = string.find(msg, L["trigger_subservienceHit"])
		if player and amount and tonumber(amount) > 6000 then
			print(msg)
		end
	end

	-- Charming Presence
	local _, _, player = string.find(msg, L["trigger_charmingPresenceOther"])
	if player and self.db.profile.markmindcontrol then
		-- Mark the player with X raid target
		self:SetRaidTargetForPlayer(player, 7) -- X
		return
	end
	
	-- King's Curse on anyone (just for timing the CD)
	if string.find(msg, L["trigger_kingscurseOther"]) then
		self:Sync(syncName.curseHappened)
		return
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if string.find(msg, L["trigger_subservienceFade"]) then
		self:RemoveBar(L["bar_subservience"])
		self:RemoveWarningSign(icon.subservience, true)
		self:Sound("Long")

		if self.db.profile.marksubservience then
			self:RestorePreviousRaidTargetForPlayer(UnitName("player"))
		end
	elseif string.find(msg, L["trigger_kingscurseFade"]) then
		local player = UnitName("player")
		self:RemoveBar(string.format(L["bar_decursebow"], player))
	end
end

function module:EnemyDebuffEvent(msg)
	-- Queen's Fury
	local _,_,_,fury = string.find(msg, L["trigger_queensfury"])
	if fury then
		self:Sync(syncName.queensfury .. " " .. fury)
	end
	
	-- Knight's Glory
	local _,_,mob = string.find(msg, L["trigger_knightsGloryGain"])
	if mob then
		if mob == module.translatedName then
			self:Sync(syncName.kingGloryGain)
		elseif mob == L["bishop_name"] then
			self:Sync(syncName.bishopGloryGain)
		end
		return
	end
	
	-- Curse of Tongues
	_,_,mob = string.find(msg, L["trigger_tonguesAfflicted"])
	if mob and mob == L["bishop_name"] then
		self:Sync(syncName.bishopTonguesGain)
		return
	end
	_,_,mob = string.find(msg, L["trigger_tonguesGain"])
	if mob and mob == L["bishop_name"] then
		self:Sync(syncName.bishopTonguesGain)
		return
	end
end

function module:FadesEvent(msg)
	local _, _, player = string.find(msg, L["trigger_kingscurseFade"])
	if player then
		self:RemoveBar(string.format(L["bar_decursebow"], player))
		return
	end

	_, _, player = string.find(msg, L["trigger_subservienceFade"])
	if player then
		if self.db.profile.marksubservience then
			self:RestorePreviousRaidTargetForPlayer(player)
		end
		self:RemoveBar(string.format(L["bar_decursebow"], player))
		return
	end

	_, _, player = string.find(msg, L["trigger_charmingPresenceFade"])
	if player then
		if self.db.profile.markmindcontrol then
			self:RestorePreviousRaidTargetForPlayer(player)
		end
		return
	end
	
	_, _, player = string.find(msg, L["trigger_knightsGloryFade"])
	if player then
		if player == module.translatedName then
			self:Sync(syncName.kingGloryFade)
		elseif player == L["bishop_name"] then
			self:Sync(syncName.bishopGloryFade)
		end
		return
	end
	
	_, _, player = string.find(msg, L["trigger_tonguesFade"])
	if player and player == L["bishop_name"] then
		self:Sync(syncName.bishopTonguesFade)
		return
	end
end

function module:OnFriendlyDeath(msg)
	local _, _, player = string.find(msg, "(.+) dies")
	if player then
		-- Remove raid marks for players who die
		if self.db.profile.marksubservience or self.db.profile.markmindcontrol then
			self:RestorePreviousRaidTargetForPlayer(player)
		end

		self:RemoveBar(string.format(L["bar_decursebow"], player))
	end
end

function module:SpellHitEvent(msg)
	if self.db.profile.printchess then
		local _,_,player,amount = string.find(msg, L["trigger_kingsFuryHit"])
		if player and amount and tonumber(amount) > 8000 then
			print(msg)
		end
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.subservience and rest and rest ~= UnitName("player") then
		self:Subservience(rest)
	elseif sync == syncName.queenCastingSubservience then
		self:QueenCastingSubservience(rest)
	elseif sync == syncName.kingCastFury then
		self:KingCastFury()
	elseif sync == syncName.subservienceFailed and rest then
		self:SubservienceFailed(rest)
	elseif sync == syncName.charmingPresence then
		if self.db.profile.charmingpresence then
			self:StartCharmingPresenceTimer()
		end
	elseif sync == syncName.queensfury and rest then
		if self.db.profile.queensfury then
			self:Message(string.format(L["msg_queensfury"], rest)..(tonumber(rest)*70), "Purple")
		end
	elseif sync == syncName.bishopNoCurse then
		self:BishopNeedsCurseOfTongues()
	elseif sync == syncName.voidzone and rest then
		self:VoidZoneAlert(rest)
	elseif sync == syncName.kingGloryGain then
		kingHasGlory = 1
		if self.db.profile.knightsglory then
			self:Message(string.format(L["msg_gloryGain"], module.translatedName), "Urgent", nil, "Beware")
		end
	elseif sync == syncName.kingGloryFade then
		kingHasGlory = 0
		if self.db.profile.knightsglory then
			self:Message(string.format(L["msg_gloryFade"], module.translatedName), "Positive", nil, "Alert")
		end
	elseif sync == syncName.bishopGloryGain then
		bishopHasGlory = 1
		if self.db.profile.knightsglory then
			self:Message(string.format(L["msg_gloryGain"], L["bishop_name"]), "Urgent", nil, "Info")
		end
	elseif sync == syncName.bishopGloryFade then
		bishopHasGlory = 0
		if self.db.profile.knightsglory then
			self:Message(string.format(L["msg_gloryFade"], L["bishop_name"]), "Positive", nil, "Alert")
		end
	elseif sync == syncName.bishopTonguesGain then
		bishopHasTongues = 1
	elseif sync == syncName.bishopTonguesFade then
		bishopHasTongues = 0
	elseif sync == syncName.sbvolleyCast then
		self:ShadowBoltVolley()
	elseif sync == syncName.curseHappened then
		self:CurseHappened()
	elseif sync == syncName.shieldbash then
		self:ShieldBash()
	end
end

function module:StartCharmingPresenceTimer()
	if not self.db.profile.charmingpresence then
		return
	end

	self:Bar(L["bar_charmingpresence"], timer.charmingpresence, icon.charmingpresence)
end

function module:QueenCastingSubservience(playerName)
	self.queenTarget = playerName
	if playerName == UnitName("player") and self.db.profile.subservienceyou then
		self:Message(L["msg_queenCastingSubservienceYou"], "Urgent", nil, "Beware")
	elseif self.db.profile.subserviencecast then
		self:Message(string.format(L["msg_queenCastingSubservience"], playerName), "Attention", nil, "Info")
	end	
end

function module:SubservienceFailed(playerName) --might be defunct
	if playerName == UnitName("player") and self.db.profile.subservienceyou then
		self:Message(L["msg_queenSubservienceTotemYou"], "Positive", nil, "Long")
	elseif self.db.profile.subserviencecast then
		self:Message(string.format(L["msg_queenSubservienceTotem"], playerName), "Positive")
	end	
end

function module:Subservience(player)
	if player == UnitName("player") and self.db.profile.subservienceyou then
		self:Message(L["msg_subservienceYou"], "Important")
		self:WarningSign(icon.subservience, timer.subservience, true, L["warning_bow"])
		self:Bar(L["bar_subservience"], timer.subservience, icon.subservience)

		-- Set the bar to target Queen and bow when clicked
		self:SetCandyBarOnClick("BigWigsBar " .. L["bar_subservience"], function()
			TargetByName("Queen", true)
			DoEmote("bow")
		end)

		self:Sound("GoBow")
	else --Subservience on others
		-- Check for King's Curse directly if decursebow is enabled
		if self.db.profile.decursebow then
			-- Find the player in raid
			local raidTarget = nil
			for i = 1, 40 do
				if UnitExists("raid" .. i) and UnitName("raid" .. i) == player then
					raidTarget = "raid" .. i
					break
				end
			end

			-- If found, check for King's Curse debuff
			if raidTarget then
				for i = 1, 16 do
					local texture = UnitDebuff(raidTarget, i)
					if texture then
						if texture == kingsCurseTexture then
							-- Player has King's Curse, show decurse reminder
							self:DecurseReminder(player, raidTarget)
							break
						end
					else
						break
					end
				end
			end
		end
		
		-- Post warning message if enabled
		if self.db.profile.subservienceothers then
			self:Message(string.format(L["msg_subservienceOther"], player), "Important")
		end		
	end

	if self.db.profile.marksubservience then
		self:SetRaidTargetForPlayer(player, 8) -- Skull
	end
end

function module:DecurseReminder(player, raidTarget)
	if not self.db.profile.decursebow then
		return
	end

	-- Create a bar with decurse functionality
	local barText = string.format(L["bar_decursebow"], player)
	self:Bar(barText, timer.subservience, icon.kingscurse)

	-- Set the bar to target player and cast Remove Curse when clicked
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
	end, player, raidTarget)
end

function module:KingCastFury()
	if not self.db.profile.kingsfury then
		return
	end
	if kingHasGlory == 1 then
		self:Message(L["msg_kingCastFuryFast"], "Attention", nil, "Beware")
	else
		self:Message(L["msg_kingCastFury"], "Attention", nil, "Info")
	end
	local castTime = timer.kingsfury / (1 + (0.5 * kingHasGlory))
	self:Bar(L["bar_kingsfury"], castTime, icon.kingsfury)
	self:WarningSign(icon.kingsfury, castTime, true, L["warn_kingsfury"])
	self:DelayedMessage(castTime+0.2, L["msg_kingFurySafe"], "Positive", false, "Long", false)
end

function module:VoidZoneAlert(player)
	if not self.db.profile.voidzone then
		return
	end

	if player == UnitName("player") then
		self:Message(L["msg_voidzone"], "Important", nil, "Alarm")
		self:WarningSign(icon.voidzone, timer.voidzone, true, L["msg_voidzone"])
		self:Sound("VoidZoneMove")
		SendChatMessage("Void Zone On Me!", "SAY")
	end
end

function module:ScanBishopDebuffs()
	-- Check if current target is Bishop
	if UnitName("target") == L["bishop_name"] then
		-- Scan debuffs
		for i = 1, 16 do
			local texture = UnitDebuff("target", i)
			if texture and string.find(texture, "Spell_Shadow_CurseOfTounges") then
				-- Found Curse of Tongues debuff
				return
			elseif not texture then
				break
			end
		end

		-- Scan buffs
		for i = 1, 32 do
			local texture = UnitBuff("target", i)
			if texture and string.find(texture, "Spell_Shadow_CurseOfTounges") then
				-- Found Curse of Tongues as buff
				return
			elseif not texture then
				break
			end
		end

		-- no curse of tongues found, trigger sync
		self:Sync(syncName.bishopNoCurse)
	end
end

function module:BishopNeedsCurseOfTongues()
	if self.db.profile.bishoptonguesalert then
		if IsRaidLeader() or playerClass == "WARLOCK" then
			-- Alert warlocks that the Bishop needs to be cursed
			self:Message(L["bishop_needsTongues"], "Important", nil, "Alert")
		end
	end
end

function module:ShadowBoltVolley()
	if self.db.profile.bishopvolley then
		local castTime = timer.sbvolley * (1 + bishopHasTongues * 0.6) / (1 + bishopHasGlory * 0.5)
		self:Bar(L["bar_bishopVolley"], castTime, icon.sbvolley)
		self:Message(L["msg_bishopVolley"], "purple", nil, "Alarm")
	end
end

function module:CurseHappened()
	self:RemoveBar(L["bar_curseCD"]) --remove old bar
	if self.db.profile.kingscursecd then
		self:IntervalBar(L["bar_curseCD"], timer.cursecd[1], timer.cursecd[2], icon.kingscurse, true, "Black")
	end
end

function module:ShieldBash()
	if self.db.profile.shieldbashbar then
		self:RemoveBar(L["bar_shieldbash"])
		self:Bar(L["bar_shieldbash"], timer.shieldbash, icon.shieldbash)
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
		-- King's Curse events
		{ time = 1, func = function()
			-- Simulate actual message format
			local msg = originalPlayer .. " is afflicted by King's Curse"
			module:AfflictionEvent(msg)
			print("Test: " .. msg)
		end },

		{ time = 1, func = function()
			-- Simulate actual message format
			local msg = testPlayerName1 .. " is afflicted by King's Curse"
			module:AfflictionEvent(msg)
			print("Test: " .. msg)
		end },

		-- Queen cast with target
		{ time = 2, func = function()
			local targetMsg = "Queen begins to cast Dark Subservience on " .. originalPlayer
			print("Test: " .. targetMsg)
			-- Use the correct sync format
			self:Sync(syncName.queenCastingSubservience .. " " .. originalPlayer)
		end },

		-- Subservience events for self
		{ time = 3, func = function()
			local msg = "You are afflicted by Dark Subservience"
			module:AfflictionEvent(msg)
			print("Test: " .. msg)
		end },

		{ time = 5, func = function()
			print("Test: Scanning Bishop")
			local originalName = L["bishop_name"]
			L["bishop_name"] = UnitName("target")

			-- Run the scan function
			module:ScanBishopDebuffs()

			-- Restore original name
			L["bishop_name"] = originalName
		end },

		{ time = 7, func = function()
			print("Test: Queen begins to cast Charming Presence")
			module:Sync(syncName.charmingPresence)
		end },

		{ time = 9, func = function()
			local msg = "Dark Subservience fades from you"
			module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
			print("Test: " .. msg)
		end },

		{ time = 10, func = function()
			local msg = "Alice suffers 30000 Shadow damage from Queen's Dark Subservience."
			module:AfflictionEvent(msg)
			print("Test: " .. msg)
		end },

		-- Subservience events for another player with King's Curse
		{ time = 12, func = function()
			local msg = testPlayerName1 .. " is afflicted by Dark Subservience"
			module:AfflictionEvent(msg)
			module:DecurseReminder(testPlayerName1, "raid1")
			print("Test: " .. msg)
		end },

		{ time = 18, func = function()
			local msg = "Dark Subservience fades from " .. testPlayerName1
			module:FadesEvent(msg)
			print("Test: " .. msg)
		end },

		-- Test King's Curse fading
		{ time = 20, func = function()
			local msg = "King's Curse fades from " .. testPlayerName1
			module:FadesEvent(msg)
			print("Test: " .. msg)
		end },

		-- Test SBV from Bishop
		{ time = 22, func = function()
			local msg = "Bishop begins to cast Shadow Bolt Volley"
			module:CastEvent(msg)
			print("Test: " .. msg)
		end },

		-- Test subservience failed (grounding totem)
		{ time = 24, func = function()
			self.queenTarget = testPlayerName1
			print("Test: Queen begins to cast Dark Subservience on " .. testPlayerName1)
			self:Sync(syncName.queenCastingSubservience .. " " .. testPlayerName1)
		end },

		{ time = 25, func = function()
			local msg = "Dark Subservience fails. Grounding Totem"
			module:CastEvent(msg)
			print("Test: " .. msg)
		end },

		-- Knight's Glory fade (to set variable properly)
		{ time = 27, func = function()
			local msg = "Knight’s Glory fades from King."
			module:FadesEvent(msg)
			print("Test: " .. msg)
		end },

		-- King's Fury event
		{ time = 28, func = function()
			local msg = "King begins to cast King’s Fury"
			module:CastEvent(msg)
			print("Test: " .. msg)
		end },

		-- Test player death with debuffs
		{ time = 30, func = function()
			local msg = testPlayerName2 .. " is afflicted by Dark Subservience"
			module:AfflictionEvent(msg)
			module:DecurseReminder(testPlayerName2, "raid2")
			print("Test: " .. msg)
		end },

		{ time = 31, func = function()
			local msg = testPlayerName2 .. " is afflicted by King's Curse"
			module:AfflictionEvent(msg)
			print("Test: " .. msg)
		end },

		{ time = 32, func = function()
			local msg = testPlayerName2 .. " dies"
			-- Correct event for player death is CHAT_MSG_COMBAT_FRIENDLY_DEATH
			module:OnFriendlyDeath(msg)
			print("Test: " .. msg)
		end },

		-- Add to the events table inside the Test function
		{ time = 33, func = function()
			print("Test: Scanning Bishop")
			local originalName = L["bishop_name"]
			L["bishop_name"] = UnitName("target")

			-- Run the scan function
			module:ScanBishopDebuffs()

			-- Restore original name
			L["bishop_name"] = originalName
		end },

		-- CoT on Bishop
		{ time = 34, func = function()
			local msg = "Bishop is afflicted by Curse of Tongues."
			module:EnemyDebuffEvent(msg)
			print("Test: " .. msg)
		end },

		-- Knight's Glory fade on Bishop
		{ time = 34, func = function()
			local msg = "Knight’s Glory fades from Bishop."
			module:FadesEvent(msg)
			print("Test: " .. msg)
		end },

		-- Knight's Glory gain
		{ time = 35, func = function()
			local msg = "King gains Knight’s Glory."
			module:EnemyDebuffEvent(msg)
			print("Test: " .. msg)
		end },

		-- King's Fury event
		{ time = 36, func = function()
			local msg = "King begins to cast King’s Fury"
			module:CastEvent(msg)
			print("Test: " .. msg)
		end },

		-- First Shield Bash
		{ time = 37, func = function()
			print("Test: Rook casts Shield Bash")
			module:ShieldBash()
		end },

		-- Test SBV from Bishop with full length
		{ time = 38, func = function()
			local msg = "Bishop begins to cast Shadow Bolt Volley"
			module:CastEvent(msg)
			print("Test: " .. msg)
		end },

		-- King's Fury hit
		{ time = 38, func = function()
			local msg = "King's King’s Fury hits Bob for 18000 Holy damage."
			module:SpellHitEvent(msg)
			print("Test: " .. msg)
		end },

		{ time = 39, func = function()
			local msg = "King's King’s Fury hits BobsPet for 3600 Holy damage."
			module:SpellHitEvent(msg)
			print("Test: " .. msg)
		end },

		-- Knight's Glory fade
		{ time = 40, func = function()
			local msg = "Knight’s Glory fades from King."
			module:FadesEvent(msg)
			print("Test: " .. msg)
		end },

		-- Queen's Fury stack
		{ time = 41, func = function()
			local msg = "Queen gains Queen’s Fury."
			module:EnemyDebuffEvent(msg)
			print("Test: " .. msg)
		end },

		-- Queen's Fury stack
		{ time = 42, func = function()
			local msg = "Queen gains Queen’s Fury (4)."
			module:EnemyDebuffEvent(msg)
			print("Test: " .. msg)
		end },

		-- Add to the events table inside the Test function
		{ time = 43, func = function()
			print("Test: King casts Void Zone (Blunder) on player")
			-- Simulate KingCastEvent with current player as target
			local _, playerGuid = UnitExists("player")
			local kingGuid = "king"
			module:KingCastEvent(kingGuid, playerGuid, "CAST", spellIds.blunder, 0)
		end },

		-- Queen's Fury stack
		{ time = 45, func = function()
			local msg = "Queen gains Queen’s Fury (6)."
			module:EnemyDebuffEvent(msg)
			print("Test: " .. msg)
		end },

		-- Second Shield Bash (11s after first)
		{ time = 48, func = function()
			print("Test: Rook casts Shield Bash")
			module:ShieldBash()
		end },

		-- Add to the events table inside the Test function
		{ time = 52, func = function()
			print("Test: King casts Void Zone (Blunder) on raid1")
			-- Simulate KingCastEvent with current player as target
			local _, playerGuid = UnitExists("raid1")
			local kingGuid = "king"
			module:KingCastEvent(kingGuid, playerGuid, "CAST", spellIds.blunder, 0)
		end },

		-- Test disengage
		{ time = 55, func = function()
			print("Test: Disengage")
			BigWigs:DisableModule("King")
		end },
	}

	-- Schedule each event at its absolute time
	for i, event in ipairs(events) do
		self:ScheduleEvent("ChessEventTest" .. i, event.func, event.time)
	end

	self:Message("Chess Event test started", "Positive")
	return true
end

-- Test command:
-- /run local m=BigWigs:GetModule("King"); BigWigs:SetupModule("King");m:Test();
