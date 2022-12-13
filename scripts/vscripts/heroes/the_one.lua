LinkLuaModifier("modifier_the_one", "heroes/the_one", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_the_one_ultimate", "heroes/the_one", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_the_one_ultimate_d", "heroes/the_one", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_the_one_ultimate_damage", "heroes/the_one", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_the_one_invul", "heroes/the_one", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_escanor_weak_stop", "heroes/mael_sun", LUA_MODIFIER_MOTION_NONE)

the_one = class({})

function the_one:IsStealable() return true end
function the_one:IsHiddenWhenStolen() return false end
function the_one:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
		return "escanor_7"
	end
	return "escanor_5"
end
function the_one:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("divine_sword_escanor")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	local ability2 = self:GetCaster():FindAbilityByName("divine_spear_escanor")
    if ability2 and ability2:GetLevel() < self:GetLevel() then
        ability2:SetLevel(self:GetLevel())
    end
end
function the_one:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	caster:AddNewModifier(caster, self, "modifier_escanor_weak_stop", {duration = 40})

    if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
	  caster:AddNewModifier(caster, self, "modifier_the_one_ultimate", {duration = 40})
	  caster:AddNewModifier(caster, self, "modifier_the_one_ultimate_d", {duration = 43})
caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 40})
	else
    caster:AddNewModifier(caster, self, "modifier_the_one", {duration = fixed_duration})
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
end
    self:EndCooldown()


    
end
function the_one:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		return nil
	end

	

	local damage_table = {	victim = hTarget,
							attacker = self:GetCaster(),
							damage = self.damage,
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
end

---------------------------------------------------------------------------------------------------------------------
modifier_the_one = class({})
function modifier_the_one:IsHidden() return false end
function modifier_the_one:IsDebuff() return true end
function modifier_the_one:IsPurgable() return false end
function modifier_the_one:IsPurgeException() return false end
function modifier_the_one:RemoveOnDeath() return true end
function modifier_the_one:AllowIllusionDuplicate() return true end

function modifier_the_one:DeclareFunctions()
    local func = {  
	                MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
                    MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
                    MODIFIER_PROPERTY_MODEL_SCALE,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,					}
    return func
end
function modifier_the_one:GetModifierModelScale()
	return 30
end

function modifier_the_one:GetModifierSpellAmplify_PercentageUnique()
    return 50
end

function modifier_the_one:GetModifierHealthBonus()
    return 2500
end

function modifier_the_one:GetModifierPhysicalArmorBonus()
    return 20
end


function modifier_the_one:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["the_one"] = "divine_sword_escanor",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/the_one.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
        EmitSoundOn("escanor.5", self.parent)
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_the_one:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_the_one:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

            StopSoundOn("escanor.5", self.parent)

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
               
                   
                end
            end
        end
    end
modifier_the_one_ultimate = class({})
function modifier_the_one_ultimate:IsHidden() return false end
function modifier_the_one_ultimate:IsDebuff() return true end
function modifier_the_one_ultimate:IsPurgable() return false end
function modifier_the_one_ultimate:IsPurgeException() return false end
function modifier_the_one_ultimate:RemoveOnDeath() return true end
function modifier_the_one_ultimate:AllowIllusionDuplicate() return true end

function modifier_the_one_ultimate:DeclareFunctions()
    local func = {  
	                MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
                   MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
                    MODIFIER_PROPERTY_MODEL_SCALE,
 MODIFIER_PROPERTY_HEALTH_BONUS,					}
    return func
end
function modifier_the_one_ultimate:GetModifierModelScale()
	return 40
end

function modifier_the_one_ultimate:GetModifierSpellAmplify_PercentageUnique()
    return 50
end
function modifier_the_one_ultimate:GetModifierHealthBonus()
    return 5000
end

function modifier_the_one_ultimate:GetModifierPhysicalArmorBonus()
    return 40
end




function modifier_the_one_ultimate:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["the_one"] = "divine_sword_escanor",
							["mael_sun"] = "divine_spear_escanor",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/the_one_ultimate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
        EmitSoundOn("escanor.7", self.parent)
		
		end
		local interval = 1
        self:StartIntervalThink( interval )

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_the_one_ultimate:OnIntervalThink()
self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}

	self.damageTable.damage = 7/100*self:GetParent():GetMaxHealth()

local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		
		
	end
	
end

function modifier_the_one_ultimate:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_the_one_ultimate:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

            StopSoundOn("escanor.7", self.parent)

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
               local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = 9999999,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	-- update damage
	

	-- apply damage
	ApplyDamage( damageTable )
                   self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_the_one_ultimate_damage", {duration = 5})
                end
            end
        end
    end
	modifier_the_one_ultimate_d = class({})
function modifier_the_one_ultimate_d:IsHidden() return false end
function modifier_the_one_ultimate_d:IsDebuff() return true end
function modifier_the_one_ultimate_d:IsPurgable() return false end
function modifier_the_one_ultimate_d:IsPurgeException() return false end
function modifier_the_one_ultimate_d:RemoveOnDeath() return true end
modifier_the_one_ultimate_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_the_one_ultimate_damage:IsHidden()
	return false
end

function modifier_the_one_ultimate_damage:IsDebuff()
	return false
end
function modifier_the_one_ultimate_damage:RemoveOnDeath() return true end
function modifier_the_one_ultimate_damage:IsStunDebuff()
	return false
end

function modifier_the_one_ultimate_damage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_the_one_ultimate_damage:OnCreated( kv )
	-- references
	local damage = 99999
	

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.2 )
end

function modifier_the_one_ultimate_damage:OnRefresh( kv )
	-- references
	local damage = 999999
	

	if not IsServer() then return end

	-- update damage
	self.damageTable.damage = damage	
end

function modifier_the_one_ultimate_damage:OnRemoved()
end

function modifier_the_one_ultimate_damage:OnDestroy()
end

-- Interval Effects
function modifier_the_one_ultimate_damage:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_the_one_ultimate_damage:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_the_one_ultimate_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end