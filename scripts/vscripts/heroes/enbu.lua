LinkLuaModifier("modifier_enbu", "heroes/enbu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enbu_burn", "heroes/enbu", LUA_MODIFIER_MOTION_NONE)
enbu = class({})

function enbu:IsStealable() return true end
function enbu:IsHiddenWhenStolen() return false end

function enbu:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("enbu_hit")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function enbu:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function enbu:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_enbu", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
function enbu:OnProjectileHit(hTarget, vLocation)
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
modifier_enbu = class({})
function modifier_enbu:IsHidden() return false end
function modifier_enbu:IsDebuff() return true end
function modifier_enbu:IsPurgable() return false end
function modifier_enbu:IsPurgeException() return false end
function modifier_enbu:RemoveOnDeath() return true end
function modifier_enbu:AllowIllusionDuplicate() return true end
function modifier_enbu:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("enbu_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_enbu:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                 MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
                    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
MODIFIER_EVENT_ON_ATTACK_LANDED,					}
    return func
end
function modifier_enbu:GetModifierMoveSpeedBonus_Constant()
    return 100
end
function modifier_enbu:GetModifierBonusStats_Strength()
    return 40
end

function modifier_enbu:GetModifierBonusStats_Agility()
    return 40
end

function modifier_enbu:GetModifierPreAttack_BonusDamage()
    return 300
end
function modifier_enbu:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if not params.attacker:IsIllusion() then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_enbu_burn", {duration = 1.5 })
			end
		end
	end
end


function modifier_enbu:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["enbu"] = "enbu_hit",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/tanjiro_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("tanjiro.5", self.parent)
        
self:PlayEffects()
self:PlayEffects2()
self:PlayEffects3()
        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_enbu:PlayEffects()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/base_fire_flame1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "tanjiro_sword", self.parent:GetAbsOrigin(), true)
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
function modifier_enbu:PlayEffects2()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/base_fire_flame1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "tanjiro_sword1", self.parent:GetAbsOrigin(), true)
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
function modifier_enbu:PlayEffects3()
		-- Get Resources
	local particle_cast = "particles/juggernaut_blade_fury1.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/base_fire_flame1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "tanjiro_sword2", self.parent:GetAbsOrigin(), true)
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
function modifier_enbu:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_enbu:OnDestroy()
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

            StopSoundOn("tanjiro.5", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("enbu_awake")
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
enbu_awake = class({})

function enbu_awake:IsStealable() return true end
function enbu_awake:IsHiddenWhenStolen() return false end
function enbu_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("enbu")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function enbu_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_enbu", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_enbu", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("enbu")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.enbu_awake_skills_used, "sss")
        if not self.enbu_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.enbu_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_enbu", parent)
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

    local enbu_awake = parent:FindAbilityByName("enbu_awake")
    if not enbu_awake:IsNull() and enbu_awake:IsTrained() then
        enbu_awake.enbu_awake_skills_used = true
    end
end


LinkLuaModifier("modifier_kotori_ring", "heroes/enbu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kotori_ring_buff", "heroes/enbu", LUA_MODIFIER_MOTION_NONE)

kotori_ring = class({})

function kotori_ring:IsStealable() return true end
function kotori_ring:IsHiddenWhenStolen() return false end
function kotori_ring:OnAbilityPhaseStart()
	self.pre_ring_fx = 	ParticleManager:CreateParticle("", PATTACH_WORLDORIGIN, nil)
	                    ParticleManager:SetParticleControl(self.pre_ring_fx, 0, self:GetCaster():GetAbsOrigin())
	                    ParticleManager:SetParticleControl(self.pre_ring_fx, 1, Vector(self:GetAOERadius(), 1, 1))

	return true
end
function kotori_ring:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle(self.pre_ring_fx, false)
	ParticleManager:ReleaseParticleIndex(self.pre_ring_fx)
end
function kotori_ring:GetAOERadius()
	return self:GetSpecialValueFor("ring_radius") 
