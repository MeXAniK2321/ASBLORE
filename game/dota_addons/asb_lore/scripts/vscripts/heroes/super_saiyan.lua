super_saiyan = class({})
LinkLuaModifier( "modifier_super_saiyan", "modifiers/modifier_super_saiyan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_super_saiyan2", "modifiers/modifier_super_saiyan2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_super_saiyan3", "modifiers/modifier_super_saiyan3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_super_saiyan4", "modifiers/modifier_super_saiyan4", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function super_saiyan:GetAbilityTextureName()
 local rit = self:GetSpecialValueFor("rit")
 if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
 return "ss_blue"
 else
	if rit > 1 and rit < 150 then
		return "goku_3_2"
	elseif rit > 150 then
	return "goku_3_3"
	else return "goku_3"
	end
end
end
function super_saiyan:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local baka = self:GetSpecialValueFor("bom")
	local rit = self:GetSpecialValueFor("rit")

	-- load data
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_super_saiyan4", -- modifier name
		{ duration = duration } -- kv
	)
    if baka > 1 then
	
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_super_saiyan2", -- modifier name
		{ duration = duration } -- kv
	)
	else
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_super_saiyan", -- modifier name
		{ duration = duration } -- kv
	)
	end
	if self:GetCaster():HasModifier("modifier_super_saiyan") then
	if rit > 1 then
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_super_saiyan3", -- modifier name
		{ duration = duration } -- kv
	)
	end
	end
	
end