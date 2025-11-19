local module, L = BigWigs:ModuleDeclaration("Anomalus", "Karazhan")

-- module variables
module.revision = 30002
module.enabletrigger = module.translatedName
module.toggleoptions = { "arcaneoverload", "arcaneoverloadsay", "markdampenedplayers", "yellondampen", -1, "arcaneprison", "unstablemagic", -1, "manaboundstrike", "manaboundframe", -1, "printanomalus", "bosskill" }
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Tower of Karazhan"],
	AceLibrary("Babble-Zone-2.2")["Tower of Karazhan"],
}

-- module defaults
module.defaultDB = {
	arcaneoverload = true,
	arcaneoverloadsay = true,
	markdampenedplayers = false,
	yellondampen = false,
	arcaneprison = true,
	unstablemagic = true,
	manaboundstrike = true,
	manaboundframe = true,
	manaboundframeposx = 100,
	manaboundframeposy = 300,
	printanomalus = false,
}

-- localization
L:RegisterTranslations("enUS", function()
	return {
		cmd = "Anomalus",

		arcaneoverload_cmd = "arcaneoverload",
		arcaneoverload_name = "Arcane Overload Alert",
		arcaneoverload_desc = "Warns about other players getting affected by Arcane Overload (bomb), marks them with Skull, and shows a cooldown timer",
		
		arcaneoverloadsay_cmd = "arcaneoverloadsay",
		arcaneoverloadsay_name = "Arcane Overload Announce",
		arcaneoverloadsay_desc = "Announce to /say when you get the bomb",

		markdampenedplayers_cmd = "markdampenedplayers",
		markdampenedplayers_name = "Mark Dampened Players",
		markdampenedplayers_desc = "Mark players affected by Arcane Dampening if there are unused raid icons (requires assistant or leader)",

		yellondampen_cmd = "yellondampen",
		yellondampen_name = "Soaker Yell",
		yellondampen_desc = "Announce that you are ready to soak with a yell",

		arcaneprison_cmd = "arcaneprison",
		arcaneprison_name = "Arcane Prison Alert",
		arcaneprison_desc = "Warns when players get affected by Arcane Prison",

		unstablemagic_cmd = "unstablemagic",
		unstablemagic_name = "Unstable Magic Alert",
		unstablemagic_desc = "Warns when standing in an Unstable Magic zone",

		manaboundstrike_cmd = "manaboundstrike",
		manaboundstrike_name = "Manabound Strike Alert",
		manaboundstrike_desc = "Warns when players get affected by Manabound Strike stacks",

		manaboundframe_cmd = "manaboundframe",
		manaboundframe_name = "Manabound Strikes Frame",
		manaboundframe_desc = "Shows a frame with player stacks and timers for Manabound Strikes",

		printanomalus_cmd = "printanomalus",
		printanomalus_name = "Troubleshoot Info",
		printanomalus_desc = "Print information to your main chat window: Bomb gains, deaths to Unstable Magic zones",


		trigger_arcaneOverloadYou = "You are afflicted by Arcane Overload",
		trigger_arcaneOverloadOther = "(.+) is afflicted by Arcane Overload",
		msg_arcaneOverloadYou = "BOMB ON YOU",
		say_arcaneOverloadYou = "I have the bomb!",
		msg_arcaneOverloadOther = "BOMB on %s!",
		bar_arcaneOverload = "Next Bomb",
		bar_arcaneOverloadExplosion = "BOMB ON YOU Explosion",

		trigger_arcaneDampeningYou = "You are afflicted by Arcane Dampening",
		trigger_arcaneDampening = "(.+) is afflicted by Arcane Dampening",
		yell_arcaneDampening = "I can soak now!",
		bar_arcaneDampening = "Arcane Dampening - Can Soak",
		trigger_arcaneDampeningFade = "Arcane Dampening fades from (.+)",

		trigger_arcanePrison = "(.+) is afflicted by Arcane Prison",
		msg_arcanePrison = "Arcane Prison on %s!",
		
		debuff_unstableMagic = "Unstable Magic",
		bar_unstableMagic = "Floor Zone exploding",
		msg_unstableMagicSoak = "Soaking...",
		msg_unstableMagicRun = "Move out of the floor zone!",
		msg_unstableMagicBomb = "BOMB + FLOOR ZONE!",
		warn_unstableMagicRun = "MOVE!",

		trigger_manaboundStrike1 = "(.+) is afflicted by Manabound Strikes%.",
		trigger_manaboundStrike = "(.+) is afflicted by Manabound Strikes %((%d+)%)",
		trigger_manaboundFade = "Manabound Strikes fades from (.+)",

		bar_manaboundExpire = "Manabound stacks expire",
		
		trigger_deathWish = "You are afflicted by Death Wish",
		say_deathWishAR = "Death Wish reduced your AR to ",
		say_deathWishFail = "I used Death Wish and it reduced my AR below 200.",

		trigger_unstableMagicHit = "Unstable Magic hits (.+) for (.+) Arcane damage",
	}
end)

