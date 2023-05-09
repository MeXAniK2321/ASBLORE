LinkLuaModifier("modifier_zenitsu_sleep", "heroes/susano2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
zenitsu_sleep = class({})

function zenitsu_sleep:IsStealable() return true end
function zenitsu_sleep:IsHiddenWhenStolen() return false end

function zenitsu_sleep:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("susano_slash")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--[[function zenitsu_sleep:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function zenitsu_sleep:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	


    caster:AddNewModifier(caster, self, "modifier_zenitsu_sleep", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()

    
end
---------------------------------------------------------------------------------------------------------------------
modifier_zenitsu_sleep = class({})
function modifier_zenitsu_sleep:IsHidden() return false end
function modifier_zenitsu_sleep:IsDebuff() return true end
function modifier_zenitsu_sleep:IsPurgable() return false end
function modifier_zenitsu_sleep:IsPurgeException() return false end
function modifier_zenitsu_sleep:RemoveOnDeath() return true end
function modifier_zenitsu_sleep:AllowIllusionDuplicate() return true end
function modifier_zenitsu_sleep:CheckState()
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
function modifier_zenitsu_sleep:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end
function modifier_zenitsu_sleep:GetModifierModelChange()
    return "models/susano/susano1.vmdl"
end
function modifier_zenitsu_sleep:GetModifierModelScale()
	return 120
end
function modifier_zenitsu_sleep:GetModifierHealthBonus()
    return self.hp
end
function modifier_zenitsu_sleep:GetModifierAttackRangeBonus()
    return 300
end
function modifier_zenitsu_sleep:GetModifierSpellAmplify_Percentage()

    return 25
end
function modifier_zenitsu_sleep:GetModifierMagicalResistanceBonus()
    return 40
end
function modifier_zenitsu_sleep:GetModifierPhysicalArmorBonus()
    return 40
end

function modifier_zenitsu_sleep:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.mana = self.caster:GetMana() * 0.5
    self.hp = self.mana * 0.5
	
    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["zenitsu_sleep"] = "susano_slash",
                            
                        }


    if IsServer() then
        self.caster:Script_ReduceMana( self.mana, self.ability)

        for k, v in pairs(self.skills_table) do
            if k and v then
                print(k, v)
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
        local sleep_fx = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_1.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)

        self:AddParticle(sleep_fx, false, false, -1, false, true)
		
        
        EmitSoundOn("Perfect.Susano", self.parent)

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_zenitsu_sleep:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_zenitsu_sleep:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

            StopSoundOn("Perfect.Susano", self.parent)
			

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
    local ability = self:GetCaster():FindAbilityByName("zenitsu_sleep")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function zenitsu_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_zenitsu_sleep", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_zenitsu_sleep", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("zenitsu_sleep")
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

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_zenitsu_sleep", parent)
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