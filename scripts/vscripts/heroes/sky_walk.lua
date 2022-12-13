LinkLuaModifier("modifier_sky_walk", "heroes/sky_walk", LUA_MODIFIER_MOTION_NONE)


sky_walk = class({})

function sky_walk:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("void_bomb")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function sky_walk:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function sky_walk:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("shu.4_3") 
    caster:AddNewModifier(caster, self, "modifier_sky_walk", { duration = duration } )
end

modifier_sky_walk = class({})

function modifier_sky_walk:IsPurgable()
    return false
end
function modifier_sky_walk:CheckState()
  
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_sky_walk:DeclareFunctions()
    local funcs = {
      
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end



function modifier_sky_walk:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

function modifier_sky_walk:GetEffectName()
    return "particles/sky_walk.vpcf"
end

function modifier_sky_walk:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end




