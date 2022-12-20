maki_strangulate = class({})
LinkLuaModifier("modifier_maki_strangulate_dash", "heroes/accel_blood", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_maki_strangulate_slow", "heroes/accel_blood", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_accel_stunned", "modifiers/modifier_accel_stunned", LUA_MODIFIER_MOTION_NONE) 
--LinkLuaModifier("modifier_maki_strangulate_stun", "heroes/anime_hero_maki", LUA_MODIFIER_MOTION_NONE)

function maki_strangulate:IsStealable() return true end
function maki_strangulate:IsHiddenWhenStolen() return false end
function maki_strangulate:GetChannelAnimation()
    return ACT_DOTA_CHANNEL_ABILITY_1
end
function maki_strangulate:OnAbilityPhaseStart()
    return true
end
function maki_strangulate:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function maki_strangulate:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if target:TriggerSpellAbsorb(self) then
        caster:Interrupt()
        --self:EndChannel(true)
        return nil
    end

    self.target = target
    self.elapsed = self:GetSpecialValueFor("interval")
    
    EmitSoundOn("Accel.Laught", self:GetCaster())

    self.modifier_target = self.target:AddNewModifier(caster, self, "modifier_accel_stunned", {})
    self.target:SetForwardVector((caster:GetOrigin() - self.target:GetOrigin()):Normalized())

    caster:AddNewModifier(caster, self, "modifier_maki_strangulate_dash", {})
end
function maki_strangulate:OnChannelThink(flInterval)
    if not self.target or self.target:IsNull() then
        return nil
    end
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
    
    local modifier = self.target:FindModifierByNameAndCaster("modifier_accel_stunned", self:GetCaster())
    if modifier and modifier == self.modifier_target then
        self.elapsed = self.elapsed + flInterval
        if self.elapsed >= self:GetSpecialValueFor("interval") then
            self.elapsed = 0
		

	-- effects
	self:PlayEffects( target, success )

	

            local max_health = self.target:GetMaxHealth()
			local health = self.target:GetHealth()
			local death = max_health * 0.05
			local hp_damage = (max_health - health) * 0.02
            local damage = self:GetSpecialValueFor("damage")+self:GetCaster():FindTalentValue("special_bonus_accel_25")
            local damage_table = {  victim = self.target,
                                    attacker = self:GetCaster(),
                                    damage = self:GetSpecialValueFor("damage")+self:GetCaster():FindTalentValue("special_bonus_accel_25") + hp_damage,
                                    damage_type = self:GetAbilityDamageType(),
                                    ability = self }

            ApplyDamage(damage_table)
			if health < death then
			   self.target:Kill(self, caster)
			end
        end
    else
        self:GetCaster():Interrupt()
    end
end
function maki_strangulate:OnChannelFinish(bInterrupted)
    StopSoundOn("Accel.Laught", self:GetCaster())

    
        self.target:AddNewModifier(self:GetCaster(), self, "modifier_accel_stunned", {duration = 0.5})

        
    
end
--------------------------------------------------------------------------------------------------------------------- NOW IT'S JUST DISARM
modifier_maki_strangulate_slow = class({})
function modifier_maki_strangulate_slow:IsHidden() return false end
function modifier_maki_strangulate_slow:IsDebuff() return true end
function modifier_maki_strangulate_slow:IsPurgable() return true end

function modifier_maki_strangulate_slow:IsPurgeException() return true end

function modifier_maki_strangulate_slow:RemoveOnDeath() return true end
function modifier_maki_strangulate_slow:CheckState()
    local state = { [MODIFIER_STATE_DISARMED] = true,}
    return state
end
function modifier_maki_strangulate_slow:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}
    return func
end
function modifier_maki_strangulate_slow:GetModifierMoveSpeedBonus_Percentage()
    return 0--self:GetAbility():GetSpecialValueFor("slow")
end
function modifier_maki_strangulate_slow:GetEffectName()
    return "particles/units/heroes/hero_windrunner/windrunner_windrun_slow.vpcf"
