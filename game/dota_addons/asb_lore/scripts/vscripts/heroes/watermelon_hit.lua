watermelon_hit = class({})
LinkLuaModifier( "modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_watermelon_hit_damage", "modifiers/modifier_watermelon_hit_damage", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function watermelon_hit:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()



if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "crit_mult" )
	local duration = self:GetSpecialValueFor( "stun_duration" )
    
	-- damage
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_watermelon_hit_damage", -- modifier name
		{  } -- kv
	)
	
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
		--Optional.
	}
	ApplyDamage(damageTable)
 


	target:AddNewModifier(caster, self, "modifier_root", {duration = duration})
	
	
	self:PlayEffects(target)
	buff:Destroy()
	EmitSoundOn("ikaros.4", caster)
end
function watermelon_hit:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/watermelon_hit.vpcf"
	local sound_cast = ""

	-- Get Data
	local forward = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
	ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end