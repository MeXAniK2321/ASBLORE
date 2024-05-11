x_burner = x_burner or class({})

function x_burner:IsStealable() return true end
function x_burner:IsHiddenWhenStolen() return false end
function x_burner:GetIntrinsicModifierName()
    return "modifier_x_burner_charges"
end
function x_burner:OnAbilityPhaseStart()
    self:GetCaster():SetSingleMeshGroup("2")
	
    self.launcher_charge_fx = 	ParticleManager:CreateParticle("particles/phoenix_sunray_left.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
                                ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 0, self:GetCaster(), 5, "attach_left_arm", Vector(0,0,0), true)
                                ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 1, self:GetCaster(), 5, "attach_left_arm", Vector(0,0,0), true)
    return true
end
function x_burner:OnAbilityPhaseInterrupted()
    caster:SetSingleMeshGroup("1")

    if self.launcher_charge_fx then
        ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
        ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
    end
end
function x_burner:OnSpellStart()
    local caster = self:GetCaster()

    EmitSoundOn("x_burner.1", caster)

    self.launcher_damage = self:GetSpecialValueFor("launcher_damage") 
    self.launcher_damage = self.launcher_damage / self:GetChannelTime() or 1
end
function x_burner:OnChannelFinish(bInterrupted)
    local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_AMBUSH)

    EmitSoundOn("x_burner.2", caster)

    if self.launcher_charge_fx then
        ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
        ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
    end

    if bInterrupted then
        caster:Interrupt()
    end
    
    local delay = FrameTime() * 8
    local start_loc = caster:GetAbsOrigin() + caster:GetForwardVector() * 250
    local bonus_delay = delay * 3
    local end_delay = bonus_delay + 1
    local hits = 10

    self.launcher_damage = self.launcher_damage * (GameRules:GetGameTime() - self:GetChannelStartTime())
    
    if caster:HasShard() then
        self.launcher_damage = self.launcher_damage * 0.5
    end

    local width = self:GetSpecialValueFor("launcher_width")
    local distance = self:GetCastRange(caster:GetAbsOrigin(),caster) + caster:GetCastRangeBonus()

    local cero_particle = "particles/phoenix_sunray_right.vpcf"
    local cero_particle_end = "particles/phoenix_sunray_energy_right.vpcf"
    local pfx = ParticleManager:CreateParticle(cero_particle, PATTACH_WORLDORIGIN, nil )
    local pfx_end = ParticleManager:CreateParticle(cero_particle_end, PATTACH_WORLDORIGIN, nil )
    local attach_point = caster:ScriptLookupAttachment("attach_right_arm")
    local duration_kek = hits * (bonus_delay * 0.1)

    ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
    ParticleManager:SetParticleControl(pfx_end, 0, caster:GetAttachmentOrigin(attach_point))

    local endcapPos = caster:GetAbsOrigin() + caster:GetForwardVector() * distance
	
    GridNav:DestroyTreesAroundPoint(endcapPos, width, false)

    endcapPos = GetGroundPosition( endcapPos, nil )
    endcapPos.z = endcapPos.z + 184

    ParticleManager:SetParticleControl( pfx, 1, endcapPos )
    ParticleManager:SetParticleControl( pfx, 12, Vector( duration_kek, 0, 0 ) )
    ParticleManager:SetParticleControl( pfx, 13, Vector( duration_kek, 0, 0 ) )
    ParticleManager:SetParticleControl( pfx, 14, Vector( width, 0, 0 ) )
    --ParticleManager:SetParticleFoWProperties( pfx, 0, 1, 99999 )
    ParticleManager:SetParticleControl( pfx_end, 3, endcapPos ) --IN ir EndCap your effect
    
    -- Why is this so cringe ? Make tests later to solve it...
    for iTeamNumber = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
        AddFOWViewer(iTeamNumber, caster:GetAttachmentOrigin(attach_point), 255, duration_kek, false)
        AddFOWViewer(iTeamNumber, endcapPos, 255, duration_kek, false)
    end
	
    Timers:CreateTimer(0, function()
        local enemies = FindUnitsInLine(caster:GetTeamNumber(),
                                        start_loc,
                                        endcapPos,
                                        nil,
                                        width,
                                        self:GetAbilityTargetTeam(),
                                        self:GetAbilityTargetType(),
                                        self:GetAbilityTargetFlags() )
		
        for _,enemy in pairs(enemies) do
            local damage_table = {	victim = enemy,
                                    attacker = caster,
                                    damage = self.launcher_damage * 0.1,
                                    damage_type = self:GetAbilityDamageType(),
                                    ability = self }
                                    
            AddFOWViewer(caster:GetTeamNumber(), enemy:GetOrigin(), 255, 0.1, false)

            ApplyDamage(damage_table)

            EmitSoundOn("x_burner.3", enemy)		
        end
        --print("damage done ".. hits)
        if hits > 0 then
            hits = hits - 1
            return bonus_delay * 0.1
        end
        
        --ParticleManager:DestroyParticle( pfx, true )
        ParticleManager:ReleaseParticleIndex( pfx )
        
        ParticleManager:DestroyParticle( pfx_end, true )
        ParticleManager:ReleaseParticleIndex( pfx_end )
    end)
