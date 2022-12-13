modifier_subaru_suffering = class({})

--------------------------------------------------------------------------------

function modifier_subaru_suffering:IsHidden()
	return false
end

function modifier_subaru_suffering:IsDebuff()
	return false
end

function modifier_subaru_suffering:IsPurgable()
	return false
end

function modifier_subaru_suffering:RemoveOnDeath()
	return false
end
function modifier_subaru_suffering:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_subaru_suffering:OnCreated( kv )
	-- get references
	self.soul_max = self:GetAbility():GetSpecialValueFor("soul_max")
	self.soul_max_scepter = self:GetAbility():GetSpecialValueFor("soul_max_scepter")
	self.soul_release = self:GetAbility():GetSpecialValueFor("soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")+self:GetCaster():FindTalentValue("special_bonus_rumia_25")
	self.soul_hero_bonus = self:GetAbility():GetSpecialValueFor("soul_hero_bonus")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_range = self:GetAbility():GetSpecialValueFor("attack_range")

	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_subaru_suffering:OnRefresh( kv )
	-- get references
	self.soul_max = self:GetAbility():GetSpecialValueFor("soul_max")
	self.soul_max_scepter = self:GetAbility():GetSpecialValueFor("soul_max_scepter")
	self.soul_release = self:GetAbility():GetSpecialValueFor("soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("soul_damage")+self:GetCaster():FindTalentValue("special_bonus_rumia_25")
	self.soul_hero_bonus = self:GetAbility():GetSpecialValueFor("soul_hero_bonus")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_range = self:GetAbility():GetSpecialValueFor("attack_range")
end

--------------------------------------------------------------------------------

function modifier_subaru_suffering:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
       MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end
function modifier_subaru_suffering:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
	end
end

--------------------------------------------------------------------------------


function modifier_subaru_suffering:GetModifierBonusStats_Strength( params )
	if not self:GetParent():IsIllusion() then
		local max_stack = self.soul_max
		
			return math.min(self.soul_max,self:GetStackCount()) * self.soul_damage
		end
	end

function modifier_subaru_suffering:GetModifierSpellAmplify_Percentage( params )
	if not self:GetParent():IsIllusion() then
		local max_stack = self.soul_max
		
			return math.min(self.soul_max,self:GetStackCount()) * self.soul_damage
		end
	end




--------------------------------------------------------------------------------


function modifier_subaru_suffering:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end

	-- logic
	if pass then
		self:AddStack(1)
	end
end

function modifier_subaru_suffering:AddStack( value )
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

function modifier_subaru_suffering:PlayEffects( target )
	-- Get Resources
	local projectile_name = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"

	-- CreateProjectile
	local info = {
		Target = self:GetParent(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 400,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end