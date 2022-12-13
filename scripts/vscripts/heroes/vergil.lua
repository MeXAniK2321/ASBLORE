judgment_cut = class({})
LinkLuaModifier( "modifier_judgment_cut", "heroes/vergil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_judgment_cut_cd", "heroes/vergil.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function judgment_cut:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function judgment_cut:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	caster:AddNewModifier(self:GetCaster(), self, "modifier_judgment_cut_cd", {duration = duration + 0.1})

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_judgment_cut", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	
	if caster:HasModifier("modifier_motivated") then
	self:EndCooldown()
	else
	end
end

modifier_judgment_cut_cd = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_judgment_cut_cd:IsHidden()
	return true
end

function modifier_judgment_cut_cd:IsDebuff()
	return false
end

function modifier_judgment_cut_cd:IsPurgable()
	return false
end

modifier_judgment_cut = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_judgment_cut:IsHidden()
	return false
end

function modifier_judgment_cut:IsDebuff()
	return true
end

function modifier_judgment_cut:IsStunDebuff()
	return false
end

function modifier_judgment_cut:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_judgment_cut:OnCreated( kv )
	-- references
	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.armor = self:GetAbility():GetSpecialValueFor( "root" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end

	-- precache damage
	self.damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
    		--Optional.
	}
local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		self:GetCaster():PerformAttack(enemy, true,
				true,
				true,
				true,
				true,
				false,
				true)

		
	end
	self:StartIntervalThink( interval )

	-- precache effects
	self.sound_cast = "vergil.judgment_cut"
	EmitSoundOn( self.sound_cast, self:GetParent() )

	-- Play effects
	self:PlayEffects()
end

function modifier_judgment_cut:OnRefresh( kv )
	
end

function modifier_judgment_cut:OnRemoved()
end

function modifier_judgment_cut:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_judgment_cut:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		
		
	}

	return state
end
function modifier_judgment_cut:DeclareFunctions()
local func = {
 MODIFIER_PROPERTY_FIXED_DAY_VISION,
 MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
 MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 }
 return func
end
function modifier_judgment_cut:GetModifierMoveSpeedBonus_Percentage()
	return -100
end



--------------------------------------------------------------------------------
-- Interval Effects
function modifier_judgment_cut:OnIntervalThink()
	-- find enemies 
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		self:GetCaster():PerformAttack(enemy, true,
				true,
				true,
				true,
				true,
				false,
				true)

		
	end
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_judgment_cut:IsAura()
	return self.thinker
end

function modifier_judgment_cut:GetModifierAura()
	return "modifier_judgment_cut"
end

function modifier_judgment_cut:GetAuraRadius()
	return self.radius
end

function modifier_judgment_cut:GetAuraDuration()
	return 0.5
end

function modifier_judgment_cut:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_judgment_cut:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_judgment_cut:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_judgment_cut:GetEffectName()
	return ""
end

function modifier_judgment_cut:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_judgment_cut:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/test_cut1.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end

judgment_cut_end = class({})
LinkLuaModifier( "modifier_judgment_cut_end_invul", "heroes/vergil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_judgment_cut_end", "modifiers/modifier_judgment_cut_end", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_judgment_end", "modifiers/modifier_judgment_end", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_judgment_cut_end_astral", "heroes/vergil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_judgment_end_damage", "heroes/vergil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_judgment_cut_end_invul_2", "heroes/vergil", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function judgment_cut_end:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("hell_on_earth")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function judgment_cut_end:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage")
	local point = self:GetCaster():GetOrigin()
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
	
	for _,enemy in pairs(enemies) do
		-- damage	
		local delay = 0.5

	
	enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 2.75 } -- kv
		)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_judgment_end", -- modifier name
			{ duration = 0.5 } -- kv
		)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_judgment_end_damage", -- modifier name
			{ duration = 1.75 } -- kv
		)
	end
	
caster:AddNewModifier(caster, self, "modifier_judgment_cut_end_invul", {duration = 0.3})	

	self.sound_cast = "vergil.judgment_cut_end_start"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
	
	self:PlayEffects()
	


	
end
function judgment_cut_end:PlayEffects( radius )
	local particle_cast = "particles/judgment_cut_pre.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


modifier_judgment_cut_end_invul = class({})
function modifier_judgment_cut_end_invul:IsHidden() return false end
function modifier_judgment_cut_end_invul:IsDebuff() return true end
function modifier_judgment_cut_end_invul:IsPurgable() return false end
function modifier_judgment_cut_end_invul:IsPurgeException() return false end
function modifier_judgment_cut_end_invul:RemoveOnDeath() return true end
function modifier_judgment_cut_end_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_judgment_cut_end_invul:OnCreated()
if IsServer() then
        --self:SetStackCount(0)
       self.sound_cast = "vergil.4"
	EmitSoundOn( self.sound_cast, self:GetParent() )
    end
