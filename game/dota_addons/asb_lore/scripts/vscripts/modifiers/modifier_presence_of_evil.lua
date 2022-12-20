modifier_presence_of_evil = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_presence_of_evil:IsHidden()
	return false
end

function modifier_presence_of_evil:IsDebuff()
	return true
end

function modifier_presence_of_evil:IsStunDebuff()
	return false
end

function modifier_presence_of_evil:IsPurgable()
	return true
end

function modifier_presence_of_evil:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_presence_of_evil:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	
	 local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
        self:PlayEffects1()
		self:PlayEffects2()
end

function modifier_presence_of_evil:OnRefresh( kv )
	
end

function modifier_presence_of_evil:OnRemoved()
end

function modifier_presence_of_evil:OnDestroy()
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
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	end

	 
	
	
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_presence_of_evil:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_presence_of_evil:GetEffectName()
	return ""
end

function modifier_presence_of_evil:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_presence_of_evil:GetStatusEffectName()
	return ""
end

function modifier_presence_of_evil:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end
function modifier_presence_of_evil:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/oooga.vpcf"
	local sound_target = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
function modifier_presence_of_evil:PlayEffects2( )
	-- Get Resources
	local particle_cast = "particles/oogabooga.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	
    EmitSoundOnClient("pikachu.1", Player)

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end