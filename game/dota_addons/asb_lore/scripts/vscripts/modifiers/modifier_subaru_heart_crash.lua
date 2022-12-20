modifier_subaru_heart_crash = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_subaru_heart_crash:IsHidden()
	return false
end

function modifier_subaru_heart_crash:IsDebuff()
	return true
end

function modifier_subaru_heart_crash:IsStunDebuff()
	return false
end

function modifier_subaru_heart_crash:IsPurgable()
	return true
end

function modifier_subaru_heart_crash:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_subaru_heart_crash:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_subaru_heart_crash:OnRefresh( kv )
	
end

function modifier_subaru_heart_crash:OnRemoved()
end

function modifier_subaru_heart_crash:OnDestroy()
	if not IsServer() then return end

    if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	else
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	end

	-- play effects
	self:PlayEffects()
	
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_subaru_heart_crash:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_subaru_heart_crash:GetEffectName()
	return ""
end

function modifier_subaru_heart_crash:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_subaru_heart_crash:GetStatusEffectName()
	return ""
end

function modifier_subaru_heart_crash:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_subaru_heart_crash:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/chara_blood2.vpcf"
	local sound_target = "subaru.heart"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
function modifier_subaru_heart_crash:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/test222.vpcf"
	local sound_target = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
function modifier_subaru_heart_crash:PlayEffects2( )
	-- Get Resources
	local particle_cast = "particles/satella_death_screen.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end