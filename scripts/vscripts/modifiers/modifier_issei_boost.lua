modifier_issei_boost = class({})

--------------------------------------------------------------------------------

function modifier_issei_boost:IsDebuff()
	return false
end
function modifier_issei_boost:IsPurgable() return false end
--------------------------------------------------------------------------------
function modifier_issei_boost:RemoveOnDeath() return false end
function modifier_issei_boost:OnCreated( kv )

	

	self.attack = self:GetAbility():GetSpecialValueFor("attack")
	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed") 


	-- Increase stack

	if IsServer() then
		self:SetStackCount(1)
	end
	self:AddEffects()
end

function modifier_issei_boost:OnRefresh( kv )
	-- references
	self.attack = self:GetAbility():GetSpecialValueFor("attack")
	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
	local max_stack = 30

	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
	end
	self:AddEffects()
end


--------------------------------------------------------------------------------

function modifier_issei_boost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------
function modifier_issei_boost:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
		self:KillLogic( params )
		
	end
end
function modifier_issei_boost:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent() and params.reincarnate==false then
		pass = true
	end

	-- logic
	if pass then
	local stack = self:GetStackCount()
	if stack  < 1 then 
	else
	local new = stack - 2
	self:SetStackCount(new)
		
		end
	end
end
function modifier_issei_boost:KillLogic( params )
      
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
		
		local stack = self:GetStackCount()
	if stack > 29 then 
	else
	local new = stack + 1
	self:SetStackCount(new)
self:AddEffects()		
		
		end
		end
		end
	end
function modifier_issei_boost:GetModifierAttackSpeedBonus_Constant()
  
	return self.attack_speed * self:GetStackCount()
end

function modifier_issei_boost:GetModifierBaseAttack_BonusDamage()
  
	return self.attack * self:GetStackCount()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_issei_boost:AddEffects()
	-- get resources
	local particle_buff = "particles/issei_boost.vpcf"

	-- Create particle
	self.effect_cast = ParticleManager:CreateParticle( particle_buff, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	
	
	-- Apply particle
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end



modifier_juggernaut_drive_unlocked = class({})

--------------------------------------------------------------------------------

function modifier_juggernaut_drive_unlocked:IsHidden()
	return false
end

function modifier_juggernaut_drive_unlocked:IsDebuff()
	return false
end

function modifier_juggernaut_drive_unlocked:IsPurgable()
	return false
end

function modifier_juggernaut_drive_unlocked:RemoveOnDeath()
	return false
end
function modifier_juggernaut_drive_unlocked:AllowIllusionDuplicate()
 return false 
 end
