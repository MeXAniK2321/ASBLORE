LinkLuaModifier("modifier_rimuru_demon_lord", "heroes/rimuru_demon_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
rimuru_demon_lord = class({})

function rimuru_demon_lord:IsStealable() return true end
function rimuru_demon_lord:IsHiddenWhenStolen() return false end

function rimuru_demon_lord:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_megiddo")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function rimuru_demon_lord:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function rimuru_demon_lord:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_rimuru_demon_lord", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_rimuru_demon_lord = class({})
function modifier_rimuru_demon_lord:IsHidden() return false end
function modifier_rimuru_demon_lord:IsDebuff() return true end
function modifier_rimuru_demon_lord:IsPurgable() return false end
function modifier_rimuru_demon_lord:IsPurgeException() return false end
function modifier_rimuru_demon_lord:RemoveOnDeath() return true end
function modifier_rimuru_demon_lord:AllowIllusionDuplicate() return true end
function modifier_rimuru_demon_lord:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("rimuru_demon_lord_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_rimuru_demon_lord:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end

function modifier_rimuru_demon_lord:GetModifierSpellAmplify_PercentageUnique()
    return self.bonus_amplify 
end
function modifier_rimuru_demon_lord:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_rimuru_demon_lord:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_rimuru_demon_lord:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end



function modifier_rimuru_demon_lord:OnCreated(table)
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
                            ["rimuru_demon_lord"] = "rimuru_megiddo",
							["rimuru_slime"] = "rimuru_black_flame",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/rimuru_mao.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		EmitSoundOn("rimuru.6", self.parent)

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_rimuru_demon_lord:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_rimuru_demon_lord:OnDestroy()
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

            StopSoundOn("rimuru.6", self.parent)

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("rimuru_demon_lord_awake")
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
rimuru_demon_lord_awake = class({})

function rimuru_demon_lord_awake:IsStealable() return true end
function rimuru_demon_lord_awake:IsHiddenWhenStolen() return false end
function rimuru_demon_lord_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_demon_lord")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function rimuru_demon_lord_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_rimuru_demon_lord", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_rimuru_demon_lord", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("rimuru_demon_lord")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.rimuru_demon_lord_awake_skills_used, "sss")
        if not self.rimuru_demon_lord_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.rimuru_demon_lord_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_rimuru_demon_lord", parent)
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

    local rimuru_demon_lord_awake = parent:FindAbilityByName("rimuru_demon_lord_awake")
    if not rimuru_demon_lord_awake:IsNull() and rimuru_demon_lord_awake:IsTrained() then
        rimuru_demon_lord_awake.rimuru_demon_lord_awake_skills_used = true
    end
end


