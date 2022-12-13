modifier_shadow_fiend_necromastery_lua = class({})

--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:IsHidden()
	return false
end

function modifier_shadow_fiend_necromastery_lua:IsDebuff()
	return false
end

function modifier_shadow_fiend_necromastery_lua:IsPurgable()
	return false
end

function modifier_shadow_fiend_necromastery_lua:RemoveOnDeath()
	return false
end
function modifier_shadow_fiend_necromastery_lua:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:OnCreated( kv )
	-- get references
	

	if IsServer() then
		self:SetStackCount(0)
	end
end


--------------------------------------------------------------------------------

function modifier_shadow_fiend_necromastery_lua:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,

	}

	return funcs
end

function modifier_shadow_fiend_necromastery_lua:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
	end
end

function modifier_shadow_fiend_necromastery_lua:KillLogic( params )
      
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
		-- check if it is a hero
		if target:IsRealHero() then
		
		self:AddStack(1)	
		
		
		local stack = self:GetStackCount()
		if stack > 19 then
		
		
	if self:GetParent():HasModifier( "modifier_rumia_awake" ) or self:GetParent():HasModifier( "modifier_rumia_ex2" ) then
	
	else
	
	
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_rumia_awake", -- modifier name
		{} -- kv
	)
	EmitSoundOn("rumia.awake", self:GetParent())
	self:PlayEffects()
		
		end
		elseif stack < 19 and stack > 9 then
		if self:GetParent():HasModifier( "modifier_rumia_pre_awaken" ) then
		else
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_rumia_pre_awaken", -- modifier name
		{} -- kv
	)
		
		end
		end

		end
	end
	end

function modifier_shadow_fiend_necromastery_lua:AddStack( value )
	local current = self:GetStackCount()
	self.soul_max = 20
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

function modifier_shadow_fiend_necromastery_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/rumia_ex_awake.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end

