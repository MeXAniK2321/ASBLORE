modifier_bookmaker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bookmaker:IsHidden()
	return false
end

function modifier_bookmaker:IsDebuff()
	return true
end

function modifier_bookmaker:IsPurgable()
	return false
end
function modifier_bookmaker:AllowIllusionDuplicate() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_bookmaker:OnCreated( kv )
	-- references
	self.chance1 = 40
	self.chance2 = 40
	self.chance3 = 100
	self.damage = 400
	self.damage1 = 600
	self.damage2 = 800
	self.duration = 1.5
	self.duration2 = 1
	
	self:StartIntervalThink( 3.3 )
end

function modifier_bookmaker:OnRefresh( kv )
	-- references
	self.chance1 = 40
	self.chance2 = 40
	self.chance3 = 100
	self.damage = 400
	self.damage1 = 600
	self.damage2 = 800
	self.duration = 1.5
	self.duration2 = 1
	
end

function modifier_bookmaker:OnRemoved()
end

function modifier_bookmaker:OnDestroy()
end
function modifier_bookmaker:OnIntervalThink()
    local caster =self:GetCaster()
	local parent = self:GetParent()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	if RollPercentage(self.chance1) then
	local damage = self.damage
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	parent:AddNewModifier(caster, self, "modifier_generic_stunned_lua", {duration = self.duration})
	damageTable.victim = self:GetParent()
		ApplyDamage(damageTable)
		self:PlayEffects()
		
    elseif RollPercentage(self.chance2) then
	local damage = self.damage1
	parent:AddNewModifier(caster, self, "modifier_generic_stunned_lua", {duration = self.duration2})
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	damageTable.victim = self:GetParent()
		ApplyDamage(damageTable)
		self:PlayEffects2()
	
		elseif RollPercentage(self.chance3) then
		local damage = self.damage2
	parent:AddNewModifier(caster, self, "modifier_root", {duration = self.duration2})
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	damageTable.victim = self:GetParent()
		ApplyDamage(damageTable)
		self:PlayEffects3()
		
		else
		end
	
end

function modifier_bookmaker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/good_loser_debuff1.vpcf"
	local sound_cast = "kumagawa.fall"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_bookmaker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/good_loser_debuff2.vpcf"
	local sound_cast = "kumagawa.hitted"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_bookmaker:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/kinton_lightning.vpcf"
	local sound_cast = "kumagawa.lightning"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

