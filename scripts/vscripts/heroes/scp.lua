
LinkLuaModifier("modifier_scp_screamer", "heroes/scp", LUA_MODIFIER_MOTION_NONE)

Scp173_Screamer = class({}) 

function Scp173_Screamer:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function Scp173_Screamer:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end

function Scp173_Screamer:GetCastRange(location, target)
    return self.BaseClass.GetCastRange(self, location, target)
end

function Scp173_Screamer:OnSpellStart()
    if not IsServer() then return end
    local target = self:GetCursorTarget()
    local victim_angle = target:GetAnglesAsVector()
    local victim_forward_vector = target:GetForwardVector()
    local victim_angle_rad = victim_angle.y*math.pi/180
    local victim_position = target:GetAbsOrigin()
    local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)
    local duration = self:GetSpecialValueFor("duration")
    local damage = self:GetSpecialValueFor("damage")
    if target:TriggerSpellAbsorb( self ) then return end
    self:GetCaster():SetAbsOrigin(attacker_new)
    FindClearSpaceForUnit(self:GetCaster(), attacker_new, true)
    self:GetCaster():SetForwardVector(victim_forward_vector)
    self:GetCaster():MoveToTargetToAttack(target)
    target:AddNewModifier(self:GetCaster(), self, "modifier_scp_screamer", {duration = duration})
    ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
end

modifier_scp_screamer = class({})

function modifier_scp_screamer:IsHidden()
    return false
end

function modifier_scp_screamer:IsPurgable()
    return false
end

function modifier_scp_screamer:OnCreated()
    if not IsServer() then return end
    local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    EmitSoundOnClient("ScpScreamer", Player)
    CustomGameEventManager:Send_ServerToPlayer(Player, "ScpScreamerTrue", {} )
    print("ScpScreamer")
end

function modifier_scp_screamer:OnDestroy()
    if not IsServer() then return end
    local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    CustomGameEventManager:Send_ServerToPlayer(Player, "ScpScreamerFalse", {} )
end

function modifier_scp_screamer:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

function modifier_scp_screamer:GetEffectName()
    return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_scp_screamer:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

