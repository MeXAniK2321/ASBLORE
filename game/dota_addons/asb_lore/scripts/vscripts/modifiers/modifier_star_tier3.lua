modifier_star_tier3 = class({})
function modifier_star_tier3:IsHidden() return true end
function modifier_star_tier3:IsDebuff() return false end
function modifier_star_tier3:IsPurgable() return false end
function modifier_star_tier3:IsPurgeException() return false end
function modifier_star_tier3:RemoveOnDeath() return true end
function modifier_star_tier3:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()

	if IsServer() then
		self:StopAllMusic()
		StopGlobalSound("spamton.neo_theme")
		StopGlobalSound("halo.lust_1")
			for i = 1, 40 do
			StopGlobalSound("star.theme3_"..i)
			end
			StopGlobalSound("halo.theme4")
			for i = 1, 3 do
			StopGlobalSound("halo.theme3_"..i)
		end
	end
	if caster:GetUnitName()== "npc_dota_hero_chaos_knight" then
	EmitGlobalSound("star.theme3_1")
	elseif caster:GetUnitName()== "npc_dota_hero_abyssal_underlord" then
	EmitGlobalSound("star.theme3_2")
	elseif caster:GetUnitName()== "npc_dota_hero_slark" then
	EmitGlobalSound("star.theme3_14")
	elseif caster:GetUnitName()== "npc_dota_hero_spectre" then
	EmitGlobalSound("star.theme3_10")
	elseif caster:GetUnitName()== "npc_dota_hero_monkey_king" then
	EmitGlobalSound("star.theme3_3")
	elseif caster:GetUnitName()== "npc_dota_hero_lich" then
	EmitGlobalSound("star.theme3_15")
		elseif caster:GetUnitName()== "npc_dota_hero_nevermore" then
	EmitGlobalSound("star.theme3_8")
	elseif caster:GetUnitName()== "npc_dota_hero_phantom_lancer" then
	if self:GetCaster():HasScepter() then
	EmitGlobalSound("star.theme3_13")
	else
	EmitGlobalSound("star.theme3_12")
	end
	elseif caster:GetUnitName()== "npc_dota_hero_oracle" then
	EmitGlobalSound("star.theme3_16")
	elseif caster:GetUnitName()== "npc_dota_hero_ancient_apparition" then
	EmitGlobalSound("star.theme3_7")
	elseif caster:GetUnitName()== "npc_dota_hero_dragon_knight" then
	EmitGlobalSound("star.theme3_11")
	elseif caster:GetUnitName()== "npc_dota_hero_marci" then
	if caster:HasModifier("modifier_blood_sacrifice_self") then
	EmitGlobalSound("star.theme3_20")
	elseif caster:HasModifier("modifier_shield_prison_change") then
	EmitGlobalSound("star.theme3_18")
	else
	EmitGlobalSound("star.theme3_19")
	end
	elseif caster:GetUnitName()== "npc_dota_hero_ember_spirit" then
	if self:GetParent():HasModifier( "modifier_alastor_awake" ) then
	EmitGlobalSound("star.theme3_9")
	
	else
	EmitGlobalSound("star.theme3_6")
	end
	elseif caster:GetUnitName()== "npc_dota_hero_pudge" then
	if self:GetParent():HasModifier( "modifier_exe_awakening" ) then
	EmitGlobalSound("star.theme3_4")
	else
	EmitGlobalSound("star.theme3_5")
	end
	else
	end

	
	
	

	if not IsServer() or not self.parent:IsRealHero() then
		return nil
	end
	
self:StartIntervalThink(2)
	
end
function modifier_star_tier3:OnIntervalThink()
	if IsServer() then
		self:StopAllMusic2()
		self:StopAllMusic()
	end
end



function modifier_star_tier3:OnDestroy()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
if caster:GetUnitName()== "npc_dota_hero_chaos_knight" then
	StopGlobalSound("star.theme3_1")
		elseif caster:GetUnitName()== "npc_dota_hero_abyssal_underlord" then
	StopGlobalSound("star.theme3_2")
	elseif caster:GetUnitName()== "npc_dota_hero_monkey_king" then
	StopGlobalSound("star.theme3_3")
		elseif caster:GetUnitName()== "npc_dota_hero_slark" then
	StopGlobalSound("star.theme3_14")
	elseif caster:GetUnitName()== "npc_dota_hero_lich" then
	StopGlobalSound("star.theme3_15")
	elseif caster:GetUnitName()== "npc_dota_hero_dragon_knight" then
	StopGlobalSound("star.theme3_11")
	elseif caster:GetUnitName()== "npc_dota_hero_ancient_apparition" then
	StopGlobalSound("star.theme3_7")
	elseif caster:GetUnitName()== "npc_dota_hero_marci" then
	StopGlobalSound("star.theme3_18")
	StopGlobalSound("star.theme3_19")
	StopGlobalSound("star.theme3_20")
	elseif caster:GetUnitName()== "npc_dota_hero_nevermore" then
	StopGlobalSound("star.theme3_8")
	elseif caster:GetUnitName()== "npc_dota_hero_oracle" then
	StopGlobalSound("star.theme3_16")
		elseif caster:GetUnitName()== "npc_dota_hero_spectre" then
	StopGlobalSound("star.theme3_10")
	elseif caster:GetUnitName()== "npc_dota_hero_phantom_lancer" then
	StopGlobalSound("star.theme3_12")
	StopGlobalSound("star.theme3_13")
	elseif caster:GetUnitName()== "npc_dota_hero_ember_spirit" then
	StopGlobalSound("star.theme3_6")
	StopGlobalSound("star.theme3_9")
	elseif caster:GetUnitName()== "npc_dota_hero_pudge" then
	StopGlobalSound("star.theme3_4")
	StopGlobalSound("star.theme3_5")
	
	end
end
function modifier_star_tier3:StopAllMusic()
	if IsServer() then
		
StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
		for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
	
		  for i = 1, 6  do
			StopGlobalSound("horn.hero_"..i)
		end
		 for i = 1, 6  do
			StopGlobalSound("horn.demon_"..i)
		end
		 for i = 1, 6  do
			StopGlobalSound("horn.samurai_"..i)
		end
		 for i = 1, 6  do
			StopGlobalSound("spamton.theme_"..i)
		end
		for i = 1, 10  do
			StopGlobalSound("gay_hammer.theme_"..i)
		end
			for i = 1, 30 do
			StopGlobalSound("star.theme_"..i)
		end
			 for i = 1, 8  do
			StopGlobalSound("new.year_theme_"..i)
		end
end
end
function modifier_star_tier3:StopAllMusic2()
	if IsServer() then
		
StopGlobalSound("halo.theme_spirits_true")

		  for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		for i = 1, 2  do
			StopGlobalSound("star.event_"..i)
		end
		for i = 1, 6  do
			StopGlobalSound("star.horn_"..i)
		end
		for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)

		

		
	end
end
end