modifier_good_loser = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_good_loser:IsHidden()
	return true
end

function modifier_good_loser:IsDebuff()
	return false
end

function modifier_good_loser:IsPurgable()
	return false
end
function modifier_good_loser:AllowIllusionDuplicate() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_good_loser:OnCreated( kv )
	-- references
	self.chance1 = 25
	self.chance2 = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.chance3 = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration1" )
	self.duration2 = self:GetAbility():GetSpecialValueFor( "duration2" )
	
	self:StartIntervalThink( 10 )
end

function modifier_good_loser:OnRefresh( kv )
	-- references
	self.chance1 = 25
	self.chance2 = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.chance3 = self:GetAbility():GetSpecialValueFor( "crit_chance" ) 
	self.duration = self:GetAbility():GetSpecialValueFor( "duration1" )
	self.duration2 = self:GetAbility():GetSpecialValueFor( "duration2" )
	
end

function modifier_good_loser:OnRemoved()
end

function modifier_good_loser:OnDestroy()
end
function modifier_good_loser:OnIntervalThink()
	local caster = self:GetParent()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	if self:GetAbility():IsFullyCastable() then
	if not self:GetCaster():HasModifier("modifier_all_fiction") then
	if RollPercentage(self.chance1) then
	local damage = self:GetParent():GetHealth() * 0.35
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,			--Optional.
	}
	caster:AddNewModifier(caster, self, "modifier_generic_stunned_lua", {duration = self.duration})
	damageTable.victim = self:GetParent()
		ApplyDamage(damageTable)
		self:PlayEffects()
		self.ability:StartCooldown(self.ability:GetCooldown(-1))
    elseif RollPercentage(self.chance2) then
	local damage = self:GetParent():GetHealth() * 0.2
	caster:AddNewModifier(caster, self, "modifier_generic_stunned_lua", {duration = self.duration2})
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,			--Optional.
	}
	damageTable.victim = self:GetParent()
		ApplyDamage(damageTable)
		self:PlayEffects2()
		self.ability:StartCooldown(self.ability:GetCooldown(-1))
		elseif RollPercentage(self.chance3) then
		local damage = self:GetParent():GetHealth() * 0.2
	caster:AddNewModifier(caster, self, "modifier_root", {duration = self.duration2})
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,			--Optional.
	}
	damageTable.victim = self:GetParent()
		ApplyDamage(damageTable)
		self:PlayEffects3()
		self.ability:StartCooldown(self.ability:GetCooldown(-1))
		else
		end
	
end
end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_good_loser:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_MODEL_SCALE,
		
	}

	return funcs
end
function modifier_good_loser:GetModifierModelScale()
	return 10
end


function modifier_good_loser:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/good_loser_debuff1.vpcf"
	local sound_cast = "kumagawa.fall"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOn( sound_cast, self:GetParent() )
	local sound_cast2 = "kumagawa.2_1"
	EmitSoundOn( sound_cast2, self:GetParent() )
end
function modifier_good_loser:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/good_loser_debuff2.vpcf"
	local sound_cast = "kumagawa.hitted"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
	local sound_cast2 = "kumagawa.2_1"
	EmitSoundOn( sound_cast2, self:GetParent() )
end
function modifier_good_loser:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/kinton_lightning.vpcf"
	local sound_cast = "kumagawa.lightning"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
	local sound_cast2 = "kumagawa.2_1"
	EmitSoundOn( sound_cast2, self:GetParent() )
end

