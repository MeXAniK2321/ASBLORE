modifier_demon_lord_seed = class({})

--------------------------------------------------------------------------------

function modifier_demon_lord_seed:IsHidden()
	return false
end

function modifier_demon_lord_seed:IsDebuff()
	return false
end

function modifier_demon_lord_seed:IsPurgable()
	return false
end

function modifier_demon_lord_seed:RemoveOnDeath()
	return false
end
function modifier_demon_lord_seed:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_demon_lord_seed:OnCreated( kv )
	-- get references
	self.soul_max = 15
    self.bonus_evasion = self:GetAbility():GetSpecialValueFor("miss")

	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_demon_lord_seed:OnRefresh( kv )
	-- get references
	self.soul_max = 15
    self.bonus_evasion = self:GetAbility():GetSpecialValueFor("miss")
end

--------------------------------------------------------------------------------

function modifier_demon_lord_seed:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

function modifier_demon_lord_seed:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
	end
end

function modifier_demon_lord_seed:KillLogic( params )
      
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
			self:AddStack(1)
		end
		
		
		
		
		local stack = self:GetStackCount()
		if stack == 15 then
		
	if self:GetParent():HasModifier( "modifier_demon_lord_awake_started" ) or self:GetParent():HasModifier( "modifier_rimuru_harvest_begin" )  then
	else
	EmitSoundOn("rimuru.10", self:GetParent())
	
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_demon_lord_awake_started", -- modifier name
		{} -- kv
	)
	self:GetParent():RemoveModifierByName("modifier_demon_lord_seed")
		
		end
		end
		end
	
		
		
		

		
	end


function modifier_demon_lord_seed:AddStack( value )
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