-- timer and icon variables
local timer = {
	arcaneOverload = {
		7, 15, 13.5, 12.1, 10.9, 9.8, 8.8, 8, 7.2, 6.5, 5.8, 5.2, 4.5
	},
	minArcaneOverload = 4.5, -- minimum time between Arcane Overload casts
	manaboundDuration = 60,
	arcaneOverloadExplosion = 15,
	arcaneDampening = 45, -- duration of Arcane Dampening
	unstableMagic = 8, -- duration of Arcane Dampening
}

local icon = {
	arcaneOverload = "INV_Misc_Bomb_04",
	arcanePrison = "Spell_Frost_Glacier",
	unstableMagic = "Spell_Nature_WispSplode",
	manaboundStrike = "Spell_Arcane_FocusedPower",
	manaboundExpire = "Spell_Holy_FlashHeal",
	arcaneDampening = "Spell_Nature_AbolishMagic", -- icon for Arcane Dampening
}

local syncName = {
	arcaneOverload = "AnomalusArcaneOverload" .. module.revision,
	arcanePrison = "AnomalusArcanePrison" .. module.revision,
	manaboundStrike = "AnomalusManaboundStrike" .. module.revision,
	manaboundStrikeFade = "AnomalusManaboundStrikeFade" .. module.revision,
	arcaneDampening = "AnomalusArcaneDampening" .. module.revision,
	arcaneDampeningFade = "AnomalusArcaneDampeningFade" .. module.revision,
}

local maxManaboundPlayers = 10
local arcaneOverloadCount = 0
local manaboundStrikesPlayers = {}
local dampenedPlayers = {}
local inZoneUntil = 0
local lastBomb = 0

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictionEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("PLAYER_AURAS_CHANGED")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SpellHitEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "SpellHitEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "SpellHitEvent")

	self:ThrottleSync(3, syncName.arcaneOverload)
	self:ThrottleSync(3, syncName.arcanePrison)
	self:ThrottleSync(3, syncName.manaboundStrike)
	self:ThrottleSync(3, syncName.manaboundStrikeFade)
	self:ThrottleSync(3, syncName.arcaneDampening)
	self:ThrottleSync(3, syncName.arcaneDampeningFade)

	self:UpdateManaboundStatusFrame()
end

function module:OnSetup()
	self.started = nil
end

function module:OnEngage()
	arcaneOverloadCount = 1
	manaboundStrikesPlayers = {}
	inZoneUntil = 0

	if self.db.profile.arcaneoverload then
		self:Bar(L["bar_arcaneOverload"], timer.arcaneOverload[arcaneOverloadCount], icon.arcaneOverload)
	end

	if self.db.profile.manaboundframe then
		self:ScheduleRepeatingEvent("UpdateManaboundStatusFrame", self.UpdateManaboundStatusFrame, 1, self)
	end
end

function module:OnDisengage()
	self:CancelScheduledEvent("UpdateManaboundStatusFrame")

	if self.manaboundStatusFrame then
		self.manaboundStatusFrame:Hide()
	end
end

