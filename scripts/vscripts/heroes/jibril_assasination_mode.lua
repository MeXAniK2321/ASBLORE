LinkLuaModifier("modifier_jibril_assasination_mode", "heroes/jibril_assasination_mode", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jibril_loli", "heroes/jibril_assasination_mode", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
jibril_assasination_mode = class({})

function jibril_assasination_mode:IsStealable() return true end
function jibril_assasination_mode:IsHiddenWhenStolen() return false end

function jibril_assasination_mode:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("jibril_air_strike")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end


function jibril_assasination_mode:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	


    caster:AddNewModifier(caster, self, "modifier_jibril_assasination_mode", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()

    self:PlayEffects()
end
function jibril_assasination_mode:PlayEffects()
	-- get resources
	local particle_cast = "particles/jibril_assasination_mode.vpcf"
	local caster = self:GetCaster()

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 2, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound

end
---------------------------------------------------------------------------------------------------------------------
modifier_jibril_assasination_mode = class({})
function modifier_jibril_assasination_mode:IsHidden() return false end
function modifier_jibril_assasination_mode:IsDebuff() return true end
function modifier_jibril_assasination_mode:IsPurgable() return false end
function modifier_jibril_assasination_mode:IsPurgeException() return false end
function modifier_jibril_assasination_mode:RemoveOnDeath() return true end
function modifier_jibril_assasination_mode:AllowIllusionDuplicate() return true end
function modifier_jibril_assasination_mode:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("devil_trigger_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_jibril_assasination_mode:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
                    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					MODIFIER_PROPERTY_HEALTH_BONUS,
							MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
MODIFIER_PROPERTY_STATS_AGILITY_BONUS,					}
    return func
end
function modifier_jibril_assasination_mode:GetModifierModelChange()
    return "models/jibril/jibril_scythe.vmdl"
end
function modifier_jibril_assasination_mode:GetModifierModelScale()
	return 1
end
function modifier_jibril_assasination_mode:GetModifierPreAttack_BonusDamage()
    return 500
end
function modifier_jibril_assasination_mode:GetAttackSound()
	return "jibril.scythe_attack_sfx"
end
function modifier_jibril_assasination_mode:GetModifierHealthBonus()
    return 1000
end
function modifier_jibril_assasination_mode:GetModifierBonusStats_Agility()

    return 150
	
end
function modifier_jibril_assasination_mode:GetModifierAttackRangeBonus()
	return -375
end


function modifier_jibril_assasination_mode:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()
	self.parent:SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )
	

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["jibril_assasination_mode"] = "jibril_air_strike",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/jibril_assasination_mode_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
	

        
		
        EmitSoundOn("jibril.5", self.parent)
		local delay = 0.2

	Timers:CreateTimer(delay,function()
		self:PlayEffects()
	end)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_jibril_assasination_mode:PlayEffects()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/jibril_scythe_flame.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_scythe", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end
function modifier_jibril_assasination_mode:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_jibril_assasination_mode:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			self.parent:SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )

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
		self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_jibril_loli", {duration = 10})
		 EmitSoundOn("jibril.loli", self.parent)
    end
end
modifier_jibril_loli = class({})
function modifier_jibril_loli:IsHidden() return false end
function modifier_jibril_loli:IsDebuff() return true end
function modifier_jibril_loli:IsPurgable() return false end
function modifier_jibril_loli:IsPurgeException() return false end
function modifier_jibril_loli:RemoveOnDeath() return true end
function modifier_jibril_loli:AllowIllusionDuplicate() return false end
function modifier_jibril_loli:DeclareFunctions()
    local func = { 
    				MODIFIER_PROPERTY_MODEL_SCALE,
                    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					MODIFIER_PROPERTY_HEALTH_BONUS,
							MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
MODIFIER_PROPERTY_STATS_AGILITY_BONUS,					}
    return func
end
function modifier_jibril_loli:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end
function modifier_jibril_loli:GetModifierModelScale()
	return -50
end
function modifier_jibril_loli:GetModifierBaseAttack_BonusDamage()
    return -250
end
function modifier_jibril_loli:GetModifierHealthBonus()
    return -2000
end