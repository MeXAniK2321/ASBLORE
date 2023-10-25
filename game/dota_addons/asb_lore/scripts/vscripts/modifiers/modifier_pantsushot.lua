modifier_pantsushot = modifier_pantsushot or class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_pantsushot:IsHidden() return false end
function modifier_pantsushot:IsPurgable() return false end
function modifier_pantsushot:AllowIllusionDuplicate() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_pantsushot:OnCreated( kv )
	-- references
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" )
	self.cooldown = self:GetAbility():GetSpecialValueFor( "cooldown" )
end
function modifier_pantsushot:OnRefresh( kv )
    self:OnCreated( kv )
end
function modifier_pantsushot:OnDestroy( kv )
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_pantsushot:DeclareFunctions()
	local funcs = {
		              MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		              MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		              MODIFIER_EVENT_ON_ATTACK_LANDED,
		              MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
                      MODIFIER_EVENT_ON_TAKEDAMAGE,
	              }

	return funcs
end
function modifier_pantsushot:GetModifierBaseAttackTimeConstant()
	return 1.7
end
function modifier_pantsushot:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self.parent:PassivesDisabled()) then
	    if self.ability:IsFullyCastable() then
		    if self:RollChance( self.crit_chance ) and ( not self.parent:IsIllusion() ) then
			    self.record = params.record
			    self.ability:StartCooldown(self.cooldown)
			    params.target:AddNewModifier(self.caster, self.ability, "modifier_generic_stunned_lua", {duration = 0.3})
			
			    return self.crit_bonus
		   end
	    end
    end
end
function modifier_pantsushot:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end
function modifier_pantsushot:OnTakeDamage(keys)
	if IsServer() and IsASBPatreon(self.parent) then
       if keys.unit == self.parent and keys.attacker ~= self.parent and keys.inflictor ~= self.ability then 
	     local Emit = self:RollChance(25) 
		       and EmitSoundOn("miku.kizuna_ai.3_"..RandomInt(2, 4), self.parent)
			   or nil
	   end
    end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_pantsushot:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_pantsushot:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/miku_huya.vpcf"
	local sound_cast = "miku.2"

	-- if target:IsMechanical() then
	-- 	particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
	-- 	sound_cast = "Hero_PhantomAssassin.CoupDeGrace.Mech"
	-- end

	-- Create Particle
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