function module:AfflictionEvent(msg)
	-- Arcane Overload
	if string.find(msg, L["trigger_arcaneOverloadYou"]) and GetTime() > lastBomb + 2 then
		local player = UnitName("player")
		self:ArcaneOverload(player) -- let's not miss a sync
		self:Sync(syncName.arcaneOverload .. " " .. player)
		if self.db.profile.printanomalus then
			print(msg)
		end
		lastBomb = GetTime() -- double debuffs so skip the second
	else
		local _, _, player = string.find(msg, L["trigger_arcaneOverloadOther"])
		if player then
			self:Sync(syncName.arcaneOverload .. " " .. player)
			if self.db.profile.printanomalus then
				print(msg)
			end
		end
	end

	-- Arcane Prison
	local _, _, player = string.find(msg, L["trigger_arcanePrison"])
	if player then
		self:Sync(syncName.arcanePrison .. " " .. player)
	end

	-- Manabound Strikes
	local _, _, player, count = string.find(msg, L["trigger_manaboundStrike"])
	if player and count then
		self:Sync(syncName.manaboundStrike .. " " .. player .. " " .. count)
	end
	local _, _, player = string.find(msg, L["trigger_manaboundStrike1"])
	if player then
		self:Sync(syncName.manaboundStrike .. " " .. player .. " " .. 1)
	end

	-- Arcane Dampening
	if string.find(msg, L["trigger_arcaneDampeningYou"]) then
		self:Sync(syncName.arcaneDampening .. " " .. UnitName("player"))
	else
		local _, _, player = string.find(msg, L["trigger_arcaneDampening"])
		if player then
			self:Sync(syncName.arcaneDampening .. " " .. player)
		end
	end
	
	-- Death Wish
	if string.find(msg, L["trigger_deathWish"]) then
		local _, AR = UnitResistance("player",6)
		if AR < 200 then
			SendChatMessage(L["say_deathWishFail"], "RAID")
		else
			print(L["say_deathWishAR"]..AR)
		end
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	local _, _, player = string.find(msg, L["trigger_manaboundFade"])
	if player then
		self:Sync(syncName.manaboundStrikeFade .. " " .. player)
	end

	-- Arcane Dampening faded
	local _, _, player = string.find(msg, L["trigger_arcaneDampeningFade"])
	if player then
		self:Sync(syncName.arcaneDampeningFade .. " " .. player)
	end

	-- remove bar
	self:RemoveBar(L["bar_manaboundExpire"])
end

function module:CHAT_MSG_SPELL_AURA_GONE_PARTY(msg)
	local _, _, player = string.find(msg, L["trigger_manaboundFade"])
	if player then
		self:Sync(syncName.manaboundStrikeFade .. " " .. player)
	end

	-- Arcane Dampening faded
	local _, _, player = string.find(msg, L["trigger_arcaneDampeningFade"])
	if player then
		self:Sync(syncName.arcaneDampeningFade .. " " .. player)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	local _, _, player = string.find(msg, L["trigger_manaboundFade"])
	if player then
		self:Sync(syncName.manaboundStrikeFade .. " " .. player)
	end

	-- Arcane Dampening faded
	local _, _, player = string.find(msg, L["trigger_arcaneDampeningFade"])
	if player then
		self:Sync(syncName.arcaneDampeningFade .. " " .. player)
	end
end

function module:PLAYER_AURAS_CHANGED()
	local duration = timer.unstableMagic + 2
	local i=0
	while not (GetPlayerBuff(i,"HARMFUL") == -1) do -- scan all debuffs
		local buffIndex = GetPlayerBuff(i,"HARMFUL")
		if GetPlayerBuffTexture(buffIndex) == "Interface\\Icons\\"..icon.unstableMagic then -- right icon, but Arcane Overload has the same
			local name = BigWigs:BuffNameByIndex(buffIndex)
			if name and name == L["debuff_unstableMagic"] then -- confirmed name
				local newDuration = GetPlayerBuffTimeLeft(buffIndex)
				if newDuration < duration then -- store shortest debuff
					duration = newDuration
				end
			end
		end
		i=i+1
	end
	
	if duration < timer.unstableMagic + 1 then -- debuff found
		if GetTime() + duration > inZoneUntil or GetTime() + duration < inZoneUntil - 0.3 then -- new zone, warn about it
			self:UnstableMagic(duration)
			inZoneUntil = GetTime() + duration + 0.1
		end		
	else -- no debuff found, reset timer to get warnings again
		if inZoneUntil > 0 then -- if leaving zone confirm safety, cancel bar
			self:Sound("Long")
			self:RemoveBar(L["bar_unstableMagic"])
		end
		inZoneUntil = 0
	end	
end