end
function modifier_judgment_cut_end_invul:OnDestroy()
local caster = self:GetCaster()
self.yamato_fx = 	ParticleManager:CreateParticle("particles/vergil_end_cut_flash1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.yamato_fx , 0, self:GetCaster(), 5, "attach_yamato", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.yamato_fx , 1, self:GetCaster(), 5, "attach_yamato", Vector(0,0,0), true)
	self:PlayEffects()
self:GetParent():AddNewModifier(caster, self, "modifier_judgment_cut_end_astral", {duration = 1.0})		
end
function modifier_judgment_cut_end_invul:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vergil_blur.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end

function modifier_judgment_cut_end_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_judgment_cut_end_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end


modifier_judgment_cut_end_astral = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_judgment_cut_end_astral:IsHidden()
	return false
end

function modifier_judgment_cut_end_astral:IsDebuff()
	return false
end

function modifier_judgment_cut_end_astral:IsStunDebuff()
	return true
end

function modifier_judgment_cut_end_astral:IsPurgable()
	return true
end

function modifier_judgment_cut_end_astral:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_judgment_cut_end_astral:OnCreated( kv )
	
	self:PlayEffects()
	self:GetParent():AddNoDraw()
end




function modifier_judgment_cut_end_astral:OnRemoved()
end

function modifier_judgment_cut_end_astral:OnDestroy()
	if not IsServer() then return end


	


	self:GetParent():RemoveNoDraw()

	
	self:GetParent():AddNewModifier(caster, self, "modifier_judgment_cut_end_invul_2", {duration = 1.0})	
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_judgment_cut_end_astral:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_judgment_cut_end_astral:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/vergil_blur.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	

end





modifier_judgment_cut_end_invul_2 = class({})
function modifier_judgment_cut_end_invul_2:IsHidden() return false end
function modifier_judgment_cut_end_invul_2:IsDebuff() return true end
function modifier_judgment_cut_end_invul_2:IsPurgable() return false end
function modifier_judgment_cut_end_invul_2:IsPurgeException() return false end
function modifier_judgment_cut_end_invul_2:RemoveOnDeath() return true end
function modifier_judgment_cut_end_invul_2:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_judgment_cut_end_invul_2:OnCreated()
if IsServer() then
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_7)
       self:PlayEffects()
    end
end
function modifier_judgment_cut_end_invul_2:OnDestroy()
local caster = self:GetCaster()
self.yamato_fx = 	ParticleManager:CreateParticle("particles/vergil_end_cut_flash1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.yamato_fx , 0, self:GetCaster(), 5, "attach_yamato", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.yamato_fx , 1, self:GetCaster(), 5, "attach_yamato", Vector(0,0,0), true)
	
end
function modifier_judgment_cut_end_invul_2:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vergil_blur.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	self.sound_cast = "vergil.judgment_cut_end_ended"
	EmitSoundOn( self.sound_cast, self:GetParent() )

end

function modifier_judgment_cut_end_invul_2:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_judgment_cut_end_invul_2:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_7
end


modifier_judgment_end_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_judgment_end_damage:IsHidden()
	return false
end

function modifier_judgment_end_damage:IsDebuff()
	return true
end

function modifier_judgment_end_damage:IsStunDebuff()
	return false
end

function modifier_judgment_end_damage:IsPurgable()
	return true
end

function modifier_judgment_end_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_judgment_end_damage:OnCreated( kv )
	-- references
	self.duration = 1.95
	self.damage2 = self:GetCaster():GetAgility()	* 7
	self.damage = 500 + self.damage2

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
end

function modifier_judgment_end_damage:OnRefresh( kv )
	
end

function modifier_judgment_end_damage:OnRemoved()
end

function modifier_judgment_end_damage:OnDestroy()
end


function modifier_judgment_end_damage:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_judgment_end_damage:Silence()


	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self,
			--Optional.
	}
	ApplyDamage( damageTable )

	self:PlayEffects()

	StopSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end



function modifier_judgment_end_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_judgment_end_damage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/end_cut_hit.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

























hell_on_earth = class({})
LinkLuaModifier( "modifier_hell_on_earth_invul", "heroes/vergil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hell_on_earth_damage", "heroes/vergil", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function hell_on_earth:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage")
	local point = self:GetCaster():GetOrigin()
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
	
	for _,enemy in pairs(enemies) do
		-- damage	
		

	
	enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 1.0 } -- kv
		)
	

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_judgment_end_damage", -- modifier name
			{ duration = 0.95 } -- kv
		)
	end
	
caster:AddNewModifier(caster, self, "modifier_hell_on_earth_invul", {duration = 0.9})	

	self.sound_cast = "vergil.hell_on_earth_start"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
	
	self:PlayEffects()

	
end
function hell_on_earth:PlayEffects( radius )
	local particle_cast = "particles/vergil_hell_on_earth.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


modifier_hell_on_earth_invul = class({})
function modifier_hell_on_earth_invul:IsHidden() return false end
function modifier_hell_on_earth_invul:IsDebuff() return true end
function modifier_hell_on_earth_invul:IsPurgable() return false end
function modifier_hell_on_earth_invul:IsPurgeException() return false end
function modifier_hell_on_earth_invul:RemoveOnDeath() return true end
function modifier_hell_on_earth_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_hell_on_earth_invul:OnCreated()
if IsServer() then
        --self:SetStackCount(0)
    
    end
end
function modifier_hell_on_earth_invul:OnDestroy()
local caster = self:GetCaster()
local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
		-- damage	
		

	
	enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 1.0 } -- kv
		)
		end
		self.sound_cast = "vergil.hell_on_earth_slam"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
	
end
function modifier_hell_on_earth_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_hell_on_earth_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_7
end








modifier_hell_on_earth_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hell_on_earth_damage:IsHidden()
	return false
end

function modifier_hell_on_earth_damage:IsDebuff()
	return true
end

function modifier_hell_on_earth_damage:IsStunDebuff()
	return false
end

function modifier_hell_on_earth_damage:IsPurgable()
	return true
end

function modifier_hell_on_earth_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_hell_on_earth_damage:OnCreated( kv )
	-- references
	self.duration = 0.95
	self.damage = self:GetCaster():GetAgility()	* 12

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
end

function modifier_hell_on_earth_damage:OnRefresh( kv )
	
end

function modifier_hell_on_earth_damage:OnRemoved()
end

function modifier_hell_on_earth_damage:OnDestroy()
end


function modifier_hell_on_earth_damage:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_hell_on_earth_damage:Silence()


	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	self:PlayEffects()

	StopSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end



function modifier_hell_on_earth_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hell_on_earth_damage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/end_cut_hit.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end