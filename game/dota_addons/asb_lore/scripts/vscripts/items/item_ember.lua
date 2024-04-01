LinkLuaModifier( "modifier_ember_buff", "items/item_ember", LUA_MODIFIER_MOTION_NONE )
item_ember = item_ember or class({})

function item_ember:CastFilterResult()
    if IsServer() then
        return ( self:GetCaster():HasModifier("modifier_ember_buff") )
               and UF_FAIL_CUSTOM
               or UF_SUCCESS
    end
end
function item_ember:GetCustomCastError()
	return "#item_ember_cast_error"
end
function item_ember:OnAbilityPhaseStart() 
    local hCaster = self:GetCaster()
    EmitSoundOn("ember.activate", hCaster)    
   
    return true 
end
function item_ember:OnAbilityPhaseInterrupted() 
    StopSoundOn("ember.activate", self:GetCaster())
end
function item_ember:OnSpellStart()
    if not IsServer() then return end
    
    local hCaster = self:GetCaster()
	
    hCaster:AddNewModifier(hCaster, self, "modifier_ember_buff", {})
    --hCaster:CalculateStatBonus(true)
    self:SpendCharge()
end


modifier_ember_buff = modifier_ember_buff or class({})

--------------------------------------------------------------------------------

function modifier_ember_buff:IsHidden() return false end
function modifier_ember_buff:RemoveOnDeath() return true end
function modifier_ember_buff:IsDebuff() return false end
function modifier_ember_buff:IsStunDebuff() return false end
function modifier_ember_buff:IsPurgable() return false end
function modifier_ember_buff:GetTexture() 
    return "ember"
end
function modifier_ember_buff:DeclareFunctions()
	local funcs = {
		              MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		              MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			      }
	return funcs
end
function modifier_ember_buff:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
	self.ability = self:GetAbility()
    
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end
function modifier_ember_buff:OnIntervalThink()
    if IsNotNull(self.parent) and self.parent:IsAlive() then
        self.parent:Heal(99999.99, self.ability)
        self.iBonusHP = 10
        self.iBonusMS = 25
    end
    
    self:StartIntervalThink(-1)
end
function modifier_ember_buff:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_ember_buff:GetModifierExtraHealthPercentage()
	return self.iBonusHP
end
function modifier_ember_buff:GetModifierMoveSpeedBonus_Constant()
	return self.iBonusMS
end