function module:UnstableMagic(duration)
	-- infer player status from which bars are currently active
	local bomb = self:BarStatus(L["bar_arcaneOverloadExplosion"])
	local dampened, time, elapsed = self:BarStatus(L["bar_arcaneDampening"])
	
	if bomb then -- always warn
		self:RemoveWarningSign(icon.arcaneOverload, true) -- override bomb sign
		self:WarningSign(icon.unstableMagic, 3, true, L["msg_unstableMagicBomb"])
		self:Message(L["msg_unstableMagicBomb"], "Important")
		self:Message(L["msg_unstableMagicBomb"], "Important")
		self:Message(L["msg_unstableMagicBomb"], "Important", true, "RunAway")
		self:Bar(L["bar_unstableMagic"], duration, icon.unstableMagic, true, "red")
	elseif dampened and time - elapsed > duration + 0.1 and self.db.profile.unstablemagic then -- notify if enough time and enabled
		self:Message(L["msg_unstableMagicSoak"], "Positive", true, "Long")
		self:Bar(L["bar_unstableMagic"], duration, icon.unstableMagic, true, "green")
	elseif self.db.profile.unstablemagic then -- warn if enabled
		self:Message(L["msg_unstableMagicRun"], "Urgent", true, "RunAway")
		self:WarningSign(icon.unstableMagic, 2, true, L["warn_unstableMagicRun"])
		self:Bar(L["bar_unstableMagic"], duration, icon.unstableMagic, true, "red")
	end
end

function module:SpellHitEvent(msg)
	if self.db.profile.printanomalus then
		local _,_,player,amount = string.find(msg, L["trigger_unstableMagicHit"])
		if player and amount and tonumber(amount) > 8000 then
			print(msg)
		end
	end
end

function module:OnFriendlyDeath(msg)
	-- Remove raid marker when a player dies
	local _, _, player = string.find(msg, "(.+) dies")
	if player and self.db.profile.markdampenedplayers and dampenedPlayers[player] then
		self:RemoveDampenedPlayerMark(player)
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.arcaneOverload and rest and rest ~= UnitName("player") then
		self:ArcaneOverload(rest)
	elseif sync == syncName.arcanePrison and rest then
		self:ArcanePrison(rest)
	elseif string.find(sync, syncName.manaboundStrike) and rest then
		local _, _, player, count = string.find(rest, "([^%s]+) (%d+)")
		if player and count then
			self:ManaboundStrike(player, count)
		end
	elseif sync == syncName.manaboundStrikeFade and rest then
		self:ManaboundStrikeFade(rest)
	elseif sync == syncName.arcaneDampening and rest then
		self:ArcaneDampening(rest)
	elseif sync == syncName.arcaneDampeningFade and rest then
		self:ArcaneDampeningFade(rest)
	end
end

function module:ArcaneOverload(player)
	arcaneOverloadCount = arcaneOverloadCount + 1

	-- Calculate next timer (minimum 4.5 seconds)
	local nextTimer = timer.arcaneOverload[arcaneOverloadCount] or timer.minArcaneOverload

	if player == UnitName("player") then -- always show personal warning
		self:Message(L["msg_arcaneOverloadYou"], "Important", true, "Beware")
		self:WarningSign(icon.arcaneOverload, 5, true, L["msg_arcaneOverloadYou"])
		self:Bar(L["bar_arcaneOverloadExplosion"], timer.arcaneOverloadExplosion, icon.arcaneOverload, true, "red")
		if self.db.profile.arcaneoverloadsay then
			SendChatMessage(L["say_arcaneOverloadYou"], "SAY")
		end
		-- force re-check for floor zones
		inZoneUntil = 0
		self:PLAYER_AURAS_CHANGED()
	elseif self.db.profile.arcaneoverload then
		self:Message(string.format(L["msg_arcaneOverloadOther"], player), "Important")
	end
	
	if self.db.profile.arcaneoverload then
		-- set latest bomb as skull
		self:SetRaidTargetForPlayer(player, 8)

		self:RemoveBar(L["bar_arcaneOverload"])
		self:Bar(L["bar_arcaneOverload"], nextTimer, icon.arcaneOverload)
	end
end

function module:ArcanePrison(player)
	if self.db.profile.arcaneprison then
		self:Message(string.format(L["msg_arcanePrison"], player), "Attention")
	end
end

function module:ManaboundStrike(player, count)
	if tonumber(count) then
		-- Update or add player to tracking table
		manaboundStrikesPlayers[player] = {
			count = tonumber(count),
			expires = GetTime() + timer.manaboundDuration
		}

		-- Only show bar for the player's own debuff
		if player == UnitName("player") and self.db.profile.manaboundstrike then
			self:RemoveBar(L["bar_manaboundExpire"])
			self:Bar(L["bar_manaboundExpire"], timer.manaboundDuration, icon.manaboundExpire)
		end

		self:UpdateManaboundStatusFrame()
	end
