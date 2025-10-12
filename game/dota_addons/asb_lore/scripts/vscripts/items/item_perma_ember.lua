LinkLuaModifier( "modifier_ember_buff", "items/item_ember", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ember_burn", "items/item_ember", LUA_MODIFIER_MOTION_NONE )

item_perma_ember = item_perma_ember or class({})

function item_perma_ember:CastFilterResult()
    if IsServer() then
        return ( self:GetCaster():HasModifier("modifier_ember_buff") )
               and UF_FAIL_CUSTOM
               or UF_SUCCESS
    end
end
function item_perma_ember:GetCustomCastError()
	return "#item_ember_cast_error"
end
function item_perma_ember:OnAbilityPhaseStart() 
    local hCaster = self:GetCaster()
    EmitSoundOn("ember.activate", hCaster)    
   
    return true 
end
function item_perma_ember:OnAbilityPhaseInterrupted() 
    StopSoundOn("ember.activate", self:GetCaster())
end
function item_perma_ember:OnSpellStart()
    if not IsServer() then return end
    
    local hCaster = self:GetCaster()
    
    local tGetValues = { 
                           iBonusHealthPercent   = self:GetSpecialValueFor("bonus_hp_percent"),
                           iBonusMoveSpeedConst  = self:GetSpecialValueFor("bonus_ms_constant"),
    
                           fFireCircleDamage     = self:GetSpecialValueFor("circle_damage"),
                           fFireCircleChance     = self:GetSpecialValueFor("circle_chance"),
                           fBurnDamageInterval   = self:GetSpecialValueFor("burn_damage_interval"),
    
                           iABILITY_TARGET_TEAM  = self:GetAbilityTargetTeam(),
                           iABILITY_TARGET_TYPE  = self:GetAbilityTargetType(),
                           iABILITY_TARGET_FLAGS = self:GetAbilityTargetFlags(),
                       }
	
    hCaster:AddNewModifier(hCaster, self, "modifier_ember_buff", tGetValues)
    
    --self:SpendCharge(0)
end
