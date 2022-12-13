LinkLuaModifier("modifier_devil_homura", "heroes/devil_homura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)


devil_homura = class({})

function devil_homura:IsStealable() return true end
function devil_homura:IsHiddenWhenStolen() return false end

function devil_homura:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("universe_shatter")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--[[function devil_homura:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function devil_homura:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
	

	

    caster:AddNewModifier(caster, self, "modifier_devil_homura", {duration = fixed_duration})

	
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()

    
end
function devil_homura:OnProjectileHit(hTarget, vLocation)
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
modifier_devil_homura = class({})
function modifier_devil_homura:IsHidden() return false end
function modifier_devil_homura:IsDebuff() return true end
function modifier_devil_homura:IsPurgable() return false end
function modifier_devil_homura:IsPurgeException() return false end
function modifier_devil_homura:RemoveOnDeath() return true end
function modifier_devil_homura:AllowIllusionDuplicate() return true end
function modifier_devil_homura:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("devil_homura_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end
local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    return state
end
function modifier_devil_homura:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND					}
    return func
end


function modifier_devil_homura:GetModifierModelChange()

	return "models/homura/walk.vmdl"
	
end
function modifier_devil_homura:GetModifierModelScale()

	return 35
end

function modifier_devil_homura:GetModifierSpellAmplify_Percentage()

	return 50
	
end
function modifier_devil_homura:GetModifierBonusStats_Strength()

    return 50
	
	
end
function modifier_devil_homura:GetAttackSound()
return "homura.attack"
	
end

function modifier_devil_homura:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["devil_homura"] = "universe_shatter",
							["homura_timestop"] = "darkness_falls",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/homura_devil_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

     
		EmitSoundOn("homura.5", self.parent)
		
		
		
       if IsServer() then
        local ability = self:GetParent():FindAbilityByName("plant_c4")
        if ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
	if IsServer() then
        local ability2 = self:GetParent():FindAbilityByName("homura_aka")
        if ability2:IsActivated() then
            ability2:SetActivated(false)
        end
    end
		
	
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_devil_homura:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_devil_homura:OnDestroy()
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

            
     local ability = self:GetParent():FindAbilityByName("plant_c4")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
	     local ability2 = self:GetParent():FindAbilityByName("homura_aka")
        if ability2 and not ability2:IsActivated() then
            ability2:SetActivated(true)
        end
    end
            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("devil_homura_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
devil_homura_awake = class({})

function devil_homura_awake:IsStealable() return true end
function devil_homura_awake:IsHiddenWhenStolen() return false end
function devil_homura_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("devil_homura")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function devil_homura_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_devil_homura", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_devil_homura", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("devil_homura")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.devil_homura_awake_skills_used, "sss")
        if not self.devil_homura_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.devil_homura_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_devil_homura", parent)
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

    local devil_homura_awake = parent:FindAbilityByName("devil_homura_awake")
    if not devil_homura_awake:IsNull() and devil_homura_awake:IsTrained() then
        devil_homura_awake.devil_homura_awake_skills_used = true
    end
end