end


LinkLuaModifier( "modifier_x_burner_charges", "heroes/x_burner.lua", LUA_MODIFIER_MOTION_NONE )

modifier_x_burner_charges = modifier_x_burner_charges or class({})

function modifier_x_burner_charges:IsHidden() return not self:GetCaster():HasShard() end
function modifier_x_burner_charges:IsDebuff() return false end
function modifier_x_burner_charges:IsPurgable() return false end
function modifier_x_burner_charges:DestroyOnExpire() return false end
function modifier_x_burner_charges:RemoveOnDeath() return false end
function modifier_x_burner_charges:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_x_burner_charges:DeclareFunctions()
    local funcs = {
                      MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
                  }

    return funcs
end
function modifier_x_burner_charges:OnCreated( kv )
    self.max_charges = 2
    self.charge_time = self:GetAbility() and self:GetAbility():GetCooldown(-1)

    if not IsServer() then return end
    self:SetStackCount( self.max_charges )
    self:CalculateCharge()
end
function modifier_x_burner_charges:OnRefresh( kv )
    self.max_charges = 2
    self.charge_time = 10

    if not IsServer() then return end
    self:CalculateCharge()
end
function modifier_x_burner_charges:OnDestroy( kv )
end
function modifier_x_burner_charges:OnAbilityFullyCast( params )
	if IsServer() then
        local ability = self:GetParent():FindAbilityByName("x_burner")
        if params.unit==self:GetParent() and params.ability:GetAbilityName() == "item_refresher" then
            self:SetStackCount( self.max_charges )
            self:SetDuration( -1 , true )
            self:StartIntervalThink( -1 )
            --print(params.ability:GetAbilityName())
        end
        
        if params.unit~=self:GetParent() or params.ability~=ability or not self:GetParent():HasShard() then
            return
        end

        self:DecrementStackCount()
        self:CalculateCharge()
    end
end
function modifier_x_burner_charges:GetTexture()
    return "x-burner"
end
function modifier_x_burner_charges:OnIntervalThink()
    self:SetStackCount( self.max_charges )
    self:StartIntervalThink(-1)
    self:CalculateCharge()
end

function modifier_x_burner_charges:CalculateCharge()
    local ability = self:GetParent():FindAbilityByName("x_burner")
    if self:GetParent():HasShard() then
        ability:EndCooldown()
    end
    if self:GetStackCount()>=self.max_charges then
        self:SetDuration( -1, false )
        self:StartIntervalThink( -1 )
    else
        if self:GetRemainingTime() <= 0.05 then
            local charge_time = ability:GetCooldown( -1 )
            if self.charge_time and self:GetParent():HasShard() then
                charge_time = self.charge_time * self:GetParent():GetCooldownReduction()
            end
            self:StartIntervalThink( charge_time )
            self:SetDuration( charge_time, true )
        end

        -- set on cooldown if no charges
        if self:GetStackCount()==0 then
            ability:StartCooldown( self:GetRemainingTime() )
        end
    end
end
