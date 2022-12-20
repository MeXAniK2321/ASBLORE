LinkLuaModifier("modifier_emperor_time", "heroes/emperor_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
emperor_time = class({})

function emperor_time:IsStealable() return true end
function emperor_time:IsHiddenWhenStolen() return false end


function emperor_time:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("downsing_chain")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function emperor_time:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function emperor_time:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_emperor_time", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = fixed_duration})

    self:EndCooldown()


end
---------------------------------------------------------------------------------------------------------------------
modifier_emperor_time = class({})
function modifier_emperor_time:IsHidden() return false end
function modifier_emperor_time:IsDebuff() return true end
function modifier_emperor_time:IsPurgable() return false end
function modifier_emperor_time:IsPurgeException() return false end
function modifier_emperor_time:RemoveOnDeath() return true end
function modifier_emperor_time:AllowIllusionDuplicate() return true end
function modifier_emperor_time:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,  
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,					
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
    return func
end

function modifier_emperor_time:GetModifierModelChange()
    return "models/kurapika/kurta.vmdl"
end

function modifier_emperor_time:GetModifierSpellAmplify_Percentage()
    return 0
end


function modifier_emperor_time:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_emperor_time:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_emperor_time:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_emperor_time:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["emperor_time"] = "downsing_chain",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/emperor_time.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_head", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
						
			end
		

        
		
        EmitSoundOn("kupapika.4", self.parent)
        
		

        self.parent:Purge(false, true, false, true, true)
    end
end
end

function modifier_emperor_time:OnRefresh(table)
    self:OnCreated(table)
end

function modifier_emperor_time:OnDestroy()
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

            StopSoundOn("kupapika.4", self.parent)
			
			
            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("emperor_time_awake")
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
emperor_time_awake = class({})

function emperor_time_awake:IsStealable() return true end
function emperor_time_awake:IsHiddenWhenStolen() return false end
function emperor_time_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("emperor_time")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function emperor_time_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_emperor_time", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_emperor_time", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("emperor_time")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.emperor_time_awake_skills_used, "sss")
        if not self.emperor_time_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.emperor_time_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_emperor_time", parent)
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

    local emperor_time_awake = parent:FindAbilityByName("emperor_time_awake")
    if not emperor_time_awake:IsNull() and emperor_time_awake:IsTrained() then
        emperor_time_awake.emperor_time_awake_skills_used = true
    end
end


