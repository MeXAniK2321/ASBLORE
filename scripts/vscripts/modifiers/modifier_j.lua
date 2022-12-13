modifier_judgment_hit = class({})

--------------------------------------------------------------------------------

function modifier_judgment_hit:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_judgment_hit:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_judgment_hit:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "strength_damage_scepter" )

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
end

--------------------------------------------------------------------------------

function modifier_judgment_hit:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

--------------------------------------------------------------------------------

function modifier_judgment_hit:OnIntervalThink()
	if IsServer() then
		local flDamage = self.dismember_damage + self:GetCaster():FindTalentValue("special_bonus_vergil_25")
		self:GetCaster():PerformAttack(self:GetParent(), true,
				true,
				true,
				true,
				true,
				false,
				true)

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
		
		
				
	end
	EmitSoundOn( "vergil.3", self:GetParent() )
end

--------------------------------------------------------------------------------

function modifier_judgment_hit:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_judgment_hit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
function modifier_judgment_hit:GetEffectName()
	return "particles/test_hit.vpcf"
end

function modifier_judgment_hit:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_judgment_hit:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