end

function module:ManaboundStrikeFade(player)
	-- Remove player from tracking table
	if manaboundStrikesPlayers[player] then
		manaboundStrikesPlayers[player] = nil

		-- Only remove the player's own bar
		if player == UnitName("player") then
			self:RemoveBar(L["bar_manaboundExpire"])
		end

		self:UpdateManaboundStatusFrame()
	end
end

function module:ArcaneDampening(player)
	self:MarkDampenedPlayer(player)

	-- Add bar for the player with Arcane Dampening
	if player == UnitName("player") then
		self:Bar(L["bar_arcaneDampening"], timer.arcaneDampening, icon.arcaneDampening)
		if self.db.profile.yellondampen then
			SendChatMessage(L["yell_arcaneDampening"], "YELL")
		end
	end
end

function module:ArcaneDampeningFade(player)
	self:RemoveDampenedPlayerMark(player)

	-- Remove the bar if it's the player
	if player == UnitName("player") then
		self:RemoveBar(L["bar_arcaneDampening"])
	end
end

function module:OnFriendlyDeath(msg)
	-- Remove raid marker when a player dies
	local _, _, player = string.find(msg, "(.+) dies")
	if player then
		self:RemoveDampenedPlayerMark(player)
	end
end

function module:MarkDampenedPlayer(player)
	if self.db.profile.markdampenedplayers then
		-- don't use skull mark as that is reserved for the latest Arcane Overload
		local markToUse = self:GetAvailableRaidMark({ 8 })
		if markToUse then
			self:SetRaidTargetForPlayer(player, markToUse)
		end
	end
end

function module:RemoveDampenedPlayerMark(player)
	if self.db.profile.markdampenedplayers then
		self:RestorePreviousRaidTargetForPlayer(player)
	end
end

