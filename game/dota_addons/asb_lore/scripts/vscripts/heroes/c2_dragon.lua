LinkLuaModifier("modifier_c2_dragon", "heroes/c2_dragon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)

c2_dragon = class({})

function c2_dragon:IsStealable() return true end
function c2_dragon:IsHiddenWhenStolen() return false end

function c2_dragon:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("c3_karakura")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function c2_dragon:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function c2_dragon:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_c2_dragon", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_c2_dragon = class({})
function modifier_c2_dragon:IsHidden() return false end
function modifier_c2_dragon:IsDebuff() return true end
function modifier_c2_dragon:IsPurgable() return false end
function modifier_c2_dragon:IsPurgeException() return false end
function modifier_c2_dragon:RemoveOnDeath() return true end
function modifier_c2_dragon:AllowIllusionDuplicate() return true end
function modifier_c2_dragon:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("c2_dragon_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end
local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    return state
end
function modifier_c2_dragon:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end
function modifier_c2_dragon:GetModifierModelChange()
    return "models/deidara/deidara_dragon.vmdl"
end
function modifier_c2_dragon:GetModifierModelScale()
	return -65
end
function modifier_c2_dragon:GetModifierHealthBonus()
    return 1000
end
function modifier_c2_dragon:GetModifierSpellAmplify_PercentageUnique()
    return 0
end


function modifier_c2_dragon:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
    self.skills_table = {
                            
                            ["c2_dragon"] = "c3_karakura",
							
                        }
						else
						self.skills_table = {
                            
                            ["c2_dragon"] = "c3_karakura",
							
                        }
						end


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
		
        EmitSoundOn("deidara.c2", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_c2_dragon:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_c2_dragon:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

            
			StopSoundOn("", self.parent)

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("c2_dragon_awake")
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
c2_dragon_awake = class({})

function c2_dragon_awake:IsStealable() return true end
function c2_dragon_awake:IsHiddenWhenStolen() return false end
function c2_dragon_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("c2_dragon")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function c2_dragon_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_c2_dragon", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_c2_dragon", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("c2_dragon")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.c2_dragon_awake_skills_used, "sss")
        if not self.c2_dragon_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.c2_dragon_awake_skills_used = nil

    StopSoundOn("deidara.theme", caster)
    EmitSoundOn("", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_c2_dragon", parent)
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

    local c2_dragon_awake = parent:FindAbilityByName("c2_dragon_awake")
    if not c2_dragon_awake:IsNull() and c2_dragon_awake:IsTrained() then
        c2_dragon_awake.c2_dragon_awake_skills_used = true
    end
end