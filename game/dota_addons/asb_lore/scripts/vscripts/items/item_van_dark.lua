
LinkLuaModifier("modifier_item_van_dark_perm", "items/item_van_dark", LUA_MODIFIER_MOTION_NONE)

item_van_dark = class({})




function item_van_dark:OnSpellStart()
    if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_item_van_dark_perm")  then
       else
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_van_dark_perm", {} )
    local sound_cast = "van.dark"
	EmitSoundOn( sound_cast, self:GetCaster() )
    self:SpendCharge(0)
	end
end


modifier_item_van_dark_perm = class({})

function modifier_item_van_dark_perm:IsHidden()
    return false
end

function modifier_item_van_dark_perm:RemoveOnDeath()
    return false
end

function modifier_item_van_dark_perm:IsPurgable()
    return false
end

function modifier_item_van_dark_perm:OnCreated()
    if not IsServer() then return end
    self.ms = self:GetAbility():GetSpecialValueFor('ms')
    
end

function modifier_item_van_dark_perm:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        
    }

    return funcs
end

function modifier_item_van_dark_perm:GetModifierAttackSpeedBonus_Constant()
    
    return 80
end
function modifier_item_van_dark_perm:GetTexture()
	return "van_dark"
end
