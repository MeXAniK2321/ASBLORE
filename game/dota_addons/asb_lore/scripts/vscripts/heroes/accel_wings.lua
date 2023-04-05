LinkLuaModifier("modifier_accel_wings", "heroes/accel_wings", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
accel_wings = class({})

function accel_wings:IsStealable() return true end
function accel_wings:IsHiddenWhenStolen() return false end

function accel_wings:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("black_destroy")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function accel_wings:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function accel_wings:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_accel_wings", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
	

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_accel_wings = class({})
function modifier_accel_wings:IsHidden() return false end
function modifier_accel_wings:IsDebuff() return true end
function modifier_accel_wings:IsPurgable() return false end
function modifier_accel_wings:IsPurgeException() return false end
function modifier_accel_wings:RemoveOnDeath() return true end
function modifier_accel_wings:AllowIllusionDuplicate() return true end
function modifier_accel_wings:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("accel_wings_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_accel_wings:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end


function modifier_accel_wings:GetModifierMoveSpeedBonus_Constant()
    return 600
end
function modifier_accel_wings:GetModifierSpellAmplify_PercentageUnique()
    return self.bonus_amplify 
end
function modifier_accel_wings:GetModifierMagicalResistanceBonus()
    return 0
end
function modifier_accel_wings:GetModifierPhysicalArmorBonus()
    return 0
end

function modifier_accel_wings:OnCreated(table)
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
                            ["accel_wings"] = "black_destroy",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/econ/items/skywrath_mage/hero_skywrath_dpits3_wings/skywrath_dpits3_backwing_p.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_accel_wings", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
        end

        
		
        EmitSoundOn("Black.wings", self.parent)
       

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_accel_wings:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_accel_wings:OnDestroy()
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

            StopSoundOn("Black.wings", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("accel_wings_awake")
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
accel_wings_awake = class({})

function accel_wings_awake:IsStealable() return true end
function accel_wings_awake:IsHiddenWhenStolen() return false end
function accel_wings_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("accel_wings")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function accel_wings_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_accel_wings", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_accel_wings", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("accel_wings")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.accel_wings_awake_skills_used, "sss")
        if not self.accel_wings_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.accel_wings_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_accel_wings", parent)
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

    local accel_wings_awake = parent:FindAbilityByName("accel_wings_awake")
    if not accel_wings_awake:IsNull() and accel_wings_awake:IsTrained() then
        accel_wings_awake.accel_wings_awake_skills_used = true
    end
end


