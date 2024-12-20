LinkLuaModifier("modifier_chibi_monster", "heroes/chibi_monster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
chibi_monster = class({})

function chibi_monster:IsStealable() return true end
function chibi_monster:IsHiddenWhenStolen() return false end
function chibi_monster:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("chibi_hit")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function chibi_monster:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	
    caster:AddNewModifier(caster, self, "modifier_chibi_monster", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
    self:EndCooldown()
end
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_monster = class({})
function modifier_chibi_monster:IsHidden() return false end
function modifier_chibi_monster:IsDebuff() return true end
function modifier_chibi_monster:IsPurgable() return false end
function modifier_chibi_monster:IsPurgeException() return false end
function modifier_chibi_monster:RemoveOnDeath() return true end
function modifier_chibi_monster:AllowIllusionDuplicate() return true end
function modifier_chibi_monster:CheckState()
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
function modifier_chibi_monster:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_CHANGE,
					MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,					
				}

    return func
end
function modifier_chibi_monster:GetModifierModelChange()
    return IsASBPatreon(self.parent)
	       and "models/kizuna_ai/kizuna_ai.vmdl"
		   or "models/hatsune_miku/chibi2.vmdl"
end
function modifier_chibi_monster:GetModifierModelScale()
	return IsASBPatreon(self.parent)
	       and -35
		   or 120
end
function modifier_chibi_monster:GetModifierHealthBonus()
    return 1500
end
function modifier_chibi_monster:GetModifierPreAttack_BonusDamage()
    return 300
end
function modifier_chibi_monster:GetModifierBonusStats_Agility()
    return 100
end
function modifier_chibi_monster:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["chibi_monster"] = "chibi_hit",
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
            if IsASBPatreon(self.parent) then
                self.particle_time = ParticleManager:CreateParticle("particles/chibi_monster_kizuna_ai.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			else
                self.particle_time = ParticleManager:CreateParticle("particles/chibi_monster.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            end
                                    
        end
		
        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_chibi_monster:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_chibi_monster:OnDestroy()
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
    local ability = self:GetCaster():FindAbilityByName("chibi_monster")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function zenitsu_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_chibi_monster", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_chibi_monster", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("chibi_monster")
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
        local ultimate = parent:FindModifierByNameAndCaster("modifier_chibi_monster", parent)
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