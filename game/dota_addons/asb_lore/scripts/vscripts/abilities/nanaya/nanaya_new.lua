
LinkLuaModifier("modifier_nanaya_knife_set", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)


modifier_nanaya_knife_set = modifier_nanaya_knife_set or class({})

function modifier_nanaya_knife_set:OnCreated()
end

---------------------------------------------------------------------------------------------------------------
-- Nanaya Clones
---------------------------------------------------------------------------------------------------------------
nanaya_clones = nanaya_clones or class({})

function nanaya_clones:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()

    local hKnockBackTable = { 
                              should_stun = true,
                              knockback_duration = 0.1,
                              duration = 0.15,
                              knockback_distance = 200,
                              knockback_height = 0,
                              center_x = hTarget:GetAbsOrigin().x - hCaster:GetForwardVector().x * 180,
                              center_y = hTarget:GetAbsOrigin().y - hCaster:GetForwardVector().y * 180,
                              center_z = hTarget:GetAbsOrigin().z 
                            }								
    hTarget:EmitSound("nanaya.slash")
	hTarget:AddNewModifier(hCaster, self, "modifier_knockback", hKnockBackTable)
end


---------------------------------------------------------------------------------------------------------------
-- Nanaya Dash (Q)
---------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_q_nanaya", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_nanaya_dash_invis", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)


jump_nanaya = jump_nanaya or class({})

function jump_nanaya:OnSpellStart()
    local caster = self:GetCaster() 
	caster:EmitSound("nanaya.jumpforward")
	
    local jump = ParticleManager:CreateParticle("particles/blink.vpcf", PATTACH_CUSTOMORIGIN, caster)
	             ParticleManager:SetParticleControl(jump, 0, caster:GetAbsOrigin() + caster:GetForwardVector())
	             ParticleManager:SetParticleControl(jump, 4, self:GetCursorPosition())
	
    local blink_target = self:GetCursorPosition()
	
	local dist = self:GetSpecialValueFor("distance")
	if (blink_target - caster:GetAbsOrigin()):Length2D() > dist then 
		blink_target = caster:GetAbsOrigin() + (((blink_target - caster:GetAbsOrigin()):Normalized()) * dist)
	end
	FindClearSpaceForUnit(caster, blink_target , true) 
end

nanaya_q_strike = nanaya_q_strike or class({})

function nanaya_q_strike:OnSpellStart()
	local caster = self:GetCaster()
	local check = caster:GetAnglesAsVector():Normalized()
	local check2 = caster:GetForwardVector()
	local targetpoint = self:GetCursorTarget()
	caster:AddNewModifier(caster, self, "modifier_q_nanaya", {duration = 2})
	
    local jump = ParticleManager:CreateParticle("particles/blink.vpcf", PATTACH_CUSTOMORIGIN, caster)
	             ParticleManager:SetParticleControl(jump, 0, caster:GetAbsOrigin() + caster:GetForwardVector()*-90)
	
	local jump2 = ParticleManager:CreateParticle("particles/shiki_blink_after.vpcf", PATTACH_CUSTOMORIGIN, caster)
	              ParticleManager:SetParticleControl(jump2, 0, GetGroundPosition(caster:GetAbsOrigin()+ caster:GetForwardVector():Normalized()*-250, nil))
	              ParticleManager:SetParticleControl(jump2, 4, caster:GetAbsOrigin())
	caster:EmitSound("nanaya.jumpforward")
	
	if caster:HasTalent("special_bonus_nanaya_20l") then
        local hTalent = caster:FindAbilityByName("special_bonus_nanaya_20l")
        if hTalent
            and IsNotNull(hTalent) then
            local fDuration = hTalent:GetSpecialValueFor("value3") or 1

            caster:AddNewModifier(caster, self, "modifier_nanaya_dash_invis", {duration = fDuration})
        end
    end
    print (check)
	print (check2)
end
function nanaya_q_strike:OnUpgrade()
	local hCaster = self:GetCaster()
    
    if hCaster:FindAbilityByName("nanaya_q2jump"):GetLevel() ~= self:GetLevel() then
        hCaster:FindAbilityByName("nanaya_q2jump"):SetLevel(self:GetLevel())
    end
end

modifier_q_nanaya = modifier_q_nanaya or class({})

function modifier_q_nanaya:IsHidden() return false end
function modifier_q_nanaya:IsDebuff() return true end
function modifier_q_nanaya:RemoveOnDeath() return true end
function modifier_q_nanaya:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_q_nanaya:CheckState()
    local state = { 
                    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	                [MODIFIER_STATE_COMMAND_RESTRICTED] = true, 
                  }
	
    if self.target and not self.target:IsNull() and self.target:HasFlyMovementCapability() then
        state[MODIFIER_STATE_FLYING] = true
    else
        state[MODIFIER_STATE_FLYING] = false
    end
    
    return state
end
function modifier_q_nanaya:OnCreated(args)
    self.parent = self:GetParent()
    self.ability = self:GetAbility()	
    self.speed = 2800
    self.caster = self:GetCaster()
	
    if IsServer() then
        self.target = self.ability:GetCursorTarget()
        self.targetpos = self.target:GetAbsOrigin()
        self.parent:StartGestureWithPlaybackRate(ACT_SCRIPT_CUSTOM_15, 1)
		
        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
	end
end
function modifier_q_nanaya:UpdateHorizontalMotion(me, dt)
	local UFilter = UnitFilter( self.target,
                                self.ability:GetAbilityTargetTeam(),
                                self.ability:GetAbilityTargetType(),
                                self.ability:GetAbilityTargetFlags(),
                                self.parent:GetTeamNumber() )

    if UFilter ~= UF_SUCCESS then
        self:Destroy()

        return nil
    end
	
	if (self.targetpos - self.target:GetAbsOrigin()):Length2D() > 300 then
		self:Destroy()
		
		return nil
	end
	
	self.targetpos = self.target:GetAbsOrigin() 
	
	if (self.target:GetOrigin() - self.parent:GetOrigin()):Length2D() < 150 then
		self:hit()
		self:Destroy()
		
		return nil
	end
	self:dash(me, dt)
