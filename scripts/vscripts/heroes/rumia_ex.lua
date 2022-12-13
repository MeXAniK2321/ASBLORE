LinkLuaModifier("modifier_rumia_ex", "heroes/rumia_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rumia_ex2", "heroes/rumia_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rumia_ex3", "heroes/rumia_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_cloud","heroes/rumia_ex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
rumia_ex = class({})

function rumia_ex:IsStealable() return true end
function rumia_ex:IsHiddenWhenStolen() return false end

function rumia_ex:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("black_death")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function rumia_ex:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	if self:GetCaster():HasModifier("modifier_rumia_awake") then
    
    caster:AddNewModifier(caster, self, "modifier_rumia_ex3", {duration = 36})
	caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 36})
	
   elseif self:GetCaster():HasModifier("modifier_rumia_pre_awaken") then
   
     caster:AddNewModifier(caster, self, "modifier_rumia_ex2", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
	
	else
caster:AddNewModifier(caster, self, "modifier_rumia_ex", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
	end
    self:EndCooldown()

end
---------------------------------------------------------------------------------------------------------------------
modifier_rumia_ex = class({})
function modifier_rumia_ex:IsHidden() return false end
function modifier_rumia_ex:IsDebuff() return true end
function modifier_rumia_ex:IsPurgable() return false end
function modifier_rumia_ex:IsPurgeException() return false end
function modifier_rumia_ex:RemoveOnDeath() return true end
function modifier_rumia_ex:AllowIllusionDuplicate() return false end
function modifier_rumia_ex:CheckState()
    local state = { 
                }


	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_rumia_ex:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_PROJECTILE_NAME,
	                MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
                    MODIFIER_PROPERTY_HEALTH_BONUS,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end


function modifier_rumia_ex:GetModifierPreAttack_BonusDamage()
    return 250
end
function modifier_rumia_ex:GetModifierHealthBonus()
    return 750
end
function modifier_rumia_ex:GetModifierProjectileName()
    return "particles/rumia_attack.vpcf"
end


function modifier_rumia_ex:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.bonus_amplify 	= self.ability:GetSpecialValueFor("bonus_amplify")

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["rumia_ex"] = "slark_shadow_dance_lua",
                            
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
         if IsServer() then
        if IsServer() then
		self:PlayEffects()
	end
	
       

        
		
        EmitSoundOn("nevermore_nev_respawn_01", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_rumia_ex:PlayEffects()
	

	local particle_cast = "particles/rumia_ex_first.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius, 0, 0 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end

function modifier_rumia_ex:OnRefresh(table)
    self:OnCreated(table)
	
end
function modifier_rumia_ex:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			
			

            StopSoundOn("nevermore_nev_respawn_01", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("rumia_ex_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end

modifier_rumia_ex2 = class({})
function modifier_rumia_ex2:IsHidden() return false end
function modifier_rumia_ex2:IsDebuff() return true end
function modifier_rumia_ex2:IsPurgable() return false end
function modifier_rumia_ex2:IsPurgeException() return false end
function modifier_rumia_ex2:RemoveOnDeath() return true end
function modifier_rumia_ex2:AllowIllusionDuplicate() return false end
function modifier_rumia_ex2:CheckState()
    local state = { 
                }

	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_rumia_ex2:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_PROJECTILE_NAME,
	                MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
                    MODIFIER_PROPERTY_HEALTH_BONUS,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end


function modifier_rumia_ex2:GetModifierPreAttack_BonusDamage()
    return 300
end
function modifier_rumia_ex2:GetModifierHealthBonus()
    return 1000
end
function modifier_rumia_ex2:GetModifierProjectileName()
    return "particles/rumia_attack.vpcf"
end

function modifier_rumia_ex2:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.bonus_amplify 	= self.ability:GetSpecialValueFor("bonus_amplify")

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["rumia_ex"] = "black_death",
                            ["shadow_fiend_necromastery_lua"] = "slark_shadow_dance_lua",
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
         if IsServer() then
        if IsServer() then
		self:PlayEffects()
	end
	
       

        
		
        EmitSoundOn("rumia.5_2", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_rumia_ex2:PlayEffects()
	

	local particle_cast = "particles/rumia_ex_second.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius, 0, 0 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end

function modifier_rumia_ex2:OnRefresh(table)
    self:OnCreated(table)
	
end
function modifier_rumia_ex2:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			
			

            StopSoundOn("rumia.5_2", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("rumia_ex_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end

modifier_rumia_ex3 = class({})
function modifier_rumia_ex3:IsHidden() return false end
function modifier_rumia_ex3:IsDebuff() return true end
function modifier_rumia_ex3:IsPurgable() return false end
function modifier_rumia_ex3:IsPurgeException() return false end
function modifier_rumia_ex3:RemoveOnDeath() return true end
function modifier_rumia_ex3:AllowIllusionDuplicate() return false end

function modifier_rumia_ex3:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_PROJECTILE_NAME,
	                MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
                    MODIFIER_PROPERTY_HEALTH_BONUS,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,					}
    return func
end


function modifier_rumia_ex3:GetModifierPreAttack_BonusDamage()
    return 300
end
function modifier_rumia_ex3:GetModifierBonusStats_Strength()
    return 75
end

function modifier_rumia_ex3:GetModifierBonusStats_Agility()

    return 80
	
end

function modifier_rumia_ex3:GetModifierPhysicalArmorBonus()
    return 0
end

function modifier_rumia_ex3:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.bonus_amplify 	= self.ability:GetSpecialValueFor("bonus_amplify")

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["rumia_ex"] = "rumia_backwark_slash",
                            ["rumia_ex_slash"] = "slark_shadow_dance_lua",
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
         if IsServer() then
        if IsServer() then
		self:PlayEffects()
	end
	
       

        
		
  
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_rumia_ex3:PlayEffects()
	

	local particle_cast = "particles/rumia_ex_awaken.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius, 0, 0 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end

function modifier_rumia_ex3:OnRefresh(table)
    self:OnCreated(table)
	
end
function modifier_rumia_ex3:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			
			

			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("rumia_ex_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
