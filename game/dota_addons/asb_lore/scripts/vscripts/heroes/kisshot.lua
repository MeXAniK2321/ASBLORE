LinkLuaModifier("modifier_kisshot", "heroes/shinobu_kisshot", LUA_MODIFIER_MOTION_NONE)

kisshot = class({})

function kisshot:IsStealable() return true end
function kisshot:IsHiddenWhenStolen() return false end

function kisshot:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("kisshot_awake")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function kisshot:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function kisshot:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_kisshot", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_kisshot = class({})
function modifier_kisshot:IsHidden() return false end
function modifier_kisshot:IsDebuff() return true end
function modifier_kisshot:IsPurgable() return false end
function modifier_kisshot:IsPurgeException() return false end
function modifier_kisshot:RemoveOnDeath() return true end
function modifier_kisshot:AllowIllusionDuplicate() return true end
function modifier_kisshot:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("kisshot_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_kisshot:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,					}
    return func
end
function modifier_kisshot:GetModifierModelChange()
    return "models/shinobu_vampire/shinobu_success1.vmdl"
end
function modifier_kisshot:GetModifierModelScale()
	return 10
end
function modifier_kisshot:GetModifierHealthBonus()
    return 5000
end
function modifier_kisshot:GetModifierPreAttack_BonusDamage()
    return 500
end
function modifier_kisshot:GetModifierMagicalResistanceBonus()
    return 50
end
function modifier_kisshot:GetModifierPhysicalArmorBonus()
    return 100
end

function modifier_kisshot:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["tusk_walrus_punch"] = "kisshot_awake",
                            ["kisshot"] = "Kisshot_hit",
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
        local sleep_fx = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_1.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)

        self:AddParticle(sleep_fx, false, false, -1, false, true)
		
        EmitSoundOn("Susano.Theme", self.parent)
        EmitSoundOn("Perfect.Susano", self.parent)

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_kisshot:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_kisshot:OnDestroy()
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
			StopSoundOn("Susano.Theme", self.parent)

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("kisshot_awake")
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
kisshot_awake = class({})

function kisshot_awake:IsStealable() return true end
function kisshot_awake:IsHiddenWhenStolen() return false end
function kisshot_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("kisshot")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function kisshot_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_kisshot", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_kisshot", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("kisshot")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.kisshot_awake_skills_used, "sss")
        if not self.kisshot_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.kisshot_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_kisshot", parent)
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

    local kisshot_awake = parent:FindAbilityByName("kisshot_awake")
    if not kisshot_awake:IsNull() and kisshot_awake:IsTrained() then
        kisshot_awake.kisshot_awake_skills_used = true
    end
end