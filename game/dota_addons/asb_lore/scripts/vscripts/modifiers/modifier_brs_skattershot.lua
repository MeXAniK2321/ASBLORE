modifier_brs_skattershot = class({})

--------------------------------------------------------------------------------

function modifier_brs_skattershot:IsHidden()
	return false
end

function modifier_brs_skattershot:IsDebuff()
	return false
end

function modifier_brs_skattershot:IsPurgable()
	return false
end

function modifier_brs_skattershot:RemoveOnDeath()
	return false
end
function modifier_brs_skattershot:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_brs_skattershot:OnCreated( kv )
	-- get references

    self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" ) 




end

function modifier_brs_skattershot:OnRefresh( kv )
	-- get references
	
    self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_bonus = 100

end

--------------------------------------------------------------------------------

function modifier_brs_skattershot:DeclareFunctions()
	local funcs = {

	
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end
function modifier_brs_skattershot:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
	if self:GetParent():IsRealHero() then
		if self:RollChance( self.crit_chance ) then
	     if self:GetAbility():IsFullyCastable() then
			self.record = params.record
			local target = params.target
			self.ability = self:GetAbility()
  
    
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_brs_skattershot_exp", {duration = 0.1 })
			self.ability:StartCooldown(1)
			return self.crit_bonus
			else
			end
		end
	end
	end
end

function modifier_brs_skattershot:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end
--------------------------------------------------------------------------------
-- Helper
function modifier_brs_skattershot:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_brs_skattershot:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/skatter_exp.vpcf"
	local sound_cast = "brs.shot"


	
	
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

