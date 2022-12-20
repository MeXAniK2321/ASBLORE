item_hidnotea = class({})

LinkLuaModifier( "modifier_hidnotea", "items/item_hidnotea", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_valera", "items/item_hidnotea", LUA_MODIFIER_MOTION_NONE )
function item_hidnotea:GetAbilityTextureName()
local caster = self:GetCaster()
 if caster:GetUnitName()== "npc_dota_hero_slark" then
  return "valeryanka"
 else
 return "hidnotea"
 end
		
end
function item_hidnotea:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	 if caster:GetUnitName()== "npc_dota_hero_slark" and caster:HasScepter() then
caster:AddNewModifier(caster, self, "modifier_valera", {} )
end
if not caster:HasModifier("modifier_item_super_idol_water") then
	caster:AddNewModifier(caster, self, "modifier_hidnotea", { duration = 6.0 } )
	EmitSoundOn("hidnotea.tea", caster)
	self:SpendCharge()
	end
end
modifier_hidnotea = class({})

--------------------------------------------------------------------------------

function modifier_hidnotea:IsHidden()
	return false
end
function modifier_hidnotea:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		
	}
	return funcs
end






function modifier_hidnotea:GetTexture()
	return "hidnotea"
end

--------------------------------------------------------------------------------

function modifier_hidnotea:GetModifierConstantHealthRegen( params )
	return 75
end

--------------------------------------------------------------------------------
function modifier_hidnotea:GetModifierIncomingDamage_Percentage( params )
	if GameRules:GetGameTime() < 260 then

		return -30
		else
		return 0
	end
end


--------------------------------------------------------------------------------

function modifier_hidnotea:GetModifierConstantManaRegen( params )
	return 30
end
function modifier_hidnotea:GetEffectName()
	return "particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_ribbon_c_b.vpcf"
end

modifier_valera = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_valera:IsHidden()
	return false
end
function modifier_valera:RemoveOnDeath() return false end
function modifier_valera:IsDebuff()
	return false
end

function modifier_valera:IsStunDebuff()
	return false
end

function modifier_valera:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_valera:OnCreated( kv )
	-- references
	


	if IsServer() then
		self:SetStackCount(1)
	end
end


function modifier_valera:OnRefresh( kv )
	-- references
	
	local max_stack = 10

	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
	end
end