function module:UpdateManaboundStatusFrame()
	if not self.db.profile.manaboundframe then
		if self.manaboundStatusFrame then
			self.manaboundStatusFrame:Hide()
		end
		return
	end

	-- Create frame if needed
	if not self.manaboundStatusFrame then
		self.manaboundStatusFrame = CreateFrame("Frame", "AnomalusManaboundFrame", UIParent)
		self.manaboundStatusFrame.module = self
		self.manaboundStatusFrame:SetWidth(200)
		self.manaboundStatusFrame:SetHeight(120)
		self.manaboundStatusFrame:ClearAllPoints()
		local s = self.manaboundStatusFrame:GetEffectiveScale()
		self.manaboundStatusFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",
				(self.db.profile.manaboundframeposx or 100) / s,
				(self.db.profile.manaboundframeposy or 300) / s)
		self.manaboundStatusFrame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 8, right = 8, top = 8, bottom = 8 }
		})
		self.manaboundStatusFrame:SetBackdropColor(0, 0, 0, 1)

		-- Allow dragging
		self.manaboundStatusFrame:SetMovable(true)
		self.manaboundStatusFrame:EnableMouse(true)
		self.manaboundStatusFrame:RegisterForDrag("LeftButton")
		self.manaboundStatusFrame:SetScript("OnDragStart", function()
			this:StartMoving()
		end)
		self.manaboundStatusFrame:SetScript("OnDragStop", function()
			this:StopMovingOrSizing()
			local scale = this:GetEffectiveScale()
			this.module.db.profile.manaboundframeposx = this:GetLeft() * scale
			this.module.db.profile.manaboundframeposy = this:GetTop() * scale
		end)

		-- Header - Column labels
		self.manaboundStatusFrame.header = self.manaboundStatusFrame:CreateFontString(nil, "ARTWORK")
		self.manaboundStatusFrame.header:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		self.manaboundStatusFrame.header:SetPoint("TOPLEFT", self.manaboundStatusFrame, "TOPLEFT", 10, -10)
		self.manaboundStatusFrame.header:SetText("Timer | Player name | Stack count")

		-- Create player lines (will be populated dynamically)
		self.manaboundStatusFrame.lines = {}
		for i = 1, maxManaboundPlayers do
			-- Support up to maxManaboundPlayers players
			local line = {}

			-- Timer column
			line.timer = self.manaboundStatusFrame:CreateFontString(nil, "ARTWORK")
			line.timer:SetFont("Fonts\\FRIZQT__.TTF", 9)
			line.timer:SetPoint("TOPLEFT", self.manaboundStatusFrame, "TOPLEFT", 10, -10 - (i * 15))
			line.timer:SetWidth(40)
			line.timer:SetJustifyH("LEFT")

			-- Player name column
			line.player = self.manaboundStatusFrame:CreateFontString(nil, "ARTWORK")
			line.player:SetFont("Fonts\\FRIZQT__.TTF", 9)
			line.player:SetPoint("LEFT", line.timer, "RIGHT", 10, 0)
			line.player:SetWidth(80)
			line.player:SetJustifyH("LEFT")

			-- Stack count column
			line.stacks = self.manaboundStatusFrame:CreateFontString(nil, "ARTWORK")
			line.stacks:SetFont("Fonts\\FRIZQT__.TTF", 9)
			line.stacks:SetPoint("LEFT", line.player, "RIGHT", 10, 0)
			line.stacks:SetWidth(30)
			line.stacks:SetJustifyH("CENTER")

			self.manaboundStatusFrame.lines[i] = line
		end
	end

	self.manaboundStatusFrame:Show()

	-- Update player data in the frame
	local lineIndex = 1
	local now = GetTime()

	for player, data in pairs(manaboundStrikesPlayers) do
		if lineIndex <= maxManaboundPlayers then
			-- Max maxManaboundPlayers players shown
			local line = self.manaboundStatusFrame.lines[lineIndex]

			local timeLeft = math.max(0, data.expires - now)

			-- Set the columns in the new format
			line.timer:SetText(string.format("%.0f", timeLeft))
			line.player:SetText(player)
			line.stacks:SetText(data.count)

			-- Color based on stack count
			if data.count >= 8 then
				line.stacks:SetTextColor(1, 0, 0) -- Red for high stacks
			elseif data.count >= 5 then
				line.stacks:SetTextColor(1, 0.5, 0) -- Orange for medium stacks
			else
				line.stacks:SetTextColor(1, 1, 1) -- White for low stacks
			end

			-- Color timer based on time remaining
			if timeLeft < 5 then
				line.timer:SetTextColor(0, 1, 0) -- Green for about to expire
			else
				line.timer:SetTextColor(1, 1, 1) -- White for normal
			end

			lineIndex = lineIndex + 1
		end
	end

	-- Hide unused lines
	for i = lineIndex, maxManaboundPlayers do
		local line = self.manaboundStatusFrame.lines[i]
		if line then
			line.timer:SetText("")
			line.player:SetText("")
			line.stacks:SetText("")
		end
	end

	-- Adjust frame height based on number of visible entries
	local numEntries = 0
	for _ in pairs(manaboundStrikesPlayers) do
		numEntries = numEntries + 1
	end

	local newHeight = math.max(40, 25 + (numEntries * 17))
	self.manaboundStatusFrame:SetHeight(newHeight)
end

