LinkLuaModifier("gogeta_track_combos","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gogeta_COMBO_EQ","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gogeta_COMBO_DFD","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gogeta_COMBO_DFE","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_disable_actions","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gogeta_stunned","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marked","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)

Gogeta_Air_Time_Ready = 0

-- This modifier tracks all the combos and changes the abilities accordingly
-- This modifier is added to Gogeta after learning his Kamehameha ability
gogeta_track_combos = gogeta_track_combos or class ({})

function gogeta_track_combos:IsHidden() return false end
function gogeta_track_combos:IsPurgable() return false end
function gogeta_track_combos:RemoveOnDeath() return false end
function gogeta_track_combos:DeclareFunctions()
    return {
               --MODIFIER_EVENT_ON_ABILITY_EXECUTED,
			   MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
           }
end
function gogeta_track_combos:OnCreated(hTable)
   if IsServer() then
        self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.Combo  = nil
		
		self.hComboTable = {
                                -- Cast E              = 2 stacks
								-- Cast D              = 2 stacks
								-- Cast F              = 3 stacks
								COMBO_EQ               = "modifier_gogeta_COMBO_EQ",  -- For True requires 2 stacks
								COMBO_DFD              = "modifier_gogeta_COMBO_DFD", -- For True requires 5 - 7 stacks
								COMBO_DFE              = "modifier_gogeta_COMBO_DFE", -- For True requires 5 - 7 stacks
                           }
		
	end
end
function gogeta_track_combos:OnAbilityFullyCast(keys)
    local ability = keys.ability
    local Combo_Timer = self.Combo
    
	if Combo_Timer then
	  Timers:RemoveTimer(Combo_Timer)
	end
    
	-- Ability Q casted
	if ability:GetName() == "gogeta_kamehameha" then
      --self:SetStackCount(0)
	  --print("It works")
    end
	
	-- Ability E casted
	if ability:GetName() == "gogeta_kick_combo" then
      self.caster:AddNewModifier(self.caster, self, self.hComboTable.COMBO_EQ,{duration = 4.0})
	  self:SetStackCount(self:GetStackCount() + 2)
	  --print("It works")
	end
	
	-- Ability D casted
	if ability:GetName() == "gogeta_backhand" then
      self:SetStackCount(self:GetStackCount() + 2)
      --print("It works")
    end
	
	-- Ability F casted
	if ability:GetName() == "gogeta_upper_kick" then
      self:SetStackCount(self:GetStackCount() + 3)
	  --print("It works")
    end
	
	-- Ability D swapped casted
	if ability:GetName() == "gogeta_downward_punch" then
      self.caster:RemoveModifierByName(self.hComboTable.COMBO_DFD)
      self.caster:RemoveModifierByName(self.hComboTable.COMBO_DFE)
      self:SetStackCount(0)
	  --print("It works")
	end
	
       -- Ability E and D have been casted, change functionality of Ability Q
       -- Give Ability Q different behavior, change the Kamehameha's properties and animation
	   if self:GetStackCount() == 4 then
	   
         --self.caster:AddNewModifier(self.caster, self, self.hComboTable.COMBO_EWQ_or_WEQ,{duration = 3.0})
		 --self:SetStackCount(0)
	   -- Ability D and F have been casted, change functionality of ability D
	   -- Swap abiltiy D with a different ability
       elseif self:GetStackCount() >= 5 and self:GetStackCount() <= 7 and Gogeta_Air_Time_Ready > 0 then
	     self.caster:AddNewModifier(self.caster, self, self.hComboTable.COMBO_DFD,{duration = 3.0})
	     self.caster:AddNewModifier(self.caster, self, self.hComboTable.COMBO_DFE,{duration = 3.0})
		 self:SetStackCount(0)
       end
	   
	   if self:GetStackCount() > 0 then
	     self.Combo = Timers:CreateTimer(3.5,function() 
		 self:SetStackCount(0)
		 end)
	   end
    
	-- Ability D (Gogeta Backhand) casted
	--[[if ability:GetName() == "gogeta_backhand" then

        self:SetStackCount(1)
        elseif ability:GetName() == "gogeta_kick_combo" then
         -- Ability E casted
         if self:GetStackCount() == 1 then
         -- Ability W was casted before E, change functionality of ability Q or replace it with ability F
         -- Functionality should be added
         self:SetStackCount(2) -- Update stack count to indicate successful sequence
         else
         -- Ability E was casted before W or without W, reset the sequence
         self:SetStackCount(0)
         end
    end]]--
end

---------------------------------------------------------------------------------------------------------------
modifier_disable_actions = modifier_disable_actions or class ({})

function modifier_disable_actions:IsHidden() return false end
function modifier_disable_actions:IsPurgable() return false end
function modifier_disable_actions:RemoveOnDeath() return true end
function modifier_disable_actions:CheckState()
    local state = {
                      [MODIFIER_STATE_COMMAND_RESTRICTED] = true, -- Disable command inputs
                  }
    return state
end
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
modifier_marked = modifier_marked or class ({})

function modifier_disable_actions:IsHidden() return false end
function modifier_disable_actions:IsPurgable() return false end
function modifier_disable_actions:RemoveOnDeath() return true end
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
modifier_gogeta_stunned = modifier_gogeta_stunned or class ({})

function modifier_gogeta_stunned:IsHidden() return false end
function modifier_gogeta_stunned:IsPurgable() return false end
function modifier_gogeta_stunned:RemoveOnDeath() return true end
function modifier_gogeta_stunned:CheckState()
    local state = {
                      [MODIFIER_STATE_STUNNED] = true, -- Disable command inputs
                      [MODIFIER_STATE_PROVIDES_VISION] = true,
                  }
    return state
end
function modifier_gogeta_stunned:GetEffectName()
	return "particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_wave_iron.vpcf"
end
function modifier_gogeta_stunned:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
modifier_gogeta_COMBO_EQ = modifier_gogeta_COMBO_EQ or class ({})

function modifier_gogeta_COMBO_EQ:IsHidden() return false end
function modifier_gogeta_COMBO_EQ:IsPurgable() return false end
function modifier_gogeta_COMBO_EQ:RemoveOnDeath() return true end
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
modifier_gogeta_COMBO_DFD = modifier_gogeta_COMBO_DFD or class ({})

function modifier_gogeta_COMBO_DFD:IsHidden() return false end
function modifier_gogeta_COMBO_DFD:IsPurgable() return false end
function modifier_gogeta_COMBO_DFD:RemoveOnDeath() return true end
function modifier_gogeta_COMBO_DFD:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
	
	self.skills_table = {
                            ["gogeta_backhand"] = "gogeta_downward_punch",
                        }

    if IsServer() then
	  for k, v in pairs(self.skills_table) do
        if k and v then
          self.parent:SwapAbilities(k, v, false, true)
        end
      end
    end
end
function modifier_gogeta_COMBO_DFD:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_gogeta_COMBO_DFD:OnDestroy()
    if IsServer() then
      for k, v in pairs(self.skills_table) do
        if k and v then
          self.parent:SwapAbilities(k, v, true, false)
        end
      end
    end
end
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
modifier_gogeta_COMBO_DFE = modifier_gogeta_COMBO_DFE or class ({})

function modifier_gogeta_COMBO_DFE:IsHidden() return false end
function modifier_gogeta_COMBO_DFE:IsPurgable() return false end
function modifier_gogeta_COMBO_DFE:RemoveOnDeath() return true end
function modifier_gogeta_COMBO_DFE:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
	
	self.skills_table = {
                            ["gogeta_kick_combo"] = "gogeta_kick_combo_air_finisher",
                        }

    if IsServer() then
	  for k, v in pairs(self.skills_table) do
        if k and v then
          self.parent:SwapAbilities(k, v, false, true)
        end
      end
    end
end
function modifier_gogeta_COMBO_DFE:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_gogeta_COMBO_DFE:OnDestroy()
    if IsServer() then
      for k, v in pairs(self.skills_table) do
        if k and v then
          self.parent:SwapAbilities(k, v, true, false)
        end
      end
    end
end




---------------------------------------------------------------------------------------------------------------
-- Gogeta Kamehameha(Q)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_gogeta_q_pause","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE)

gogeta_kamehameha  = gogeta_kamehameha or class ({})

function gogeta_kamehameha:GetIntrinsicModifierName()
	return "gogeta_track_combos" -- Add the Combo Track modifier when this ability is learned
end
function gogeta_kamehameha:GetBehavior()
	 -- Change ability behavior based on modifier combo
	 return self:GetCaster():HasModifier("modifier_gogeta_COMBO_EQ") 
	        and DOTA_ABILITY_BEHAVIOR_NO_TARGET
            or DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end
function gogeta_kamehameha:OnAbilityPhaseStart() local hCaster = self:GetCaster() return true end
function gogeta_kamehameha:OnAbilityPhaseInterrupted() end
function gogeta_kamehameha:GetAbilityTextureName()
	-- Change ability icon based on modifier combo
	 return not self:GetCaster():HasModifier("modifier_gogeta_COMBO_EQ") 
	        and self.BaseClass.GetAbilityTextureName(self)
		    or "touma/1_2"
