require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
item_roland_mask = item_roland_mask or class({})

function item_roland_mask:Precache(context)
	PrecacheUnitByNameSync("npc_roland_gebura", context, nil)
end
function item_roland_mask:GetIntrinsicModifierName()
	return "modifier_item_roland_mask"
end
function item_roland_mask:OnSpellStart()
	local hCaster 	= self:GetCaster()
	local nDuration = self:GetSpecialValueFor("gebura_duration")

	local sUnitName = "npc_roland_gebura"
	local vSpawnLoc = hCaster:GetAbsOrigin() + hCaster:GetForwardVector() * 300

	local fCallback =   function(hUnit, bNotFirstSpawn)
							if not bNotFirstSpawn then
								self._hGeburaNPC = hUnit
								
								hUnit:SetUnitCanRespawn(false)
								hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
							else
								FindClearSpaceForUnit(hUnit, vSpawnLoc, true)
							end

							hUnit:RespawnUnit()

							local vForward = hCaster:GetForwardVector()
							local vToward  = vSpawnLoc + vForward * 10

							hUnit:SetForwardVector(vForward, true)
							hUnit:FaceTowards(vToward)

							for i = DOTA_ITEM_SLOT_7, DOTA_ITEM_SLOT_9 do
								local hItem = hUnit:GetItemInSlot(i)
								if IsNotNull(hItem) then
									hUnit:SwapItems(DOTA_STASH_SLOT_6, i)
									hUnit:SwapItems(DOTA_STASH_SLOT_6, i)
								end
							end

							hUnit:AddNewModifier(hCaster, self, "modifier_kill", {duration = nDuration})

							return hUnit
						end

	if IsNotNull(self._hGeburaNPC) then
		fCallback(self._hGeburaNPC, true)
	else
		local _hGeburaNPC = fCallback(CreateUnitByName(sUnitName, vSpawnLoc, true, hCaster, hCaster, hCaster:GetTeamNumber()), false)
	end


	-- local therolist = LoadKeyValues("scripts/npc/herolist.txt")

	-- for sHeroName, enable in pairs(therolist) do
	-- 	if enable > 0 then
	-- 		PrecacheUnitByNameAsync(sHeroName, function(nID)
	-- 			local hHero = CreateUnitByName(sHeroName, vSpawnLoc, true, hCaster, hCaster, hCaster:GetTeamNumber())
	-- 			hHero:AddItemByName("item_pandora_box")
	-- 			hHero:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)
	-- 			for i = 1, 30 do
	-- 				hHero:HeroLevelUp(false)
	-- 			end
	-- 		end, hCaster:GetPlayerOwnerID())


	-- 	end
	-- end
end

--====================================================================================================--
LinkLuaModifier("modifier_item_roland_mask", "heroes/roland/item_roland_mask", LUA_MODIFIER_MOTION_NONE)

modifier_item_roland_mask = modifier_item_roland_mask or class({})

function modifier_item_roland_mask:IsHidden()												return true end
function modifier_item_roland_mask:RemoveOnDeath()											return false end
function modifier_item_roland_mask:IsPurgable()												return false end
function modifier_item_roland_mask:GetAttributes()											return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_roland_mask:DeclareFunctions()
	local t =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return t
end
function modifier_item_roland_mask:OnCreated(hTable)
	self.caster  = self:GetCaster()
	self.parent  = self:GetParent()
	self.ability = self:GetAbility()
	
	self.iBonusDmg	  = self.ability:GetSpecialValueFor("bonus_attk_damage")
	self.iBonusHealth   = self.ability:GetSpecialValueFor("bonus_health")
	self.iBonusAllStats = self.ability:GetSpecialValueFor("bonus_allstats")
	self.iBonusSpellAmp = self.ability:GetSpecialValueFor("bonus_spell_amp")

	if IsServer() and IsNotNull(self.parent) and not self.parent:HasScepter() then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end
function modifier_item_roland_mask:GetModifierPreAttack_BonusDamage()
	return self.iBonusDmg
end
function modifier_item_roland_mask:GetModifierHealthBonus()
	return self.iBonusHealth
end
function modifier_item_roland_mask:GetModifierBonusStats_Strength()
	return self.iBonusAllStats
end
function modifier_item_roland_mask:GetModifierBonusStats_Agility()
	return self.iBonusAllStats
end
function modifier_item_roland_mask:GetModifierBonusStats_Intellect()
	return self.iBonusAllStats
end
function modifier_item_roland_mask:GetModifierSpellAmplify_Percentage()
	return self.iBonusSpellAmp
end