function module:Test()
	-- Initialize module state
	self:Engage()

	local events = {
		-- Arcane Overload (bomb) events
		{ time = 5, func = function()
			print("Test: raid1 gets Arcane Overload")
			local name = UnitName("raid1") or "raid1"
			module:AfflictionEvent(name .. " is afflicted by Arcane Overload")
		end },
		{ time = 15, func = function()
			print("Test: You get Arcane Overload")
			module:AfflictionEvent("You are afflicted by Arcane Overload")
		end },

		-- Arcane Prison event
		{ time = 10, func = function()
			print("Test: raid3 gets Arcane Prison")
			local name = UnitName("raid3") or "raid3"
			module:AfflictionEvent(name .. " is afflicted by Arcane Prison")
		end },

		-- Arcane Dampening events
		{ time = 12, func = function()
			print("Test: raid4 gets Arcane Dampening")
			local name = UnitName("raid4") or "raid4"
			module:AfflictionEvent(name .. " is afflicted by Arcane Dampening")
		end },
		{ time = 16, func = function()
			print("Test: raid5 gets Arcane Dampening")
			local name = UnitName("raid5") or "raid5"
			module:AfflictionEvent(name .. " is afflicted by Arcane Dampening")
		end },
		{ time = 22, func = function()
			print("Test: Arcane Dampening fades from raid5")
			local name = UnitName("raid5") or "raid5"
			module:CHAT_MSG_SPELL_AURA_GONE_PARTY("Arcane Dampening fades from " .. name)
		end },
		{ time = 25, func = function()
			print("Test: raid5 gets Arcane Dampening")
			local name = UnitName("raid5") or "raid5"
			module:AfflictionEvent(name .. " is afflicted by Arcane Dampening")
		end },
		{ time = 28, func = function()
			print("Test: raid1 dies")
			local name = UnitName("raid1") or "raid1"
			module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(name .. " dies")
		end },
		{ time = 31, func = function()
			print("Test: You are afflicted by Arcane Dampening")
			module:AfflictionEvent("You are afflicted by Arcane Dampening.")
		end },
		
		-- Unstable Mana (floor zone) events
		{ time = 19, func = function()
			print("Test: Entering Unstable Magic zone")
			local duration = 8
			inZoneUntil = GetTime() + duration + 0.1
			module:UnstableMagic(duration)
		end },
		{ time = 21, func = function()
			print("Test: Alice fails Unstable Magic zone")
			module:SpellHitEvent("Anomalus's Unstable Magic hits Alice for 25035 Arcane damage. (25034 resisted)")
		end },
		{ time = 26, func = function()
			print("Test: Leaving Unstable Magic zone")
			module:PLAYER_AURAS_CHANGED()
		end },
		{ time = 34, func = function()
			print("Test: Entering Unstable Magic zone")
			local duration = 5
			inZoneUntil = GetTime() + duration + 0.1
			module:UnstableMagic(duration)
		end },
		{ time = 39, func = function()
			print("Test: Unstable Magic zone explodes, you soak.")
			module:PLAYER_AURAS_CHANGED()
			module:SpellHitEvent("Anomalus's Unstable Magic hits you for 2501 Arcane damage. (2500 resisted)")
		end },
		{ time = 48, func = function()
			print("Test: You fail Unstable Magic zone.")
			module:SpellHitEvent("Anomalus 's Unstable Magic hits you for 12519 Arcane damage. (37556 resisted)")
		end },

		-- Manabound Strikes events
		{ time = 3, func = function()
			print("Test: raid1 gets Manabound Strikes")
			local name = UnitName("raid1") or "raid1"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes.")
		end },
		{ time = 8, func = function()
			print("Test: raid2 gets Manabound Strikes")
			local name = UnitName("raid2") or "raid2"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes.")
		end },
		{ time = 13, func = function()
			print("Test: raid1 gets Manabound Strikes (2)")
			local name = UnitName("raid1") or "raid1"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes (2)")
		end },
		{ time = 18, func = function()
			print("Test: raid3 gets Manabound Strikes")
			local name = UnitName("raid3") or "raid3"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes.")
		end },
		{ time = 20, func = function()
			print("Test: raid2 gets Manabound Strikes (2)")
			local name = UnitName("raid2") or "raid2"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes (2)")
		end },
		{ time = 25, func = function()
			print("Test: raid3 gets Manabound Strikes (2)")
			local name = UnitName("raid3") or "raid3"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes (2)")
		end },
		{ time = 30, func = function()
			print("Test: raid1 gets Manabound Strikes (3)")
			local name = UnitName("raid1") or "raid1"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes (3)")
		end },
		{ time = 35, func = function()
			print("Test: raid2 gets Manabound Strikes (3)")
			local name = UnitName("raid2") or "raid2"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes (3)")
		end },
		{ time = 40, func = function()
			print("Test: raid3 gets Manabound Strikes (3)")
			local name = UnitName("raid3") or "raid3"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes (3)")
		end },
		{ time = 45, func = function()
			print("Test: raid6 gets Manabound Strikes")
			local name = UnitName("raid6") or "raid6"
			module:AfflictionEvent(name .. " is afflicted by Manabound Strikes.")
		end },
		-- Death Wish event
		{ time = 47, func = function()
			print("Test: You are afflicted by Death Wish")
			module:AfflictionEvent("You are afflicted by Death Wish.")
		end },
		-- End of Test
		{ time = 50, func = function()
			print("Test: Disengage")
			module:Disengage()
		end },
	}

	-- Schedule each event at its absolute time
	for i, event in ipairs(events) do
		self:ScheduleEvent("AnomalusTest" .. i, event.func, event.time)
	end

	self:Message("Anomalus test started", "Positive")
	return true
end

-- Test command:
-- /run local m=BigWigs:GetModule("Anomalus"); BigWigs:SetupModule("Anomalus");m:Test();