end
function gogeta_kamehameha:OnSpellStart()
    local hCaster = self:GetCaster()
	local hModifier = "modifier_gogeta_COMBO_EQ"
	local bAnimation = not hCaster:HasModifier(hModifier)
    local fDamage = self:GetSpecialValueFor("damage") * (bAnimation and 0.2 or 0.15)
	local hModifierName = bAnimation and "modifier_gogeta_q_pause" or "gogeta_track_combos"
	
	-- Values
	local timer_delay = bAnimation and 1.8 or 0.4
	local timer_stop = 0.1
	local timer_duration = bAnimation and 1.8 or 1.3
    local self_distance = bAnimation and 20 or 40  -- Distance to push the enemy in units
    local self_speed = bAnimation and 100 or 125    -- Speed at which the enemy is pushed in units per second
    
	-- Cringe Particle
	local start_loc = hCaster:GetAbsOrigin() + hCaster:GetForwardVector() * 32
    local cero_particle = bAnimation
	                      and "particles/gogeta_kamehameha_test.vpcf"
						  or "particles/gogeta_kamehameha_test_alt.vpcf"
	local cero_particle_end = "particles/gogeta_kamehameha_end.vpcf"
	local attach_point = hCaster:ScriptLookupAttachment("attach_attack1")
    local distance = self:GetCastRange(hCaster:GetAbsOrigin(),hCaster) + hCaster:GetCastRangeBonus()
	local endcapPos = hCaster:GetAbsOrigin() + hCaster:GetForwardVector() * distance
	
	-- Begin animation lock
	if bAnimation then
	  StartAnimation(hCaster, {duration=2.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
      hCaster:AddNewModifier(hCaster, self, "modifier_gogeta_q_pause",{duration = 4.0})
      EmitSoundOn("Gogeta.q1", hCaster)
	else
      hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_6)
      hCaster:AddNewModifier(hCaster, self, "modifier_disable_actions",{duration = 0.8})
	end
	
	-- Particles
	local pfx, pfx_ball, pfx_end
		
		Timers:CreateTimer(timer_delay,function()
		 -- Remove if Caster is stunned
		 if hCaster:IsStunned() or not hCaster:IsAlive() or not hCaster:HasModifier(hModifierName) then return end
		
	     -- Start Animation
		 if bAnimation then
		   StartAnimation(hCaster, {duration=1.8, activity=ACT_DOTA_CAST_ABILITY_1_END, rate=1})
		 end
		
		 -- Create Particle Effects
		 pfx = ParticleManager:CreateParticle(cero_particle, PATTACH_WORLDORIGIN, nil )
		 pfx_ball = ParticleManager:CreateParticle("particles/gogeta_kamehameha_big_ball.vpcf", PATTACH_WORLDORIGIN, nil )
	     pfx_end = ParticleManager:CreateParticle(cero_particle_end, PATTACH_WORLDORIGIN, nil )
		 --pfx = ParticleManager:CreateParticle(cero_particle, PATTACH_ABSORIGIN_FOLLOW, hCaster )
	     --pfx_end = ParticleManager:CreateParticle(cero_particle_end, PATTACH_ABSORIGIN_FOLLOW, hCaster )
		
		 -- Particle Manager
		 ParticleManager:SetParticleControl(pfx, 0, hCaster:GetAttachmentOrigin(attach_point))
		 ParticleManager:SetParticleControl(pfx_ball, 0, hCaster:GetAttachmentOrigin(attach_point))
	     ParticleManager:SetParticleControl(pfx_end, 0, hCaster:GetAttachmentOrigin(attach_point))
		 endcapPos = GetGroundPosition( endcapPos, nil )
	     endcapPos.z = endcapPos.z + 92
	     ParticleManager:SetParticleControl( pfx, 1, endcapPos )
	     ParticleManager:SetParticleControl( pfx_end, 3, endcapPos ) --IN ir EndCap your effect
		 
		 -- Sound Effects
         EmitSoundOn("Gogeta.kamehameha", hCaster)
		
		end)
	
	-- Set a timer for finding enemies in a straight line
	Timers:CreateTimer(timer_delay, function()
	    if timer_stop >= timer_duration or hCaster:IsStunned() or not hCaster:IsAlive() or not hCaster:HasModifier(hModifierName)  then
		  if IsNotNull(pfx) then 
		   ParticleManager:DestroyParticle( pfx, true )
		   ParticleManager:ReleaseParticleIndex( pfx )
		  end
		  if IsNotNull(pfx_ball) then 
		   ParticleManager:DestroyParticle( pfx_ball, true )
		   ParticleManager:ReleaseParticleIndex( pfx_ball )
		  end
		  if IsNotNull(pfx_end) then
		   ParticleManager:DestroyParticle( pfx_end, true )
		   ParticleManager:ReleaseParticleIndex( pfx_end )
		  end
		  if IsServer() then
		    hCaster:RemoveModifierByName("modifier_gogeta_q_pause")
			hCaster:StopSound("Gogeta.q1")
			hCaster:StopSound("Gogeta.kamehameha")
		  end
		 return
		end
		
	    -- Find enemies in a line
		local enemies = FindUnitsInLine(hCaster:GetTeamNumber(),
										start_loc,
										endcapPos,
										nil,
										self:GetSpecialValueFor("width"),
										self:GetAbilityTargetTeam(),
										self:GetAbilityTargetType(),
										self:GetAbilityTargetFlags() )
							
---------------------------------------------------------------------------------------------------		
		for _,enemy in pairs(enemies) do
			local damage_table = {	victim = enemy,
									attacker = hCaster,
									damage = fDamage,
									damage_type = self:GetAbilityDamageType(),
									ability = self }
									
			local direction = (enemy:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
            local pushTarget = enemy:GetAbsOrigin() + direction * self_distance
            local pushDuration = self_distance / self_speed						

			ApplyDamage(damage_table)
            enemy:AddNewModifier(hCaster, nil, "modifier_phased", { duration = pushDuration })
            if not hCaster:HasModifier("modifier_gogeta_powerup") then
			  enemy:AddNewModifier(hCaster, nil, "modifier_generic_slow", { duration = pushDuration })
			else
              enemy:AddNewModifier(hCaster, nil, "modifier_generic_stunned_lua", { duration = pushDuration })
			end
            enemy:SetAbsOrigin(pushTarget)		
		end
		
		-- Remove this timer after a certain set of time
		if timer_stop < timer_duration then
		 timer_stop = timer_stop + 0.1
         return 0.1
		end
	end)
end

---------------------------------------------------------------------------------------------------	
modifier_gogeta_q_pause = modifier_gogeta_q_pause or class({})

function modifier_gogeta_q_pause:IsHidden() return true end
function modifier_gogeta_q_pause:IsPurgeable() return false end
function modifier_gogeta_q_pause:RemoveOnDeath() return true end
function modifier_gogeta_q_pause:GetModifierDisableTurning() return 1 end
function modifier_gogeta_q_pause:DeclareFunctions()
	local funcs = {
	                  MODIFIER_PROPERTY_DISABLE_TURNING,
	              }
    return funcs
end
 function modifier_gogeta_q_pause:CheckState()
    local state =   { 
		                [MODIFIER_STATE_SILENCED] = true,
		                [MODIFIER_STATE_ROOTED] = true,
		                [MODIFIER_STATE_MUTED] = true,
		            }
    
	return state
end





-----------------------------------------------------------------------------------------------------------
-- Gogeta Powerup(W)
-----------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_gogeta_powerup","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)

gogeta_powerup  = gogeta_powerup or class ({})

function gogeta_powerup:OnAbilityPhaseStart() local hCaster = self:GetCaster() return true end
function gogeta_powerup:OnAbilityPhaseInterrupted() end
function gogeta_powerup:OnSpellStart()
    local hCaster = self:GetCaster()
	
	-- Add state modifier
    hCaster:AddNewModifier(hCaster, self, "modifier_gogeta_powerup", {duration = 20.0})
end

----------------------------------------------------------------------------------------------------------
modifier_gogeta_powerup = modifier_gogeta_powerup or class({})

function modifier_gogeta_powerup:IsHidden() return false end
function modifier_gogeta_powerup:IsDebuff() return false end
function modifier_gogeta_powerup:IsStunDebuff() return false end
function modifier_gogeta_powerup:IsPurgable() return false end
function modifier_gogeta_powerup:RemoveOnDeath() return true end
function modifier_gogeta_powerup:DeclareFunctions()
    local func = {
	                 MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
			     }
    
	return func
end
function modifier_gogeta_powerup:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor("spellamp")
end
function modifier_gogeta_powerup:OnCreated( kv )
	if IsClient() then
        if not self.AuraEffect then
            self.AuraEffect =  ParticleManager:CreateParticle("particles/gogeta_powerup_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())            
            self:AddParticle(self.AuraEffect, false, false, -1, false, false)
		end
	end
end
function modifier_gogeta_powerup:OnRefresh( kv )
    self:OnCreated( kv )
end
function modifier_gogeta_powerup:OnDestroy()
	if not IsServer() then return end
    local hCaster = self:GetCaster()

end





----------------------------------------------------------------------------------------------------------
-- Gogeta Kick Combo(E)
----------------------------------------------------------------------------------------------------------
gogeta_kick_combo = gogeta_kick_combo or class({})

function gogeta_kick_combo:GetOnUpgradeAbilities()
    local hTable =  {
                        "gogeta_kick_combo_air_finisher",
						"gogeta_rainbow_orb",
                    }
    return hTable
end
function gogeta_kick_combo:CastFilterResult()
	local hCaster         = self:GetCaster()

    return UF_SUCCESS
end
function gogeta_kick_combo:OnSpellStart()
	local hCaster 	= self:GetCaster()
	local hTarget   = self:GetCursorTarget()
	local fDuration = 3.0

	hCaster:AddNewModifier(hCaster, self, "modifier_akame_headbump", {duration = fDuration, enemy_target = hTarget:GetEntityIndex()})
	EmitSoundOn("Gogeta.e1", hCaster)
end
function gogeta_kick_combo:OnChannelFinish()
	local hCaster 	= self:GetCaster()
	
	if hCaster:HasModifier("modifier_akame_headbump") then
	  hCaster:RemoveModifierByName("modifier_akame_headbump")
	end
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_akame_headbump", "heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_gogeta_kick_combo_air_finisher", "heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_gogeta_kick_combo_air_finisher_tp", "heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)

-- MEGA CRINGE BUT SAVES A LOT OF TIME
modifier_akame_headbump = modifier_akame_headbump or class({})

function modifier_akame_headbump:IsHidden()                                 return false end
function modifier_akame_headbump:IsDebuff()                                 return false end
function modifier_akame_headbump:IsPurgable()                               return false end
function modifier_akame_headbump:IsPurgeException()                         return false end
function modifier_akame_headbump:RemoveOnDeath()                            return true end
function modifier_akame_headbump:GetPriority()                              return MODIFIER_PRIORITY_HIGH end
function modifier_akame_headbump:CheckState()
	local state = 	{
						[MODIFIER_STATE_MAGIC_IMMUNE] = true,
						[MODIFIER_STATE_DISARMED]	  = true
					}
	return state
end
function modifier_akame_headbump:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
                        MODIFIER_PROPERTY_DISABLE_TURNING
                    }
    return func
