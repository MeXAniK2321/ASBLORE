
LinkLuaModifier("modifier_ebaniyzhazj", "heroes/ichigo/ichigof", LUA_MODIFIER_MOTION_NONE)

ichigoF = class({})

function ichigoF:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end

---------------------------------------------------------------------------

function ichigoF:OnAbilityPhaseStart()
    local particle_cast_a = "particles/ichigo_eff/ichigo_f/ichigo_f.vpcf"
    local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a, PATTACH_POINT, self:GetOwner())
    ParticleManager:SetParticleControl(effect_cast_a, 0, self:GetOwner():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(effect_cast_a)

    return true
end

function ichigoF:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local origin = caster:GetOrigin()
    local ability = self
    if caster:HasModifier("modifier_ebaniyzhazj") then 
		ability:EndCooldown() 
		local modifier = caster:FindModifierByName("modifier_ebaniyzhazj")
        if modifier:GetStackCount() == 0 then 
			ability:StartCooldown(modifier:GetRemainingTime())
			else
			ability:StartCooldown(0.1)
			end
        end
    local max_range = self:GetSpecialValueFor("range")

    local direction = (point - origin)
    if direction:Length2D() > max_range then
        direction = direction:Normalized() * max_range
    end

    FindClearSpaceForUnit(caster, origin + direction, true)

    self:PlayEffects(direction)
end

--------------------------------------------------------------------------------
function ichigoF:PlayEffects(direction)
    local particle_cast_b = "particles/ichigo_eff/ichigo_f/ichigo_f.vpcf"

    local sound_cast = "Ichigo.F1"

    local effect_cast_b = ParticleManager:CreateParticle(particle_cast_b, PATTACH_ABSORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(effect_cast_b, 0, self:GetCaster():GetOrigin())
    ParticleManager:SetParticleControlForward(effect_cast_b, 0, direction:Normalized())
    ParticleManager:ReleaseParticleIndex(effect_cast_b)
    EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), sound_cast, self:GetCaster())
end

modifier_ebaniyzhazj = class({})
if IsServer() then
    function modifier_ebaniyzhazj:Update()
        if self:GetDuration() == -1 then
            self:SetDuration(self.kv.replenish_time, true)
            self:StartIntervalThink(self.kv.replenish_time)
        end

        --Doesnt work properly for abilities that have a cooldown
        --[[if self:GetStackCount() == 0 then
            self:GetAbility():StartCooldown(self:GetRemainingTime())
        end]]
    end

    function modifier_ebaniyzhazj:OnCreated(kv)
        self:SetStackCount(kv.start_count or kv.max_count)
        self.kv = kv

        if kv.start_count and kv.start_count ~= kv.max_count then
            self:Update()
        end
    end

    function modifier_ebaniyzhazj:DeclareFunctions()
        local funcs = {
            MODIFIER_EVENT_ON_ABILITY_EXECUTED
        }

        return funcs
    end

    function modifier_ebaniyzhazj:OnAbilityExecuted(params)
        if params.unit == self:GetParent() then
            local ability = params.ability

            if params.ability == self:GetAbility() then
                self:DecrementStackCount()
                self:Update()
            end
        end

        return 0
    end

    function modifier_ebaniyzhazj:OnIntervalThink()
        local stacks = self:GetStackCount()

        if stacks < self.kv.max_count then
            self:SetDuration(self.kv.replenish_time, true)
            self:IncrementStackCount()

            if stacks == self.kv.max_count - 1 then
                self:SetDuration(-1, true)
                self:StartIntervalThink(-1)
            end
        end
    end
end

function modifier_ebaniyzhazj:DestroyOnExpire()
    return false
end

function modifier_ebaniyzhazj:IsPurgable()
    return false
end

function modifier_ebaniyzhazj:RemoveOnDeath()
    return false
end