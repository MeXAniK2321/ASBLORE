modifier_star_tier1 = class({})
function modifier_star_tier1:IsHidden() return true end
function modifier_star_tier1:IsDebuff() return false end
function modifier_star_tier1:IsPurgable() return false end
function modifier_star_tier1:IsPurgeException() return false end
function modifier_star_tier1:RemoveOnDeath() return true end
function modifier_star_tier1:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	if IsServer() then
	
		self:StopAllMusic()
	end
	if caster:GetUnitName()== "npc_dota_hero_winter_wyvern" then
	EmitSoundOnClient("star.theme_2", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_nyx_assassin" then
	EmitSoundOnClient("star.theme_13", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_night_stalker" then
	EmitSoundOnClient("star.theme_15", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_pangolier" then
	EmitSoundOnClient("star.theme_17", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_bounty_hunter" then
	EmitSoundOnClient("star.theme_3", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_magnataur" then
	EmitSoundOnClient("star.theme_16", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_lycan" then
	EmitSoundOnClient("star.theme_14", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_bane" then
	EmitSoundOnClient("star.theme_3", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_juggernaut" then
	EmitSoundOnClient("star.theme_4", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_legion_commander" then
	EmitSoundOnClient("star.theme_5", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_techies" then
	EmitSoundOnClient("star.theme_6", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_ursa" then
	EmitSoundOnClient("star.theme_8", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_naga_siren" then
	EmitSoundOnClient("star.theme_10", Player)
	elseif caster:GetUnitName()== "npc_dota_hero_dark_seer" then
	EmitSoundOnClient("star.theme_11", Player)
	else 
	end

	
	
	

	if not IsServer() or not self.parent:IsRealHero() then
		return nil
	end
	

	
end

function modifier_star_tier1:OnDestroy()
if IsServer() then
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
		

		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
		end
end
function modifier_star_tier1:StopAllMusic()
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme", Player)
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
		  for i = 1, 6  do
			StopSoundOn("horn.hero_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.demon_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.samurai_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("spamton.theme_"..i, Player)
		end
			 for i = 1, 8  do
			StopSoundOn("new.year_theme_"..i, Player)
		end
end

end