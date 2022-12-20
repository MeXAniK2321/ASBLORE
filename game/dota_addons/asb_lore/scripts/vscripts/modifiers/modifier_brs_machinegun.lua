modifier_brs_machinegun = class({})

--------------------------------------------------------------------------------

function modifier_brs_machinegun:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_brs_machinegun:OnCreated( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.max_attacks = self:GetAbility():GetSpecialValueFor("max_attacks")

	-- Increase stack

	if IsServer() then
		self:SetStackCount(self.max_attacks)

		self:AddEffects()
	end
end

function modifier_brs_machinegun:OnRefresh( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.max_attacks = self:GetAbility():GetSpecialValueFor("max_attacks")

	-- Increase stack
	if IsServer() then
		self:SetStackCount(self.max_attacks)
	end
end

function modifier_brs_machinegun:OnDestroy( kv )
	if IsServer() then
		self:RemoveEffects()
	end
end
--------------------------------------------------------------------------------

function modifier_brs_machinegun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_brs_machinegun:GetModifierBaseAttack_BonusDamage()
    return -100
end
function modifier_brs_machinegun:GetModifierAttackSpeedBonus_Constant()
    return 300
end

function modifier_brs_machinegun:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- decrement stack
		self:DecrementStackCount()

		-- destroy if reach zero
		if self:GetStackCount() < 1 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_brs_machinegun:AddEffects()
	-- get resources
	local particle_buff = "particles/econ/events/ti10/agh_aura_03_shape.vpcf"

	-- Create particle
	self.effect_cast = ParticleManager:CreateParticle( particle_buff, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	
	
	-- Apply particle
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end

function modifier_brs_machinegun:RemoveEffects()
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end