end
function modifier_maki_strangulate_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
---------------------------------------------------------------------------------------------------------------------
modifier_maki_strangulate_dash = class({})
function modifier_maki_strangulate_dash:IsHidden() return true end
function modifier_maki_strangulate_dash:IsDebuff() return false end
function modifier_maki_strangulate_dash:IsPurgable() return false end
function modifier_maki_strangulate_dash:IsPurgeException() return false end
function modifier_maki_strangulate_dash:RemoveOnDeath() return true end
function modifier_maki_strangulate_dash:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_maki_strangulate_dash:CheckState()
    local state = { [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    --[MODIFIER_STATE_DISARMED] = true,
                    --[MODIFIER_STATE_SILENCED] = true,
                    --[MODIFIER_STATE_MUTED] = true,
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true, }

    if self.target and not self.target:IsNull() and self.target:HasFlyMovementCapability() then
        state[MODIFIER_STATE_FLYING] = true
    else
        state[MODIFIER_STATE_FLYING] = false
    end
    
    return state
end
function modifier_maki_strangulate_dash:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_OVERRIDE_ANIMATION, }
    return funcs
end
function modifier_maki_strangulate_dash:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_maki_strangulate_dash:OnCreated(table)
    if IsServer() then
        self.target = self:GetAbility():GetCursorTarget()
       
        self.speed = self:GetAbility():GetSpecialValueFor("speed")

        self.latch_offset = 150--(self.target:GetHullRadius() + self:GetParent():GetHullRadius())

        EmitSoundOn("Accel.vector2", self:GetParent())

        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
    end
end
function modifier_maki_strangulate_dash:OnDestroy()
    if IsServer() then
        self:GetParent():InterruptMotionControllers(true)

        if self.strangle then
            --self:GetAbility().strangle = true

            --self:GetParent():SetCursorCastTarget(self.target)
            --self:GetAbility():SetOverrideCastPoint(0)
            --self:GetParent():CastAbilityOnTarget(self.target, self:GetAbility(), self:GetParent():GetPlayerID())
            --self:GetAbility():OnSpellStart()
            --self:GetAbility():SetChanneling(true)
            --print(self:GetAbility():IsChanneling())
            --self:GetAbility():EndChannel(false)
            --self:GetAbility():CastAbility()

            --self:GetParent():CastAbilityImmediately(self:GetAbility(), self:GetParent():GetPlayerOwnerID())
        end
    end
end
function modifier_maki_strangulate_dash:UpdateHorizontalMotion(me, dt)
    local UFilter = UnitFilter( self.target,
                                self:GetAbility():GetAbilityTargetTeam(),
                                self:GetAbility():GetAbilityTargetType(),
                                self:GetAbility():GetAbilityTargetFlags(),
                                self:GetParent():GetTeamNumber() )

    if UFilter ~= UF_SUCCESS then
        self:Destroy()
        return nil
    end

    if (self.target:GetOrigin()-self:GetParent():GetOrigin()):Length2D() < self.latch_offset then
        self:StrangulatePos(me, dt)

        self:Destroy()
        return nil
    end

    self:Charge(me, dt)
end
function modifier_maki_strangulate_dash:StrangulatePos(me, dt)
    local point = self.target:GetOrigin() + self.target:GetForwardVector() * self.latch_offset

    self.strangle = true

    self:GetParent():SetOrigin(point)
    self.target:SetForwardVector((point - self.target:GetOrigin()):Normalized())
    self:GetParent():SetForwardVector((self.target:GetOrigin() - point):Normalized())
    --self:GetParent():FaceTowards(self.target:GetOrigin())
    --self.target:FaceTowards(self:GetParent():GetOrigin())
end
function modifier_maki_strangulate_dash:Charge(me, dt)
    if self:GetParent():IsStunned() then
        return nil
    end

    local pos = self:GetParent():GetOrigin()
    local targetpos = self.target:GetOrigin()

    local direction = targetpos - pos
    direction.z = 0     
    local target = pos + direction:Normalized() * (self.speed*dt)

    self:GetParent():SetOrigin(target)
    self:GetParent():FaceTowards(targetpos)
end
function modifier_maki_strangulate_dash:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_maki_strangulate_dash:GetEffectName()
    return ""
end
function modifier_maki_strangulate_dash:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function maki_strangulate:PlayEffects( target, success )
	-- Get Resources
	local particle_cast = ""
	local sound_cast = ""
	if success then
		particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
		sound_cast = ""
	else
		particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade.vpcf"
		sound_cast = ""
	end

	-- load data
	local direction = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
	ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
	-- assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_color"))(self,effect_target)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end