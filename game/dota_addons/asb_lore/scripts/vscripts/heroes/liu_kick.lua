LinkLuaModifier("modifier_liu_kick", "heroes/liu_kick", LUA_MODIFIER_MOTION_HORIZONTAL)

liu_kick = liu_kick or class({})

function liu_kick:IsStealable() return true end
function liu_kick:IsHiddenWhenStolen() return false end
--function liu_kick:IsHiddenAbilityCastable() return true end
function liu_kick:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function liu_kick:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local damage = self:GetSpecialValueFor("damage")
    
	if target:TriggerSpellAbsorb(self) then
        self.TriggerSpellAbsorb = true
        caster:Interrupt()
        return nil
    end
	
	caster:AddNewModifier(caster, self, "modifier_liu_kick", {damage = damage})
    EmitSoundOn("miku.3_"..RandomInt(1, 3), self:GetCaster())
end
   


---------------------------------------------------------------------------------------------------------------------
modifier_liu_kick = modifier_liu_kick or class({})
function modifier_liu_kick:IsHidden() return true end
function modifier_liu_kick:IsDebuff() return false end
function modifier_liu_kick:IsPurgable() return false end
function modifier_liu_kick:IsPurgeException() return false end
function modifier_liu_kick:RemoveOnDeath() return true end
function modifier_liu_kick:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_liu_kick:CheckState()
    local state = { [MODIFIER_STATE_NO_UNIT_COLLISION] = true,                  
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true, }

    if self.target and not self.target:IsNull() and self.target:HasFlyMovementCapability() then
        state[MODIFIER_STATE_FLYING] = true
    else
        state[MODIFIER_STATE_FLYING] = false
    end
    
    return state
end
function modifier_liu_kick:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_OVERRIDE_ANIMATION, }
    return funcs
end
function modifier_liu_kick:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_liu_kick:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.target = self.ability:GetCursorTarget()
        self.damage = hTable.damage
        self.speed = self.ability:GetSpecialValueFor("speed")
        self.range_knockback = self.ability:GetSpecialValueFor("range_knockback")
        self.latch_offset = 150


        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
    end
end
function modifier_liu_kick:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_liu_kick:OnDestroy()
    if IsServer() then
        self.parent:InterruptMotionControllers(true)
    end
end
function modifier_liu_kick:UpdateHorizontalMotion(me, dt)
    local UFilter = UnitFilter( self.target,
                                self.ability:GetAbilityTargetTeam(),
                                self.ability:GetAbilityTargetType(),
                                self.ability:GetAbilityTargetFlags(),
                                self.parent:GetTeamNumber() )

    if UFilter ~= UF_SUCCESS then
        self:Destroy()

        return nil
    end

    if (self.target:GetOrigin() - self.parent:GetOrigin()):Length2D() < self.latch_offset then
        self:PlayEffects()

        self:Destroy()
        return nil
    end

    self:Charge(me, dt)
end
function modifier_liu_kick:PlayEffects()
    local position = self.target:GetAbsOrigin()
    local damage = self.damage+ self:GetCaster():FindTalentValue("special_bonus_miku_25")       
    
    --[[local beam_fx = ParticleManager:CreateParticle("particles/heroes/anime_hero_kizaru/liu_kick.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                    ParticleManager:SetParticleControl(beam_fx, 0, self.parent:GetAbsOrigin())
                    ParticleManager:SetParticleControl(beam_fx, 1, position)
                    ParticleManager:SetParticleControlEnt(  beam_fx,
                                                            9,
                                                            self.parent,
                                                            PATTACH_POINT_FOLLOW,
                                                            "attach_foot2",
                                                            Vector(0,0,0),
                                                            true)

                    ParticleManager:ReleaseParticleIndex(beam_fx)]]

    local particle_name = not IsASBPatreon(self.parent)
	                      and "particles/miku_3_exp.vpcf"
						  or "particles/miku_3_exp_kizuna_ai.vpcf"
	local hit_fx =  ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.parent)
                    ParticleManager:SetParticleControlEnt(  hit_fx, 
                                                            0, 
                                                            self.target, 
                                                            PATTACH_ABSORIGIN_FOLLOW, 
                                                            "attach_hitloc", 
                                                            self.target:GetAbsOrigin(), 
                                                            true)

                    ParticleManager:ReleaseParticleIndex(hit_fx)

    local knockback = { should_stun = 0,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = self.range_knockback,
                        knockback_height = 0,
                        center_x = self.parent:GetAbsOrigin().x,
                        center_y = self.parent:GetAbsOrigin().y,
                        center_z = self.parent:GetAbsOrigin().z }

    self.target:AddNewModifier(self.parent, self.ability, "modifier_knockback", knockback)


    local enemies = FindUnitsInRadius(  self.parent:GetTeamNumber(),
                                        position,
                                        nil,
                                        self.ability:GetAOERadius(),
                                        self.ability:GetAbilityTargetTeam(),
                                        self.ability:GetAbilityTargetType(),
                                        self.ability:GetAbilityTargetFlags(),
                                        FIND_ANY_ORDER,
                                        false)

    local blow_fx =     ParticleManager:CreateParticle("", PATTACH_CUSTOMORIGIN, self.parent)
                        ParticleManager:SetParticleControl(blow_fx, 0, position)
                        --[[ParticleManager:SetParticleControlEnt(  blow_fx,
                                                                0,
                                                                self.target,
                                                                PATTACH_POINT_FOLLOW,
                                                                "attach_hitloc",
                                                                Vector(0,0,0),
                                                                true)]]
                        ParticleManager:ReleaseParticleIndex(blow_fx)

    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() and IsValidEntity(enemy) then

            --enemy:AddNewModifier(caster, self, "modifier_liu_kick_disarm", {duration = self:GetSpecialValueFor("duration")})

            local damage_table = {  victim = enemy,
                                    attacker = self.parent,
                                    damage = damage,
                                    damage_type = self.ability:GetAbilityDamageType(),
                                    ability = self.ability,
									}

            ApplyDamage(damage_table)
        end
		self:GetCaster():PerformAttack (
		enemy,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)
    end

    EmitSoundOnLocationWithCaster(position, "miku.2", self.parent)
end
function modifier_liu_kick:Charge(me, dt)
    if self.parent:IsStunned() then
        return nil
    end

    local pos = self.parent:GetOrigin()
    local targetpos = self.target:GetOrigin()

    local direction = targetpos - pos
    direction.z = 0     
    local target = pos + direction:Normalized() * (self.speed * dt)

    self.parent:SetOrigin(target)
    self.parent:FaceTowards(targetpos)
end
function modifier_liu_kick:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
        self.parent:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
    end
end
