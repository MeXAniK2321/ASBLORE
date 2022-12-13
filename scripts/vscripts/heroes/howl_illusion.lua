howl_illusion = class({})
LinkLuaModifier("modifier_howl_illusion", "heroes/howl_illusion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_howl_illusion1", "heroes/howl_illusion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_howl_illusion_debuff", "heroes/howl_illusion.lua", LUA_MODIFIER_MOTION_NONE)

function howl_illusion:IsStealable() return true end
function howl_illusion:IsHiddenWhenStolen() return false end
function howl_illusion:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end
function howl_illusion:GetAOERadius()
    return self:GetSpecialValueFor("song_radius")
end
function howl_illusion:GetCooldown(level)
    return self.BaseClass.GetCooldown(self, level) 
end
function howl_illusion:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function howl_illusion:GetAbilityDamageType()
    --[[if self:GetCaster():HasModifier("modifier_miku_akuma_buff") then
        return DAMAGE_TYPE_PURE
    end]]--
    return DAMAGE_TYPE_MAGICAL
end
function howl_illusion:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor("song_duration")
    local radius = self:GetSpecialValueFor("song_radius")
    local incoming_damage = self:GetSpecialValueFor("incoming_damage")

	local hologram = CreateUnitByName("npc_dota_inori", point, true, caster, caster, caster:GetTeamNumber())
	hologram:SetDayTimeVisionRange(radius)
	hologram:SetNightTimeVisionRange(radius)
	hologram:SetModelScale(1)
    if self:GetCaster():HasModifier( "modifier_own_soul" ) then
    hologram:AddNewModifier(hologram, self, "modifier_howl_illusion1", {duration = duration})
	else
	hologram:AddNewModifier(hologram, self, "modifier_howl_illusion", {duration = duration})
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_howl_illusion = class({})
function modifier_howl_illusion:IsHidden() return false end
function modifier_howl_illusion:IsDebuff() return false end
function modifier_howl_illusion:IsPurgable() return false end
function modifier_howl_illusion:IsPurgeException() return false end
function modifier_howl_illusion:RemoveOnDeath() return true end
function modifier_howl_illusion:IsAura() return true end
function modifier_howl_illusion:IsAuraActiveOnDeath() return false end
function modifier_howl_illusion:DeclareFunctions()
    local func = {  --MODIFIER_EVENT_ON_UNIT_MOVED,
                    MODIFIER_PROPERTY_AVOID_DAMAGE,
                    MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
    return func
end
function modifier_howl_illusion:CheckState()
    local state = { [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    				[MODIFIER_STATE_STUNNED] = true,
                    [MODIFIER_STATE_MAGIC_IMMUNE] = true, }
    return state
end
function modifier_howl_illusion:GetOverrideAnimation()
    return ACT_DOTA_IDLE_RARE
end
--[[function modifier_howl_illusion:OnUnitMoved(keys)
    if keys.unit == self:GetParent() then
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_5)
    end
end]]--
function modifier_howl_illusion:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("song_radius")
end
function modifier_howl_illusion:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end
function modifier_howl_illusion:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
function modifier_howl_illusion:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end
function modifier_howl_illusion:GetModifierAura()
    return "modifier_howl_illusion_debuff"
end
function modifier_howl_illusion:GetModifierAvoidDamage(keys)
    if IsServer() then
        if keys.attacker and not keys.attacker:IsNull() and IsValidEntity(keys.attacker) then
            local multi_per_attack = (keys.attacker:IsRealHero() and (keys.attacker:IsRangedAttacker() and self.ranged_hero_attacks or self.melee_hero_attacks) or (keys.attacker:IsRangedAttacker() and self.ranged_creep_attacks or self.melee_creep_attacks))
            local health_per_attack = self.parent:GetMaxHealth() / multi_per_attack
            --print(multi_per_attack, health_per_attack)
            if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
                --print(self.health_attacks)
                self.health_attacks = self.health_attacks - (self.melee_hero_attacks / multi_per_attack)
                self.parent_health = self.parent_health - health_per_attack
                --print(self.health_attacks)
                if self.health_attacks <= 0 then
                    --print("DIEEE")
                    self.parent:Kill(keys.ability, keys.attacker)
                else
                    self.parent:SetHealth(self.parent_health)
                end
            end
        end

        return 1
    end
end
function modifier_howl_illusion:OnCreated()
    if IsServer() then
        self.parent = self:GetParent()
		

        self.created_health = self.parent:GetHealthPercent()
        self.parent:SetHealth(self.parent:GetMaxHealth())

        self.melee_hero_attacks = self:GetAbility():GetSpecialValueFor("melee_hero_attacks") or 2
        self.ranged_hero_attacks = self:GetAbility():GetSpecialValueFor("ranged_hero_attacks") or 2
        self.melee_creep_attacks = self:GetAbility():GetSpecialValueFor("melee_creep_attacks") or 2
        self.ranged_creep_attacks = self:GetAbility():GetSpecialValueFor("ranged_creep_attacks") or 2

        self.health_attacks = self.melee_hero_attacks
        self.parent_health = self.parent:GetMaxHealth()

        self.song_radius = self:GetAbility():GetSpecialValueFor("song_radius")
        self.wave_speed_inv = 0.002
        self.wave_duration = self.song_radius * self.wave_speed_inv

        
        if self:GetParent():HasModifier("modifier_own_soul") then
            self.song_waves_fx = ParticleManager:CreateParticle("particles/naga_siren_song_aura2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            self.song_light_fx = ParticleManager:CreateParticle("particles/naga_siren_song_aura2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        else
            self.song_waves_fx = ParticleManager:CreateParticle("particles/naga_siren_song_aura2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            self.song_light_fx = ParticleManager:CreateParticle("particles/naga_siren_song_aura2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        end

        ParticleManager:SetParticleControl(self.song_waves_fx, 0, self:GetParent():GetOrigin() + Vector(0, 0, 10))
        ParticleManager:SetParticleControl(self.song_waves_fx, 1, Vector(self.song_radius, self.wave_duration, 0))

        self:AddParticle(self.song_waves_fx, false, false, -1, true, true)
        self:AddParticle(self.song_light_fx, false, false, -1, true, true)

        if self.parent:HasModifier("modifier_own_soul") then
            EmitSoundOn("inori.song", self.parent)
            --local cast_particle_akuma = ParticleManager:CreateParticle("particles/heroes/miku/howl_illusion_cast_akuma.vpcf", PATTACH_OVERHEAD_FOLLOW, hologram)
        else
            EmitSoundOn("inori.song2", self.parent)
            --local cast_particle = ParticleManager:CreateParticle("particles/heroes/miku/howl_illusion_cast.vpcf", PATTACH_OVERHEAD_FOLLOW, hologram)
        end
    end
end
--[[function modifier_howl_illusion:GetEffectName()
    if self:GetParent():HasModifier("modifier_miku_akuma_buff") then
        return "particles/heroes/miku/howl_illusion_waves_red.vpcf"
    else
        return "particles/heroes/miku/howl_illusion_waves_blue.vpcf"
    end
end
function modifier_howl_illusion:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end]]--
function modifier_howl_illusion:OnDestroy()
    if IsServer() then
        if self.parent and IsValidEntity(self.parent) and self.parent:IsAlive() then
            local hp_will_be = self.created_health * self.parent:GetMaxHealth() * 0.01
            self.parent:SetHealth(hp_will_be + 1)

            self.parent:RemoveGesture(ACT_DOTA_IDLE_RARE)
            self.parent:ForceKill(false)
        end

        StopSoundOn("inori.song", self.parent)
        StopSoundOn("inori.song2", self.parent)
        
    end
end
modifier_howl_illusion1 = class({})
function modifier_howl_illusion1:IsHidden() return false end
function modifier_howl_illusion1:IsDebuff() return false end
function modifier_howl_illusion1:IsPurgable() return false end
function modifier_howl_illusion1:IsPurgeException() return false end
function modifier_howl_illusion1:RemoveOnDeath() return true end
function modifier_howl_illusion1:IsAura() return true end
function modifier_howl_illusion1:IsAuraActiveOnDeath() return false end
function modifier_howl_illusion1:DeclareFunctions()
    local func = {  --MODIFIER_EVENT_ON_UNIT_MOVED,
                    MODIFIER_PROPERTY_AVOID_DAMAGE,
                    MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
    return func
end
function modifier_howl_illusion1:CheckState()
    local state = { [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    				[MODIFIER_STATE_STUNNED] = true,
                    [MODIFIER_STATE_MAGIC_IMMUNE] = true, }
    return state
end
function modifier_howl_illusion1:GetOverrideAnimation()
    return ACT_DOTA_IDLE_RARE
end
--[[function modifier_howl_illusion:OnUnitMoved(keys)
    if keys.unit == self:GetParent() then
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_5)
    end
end]]--
function modifier_howl_illusion1:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("song_radius")
end
function modifier_howl_illusion1:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end
function modifier_howl_illusion1:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
function modifier_howl_illusion1:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end
function modifier_howl_illusion1:GetModifierAura()
    return "modifier_howl_illusion_debuff"
end
function modifier_howl_illusion1:GetModifierAvoidDamage(keys)
    if IsServer() then
        if keys.attacker and not keys.attacker:IsNull() and IsValidEntity(keys.attacker) then
            local multi_per_attack = (keys.attacker:IsRealHero() and (keys.attacker:IsRangedAttacker() and self.ranged_hero_attacks or self.melee_hero_attacks) or (keys.attacker:IsRangedAttacker() and self.ranged_creep_attacks or self.melee_creep_attacks))
            local health_per_attack = self.parent:GetMaxHealth() / multi_per_attack
            --print(multi_per_attack, health_per_attack)
            if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
                --print(self.health_attacks)
                self.health_attacks = self.health_attacks - (self.melee_hero_attacks / multi_per_attack)
                self.parent_health = self.parent_health - health_per_attack
                --print(self.health_attacks)
                if self.health_attacks <= 0 then
                    --print("DIEEE")
                    self.parent:Kill(keys.ability, keys.attacker)
                else
                    self.parent:SetHealth(self.parent_health)
                end
            end
        end

        return 1
    end
end
function modifier_howl_illusion1:OnCreated()
    if IsServer() then
        self.parent = self:GetParent()
		

        self.created_health = self.parent:GetHealthPercent()
        self.parent:SetHealth(self.parent:GetMaxHealth())

        self.melee_hero_attacks = self:GetAbility():GetSpecialValueFor("melee_hero_attacks") or 2
        self.ranged_hero_attacks = self:GetAbility():GetSpecialValueFor("ranged_hero_attacks") or 2
        self.melee_creep_attacks = self:GetAbility():GetSpecialValueFor("melee_creep_attacks") or 2
        self.ranged_creep_attacks = self:GetAbility():GetSpecialValueFor("ranged_creep_attacks") or 2

        self.health_attacks = self.melee_hero_attacks
        self.parent_health = self.parent:GetMaxHealth()

        self.song_radius = self:GetAbility():GetSpecialValueFor("song_radius")
        self.wave_speed_inv = 0.002
        self.wave_duration = self.song_radius * self.wave_speed_inv

        
        if self:GetParent():HasModifier("modifier_own_soul") then
            self.song_waves_fx = ParticleManager:CreateParticle("particles/naga_siren_song_aura2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            self.song_light_fx = ParticleManager:CreateParticle("particles/naga_siren_song_aura2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        else
            self.song_waves_fx = ParticleManager:CreateParticle("particles/naga_siren_song_aura2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            self.song_light_fx = ParticleManager:CreateParticle("particles/naga_siren_song_aura2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        end

        ParticleManager:SetParticleControl(self.song_waves_fx, 0, self:GetParent():GetOrigin() + Vector(0, 0, 10))
        ParticleManager:SetParticleControl(self.song_waves_fx, 1, Vector(self.song_radius, self.wave_duration, 0))

        self:AddParticle(self.song_waves_fx, false, false, -1, true, true)
        self:AddParticle(self.song_light_fx, false, false, -1, true, true)

        if self.parent:HasModifier("modifier_own_soul") then
            EmitSoundOn("inori.song2", self.parent)
            --local cast_particle_akuma = ParticleManager:CreateParticle("particles/heroes/miku/howl_illusion_cast_akuma.vpcf", PATTACH_OVERHEAD_FOLLOW, hologram)
        else
            EmitSoundOn("inori.song", self.parent)
            --local cast_particle = ParticleManager:CreateParticle("particles/heroes/miku/howl_illusion_cast.vpcf", PATTACH_OVERHEAD_FOLLOW, hologram)
        end
    end
end
--[[function modifier_howl_illusion:GetEffectName()
    if self:GetParent():HasModifier("modifier_miku_akuma_buff") then
        return "particles/heroes/miku/howl_illusion_waves_red.vpcf"
    else
        return "particles/heroes/miku/howl_illusion_waves_blue.vpcf"
    end
end
function modifier_howl_illusion:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end]]--
function modifier_howl_illusion1:OnDestroy()
    if IsServer() then
        if self.parent and IsValidEntity(self.parent) and self.parent:IsAlive() then
            local hp_will_be = self.created_health * self.parent:GetMaxHealth() * 0.01
            self.parent:SetHealth(hp_will_be + 1)

            self.parent:RemoveGesture(ACT_DOTA_IDLE_RARE)
            self.parent:ForceKill(false)
        end

        StopSoundOn("inori.song", self.parent)
        StopSoundOn("inori.song2", self.parent)
        
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_howl_illusion_debuff = class({})
function modifier_howl_illusion_debuff:IsHidden() return false end
function modifier_howl_illusion_debuff:IsDebuff() return true end
function modifier_howl_illusion_debuff:IsPurgable() return true end
function modifier_howl_illusion_debuff:IsPurgeException() return true end
function modifier_howl_illusion_debuff:RemoveOnDeath() return true end
function modifier_howl_illusion_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--[[function modifier_howl_illusion_debuff:CheckState()
    local state = { [MODIFIER_STATE_ROOTED] = true,}
    return state
end]]
function modifier_howl_illusion_debuff:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}
    return func
end
function modifier_howl_illusion_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("move_slow") * (-1)
end
function modifier_howl_illusion_debuff:OnCreated()
    if IsServer() then
        self.interval = 0.1

        self.damage = (self:GetAbility():GetSpecialValueFor("song_damage") * self.interval)

        self:StartIntervalThink(self.interval)
    end
end
function modifier_howl_illusion_debuff:GetOverrideAnimation()
    return ACT_DOTA_IDLE_RARE
end
function modifier_howl_illusion_debuff:OnIntervalThink()
    if IsServer() then
        if not self:GetAbility() then
            return nil
        end

        local effect = OVERHEAD_ALERT_MANA_LOSS

        if self:GetCaster():HasModifier("modifier_miku_akuma_buff") then
            effect = OVERHEAD_ALERT_DAMAGE
        end

        self.final_damage = self:GetParent():GetHealth() * 0.01 * self.damage
        
        SendOverheadEventMessage(nil, effect, self:GetParent(), self.final_damage, nil)

        local damage_table = {  attacker = self:GetCaster(), 
                                victim = self:GetParent(), 
                                ability = self:GetAbility(), 
                                damage = self.final_damage, 
                                damage_type = self:GetAbility():GetAbilityDamageType()
                                --damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
                            }

        ApplyDamage(damage_table)
    end
end
function modifier_howl_illusion_debuff:GetEffectName()
    if self:GetCaster():HasModifier("modifier_own_soul") then
        return "particles/heroes/miku/howl_illusion_aura_debuff/howl_illusion_debuff_akuma.vpcf"
    else
        return "particles/units/heroes/hero_siren/naga_siren_song_debuff.vpcf"
    end
end
function modifier_howl_illusion_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end