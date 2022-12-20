LinkLuaModifier("modifier_illidan_pepper", "heroes/donut", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_grand_donut",        "heroes/donut", LUA_MODIFIER_MOTION_NONE)

grand_panaino = class({})

function grand_panaino:GetIntrinsicModifierName()
    return "modifier_grand_donut"
end
function grand_panaino:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("grand_panaino")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function grand_panaino:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function grand_panaino:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    local heal = self:GetSpecialValueFor("regen")
    caster:EmitSound("grand.panaino")
    caster:Heal( heal, caster )
    caster:AddNewModifier(caster, self, "modifier_illidan_pepper", { duration = duration } )
end

modifier_illidan_pepper = class({})

function modifier_illidan_pepper:IsPurgable()
    return true
end

function modifier_illidan_pepper:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_illidan_pepper:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_illidan_pepper:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end
function modifier_illidan_pepper:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end
function modifier_illidan_pepper:GetEffectName()
    return "particles/econ/courier/courier_onibi/courier_onibi_pink_ambient_b.vpcf"
end

function modifier_illidan_pepper:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_illidan_pepper:GetStatusEffectName()
    return "particles/econ/courier/courier_onibi/courier_onibi_pink_ambient_b.vpcf" 
end

function modifier_illidan_pepper:StatusEffectPriority()
    return 5
end
modifier_grand_donut = class ({})
function modifier_grand_donut:IsHidden() return true end
function modifier_grand_donut:IsDebuff() return false end
function modifier_grand_donut:IsPurgable() return false end
function modifier_grand_donut:IsPurgeException() return false end
function modifier_grand_donut:RemoveOnDeath() return false end

function modifier_grand_donut:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_grand_donut:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_grand_donut:OnIntervalThink()
    if IsServer() then
        local lerolero = self:GetParent():FindAbilityByName("grand_panaino")
        if lerolero and not lerolero:IsNull() then
            if self:GetParent():HasScepter() then
                if lerolero:IsHidden() then
                    lerolero:SetHidden(false)
                end
            else
                if not lerolero:IsHidden() then
                    lerolero:SetHidden(true)
                end
            end
        end
    end
end