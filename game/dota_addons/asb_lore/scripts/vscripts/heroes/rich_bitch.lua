LinkLuaModifier("modifier_rich_bitch", "heroes/rich_bitch", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)

rich_bitch = class({})

function rich_bitch:IsStealable() return true end
function rich_bitch:IsHiddenWhenStolen() return false end

function rich_bitch:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("money_explosion")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function rich_bitch:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function rich_bitch:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_rich_bitch", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = fixed_duration})
local modifier = caster:FindModifierByNameAndCaster("modifier_daisuke_investition",caster)
	if modifier == nil then return end
	local gold = modifier:GetStackCount() * 10
	PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
    self:EndCooldown()
modifier:SetStackCount(0)
   
end
function rich_bitch:OnProjectileHit(hTarget, vLocation)
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
modifier_rich_bitch = class({})
function modifier_rich_bitch:IsHidden() return false end
function modifier_rich_bitch:IsDebuff() return true end
function modifier_rich_bitch:IsPurgable() return false end
function modifier_rich_bitch:IsPurgeException() return false end
function modifier_rich_bitch:RemoveOnDeath() return true end
function modifier_rich_bitch:AllowIllusionDuplicate() return true end
function modifier_rich_bitch:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("rich_bitch_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_rich_bitch:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end

function modifier_rich_bitch:GetModifierSpellAmplify_Percentage()
    return self:GetStackCount()
end








function modifier_rich_bitch:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["rich_bitch"] = "money_explosion",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/rich_bitch.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("daisuke_4", self.parent)
       

        self.parent:Purge(false, true, false, true, true)
        
        self:StartIntervalThink(0.1)
    end
end
end
function modifier_rich_bitch:OnIntervalThink()
    local fBonusSpellAmpPerc = self:GetParent():HasShard() 
                               and math.min(math.floor(self:GetParent():GetGold() * 0.01), 300)
                               or 0
    self:SetStackCount(fBonusSpellAmpPerc)
end
function modifier_rich_bitch:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_rich_bitch:OnDestroy()
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

            StopSoundOn("daisuke_4", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("rich_bitch_awake")
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
rich_bitch_awake = class({})

function rich_bitch_awake:IsStealable() return true end
function rich_bitch_awake:IsHiddenWhenStolen() return false end
function rich_bitch_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rich_bitch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function rich_bitch_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_rich_bitch", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_rich_bitch", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("rich_bitch")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.rich_bitch_awake_skills_used, "sss")
        if not self.rich_bitch_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.rich_bitch_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_rich_bitch", parent)
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

    local rich_bitch_awake = parent:FindAbilityByName("rich_bitch_awake")
    if not rich_bitch_awake:IsNull() and rich_bitch_awake:IsTrained() then
        rich_bitch_awake.rich_bitch_awake_skills_used = true
    end
end


