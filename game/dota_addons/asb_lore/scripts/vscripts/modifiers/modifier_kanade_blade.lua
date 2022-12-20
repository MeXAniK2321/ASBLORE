modifier_kanade_blade = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_kanade_blade:IsHidden()
	return true
end

function modifier_kanade_blade:IsDebuff()
	return false
end

function modifier_kanade_blade:IsPurgable()
	return false
end
function modifier_kanade_blade:AllowIllusionDuplicate() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_kanade_blade:OnCreated( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )+ self:GetParent():FindTalentValue("special_bonus_kanade_25")
end

function modifier_kanade_blade:OnRefresh( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )+ self:GetParent():FindTalentValue("special_bonus_kanade_25")	
end

function modifier_kanade_blade:OnRemoved()
end

function modifier_kanade_blade:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_kanade_blade:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
		
	}

	return funcs
end

function modifier_kanade_blade:OnAttackLanded(params)
	if IsServer() then
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
	if self:GetParent():IsRealHero() then
	if self:GetAbility():IsFullyCastable() then
	self.crit_chance = self:GetAbility():GetSpecialValueFor("chance")
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			local damage = self:GetCaster():GetAttackDamage()
			local damageTable = {
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		self:GetParent():EmitSound("kanade.blade_sfx")
		self.ability = self:GetAbility()
		local cd = self:GetAbility():GetSpecialValueFor("cooldown")
		self.ability:StartCooldown(cd)
			end
		end
	end
	end
end
end
end
end
function modifier_kanade_blade:GetAttackSound()
return "kanade.attack"
	
end

