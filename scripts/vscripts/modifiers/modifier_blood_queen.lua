modifier_blood_queen = class({})

--------------------------------------------------------------------------------

function modifier_blood_queen:IsHidden()
	return false
end

function modifier_blood_queen:IsDebuff()
	return false
end

function modifier_blood_queen:IsPurgable()
	return false
end

function modifier_blood_queen:RemoveOnDeath()
	return false
end
function modifier_blood_queen:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_blood_queen:OnCreated( kv )
	-- get references
	self.soul_max = self:GetAbility():GetSpecialValueFor("soul_max")
    self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" ) + self:GetCaster():FindTalentValue("special_bonus_flandr_25")
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" ) 
	self.crit_bonus = 100

	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_blood_queen:OnRefresh( kv )
	-- get references
	self.soul_max = self:GetAbility():GetSpecialValueFor("soul_max")
    self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_bonus = 100
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

--------------------------------------------------------------------------------

function modifier_blood_queen:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
				MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return funcs
end

function modifier_blood_queen:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_blood_queen:OnTakeDamage(params)
	if IsServer() then
	local caster = self:GetParent()
	if self:GetAbility():IsFullyCastable() then
		if params.attacker == caster then
		if not params.attacker:IsIllusion() then
		if params.unit == caster then return end
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local cooldown = self:GetAbility():GetSpecialValueFor("cooldown")+ self:GetCaster():FindTalentValue("special_bonus_flandr_25")
		local duration = self:GetAbility():GetSpecialValueFor("duration")
			self:GetAbility():StartCooldown(cooldown)
	params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_rip_and_tear_blood", {duration = duration })
	self:PlayEffects( params.unit )
			end
		end
	end
end
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_blood_queen:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local sound_cast = "flandr.crit"


	
	
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
function modifier_blood_queen:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
	end
end

function modifier_blood_queen:KillLogic( params )
      
	local target = params.unit
	local attacker = params.attacker
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

	-- logic
	if pass and (not self:GetParent():PassivesDisabled()) then
		self:AddStack(0)
		-- check if it is a hero
		if target:IsRealHero() then
		if self:GetParent():HasModifier("modifier_item_ultimate_scepter") then
			self:AddStack(1)
			end
		end
		
		
		
		
		local stack = self:GetStackCount()
		if stack > 7 then
		
		
	if self:GetParent():HasModifier( "modifier_nightmare" ) then
	
	else
	
	
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_nightmare", -- modifier name
		{} -- kv
	)
		
		end
		end
		
	
		
		
		

		end
	end

function modifier_blood_queen:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
	if not self:GetParent():HasScepter() then
		if after > self.soul_max then
			after = self.soul_max
		end
	else
		if after > self.soul_max then
			after = self.soul_max
		end
	end
	self:SetStackCount( after )
end

