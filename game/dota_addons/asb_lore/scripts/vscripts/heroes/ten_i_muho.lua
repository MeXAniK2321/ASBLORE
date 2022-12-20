LinkLuaModifier("modifier_ten_i_muho", "heroes/ten_i_muho", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_rakudai_kishi", "heroes/ikki", LUA_MODIFIER_MOTION_NONE)



ten_i_muho = class({})
function ten_i_muho:GetIntrinsicModifierName()
    return "modifier_rakudai_kishi"
end

function ten_i_muho:IsStealable() return true end
function ten_i_muho:IsHiddenWhenStolen() return false end
--function ten_i_muho:IsHiddenAbilityCastable() return true end
function ten_i_muho:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function ten_i_muho:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local damage = self:GetSpecialValueFor("damage")
    if target:TriggerSpellAbsorb(self) then
        self.TriggerSpellAbsorb = true
        
        caster:Interrupt()
        
        return nil
    end

   
    
																	
caster:AddNewModifier(caster, self, "modifier_ten_i_muho", {damage = damage})
    EmitSoundOn("ikki.swoosh", self:GetCaster())

    
        end
   


---------------------------------------------------------------------------------------------------------------------
modifier_ten_i_muho = class({})
function modifier_ten_i_muho:IsHidden() return true end
function modifier_ten_i_muho:IsDebuff() return false end
function modifier_ten_i_muho:IsPurgable() return false end
function modifier_ten_i_muho:IsPurgeException() return false end
function modifier_ten_i_muho:RemoveOnDeath() return true end
function modifier_ten_i_muho:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_ten_i_muho:CheckState()
    local state = { [MODIFIER_STATE_NO_UNIT_COLLISION] = true,                  
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true, }

    if self.target and not self.target:IsNull() and self.target:HasFlyMovementCapability() then
        state[MODIFIER_STATE_FLYING] = true
    else
        state[MODIFIER_STATE_FLYING] = false
    end
    
    return state
end
function modifier_ten_i_muho:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_OVERRIDE_ANIMATION, }
    return funcs
end
function modifier_ten_i_muho:GetOverrideAnimation()
    return ACT_DOTA_CAST_ABILITY_6
end
function modifier_ten_i_muho:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.target = self.ability:GetCursorTarget()
        
        self.damage = hTable.damage
        self.speed = self.ability:GetSpecialValueFor("speed")
		self.duration = self.ability:GetSpecialValueFor("duration")

        self.range_knockback = self.ability:GetSpecialValueFor("range_knockback")

        self.latch_offset = 150


        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
    end
end
function modifier_ten_i_muho:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_ten_i_muho:OnDestroy()
    if IsServer() then
        self.parent:InterruptMotionControllers(true)

        
    end
end
function modifier_ten_i_muho:UpdateHorizontalMotion(me, dt)
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
function modifier_ten_i_muho:PlayEffects()
    local position = self.target:GetAbsOrigin()
    local damage = self.damage+ self:GetCaster():FindTalentValue("special_bonus_ikki_25")       
    
    --[[local beam_fx = ParticleManager:CreateParticle("particles/heroes/anime_hero_kizaru/ten_i_muho.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
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

    local hit_fx =  ParticleManager:CreateParticle("particles/ikki_ten_i_muho_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                    ParticleManager:SetParticleControlEnt(  hit_fx, 
                                                            0, 
                                                            self.target, 
                                                            PATTACH_ABSORIGIN_FOLLOW, 
                                                            "attach_hitloc", 
                                                            self.target:GetAbsOrigin(), 
                                                            true)

                    ParticleManager:ReleaseParticleIndex(hit_fx)

  
    self.target:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = self.duration})


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

            --enemy:AddNewModifier(caster, self, "modifier_ten_i_muho_disarm", {duration = self:GetSpecialValueFor("duration")})

            local damage_table = {  victim = enemy,
                                    attacker = self.parent,
                                    damage = damage,
                                    damage_type = self.ability:GetAbilityDamageType(),
                                    ability = self.ability}

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

    EmitSoundOnLocationWithCaster(position, "ikki.ten_i_muho_strike", self.parent)
end
function modifier_ten_i_muho:Charge(me, dt)
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
function modifier_ten_i_muho:GetEffectName()
	return "particles/ikki_ten_i_muho.vpcf"
end

function modifier_ten_i_muho:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_ten_i_muho:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end