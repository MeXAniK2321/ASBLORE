modifier_horn_6 = class({})

function modifier_horn_6:IsHidden()
	return false
end
function modifier_horn_6:RemoveOnDeath() return false end
function modifier_horn_6:AllowIllusionDuplicate()
	return false
end

function modifier_horn_6:IsPurgable()
    return false
end
function modifier_horn_6:OnCreated(table)
local interval = 1
self:StartIntervalThink( interval )
end
function modifier_horn_6:OnIntervalThink()
self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	-- update damage
	self.damageTable.damage = 3/100*self:GetParent():GetHealth()

	-- apply damage
	ApplyDamage( self.damageTable )
end
function modifier_horn_6:DeclareFunctions()
    local funcs = {
      MODIFIER_PROPERTY_HEALTH_BONUS,
MODIFIER_EVENT_ON_TAKEDAMAGE,	  
		
    }

    return funcs
end
function modifier_horn_6:GetModifierHealthBonus()
return 1500
end
function modifier_horn_6:OnTakeDamage(params)
	if IsServer() then
	local caster = self:GetParent()
		if params.attacker == caster then
		if not params.attacker:IsIllusion() then
		if params.unit == caster then return end
		if self:GetParent():IsAlive() then
		if not params.unit:HasModifier("modifier_fountain_aura_effect_lua") then
		if not self:GetParent():HasModifier("modifier_horn_truth_cd") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_horn_truth_cd", {duration = 3.0 })
		local hp = self:GetParent():GetMaxHealth()
		local damage = hp * 0.05
		local damageTable = {
		victim = params.unit,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, 
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)
	local point = params.unit:GetOrigin()
	local radius = 300
	local debuffDuration = 2
	self:PlayEffects( point, radius, debuffDuration )
	EmitSoundOn("horn.slash", caster)
			end
		end
	end
end
end
end
end
function modifier_horn_6:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/crit_red.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_horn_6:OnDestroy()
	StopGlobalSound("star.horn_6")
	
end
function modifier_horn_6:GetTexture()
	return "note"
end
function modifier_horn_6:GetEffectName()
	return "particles/sacrifice_red.vpcf"
end