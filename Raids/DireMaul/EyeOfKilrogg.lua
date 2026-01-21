
local module, L = BigWigs:ModuleDeclaration("Eye of Kilrogg", "Dire Maul")

module.revision = 30132
module.enabletrigger = module.translatedName
module.toggleoptions = {"netherportal"}
module.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Dire Maul"],
	AceLibrary("Babble-Zone-2.2")["Dire Maul"],
}

L:RegisterTranslations("enUS", function() return {
	cmd = "EyeOfKilrogg",

	netherportal_cmd = "netherportal",
	netherportal_name = "Summon Alert",
	netherportal_desc = "Alerts when a Wandering Eye of Kilrogg begins to summon Netherwalkers",

	trigger_subZone = "Halls of Destruction",
	unit_EyeOfKilrogg = "Wandering Eye of Kilrogg",
	trigger_netherPortal = "senses your presence and opens a nether portal", --CHAT_MSG_MONSTER_EMOTE
	bar_netherPortal = "Kill the Eye! >target<",
} end )

local timer = {
	netherPortal = 4,
}
local icon = {
	eye = "Spell_Shadow_EvilEye",
	netherPortal = "Spell_Shadow_AntiShadow",
}
local syncName = {
	eyeEngage = "EyeEngage"..module.revision,
	eyeDead = "EyeDead"..module.revision,
}

function module:OnRegister()
	self:RegisterEvent("MINIMAP_ZONE_CHANGED")
	self:CheckSubzone() -- no change event if you reload UI inside the zone
end

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:ThrottleSync(3, syncName.eyeEngage)
	self:ThrottleSync(3, syncName.eyeDead)
end

function module:OnSetup()
end

function module:OnEngage()
end

function module:OnDisengage()
end

function module:MINIMAP_ZONE_CHANGED(msg)
	self:CheckSubzone()
end

function module:CheckSubzone()
	if GetMinimapZoneText() == L["trigger_subZone"] and not self.core:IsModuleActive(module.translatedName) then
		self.core:EnableModule(module.translatedName)
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["trigger_netherPortal"]) then
		self:Sync(syncName.eyeEngage)
	end
end

function module:OnEnemyDeath(msg)
	if msg == string.format(UNITDIESOTHER, L["unit_EyeOfKilrogg"]) then
		self:Sync(syncName.eyeDead)
	end
end

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.eyeEngage and self.db.profile.netherportal then
		self:NetherPortal()	
	elseif sync == syncName.eyeDead then
		self:EyeDead()
	end
end

function module:NetherPortal()
	self:Bar(L["bar_netherPortal"], timer.netherPortal, icon.netherPortal)
	self:SetCandyBarOnClick("BigWigsBar " .. L["bar_netherPortal"], function(name, button)
			TargetByName(L["unit_EyeOfKilrogg"], true)
		end)
	self:WarningSign(icon.eye, timer.netherPortal)
	self:Sound("Beware")
end

function module:EyeDead()
	self:RemoveBar(L["bar_netherPortal"])
	
	self:RemoveWarningSign(icon.eye)
end
