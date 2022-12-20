LinkLuaModifier("modifier_shana_wings", "heroes/shana_wings", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
shana_wings = class({})

function shana_wings:IsStealable() return true end
function shana_wings:IsHiddenWhenStolen() return false end

function shana_wings:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("tenpa_josai")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function shana_wings:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function shana_wings:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_shana_wings", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_shana_wings = class({})
function modifier_shana_wings:IsHidden() return false end
function modifier_shana_wings:IsDebuff() return true end
function modifier_shana_wings:IsPurgable() return false end
function modifier_shana_wings:IsPurgeException() return false end
function modifier_shana_wings:RemoveOnDeath() return true end
function modifier_shana_wings:AllowIllusionDuplicate() return true end
function modifier_shana_wings:CheckState()
   
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}

    return state
end
function modifier_shana_wings:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,                   
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
    return func
end




function modifier_shana_wings:GetModifierMagicalResistanceBonus()
    return 20
end
function modifier_shana_wings:GetModifierSpellAmplify_Percentage()
    return 50
end

function modifier_shana_wings:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["shana_wings"] = "tenpa_josai",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/ember_spirit_ambient_head.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_l", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
        end

        
		
        EmitSoundOn("shana.5", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_shana_wings:GetEffectName()

	return "particles/shana_wings.vpcf"
	end
function modifier_shana_wings:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_shana_wings:OnDestroy()
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

            StopSoundOn("shana.5", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
               
            end
        end
    end
end

LinkLuaModifier("modifier_shana_ring", "heroes/shana_wings", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shana_ring_buff", "heroes/shana_wings", LUA_MODIFIER_MOTION_NONE)

shana_ring = class({})

function shana_ring:IsStealable() return true end
function shana_ring:IsHiddenWhenStolen() return false end
function shana_ring:OnAbilityPhaseStart()
	self.pre_ring_fx = 	ParticleManager:CreateParticle("", PATTACH_WORLDORIGIN, nil)
	                    ParticleManager:SetParticleControl(self.pre_ring_fx, 0, self:GetCaster():GetAbsOrigin())
	                    ParticleManager:SetParticleControl(self.pre_ring_fx, 1, Vector(self:GetAOERadius(), 1, 1))

	return true
end
function shana_ring:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle(self.pre_ring_fx, false)
	ParticleManager:ReleaseParticleIndex(self.pre_ring_fx)
end
function shana_ring:GetAOERadius()
	return self:GetSpecialValueFor("ring_radius") 
end
function shana_ring:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("ring_duration")
	local radius  = self:GetSpecialValueFor("ring_radius")
	local damage = self:GetSpecialValueFor("ring_dot_damage") * 2
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_shana_ring_buff", -- modifier name
			{ duration = 1.5 } -- kv
		)
		end
		
    self:PlayEffects()
    CreateModifierThinker(caster, self, "modifier_shana_ring", {duration = duration}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
end
function shana_ring:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/hien_shockwave.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
end
---------------------------------------------------------------------------------------------------------------------
modifier_shana_ring = class({})
function modifier_shana_ring:IsHidden() return true end
function modifier_shana_ring:IsDebuff() return false end
function modifier_shana_ring:IsPurgable() return false end
function modifier_shana_ring:IsPurgeException() return false end
function modifier_shana_ring:RemoveOnDeath() return true end
function modifier_shana_ring:IsAura() return true end
function modifier_shana_ring:IsAuraActiveOnDeath() return false end
function modifier_shana_ring:GetAuraDuration()
	return self.ring_dot_duration
end
function modifier_shana_ring:GetAuraEntityReject(hEntity)
end
function modifier_shana_ring:GetAuraRadius()
    return self.ring_radius
end
function modifier_shana_ring:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end
function modifier_shana_ring:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end
function modifier_shana_ring:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
function modifier_shana_ring:GetModifierAura()
    return "modifier_shana_ring_buff"
end
function modifier_shana_ring:OnCreated(table)
    if IsServer() then
        self.caster = self:GetCaster()
        self.parent = self:GetParent()
        self.ability = self:GetAbility()

        self.ring_radius = self.ability:GetAOERadius()

      	self.ring_dot_duration = self.ability:GetSpecialValueFor("ring_dot_duration")

		
		EmitSoundOn("shana.3", self.parent)

      	if not self.ring_fx then
		if self:GetCaster():HasModifier("modifier_alastor_awake") then
		 self.ring_fx = ParticleManager:CreateParticle("particles/hien_alastor.vpcf", PATTACH_WORLDORIGIN, nil)
		                    ParticleManager:SetParticleControl(self.ring_fx, 0, self.parent:GetAbsOrigin())
		                    ParticleManager:SetParticleControl(self.ring_fx, 1, Vector(self.ring_radius, 1, 1))
		                    ParticleManager:SetParticleControl(self.ring_fx, 2, Vector(self:GetDuration(), 0, 0))

	        self:AddParticle(self.ring_fx, false, false, -1, true, true)
		else
		    self.ring_fx = ParticleManager:CreateParticle("particles/hien.vpcf", PATTACH_WORLDORIGIN, nil)
		                    ParticleManager:SetParticleControl(self.ring_fx, 0, self.parent:GetAbsOrigin())
		                    ParticleManager:SetParticleControl(self.ring_fx, 1, Vector(self.ring_radius, 1, 1))
		                    ParticleManager:SetParticleControl(self.ring_fx, 2, Vector(self:GetDuration(), 0, 0))

	        self:AddParticle(self.ring_fx, false, false, -1, true, true)
	    end
		end
    end
end
function modifier_shana_ring:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_shana_ring_buff = class({})
function modifier_shana_ring_buff:IsHidden() return false end
function modifier_shana_ring_buff:IsDebuff() return true end
function modifier_shana_ring_buff:IsPurgable() return true end
function modifier_shana_ring_buff:IsPurgeException() return true end
function modifier_shana_ring_buff:RemoveOnDeath() return true end
function modifier_shana_ring_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_shana_ring_buff:OnCreated(table)
    if IsServer() then
        self.caster = self:GetCaster()
        self.parent = self:GetParent()
        self.ability = self:GetAbility()

        self.ring_dot_interval  = self.ability:GetSpecialValueFor("ring_dot_interval")
        self.ring_dot_damage    = self.ring_dot_interval * (self.ability:GetSpecialValueFor("ring_dot_damage"))+ self:GetCaster():FindTalentValue("special_bonus_shana_20")

        local burn_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        
        self:AddParticle(burn_fx, false, false, -1, true, true)

        self:StartIntervalThink(self.ring_dot_interval)
    end
end
function modifier_shana_ring_buff:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
function modifier_shana_ring_buff:OnIntervalThink()
    if IsServer() then
        local damage_table = {  victim = self.parent,
                                attacker = self.caster,
                                damage = self.ring_dot_damage,
                                damage_type = self.ability:GetAbilityDamageType(),
                                ability = self.ability }

        ApplyDamage(damage_table)
    end
end

angry_loli_urusai = class({})
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function angry_loli_urusai:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	if self:GetCaster():HasModifier("modifier_alastor_awake") then
	self.damage = self:GetSpecialValueFor("damage") * 1.4
	else
	self.damage = self:GetSpecialValueFor("damage") 
	end

	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_silenced_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end
	if self:GetCaster():HasModifier("modifier_alastor_awake") then
	self:PlayEffects2( radius )
    elseif self:GetCaster():HasModifier("modifier_shana_wings") then
	self:PlayEffects1( radius )
	else
	self:PlayEffects( radius )
	end
end

function angry_loli_urusai:PlayEffects( radius )
	local particle_cast = "particles/angry_loli_urusai.vpcf"
	local sound_cast = "shana.6"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function angry_loli_urusai:PlayEffects1( radius )
	local particle_cast = "particles/angry_loli_urusai2_0.vpcf"
	local sound_cast = "shana.6_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function angry_loli_urusai:PlayEffects2( radius )
	local particle_cast = "particles/angry_loli_urusai_tenpa.vpcf"
	local sound_cast = "shana.6_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end