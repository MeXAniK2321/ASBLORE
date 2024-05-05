LinkLuaModifier("modifier_blackrock_form", "heroes/blackrock_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
blackrock_form = class({})

function blackrock_form:IsStealable() return true end
function blackrock_form:IsHiddenWhenStolen() return false end

function blackrock_form:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("brs_machinegun")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end


function blackrock_form:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	


    caster:AddNewModifier(caster, self, "modifier_blackrock_form", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = fixed_duration})

    self:EndCooldown()

    
end
---------------------------------------------------------------------------------------------------------------------
modifier_blackrock_form = class({})
function modifier_blackrock_form:IsHidden() return false end
function modifier_blackrock_form:IsDebuff() return true end
function modifier_blackrock_form:IsPurgable() return false end
function modifier_blackrock_form:IsPurgeException() return false end
function modifier_blackrock_form:RemoveOnDeath() return true end
function modifier_blackrock_form:AllowIllusionDuplicate() return true end
function modifier_blackrock_form:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("zenitsu_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_blackrock_form:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
							MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
MODIFIER_PROPERTY_STATS_AGILITY_BONUS,					}
    return func
end
function modifier_blackrock_form:GetModifierModelChange()

	return "models/brs_rework/brs_range.vmdl"
	
	end

function modifier_blackrock_form:GetModifierModelScale()
	return 1
end
function modifier_blackrock_form:GetModifierPreAttack_BonusDamage()
    return 130
end
function modifier_blackrock_form:GetAttackSound()
	return "Brs.range_attack"
end

function modifier_blackrock_form:GetModifierProjectileName()
	return "particles/blackrock_projectile.vpcf"
end

function modifier_blackrock_form:GetModifierProjectileSpeedBonus()
	return 800
end
function modifier_blackrock_form:GetModifierAttackRangeBonus()
	return self:GetParent():HasShard() and 1000 or 530
end


function modifier_blackrock_form:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()
	self.parent:SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["blackrock_form"] = "brs_machinegun",
                            
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
       if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/terrorblade_metamorphosis1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
	

        
		
        
        self:PlayEffects()

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_blackrock_form:PlayEffects()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/sans_eye_flame.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "brs_eye", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end
function modifier_blackrock_form:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_blackrock_form:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			self.parent:SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )

           ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		self.parent:RemoveModifierByName("modifier_brs_machinegun")
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("zenitsu_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
zenitsu_awake = class({})

function zenitsu_awake:IsStealable() return true end
function zenitsu_awake:IsHiddenWhenStolen() return false end
function zenitsu_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("blackrock_form")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function zenitsu_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_blackrock_form", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_blackrock_form", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("blackrock_form")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.zenitsu_awake_skills_used, "sss")
        if not self.zenitsu_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.zenitsu_awake_skills_used = nil

   
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_blackrock_form", parent)
        if ultimate and not ultimate:IsNull() then
            return ultimate:GetAbility()
        end
    end

    return nil
end

function SetZenitsuAwakeLongCd(parent, ability)
    if not IsServer() or parent:IsNull() or ability:IsNull() then
        return nil
    end

    local zenitsu_awake = parent:FindAbilityByName("zenitsu_awake")
    if not zenitsu_awake:IsNull() and zenitsu_awake:IsTrained() then
        zenitsu_awake.zenitsu_awake_skills_used = true
    end
end