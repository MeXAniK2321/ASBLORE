dragon_hit = class({})
LinkLuaModifier( "modifier_generic_orb_effect_lua", "modifiers/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function dragon_hit:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

--------------------------------------------------------------------------------
-- Ability Start
function dragon_hit:OnSpellStart()
end

--------------------------------------------------------------------------------
-- Orb Effects
function dragon_hit:OnOrbImpact( params )
local caster = self:GetCaster()

if self:GetCaster():HasModifier( "modifier_juggernaut_drive" ) or self:GetCaster():HasModifier( "modifier_balance_breaker2" ) then
 local knockback = { should_stun = 1,
                        knockback_duration = 2,
                        duration = 2,
                        knockback_distance = 800,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    params.target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local target = params.target
	self:PlayEffects1()
		    local hero_damage = caster:GetBaseDamageMax()
		local mult = self:GetSpecialValueFor("crit_damage")
		local hero_damage2 = hero_damage * 6
		local damage  = self:GetSpecialValueFor("damage") + hero_damage2 + self:GetCaster():FindTalentValue("special_bonus_issei_25")
	 local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}	

damageTable.victim = params.target
		ApplyDamage(damageTable)
		EmitSoundOn("issei.7", caster)
		EmitSoundOn("issei.7_1", caster)
else
	 local knockback = { should_stun = 0,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 350,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    params.target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local target = params.target
	self:PlayEffects()
		    local hero_damage = caster:GetBaseDamageMax()
		local mult = self:GetSpecialValueFor("crit_damage")
		local hero_damage2 = hero_damage * mult
		local damage  = self:GetSpecialValueFor("damage") + hero_damage2 + self:GetCaster():FindTalentValue("special_bonus_issei_25")
	 local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}	

damageTable.victim = params.target
		ApplyDamage(damageTable)
		EmitSoundOn("issei.8", caster)
		EmitSoundOn("issei.7_1", caster)
	end
	
end

function dragon_hit:PlayEffects()
	-- Load effects
	local particle_cast = "particles/issei_dragon_hit.vpcf"
	local caster = self:GetCaster()



	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		caster:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end

function dragon_hit:PlayEffects1()
	-- Load effects
	local particle_cast = "particles/issei_dragon_hit_balance_breaker2.vpcf"
	local caster = self:GetCaster()



	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		caster:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end