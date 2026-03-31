require("heroes/roland/roland_init")

roland_bleed = class({})

--====================================================================================================--
LinkLuaModifier("modifier_roland_bleed_debuff", "heroes/roland/roland_bleed", LUA_MODIFIER_MOTION_NONE)

modifier_roland_bleed_debuff = class({})

function modifier_roland_bleed_debuff:IsHidden()								return false end
function modifier_roland_bleed_debuff:IsDebuff()								return true end
function modifier_roland_bleed_debuff:IsPurgable()								return true end
function modifier_roland_bleed_debuff:IsPurgeException()						return true end
function modifier_roland_bleed_debuff:RemoveOnDeath()							return true end
function modifier_roland_bleed_debuff:DeclareFunctions()
	local t =
	{
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ATTACK,
	}
	return t
end
function modifier_roland_bleed_debuff:OnAbilityExecuted(keys)
	if keys.unit ~= self.hParent then return end
	if bit.band(keys.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_ATTACK) ~= 0 then return end
	self:ReleaseBleeds(math.ceil(self.nBleedsAbilityPct * #self.tDamageInfo))
end
function modifier_roland_bleed_debuff:OnAttack(keys)
	if keys.attacker ~= self.hParent then return end
	self:ReleaseBleeds(math.ceil(self.nBleedsAttackPct * #self.tDamageInfo))
end
function modifier_roland_bleed_debuff:OnCreated(tInfo)
	self.hCaster  = self:GetCaster()
	self.hParent  = self:GetParent()
	self.hAbility = self:GetAbility()

	if IsNull(self.hAbility) then return end

	self.nBleedsAbilityPct = self.hAbility:GetSpecialValueFor("bleeds_ability_pct") * 0.01
	self.nBleedsAttackPct = self.hAbility:GetSpecialValueFor("bleeds_attack_pct") * 0.01
	self.nBleedsSecondPct = self.hAbility:GetSpecialValueFor("bleeds_second_pct") * 0.01

	self.nBleeds = tInfo.bleeds or 0
	self.nBleedDamage = self.hAbility:GetSpecialValueFor("bleed_damage")

	if not IsServer() then return end

	self.nDamageType = self.hAbility:GetAbilityDamageType()
	self.nDamageFlags = DOTA_DAMAGE_FLAG_NONE

	self.tDamageInfo = self.tDamageInfo or {}

	self:AddBleeds(self.nBleeds)

	if self._bThinking then return end
	self._bThinking = true
	self:StartIntervalThink(1)
end
function modifier_roland_bleed_debuff:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_roland_bleed_debuff:OnRemoved(bDeath)
	if not IsServer() then return end
end
function modifier_roland_bleed_debuff:AddBleeds(nBleeds)
	if nBleeds <= 0 then return end
	for i = 1, nBleeds do
		-- local tDamage =
		-- {
		-- 	victim = self.hParent,
		-- 	attacker = self.hCaster,
		-- 	ability = self.hAbility,
		-- 	damage = self.nBleedDamage,
		-- 	damage_type = self.nDamageType,
		-- 	damage_flags = self.nDamageFlags
		-- }
		table.insert(self.tDamageInfo, self.nBleedDamage)
	end
	self:SetStackCount(#self.tDamageInfo)
end
function modifier_roland_bleed_debuff:ReleaseBleeds(nBleeds)
	if nBleeds <= 0 then return end
	local t = self.tDamageInfo
	local nLen = #t
	if nLen <= 0 then return end
	local nToRemove = math.min(nBleeds, nLen)
	for i = 1, nToRemove do
		local index = #t
		t[index] = nil
	end

	local tDamage =
	{
		victim = self.hParent,
		attacker = self.hCaster,
		ability = self.hAbility,
		damage = self.nBleedDamage * nToRemove,
		damage_type = self.nDamageType,
		damage_flags = self.nDamageFlags
	}

	if IsNotNull(tDamage.victim) and IsNotNull(tDamage.attacker) then
		ApplyDamage(tDamage)
	end

	self:SetStackCount(#t)
	if #t <= 0 then
		self:Destroy()
	end
end
function modifier_roland_bleed_debuff:OnIntervalThink()
	self:ReleaseBleeds(math.ceil(self.nBleedsSecondPct * #self.tDamageInfo))
end