require("items/makora_fix/util")

LinkLuaModifier("modifier_wheel_effect_passive", "items/makora_fix/wheel_effect.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wheel_effect_immunity", "items/makora_fix/wheel_effect.lua", LUA_MODIFIER_MOTION_NONE)

item_wheel_effect = class({})

function item_wheel_effect:GetIntrinsicModifierName()
    return "modifier_wheel_effect_passive"
end

function item_wheel_effect:OnSpellStart()
    if self.EndCooldown then self:EndCooldown() end
    WheelUtil.switch_to_next_mode(self)
end

modifier_wheel_effect_passive = class({})

function modifier_wheel_effect_passive:IsHidden() return true end
function modifier_wheel_effect_passive:IsPurgable() return false end
function modifier_wheel_effect_passive:RemoveOnDeath() return false end
function modifier_wheel_effect_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_wheel_effect_passive:OnCreated()
    self.debuff_count = 0
    self.tracked_debuffs = {}
    local ability = self:GetAbility()
    if ability then
        self.immunity_duration = ability:GetSpecialValueFor("duration")
        self.counter_window = ability:GetSpecialValueFor("counter_window")
        self.cooldown_time = ability:GetSpecialValueFor("adaptation_cooldown")
        self.threshold = ability:GetSpecialValueFor("debuff_threshold")
        self.status_resist = ability:GetSpecialValueFor("wheel_status_resistance")
    end
    if IsServer() then self:StartIntervalThink(0.1) end
end

function modifier_wheel_effect_passive:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    }
end

function modifier_wheel_effect_passive:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_wheel_effect_passive:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_wheel_effect_passive:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_wheel_effect_passive:GetModifierStatusResistanceStacking()
    return self.status_resist or 0
end

function modifier_wheel_effect_passive:HasImmunity()
    return self:GetParent():HasModifier("modifier_wheel_effect_immunity")
end

function modifier_wheel_effect_passive:CanTriggerImmunity()
    local ability = self:GetAbility()
    local parent = self:GetParent()
    if not ability or ability:IsNull() or not parent or parent:IsNull() then return false end
    if WheelUtil.get_proc_cooldown_remaining(ability) > 0 then return false end
    if parent.IsIllusion and parent:IsIllusion() then return false end
    return not self:HasImmunity()
end

function modifier_wheel_effect_passive:IsValidDebuff(modifier)
    if not modifier or not modifier:IsDebuff() then return false end
    if modifier.GetAuraOwner then
        local aura_owner = modifier:GetAuraOwner()
        if aura_owner and not aura_owner:IsNull() then return false end
    end
    return true
end

function modifier_wheel_effect_passive:OnIntervalThink()
    if not IsServer() then return end
    local parent = self:GetParent()
    if not parent or parent:IsNull() then return end
    
    local current_debuffs = {}
    for i = 0, parent:GetModifierCount() - 1 do
        local mod_name = parent:GetModifierNameByIndex(i)
        local modifier = parent:FindModifierByName(mod_name)
        if modifier and self:IsValidDebuff(modifier) then
            current_debuffs[mod_name] = true
        end
    end
    
    local new_count = 0
    for mod_name, _ in pairs(current_debuffs) do
        if not self.tracked_debuffs[mod_name] then
            new_count = new_count + 1
        end
    end
    
    self.tracked_debuffs = current_debuffs
    
    if new_count > 0 then
        self.debuff_count = self.debuff_count + new_count
        if self.debuff_count >= (self.threshold or 3) then
            self.debuff_count = 0
            self:ActivateImmunity()
        end
    end
end

function modifier_wheel_effect_passive:ActivateImmunity()
    local ability = self:GetAbility()
    local parent = self:GetParent()
    if not ability or ability:IsNull() or not parent or parent:IsNull() then return end
    WheelUtil.start_proc_cooldown(ability, self.cooldown_time or 60)
    local duration = self.immunity_duration or 5
    parent:AddNewModifier(parent, ability, "modifier_wheel_effect_immunity", {duration = duration})
    EmitSoundOn("DOTA_Item.BlackKingBar.Activate", parent)
end

modifier_wheel_effect_immunity = class({})

function modifier_wheel_effect_immunity:GetTexture() return "item_wheel_effect" end
function modifier_wheel_effect_immunity:IsHidden() return false end
function modifier_wheel_effect_immunity:IsPurgable() return false end

function modifier_wheel_effect_immunity:OnCreated()
    if IsServer() then
        self.PFX = WheelUtil.attach_particle(WheelUtil.DEBUFF_IMMUNITY_PARTICLE, self:GetParent())
        self:AddParticle(self.PFX, false, false, -1, false, false)
        self:GetParent():Purge(false, true, false, true, false)
        self:StartIntervalThink(0.1)
    end
end

function modifier_wheel_effect_immunity:OnIntervalThink()
    if IsServer() then
        self:GetParent():Purge(false, true, false, true, false)
    end
end

function modifier_wheel_effect_immunity:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_wheel_effect_immunity:CheckState()
    return { [MODIFIER_STATE_DEBUFF_IMMUNE] = true }
end