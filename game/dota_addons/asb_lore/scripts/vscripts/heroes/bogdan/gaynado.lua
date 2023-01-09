gaynado = class({})
LinkLuaModifier("modifier_gaynado", "heroes/bogdan/gaynado", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gaynado_pull", "heroes/bogdan/gaynado", LUA_MODIFIER_MOTION_HORIZONTAL)

function gaynado:IsStealable() return true end
function gaynado:IsHiddenWhenStolen() return false end
function gaynado:GetAOERadius()
    return self:GetSpecialValueFor("pull_radius")
end
function gaynado:OnAbilityPhaseStart()

  EmitSoundOn("bogdan.gaynado"..RandomInt(1, 1), self:GetCaster())
    return true
end

function gaynado:OnAbilityPhaseInterrupted()
    for i = 1, 1 do
        StopSoundOn("bogdan.gaynado"..i, self:GetCaster())
		
    end
	StopSoundOn("hurk.gaynado"..i, self:GetCaster())
end
function gaynado:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
	
if IsASBPatreon(caster) then
	EmitSoundOn("hurk.arcana_gaynado", caster)
	else
EmitSoundOn("bogdan.gaynado", caster)
end
    caster:AddNewModifier(caster, self, "modifier_gaynado", {duration = duration})
	
end
---------------------------------------------------------------------------------------------------------------------
modifier_gaynado = class({})
function modifier_gaynado:IsHidden() return false end
function modifier_gaynado:IsDebuff() return false end
function modifier_gaynado:IsPurgable() return false end
function modifier_gaynado:IsPurgeException() return false end
function modifier_gaynado:RemoveOnDeath() return true end
function modifier_gaynado:IsAura() return true end
function modifier_gaynado:IsAuraActiveOnDeath() return false end
function modifier_gaynado:GetAuraEntityReject(hEntity)
    if IsServer() then
        if not self.parent:IsNull() and not hEntity:IsNull() then
            if (self.parent:GetAbsOrigin() - hEntity:GetAbsOrigin()):Length2D() <= 100 then
                --return true
            end
        end
    end
end
function modifier_gaynado:CheckState()
    local state = { [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
[MODIFIER_STATE_SILENCED] = true,	}

    if self.parent and not self.parent:IsNull()  then
        state[MODIFIER_STATE_DISARMED] = true
    end

    if self.parent and not self.parent:IsNull() and not self.parent:IsAlive() then
        self:Destroy()
    end

    return state
end
function modifier_gaynado:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                    MODIFIER_EVENT_ON_DEATH, }
    return func
end
function modifier_gaynado:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
--[[function modifier_gaynado:OnDeath(keys)
    if IsServer() then
        if not keys.unit:IsNull() and keys.unit == self.parent then
            self:Destroy()
        end
    end
end]]
function modifier_gaynado:GetAuraRadius()
    return self.pull_radius
end
function modifier_gaynado:GetAuraDuration()
    return 0.03
end
function modifier_gaynado:GetAuraSearchType()
    return self.ability:GetAbilityTargetType()
end
function modifier_gaynado:GetAuraSearchTeam()
    return self.ability:GetAbilityTargetTeam()
end
function modifier_gaynado:GetAuraSearchFlags()
    return self.ability:GetAbilityTargetFlags()
end
function modifier_gaynado:GetModifierAura()
    return "modifier_gaynado_pull"
end
function modifier_gaynado:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.damage_radius  = self.ability:GetSpecialValueFor("damage_radius")
    self.damage_per_sec = self.ability:GetSpecialValueFor("damage_per_sec")
    self.damage_interval = self.ability:GetSpecialValueFor("damage_interval")

    self.pull_radius    = self.ability:GetAOERadius()


    self.damage_per_sec = self.damage_per_sec * self.damage_interval

    if IsServer() then


        if not self.spin_fx then
		local caster = self:GetCaster()
if IsASBPatreon(caster) then
	self.spin_fx =  ParticleManager:CreateParticle("particles/hurk_gaynado.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                            ParticleManager:SetParticleControl(self.spin_fx, 0, self.parent:GetAbsOrigin())
                            ParticleManager:SetParticleControl(self.spin_fx, 1, Vector(self.pull_radius * (self.parent:GetModelScale() + 0.4), 0, 0))

            self:AddParticle(self.spin_fx, false, false, -1, false, false)
	else
            
            self.spin_fx =  ParticleManager:CreateParticle("particles/gaynado.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                            ParticleManager:SetParticleControl(self.spin_fx, 0, self.parent:GetAbsOrigin())
                            ParticleManager:SetParticleControl(self.spin_fx, 1, Vector(self.pull_radius * (self.parent:GetModelScale() + 0.4), 0, 0))

            self:AddParticle(self.spin_fx, false, false, -1, false, false)
        end
		end

        self:StartIntervalThink(self.damage_interval)
    end
end
function modifier_gaynado:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_gaynado:OnIntervalThink()
    if IsServer() then
	if self:GetCaster():HasModifier("modifier_bogdan_chill") then
	else
        local enemies = FindUnitsInRadius(  self.parent:GetTeamNumber(), 
                                            self.parent:GetAbsOrigin(), 
                                            nil, 
                                            self.damage_radius, 
                                            self.ability:GetAbilityTargetTeam(), 
                                            self.ability:GetAbilityTargetType(), 
                                            self.ability:GetAbilityTargetFlags(), 
                                            FIND_ANY_ORDER, 
                                            false)

        for _, enemy in pairs(enemies) do
            if not enemy:IsNull() then
                local slash_pfx =   ParticleManager:CreateParticle("", PATTACH_ABSORIGIN_FOLLOW, enemy)
                                    ParticleManager:SetParticleControlEnt(slash_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
                                    ParticleManager:ReleaseParticleIndex(slash_pfx)

           

                local damage_table = {  victim      = enemy,
                                        attacker    = self.caster,
                                        damage      = self.damage_per_sec,
                                        damage_type = self.ability:GetAbilityDamageType(),
                                        ability     = self.ability }

                ApplyDamage(damage_table)
            end
        end
    end
end
end
function modifier_gaynado:OnDestroy()
    if IsServer() then
        StopSoundOn("bogdan.gaynado", self.parent)
		StopSoundOn("hurk.arcana_gaynado", self.parent)
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_gaynado_pull = class({})
function modifier_gaynado_pull:IsHidden() return false end
function modifier_gaynado_pull:IsDebuff() return true end
function modifier_gaynado_pull:IsPurgable() return true end
function modifier_gaynado_pull:IsPurgeException() return true end
function modifier_gaynado_pull:RemoveOnDeath() return true end
function modifier_gaynado_pull:GetPriority() return MODIFIER_PRIORITY_NORMAL end
function modifier_gaynado_pull:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end
function modifier_gaynado_pull:CheckState()
    local state = { --[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_DISARMED] = true, }

    if not self.parent:IsNull() and self.pull_leash then
        state[MODIFIER_STATE_TETHERED] = true
    end

    return state
end
--[[function modifier_gaynado_pull:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_OVERRIDE_ANIMATION,}
    return funcs
end
function modifier_gaynado_pull:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end]]
function modifier_gaynado_pull:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    self.pull_speed     = self.ability:GetSpecialValueFor("pull_speed") * 0.2
    self.pull_leash     = 1 <= ( self.ability:GetSpecialValueFor("pull_leash") )
    
    if IsServer() then
        self.rotate_speed = 1--self.ability:GetSpecialValueFor("rotate_speed")

        --[[if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end]]
        self:StartIntervalThink(FrameTime())
    end
end
function modifier_gaynado_pull:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_gaynado_pull:OnIntervalThink()
    if IsServer() then
        self:UpdateHorizontalMotion(self.parent, FrameTime())
    end
end
function modifier_gaynado_pull:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        self:Charge(me, dt)
    end
end
function modifier_gaynado_pull:Charge(me, dt)
    if IsServer() then
        self.center = self.caster:GetAbsOrigin()

        -- get vector
        local target = self.parent:GetAbsOrigin() - self.center
        target.z = 0

        -- reduce length by pull speed
        local targetL = target:Length2D() - self.pull_speed*dt
        self.targetLSpec = targetL

        -- rotate by rotate speed
        local targetN = target:Normalized()
        local deg = math.atan2( targetN.y, targetN.x )
        local targetN = Vector( math.cos(deg + self.rotate_speed * dt), math.sin(deg + self.rotate_speed * dt), 0 );

        local move_loc = self.center + targetN * targetL
        local max_distance = target:Length2D()
        local PathLength = GridNav:FindPathLength(self.parent:GetAbsOrigin(), move_loc)
        if not GridNav:IsTraversable(move_loc) or GetGroundHeight(move_loc, self.parent) ~= GetGroundHeight(self.center, self:GetAuraOwner()) or PathLength == -1 or PathLength > max_distance then
            self.targetLSpec = self.targetLSpec - 10
        end

        self.parent:SetOrigin( self.center + targetN * self.targetLSpec )
    end
end
function modifier_gaynado_pull:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_gaynado_pull:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end
        --self.parent:InterruptMotionControllers(true)
    end
end