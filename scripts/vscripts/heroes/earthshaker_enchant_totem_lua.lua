earthshaker_enchant_totem_lua = class({})
LinkLuaModifier( "modifier_earthshaker_enchant_totem_lua", "heroes/earthshaker_enchant_totem_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "modifiers/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
-- Behavior
function earthshaker_enchant_totem_lua:GetBehavior()
	if self:GetCaster() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
	return self.BaseClass.GetBehavior( self )
end

--------------------------------------------------------------------------------
-- Custom KV
function earthshaker_enchant_totem_lua:GetAOERadius()
	return self:GetSpecialValueFor( "aftershock_range" )
end

function earthshaker_enchant_totem_lua:GetCastRange( point, target )
	local caster = self:GetCaster()
	if caster then
		return self:GetSpecialValueFor( "distance_scepter" )
	end

	return self.BaseClass.GetCastPoint( self )
end

function earthshaker_enchant_totem_lua:GetCastPoint()
	if not IsServer() then
		if self:GetCaster() then
			return self:GetSpecialValueFor( "scepter_leap_duration" )
		end
		return self.BaseClass.GetCastPoint( self )
	end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if caster and target~=caster then
		return self:GetSpecialValueFor( "scepter_leap_duration" )
	end

	return self.BaseClass.GetCastPoint( self )
end

--------------------------------------------------------------------------------
-- Ability Cast Filter
function earthshaker_enchant_totem_lua:CastFilterResultTarget( hTarget )
	return UF_SUCCESS
end


--------------------------------------------------------------------------------
-- Ability Phase Start
function earthshaker_enchant_totem_lua:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- do normal
	
	

	-- load data
	local duration = self:GetSpecialValueFor( "scepter_leap_duration" )
	local height = self:GetSpecialValueFor( "scepter_height" )
	local distance = (point - caster:GetOrigin()):Length2D()

	-- add arc modifier
	local arc = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			target_x = point.x,
			target_y = point.y,
			distance = distance,
			duration = duration,
			height = height,
			fix_end = false,
			isForward = true,
			-- isRestricted = true,
		} -- kv
	)
	arc:SetEndCallback(function()
		if not self.interrupted then return end
		self.interrupted = nil

		-- do normal
		self:OnSpellStart()
		self:UseResources( true, false, true )
	end)
	self.ability = caster:FindAbilityByName("earthshaker_enchant_totem_lua")
	if caster:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * caster:GetCooldownReduction())
				end

	return true
	
end
function earthshaker_enchant_totem_lua:OnAbilityPhaseInterrupted()
	self.interrupted = true
end
--------------------------------------------------------------------------------
-- Ability Start
function earthshaker_enchant_totem_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetDuration()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor( "max_damage" )
	local stun_duration = self:GetSpecialValueFor("stun")+self:GetCaster():FindTalentValue("special_bonus_ikki_25")
	
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- for each caught enemies
	for _,enemy in pairs(enemies) do
		-- Apply Damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- Apply stun debuff
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_generic_stunned_lua", { duration = stun_duration } )
	end


	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_earthshaker_enchant_totem_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- Effects
	local sound_cast = "ikki.tsunou"
	EmitSoundOn( sound_cast, caster )
	self:PlayEffects()
end
function earthshaker_enchant_totem_lua:PlayEffects()
	-- get particles
	local particle_cast = "particles/centaur_warstomp1.vpcf"
	local sound_cast = "Hero_Centaur.HoofStomp"

	-- get data
	local radius = self:GetSpecialValueFor("radius")


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hoof_L",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hoof_R",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
--
modifier_earthshaker_enchant_totem_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_enchant_totem_lua:IsHidden()
	return false
end

function modifier_earthshaker_enchant_totem_lua:IsDebuff()
	return false
end

function modifier_earthshaker_enchant_totem_lua:IsPurgable()
	return true
end
function modifier_earthshaker_enchant_totem_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_enchant_totem_lua:OnCreated( kv, hTarget, vLocation )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "totem_damage_percentage" ) -- special value
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" ) -- special value
	if IsServer() then
	
		
	end
end


function modifier_earthshaker_enchant_totem_lua:OnRefresh( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "totem_damage_percentage" ) -- special value
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" ) -- special value
end

function modifier_earthshaker_enchant_totem_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_earthshaker_enchant_totem_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end

function modifier_earthshaker_enchant_totem_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus
end

function modifier_earthshaker_enchant_totem_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- effects
		local sound_cast = "ikki.tsunou"
		EmitSoundOn( sound_cast, params.target )

		self:Destroy()
	end
end

function modifier_earthshaker_enchant_totem_lua:GetModifierAttackRangeBonus()
	return self.range
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_earthshaker_enchant_totem_lua:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_earthshaker_enchant_totem_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_totem" )~=0 then attach = "attach_totem" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end