end
function kotori_ring:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("ring_duration")

    CreateModifierThinker(caster, self, "modifier_kotori_ring", {duration = duration}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
end
---------------------------------------------------------------------------------------------------------------------
modifier_kotori_ring = class({})
function modifier_kotori_ring:IsHidden() return true end
function modifier_kotori_ring:IsDebuff() return false end
function modifier_kotori_ring:IsPurgable() return false end
function modifier_kotori_ring:IsPurgeException() return false end
function modifier_kotori_ring:RemoveOnDeath() return true end
function modifier_kotori_ring:IsAura() return true end
function modifier_kotori_ring:IsAuraActiveOnDeath() return false end
function modifier_kotori_ring:GetAuraDuration()
	return self.ring_dot_duration
end
function modifier_kotori_ring:GetAuraEntityReject(hEntity)
end
function modifier_kotori_ring:GetAuraRadius()
    return self.ring_radius
end
function modifier_kotori_ring:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end
function modifier_kotori_ring:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end
function modifier_kotori_ring:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
function modifier_kotori_ring:GetModifierAura()
    return "modifier_kotori_ring_buff"
end
function modifier_kotori_ring:OnCreated(table)
    if IsServer() then
        self.caster = self:GetCaster()
        self.parent = self:GetParent()
        self.ability = self:GetAbility()

        self.ring_radius = self.ability:GetAOERadius()

      	self.ring_dot_duration = self.ability:GetSpecialValueFor("ring_dot_duration")

		EmitSoundOn("ember_spirit_embr_fireremrun_01", self.parent)
		EmitSoundOn("Shana.Hien", self.parent)

      	if not self.ring_fx then
		    self.ring_fx = ParticleManager:CreateParticle("particles/hien.vpcf", PATTACH_WORLDORIGIN, nil)
		                    ParticleManager:SetParticleControl(self.ring_fx, 0, self.parent:GetAbsOrigin())
		                    ParticleManager:SetParticleControl(self.ring_fx, 1, Vector(self.ring_radius, 1, 1))
		                    ParticleManager:SetParticleControl(self.ring_fx, 2, Vector(self:GetDuration(), 0, 0))

	        self:AddParticle(self.ring_fx, false, false, -1, true, true)
	    end
    end
end
function modifier_kotori_ring:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_kotori_ring_buff = class({})
function modifier_kotori_ring_buff:IsHidden() return false end
function modifier_kotori_ring_buff:IsDebuff() return true end
function modifier_kotori_ring_buff:IsPurgable() return true end
function modifier_kotori_ring_buff:IsPurgeException() return true end
function modifier_kotori_ring_buff:RemoveOnDeath() return true end
function modifier_kotori_ring_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_kotori_ring_buff:OnCreated(table)
    if IsServer() then
        self.caster = self:GetCaster()
        self.parent = self:GetParent()
        self.ability = self:GetAbility()

        self.ring_dot_interval  = self.ability:GetSpecialValueFor("ring_dot_interval")
        self.ring_dot_damage    = self.ring_dot_interval * (self.ability:GetSpecialValueFor("ring_dot_damage"))

        local burn_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        
        self:AddParticle(burn_fx, false, false, -1, true, true)

        self:StartIntervalThink(self.ring_dot_interval)
    end
end
function modifier_kotori_ring_buff:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
function modifier_kotori_ring_buff:OnIntervalThink()
    if IsServer() then
        local damage_table = {  victim = self.parent,
                                attacker = self.caster,
                                damage = self.ring_dot_damage,
                                damage_type = self.ability:GetAbilityDamageType(),
                                ability = self.ability }

        ApplyDamage(damage_table)
    end
end

modifier_enbu_burn = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_enbu_burn:IsHidden()
	return false
end

function modifier_enbu_burn:IsDebuff()
	return true
end

function modifier_enbu_burn:IsStunDebuff()
	return false
end

function modifier_enbu_burn:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_enbu_burn:OnCreated( kv )
	-- references
	local damage = 100
	

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.5 )
end

function modifier_enbu_burn:OnRefresh( kv )
	-- references
	local damage = 100
	

	if not IsServer() then return end

	-- update damage
	self.damageTable.damage = damage	
end

function modifier_enbu_burn:OnRemoved()
end

function modifier_enbu_burn:OnDestroy()
end

-- Interval Effects
function modifier_enbu_burn:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_enbu_burn:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_enbu_burn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end