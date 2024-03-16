modifier_star_tier2 = class({})
function modifier_star_tier2:IsHidden() return true end
function modifier_star_tier2:IsDebuff() return false end
function modifier_star_tier2:IsPurgable() return false end
function modifier_star_tier2:IsPurgeException() return false end
function modifier_star_tier2:RemoveOnDeath() return true end
function modifier_star_tier2:OnCreated(table)
	if not IsServer() then return end

	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
    
    self.bSecondTheme = table.bSecondTheme
	
	
	if IsServer() then
		self:StopAllMusic()
		StopGlobalSound("spamton.theme")
		StopGlobalSound("spamton.neo_theme")
		StopGlobalSound("halo.theme_spirits_true")
	end
	if caster:GetUnitName()== "npc_dota_hero_oracle" then
		EmitGlobalSound("star.theme2_15")
	elseif caster:GetUnitName()== "npc_dota_hero_dragon_knight" then
		EmitGlobalSound("star.theme2_2")
	elseif caster:GetUnitName()== "npc_dota_hero_pudge" then
		EmitGlobalSound("star.theme2_33")
	elseif caster:GetUnitName()== "npc_dota_hero_slark" then
		if caster:HasModifier( "modifier_neko_arc" ) then
			EmitGlobalSound("star.theme2_46")
		else
			EmitGlobalSound("star.theme2_45")
		end
	elseif caster:GetUnitName()== "npc_dota_hero_faceless_void" then
		EmitGlobalSound("star.theme2_32")
	elseif caster:GetUnitName()== "npc_dota_hero_skeleton_king" then
		EmitGlobalSound("star.theme2_28")
	elseif caster:GetUnitName()== "npc_dota_hero_juggernaut" then
		EmitGlobalSound("star.theme2_38")
	elseif caster:GetUnitName()== "npc_dota_hero_abyssal_underlord" then
		EmitGlobalSound("star.theme2_27")
	elseif caster:GetUnitName()== "npc_dota_hero_bane" then
		if caster:HasScepter() then
			EmitGlobalSound("star.theme2_43")
		else
			EmitGlobalSound("star.theme2_42")
		end
	elseif caster:GetUnitName()== "npc_dota_hero_ember_spirit" then
		EmitGlobalSound("star.theme2_36")
	elseif caster:GetUnitName()== "npc_dota_hero_dark_willow" then
		EmitGlobalSound("star.theme2_34")
	elseif caster:GetUnitName()== "npc_dota_hero_life_stealer" then
		EmitGlobalSound("star.theme2_39")
	elseif caster:GetUnitName()== "npc_dota_hero_mars" then
		EmitGlobalSound("star.theme2_44")
	elseif caster:GetUnitName()== "npc_dota_hero_chaos_knight" then
		EmitGlobalSound("star.theme2_25")
	elseif caster:GetUnitName()== "npc_dota_hero_queenofpain" then
		EmitGlobalSound("star.theme2_21")
	elseif caster:GetUnitName()== "npc_dota_hero_monkey_king" then
		EmitGlobalSound("star.theme2_3")
	elseif caster:GetUnitName()== "npc_dota_hero_beastmaster" then
		EmitGlobalSound("star.theme2_35")
	elseif caster:GetUnitName()== "npc_dota_hero_spectre" then
		if self:GetParent():HasModifier( "modifier_devilovania" ) then
			EmitGlobalSound("star.theme2_24")
		else
			if self:GetParent():HasModifier( "modifier_little_devil" ) then
				EmitGlobalSound("star.theme2_23")
			else
				if self:GetParent():HasModifier( "modifier_hopes_and_dreams" ) then
					EmitGlobalSound("star.theme2_22")
				end
			end
		end
	elseif caster:GetUnitName()== "npc_dota_hero_nevermore" then
		if self:GetParent():HasModifier( "modifier_rumia_pre_awaken" ) then
			EmitGlobalSound("star.theme2_40")
		else
			EmitGlobalSound("star.theme2_41")
		end
	elseif caster:GetUnitName()== "npc_dota_hero_bloodseeker" then
		EmitGlobalSound("star.theme2_20")
	elseif caster:GetUnitName()== "npc_dota_hero_night_stalker" then
		EmitGlobalSound("star.theme2_19")
	elseif caster:GetUnitName()== "npc_dota_hero_kunkka" then
		EmitGlobalSound("star.theme2_6")
	elseif caster:GetUnitName()== "npc_dota_hero_lich" then
		if self:GetParent():HasItemInInventory("item_chomusuke") then
			EmitGlobalSound("star.theme2_26")
		else
			EmitGlobalSound("star.theme2_8")
		end
	elseif caster:GetUnitName()== "npc_dota_hero_tusk" then
		EmitGlobalSound("star.theme2_9")
	elseif caster:GetUnitName()== "npc_dota_hero_antimage" then
		EmitGlobalSound("star.theme2_10")
	elseif caster:GetUnitName()== "npc_dota_hero_terrorblade" then
	    if IsASBPatreon(self:GetCaster()) then
		    EmitGlobalSound("miku.kizuna_ai.7")
		else
            EmitGlobalSound("star.theme2_18")
        end
	elseif caster:GetUnitName()== "npc_dota_hero_ancient_apparition" then
		EmitGlobalSound("star.theme2_11")
	elseif caster:GetUnitName()== "npc_dota_hero_bristleback" then
		EmitGlobalSound("star.theme2_12")
	elseif caster:GetUnitName()== "npc_dota_hero_alchemist" then
		if IsASBPatreon(self:GetCaster()) then
			EmitGlobalSound("star.theme2_48")
		else
			EmitGlobalSound("star.theme2_13")
		end
	elseif caster:GetUnitName()== "npc_dota_hero_void_spirit" then
		EmitGlobalSound("star.theme2_14")
	elseif caster:GetUnitName()== "npc_dota_hero_legion_commander" then
		EmitGlobalSound("star.theme2_47")
	elseif caster:GetUnitName()== "npc_dota_hero_abaddon" then
		EmitGlobalSound("star.theme2_29")
	elseif caster:GetUnitName()== "npc_dota_hero_ursa" then
		EmitGlobalSound("star.theme2_31")
	elseif caster:GetUnitName()== "npc_dota_hero_death_prophet" then
		EmitGlobalSound("star.theme2_30")
	elseif caster:GetUnitName()== "npc_dota_hero_pangolier" then
		EmitGlobalSound("star.theme2_37")
	elseif caster:GetUnitName()== "npc_dota_hero_drow_ranger" then
		EmitGlobalSound("star.theme2_16")
	elseif caster:GetUnitName()== "npc_dota_hero_arc_warden" then
		EmitGlobalSound("star.theme2_49")
	elseif caster:GetUnitName()== "npc_dota_hero_sven" then
		EmitGlobalSound("star.theme2_50")
	elseif caster:GetUnitName()== "npc_dota_hero_earthshaker" then
		EmitGlobalSound("Gogeta.ulti_mp3")
	elseif caster:GetUnitName()== "npc_dota_hero_dazzle" then
		if self.bSecondTheme then
            EmitGlobalSound("Gojo.delirious")
        else
            EmitGlobalSound("Gojo.purple_theme")
        end
	else
	end

	if not IsServer() or not self.parent:IsRealHero() then
		return nil
	end
	
	self:StartIntervalThink(2)	
