LinkLuaModifier("modifier_uranus_system", "heroes/uranus_system", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_uranus_system_invul", "heroes/uranus_system", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)


uranus_system = class({})

function uranus_system:IsStealable() return true end
function uranus_system:IsHiddenWhenStolen() return false end

function uranus_system:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("thunder_tornado")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function uranus_system:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
	local duration = 3.0
	local damage = 2000

	

	

    caster:AddNewModifier(caster, self, "modifier_uranus_system", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_uranus_system_invul", {duration = 2})	
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
    self:EndCooldown()
end
function uranus_system:OnProjectileHit(hTarget, vLocation)
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
modifier_uranus_system_invul = class({})
function modifier_uranus_system_invul:IsHidden() return false end
function modifier_uranus_system_invul:IsDebuff() return true end
function modifier_uranus_system_invul:IsPurgable() return false end
function modifier_uranus_system_invul:IsPurgeException() return false end
function modifier_uranus_system_invul:RemoveOnDeath() return true end
function modifier_uranus_system_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_uranus_system_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_uranus_system_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_6
end


---------------------------------------------------------------------------------------------------------------------
modifier_uranus_system = class({})
function modifier_uranus_system:IsHidden() return false end
function modifier_uranus_system:IsDebuff() return true end
function modifier_uranus_system:IsPurgable() return false end
function modifier_uranus_system:IsPurgeException() return false end
function modifier_uranus_system:RemoveOnDeath() return true end
function modifier_uranus_system:AllowIllusionDuplicate() return true end
function modifier_uranus_system:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("uranus_system_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_uranus_system:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,	
MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,				}
    return func
end

function modifier_uranus_system:GetModifierPreAttack_BonusDamage()
	return 250
end
function modifier_uranus_system:GetModifierModelChange()
   
    return "models/ikaros/untitled.vmdl"
	end


function modifier_uranus_system:GetModifierModelScale()
    if self:GetCaster():HasModifier("modifier_uranys_system_launched") then
	return 1
	else
	return 30
	end
	
end

function modifier_uranus_system:GetModifierBonusStats_Strength()

    return 50
	

	
end


function modifier_uranus_system:GetModifierBonusStats_Agility()

    return 75

	

end
function modifier_uranus_system:GetAttackSound()
	return "ikaros.shot"
end

function modifier_uranus_system:GetModifierProjectileName()
	return "particles/uranus_system_projectile.vpcf"
end

function modifier_uranus_system:GetModifierProjectileSpeedBonus()
	return 1300
end



function modifier_uranus_system:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
	
	  if self:GetCaster():HasModifier("modifier_uranys_system_launched") then

    self.skills_table = {
                            ["uranus_system"] = "appolon_bow",
							
                            
                        }
						
					
					
	else
				self.skills_table = {
                            ["uranus_system"] = "appolon_bow",
							["angel_initialize"] = "aegis_activate",
							["watermelon_hit"] = "artemis_launcher",
                           
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
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/uranus_system.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      local ability2 = self:GetParent():FindAbilityByName("angel_initialize")
        if ability2:IsActivated() then
            ability2:SetActivated(false)
        end
    end
		 
        EmitSoundOn("ikaros.5", self.parent)
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end


function modifier_uranus_system:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_uranus_system:OnDestroy()
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

            StopGlobalSound("star.theme2_16")

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("uranus_system_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
				if IsServer() then
        local ability2 = self:GetParent():FindAbilityByName("angel_initialize")
        if ability2 and not ability2:IsActivated() then
            ability2:SetActivated(true)
        
    end
        end
    end
end
end
function modifier_uranus_system:GetEffectName()
	return "particles/ikaros_nimbus.vpcf"
end

function modifier_uranus_system:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
uranus_system_awake = class({})

function uranus_system_awake:IsStealable() return true end
function uranus_system_awake:IsHiddenWhenStolen() return false end
function uranus_system_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("uranus_system")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function uranus_system_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_uranus_system", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_uranus_system", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("uranus_system")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.uranus_system_awake_skills_used, "sss")
        if not self.uranus_system_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.uranus_system_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_uranus_system", parent)
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

    local uranus_system_awake = parent:FindAbilityByName("uranus_system_awake")
    if not uranus_system_awake:IsNull() and uranus_system_awake:IsTrained() then
        uranus_system_awake.uranus_system_awake_skills_used = true
    end
end


