modifier_hand_sonic = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hand_sonic:IsHidden()
	return true
end

function modifier_hand_sonic:IsDebuff()
	return false
end

function modifier_hand_sonic:IsPurgable()
	return false
end
function modifier_hand_sonic:AllowIllusionDuplicate() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_hand_sonic:OnCreated( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )+ self:GetParent():FindTalentValue("special_bonus_kanade_25")
end

function modifier_hand_sonic:OnRefresh( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )+ self:GetParent():FindTalentValue("special_bonus_kanade_25")	
end

function modifier_hand_sonic:OnRemoved()
end

function modifier_hand_sonic:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_hand_sonic:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
		
	}

	return funcs
end

function modifier_hand_sonic:OnAttackLanded(params)
	if IsServer() then
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
	if self:GetParent():IsRealHero() then
	if self:GetAbility():IsFullyCastable() then
	self.crit_chance = self:GetAbility():GetSpecialValueFor("chance")
	   if self:GetCaster():HasModifier("modifier_kanade_wings") then
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
		local caster = self:GetCaster()
    local duration = 2.5
    local incoming = 250
    local outgoing = 60
    local clones = 1 
    local target = params.target


    for i = 1,clones do
        local clone = CreateIllusionForPlayer(caster, caster, caster, self, target:GetAbsOrigin() + RandomVector(100), duration, 1, incoming, outgoing)
    end
		local cd = self:GetAbility():GetSpecialValueFor("cooldown")
		self.ability = self:GetAbility()
		self.ability:StartCooldown(cd)
			end
		end
	end
	end
end
end
end
end
end
