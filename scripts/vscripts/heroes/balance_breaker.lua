LinkLuaModifier("modifier_balance_breaker", "heroes/balance_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_balance_breaker2", "heroes/balance_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_drive", "heroes/balance_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
balance_breaker = class({})

function balance_breaker:IsStealable() return true end
function balance_breaker:IsHiddenWhenStolen() return false end

function balance_breaker:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("issei_laser")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function balance_breaker:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function balance_breaker:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local modifier = caster:FindModifierByNameAndCaster("modifier_issei_boost",caster)
	if modifier == nil then return end
	local current = modifier:GetStackCount()
	
if current == 30 then
modifier:SetStackCount(20)
    caster:AddNewModifier(caster, self, "modifier_juggernaut_drive", {duration = fixed_duration})
    caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = fixed_duration})
		local radius = 550
	local duration = 2.4
	local damage = 3000
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.5})
	
	end
	self:PlayEffects(radius)
elseif current > 14 then
  caster:AddNewModifier(caster, self, "modifier_balance_breaker2", {duration = fixed_duration})
    caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
else
    caster:AddNewModifier(caster, self, "modifier_balance_breaker", {duration = fixed_duration})
    caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
	end
    self:EndCooldown()
end

function balance_breaker:PlayEffects( radius )

	local particle_cast = "particles/balance_breaker_explosion1.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_balance_breaker = class({})
function modifier_balance_breaker:IsHidden() return false end
function modifier_balance_breaker:IsDebuff() return true end
function modifier_balance_breaker:IsPurgable() return false end
function modifier_balance_breaker:IsPurgeException() return false end
function modifier_balance_breaker:RemoveOnDeath() return true end
function modifier_balance_breaker:AllowIllusionDuplicate() return true end

function modifier_balance_breaker:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end
function modifier_balance_breaker:GetModifierModelChange()
    return "models/hyodo_issei/isse_dragon.vmdl"
end
function modifier_balance_breaker:GetModifierModelScale()
	return 60
end
function modifier_balance_breaker:GetModifierHealthBonus()
    return 1000
end
function modifier_balance_breaker:GetModifierBaseAttack_BonusDamage()
    return 150
end
function modifier_balance_breaker:GetModifierMagicalResistanceBonus()
    return 10
end
function modifier_balance_breaker:GetModifierPhysicalArmorBonus()
    return 10
end

function modifier_balance_breaker:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {                          
                            ["balance_breaker"] = "issei_laser",
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
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/balance_breaker.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("issei.5", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_balance_breaker:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_balance_breaker:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

            StopSoundOn("issei.5", self.parent)
			 ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("balance_breaker_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
modifier_balance_breaker2 = class({})
function modifier_balance_breaker2:IsHidden() return false end
function modifier_balance_breaker2:IsDebuff() return true end
function modifier_balance_breaker2:IsPurgable() return false end
function modifier_balance_breaker2:IsPurgeException() return false end
function modifier_balance_breaker2:RemoveOnDeath() return true end
function modifier_balance_breaker2:AllowIllusionDuplicate() return true end

function modifier_balance_breaker2:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end
function modifier_balance_breaker2:GetModifierModelChange()
    return "models/hyodo_issei/isse_dragon.vmdl"
end
function modifier_balance_breaker2:GetModifierModelScale()
	return 60
end
function modifier_balance_breaker2:GetModifierHealthBonus()
    return 2000
end
function modifier_balance_breaker2:GetModifierBaseAttack_BonusDamage()
    return 250
end
function modifier_balance_breaker2:GetModifierMagicalResistanceBonus()
    return 15
end
function modifier_balance_breaker2:GetModifierPhysicalArmorBonus()
    return 20
end

function modifier_balance_breaker2:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {                          
                            ["balance_breaker"] = "issei_laser",
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
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/balance_breaker2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("issei.5", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_balance_breaker2:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_balance_breaker2:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

            StopSoundOn("issei.5", self.parent)
			 ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("balance_breaker_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
modifier_juggernaut_drive = class({})
function modifier_juggernaut_drive:IsHidden() return false end
function modifier_juggernaut_drive:IsDebuff() return true end
function modifier_juggernaut_drive:IsPurgable() return false end
function modifier_juggernaut_drive:IsPurgeException() return false end
function modifier_juggernaut_drive:RemoveOnDeath() return true end
function modifier_juggernaut_drive:AllowIllusionDuplicate() return true end
function modifier_juggernaut_drive:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("juggernaut_drive_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_juggernaut_drive:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end
function modifier_juggernaut_drive:GetModifierModelChange()
    return "models/hyodo_issei/isse_dragon.vmdl"
end
function modifier_juggernaut_drive:GetModifierModelScale()
	return 80
end
function modifier_juggernaut_drive:GetModifierHealthBonus()
    return 3000
end
function modifier_juggernaut_drive:GetModifierBaseAttack_BonusDamage()
    return 400
end
function modifier_juggernaut_drive:GetModifierMagicalResistanceBonus()
    return 20
end
function modifier_juggernaut_drive:GetModifierPhysicalArmorBonus()
    return 30
end

function modifier_juggernaut_drive:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {                          
                            ["balance_breaker"] = "issei_laser",
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
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/juggernaut_drive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("issei.5_juggernaut", self.parent)
        
self:PlayEffects()
        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_juggernaut_drive:PlayEffects( )
	-- Get Resources
	 if not self.particle_time2 then
            self.particle_time2 =    ParticleManager:CreateParticle("particles/juggernaut_drive_wings.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_wings", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time2, 1, Vector(self.radius, self.radius, self.radius))
        end
	
	
end
function modifier_juggernaut_drive:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_juggernaut_drive:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

           		ParticleManager:DestroyParticle(self.particle_time2, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time2)
			 ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("juggernaut_drive_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end