end
function modifier_akame_headbump:GetOverrideAnimation(keys)
    return ACT_DOTA_CAST_ABILITY_2
end
function modifier_akame_headbump:GetModifierIgnoreCastAngle(keys)
	return 1
end
function modifier_akame_headbump:GetModifierDisableTurning(keys)
    return 1
end
function modifier_akame_headbump:OnCreated(hTable)
    if IsServer() then
        self.caster  = self:GetCaster()
        self.parent  = self:GetParent()
        self.ability = self:GetAbility()

        self.CASTER_TEAM          = self.caster:GetTeamNumber()
        self.ABILITY_TARGET_TEAM  = "DOTA_UNIT_TARGET_TEAM_ENEMY" 
        self.ABILITY_TARGET_TYPE  = "DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
        self.ABILITY_TARGET_FLAGS = "DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES"
        
        self.hMainModifier = self.parent:FindModifierByNameAndCaster("modifier_akame_headbump", self.parent)
		self.hMainTarget = EntIndexToHScript(hTable.enemy_target)
		self.Test = 1
		
        
		self.fKnockbackDistance = 270
        self.fKnockbackDuration = 0.2
		self.iAttacksCount 		= 50
		self.fAttacksInterval   = 0.5
        self.fAttacksDamage     = self.ability:GetSpecialValueFor("damage")
		--self.fAttacksAgiDamage  = 20	
		  

		--self.fFollowSpeed       = self.fKnockbackDistance / self.fKnockbackDuration
		self.fFollowDistance 	= 180

		self.hKnockBackTable = {
									should_stun        = 1,
									knockback_duration = self.fKnockbackDuration,
									duration           = self.fKnockbackDuration,
									knockback_distance = self.fKnockbackDistance,
									knockback_height   = 0,
									center_x 		   = nil,
									center_y 		   = nil,
									center_z 		   = nil
								}

		--self.parent:SetForwardVector(GetDirection(self.hMainTarget, self.parent))

		self:StartIntervalThink(self.fAttacksInterval)
		self:OnIntervalThink()

        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_akame_headbump:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_akame_headbump:UpdateHorizontalMotion(me, dt)

	local vCurPos     = self.parent:GetOrigin()
	local vDirection  = GetDirection(self.hMainTarget, vCurPos)
	local fDistance   = GetDistance(self.hMainTarget, vCurPos)
 	local fUnitsPerDt = self.hMainTarget:GetIdealSpeed() * dt
 	local vNextPos    = vCurPos + vDirection * fUnitsPerDt * 3
 		  vNextPos    = fDistance <= self.fFollowDistance
 		  				and vCurPos
 		  				or vNextPos

	self.parent:SetOrigin(vNextPos)
    self.parent:SetForwardVector(vDirection, true)
    --self.parent:FaceTowards(self.hMainTarget:GetOrigin())
