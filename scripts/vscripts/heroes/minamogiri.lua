minamogiri = class({})
LinkLuaModifier( "modifier_minamogiri", "heroes/minamogiri", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function minamogiri:GetIntrinsicModifierName()
	return "modifier_minamogiri"
end



modifier_minamogiri = class({})

--------------------------------------------------------------------------------

function modifier_minamogiri:IsHidden()
	return false
end

function modifier_minamogiri:IsDebuff()
	return false
end

function modifier_minamogiri:IsPurgable()
	return false
end

function modifier_minamogiri:RemoveOnDeath()
	return false
end
function modifier_minamogiri:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_minamogiri:OnCreated( kv )
	-- get references

    self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" ) 




end

function modifier_minamogiri:OnRefresh( kv )
	-- get references
	
    self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_bonus = 100

end

--------------------------------------------------------------------------------

function modifier_minamogiri:DeclareFunctions()
	local funcs = {

	
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
	}

	return funcs
end
function modifier_minamogiri:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 25
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			if self:GetAbility():IsFullyCastable() then
			local damage  = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_tanjiro_25") 
			local cooldown  = self:GetAbility():GetSpecialValueFor( "cooldown" ) 
			local damageTable = {
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
	self.target = params.target
		ApplyDamage(damageTable)
		self:PlayEffects()
		self.ability = self:GetAbility()
		self.ability:StartCooldown(cooldown)
			end
		end
	end
	end
end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_minamogiri:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/cull3.vpcf"
	local sound_cast = "tanjiro.6"
     local target = self.target

	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end