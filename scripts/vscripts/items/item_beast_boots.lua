
LinkLuaModifier("modifier_item_beast_boots_perm", "items/item_beast_boots", LUA_MODIFIER_MOTION_NONE)

item_beast_boots = class({})

function item_beast_boots:CastFilterResultTarget(target)
    if target:HasModifier("modifier_item_beast_boots_perm") then
        return UF_FAIL_CUSTOM
    end
    if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
        return UF_FAIL_ENEMY
    end
    return UF_SUCCESS
end 

function item_beast_boots:GetCustomCastErrorTarget(target)
    if target:HasModifier("modifier_item_beast_boots_perm")  then
        return "#dota_hud_error_cant_cast_on_other"
    end
end

function item_beast_boots:OnSpellStart()
    if not IsServer() then return end
    local target = self:GetCursorTarget()
    target:AddNewModifier( self:GetCaster(), self, "modifier_item_beast_boots_perm", {} )
    
    self:SpendCharge()
end


modifier_item_beast_boots_perm = class({})

function modifier_item_beast_boots_perm:IsHidden()
    return false
end

function modifier_item_beast_boots_perm:RemoveOnDeath()
    return false
end

function modifier_item_beast_boots_perm:IsPurgable()
    return false
end

function modifier_item_beast_boots_perm:OnCreated()
    if not IsServer() then return end
    self.ms = self:GetAbility():GetSpecialValueFor('ms')
    
end

function modifier_item_beast_boots_perm:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        
    }

    return funcs
end

function modifier_item_beast_boots_perm:GetModifierMoveSpeedBonus_Constant()
    
    return 50
end
  function modifier_item_beast_boots_perm:GetModifierPhysicalArmorBonus()
return 4
end     
function modifier_item_beast_boots_perm:GetTexture()
	return "beast_boots"
end
