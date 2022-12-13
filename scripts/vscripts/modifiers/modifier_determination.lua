modifier_determination = class({})

--------------------------------------------------------------------------------

function modifier_determination:IsHidden()
	return false
end

function modifier_determination:IsDebuff()
	return false
end

function modifier_determination:IsPurgable()
	return false
end

function modifier_determination:RemoveOnDeath()
	return false
end
function modifier_determination:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_determination:OnCreated( kv )
	-- get references
	
    self.bonus_evasion = self:GetAbility():GetSpecialValueFor("miss")

	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_determination:OnRefresh( kv )

    self.bonus_evasion = self:GetAbility():GetSpecialValueFor("miss")
end

--------------------------------------------------------------------------------

function modifier_determination:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end
function modifier_determination:GetModifierEvasion_Constant()
	if not self:GetParent():PassivesDisabled() then
		return self.bonus_evasion
	end
end
function modifier_determination:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
	end
end

function modifier_determination:KillLogic( params )
      
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
		if not self:GetParent():HasModifier( "modifier_little_devil" ) or self:GetParent():HasModifier("modifier_little_nightmare") then
			self:AddStack(1)
		end
		end
		
		
		
		
		local stack = self:GetStackCount()
		if stack > 8 then
		if self:GetCaster():HasModifier( "modifier_pacifist" ) then
			self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_storyshift", -- modifier name
		{} -- kv
	)
		elseif self:GetParent():HasModifier( "modifier_genocide" ) and not self:GetParent():HasModifier( "modifier_genocide_complited" ) then
		
		if stack > 9 then
	    self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_genocide_complited", -- modifier name
		{} -- kv
	)
	EmitSoundOn("chara.true_appearance", self:GetParent())
	local radius = 1000
	self:PlayEffects(radius)
	end
	else
	if not self:GetParent():HasModifier( "modifier_genocide" ) then
	
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_genocide", -- modifier name
		{} -- kv
	)
	self:SetStackCount(0)
		
		
		end
		end
		end
	
		
		
		

		
	end
end

function modifier_determination:AddStack( value )
   if self:GetParent():HasModifier( "modifier_genocide" ) and self:GetParent():HasScepter() then
    
   self.soul_max = 10
   else
   self.soul_max = self:GetAbility():GetSpecialValueFor("soul_max")
   end
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

function modifier_determination:PlayEffects( radius )

	local particle_cast = "particles/chara_true_genocide.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end