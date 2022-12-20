modifier_rip_and_tear = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rip_and_tear:IsHidden()
	-- actual true
	return true
end

function modifier_rip_and_tear:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rip_and_tear:OnCreated( kv )
	-- references
	
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" ) 
	self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" )+ self:GetCaster():FindTalentValue("special_bonus_frisk_25")
	
end

function modifier_rip_and_tear:OnRefresh( kv )
	-- references
	
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" ) + self:GetCaster():FindTalentValue("special_bonus_frisk_25")
	
end

function modifier_rip_and_tear:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_rip_and_tear:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

function modifier_rip_and_tear:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if self:RollChance( self.crit_chance ) then
		if self:GetParent():HasModifier( "modifier_genocide" ) then
		local ability = self:GetParent():FindAbilityByName("determination")
		if ability:IsFullyCastable() then
			self.record = params.record
			local target = params.target
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_rip_and_tear_blood", {duration = 3.0 + self:GetCaster():FindTalentValue("special_bonus_frisk_25")})
			ability:StartCooldown(2)
			return self.crit_bonus
			else
			end
		end
	end
	end
end

function modifier_rip_and_tear:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end
--------------------------------------------------------------------------------
-- Helper
function modifier_rip_and_tear:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_rip_and_tear:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local sound_cast = "Hero_PhantomAssassin.CoupDeGrace"


	
	
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
