modifier_taboo_eternal_hunting = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_taboo_eternal_hunting:IsHidden()
	return false
end

function modifier_taboo_eternal_hunting:IsDebuff()
	return true
end

function modifier_taboo_eternal_hunting:IsStunDebuff()
	return false
end

function modifier_taboo_eternal_hunting:IsPurgable()
	return true
end

function modifier_taboo_eternal_hunting:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_taboo_eternal_hunting:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "pop_damage" )
	self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
		if self:GetCaster():HasModifier("modifier_un_owen_was_her") then
 local caster = self:GetCaster()
    local duration = 1.5
    local incoming = 100
    local outgoing = 25
    local clones = 1 



    for i = 1,clones do
        local clone = CreateIllusionForPlayer(caster, caster, caster, self, self:GetParent():GetAbsOrigin() + RandomVector(100), duration, 1, incoming, outgoing)
    end
end
end

function modifier_taboo_eternal_hunting:OnRefresh( kv )
	
end  

function modifier_taboo_eternal_hunting:OnRemoved()
end

function modifier_taboo_eternal_hunting:OnDestroy()
	if not IsServer() then return end

    if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),			--Optional.
	}
	ApplyDamage(damageTable)
	else
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),			--Optional.
	}
	ApplyDamage(damageTable)
	end

	EmitSoundOn("flandr.4_1", self:GetParent() )
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_taboo_eternal_hunting:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_taboo_eternal_hunting:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_taboo_eternal_hunting:GetEffectName()
	return "particles/void_spirit_astral_step_debuff1.vpcf"
end

function modifier_taboo_eternal_hunting:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_taboo_eternal_hunting:GetStatusEffectName()
	return "particles/void_spirit_astral_step_debuff1.vpcf"
end

function modifier_taboo_eternal_hunting:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_taboo_eternal_hunting:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/taboo_eternal_hunting_blood.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end