modifier_juggernaut_blade_dance_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_juggernaut_blade_dance_lua:IsHidden()
	return true
end

function modifier_juggernaut_blade_dance_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_juggernaut_blade_dance_lua:OnCreated( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
end

function modifier_juggernaut_blade_dance_lua:OnRefresh( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
	self.strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_juggernaut_blade_dance_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_juggernaut_blade_dance_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end
function modifier_juggernaut_blade_dance_lua:GetModifierBonusStats_Strength()
	return self.strength
end
function modifier_juggernaut_blade_dance_lua:GetModifierPreAttack_BonusDamage()
	return self.damage
end
function modifier_juggernaut_blade_dance_lua:GetModifierBonusStats_Intellect()
	return self.intellect
end
function modifier_juggernaut_blade_dance_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end

		-- Throw dice
		if RandomInt(0, 100)<self.crit_chance then
		if self:GetAbility():IsFullyCastable() then
		self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor( "cooldown" ))
			self.record = params.record
			return self.crit_mult
		end
	end
end
end
function modifier_juggernaut_blade_dance_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil

			-- Play effects
			local sound_cast = "ikki.tsunou"
			EmitSoundOn( sound_cast, params.target )
		end
	end
end