end
function modifier_star_tier2:OnIntervalThink()
	if IsServer() then
		self:StopAllMusic2()
	end
end



function modifier_star_tier2:OnDestroy()
	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	if caster:GetUnitName()== "npc_dota_hero_oracle" then
		StopGlobalSound("star.theme2_15")
	elseif caster:GetUnitName()== "npc_dota_hero_dragon_knight" then
		StopGlobalSound("star.theme2_2")
	elseif caster:GetUnitName()== "npc_dota_hero_legion_commander" then
		StopGlobalSound("star.theme2_47")
	elseif caster:GetUnitName()== "npc_dota_hero_chaos_knight" then
		StopGlobalSound("star.theme2_25")
	elseif caster:GetUnitName()== "npc_dota_hero_monkey_king" then
		StopGlobalSound("star.theme2_3")
	elseif caster:GetUnitName()== "npc_dota_hero_kunkka" then
		StopGlobalSound("star.theme2_6")
	elseif caster:GetUnitName()== "npc_dota_hero_lich" then
		StopGlobalSound("star.theme2_8")
		StopGlobalSound("star.theme2_26")
	elseif caster:GetUnitName()== "npc_dota_hero_slark" then
		StopGlobalSound("star.theme2_45")
		StopGlobalSound("star.theme2_46")
	elseif caster:GetUnitName()== "npc_dota_hero_tusk" then
		StopGlobalSound("star.theme2_9")
	elseif caster:GetUnitName()== "npc_dota_hero_juggernaut" then
		StopGlobalSound("star.theme2_38")
	elseif caster:GetUnitName()== "npc_dota_hero_spectre" then
		StopGlobalSound("star.theme2_22")
		StopGlobalSound("star.theme2_23")
		StopGlobalSound("star.theme2_24")
	elseif caster:GetUnitName()== "npc_dota_hero_life_stealer" then
		StopGlobalSound("star.theme2_39")
	elseif caster:GetUnitName()== "npc_dota_hero_dark_willow" then
		StopGlobalSound("star.theme2_34")
	elseif caster:GetUnitName()== "npc_dota_hero_ember_spirit" then
		StopGlobalSound("star.theme2_36")
	elseif caster:GetUnitName()== "npc_dota_hero_mars" then
		StopGlobalSound("star.theme2_44")
	elseif caster:GetUnitName()== "npc_dota_hero_bane" then
		StopGlobalSound("star.theme2_42")
		StopGlobalSound("star.theme2_43")
	elseif caster:GetUnitName()== "npc_dota_hero_nevermore" then
		StopGlobalSound("star.theme2_40")
		StopGlobalSound("star.theme2_41")
	elseif caster:GetUnitName()== "npc_dota_hero_pangolier" then
		StopGlobalSound("star.theme2_37")
	elseif caster:GetUnitName()== "npc_dota_hero_pudge" then
		StopGlobalSound("star.theme2_33")
	elseif caster:GetUnitName()== "npc_dota_hero_faceless_void" then
		StopGlobalSound("star.theme2_32")
	elseif caster:GetUnitName()== "npc_dota_hero_queenofpain" then
		StopGlobalSound("star.theme2_21")
	elseif caster:GetUnitName()== "npc_dota_hero_abyssal_underlord" then
		StopGlobalSound("star.theme2_27")
	elseif caster:GetUnitName()== "npc_dota_hero_bloodseeker" then
		StopGlobalSound("star.theme2_20")
	elseif caster:GetUnitName()== "npc_dota_hero_night_stalker" then
		StopGlobalSound("star.theme2_19")
	elseif caster:GetUnitName()== "npc_dota_hero_antimage" then
		StopGlobalSound("star.theme2_10")
	elseif caster:GetUnitName()== "npc_dota_hero_skeleton_king" then
		StopGlobalSound("star.theme2_28")
	elseif caster:GetUnitName()== "npc_dota_hero_ancient_apparition" then
		StopGlobalSound("star.theme2_11")
	elseif caster:GetUnitName()== "npc_dota_hero_beastmaster" then
		StopGlobalSound("star.theme2_35")
	elseif caster:GetUnitName()== "npc_dota_hero_terrorblade" then
		StopGlobalSound("star.theme2_18")
        StopGlobalSound("miku.kizuna_ai.7")
	elseif caster:GetUnitName()== "npc_dota_hero_bristleback" then
		StopGlobalSound("star.theme2_12")
	elseif caster:GetUnitName()== "npc_dota_hero_alchemist" then
		StopGlobalSound("star.theme2_13")
		StopGlobalSound("star.theme2_48")
	elseif caster:GetUnitName()== "npc_dota_hero_void_spirit" then
		StopGlobalSound("star.theme2_14")
	elseif caster:GetUnitName()== "npc_dota_hero_abaddon" then
		StopGlobalSound("star.theme2_29")
	elseif caster:GetUnitName()== "npc_dota_hero_death_prophet" then
		StopGlobalSound("star.theme2_30")
    elseif caster:GetUnitName()== "npc_dota_hero_ursa" then
		StopGlobalSound("star.theme2_31")
		StopGlobalSound("star.theme2_30")
	elseif caster:GetUnitName()== "npc_dota_hero_drow_ranger" then
		StopGlobalSound("star.theme2_16")
	elseif caster:GetUnitName()== "npc_dota_hero_arc_warden" then
		StopGlobalSound("star.theme2_49")
	elseif caster:GetUnitName()== "npc_dota_hero_sven" then
		StopGlobalSound("star.theme2_50")
	elseif caster:GetUnitName()== "npc_dota_hero_earthshaker" then
		StopGlobalSound("Gogeta.ulti_mp3")
	elseif caster:GetUnitName()== "npc_dota_hero_dazzle" then
		StopGlobalSound("Gojo.purple_theme")
        StopGlobalSound("Gojo.delirious")
	else
	end
end
function modifier_star_tier2:StopAllMusic()
	if IsServer() then
		StopGlobalSound("spamton.theme")
		StopGlobalSound("nanaya.heykids")

			for i = 1, 100 do
			StopGlobalSound("star.theme2_"..i)
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
		for i = 1, 10 do
	StopGlobalSound("gay_hammer.theme_"..i)
	end
	
	
end
end
function modifier_star_tier2:StopAllMusic2()
	if IsServer() then
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
	for i = 1, 10 do
	StopGlobalSound("gay_hammer.theme_"..i)
	end
		 for i = 1, 8  do
			StopGlobalSound("new.year_theme_"..i)
		end
self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		enemy:RemoveModifierByName("modifier_star_tier1")
		enemy:RemoveModifierByName("modifier_buff_chance")
		enemy:RemoveModifierByName("modifier_horn_tier1")
		enemy:RemoveModifierByName("modifier_debuff_chance")
	end
		

		
	end
end