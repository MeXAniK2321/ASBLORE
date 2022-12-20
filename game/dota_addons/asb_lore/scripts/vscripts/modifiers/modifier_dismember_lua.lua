modifier_dismember_lua = class({})

--------------------------------------------------------------------------------

function modifier_dismember_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_dismember_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_dismember_lua:OnCreated( kv )
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

function modifier_dismember_lua:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
		self.damage2 = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = 2500,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility()
		}

		ApplyDamage( self.damage2 )
		EmitSoundOn( "sword.fight_end", self:GetParent() )
		self:PlayEffects(self:GetParent())
end
function modifier_dismember_lua:PlayEffects(target)
	-- Get Resources
	local particle_cast = "particles/shinobu_kisshot_flash_crit.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end
--------------------------------------------------------------------------------

function modifier_dismember_lua:OnIntervalThink()
	if IsServer() then
		local flDamage = self.dismember_damage
		if self:GetCaster():HasScepter() then
			flDamage = flDamage + ( self:GetCaster():GetStrength() * self.strength_damage_scepter )
			self:GetCaster():Heal( flDamage, self:GetAbility() )
		end

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
	EmitSoundOn( "sword.fight", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_dismember_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_dismember_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
function modifier_dismember_lua:GetEffectName()

	return "particles/kisshot_kill.vpcf"

end


function modifier_dismember_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
--------------------------------------------------------------------------------

function modifier_dismember_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