end
function modifier_q_nanaya:hit()
    self.fDamage = self.ability:GetSpecialValueFor("dmg")
    self.fAgiScale = self.ability:GetSpecialValueFor("agi_scale") or 4
    self.fAgiTalentScale = 0
    
    if self:GetCaster():HasTalent("special_bonus_nanaya_20l") then
        local hTalent = self:GetCaster():FindAbilityByName("special_bonus_nanaya_20l")
        
        if hTalent
            and IsNotNull(hTalent) then
            self.fAgiTalentScale = hTalent:GetSpecialValueFor("value2") or 2
            self.fDamage = self.fDamage + self:GetCaster():FindTalentValue("special_bonus_nanaya_20l")
        end
    end
    
	self.dmg = self.fDamage + math.floor(self:GetCaster():GetAgility() * (self.fAgiScale + self.fAgiTalentScale))
	
    ApplyDamage({
                    victim = self.target,
                    attacker = self.parent,
                    damage = self.dmg,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    damage_flags = 1024,
                    ability = self.ability
                })
	self.target:EmitSound("nanaya.slash")
	
    local effect_cast = ParticleManager:CreateParticle( "particles/justcheck.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
	                    ParticleManager:SetParticleControlEnt(
		                                                       effect_cast,
		                                                       0,
		                                                       self.target,
		                                                       PATTACH_POINT_FOLLOW,
		                                                       "attach_hitloc",
		                                                       self.target:GetOrigin(), -- unknown
		                                                       true -- unknown, true
		                                                     )
	                    ParticleManager:SetParticleControlForward( effect_cast, 1, (self.target:GetOrigin()+self.parent:GetOrigin()):Normalized() )
	                    ParticleManager:ReleaseParticleIndex( effect_cast )
	
    local effect_cast2 = ParticleManager:CreateParticle( "particles/nanaya_hit_test22.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
                         ParticleManager:SetParticleControl(effect_cast2, 1, self.target:GetAbsOrigin())
                         ParticleManager:SetParticleControlEnt(effect_cast2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_knife", self.parent:GetAbsOrigin(), true)

	local effect_cast1 = ParticleManager:CreateParticle( "particles/nanaya_combo_1hit2_.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
	                     ParticleManager:SetParticleControl(effect_cast1, 1, self.target:GetAbsOrigin())
	                     ParticleManager:ReleaseParticleIndex( effect_cast1 )
	
    self.parent:FaceTowards(self.parent:GetOrigin() + self.parent:GetForwardVector()*180)
	self.parent:SetOrigin(self.parent:GetOrigin() + self.parent:GetForwardVector()*180)
end
function modifier_q_nanaya:dash(me, dt)
	local pos = self.parent:GetOrigin()
	local targetpos = self.target:GetOrigin()
	
	local direction = targetpos - pos
	direction.z = 0     
	local target = pos + direction:Normalized() * (self.speed * dt)
	
	self.parent:SetOrigin(target)
	self.parent:FaceTowards(targetpos)
end
function modifier_q_nanaya:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_q_nanaya:OnDestroy()
	if IsServer() then
		self.parent:RemoveGesture(ACT_SCRIPT_CUSTOM_15)
		self.parent:InterruptMotionControllers(true)
		self.parent:StartGestureWithPlaybackRate(ACT_SCRIPT_CUSTOM_14, 0.8)
	end
end

modifier_nanaya_dash_invis = modifier_nanaya_dash_invis or class({})

function modifier_nanaya_dash_invis:IsDebuff() return false end
function modifier_nanaya_dash_invis:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantom_assassin_fall20_active_blur.vpcf"
end
function modifier_nanaya_dash_invis:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf"
end
function modifier_nanaya_dash_invis:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_nanaya_dash_invis:DeclareFunctions()
     self.funcs = {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
     				MODIFIER_PROPERTY_INVISIBILITY_LEVEL}
    return self.funcs
end
function modifier_nanaya_dash_invis:GetModifierInvisibilityLevel()
	return 1
end
function modifier_nanaya_dash_invis:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = true}
end
function modifier_nanaya_dash_invis:OnAbilityFullyCast(args)
    if args.unit == self:GetParent() then
    	if not (args.ability == self:GetAbility()) then
    		self:Destroy()
    	end
    end
end

---------------------------------------------------------------------------------------------------------------
-- Nanaya Charge Kick (Q)
---------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_q2jump", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_HORIZONTAL)


nanaya_q2jump = nanaya_q2jump or class({})

function nanaya_q2jump:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("nanaya.kerikedaknormal")
	local check = caster:GetAnglesAsVector():Normalized()
	local check2 = caster:GetForwardVector()
	local targetpoint = self:GetCursorPosition()
	caster:AddNewModifier(caster, self, "modifier_q2jump", {duration = 2})
	local jump = ParticleManager:CreateParticle("particles/blink.vpcf", PATTACH_CUSTOMORIGIN, caster)
	local hTarget = (targetpoint - caster:GetAbsOrigin()):Normalized()
    local fKnifeDistance = self:GetSpecialValueFor("knife_distance")

	local speed = 3600
	local hKnifeProjectile =    {
			Source            = caster,
			Ability           = self,
			vSpawnOrigin      = caster:GetAbsOrigin() + Vector(0, 0, 0),
			
			iUnitTargetTeam   = self:GetAbilityTargetTeam(),
			iUnitTargetType   = self:GetAbilityTargetType(),
			iUnitTargetFlags  = self:GetAbilityTargetFlags(),
			
			EffectName        = nil,
			fDistance         = fKnifeDistance, --1300,
			fStartRadius      = 150,
			fEndRadius        = 150,
			vVelocity         = Vector(hTarget.x,hTarget.y,0) * (speed - 100),
			
			bHasFrontalCone   = false,
			
			bProvidesVision   = true,
			iVisionRadius     = iVisionRadius,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		local iKnifeProjectile = ProjectileManager:CreateLinearProjectile(hKnifeProjectile)
	
    ParticleManager:SetParticleControl(jump, 0, caster:GetAbsOrigin() + caster:GetForwardVector()*-90)
	
	local jump2 = ParticleManager:CreateParticle("particles/shiki_blink_after.vpcf", PATTACH_CUSTOMORIGIN, caster)
	              ParticleManager:SetParticleControl(jump2, 0, GetGroundPosition(caster:GetAbsOrigin()+ caster:GetForwardVector():Normalized()*-250, nil))
	              ParticleManager:SetParticleControl(jump2, 4, caster:GetAbsOrigin())
	caster:EmitSound("nanaya.jumpforward")
	
	print (check)
	print (check2)
end

function nanaya_q2jump:OnUpgrade()
    local hCaster = self:GetCaster()
    
    if hCaster:FindAbilityByName("nanaya_q_strike"):GetLevel() ~= self:GetLevel() then
        hCaster:FindAbilityByName("nanaya_q_strike"):SetLevel(self:GetLevel())
    end
end
function nanaya_q2jump:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
	local caster = self:GetCaster()
	local hit = 2
	
    if hTarget == nil then return true 
	else
        local fAgiScale = self:GetSpecialValueFor("agi_scale")
		local dmg = self:GetSpecialValueFor("dmg") + math.floor(self:GetCaster():GetAgility()*fAgiScale)
		hTarget:EmitSound("nanaya.hitleg")
		ParticleManager:CreateParticle("particles/nanaya_work_22.vpcf", PATTACH_ABSORIGIN, hTarget)
		   ScreenShake(hTarget:GetOrigin(), 10, 1.0, 0.7, 2000, 0, true)
		   ApplyDamage({
                         victim = hTarget,
                         attacker = caster,
                         damage = dmg,
                         damage_type = DAMAGE_TYPE_PHYSICAL,
                         damage_flags = 1024,
                         ability = self
                     })

	caster:RemoveModifierByName("modifier_q2jump")
	caster:Stop()
	caster:SetOrigin(hTarget:GetOrigin() - caster:GetForwardVector()*100)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 1)
	
    Timers:CreateTimer(0, function()	
        if hit > 0 then
            hit = hit-1
            
            ApplyDamage({
                          victim = hTarget,
                          attacker = caster,
                          damage = dmg,
                          damage_type = DAMAGE_TYPE_PHYSICAL,
                          damage_flags = 1024,
                          ability = self
                       })


            ParticleManager:CreateParticle("particles/nanaya_work_22.vpcf", PATTACH_ABSORIGIN, hTarget)
            ScreenShake(hTarget:GetOrigin(), 10, 1.0, 0.3, 2000, 0, true)
            hTarget:EmitSound("nanaya.hitleg")
        
            return 0.1
        else
            return end	
    end)

    local knockback4 = { should_stun = true,
				         knockback_duration = 0.05,
				         duration = 0.05,
				         knockback_distance = 25,
				         knockback_height = 50,
				         center_x = caster:GetAbsOrigin().x - caster:GetForwardVector().x * 800,
				         center_y = caster:GetAbsOrigin().y - caster:GetForwardVector().y * 800,
			             center_z = 4000}	
    
    hTarget:AddNewModifier(caster, self, "modifier_knockback", knockback4)	

	local knockback1 = { should_stun = true,
                         knockback_duration = 1,
                         duration = 1,
                         knockback_distance = 250,
                         knockback_height = 400,
                         center_x = caster:GetAbsOrigin().x - caster:GetForwardVector().x * 800,
                         center_y = caster:GetAbsOrigin().y - caster:GetForwardVector().y * 800,
                         center_z = caster:GetAbsOrigin().z }	

    local knockback2 = { should_stun = true,
				         knockback_duration = 1,
				         duration = 1,
				         knockback_distance = 250,
				         knockback_height = 200,
				         center_x = caster:GetAbsOrigin().x - caster:GetForwardVector().x * 800,
				         center_y = caster:GetAbsOrigin().y - caster:GetForwardVector().y * 800,
			             center_z = caster:GetAbsOrigin().z }	
    
    Timers:CreateTimer(0.01, function()
        hTarget:RemoveModifierByName("modifier_knockback")
        hTarget:AddNewModifier(caster, self, "modifier_knockback", knockback1)	
        caster:AddNewModifier(caster, self, "modifier_knockback", knockback2)
    end)
		
    Timers:CreateTimer(0.75, function()	
       hTarget:RemoveModifierByName("modifier_knockback")
       local knockback3 = { should_stun = true,
				            knockback_duration = 0.05,
				            duration = 0.05,
				            knockback_distance = 500,
				            knockback_height = 150,
				            center_x = caster:GetAbsOrigin().x - caster:GetForwardVector().x * 800,
				            center_y = caster:GetAbsOrigin().y - caster:GetForwardVector().y * 800,
			                center_z = 4000 }	
                
        hTarget:AddNewModifier(caster, self, "modifier_knockback", knockback3)	
        caster:EmitSound("nanaya.jumphit")
                
        Timers:CreateTimer(0.05, function()	
            hTarget:EmitSound("nanaya.hit")
            ScreenShake(hTarget:GetOrigin(), 10, 1.0, 0.4, 2000, 0, true)
            hTarget:AddNewModifier(caster, self, "modifier_stunned", { duration = 1 })
            ApplyDamage({
                          victim = hTarget,
                          attacker = caster,
                          damage = dmg*2,
                          damage_type = DAMAGE_TYPE_PHYSICAL,
                          damage_flags = 1024,
                          ability = self
                       })


            local part = ParticleManager:CreateParticle("particles/test_part6.vpcf", PATTACH_CUSTOMORIGIN, caster)
			             ParticleManager:SetParticleControl(part, 3, caster:GetAbsOrigin() + Vector(0, 0, 0))
			
            local part2 = ParticleManager:CreateParticle("particles/hit2.vpcf", PATTACH_CUSTOMORIGIN, caster)
			              ParticleManager:SetParticleControlEnt(part2, 0, caster, PATTACH_POINT, "attach_knife", caster:GetAbsOrigin(), true)
		  
            local part1 = ParticleManager:CreateParticle("particles/nanaya_jump_back.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hTarget)
		                  ParticleManager:SetParticleControl(part1, 0, GetGroundPosition(hTarget:GetAbsOrigin(), nil))
		                  ParticleManager:SetParticleControl(part, 5, GetGroundPosition(hTarget:GetAbsOrigin(), nil))
        end)
    end)

    end
end


modifier_q2jump = modifier_q2jump or class({})

function modifier_q2jump:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_q2jump:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_q2jump:CheckState()
    local state = { 
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_ROOTED] = true,
                    [MODIFIER_STATE_DISARMED] = true,
                    [MODIFIER_STATE_SILENCED] = true,
                    [MODIFIER_STATE_MUTED] = true,
                  }
    return state
end
function modifier_q2jump:OnCreated(args)
	if not IsServer() then 
        return
    end 
	self.parent = self:GetParent()	
	
    self.hit = ParticleManager:CreateParticle("particles/test_part5.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
               ParticleManager:SetParticleControlEnt(self.hit, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_leg", self.parent:GetAbsOrigin(), true)
               ParticleManager:SetParticleControlEnt(self.hit, 5, self.parent, PATTACH_POINT_FOLLOW, "attach_leg1", self.parent:GetAbsOrigin(), true)
	
    self.check = args.knife
    if self.check == nil then 
        self.ability = self:GetAbility()
        self.point = self.ability:GetCursorPosition()
        self.distances = 1000
        self.direction = (self.point - self.parent:GetAbsOrigin()):Normalized()
    else
        self.point = Vector(args.pos_x, args.pos_y, 0)
        self.distances = 450
		
        self.direction = (self.parent:GetForwardVector() * 180):Normalized() 
        self.parent:SetOrigin(Vector(args.pos_x, args.pos_y, self.parent:GetAbsOrigin().z))
        self.target = args.target
    end
    self:StartIntervalThink(FrameTime())
end
function modifier_q2jump:OnIntervalThink()
	self:UpdateHorizontalMotion(self:GetParent(), FrameTime())
end
function modifier_q2jump:UpdateHorizontalMotion(hero, times)
	if self.distances >= 0 then 
		local speed = 4000 * times
		local parent_pos = self.parent:GetAbsOrigin()
		
		self.next_pos = parent_pos + self.direction * speed
		self.distances = self.distances - speed
		self.parent:SetOrigin(self.next_pos)
		else
		self:Destroy()
	end
end
function modifier_q2jump:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
	end
end
function modifier_q2jump:OnDestroy()
	if IsServer() then
        self.parent:InterruptMotionControllers(true)
        	if self.hit ~= nil then
			ParticleManager:DestroyParticle(self.hit, true)
		end
	end
	
end

---------------------------------------------------------------------------------------------------------------
-- Nanaya Jump Ahead (W) and FBT Incident {E)
---------------------------------------------------------------------------------------------------------------

LinkLuaModifier("jump_ahead_nanaya_modifier", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nanaya_animation_knife", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)

jump_ahead_nanaya = jump_ahead_nanaya or class({})

function jump_ahead_nanaya:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "jump_ahead_nanaya_modifier", {})
	local justpoint = self:GetCursorPosition()
	local hTarget = (justpoint - caster:GetAbsOrigin()):Normalized()
	local speed = 3000
	caster:EmitSound("nanaya.jump")
	local projectile_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"
	local projectile_speed = 450
	local projectile_vision = 450
	local sAbil = caster:GetAbilityByIndex(0):GetAbilityName()
        if sAbil == "nanaya_q_strike" then
	        caster:SwapAbilities("nanaya_q_strike", "nanaya_q2jump", false, true)
        else
            caster:SwapAbilities("nanaya_q_strike", "nanaya_q2jump", true, false)
    end
	
    if caster:FindModifierByName("nanaya_blood_modifier"):GetStackCount() > 9 then
	    Timers:CreateTimer(0.1, function()
		    local hKnifeProjectile =    {
			                              Source            = caster,
			                              Ability           = self,
			                              vSpawnOrigin      = caster:GetAbsOrigin() + Vector(0, 0, 100),
			
			                              iUnitTargetTeam   = self:GetAbilityTargetTeam(),
			                              iUnitTargetType   = self:GetAbilityTargetType(),
			                              iUnitTargetFlags  = self:GetAbilityTargetFlags(),
			
			                              EffectName        = "particles/heroes/anime_hero_sniper/sniper_knife_projectile.vpcf",
			                              fDistance         = 1500,
			                              fStartRadius      = 25,
			                              fEndRadius        = 65,
			                              vVelocity         = Vector(hTarget.x,hTarget.y,0) * (speed - 100),
			
			                              bHasFrontalCone   = false,
			
			                              bProvidesVision   = true,
			                              iVisionRadius     = iVisionRadius,
			                              iVisionTeamNumber = caster:GetTeamNumber()
			                            }
		    local iKnifeProjectile = ProjectileManager:CreateLinearProjectile(hKnifeProjectile)
	    end)
    end
end
function jump_ahead_nanaya:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
	local caster = self:GetCaster()
	if hTarget == nil then return true 
    else
		caster:RemoveModifierByName("jump_ahead_nanaya_modifier")
		local target = hTarget:GetAbsOrigin()
		local target_2 = hTarget:entindex()
		local dmg = self:GetSpecialValueFor("dmg_knife") + math.floor(self:GetCaster():GetAgility()*4)
		local dmg2 = self:GetSpecialValueFor("dmg_hit") + math.floor(self:GetCaster():GetAgility()*4)

		ApplyDamage({
                    victim = hTarget,
                    attacker = caster,
                    damage = dmg,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    damage_flags = 1024,
                    ability = self
                })

		caster:SetOrigin(target+caster:GetForwardVector()*180)
		
		local order = { UnitIndex = caster:entindex(),
			            OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET ,
			            TargetIndex = hTarget:entindex(),
			            AbilityIndex = 0,
			            Position = 0,
		              Queue = 0, }
		
		ExecuteOrderFromTable(order)
		
		caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2, 1.2)
		
        Timers:CreateTimer(0.25, function()
			local jump = ParticleManager:CreateParticle("particles/blink.vpcf", PATTACH_CUSTOMORIGIN, caster)
			             ParticleManager:SetParticleControl(jump, 0, caster:GetAbsOrigin() + caster:GetForwardVector()*-90)
			
			local jump2 = ParticleManager:CreateParticle("particles/shiki_blink_after.vpcf", PATTACH_CUSTOMORIGIN, caster)
			              ParticleManager:SetParticleControl(jump2, 0, caster:GetAbsOrigin()+ caster:GetForwardVector()*-250)
			              ParticleManager:SetParticleControl(jump2, 4, hTarget:GetAbsOrigin())
			
			
			local dagon_particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_ABSORIGIN, hTarget)
			                       ParticleManager:SetParticleControl(dagon_particle, 1,  hTarget:GetAbsOrigin()+Vector(0, 0, 150))
			
            local particle_effect_intensity = 500
			ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity))
			
			local knockback1 = { should_stun = true,
				                 knockback_duration = 0.1,
				                 duration = 0.15,
				                 knockback_distance = 800,
				                 knockback_height = 0,
				                 center_x = caster:GetAbsOrigin().x - caster:GetForwardVector().x * 800,
				                 center_y = caster:GetAbsOrigin().y - caster:GetForwardVector().y * 800,
			                     center_z = caster:GetAbsOrigin().z }								
			caster:EmitSound("nanaya.slash")

			ApplyDamage({
                    victim = hTarget,
                    attacker = caster,
                    damage = dmg2,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    damage_flags = 1024,
                    ability = self
                })

			local culling_kill_particle = ParticleManager:CreateParticle("particles/lanc1.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
			                              ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			                              ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			                              ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			                              ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			                              ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)	
			
			Timers:CreateTimer( 3.0, function()
                ParticleManager:DestroyParticle( culling_kill_particle, false )
                ParticleManager:ReleaseParticleIndex(culling_kill_particle)		
			end)
			caster:AddNewModifier(caster, self, "modifier_knockback", knockback1)
		end)
	end
	return true
end


jump_ahead_nanaya_modifier = jump_ahead_nanaya_modifier or class({})
function jump_ahead_nanaya_modifier:GetPriority() return MODIFIER_PRIORITY_HIGH end
function jump_ahead_nanaya_modifier:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function jump_ahead_nanaya_modifier:CheckState()
    local state = { 
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_ROOTED] = true,
                    [MODIFIER_STATE_DISARMED] = true,
                    [MODIFIER_STATE_SILENCED] = true,
                    [MODIFIER_STATE_MUTED] = true,
                  }
    return state