end
function modifier_akame_headbump:OnIntervalThink()
	if IsServer() then
        if self.iAttacksCount <= 0 then
            return
        end

        self.iAttacksCount = self.iAttacksCount - 1
        self.Test = self.Test + 1
		self.Test2 = self.Test

        if IsNotNull(self.hMainTarget) then
    		local vParentLoc = self.parent:GetOrigin()
			
        local hDamageTable = {
                                victim       = self.hMainTarget,
                                attacker     = self.parent, 
                                damage       = self.fAttacksDamage,
                                damage_type  = DAMAGE_TYPE_MAGICAL,
                                ability      = self.ability,
                                --damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK
                            }
			
			if self.Test >= 7 then
		      self.hKnockBackTable.knockback_distance = 1100
              self.hKnockBackTable.knockback_duration = 0.7
			  self.hKnockBackTable.duration = 1.2
            end			
			
            self.hKnockBackTable.center_x = vParentLoc.x
            self.hKnockBackTable.center_y = vParentLoc.y
            self.hKnockBackTable.center_z = vParentLoc.z

            self.hMainTarget:AddNewModifier(self.parent, self.ability, "modifier_knockback", self.hKnockBackTable, self.hMainTarget:IsOpposingTeam(self.CASTER_TEAM))

    		hDamageTable.damage = self.fAttacksDamage -- + ( self.parent:GetAgility() * self.fAttacksAgiDamage )

    		ApplyDamage(hDamageTable)
			
			if self.parent:HasModifier("modifier_gogeta_powerup") then
              hDamageTable.damage = self.hMainTarget:GetMaxHealth() * 0.01
              hDamageTable.damage_type = DAMAGE_TYPE_PURE
	          hDamageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
              ApplyDamage(hDamageTable)
			end

            --self:SetStackCount(self:GetStackCount() + 1)
            if not self.AuraEffect then
              self.AuraEffect = self.parent:HasModifier("modifier_gogeta_powerup")
			                    and ParticleManager:CreateParticle("particles/gogeta_hit_effect2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hMainTarget)
                                or ParticleManager:CreateParticle("particles/gogeta_hit_effect1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hMainTarget)					
              self:AddParticle(self.AuraEffect, false, false, -1, false, false)
			  self.AuraEffect = nil
		    end
			
			if self.Test2 > 3 then
			  self.Test2 = RandomInt(3, 5)
			end

            EmitSoundOn("Gogeta.hit"..self.Test2 - 1, self.hMainTarget)
			
           if self.Test == 3 then
		    if self.hMainTarget:HasModifier("modifier_knockback") then
             self.hMainTarget:RemoveModifierByName("modifier_knockback")
            end 
			-- Trigger AddNewModifier and ApplyDamage twice on self.Test reaching 3
			self.hMainTarget:AddNewModifier(self.parent, self.ability, "modifier_knockback", self.hKnockBackTable, self.hMainTarget:IsOpposingTeam(self.CASTER_TEAM))
			EmitSoundOn("Gogeta.hit"..self.Test2 + 1, self.hMainTarget)
			ApplyDamage(hDamageTable)
		   end	
        end
	end
end
function modifier_akame_headbump:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_akame_headbump:OnDestroy()
    if IsServer() then
        self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)

        --self.parent:RemoveHorizontalMotionController(self)
        self.parent:InterruptMotionControllers(true)
    end
end
function modifier_akame_headbump:GetEffectName()
	return "particles/gogeta_trail1.vpcf"
end
function modifier_akame_headbump:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
---------------------------------------------------------------------------------------------------------------
-- Gogeta Kick Combo Air Finisher(E)
---------------------------------------------------------------------------------------------------------------
gogeta_kick_combo_air_finisher  = gogeta_kick_combo_air_finisher or class ({})

function gogeta_kick_combo_air_finisher:GetAbilityTextureName()
	-- Change ability icon based on modifier combo
	 return not self:GetCaster():HasModifier("modifier_gogeta_kick_combo_air_finisher") 
	        and self.BaseClass.GetAbilityTextureName(self)
		    or "touma/1_3"
end
function gogeta_kick_combo_air_finisher:OnSpellStart()
    local hCaster = self:GetCaster()

    Teleport_Effect(hCaster)
	-- Add state modifier
    hCaster:AddNewModifier(hCaster, self, "modifier_gogeta_kick_combo_air_finisher_tp", {duration = 0.2, 
	                                                                                     param = "modifier_gogeta_kick_combo_air_finisher"
																			            })
   	EmitSoundOn("Gogeta.d1", hCaster)       
end
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
modifier_gogeta_kick_combo_air_finisher_tp = modifier_gogeta_kick_combo_air_finisher_tp or class({})

function modifier_gogeta_kick_combo_air_finisher_tp:IsHidden() return true end
function modifier_gogeta_kick_combo_air_finisher_tp:IsDebuff() return false end
function modifier_gogeta_kick_combo_air_finisher_tp:IsStunDebuff() return true end
function modifier_gogeta_kick_combo_air_finisher_tp:IsPurgable() return false end
function modifier_gogeta_kick_combo_air_finisher_tp:RemoveOnDeath() return false end
function modifier_gogeta_kick_combo_air_finisher_tp:CheckState()
	local state = {
		              [MODIFIER_STATE_OUT_OF_GAME] = true,
		              [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		              [MODIFIER_STATE_INVULNERABLE] = true,
		              [MODIFIER_STATE_STUNNED] = true,
	              }

	return state
end
function modifier_gogeta_kick_combo_air_finisher_tp:OnCreated( kv )
	if not IsServer() then return end
    local hCaster = self:GetCaster()
	
	self.parent = self:GetParent()
	self.modifier_param = kv.param
	self.enemy = nil
    self.parent:AddNoDraw()
	
	self.duration = self.parent:HasModifier("modifier_gogeta_kick_combo_air_finisher") 
	                and 9.0
					or 2.5
	self.stage    = self.parent:HasModifier("modifier_gogeta_kick_combo_air_finisher")
	                and 1
				    or 0
	
	-- Get enemies in the AIR who are also marked
    -- Find the closest enemy in a radius
	local enemies = FUnitsRadShort(hCaster, FIND_UNITS_EVERYWHERE, FIND_CLOSEST)
----------------------------------------------------------------------------------------------------------------   
	local closestEnemy = nil
	for _,enemy in pairs(enemies) do
        -- Get enemy in the AIR
	    if (enemy:HasModifier("modifier_gogeta_upper_kick_state") and enemy:HasModifier("modifier_marked")) or enemy:HasModifier("modifier_gogeta_stunned") then
		  closestEnemy = enemy
		  break
		end
    end
	
	self.enemy = closestEnemy
end
function modifier_gogeta_kick_combo_air_finisher_tp:OnDestroy()
	if not IsServer() then return end
    local hCaster = self:GetCaster()
    -- Animation
	self.parent:RemoveNoDraw()
	
	if not self.enemy or not self.modifier_param then return end
	
	-- Add air finisher modifier
    hCaster:AddNewModifier(hCaster, self, self.modifier_param, { duration = self.duration,-- duration
	                                                             enemy = self.enemy:entindex(), -- target 
																 stage = self.stage, -- stage of the modifier
																})
	self.enemy:AddNewModifier(hCaster, self, "modifier_gogeta_stunned", { duration = 10.0 } )															

	EmitSoundOn("Gogeta.d2", hCaster)
end

----------------------------------------------------------------------------------------------------------
-- Modifier for Horizontal and Vertical Motion
-- Progressive modifier with 3 stages
-- self.stage TRUE or FALSE
modifier_gogeta_kick_combo_air_finisher = modifier_gogeta_kick_combo_air_finisher or class({})

function modifier_gogeta_kick_combo_air_finisher:IsHidden()                                 return false end
function modifier_gogeta_kick_combo_air_finisher:IsDebuff()                                 return false end
function modifier_gogeta_kick_combo_air_finisher:IsPurgable()                               return false end
function modifier_gogeta_kick_combo_air_finisher:IsPurgeException()                         return false end
function modifier_gogeta_kick_combo_air_finisher:RemoveOnDeath()                            return true end
function modifier_gogeta_kick_combo_air_finisher:GetPriority()                              return MODIFIER_PRIORITY_HIGH end
function modifier_gogeta_kick_combo_air_finisher:CheckState()
	local state = 	{
						[MODIFIER_STATE_INVULNERABLE] = true,
						--[MODIFIER_STATE_MAGIC_IMMUNE] = true,
						[MODIFIER_STATE_MUTED] = true,
						[MODIFIER_STATE_DISARMED] = true,
					}
    if self.stage then
        state[MODIFIER_STATE_COMMAND_RESTRICTED] = true
    end
	return state
end
function modifier_gogeta_kick_combo_air_finisher:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
                        MODIFIER_PROPERTY_DISABLE_TURNING
                    }
    return func
end
function modifier_gogeta_kick_combo_air_finisher:GetOverrideAnimation(keys)
    return ACT_DOTA_ENFEEBLE
end
function modifier_gogeta_kick_combo_air_finisher:GetModifierIgnoreCastAngle(keys)
	return 1
end
function modifier_gogeta_kick_combo_air_finisher:GetModifierDisableTurning(keys)
    return 1
end
function modifier_gogeta_kick_combo_air_finisher:OnCreated(hTable)
    if IsServer() then
        self.caster  = self:GetCaster()
        self.parent  = self:GetParent()
        self.ability = self:GetAbility()
		self.stage   = hTable.stage > 0
		self.stage3  = nil
		self.finish  = nil
		self.set     = nil
		self.rainbow = nil
		self.hiddenA = nil
		self.counter = 0
        
		self.CASTER_TEAM  = self.caster:GetTeamNumber()

		self.hMainTarget = EntIndexToHScript(hTable.enemy) or self:Destroy()
		
        self.draw = self.stage 
		            and self.parent:AddNoDraw()
					or nil
					
        local hAbility = self.parent:FindAbilityByName("gogeta_kick_combo_air_finisher")
		if hAbility and not self.stage then
		   hAbility:EndCooldown()
		end
		
		self.fKnockbackDistance = 270
        self.fKnockbackDuration = 0.2
		self.iAttacksCount 		= 25
		self.fAttacksInterval   = 0.1
        self.fAttacksDamage     = 20
		--self.fAttacksAgiDamage  = 20	
		  

		--self.fFollowSpeed       = self.fKnockbackDistance / self.fKnockbackDuration
		self.fFollowDistance 	= 180

        self.hDamageTable = {
                                victim       = self.hMainTarget,
                                attacker     = self.parent, 
                                damage       = self.fAttacksDamage,
                                damage_type  = DAMAGE_TYPE_MAGICAL,
                                ability      = self.ability,
                                --damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK
                            }

		--self.parent:SetForwardVector(GetDirection(self.hMainTarget, self.parent))
		
		if self.hMainTarget:HasModifier("modifier_gogeta_upper_kick_state") or self.hMainTarget:HasModifier("modifier_marked") then
		   self.hMainTarget:RemoveModifierByName("modifier_gogeta_upper_kick_state")
		   self.hMainTarget:RemoveModifierByName("modifier_marked")
		end
		
        -- Check Abilities
	    for i = 0, self.parent:GetAbilityCount() - 1 do
		   local ability = self.parent:GetAbilityByIndex(i)
		   if ability then
		      -- Disable certain abilities
		       local ability_name = ability:GetName()
			   -- Make a table for the abilities maybe ?
		       if ability_name == "gogeta_downward_punch" or ability_name == "gogeta_kick_combo_air_finisher" or ability_name == "gogeta_rainbow_orb" then
			   else
                  ability:SetActivated(false)
			   end
		   end
	    end

		self:StartIntervalThink(self.fAttacksInterval)
		self:OnIntervalThink()

        if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_gogeta_kick_combo_air_finisher:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_gogeta_kick_combo_air_finisher:UpdateHorizontalMotion(me, dt)
	
	--=================================================================================================--
	local vCurPos     = self.parent:GetOrigin()
	local vDirection  = GetDirection(self.hMainTarget, vCurPos)
	local fDistance   = GetDistance(self.hMainTarget, vCurPos)
 	local fUnitsPerDt = self.hMainTarget:GetIdealSpeed() * dt
 	local vNextPos    = vCurPos + vDirection * fUnitsPerDt * 17
 		  vNextPos    = fDistance <= self.fFollowDistance
 		  				and vCurPos
 		  				or vNextPos
	--=================================================================================================--				
 	local vPushDirection = (self.hMainTarget:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
 	local vPushTarget = self.hMainTarget:GetAbsOrigin() + vPushDirection * 14
	--=================================================================================================--
	local vNewPos = self.hMainTarget:GetAbsOrigin()
 	local vRandDir = RandomVector(1):Normalized()
 	local fRandDist = RandomFloat(0, 120)
 	local fRandSpeed = RandomFloat(100, 120)
	--=================================================================================================--
 	vNewPos = vNewPos + vRandDir * fRandDist
	--=================================================================================================--
	
	if not self.stage then
	   -- First Stage

 	   self.parent:SetOrigin(vNextPos)
 	   self.hMainTarget:SetOrigin(vPushTarget)
 	   self.parent:SetForwardVector(vDirection, true)
 	   --self.parent:FaceTowards(self.hMainTarget:GetOrigin())
 	   --FindClearSpaceForUnit(self.parent, self.hMainTarget:GetAbsOrigin(), true) -- Interrupts motion controller
	
 	   else
	   -- Second Stage
	   if not self.stage3 then
 	      self.hMainTarget:SetAbsOrigin(vNewPos)
          self.parent:SetOrigin(vNewPos)
	   else
		  -- A LOT OF THIS CAN BE PUT ONINTERVALTHINK BUT STRANGE INTERACTION WITH KNOCKBACK MODIFIER
		  -- SO I WILL LEAVE IT HERE FOR NOW
		  ---------------------------------------------------------------------------------------------
		  ---------------------------------------------------------------------------------------------
		  if not self.finish then
		     self.parent:RemoveNoDraw()
             self.parent:StartGesture(ACT_DOTA_MK_FUR_ARMY)
		     self.finish = 1
		  
			 local knockback = { should_stun = true,
			    knockback_duration = 0.5,
				duration = 0.5,
				knockback_distance = 1100,
				knockback_height = 150,
				center_x = self.parent:GetAbsOrigin().x - self.parent:GetForwardVector().x * 800,
				center_y = self.parent:GetAbsOrigin().y - self.parent:GetForwardVector().y * 800,
			    center_z = 4000 }	
         
			 self.hMainTarget:AddNewModifier(self.parent, self, "modifier_knockback", knockback)
		  end
		  if self.counter > 1.0 and self.counter < 1.2 then
             self.parent:RemoveGesture(ACT_DOTA_MK_FUR_ARMY)
		     self.parent:StartGesture(ACT_DOTA_CAST_GHOST_SHIP)
		  elseif self.counter > 1.4 and self.counter < 1.6 and not self.rainbow then
             local hAbility = self.parent:FindAbilityByName("gogeta_rainbow_orb")
			 if hAbility then
			    hAbility:SetHidden(false)
			    self.parent:CastAbilityOnTarget(self.hMainTarget, hAbility, self.parent:GetPlayerID())
				self.hiddenA = hAbility
			 else
			    self:Destroy()
				return
			 end
             self.rainbow = 1
			 
             self.parent:RemoveGesture(ACT_DOTA_CAST_GHOST_SHIP)
		     self.parent:StartGesture(ACT_DOTA_MK_SPRING_CAST)
		  
		  end
		  ---------------------------------------------------------------------------------------------
		  ---------------------------------------------------------------------------------------------
 	      if not self.rainbow then
		     self.parent:SetForwardVector(vDirection, true)
		  end
	   end
	end

end
function modifier_gogeta_kick_combo_air_finisher:UpdateVerticalMotion(me, dt)
    if IsServer() then
        me:SetOrigin(Vector(me:GetOrigin().x, me:GetOrigin().y, 750))
		if not self.stage3 then
		   if not self.stage then
		      self.hMainTarget:SetOrigin(Vector(self.hMainTarget:GetOrigin().x, self.hMainTarget:GetOrigin().y, 750))
		   else
		      self.hMainTarget:SetOrigin(Vector(self.hMainTarget:GetOrigin().x, self.hMainTarget:GetOrigin().y, RandomInt(550, 750)))
		   end
		end
    end
end
function modifier_gogeta_kick_combo_air_finisher:OnIntervalThink()
	if IsServer() then
        if not self.hMainTarget:IsAlive() then self:Destroy() return end
		
        if self.iAttacksCount <= 0 then
		    self.stage3 = 1
        end
		
		if self.finish then
		   self.counter = self.counter + 0.1
		end
		
		

        self.iAttacksCount = self.iAttacksCount - 1

        if IsNotNull(self.hMainTarget) and self.iAttacksCount > 0 then
    		local vParentLoc = self.parent:GetOrigin()

    		self.hDamageTable.damage = self.fAttacksDamage -- + ( self.parent:GetAgility() * self.fAttacksAgiDamage )

    		ApplyDamage(self.hDamageTable)

        end
	end
end
function modifier_gogeta_kick_combo_air_finisher:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_gogeta_kick_combo_air_finisher:OnVerticalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_gogeta_kick_combo_air_finisher:OnDestroy()
    if IsServer() then
	    if self.hiddenA then
	       self.hiddenA:SetHidden(true)
		end
		
        -- Check Abilities
	    for i = 0, self.parent:GetAbilityCount() - 1 do
		   local ability = self.parent:GetAbilityByIndex(i)
		   if ability then
		      -- Enable disabled abilities
		       local ability_name = ability:GetName()
		       if ability_name == "gogeta_downward_punch" or ability_name == "gogeta_kick_combo_air_finisher" or ability_name == "gogeta_rainbow_orb" then
               else   
			      ability:SetActivated(true)
			   end
		   end
	    end
	
        self.parent:RemoveGesture(ACT_DOTA_ENFEEBLE)
        self.parent:RemoveGesture(ACT_DOTA_MK_FUR_ARMY)
        self.parent:RemoveGesture(ACT_DOTA_CAST_GHOST_SHIP)
        self.parent:RemoveGesture(ACT_DOTA_MK_SPRING_CAST)

        --self.parent:RemoveHorizontalMotionController(self)
        self.parent:InterruptMotionControllers(true)
	    self.parent:RemoveNoDraw()
        FindClearSpaceForUnit(self.hMainTarget, self.hMainTarget:GetAbsOrigin(), true)
		
		if self.hMainTarget:HasModifier("modifier_gogeta_stunned") then
		   self.hMainTarget:RemoveModifierByName("modifier_gogeta_stunned")
		end
    end
end


LinkLuaModifier("modifier_lansa_de_relampago_thinker","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)
modifier_lansa_de_relampago_thinker =  modifier_lansa_de_relampago_thinker or class ({})

function modifier_lansa_de_relampago_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end




---------------------------------------------------------------------------------------------------------------
-- Gogeta Backhand(D)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_gogeta_backhand_state","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)

gogeta_backhand  = gogeta_backhand or class ({})

function gogeta_backhand:GetOnUpgradeAbilities()
    local hTable =  {
                        "gogeta_downward_punch"
                    }
    return hTable
end
function gogeta_backhand:OnAbilityPhaseStart() local hCaster = self:GetCaster() return true end
function gogeta_backhand:OnAbilityPhaseInterrupted() end
function gogeta_backhand:OnSpellStart()
    local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	
	-- Get the enemy's facing direction
	local vTargetPos = hTarget:GetAbsOrigin()
    local vTargetForwardVector = hTarget:GetForwardVector()
    local vTeleportPos = vTargetPos + vTargetForwardVector * 50

    -- Teleport in front of the enemy
	Teleport_Effect(hCaster, self)
	FindClearSpaceForUnit( hCaster, vTeleportPos, true )

	-- Add state modifier
	hCaster:AddNewModifier(hCaster, self, "modifier_gogeta_backhand_state", {duration = 0.2})
    hCaster:AddNewModifier(hCaster, self, "modifier_disable_actions",{duration = 0.5})
   	EmitSoundOn("Gogeta.d1", hCaster)   
end

----------------------------------------------------------------------------------------------------------
modifier_gogeta_backhand_state = modifier_gogeta_backhand_state or class({})

function modifier_gogeta_backhand_state:IsHidden() return true end
function modifier_gogeta_backhand_state:IsDebuff() return false end
function modifier_gogeta_backhand_state:IsStunDebuff() return true end
function modifier_gogeta_backhand_state:IsPurgable() return false end
function modifier_gogeta_backhand_state:RemoveOnDeath() return false end
function modifier_gogeta_backhand_state:CheckState()
	local state = {
		              [MODIFIER_STATE_OUT_OF_GAME] = true,
		              [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		              [MODIFIER_STATE_INVULNERABLE] = true,
		              [MODIFIER_STATE_STUNNED] = true,
	              }

	return state
end
function modifier_gogeta_backhand_state:OnCreated( kv )
    self:GetParent():AddNoDraw()
end
function modifier_gogeta_backhand_state:OnDestroy()
	if not IsServer() then return end
    local hCaster = self:GetCaster()
	local fDamage = self:GetAbility():GetSpecialValueFor( "damage" ) 
	local fDuration = self:GetAbility():GetSpecialValueFor( "stun_duration" )

    -- Animation
	self:GetParent():RemoveNoDraw()

    -- Damage Table
	local damageTable = {
		victim = target,
		attacker = hCaster,
		damage = fDamage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	
	-- Knock the enemy backwards
    local knockback = { should_stun = 1,
                        knockback_duration = fDuration - 0.5,
                        duration = fDuration,
                        knockback_distance = 700,
                        knockback_height = 0,
                        center_x = hCaster:GetAbsOrigin().x,
                        center_y = hCaster:GetAbsOrigin().y,
                        center_z = hCaster:GetAbsOrigin().z 
					 }
    
	-- Find the closest enemy in a radius
	local enemies = FUnitsRadShort(hCaster, 100, FIND_CLOSEST)
------------------------------------------------------------------------------------------------------------
	for _,enemy in pairs(enemies) do
        -- Animation should only play if there is a target
        hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
                      
        -- Remove Knockback modifier before applying it
        if enemy:HasModifier("modifier_knockback") then
          enemy:RemoveModifierByName("modifier_knockback")
        end
					  
        -- Add knockback modifier and do Damage
        enemy:AddNewModifier(hCaster, self, "modifier_knockback", knockback)
        enemy:AddNewModifier(hCaster, self, "modifier_marked", { duration = 2.0 })
        damageTable.victim = enemy	
        ApplyDamage(damageTable)
                      
        -- Get the enemy's facing direction
        --local VTargetPos = enemy:GetAbsOrigin()
        local vTargetForwardVector = enemy:GetForwardVector()
        -- Prevent caster from turning around
        hCaster:StopFacing()
        -- Set caster facing direction
        hCaster:SetForwardVector(vTargetForwardVector)
        EmitSoundOn("Gogeta.d2", hCaster)
        break
	end
end





---------------------------------------------------------------------------------------------------------------
-- Gogeta Upper Kick(F)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_gogeta_upper_kick_state","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gogeta_downward_punch_teleport","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)

gogeta_upper_kick  = gogeta_upper_kick or class ({})

function gogeta_upper_kick:OnAbilityPhaseStart() 
	local hCaster = self:GetCaster()

	-- Find the closest enemy in a radius
    local enemies = FUnitsRadShort(hCaster, FIND_UNITS_EVERYWHERE, FIND_CLOSEST)
---------------------------------------------------------------------------------------------------------------
	for _,enemy in pairs(enemies) do
	    if enemy:HasModifier("modifier_marked") then         
            -- Calculate the direction vector from caster to target
            local vDirection = enemy:GetAbsOrigin() - hCaster:GetAbsOrigin()
            vDirection.z = 0
            vDirection = vDirection:Normalized()

            -- Calculate the teleport position
            local vTeleportPos = enemy:GetAbsOrigin() + 101

            -- Teleport the caster 
            Teleport_Effect(hCaster)
			FindClearSpaceForUnit( hCaster, vTeleportPos, true )
            -- Face the target
            hCaster:SetForwardVector(vDirection)
			EmitSoundOn("Gogeta.d1", hCaster)
	        break
	    end
	end
	
	return true
end
function gogeta_upper_kick:OnAbilityPhaseInterrupted() end
function gogeta_upper_kick:OnSpellStart()
    local hCaster = self:GetCaster()
	local fDamage = self:GetSpecialValueFor("damage")
	local fDuration = self:GetSpecialValueFor("duration")

    -- Damage Table
	local damageTable = {
		victim = target,
		attacker = hCaster,
		damage = fDamage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
 
    
	-- Find the closest enemy in a radius
	local enemies = FUnitsRadShort(hCaster, 200, FIND_CLOSEST)
-------------------------------------------------------------------------------------------------------------
	for _,enemy in pairs(enemies) do
        local vDirection = (enemy:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
                      
        -- Remove Knockback modifier before applying it
        if enemy:HasModifier("modifier_knockback") then
          enemy:RemoveModifierByName("modifier_knockback")
        end
					  
        -- Add knockback air modifier and do Damage
        enemy:AddNewModifier(hCaster, self, "modifier_gogeta_upper_kick_state", { duration = fDuration, 
					                                                              direction_x = vDirection.x, 
																				  direction_y = vDirection.y,
                                                                                  -- identifier = 1, -- 1 is caster 0 is enemy
                                                                                  -- hTarget = closestEnemy:entindex(), -- don't need this if we have the enemy																								
																				  path_control = 1 -- 1 is up 0 is down
																				})
        enemy:AddNewModifier(hCaster, self, "modifier_marked", { duration = fDuration })
        damageTable.victim = enemy	
        ApplyDamage(damageTable)
		
        -- Tell the Combo Tracker that an enemy is in the air
		Gogeta_Air_Time_Ready = 1
                      
        EmitSoundOn("Gogeta.d2", hCaster)
        break
	end
end
---------------------------------------------------------------------------------------------------------------
-- Gogeta Downward Punch(D) COMBO
---------------------------------------------------------------------------------------------------------------
gogeta_downward_punch  = gogeta_downward_punch or class ({})

function gogeta_downward_punch:OnSpellStart()
    local hCaster = self:GetCaster()

    Teleport_Effect(hCaster)
	-- Add state modifier
    hCaster:AddNewModifier(hCaster, self, "modifier_gogeta_downward_punch_teleport", {duration = 0.2, 
	                                                                                  param = "modifier_gogeta_upper_kick_state"
																			         })
	if hCaster:HasModifier("modifier_gogeta_kick_combo_air_finisher") then
      hCaster:RemoveModifierByName("modifier_gogeta_kick_combo_air_finisher")
	end																		 
    
	EmitSoundOn("Gogeta.d1", hCaster)
end
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
modifier_gogeta_downward_punch_teleport = modifier_gogeta_downward_punch_teleport or class({})

function modifier_gogeta_downward_punch_teleport:IsHidden() return true end
function modifier_gogeta_downward_punch_teleport:IsDebuff() return false end
function modifier_gogeta_downward_punch_teleport:IsStunDebuff() return true end
function modifier_gogeta_downward_punch_teleport:IsPurgable() return false end
function modifier_gogeta_downward_punch_teleport:RemoveOnDeath() return false end
function modifier_gogeta_downward_punch_teleport:CheckState()
	local state = {
		              [MODIFIER_STATE_OUT_OF_GAME] = true,
		              [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		              [MODIFIER_STATE_INVULNERABLE] = true,
		              [MODIFIER_STATE_STUNNED] = true,
	              }

	return state
end
function modifier_gogeta_downward_punch_teleport:OnCreated( kv )
	if not IsServer() then return end
    local hCaster = self:GetCaster()
	
	self.modifier_param = kv.param
	self.enemy = nil
    self:GetParent():AddNoDraw()
	
	-- Get enemies in the AIR who are also marked
    -- Find the closest enemy in a radius
	local enemies = FUnitsRadShort(hCaster, FIND_UNITS_EVERYWHERE, FIND_CLOSEST)
----------------------------------------------------------------------------------------------------------------   
	local closestEnemy = nil
	for _,enemy in pairs(enemies) do
        -- Get enemy in the AIR
	    if (enemy:HasModifier("modifier_gogeta_upper_kick_state") and enemy:HasModifier("modifier_marked")) or enemy:HasModifier("modifier_gogeta_stunned") then
		  closestEnemy = enemy
		  break
		end
    end
	
	-- Add another modifier
    if self.modifier_param and closestEnemy then
      hCaster:AddNewModifier(hCaster, self, self.modifier_param, { duration = 1.4, -- duration
	                                                               hTarget = closestEnemy:entindex(), -- target 
																   identifier = 1, -- Self 1 or Enemy 0
																   path_control = 1 -- UP 1 or 0 Down
																  })
	  self.enemy = closestEnemy
	end
end
function modifier_gogeta_downward_punch_teleport:OnDestroy()
	if not IsServer() then return end
    local hCaster = self:GetCaster()
    -- Animation
	self:GetParent():RemoveNoDraw()
	
	if not self.enemy then return end
    hCaster:StartGesture(ACT_DOTA_CHILLING_TOUCH)
    self.enemy:AddNewModifier(hCaster, self, self.modifier_param, { duration = 3.0, -- duration
	                                                                --[[hTarget = nil,]] -- target
																	identifier = 0, -- Self 1 or Enemy 0
																	path_control = 0 -- UP 1 or 0 Down
																  })
	EmitSoundOn("Gogeta.d2", hCaster)
end
----------------------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------------------
modifier_gogeta_upper_kick_state = modifier_gogeta_upper_kick_state or class({})

function modifier_gogeta_upper_kick_state:IsHidden() return false end
function modifier_gogeta_upper_kick_state:IsDebuff() return false end
function modifier_gogeta_upper_kick_state:IsStunDebuff() return true end
function modifier_gogeta_upper_kick_state:IsPurgable() return false end
function modifier_gogeta_upper_kick_state:RemoveOnDeath() return false end
function modifier_gogeta_upper_kick_state:CheckState()
	local state = {
		              [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		              [MODIFIER_STATE_STUNNED] = true,
	              }

	return state
end
----------------------------------------------------------------------------------------------------------
-- Modifier for upward and downward vertical motion
-- The motion is controlled with self.path_control
function modifier_gogeta_upper_kick_state:OnCreated(keys)
    if not IsServer() then return end
	
	-- Parent
	self.parent = self:GetParent()
	
	-- Caster or enemy
	self.identifier = keys.identifier or 0
	
	-- Set the path up or down, TRUE = up/FALSE = down
	self.path_control = keys.path_control > 0
	
	-- Look for Enemy
	self.target = keys.hTarget
	              and EntIndexToHScript(keys.hTarget)
				  or nil

    -- Retrieve the direction from the ability
    self.direction = Vector(keys.direction_x, keys.direction_y, 0)

    -- Set the initial vertical speed
    self.vertical_speed = 1000

    -- Set the initial horizontal speed
    self.horizontal_speed = 0

    -- Set the initial rotation speed
    self.rotation_speed = 360 -- Degrees per second
	
	-- Knockback table
    self.knockback = { should_stun = 1,
                        knockback_duration = 1,5,
                        duration = 1.5,
                        knockback_distance = 0,
                        knockback_height = -50,
                        center_x = self.parent:GetAbsOrigin().x,
                        center_y = self.parent:GetAbsOrigin().y,
                        center_z = self.parent:GetAbsOrigin().z 
					 }

    -- Start the motion
    self:StartIntervalThink(FrameTime())
end
function modifier_gogeta_upper_kick_state:OnRefresh(keys)
	if not IsServer() then return end
    self:OnCreated(keys)
end
-- Motion
function modifier_gogeta_upper_kick_state:OnIntervalThink()
    if not IsServer() then return end

    local me = self:GetParent()
    local dt = FrameTime()
    -- Get the current position
	local pos = self.target
	            and self.target:GetOrigin()
				or me:GetOrigin() 

    -- Apply vertical motion
	if self.identifier <= 0 then
	  if self.path_control then
        pos.z = pos.z + self.vertical_speed * dt
	  else
	    pos.z = pos.z - self.vertical_speed * dt * 2
	  end
	else
	   pos.z = 890
	end

    -- Apply horizontal motion
    pos = pos + self.direction * self.horizontal_speed * dt
	
    -- Check if the target has reached the desired height
    local maxHeight = 900
    if pos.z >= maxHeight then
        -- Stop updating the position
        pos.z = maxHeight
    end
	
    -- Apply rotation motion
    local rotation = me:GetAnglesAsVector()
    rotation.x = rotation.x + self.rotation_speed * dt
    if pos.z ~= maxHeight and self.path_control and self.identifier <= 0 then
        -- Stop updating the angles
        me:SetAngles(rotation.x, rotation.y, rotation.z)
    end

    -- Update the position
    me:SetOrigin(pos)
	
    -- Ground detection
    if pos.z <= 0 and self.identifier <= 0 then
        -- Remove the motion modifier
        self:Destroy()
        -- Add Knockback modifier
        me:AddNewModifier(me, self, "modifier_knockback", self.knockback)
    end
end
function modifier_gogeta_upper_kick_state:OnDestroy()
	if not IsServer() then return end
	
	-- Not in the air
	Gogeta_Air_Time_Ready = 0
	-- Stop Facing
	self.parent:StopFacing()
	-- Restore Angles
	self.parent:SetAngles(0, 0, 0)
end





---------------------------------------------------------------------------------------------------------------
-- Gogeta Ultimate Form(R)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_gogeta_ultimate_form","heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_NONE)

gogeta_ultimate_form = gogeta_ultimate_form or class({})
function gogeta_ultimate_form:GetOnUpgradeAbilities()
    local hTable =  {
                        "gogeta_ultimate"
                    }
    return hTable
end
function gogeta_ultimate_form:OnAbilityPhaseStart()
    local hCaster = self:GetCaster()
    --EmitSoundOn("Gogeta.d1", hCaster)   
    return true
end
function gogeta_ultimate_form:OnAbilityPhaseInterrupted() end
function gogeta_ultimate_form:OnSpellStart()
	local hCaster = self:GetCaster()
	local fDuration = 60.0
	
	hCaster:AddNewModifier(hCaster, self, "modifier_gogeta_ultimate_form", {duration = fDuration})
end
----------------------------------------------------------------------------------------------------------
modifier_gogeta_ultimate_form = modifier_gogeta_ultimate_form or class({})
function modifier_gogeta_ultimate_form:IsHidden() return false end
function modifier_gogeta_ultimate_form:IsPurgable() return false end
function modifier_gogeta_ultimate_form:RemoveOnDeath() return true end
function modifier_gogeta_ultimate_form:DeclareFunctions()
    local func = {
				     MODIFIER_PROPERTY_HEALTH_BONUS,
                     MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
				}
    return func
end
function modifier_gogeta_ultimate_form:GetModifierSpellAmplify_Percentage()
    return 35
end
function modifier_gogeta_ultimate_form:GetModifierHealthBonus()
    return 1000
end
function modifier_gogeta_ultimate_form:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
	
	self.skills_table = {
                            ["gogeta_ultimate_form"] = "gogeta_ultimate",
                        }

    if IsServer() then
      EmitSoundOn("new.year_theme_1", self.parent)
      for k, v in pairs(self.skills_table) do
        if k and v then
          self.parent:SwapAbilities(k, v, false, true)
        end
      end
    end
end
function modifier_gogeta_ultimate_form:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_gogeta_ultimate_form:OnDestroy()
    if IsServer() then
      StopSoundOn("new.year_theme_1", self.parent)
      for k, v in pairs(self.skills_table) do
        if k and v then
          self.parent:SwapAbilities(k, v, true, false)
        end
      end
    end
end





---------------------------------------------------------------------------------------------------------------
-- Gogeta Ultimate Spell(R)
---------------------------------------------------------------------------------------------------------------
gogeta_ultimate = gogeta_ultimate or class({})
function gogeta_ultimate:GetAOERadius()
	return 1000
end
function gogeta_ultimate:OnAbilityPhaseStart() local hCaster = self:GetCaster() return true end
function gogeta_ultimate:OnAbilityPhaseInterrupted() end
function gogeta_ultimate:OnSpellStart()
    local hCaster = self:GetCaster()

	-- Add state modifier
    hCaster:AddNewModifier(hCaster, self, "modifier_disable_actions",{duration = 0.6})
   	EmitSoundOn("Gogeta.d1", hCaster)   
	
    -- Get cursor position and radius
	local hTargetPoint = self:GetCursorPosition()
	local iRadius = 1000
    
	-- Particle properties
    local iDuration = 4
    local iParticlesPerSecond = 20
    local fParticleInterval = 1 / iParticlesPerSecond
    local fParticleDelay = 0.1
    local fParticleDuration = 0.5
	local iParticleRadius = 125
	
    -- Sound and sound probability
	local soundName = "Gogeta.d1"
    local fSoundProbability = 0.25 

    -- Timer inside timer
	local endTime = GameRules:GetGameTime() + iDuration
	
    -- Create the particle effect for the radius outline
    local sParticleName = "particles/earth_halo.vpcf"
    local hParticle = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, self:GetCaster())
                      ParticleManager:SetParticleControl(hParticle, 0, hTargetPoint)
                      ParticleManager:SetParticleControl(hParticle, 1, Vector(iRadius, 0, 0))
		
    Timers:CreateTimer(iDuration, function()
        ParticleManager:DestroyParticle(hParticle, false)
        ParticleManager:ReleaseParticleIndex(hParticle)
    end)

    Timers:CreateTimer(0, function()
        if GameRules:GetGameTime() >= endTime then
            return nil  -- End the timer
        end
		
		local fRandFloat   = RandomFloat(0, 1)
		local iRadiusExtra = fRandFloat < fSoundProbability
		                     and 200
							 or 0
		
		local vParticlePosition = hTargetPoint + RandomVector(RandomFloat(0, iRadius))
		local endcapPos = GetGroundPosition(  vParticlePosition, nil )
	    endcapPos.z = endcapPos.z + 200
        local hParticle  = ParticleManager:CreateParticle("particles/gogeta_impact2.vpcf", PATTACH_WORLDORIGIN, nil)
                           ParticleManager:SetParticleControl(hParticle, 0, endcapPos)
		local hParticle2 = nil

        local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vParticlePosition, nil, iParticleRadius + iRadiusExtra, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _, unit in pairs(units) do
            local damageTable = {
                victim = unit,
                attacker = self:GetCaster(),
                damage = 500,
                damage_type = self:GetAbilityDamageType(),
                ability = self  -- Optional, if you want to credit the ability for the damage
            }
            ApplyDamage(damageTable)
        end
		
        if fRandFloat < fSoundProbability then
            EmitSoundOnLocationWithCaster(vParticlePosition, soundName, self:GetCaster())
            hParticle2 = ParticleManager:CreateParticle("particles/econ/items/earthshaker/deep_magma/deep_magma_cyan/deep_magma_cyan_echoslam_start.vpcf", PATTACH_WORLDORIGIN, nil)
                         ParticleManager:SetParticleControl(hParticle2, 0, endcapPos)	
        end
        
		Timers:CreateTimer(fParticleDuration, function()
            ParticleManager:DestroyParticle(hParticle, false)
            ParticleManager:ReleaseParticleIndex(hParticle)
        end)
		
		return fParticleInterval  -- Repeat the timer after the specified delay
    end)

    -- Big Meme Code, maybe use for different hero?
	--[[-- Calculate the radius
    local radius = 1000

    -- Spawn particles along the outer radius
    local outerParticleCount = 20
    local outerInterval = 1 / outerParticleCount
    for i = 0, outerParticleCount - 1 do
        Timers:CreateTimer(i * outerInterval, function()
            local angle = i * (360 / outerParticleCount)
            local offset = Vector(math.cos(math.rad(angle)), math.sin(math.rad(angle)), 0) * radius
            local particle = ParticleManager:CreateParticle("particles/earthshaker_fissure1.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(particle, 0, targetPoint + offset)

            -- Find units in the outer radius and apply damage
            local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), targetPoint + offset, nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            local damageAmount = 200
            for _, unit in pairs(units) do
                ApplyDamage({victim = unit, attacker = self:GetCaster(), damage = damageAmount, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
            end

            -- Remove the outer particle after a certain duration
            Timers:CreateTimer(0.5, function()
                ParticleManager:DestroyParticle(particle, false)
                ParticleManager:ReleaseParticleIndex(particle)
            end)

            -- Spawn particles along the inner radius
            local innerParticleCount = 20
            local innerInterval = 0.2
            for j = 0, innerParticleCount - 1 do
                Timers:CreateTimer(innerInterval * j, function()
                    local innerOffset = offset * (j / innerParticleCount)
                    local innerParticle = ParticleManager:CreateParticle("particles/earthshaker_echoslam_start_cracks.vpcf", PATTACH_CUSTOMORIGIN, nil)
                    ParticleManager:SetParticleControl(innerParticle, 0, targetPoint + innerOffset)

                    -- Find units in the inner radius and apply damage
                    local innerUnits = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), targetPoint + innerOffset, nil, 50, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                    local innerDamageAmount = 200
                    for _, innerUnit in pairs(innerUnits) do
                        ApplyDamage({victim = innerUnit, attacker = self:GetCaster(), damage = innerDamageAmount, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
                    end

                    -- Remove the inner particle after a certain duration
                    Timers:CreateTimer(0.5, function()
                        ParticleManager:DestroyParticle(innerParticle, false)
                        ParticleManager:ReleaseParticleIndex(innerParticle)
                    end)
                end)
            end
        end)
    end]]--
end

----------------------------------------------------------------------------------------------------------
-- Gogeta: R (W) - Ultimate Finisher Combo
----------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_gogeta_ultimate_finisher", "heroes/gogeta/gogeta.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

gogeta_ultimate_finisher = gogeta_ultimate_finisher or class({})

function gogeta_ultimate_finisher:CastFilterResult()
	local hCaster         = self:GetCaster()

    return UF_SUCCESS
end
function gogeta_ultimate_finisher:OnSpellStart()
	local hCaster 	= self:GetCaster()
	local hTarget   = self:GetCursorTarget()
	local fDuration = 3.0

	hCaster:AddNewModifier(hCaster, self, "modifier_akame_headbump", {duration = fDuration, enemy_target = hTarget:GetEntityIndex()})
	EmitSoundOn("Gogeta.e1", hCaster)
end
function gogeta_ultimate_finisher:OnChannelFinish()
	local hCaster 	= self:GetCaster()
	
	if hCaster:HasModifier("modifier_akame_headbump") then
	  hCaster:RemoveModifierByName("modifier_akame_headbump")
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_gogeta_ultimate_finisher = modifier_gogeta_ultimate_finisher or class({})

function modifier_gogeta_ultimate_finisher:IsHidden()                                 return false end
function modifier_gogeta_ultimate_finisher:IsDebuff()                                 return false end
function modifier_gogeta_ultimate_finisher:IsPurgable()                               return false end
function modifier_gogeta_ultimate_finisher:IsPurgeException()                         return false end
function modifier_gogeta_ultimate_finisher:RemoveOnDeath()                            return true end
function modifier_gogeta_ultimate_finisher:GetPriority()                              return MODIFIER_PRIORITY_HIGH end
function modifier_gogeta_ultimate_finisher:CheckState()
	local state = 	{
						[MODIFIER_STATE_MAGIC_IMMUNE] = true,
						[MODIFIER_STATE_DISARMED]	  = true
					}
	return state
end
function modifier_gogeta_ultimate_finisher:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
                        MODIFIER_PROPERTY_DISABLE_TURNING
                    }
    return func
end
function modifier_gogeta_ultimate_finisher:GetOverrideAnimation(keys)
    return ACT_DOTA_CAST_ABILITY_2
end
function modifier_gogeta_ultimate_finisher:GetModifierIgnoreCastAngle(keys)
	return 1
end
function modifier_gogeta_ultimate_finisher:GetModifierDisableTurning(keys)
    return 1
end
function modifier_gogeta_ultimate_finisher:OnCreated(hTable)
    if IsServer() then
        self.caster  = self:GetCaster()
        self.parent  = self:GetParent()
        self.ability = self:GetAbility()

        self.CASTER_TEAM          = self.caster:GetTeamNumber()
        self.ABILITY_TARGET_TEAM  = "DOTA_UNIT_TARGET_TEAM_ENEMY" 
        self.ABILITY_TARGET_TYPE  = "DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
        self.ABILITY_TARGET_FLAGS = "DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES"
        
        self.hMainModifier = self.parent:FindModifierByNameAndCaster("modifier_gogeta_ultimate_finisher", self.parent)
		self.hMainTarget = EntIndexToHScript(hTable.enemy_target)
		self.Test = 1
		
        
		self.fKnockbackDistance = 270
        self.fKnockbackDuration = 0.2
		self.iAttacksCount 		= 50
		self.fAttacksInterval   = 0.5
        self.fAttacksDamage     = self.ability:GetSpecialValueFor("damage")
		--self.fAttacksAgiDamage  = 20	
		  

		--self.fFollowSpeed       = self.fKnockbackDistance / self.fKnockbackDuration
		self.fFollowDistance 	= 180

        self.hDamageTable = {
                                victim       = self.hMainTarget,
                                attacker     = self.parent, 
                                damage       = self.fAttacksDamage,
                                damage_type  = DAMAGE_TYPE_MAGICAL,
                                ability      = self.ability,
                                --damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK
                            }

		self.hKnockBackTable = {
									should_stun        = 1,
									knockback_duration = self.fKnockbackDuration,
									duration           = self.fKnockbackDuration,
									knockback_distance = self.fKnockbackDistance,
									knockback_height   = 0,
									center_x 		   = nil,
									center_y 		   = nil,
									center_z 		   = nil
								}

		--self.parent:SetForwardVector(GetDirection(self.hMainTarget, self.parent))

		self:StartIntervalThink(self.fAttacksInterval)
		self:OnIntervalThink()

        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_gogeta_ultimate_finisher:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_gogeta_ultimate_finisher:UpdateHorizontalMotion(me, dt)

	local vCurPos     = self.parent:GetOrigin()
	local vDirection  = GetDirection(self.hMainTarget, vCurPos)
	local fDistance   = GetDistance(self.hMainTarget, vCurPos)
 	local fUnitsPerDt = self.hMainTarget:GetIdealSpeed() * dt
 	local vNextPos    = vCurPos + vDirection * fUnitsPerDt * 3
 		  vNextPos    = fDistance <= self.fFollowDistance
 		  				and vCurPos
 		  				or vNextPos

	self.parent:SetOrigin(vNextPos)
    self.parent:SetForwardVector(vDirection, true)
    --self.parent:FaceTowards(self.hMainTarget:GetOrigin())
end
function modifier_gogeta_ultimate_finisher:OnIntervalThink()
	if IsServer() then
        if self.iAttacksCount <= 0 then
            return
        end

        self.iAttacksCount = self.iAttacksCount - 1
        self.Test = self.Test + 1
		self.Test2 = self.Test

        if IsNotNull(self.hMainTarget) then
    		local vParentLoc = self.parent:GetOrigin()
			
			if self.Test >= 7 then
		      self.hKnockBackTable.knockback_distance = 1100
              self.hKnockBackTable.knockback_duration = 0.7
			  self.hKnockBackTable.duration = 1.2
            end			
			
            self.hKnockBackTable.center_x = vParentLoc.x
            self.hKnockBackTable.center_y = vParentLoc.y
            self.hKnockBackTable.center_z = vParentLoc.z

            self.hMainTarget:AddNewModifier(self.parent, self.ability, "modifier_knockback", self.hKnockBackTable, self.hMainTarget:IsOpposingTeam(self.CASTER_TEAM))

    		self.hDamageTable.damage = self.fAttacksDamage -- + ( self.parent:GetAgility() * self.fAttacksAgiDamage )

    		ApplyDamage(self.hDamageTable)
			
            local vParentLoc = self.parent:GetOrigin()
            local vTargetLoc = self.hMainTarget:GetOrigin()

            -- Calculate the forward vector of the caster
            local vForward = self.parent:GetForwardVector()

            -- Set the position of the particle effect relative to the forward vector
            local vEffectPos = vForward * 100

			
            --self:SetStackCount(self:GetStackCount() + 1)
            if not self.AuraEffect then
              self.AuraEffect = self.parent:HasModifier("modifier_gogeta_powerup")
			                    and ParticleManager:CreateParticle("particles/gogeta_hit_effect2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hMainTarget)
                                or ParticleManager:CreateParticle("particles/gogeta_hit_effect1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hMainTarget)	
              -- Set the position of the particle effect
              ParticleManager:SetParticleControl(self.AuraEffect, 0, vEffectPos)					
              self:AddParticle(self.AuraEffect, false, false, -1, false, false)
			  self.AuraEffect = nil
		    end
			
			if self.Test2 > 3 then
			  self.Test2 = RandomInt(3, 5)
			end

            EmitSoundOn("Gogeta.hit"..self.Test2 - 1, self.hMainTarget)
			
           if self.Test == 3 then
		    if self.hMainTarget:HasModifier("modifier_knockback") then
             self.hMainTarget:RemoveModifierByName("modifier_knockback")
            end 
			-- Trigger AddNewModifier and ApplyDamage twice on self.Test reaching 3
			self.hMainTarget:AddNewModifier(self.parent, self.ability, "modifier_knockback", self.hKnockBackTable, self.hMainTarget:IsOpposingTeam(self.CASTER_TEAM))
			EmitSoundOn("Gogeta.hit"..self.Test2 + 1, self.hMainTarget)
			ApplyDamage(self.hDamageTable)
		   end	
        end
	end
end
function modifier_gogeta_ultimate_finisher:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_gogeta_ultimate_finisher:OnDestroy()
    if IsServer() then
        self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)

        --self.parent:RemoveHorizontalMotionController(self)
        self.parent:InterruptMotionControllers(true)
    end
end
function modifier_gogeta_ultimate_finisher:GetEffectName()
	return "particles/gogeta_trail1.vpcf"
end
function modifier_gogeta_ultimate_finisher:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


---------------------------------------------------------------------------------------------------------------
-- HELPER FUNCTIONS
---------------------------------------------------------------------------------------------------------------
function FUnitsRadShort(hCaster, radius, order)
	-- Find the closest enemy in a radius
	if hCaster then
	  radius = radius or 200
	  order = order or FIND_CLOSEST
	  local enemies = FindUnitsInRadius( hCaster:GetTeamNumber(),	-- int, your team number
			                             hCaster:GetOrigin(),	-- point, center point
			                             nil,	-- handle, cacheUnit. (not known)
			                             radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			                             DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			                             DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			                             0,	-- int, flag filter
			                             order,	-- int, order filter
			                             false	-- bool, can grow cache
		                              )
      return enemies
	end
	return 0
end

function Teleport_Effect(hCaster)
    if not hCaster then
        return
    end
	
	-- Get Resources
	local particle_cast1 = "particles/vergil_blur.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	                     ParticleManager:SetParticleControl( effect_cast1, 0, hCaster:GetOrigin() )

	
	-- buff particle
    ParticleManager:ReleaseParticleIndex(effect_cast1)
end

-----------------------------------------------------------------------------------------------------------
-- Gogeta Rainbow Orb
-----------------------------------------------------------------------------------------------------------

gogeta_rainbow_orb  = gogeta_rainbow_orb or class ({})

function gogeta_rainbow_orb:OnAbilityPhaseStart() local hCaster = self:GetCaster() return true end
function gogeta_rainbow_orb:OnAbilityPhaseInterrupted() end
function gogeta_rainbow_orb:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()
	
    local target = CreateModifierThinker(self:GetCaster(), self, "modifier_lansa_de_relampago_thinker", nil, hTarget:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	   local info = {
			        EffectName = "particles/gogeta_rainbow_orb_main.vpcf",
			        Ability = self,
			        iMoveSpeed = 525,
			        Source = hCaster,
			        Target = target,
			        iSourceAttachment = DOTA_PROJECTILE_ATTACH_ATTACK1
                    }

    ProjectileManager:CreateTrackingProjectile( info )
end
function gogeta_rainbow_orb:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
        --EmitSoundOn( "ulquiorra.nuke", hTarget )

        if IsServer() then
            local caster = caster
  
          local particle_fx = "particles/holy_bomb_explosion.vpcf"

        local effect_fx =   ParticleManager:CreateParticle(particle_fx, PATTACH_WORLDORIGIN, caster)
                            ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                            ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
               
    
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = 10000,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                
                target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 2})
    
                ApplyDamage(damage)  
            end
        end

		UTIL_Remove(hTarget)
	end

	return true
end