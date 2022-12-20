mori_hit_buttons = class({})
LinkLuaModifier("modifier_mori_hit_buttons", "heroes/mori_hit_buttons", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mori_hit_buttons_damage", "heroes/mori_hit_buttons", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_secret_move", "heroes/mori_hit_buttons", LUA_MODIFIER_MOTION_NONE)

function mori_hit_buttons:IsStealable() return true end
function mori_hit_buttons:IsHiddenWhenStolen() return false end
function mori_hit_buttons:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_mori_hit_buttons", {duration = 10})
	if self:GetCaster():HasModifier("modifier_item_secret_buff") then
	caster:AddNewModifier(caster, self, "modifier_secret_move", {duration = 5})
	else
	end
	EmitSoundOn("mori.2", caster)
	EmitSoundOn("mori.2_1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_secret_move = class({})
function modifier_secret_move:IsHidden() return true end
function modifier_secret_move:IsDebuff() return false end
function modifier_secret_move:IsPurgable() return false end
function modifier_secret_move:IsPurgeException() return false end
function modifier_secret_move:RemoveOnDeath() return true end
modifier_mori_hit_buttons = class({})
function modifier_mori_hit_buttons:IsHidden() return false end
function modifier_mori_hit_buttons:IsDebuff() return false end
function modifier_mori_hit_buttons:IsPurgable() return false end
function modifier_mori_hit_buttons:IsPurgeException() return false end
function modifier_mori_hit_buttons:RemoveOnDeath() return true end
function modifier_mori_hit_buttons:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                     MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,                                                 	}
    return func
end
function modifier_mori_hit_buttons:GetModifierMoveSpeedBonus_Percentage()

	return self:GetAbility():GetSpecialValueFor('ms')+self:GetCaster():FindTalentValue("special_bonus_mori_25")
	end
	

function modifier_mori_hit_buttons:GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        if self:GetParent():PassivesDisabled() then
            return nil
        end

        if self:GetParent():IsIllusion() then
            return nil
        end

        local reduce = self:GetAbility():GetSpecialValueFor("reduce") 
        local damage_after = keys.damage * reduce * -0.01
        
        if self.ready_damage == 0 then
            self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("delay"))
        end

        self.ready_damage = self.ready_damage + damage_after

        return reduce
    end
end
function modifier_mori_hit_buttons:OnCreated(table)
    if IsServer() then
        self.ready_damage = 0

        --self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
    end
end
function modifier_mori_hit_buttons:OnIntervalThink()
    if IsServer() then
        if self.ready_damage > 0 then
            local delay = self:GetAbility():GetSpecialValueFor("delay") 
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_mori_hit_buttons_damage", {duration = delay, damage = self.ready_damage})

            self.ready_damage = 0

            self:StartIntervalThink(-1)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_mori_hit_buttons_damage = class({})
function modifier_mori_hit_buttons_damage:IsHidden() return true end
function modifier_mori_hit_buttons_damage:IsDebuff() return false end
function modifier_mori_hit_buttons_damage:IsPurgable() return false end
function modifier_mori_hit_buttons_damage:IsPurgeException() return false end
function modifier_mori_hit_buttons_damage:RemoveOnDeath() return true end
function modifier_mori_hit_buttons_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_mori_hit_buttons_damage:OnCreated(table)
    if IsServer() then
        local interval = self:GetAbility():GetSpecialValueFor("interval")
        local multiplier = self:GetDuration()/interval

        self.damage_table = {   victim = self:GetParent(),
                                attacker = self:GetParent(),
                                damage = table.damage/multiplier,
                                damage_type = self:GetAbility():GetAbilityDamageType(),
                                ability = self:GetAbility(),
                                damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR }

        self:StartIntervalThink(interval)
    end
end
function modifier_mori_hit_buttons_damage:OnIntervalThink()
    if IsServer() then
        if self:GetParent():IsAlive() then
            ApplyDamage(self.damage_table)
        else
            self:Destroy()
        end
    end
end