end
function jump_ahead_nanaya_modifier:OnCreated(args)
	if not IsServer() then 
        return
    end 
	self.parent = self:GetParent()
	self.check = args.knife
	if self.check == nil then 
		self.ability = self:GetAbility()
		self.point = self.ability:GetCursorPosition()
		self.distances = self.ability:GetSpecialValueFor("blink_ahead")
		self.direction = (self.point - self.parent:GetAbsOrigin()):Normalized()
    else
		self.point = Vector(args.pos_x, args.pos_y, 0)
		self.distances = 450
		
		self.direction = (self.parent:GetForwardVector() * 180):Normalized() 
		self.parent:SetOrigin(Vector(args.pos_x, args.pos_y, self.parent:GetAbsOrigin().z))
		self.target = args.target
	end
	self.nanayaframechange = 0
	self:StartIntervalThink(FrameTime())
end
function jump_ahead_nanaya_modifier:OnIntervalThink()
	self:UpdateHorizontalMotion(self:GetParent(), FrameTime())
	
	local nanaya_image = ParticleManager:CreateParticle("particles/nanaya_image.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
                         ParticleManager:SetParticleControl(nanaya_image, 0, self.parent:GetAbsOrigin())
                         ParticleManager:SetParticleControl(nanaya_image, 4, self.point)
                         ParticleManager:SetParticleControl(nanaya_image, 2, Vector(self.nanayaframechange, 0, 0))
	self.nanayaframechange = self.nanayaframechange + 1
end
function jump_ahead_nanaya_modifier:UpdateHorizontalMotion(hero, times)
	if self.distances >= 0 then 
		local speed = 1750 * times
		local parent_pos = self.parent:GetAbsOrigin()
		
		self.next_pos = parent_pos - self.direction * speed
		self.distances = self.distances - speed
		self.parent:SetOrigin(self.next_pos)
		self.parent:FaceTowards(self.point)
    else
		self.jump = ParticleManager:CreateParticle("particles/nanaya_jump_back.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
			ParticleManager:SetParticleControl(self.jump, 0, GetGroundPosition(self.parent:GetAbsOrigin(), nil))

		self:Destroy()
	end
end
function jump_ahead_nanaya_modifier:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
	end
end
function jump_ahead_nanaya_modifier:OnDestroy()
	if IsServer() then
        self.parent:InterruptMotionControllers(true)
	end
end


nanaya_knife = nanaya_knife or class({})

function nanaya_knife:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local hTarget = (point - caster:GetAbsOrigin()):Normalized()
	local speed = 3000
	local nanaya_knife = ParticleManager:CreateParticle("particles/nanaya_knifethrow.vpcf", PATTACH_CUSTOMORIGIN, caster)
	                     ParticleManager:SetParticleControl(nanaya_knife, 0, caster:GetAbsOrigin() + caster:GetForwardVector() * 75)
	                     ParticleManager:SetParticleControl(nanaya_knife, 1, caster:GetAbsOrigin() + (caster:GetForwardVector():Normalized()))
	caster:EmitSound("nanaya.knifethrow")
	
	-- get projectile_data
	local projectile_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"
	local projectile_speed = 450
	local projectile_vision = 450
	
	-- Create Projectile
	local hKnifeProjectile =    {
		Source            = caster,
		Ability           = self,
		vSpawnOrigin      = caster:GetAbsOrigin() + caster:GetForwardVector()*90,
		
		iUnitTargetTeam   = self:GetAbilityTargetTeam(),
		iUnitTargetType   = self:GetAbilityTargetType(),
		iUnitTargetFlags  = self:GetAbilityTargetFlags(),
		
		EffectName        = "particles/heroes/anime_hero_sniper/sniper_knife_projectile.vpcf",
		fDistance         = 1500,
		fStartRadius      = 150,
		fEndRadius        = 150,
		vVelocity         = Vector(hTarget.x,hTarget.y,0) * (speed - 100),
		
		bHasFrontalCone   = false,
		
		bProvidesVision   = true,
		iVisionRadius     = iVisionRadius,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
    local iKnifeProjectile = ProjectileManager:CreateLinearProjectile(hKnifeProjectile)
end
function nanaya_knife:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle)
    local caster = self:GetCaster()
    if hTarget == nil then return true 
    else
		local player = caster:GetPlayerOwner()
		local player2 = hTarget:GetPlayerOwner()
		local target = hTarget:GetAbsOrigin()
		local target_2 = hTarget:entindex()
        local iHPPercent = self:GetSpecialValueFor("hp_percent")
		
        if hTarget:GetHealthPercent() >= iHPPercent then -->= 25 then
            
            local fDamage = self:GetSpecialValueFor("dmg")
            local fAgiScale = self:GetSpecialValueFor("agi_scale") or 4
            if self:GetCaster():HasTalent("special_bonus_nanaya_25l")
                and self:GetCaster():FindModifierByName("nanaya_blood_modifier"):GetStackCount() >= 30 then
                local hTalent = self:GetCaster():FindAbilityByName("special_bonus_nanaya_25l")
            
                if hTalent
                    and IsNotNull(hTalent) then
                    fDamage = hTalent:GetSpecialValueFor("value") 
                    fAgiScale = fAgiScale + hTalent:GetSpecialValueFor("value2")                   
                end
            end
		
        local dmg = fDamage + math.floor(self:GetCaster():GetAgility()*fAgiScale)
			ApplyDamage({
                    victim = hTarget,
                    attacker = caster,
                    damage = dmg,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    damage_flags = 1024,
                    ability = self
                })
		end

		local culling_kill_particle = ParticleManager:CreateParticle("particles/nanaya_work_2_great.vpcf", PATTACH_ABSORIGIN, hTarget)
		ScreenShake(hTarget:GetOrigin(), 22, 1.0, 0.4, 1000, 0, true)
		
		local nanaya_hit = hTarget:GetAbsOrigin() + Vector(0, 0, (hTarget:GetOrigin().z) - 100) + caster:GetForwardVector()*-45
		ParticleManager:CreateParticleForPlayer("particles/screen_spla.vpcf", PATTACH_EYES_FOLLOW, caster, player)
		ParticleManager:CreateParticleForPlayer("particles/screen_spla.vpcf", PATTACH_EYES_FOLLOW, caster, player2)
		
		caster:SetOrigin(nanaya_hit)
		local jump2 = ParticleManager:CreateParticle("particles/shiki_blink_after.vpcf", PATTACH_CUSTOMORIGIN, caster)
		              ParticleManager:SetParticleControl(jump2, 0, caster:GetAbsOrigin()+ caster:GetForwardVector()*-90)
		              ParticleManager:SetParticleControl(jump2, 4, hTarget:GetAbsOrigin())
		local part = ParticleManager:CreateParticle("particles/blink.vpcf", PATTACH_CUSTOMORIGIN, caster)
		             ParticleManager:SetParticleControl(part, 0, caster:GetAbsOrigin()+ caster:GetForwardVector()*-400)
		
        caster:AddNewModifier(caster, self, "modifier_nanaya_animation_knife", {duration = 0.35, enemy_health = hTarget:GetHealthPercent(), target = target_2, origin1 = nanaya_hit, hp_percent = iHPPercent})
		
		hTarget:EmitSound("nanaya.knifehit")
	end
	return true
end


modifier_nanaya_animation_knife = modifier_nanaya_animation_knife or class({})

function modifier_nanaya_animation_knife:DeclareFunctions() 
	local funcs = {
                    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                    MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
                  }
	
    return funcs
end
function modifier_nanaya_animation_knife:GetOverrideAnimation()
	return ACT_SCRIPT_CUSTOM_0
end
function modifier_nanaya_animation_knife:GetOverrideAnimationRate()
	return 2
end
function modifier_nanaya_animation_knife:OnCreated(args)
	if IsServer() then 
		self.caster = self:GetCaster()
        self.parent = self:GetParent()
		
		self.health = args.enemy_health
        self.iHPPerc = (args.hp_percent or 10) + (self.caster:HasTalent("special_bonus_nanaya_15r")
                                                     and self.caster:FindTalentValue("special_bonus_nanaya_15r")
                                                     or 0)
        print("Nanaya Knife %: " .. self.iHPPerc)
		self.origin = args.origin
		self.d = args.d
		
		self.vector = Vector(args.position_x, args.position_y, args.position_z)
		
		self.target = EntIndexToHScript(args.target)
		self.ability = self:GetAbility()
		if not self.parent:HasModifier("nanaya_blood_modifier_animemode") and self.parent:FindModifierByName("nanaya_blood_modifier"):GetStackCount() > 15 then 
            self.parent:AddNewModifier(self.parent, self, "nanaya_blood_modifier_animemode", {})
        end
        
		if args.enemy_health <= self.iHPPerc then 
			self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_nanaya_combo", {duration = 1.8})
			
			self.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_nanaya_combo", {duration = 1.8})
			self.parent:StartGestureWithPlaybackRate(ACT_SCRIPT_CUSTOM_7, 0.64)
        else
		end
        
        self:StartIntervalThink(0.1)
	end
end
function modifier_nanaya_animation_knife:OnIntervalThink()
    if IsServer() then 
        if self.parent:IsAlive() then
            local speed = FrameTime()*1000
            self.parent:SetOrigin(self.target:GetAbsOrigin() + Vector(0, 0, (self.target:GetOrigin().z) - 100) + self.parent:GetForwardVector()*-45)
        end
    end
end
function modifier_nanaya_animation_knife:OnDestroy()
	if IsServer() then
		if self.parent:HasModifier("nanaya_jump_slashes_modifier") then return nil end
		
		local check = self.parent:GetAttachmentOrigin(1)
		if self.health <= self.iHPPerc then --<= 25 then 
			Timers:CreateTimer(0.6, function() 
				
                local hit2 = ParticleManager:CreateParticle("particles/screen_spla.vpcf", PATTACH_EYES_FOLLOW, self.parent)
				local knife_hit = ParticleManager:CreateParticle("particles/test_part_small.vpcf", PATTACH_EYES_FOLLOW, self.parent)
				                  ParticleManager:SetParticleControl(knife_hit, 3, self.target:GetAbsOrigin()+self.parent:GetForwardVector()*300+Vector(0, 0, 400))
				
				FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin() - self.parent:GetForwardVector()*250 , true) 
				
				self.parent:EmitSound("nanaya.slash")
				
                ParticleManager:SetParticleControl(knife_hit, 5, GetGroundPosition(self.parent:GetAbsOrigin() - Vector(0, 0, 400), nil))
				
				self.target:Kill(self, self.parent)
			end)
			
        else
			self.parent:RemoveGesture(ACT_SCRIPT_CUSTOM_0)
			self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1)
			
            Timers:CreateTimer(0.3, function() 
				local nanaya_clone_jump = ParticleManager:CreateParticle("particles/blink_z1.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
				ParticleManager:SetParticleControl(nanaya_clone_jump, 1, GetGroundPosition(self.parent:GetAbsOrigin(), nil))
				if self.d == nil and self.parent:HasModifier("nanaya_blood_modifier_animemode") then
					local nanaya_clone = ParticleManager:CreateParticle("particles/nanaya_image_clone.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
					                     ParticleManager:SetParticleControl(nanaya_clone, 0, GetGroundPosition(self.parent:GetAbsOrigin(), nil)) --0.35
					                     ParticleManager:SetParticleControl(nanaya_clone, 2, Vector(3, 9, 0))
					                     ParticleManager:SetParticleControl(nanaya_clone, 4, self.target:GetAbsOrigin())
					nanaya_clones:Clones(self.parent, self.target)
					else
				end
			end)
			
            self.table = { knife = 1, 
				           pos_x = self.target:GetAbsOrigin().x, 
				           pos_y = self.target:GetAbsOrigin().y, 
			               pos_z = self.target:GetAbsOrigin().z, }
			
			self.parent:AddNewModifier(caster, self, "jump_ahead_nanaya_modifier", self.table)
		end
	end
end

nanaya_clones = nanaya_clones or class({})

function nanaya_clones:Clones(caster, units, secondtime)
    local table = {12, 13, 21, 23, 24}	
    local knockback_push = 0
    local knockback_push1 = caster:GetForwardVector()
    local dmg = 350 + math.floor(caster:GetAgility()*4)

    units:EmitSound("nanaya.combo2")

    local numberhit = 0
    local cloneanim = 14
    Timers:CreateTimer(0.1, function()
        if numberhit < 4 then
            if secondtime == nil then 
            knockback_push = units:GetAbsOrigin() - knockback_push1*120
            else							
            end
        
        numberhit = numberhit + 1
        local nanaya_clone = ParticleManager:CreateParticle("particles/nanaya_image_clone.vpcf", PATTACH_CUSTOMORIGIN, caster)
        cloneanim = cloneanim + 1
										
        ParticleManager:SetParticleControl(nanaya_clone, 0, knockback_push) --0.35
        ParticleManager:SetParticleControl(nanaya_clone, 2, Vector(3, table[numberhit], 0))
        ParticleManager:SetParticleControl(nanaya_clone, 4, units:GetAbsOrigin())

        local test = string.format("nanaya.clonetp%s", numberhit)
																			
        units:EmitSound(test)
 
	    local knockback = { should_stun = true,
	                        knockback_duration = 0.1,
	                        duration = 0.1,
	                        knockback_distance = 250,
	                        knockback_height = 0,

							center_x = knockback_push.x,
							center_y = knockback_push.y,
	                        center_z = units:GetAbsOrigin().z }
									
        Timers:CreateTimer(0.15, function()
		    ParticleManager:CreateParticle("particles/nanaya_work_2.vpcf", PATTACH_ABSORIGIN, units)
		    if numberhit == 4 then
		        ParticleManager:SetParticleControl(nanaya_clone, 2, Vector(2, table[numberhit], -19))
		        local test_hit = ParticleManager:CreateParticle("particles/nanaya_hit_test.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, units)
		        ParticleManager:SetParticleControl(test_hit, 1, units:GetAbsOrigin() + knockback_push1 * 120)
		        ParticleManager:SetParticleControl(test_hit, 0, units:GetAbsOrigin())
		    end
		
            units:EmitSound("nanaya.slash")
	        units:AddNewModifier(caster, self, "modifier_knockback", knockback)
		    ParticleManager:CreateParticle("particles/nanaya_e1.vpcf", PATTACH_ABSORIGIN, units)
        	
            ApplyDamage({
                    victim = units,
                    attacker = caster,
                    damage = dmg,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    damage_flags = 1024,
                    ability = self
                })

		    ScreenShake(units:GetOrigin(), 10, 1.0, 0.1, 2000, 0, true)	
		end)
		
        return 0.4
        else
            if secondtime == nil then 
                nanaya_clones:Final_clones(caster, units, knockback_push1)
            end
        end
    end)
end

function nanaya_clones:Final_clones(caster, units, knockback_push1)
    local check1 = GetGroundPosition(units:GetAbsOrigin() + knockback_push1 * 450, nil) + Vector(0, 0, 300) --ПОНИЖЕНИЕ СТАРТОВОЙ
    local check2 = GetGroundPosition(units:GetAbsOrigin() + knockback_push1 * 1500, nil) - Vector(0, 0, 250) --ПОВЫШЕНИЕ КОНЕЧНОЙ

    local center_unit_z = units:GetAbsOrigin().z

    Timers:CreateTimer(0.15, function()
        units:EmitSound("nanaya.kerikedak")
        local nanaya_clone = ParticleManager:CreateParticle("particles/nanaya_image_clone_attach.vpcf", PATTACH_CUSTOMORIGIN, caster)
        knockback_push = units:GetAbsOrigin() - knockback_push1 * 180
        ParticleManager:SetParticleControl(nanaya_clone, 0, units:GetAbsOrigin() - knockback_push1 * 20 )
        ParticleManager:SetParticleControl(nanaya_clone, 2, Vector(0, 24, 0))
        ParticleManager:SetParticleControl(nanaya_clone, 4, units:GetAbsOrigin())

        Timers:CreateTimer(0.2, function()
            ParticleManager:CreateParticle("particles/nanaya_work_2.vpcf", PATTACH_ABSORIGIN, units)
            units:EmitSound("nanaya.hitleg")
            ScreenShake(units:GetOrigin(), 10, 1.0, 0.2, 2000, 0, true)
            
            ApplyDamage({
                    victim = units,
                    attacker = caster,
                    damage = 700,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    damage_flags = 1024,
                    ability = self
                })

            local knockback = { should_stun = true,
	                            knockback_duration = 2,
	                            duration = 2,
	                            knockback_distance = 800,
	                            knockback_height = 400,
	                               
								center_x = knockback_push.x,
								center_y = knockback_push.y,
	                            center_z = center_unit_z }
	                                
            units:AddNewModifier(caster, self, "modifier_stunned", { duration = 4 })
            ParticleManager:CreateParticle("particles/nanaya_jump_back.vpcf", PATTACH_ABSORIGIN, units)
            units:AddNewModifier(caster, self, "modifier_knockback", knockback)
									
            Timers:CreateTimer(0.2, function()
			    local nanaya_clone2 = ParticleManager:CreateParticle("particles/nanaya_image_clone_back.vpcf", PATTACH_CUSTOMORIGIN, caster)	
                                      ParticleManager:SetParticleControl(nanaya_clone2, 0, GetGroundPosition(units:GetAbsOrigin() - knockback_push1 * 20, nil))
                                      ParticleManager:SetParticleControl(nanaya_clone2, 2, Vector(1, 25, 0))
                                      ParticleManager:SetParticleControl(nanaya_clone2, 4, GetGroundPosition(units:GetAbsOrigin() + knockback_push1 * 1000, nil))
                                      ParticleManager:SetParticleShouldCheckFoW(nanaya_clone2, false)

                Timers:CreateTimer(0.9, function()
                    ParticleManager:DestroyParticle(nanaya_clone2, false)

	                Timers:CreateTimer(1.4, function()
	                    ParticleManager:DestroyParticle(nanaya_clone2, false)
                        local hit = ParticleManager:CreateParticle("particles/test_part_small.vpcf", PATTACH_CUSTOMORIGIN, caster)
                        ParticleManager:SetParticleControl(hit, 3, check1) 
                        ParticleManager:SetParticleControl(hit, 5, check2) 
	
                        local hit2 = ParticleManager:CreateParticle("particles/screen_spla22.vpcf", PATTACH_EYES_FOLLOW,caster)

                        ParticleManager:SetParticleShouldCheckFoW(hit, false)

                        local sex = FindUnitsInLine(caster:GetTeam(), check1, check2, nil, 90, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
                        
                        for k,v in pairs(sex) do
                            ApplyDamage({
                                          victim = v,
                                          attacker = caster,
                                          damage = 1200,
                                          damage_type = DAMAGE_TYPE_PHYSICAL,
                                          damage_flags = 1024,
                                          ability = self
                                        })
                            ParticleManager:CreateParticle("particles/nanaya_work_2.vpcf", PATTACH_ABSORIGIN, v)
                            v:EmitSound("nanaya.finalhit")
                        end
	                end)
	            end)
			end)
		end)
    end)
end


---------------------------------------------------------------------------------------------------------------
-- Nanaya Blood (D)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("nanaya_blood_modifier_animemode", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("nanaya_blood_modifier", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)

nanaya_blood = nanaya_blood or class({})

function nanaya_blood:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end
function nanaya_blood:GetIntrinsicModifierName()
    return "nanaya_blood_modifier"
end	

nanaya_blood_modifier = nanaya_blood_modifier or class({})

function nanaya_blood_modifier:IsHidden() return false end
function nanaya_blood_modifier:IsDebuff() return false end
function nanaya_blood_modifier:DeclareFunctions()
    local func = {
                   MODIFIER_EVENT_ON_TAKEDAMAGE,
                   MODIFIER_EVENT_ON_DEATH,                  
                   MODIFIER_PROPERTY_STATS_AGILITY_BONUS 
                 }
    return func
end
function nanaya_blood_modifier:GetModifierBonusStats_Agility()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_agility")
end
function nanaya_blood_modifier:OnCreated()
	self.parent = self:GetParent()
    self.iKills = self.iKills or 0
	self:SetStackCount(0)
end
function nanaya_blood_modifier:GetMaxStackCount()
	return self:GetAbility():GetSpecialValueFor("stack_max")
end
function nanaya_blood_modifier:OnTakeDamage(keys)
    if IsServer() then
        if keys.attacker == self.parent and keys.unit and keys.unit:GetTeamNumber() ~= self.parent:GetTeamNumber() and not keys.unit:IsBuilding() then
            local iStacks = self:GetStackCount()
            if self.iNanayaParticle ~= nil then 
                ParticleManager:DestroyParticle(self.iNanayaParticle, true)
            end
            Timers:RemoveTimer("nanaya")
            if(iStacks < self:GetMaxStackCount()) then
                self:SetStackCount(iStacks+1)
            end
            self.iNanayaParticle = ParticleManager:CreateParticle("particles/nanaya_blood2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            Timers:CreateTimer("nanaya", {
                endTime = 6, 
                callback = function()
                    self:SetStackCount(0)
                    if self.parent:HasModifier("nanaya_blood_modifier_animemode") then self.parent:RemoveModifierByName("nanaya_blood_modifier_animemode") end
                end}
            )
        end			
    end
end
function nanaya_blood_modifier:OnDeath(keys)
    if IsServer() then
        if keys.attacker == self.parent and keys.unit and keys.unit:GetTeamNumber() ~= self.parent:GetTeamNumber() and not keys.unit:IsBuilding() then
            self.iKills = self.iKills + 1
            if self.parent:HasTalent("special_bonus_nanaya_20r") then
                for i = 0, self.parent:GetAbilityCount() - 1 do
                    local hAbility = self.parent:GetAbilityByIndex(i)
                    if hAbility 
                        and IsNotNull(hAbility) 
                        and hAbility:GetCooldownTimeRemaining() > 0 then
                        local fCDReduce = self.parent:FindTalentValue("special_bonus_nanaya_20r") or 2
                        local fCDRemain = hAbility:GetCooldownTimeRemaining()
                    
                        -- For Nanaya (Third for blood) Talent
                        hAbility:EndCooldown()
                        if fCDRemain > fCDReduce then
                            hAbility:StartCooldown(fCDRemain - fCDReduce)
                        end
                        print("TEST HMMMM: " .. i .. "Ability CD: " .. hAbility:GetCooldownTimeRemaining())
                        print("TEST HMMMM2: " .. fCDReduce)
                    end
                end
            end
        end
    end		
end	
	
nanaya_blood_modifier_animemode = nanaya_blood_modifier_animemode or class({})

function nanaya_blood_modifier_animemode:IsHidden() return false end
function nanaya_blood_modifier_animemode:IsDebuff() return false end
function nanaya_blood_modifier_animemode:DeclareFunctions()
    local func = {
                   MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
                 }
    return func
end
function nanaya_blood_modifier_animemode:OnCreated()
	self.parent = self:GetParent()
	
    self.nanaya_right_eye = ParticleManager:CreateParticle("particles/nanaya_eyes.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
    ParticleManager:SetParticleControlEnt(self.nanaya_right_eye, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_right_eye", self.parent:GetAbsOrigin(), true)

    self.nanaya_left_eye = ParticleManager:CreateParticle("particles/nanaya_eyes.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(self.nanaya_left_eye, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_left_eye", self.parent:GetAbsOrigin(), true)
end
function nanaya_blood_modifier_animemode:GetModifierMoveSpeed_Absolute()
    return 600
end
function nanaya_blood_modifier_animemode:OnRemoved()
	ParticleManager:DestroyParticle(self.nanaya_left_eye, false)
	ParticleManager:ReleaseParticleIndex(self.nanaya_left_eye)
	ParticleManager:DestroyParticle(self.nanaya_right_eye, false)
	ParticleManager:ReleaseParticleIndex(self.nanaya_right_eye)
end


---------------------------------------------------------------------------------------------------------------
-- Nanaya Slashes Pandora (D)
---------------------------------------------------------------------------------------------------------------

LinkLuaModifier("nanaya_slashes_modifier", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("nanaya_slashes_modifier1", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)


nanaya_slashes = nanaya_slashes or class({})

function nanaya_slashes:OnAbilityPhaseStart()	
    local caster = self:GetCaster()
    niger = 0
    caster:EmitSound("nanaya.hmm")
    return true
end
function nanaya_slashes:GetCastPoint()
    if niger == 1 then 
        return 0.1
    end
end
function nanaya_slashes:GetCastAnimation()
    if niger == 1 then  
        return ACT_DOTA_CAST_ABILITY_3
    end
end
function nanaya_slashes:GetCastRange()
    --[[if IsServer() and self:GetCaster():FindModifierByName("nanaya_blood_modifier"):GetStackCount() < 10 then
        return 250 - self:GetCaster():GetCastRangeBonus()
    end]]--
    if niger == 1 then  
        return 300
    end
end
function nanaya_slashes:GetAbilityTextureName()
    return "custom/nanaya/nanaya-D2"
end
function nanaya_slashes:OnSpellStart()	
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()
    local target_2 = target:entindex()

    if caster:FindModifierByName("nanaya_blood_modifier"):GetStackCount() < 10 then
        --FindClearSpaceForUnit(caster, target:GetOrigin(), true)
        Nanaya_New_Slashes(caster, target, self)    
    else
        local dmg = self:GetSpecialValueFor("clone_dmg")
        nanaya_clones1:ComboD(caster, target, dmg)
    end
end

function Nanaya_New_Slashes(caster, target, hAbility)
	local slash_count = hAbility:GetSpecialValueFor("slashes_count") or 8
	local radius = hAbility:GetSpecialValueFor("slashes_radius") or 400
	local interval = hAbility:GetSpecialValueFor("slashes_interval") or 0.05
    local fAgiScale = hAbility:GetSpecialValueFor("slashes_agi") or 4
    
	local knockback_push1 = caster:GetForwardVector()
    
    knockback_push = target:GetAbsOrigin() - knockback_push1*250
    
    local knife = ParticleManager:CreateParticle("particles/maybedashvpcffinal1.vpcf", PATTACH_CUSTOMORIGIN, caster)
                  ParticleManager:SetParticleControlEnt(knife, 0, caster, PATTACH_POINT_FOLLOW, "attach_hand", caster:GetAbsOrigin(), true)
                  ParticleManager:SetParticleControl(knife, 4, target:GetAbsOrigin())
	            
    caster:SetOrigin(knockback_push)

	caster:EmitSound("nanaya.zange")

	--StartAnimation(caster, {duration=0.35, activity=ACT_DOTA_CAST_ABILITY_5, rate=1})
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 1)
    
    --[[Timers:CreateTimer(0.35, function()
        if caster and IsNotNull(caster) then
            RemoveGesture(ACT_DOTA_CAST_ABILITY_5)
        end
    end)]]--

	Timers:CreateTimer(0, function()
		slash_count = slash_count - 1
		if slash_count <= 0 then
			interval = nil
		else
			caster:AddNewModifier(caster, hAbility, "nanaya_jump_revoke", { duration = 0.06 })
		end

		local part = math.random(-40, 40)
		local part2 = -20
		if slash_count%2 == 0 then
			part = part + 180
			part2 = 20
		end

		local particle = ParticleManager:CreateParticle("particles/nanaya/nanaya_slash.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 5, Vector(radius + 50, 0, 110))
		ParticleManager:SetParticleControl(particle, 10, Vector(0, part, -90 + part2))
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particle, false)
			ParticleManager:ReleaseParticleIndex(particle)
		end)

		caster:EmitSound("nanaya.slash")

		local enemies = FindUnitsInRadius(  caster:GetTeamNumber(),
                                        caster:GetAbsOrigin(),
                                        nil,
                                        radius,
                                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                                        DOTA_UNIT_TARGET_ALL,
                                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                        FIND_ANY_ORDER,
                                        false)
                                        
        local hDamageTable =    {  
                                    victim 		 = nil,
                                    attacker 	 = caster,
                                    damage 		 = hAbility:GetSpecialValueFor("slashes_damage") + caster:GetAgility()*fAgiScale,
                                    damage_type  = DAMAGE_TYPE_MAGICAL,
                                    ability 	 = hAbility,
                             		damage_flags = 0
                                }

	    for _,enemy in pairs(enemies) do
			local origin_diff = enemy:GetAbsOrigin() - caster:GetAbsOrigin()
			local origin_diff_norm = origin_diff:Normalized()
			if caster:GetForwardVector():Dot(origin_diff_norm) > 0 then
				local hit_particle = ParticleManager:CreateParticle("particles/nanaya_work_22.vpcf", PATTACH_ABSORIGIN, enemy)
				ParticleManager:ReleaseParticleIndex(hit_particle)

				enemy:AddNewModifier(caster, hAbility, "modifier_stunned", { duration = 0.1 })
			    --DoDamage(caster, enemy, damage, DAMAGE_TYPE_MAGICAL, 0, self, false)
                hDamageTable.victim = enemy
                ApplyDamage(hDamageTable)
	        end
	    end

	    return interval
	end)
end

nanaya_clones1 = nanaya_clones1 or class({})

function nanaya_clones1:ComboD(caster, target, dmg)
	caster:AddNewModifier(caster, self, "nanaya_jump_revoke", {duration = 1.2})
	local table = {12, 13, 21}
	
	local knockback_push1 = caster:GetForwardVector()
	local numslash = 0
	local somerandom = {ACT_SCRIPT_CUSTOM_1, ACT_DOTA_CAST_ABILITY_3, ACT_SCRIPT_CUSTOM_1}
	local dmg = dmg + math.floor(caster:GetAgility()*4)

	Timers:CreateTimer(0.05, function()
	    Timers:CreateTimer(0.1, function()
	        target:AddNewModifier(caster, self, "modifier_generic_stun", { Duration = 0.4 })
	        caster:SetRenderAlpha(0)
	        if not somerandom[numslash] == nil then end
	
            if numslash < 3 then
	            numslash = numslash+1
	            
                local nanaya_clone2 = ParticleManager:CreateParticle("particles/nanaya_image_clone1.vpcf", PATTACH_CUSTOMORIGIN, caster)
                local knife = ParticleManager:CreateParticle("particles/maybedashvpcffinal1.vpcf", PATTACH_CUSTOMORIGIN, caster)
                              ParticleManager:SetParticleControlEnt(knife, 0, caster, PATTACH_POINT_FOLLOW, "attach_hand", caster:GetAbsOrigin(), true)
                              ParticleManager:SetParticleControl(knife, 4, target:GetAbsOrigin())
											
	            ParticleManager:SetParticleControl(nanaya_clone2, 0, caster:GetAbsOrigin()) --0.35
	            ParticleManager:SetParticleControl(nanaya_clone2, 2, Vector(0, table[numslash], 10))
	            ParticleManager:SetParticleControl(nanaya_clone2, 4, target:GetAbsOrigin())
	
                knockback_push = target:GetAbsOrigin() - knockback_push1*120
	            
                caster:SetOrigin(knockback_push)
	
	            local nanaya_clone = ParticleManager:CreateParticle("particles/nanaya_image_clon2.vpcf", PATTACH_CUSTOMORIGIN, caster)							
	                                 ParticleManager:SetParticleControl(nanaya_clone, 0, knockback_push) --0.35
	                                 ParticleManager:SetParticleControl(nanaya_clone, 2, Vector(4, table[numslash], 0))
	                                 ParticleManager:SetParticleControl(nanaya_clone, 4, target:GetAbsOrigin())
	
	            local test = string.format("nanaya.clonetp%s", numslash)
    
	            caster:EmitSound(test)
		
                 local knockback = { should_stun = 1,
                                     knockback_duration = 0.05,
                                     duration = 0.05,
                                     knockback_distance = 250,
                                     knockback_height = 0,
                                     center_x = knockback_push.x,
                                     center_y = knockback_push.y,
                                     center_z = target:GetAbsOrigin().z }
										
			    Timers:CreateTimer(0.15, function()
			        ParticleManager:CreateParticle("particles/nanaya_work_2.vpcf", PATTACH_ABSORIGIN, target)
			        if numslash == 3 then
			            ParticleManager:SetParticleControl(nanaya_clone, 2, Vector(4, table[numslash], 0))
			            caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 5)
			            local test_hit = ParticleManager:CreateParticle("particles/nanaya_hit_test.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
			                             ParticleManager:SetParticleControl(test_hit, 1, target:GetAbsOrigin() + knockback_push1 * 120)
			                             ParticleManager:SetParticleControl(test_hit, 0, target:GetAbsOrigin())
			        end
		
			        target:EmitSound("nanaya.slash")
			        target:AddNewModifier(caster, self, "modifier_knockback", knockback)
			        
                    ApplyDamage({
                                  victim = target,
                                  attacker = caster,
                                  damage = dmg,
                                  damage_type = DAMAGE_TYPE_PHYSICAL,
                                  damage_flags = 1024,
                                  ability = self
                                })
                    
                    ScreenShake(target:GetOrigin(), 10, 1.0, 0.1, 2000, 0, true)
				end)
	        
            return 0.3
	        
            else
                caster:RemoveModifierByName("nanaya_jump_revoke")
                caster:RemoveEffects(32)
                caster:SetRenderAlpha(255)
                
                FindClearSpaceForUnit(caster, caster:GetOrigin(), true)
                nanaya_clones1:clones_2D(caster, target, knockback_push1, dmg)
	        end
	    end)
	end)
end
function nanaya_clones1:clones_2D(caster, target, knockback_push1, dmg)
	local table = {12, 13, 12}
	local numberhit = 0
	local clone_dmg = dmg
	
    Timers:CreateTimer(0.1, function()
        target:AddNewModifier(caster, self, "modifier_generic_stun", { duration = 0.4 })
		if numberhit < 3 then
		    knockback_push = target:GetAbsOrigin() + knockback_push1*120
			numberhit = numberhit + 1
			local nanaya_clone = ParticleManager:CreateParticle("particles/nanaya_image_clone.vpcf", PATTACH_CUSTOMORIGIN, caster)						
	                             ParticleManager:SetParticleControl(nanaya_clone, 0, knockback_push) --0.35
	                             ParticleManager:SetParticleControl(nanaya_clone, 2, Vector(3, table[numberhit], 0))
	                             ParticleManager:SetParticleControl(nanaya_clone, 4, target:GetAbsOrigin())
	
	 
            local knockback = { should_stun = 1,
                                knockback_duration = 0.1,
                                duration = 0.1,
                                knockback_distance = 250,
                                knockback_height = 0,

                                center_x = knockback_push.x,
                                center_y = knockback_push.y,
                                center_z = target:GetAbsOrigin().z }
										
			Timers:CreateTimer(0.15, function()
			    ParticleManager:CreateParticle("particles/nanaya_work_2.vpcf", PATTACH_ABSORIGIN, target)
	            if numberhit == 3 then
			        ParticleManager:SetParticleControl(nanaya_clone, 2, Vector(4, table[numslash], 0))
			        local test_hit = ParticleManager:CreateParticle("particles/nanaya_hit_test.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
			        ParticleManager:SetParticleControl(test_hit, 1, target:GetAbsOrigin() - knockback_push1 * 120)
			        ParticleManager:SetParticleControl(test_hit, 0, target:GetAbsOrigin())
			    end
			
			    target:EmitSound("nanaya.slash")
			    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
			    
                ApplyDamage({
                              victim = target,
                              attacker = caster,
                              damage = dmg,
                              damage_type = DAMAGE_TYPE_PHYSICAL,
                              damage_flags = 1024,
                              ability = self
                            })
			    
                ScreenShake(target:GetOrigin(), 10, 1.0, 0.1, 2000, 0, true)
			end)
			
	        return 0.3
	
	    end
	end)
end


nanaya_slashes_modifier1 = nanaya_slashes_modifier1 or class({})

function nanaya_slashes_modifier1:OnCreated(args)
    if IsServer() then 
	    self.caster = self:GetParent()
	    self.target = EntIndexToHScript(args.target)
	    self.truecaster = EntIndexToHScript(args.vector)
	    self.particle = args.part
	    
        self:StartIntervalThink(0.05)
	    
        self.sin1 = Physics:Unit(self.target)
	    self.target:SetPhysicsFriction(0)
	    self.target:SetPhysicsVelocity(self.truecaster:GetForwardVector() * 1000)
	    self.target:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
	    self.target:SetGroundBehavior (PHYSICS_GROUND_LOCK)
	  
	    self.target:OnPreBounce(function(unit, normal) -- stop the pushback when unit hits wall
            unit:OnPreBounce(nil)
            unit:SetBounceMultiplier(0)
            unit:PreventDI(false)
            unit:SetPhysicsVelocity(Vector(0,0,0))
            unit:SetGroundBehavior (PHYSICS_GROUND_NOTHING)
		end)
    end
end		
function nanaya_slashes_modifier1:OnIntervalThink()	
    if not self.truecaster:IsAlive() or self.truecaster:IsStunned() then
        self:Destroy() 
    end		
end		
function nanaya_slashes_modifier1:OnDestroy()
	if IsServer() then 
        self.target:OnPreBounce(nil)
        self.target:SetBounceMultiplier(0)
        self.target:PreventDI(false)
        self.target:SetPhysicsVelocity(Vector(0,0,0))
        self.target:SetGroundBehavior (PHYSICS_GROUND_NOTHING)
		self.truecaster:OnPreBounce(nil)
        self.truecaster:SetBounceMultiplier(0)
		self.truecaster:PreventDI(false)
        self.truecaster:SetPhysicsVelocity(Vector(0,0,0))
        self.truecaster:SetGroundBehavior (PHYSICS_GROUND_NOTHING)
		
        ParticleManager:DestroyParticle(self.particle, false)
        ParticleManager:ReleaseParticleIndex(self.particle)
	end
end
		

nanaya_slashes_modifier = nanaya_slashes_modifier or class({})

function nanaya_slashes_modifier:GetPriority() return MODIFIER_PRIORITY_HIGH end
function nanaya_slashes_modifier:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function nanaya_slashes_modifier:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function nanaya_slashes_modifier:OnCreated()
    if IsServer() then
        self.parent = self:GetParent()
        self.ability = self:GetAbility()
        self.point = self.ability:GetCursorPosition()
        self.distances = 500
        self.direction = (self.point - self.parent:GetAbsOrigin()):Normalized()
        
        self:StartIntervalThink(FrameTime())
    end
end
function nanaya_slashes_modifier:OnIntervalThink()
	self:UpdateHorizontalMotion(self:GetParent(), FrameTime())
end
function nanaya_slashes_modifier:UpdateHorizontalMotion(hero, times)
    if self.distances >= 0 then 
	    local speed = 900 * times
	    local parent_pos = self.parent:GetAbsOrigin()

	    self.next_pos = parent_pos + self.direction * speed
	    self.distances = self.distances - speed
	    self.parent:SetOrigin(self.next_pos)
	    self.parent:FaceTowards(self.point)
	else
	    self:Destroy()
	end
end
function nanaya_slashes_modifier:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function nanaya_slashes_modifier:OnDestroy()
	if IsServer() then
        self.parent:InterruptMotionControllers(true)
    end
end

---------------------------------------------------------------------------------------------------------------
-- Nanaya Jump Slash (F)
---------------------------------------------------------------------------------------------------------------

LinkLuaModifier("nanaya_jump_slashes_modifier_back", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("nanaya_jump_slashes_modifier", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("nanaya_jump_revoke", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)

nanaya_jump_revoke = nanaya_jump_revoke or class({})

function nanaya_jump_revoke:CheckState()
    local state = { 
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                    [MODIFIER_STATE_DISARMED] = true,
                    [MODIFIER_STATE_SILENCED] = true,
                    [MODIFIER_STATE_MUTED] = true,
                  }
	return state
end


nanaya_jump_slashes = nanaya_jump_slashes or class({})

function nanaya_jump_slashes:OnSpellStart()
    local caster = self:GetCaster()
    self.kappa = false
    local iTalentMult = (caster:HasTalent("special_bonus_nanaya_25r")
                            and caster:FindTalentValue("special_bonus_nanaya_25r")
                            or 1)
    caster:EmitSound("nanaya.rstart")

    if caster:HasModifier("modifier_nanaya_animation_knife") then 
        caster:AddNewModifier(caster, self, "nanaya_jump_slashes_modifier", {knife = true})
        caster:StartGestureWithPlaybackRate(ACT_SCRIPT_CUSTOM_8, 2.1 * iTalentMult)
        caster:RemoveModifierByName("modifier_nanaya_animation_knife")
    else
        local point = GetGroundPosition(caster:GetAbsOrigin() + caster:GetForwardVector()*350, caster)
        local jump = ParticleManager:CreateParticle("particles/shiki_afterearth2final.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(jump, 0, point)
        local jump_clones = ParticleManager:CreateParticle("particles/nanaya_image_clone_rework.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControl(jump_clones, 4, caster:GetAbsOrigin() + caster:GetForwardVector())
								
        caster:AddNewModifier(caster, self, "nanaya_jump_revoke", {duration = 1})

        local point = self:GetCursorPosition() + RandomVector(1)
        local direction = (point - caster:GetAbsOrigin()):Normalized()
		
		local knockback = { should_stun = false,
                            knockback_duration = 0.75 / iTalentMult,
                            duration = 0.75 / iTalentMult,
                            knockback_distance = 250,
                            knockback_height = 90,
                            
                            center_x = caster:GetAbsOrigin().x + caster:GetForwardVector().x * 350,
                            center_y = caster:GetAbsOrigin().y + caster:GetForwardVector().y * 350,
                            center_z = caster:GetAbsOrigin().z }
									
        caster:AddNewModifier(caster, self, "modifier_knockback", knockback)
									
		Timers:CreateTimer( (0.9 / iTalentMult), function()
		    caster:AddNewModifier(caster, self, "nanaya_jump_slashes_modifier", {iTalent = iTalentMult})
			local qdProjectile =  {
                                    Ability = self,
                                    EffectName = nil,
                                    iMoveSpeed = 700,
                                    vSpawnOrigin = caster:GetOrigin(),
                                    fDistance =  700,
                                    fStartRadius = 150,
                                    fEndRadius = 150,
                                    Source = caster,
                                     bHasFrontalCone = true,
                                    bReplaceExisting = true,
                                    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                                    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                                    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                    fExpireTime = GameRules:GetGameTime() + 2.0,
                                    bDeleteOnHit = true,
                                    vVelocity = direction * (700 * iTalentMult), 
                                    ExtraData = { nil }
                                  }
		    local projectile = ProjectileManager:CreateLinearProjectile(qdProjectile)
		    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_6, 0.72 * iTalentMult)
		end)
    end
end
function nanaya_jump_slashes:GetCastPoint()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_nanaya_animation_knife") then 
        return 0.15
    else
        return 0.2
    end
end
function nanaya_jump_slashes:OnProjectileHit_ExtraData(hTarget, vLocation, tData)
    local check = tData.knife
    local slash = 7
    
    if hTarget == nil or self.kappa == true then return end
    
    self.kappa = true
    hTarget:EmitSound("nanaya.finalhit")
    hTarget:AddNewModifier(caster, self, "modifier_stunned", { duration = 1 })
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName("nanaya_blood_modifier")
    local dmg = self:GetSpecialValueFor("dmg")
    if modifier:GetStackCount()+slash > modifier:GetMaxStackCount() then
        modifier:SetStackCount(modifier:GetMaxStackCount())
    else
        modifier:SetStackCount(modifier:GetStackCount()+slash)
    end

    local particle = ParticleManager:CreateParticle("particles/test_part_small1.vpcf", PATTACH_CUSTOMORIGIN, caster)
                     ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin() - caster:GetForwardVector()*250 + Vector (0, 0, 400))


    caster:EmitSound("nanaya.trigger")
    local ability = self
    
    ApplyDamage({
                    victim = hTarget,
                    attacker = caster,
                    damage = dmg,
                    damage_type = DAMAGE_TYPE_PURE,
                    damage_flags = 1024,
                    ability = self
                })

    caster:FadeGesture(ACT_DOTA_CAST_ABILITY_6)
    caster:StartGestureWithPlaybackRate(ACT_SCRIPT_CUSTOM_10, 1.4)

    caster:RemoveModifierByName("nanaya_jump_slashes_modifier")
    
    if tData.knife ~= nil then 
        FindClearSpaceForUnit(caster, caster:GetAbsOrigin() + caster:GetForwardVector()*400 , true) 
    else
        FindClearSpaceForUnit(caster, caster:GetAbsOrigin() + caster:GetForwardVector()*500 , true) 
        local hit2 = ParticleManager:CreateParticle("particles/screen_spla22.vpcf", PATTACH_EYES_FOLLOW, hTarget)
        local culling_kill_particle = ParticleManager:CreateParticle("particles/nanaya_work_2.vpcf", PATTACH_ABSORIGIN, hTarget)
        ParticleManager:SetParticleControl(particle, 5, caster:GetAbsOrigin() + caster:GetForwardVector()*250 + Vector (0, 0, -100))
        local part2 = ParticleManager:CreateParticle("particles/hit21.vpcf", PATTACH_CUSTOMORIGIN, caster)
                      ParticleManager:SetParticleControl(part2, 0, caster:GetAbsOrigin() + Vector(0, 0, 0))
    end
end

	
nanaya_jump_slashes_modifier_back = nanaya_jump_slashes_modifier_back or class({})

function nanaya_jump_slashes_modifier_back:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function nanaya_jump_slashes_modifier_back:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        --[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,

                    }
    return state
end

function nanaya_jump_slashes_modifier_back:OnCreated()
    if IsServer() then
        self.distances = 600
        speed = 500 * FrameTime()
        self.parent = self:GetParent()
        self.point_1 = self.parent:GetAbsOrigin() - self.parent:GetForwardVector()*500
        self.point = GetGroundPosition(self.point_1, self.parent)
        self.direction = (self.point - self.parent:GetAbsOrigin()):Normalized()
        
        self:StartIntervalThink(FrameTime())
    end
end			
function nanaya_jump_slashes_modifier_back:OnIntervalThink()			
    self:UpdateHorizontalMotion(self.parent, FrameTime())
end
function nanaya_jump_slashes_modifier_back:UpdateHorizontalMotion(hero, times)
    if self.distances >= 0 then 
        parent_pos = self.parent:GetAbsOrigin()
        self.next_pos = parent_pos + self.direction * speed 
        self.distances = self.distances - speed
        self.parent:SetOrigin(self.next_pos + Vector(0, 0, 3))
	else 
        self:Destroy()
	end
end		
function nanaya_jump_slashes_modifier_back:OnDestroy()
    self.parent:SetBounceMultiplier(0)
    self.parent:PreventDI(false)
    self.parent:SetPhysicsVelocity(Vector(0,0,0))
end


nanaya_jump_slashes_modifier = nanaya_jump_slashes_modifier or class({})
function nanaya_jump_slashes_modifier:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function nanaya_jump_slashes_modifier:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        --[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                        [MODIFIER_STATE_INVULNERABLE] = true,
                        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                    }
    return state
end
function nanaya_jump_slashes_modifier:OnCreated(args)
    if IsServer() then
        self.parent = self:GetParent()
        self.ability = self:GetAbility()
        self.point_1 = self.parent:GetAbsOrigin() + self.parent:GetForwardVector()*1200
        self.point = GetGroundPosition(self.point_1, self.parent) 
        self.height = GetGroundHeight(self.point, self.parent)
        self.iTalentMult = args.iTalent or 1

        self.distances = 600
        self.back = 600
        self.direction = (self.point - self.parent:GetAbsOrigin()):Normalized()

        self.nanayaframechange = 0
        speed = (550 * self.iTalentMult) * FrameTime()
        self.checking = self.back / (550 * FrameTime())

        checkout = 0

        self.vector = Vector(0, 0, (256/self.checking)/self.checking)
        self.vector_1 = Vector(0, 0, (256/self.checking)/self.checking)
        self.interesting = self.parent:GetAbsOrigin().z/self.checking

        self:StartIntervalThink(FrameTime())
        self.check2 = 0
        self.anothercheck = 500/self.checking
    end
end
function nanaya_jump_slashes_modifier:OnIntervalThink()
	self:UpdateHorizontalMotion(self:GetParent(), FrameTime())
	if self.nanayaframechange < 46 then
	    self.nanayaframechange = self.nanayaframechange + 1
	end
end
function nanaya_jump_slashes_modifier:UpdateHorizontalMotion(hero, times)
    if self.distances >= 0 then 
        speed = speed+0.2
        parent_pos = self.parent:GetAbsOrigin()

        self.next_pos = parent_pos + self.direction * speed 
        self.distances = self.distances - speed
        self.parent:SetOrigin(self.next_pos + Vector(0, 0, 4))
    else 
        self:UpdateVerticalMotion(self:GetParent(), FrameTime())
	end
end		
function nanaya_jump_slashes_modifier:UpdateVerticalMotion(hero, times)
    if self.check2 == 0 then
	    self.check2 = 1
	end
    
	if self.back >= 0 then
	    parent_pos = self.parent:GetAbsOrigin()
	    self.vector = self.vector_1 + self.vector
            
	    self.next_pos = parent_pos + self.direction * speed 
	    self.back = self.back - speed
        
	    self.check1 = self.next_pos - self.vector*2 
	    self.parent:SetOrigin(self.next_pos - self.vector*2)
	else
	    self:Destroy()
	end
end
function nanaya_jump_slashes_modifier:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function nanaya_jump_slashes_modifier:OnDestroy()
	if IsServer() then
	    self.parent:FadeGesture(ACT_SCRIPT_CUSTOM_8)
        self.parent:InterruptMotionControllers(true)
	end
end

---------------------------------------------------------------------------------------------------------------
-- Nanaya Combo (R)
---------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_nanaya_combo", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("nanaya_combo_attack", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("nanaya_combo_cd", "abilities/nanaya/nanaya_new", LUA_MODIFIER_MOTION_NONE)

nanaya_combo = nanaya_combo or class({})

function nanaya_combo:OnSpellStart()
    local hCaster = self:GetCaster()
    hCaster:AddNewModifier(hCaster, self, "nanaya_combo_attack", { duration = 1})			
end					
function nanaya_combo:Alternate(caster, target, ability)
    PlayerResource:SetCameraTarget(target:GetPlayerID(), caster)
    PlayerResource:SetCameraTarget(caster:GetPlayerID(), caster)
    local combo_part = ParticleManager:CreateParticle(nil, PATTACH_ABSORIGIN_FOLLOW, target)
    EmitGlobalSound("nanaya.combo_execute")
    print ("that", caster:GetOrigin())

    caster:Stop()
    target:AddNewModifier(caster, self, "modifier_nanaya_combo", {duration = 3})
    caster:AddNewModifier(caster, self, "modifier_nanaya_combo", {duration = 3})
    target:Stop()
    
    local sec2 = target:GetAbsOrigin()
    local sec1 = caster:GetOrigin()

    local targetabs = target:GetAbsOrigin()

	caster:SetAbsAngles(0, 0, 0)
	caster:Stop()
	target:SetAbsAngles(0, 0, 0)
    caster:SetForwardVector(Vector(-1, 0, 0))
	target:SetForwardVector(Vector(1, 0, 0))

    local targetforwardvector = target:GetForwardVector()
	local player = target:GetPlayerOwner()
	local player2 = caster:GetPlayerOwner()
	local ff2 = math.floor(target:GetLocalAngles().y)

    local nanaya_knife2 = nil


			
    caster:Stop()
    caster:StartGestureWithPlaybackRate(ACT_SCRIPT_CUSTOM_16, 1.4)
    caster:SetOrigin(targetabs + targetforwardvector*90)

    target:Stop()

    Timers:CreateTimer(0.15, function()
        caster:EmitSound("nanaya.kekshi1")
        local nanaya_knife = ParticleManager:CreateParticle("particles/nanaya_last_arc.vpcf", PATTACH_CUSTOMORIGIN, caster)
                             ParticleManager:SetParticleControlEnt(nanaya_knife, 0, caster, PATTACH_POINT, "attach_knife", caster:GetAbsOrigin(), true)

        local nanaya_knife1 = ParticleManager:CreateParticle("particles/nanaya_last_arc2.vpcf", PATTACH_CUSTOMORIGIN, caster)
                              ParticleManager:SetParticleControlEnt(nanaya_knife1, 0, caster, PATTACH_POINT_FOLLOW, "attach_knife", caster:GetAbsOrigin(), true)

        Timers:CreateTimer(0.30, function()
            local knife = ParticleManager:CreateParticle("particles/maybedashvpcffinalfinal.vpcf", PATTACH_CUSTOMORIGIN, caster)
                          ParticleManager:SetParticleControlEnt(knife, 0, caster, PATTACH_POINT_FOLLOW, "attach_hand", caster:GetAbsOrigin(), true)
                          ParticleManager:SetParticleControl(knife, 4, target:GetAbsOrigin())
        end)

        Timers:CreateTimer(0.350, function()
	        ParticleManager:CreateParticleForPlayer("particles/screen_spla22_ark.vpcf", PATTACH_EYES_FOLLOW, caster, player)
            ParticleManager:CreateParticleForPlayer("particles/screen_spla22_ark.vpcf", PATTACH_EYES_FOLLOW, caster, player2)

	        local nanaya_hit = target:GetAbsOrigin() + Vector(0, 0, (target:GetAttachmentOrigin(0).z - target:GetOrigin().z)) + caster:GetForwardVector()*-45
            caster:SetOrigin(nanaya_hit)
            nanaya_knife2 = ParticleManager:CreateParticle("particles/test_part2.vpcf", PATTACH_CUSTOMORIGIN, caster)

            ParticleManager:SetParticleControl(nanaya_knife2, 0, targetabs + Vector (0, 0, 100))



            local check = target:GetAttachmentOrigin(target:ScriptLookupAttachment("ATTACH_HITLOC"))
            print (check)
            check4 = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hand"))
            print ()
        end)
    end)

    Timers:CreateTimer(1.20, function()
        ScreenShake(targetabs, 14, 20, 1, 2000, 0, true)
        local nanaya_knife1 = ParticleManager:CreateParticle("particles/pa_arcana_phantom_strike_end2.vpcf", PATTACH_CUSTOMORIGIN, caster)
                              ParticleManager:SetParticleControlEnt(nanaya_knife1, 0, caster, PATTACH_POINT, "attach_hand", caster:GetAbsOrigin(), true)
        
        Timers:CreateTimer(0.5, function()
            local nanaya_knife10 = ParticleManager:CreateParticle("particles/maybedashvpcffinalfinal.vpcf", PATTACH_CUSTOMORIGIN, caster)
                                   ParticleManager:SetParticleControlEnt(nanaya_knife10, 0, caster, PATTACH_POINT_FOLLOW, "attach_hand", caster:GetAbsOrigin(), true)
                                   ParticleManager:SetParticleControl(nanaya_knife10, 4, targetabs + targetforwardvector*300)
	        
            ParticleManager:CreateParticleForPlayer("particles/screen_spla22_ark.vpcf", PATTACH_EYES_FOLLOW, caster, player)
            ParticleManager:CreateParticleForPlayer("particles/screen_spla22_ark.vpcf", PATTACH_EYES_FOLLOW, caster, player2)

            --Timers:CreateTimer(0.15, function()
                caster:StartGestureWithPlaybackRate(ACT_SCRIPT_CUSTOM_21, 1)
            --end)
            caster:SetOrigin(target:GetAbsOrigin() + target:GetForwardVector()*300)


            Timers:CreateTimer(0.40, function()
                
                Timers:CreateTimer(0.20, function()
                    local check1 = ParticleManager:CreateParticle("particles/ls_ti10_immortal_infest_groundfollow_trace.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
                                   ParticleManager:SetParticleControl(check1, 0, target:GetAbsOrigin())
 
                    local check2 = target:GetAbsOrigin() - target:GetForwardVector()*400
	                print (check2.x)
                end)
                
                Timers:CreateTimer(0.0350, function()
			        ParticleManager:DestroyParticle(combo_part, true)
	                CustomGameEventManager:Send_ServerToPlayer(player, "nanaya_screen", {})
                    CustomGameEventManager:Send_ServerToPlayer(player2, "enable_ui", {})

                   Timers:CreateTimer(0.120, function()
		               local effect_cast = ParticleManager:CreateParticle( "particles/justcheck.vpcf", PATTACH_CUSTOMORIGIN, target)
                                           ParticleManager:SetParticleControl(effect_cast, 0, target:GetAbsOrigin() + Vector(0, 0, 150))
		                                   ParticleManager:SetParticleControlForward(effect_cast, 1, (target:GetOrigin()-caster:GetOrigin()):Normalized() )
		               
                       target:Kill(self, caster)
		               PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
                       PlayerResource:SetCameraTarget(target:GetPlayerID(), nil)
                    end)
                end)
            end)
        end)
    end)
end
	

modifier_nanaya_combo = modifier_nanaya_combo or class({})
function modifier_nanaya_combo:CheckState()
 local func = {
                [MODIFIER_STATE_COMMAND_RESTRICTED] = true, 
                [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                [MODIFIER_STATE_ROOTED] = false,
	            [MODIFIER_STATE_INVULNERABLE] = true,
             }
  return func
end


nanaya_combo_attack = nanaya_combo_attack or class({})
	
function nanaya_combo_attack:DeclareFunctions()
    local func = {
                   MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                   MODIFIER_EVENT_ON_TAKEDAMAGE,
                 }
    return func
end
function nanaya_combo_attack:GetModifierIncomingDamage_Percentage() 
    if IsServer() then        
        return -100
    end
end		
function nanaya_combo_attack:FilterUnits(caster, target)    
    local filter = UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, caster:GetTeamNumber())
    return true
end		
function nanaya_combo_attack:OnTakeDamage(args)	
    if IsServer() then 
        local caster = self:GetParent()
        local target = args.attacker
		
        if args.unit ~= self:GetParent() then return end
		
        local damageTaken = args.original_damage
        if damageTaken >= 499 and caster:GetHealth() ~= 0 and self:FilterUnits(caster, target) then
		    nanaya_combo:Alternate(caster, target, self:GetAbility())
		    self:Destroy()
        end
    end
end


nanaya_combo_cd = nanaya_combo_cd or class({})

function nanaya_combo_cd:IsHidden() return false end
function nanaya_combo_cd:RemoveOnDeath() return false end
function nanaya_combo_cd:IsDebuff() return true end
function nanaya_combo_cd:GetTexture()
	return "custom/nanaya/nanaya_combo"
end
function nanaya_combo_cd:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end