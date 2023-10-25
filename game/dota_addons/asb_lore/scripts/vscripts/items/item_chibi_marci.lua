LinkLuaModifier("modifier_chibi_marci", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chibi_marci_logic", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_result", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_pressed", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_1", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_2", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_3", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
----------------------------------------------------------------------------------------------------------
-- BUFFS                                                                                                --
----------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_chibi_marci_golden_legendary", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_giant", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_instant_trash", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_dark_souls", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_amaterasu", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
----------------------------------------------------------------------------------------------------------
-- DEBUFFS                                                                                              --
----------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_chibi_marci_slave", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_explode", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_AYAYA", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_gay_garbage", "items/item_gay_hammer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_icecream", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_chibi_marci_gamble", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE )

local hCombinations = {}
local hBuffsTable = {
                  
				  -- Buffs
				   ["333"] = "modifier_chibi_marci_golden_legendary",
				   ["323"] = "modifier_chibi_marci_giant",
				   ["313"] = "modifier_chibi_marci_instant_trash",
				   
				   ["233"] = "modifier_chibi_marci_dark_souls",
				   ["133"] = "modifier_chibi_marci_amaterasu",
				   
				   -- Debuffs
				   ["111"] = "modifier_chibi_marci_slave",
				   ["122"] = "modifier_chibi_marci_AYAYA",
				   ["123"] = "modifier_gay_garbage",
				   ["321"] = "modifier_chibi_marci_icecream",
				   ["322"] = "modifier_chibi_marci_gamble",
				   
				   
				   ["112"] = "modifier_chibi_marci_explode",
				   ["113"] = "modifier_chibi_marci_explode",
				   ["121"] = "modifier_chibi_marci_explode",
				   ["131"] = "modifier_chibi_marci_explode",
				   ["211"] = "modifier_chibi_marci_explode",
				   ["311"] = "modifier_chibi_marci_explode",

				   }

item_chibi_marci = item_chibi_marci or class({})

function item_chibi_marci:GetIntrinsicModifierName()
	return "modifier_chibi_marci"
end
function item_chibi_marci:GetBehavior()
    return (self:GetCaster():HasModifier("modifier_chibi_marci_instant_trash") or self:GetCaster():HasModifier("modifier_chibi_marci_amaterasu")) 
	        and DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
            or DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function item_chibi_marci:OnSpellStart()
    if not IsServer() then return end
	-- unit identifier
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	
	-- Instant Garbage
    if hCaster:HasModifier("modifier_chibi_marci_instant_trash") then
       local vTargetLocation = hTarget:GetAbsOrigin()
	   
	   -- Spawn the model dummy
       local vSpawnLocation = vTargetLocation
       local TrashMdl = CreateUnitByName(
		"npc_dummy_unit",
		hCaster:GetAbsOrigin(),
		true,
		hCaster,
		hCaster:GetOwner(),
		hCaster:GetTeamNumber()
       )

       -- Apply a modifier to the model
       TrashMdl:AddNewModifier(hCaster, self, "modifier_chibi_marci_instant_trash_think", { duration = 4.0, enemy_target = hTarget:GetEntityIndex() } )
       
	   -- Remove modifier
       hCaster:RemoveModifierByName("modifier_chibi_marci_instant_trash")
	elseif hCaster:HasModifier("modifier_chibi_marci_amaterasu") then
       hTarget:AddNewModifier(hCaster, self, "modifier_chibi_marci_amaterasu_pre", {})
       hCaster:RemoveModifierByNameAndCaster("modifier_chibi_marci_amaterasu", hCaster)
	else
       -- Normal item function
       if hCaster:HasModifier("modifier_chibi_marci_logic") then
	      hCaster:AddNewModifier(hCaster, self, "modifier_chibi_marci_pressed", {duration = 1.0} )
	      hCaster:RemoveModifierByNameAndCaster("modifier_chibi_marci_logic", hCaster)
	   else
	      hCaster:AddNewModifier(hCaster, self, "modifier_chibi_marci_logic", {duration = 1.4} )
	      EmitSoundOn("chibi.activate", hCaster)
	      self:EndCooldown()
	   end
	end
end

---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci = modifier_chibi_marci or class({})

function modifier_chibi_marci:IsHidden() return true end
function modifier_chibi_marci:IsDebuff() return false end
function modifier_chibi_marci:IsPurgable() return false end
function modifier_chibi_marci:IsPurgeException() return false end
function modifier_chibi_marci:RemoveOnDeath() return false end
function modifier_chibi_marci:DeclareFunctions()
	local func = { 	
	                 MODIFIER_PROPERTY_HEALTH_BONUS,
		         }
	return func
end
function modifier_chibi_marci:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor("health_bonus")
end

---------------------------------------------------------------------------------------------------------------------
-- PRESSED MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_pressed = modifier_chibi_marci_pressed or class({})

function modifier_chibi_marci_pressed:IsHidden() return true end
function modifier_chibi_marci_pressed:IsDebuff() return false end
function modifier_chibi_marci_pressed:IsPurgable() return false end
function modifier_chibi_marci_pressed:IsPurgeException() return false end
function modifier_chibi_marci_pressed:RemoveOnDeath() return false end

---------------------------------------------------------------------------------------------------------------------
-- LOGIC MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_logic = modifier_chibi_marci_logic or class({})

function modifier_chibi_marci_logic:IsHidden() return false end
function modifier_chibi_marci_logic:IsDebuff() return false end
function modifier_chibi_marci_logic:IsPurgable() return false end
function modifier_chibi_marci_logic:IsPurgeException() return false end
function modifier_chibi_marci_logic:RemoveOnDeath() return false end
function modifier_chibi_marci_logic:OnCreated( kv )
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
    self.CurTime = GameRules:GetGameTime()
end
function modifier_chibi_marci_logic:OnDestroy()
    if not IsServer() then return end
	
	-- Prepare certain variables
	local EndTime = GameRules:GetGameTime()
	local TimeDifference = EndTime - self.CurTime
	local StackAmount = nil
	local Modifier = nil
	
	-- Determine stack amounts
	if TimeDifference <= 0.33 then
       StackAmount = 1
	   EmitSoundOn("chibi.stack1", self.parent)
	elseif TimeDifference <= 0.66 then
       StackAmount = 2
	   EmitSoundOn("chibi.stack2", self.parent)
	elseif TimeDifference <= 0.99 then
       StackAmount = 3
	   EmitSoundOn("chibi.stack3", self.parent)
	else
	   if self.parent:HasModifier("modifier_chibi_marci_pressed") then
	      StackAmount = nil
		  -- Apply Slap
	   else
	      StackAmount = nil
	   end
	end
	
    -- Apply modifiers with stacks
	if StackAmount == nil then return end
	
	if self.parent:HasModifier("modifier_chibi_marci_1") and not self.parent:HasModifier("modifier_chibi_marci_2") then
	   Modifier = self.parent:AddNewModifier(self.parent, self.ability, "modifier_chibi_marci_2", {} )
	elseif self.parent:HasModifier("modifier_chibi_marci_1") and self.parent:HasModifier("modifier_chibi_marci_2") then
	   Modifier = self.parent:AddNewModifier(self.parent, self.ability, "modifier_chibi_marci_3", {} )
	elseif self.parent:HasModifier("modifier_chibi_marci_3") then
	   -- Don't do anything
	else
	   Modifier = self.parent:AddNewModifier(self.parent, self.ability, "modifier_chibi_marci_1", {} )
	end
	
	if Modifier then Modifier:SetStackCount(StackAmount) end
end

---------------------------------------------------------------------------------------------------------------------
-- FIRST NUMBER MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_1 = modifier_chibi_marci_1 or class({})

function modifier_chibi_marci_1:IsHidden() return false end
function modifier_chibi_marci_1:IsDebuff() return false end
function modifier_chibi_marci_1:IsPurgable() return false end
function modifier_chibi_marci_1:IsPurgeException() return false end
function modifier_chibi_marci_1:RemoveOnDeath() return false end

---------------------------------------------------------------------------------------------------------------------
-- SECOND NUMBER MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_2 = modifier_chibi_marci_2 or class({})

function modifier_chibi_marci_2:IsHidden() return false end
function modifier_chibi_marci_2:IsDebuff() return false end
function modifier_chibi_marci_2:IsPurgable() return false end
function modifier_chibi_marci_2:IsPurgeException() return false end
function modifier_chibi_marci_2:RemoveOnDeath() return false end

---------------------------------------------------------------------------------------------------------------------
-- THIRD NUMBER MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_3 = modifier_chibi_marci_3 or class({})

function modifier_chibi_marci_3:IsHidden() return false end
function modifier_chibi_marci_3:IsDebuff() return false end
function modifier_chibi_marci_3:IsPurgable() return false end
function modifier_chibi_marci_3:IsPurgeException() return false end
function modifier_chibi_marci_3:RemoveOnDeath() return false end
function modifier_chibi_marci_3:OnCreated( kv )
    self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
    hCombinations[self.parent] = hCombinations[self.parent] or {}
	
	self:StartIntervalThink(1.5)
end
function modifier_chibi_marci_3:OnIntervalThink()
    self:Destroy()
	self:StartIntervalThink(-1)
end
function modifier_chibi_marci_3:OnDestroy()
   if not IsServer() then return end
   
   local Mod1 = self.parent:FindModifierByName("modifier_chibi_marci_1")
   local Mod2 = self.parent:FindModifierByName("modifier_chibi_marci_2")
   local Mod3 = self
   
   local iStacksFull = Mod1:GetStackCount() .. Mod2:GetStackCount() .. Mod3:GetStackCount()
   
   if Mod1 and Mod2 then
      hCombinations[self.parent] = iStacksFull
   end

   --print(iStacksFull)
   --print(hCombinations[self.parent])
   
   -- Modifier 1 and 2 cannot exist without 3... avoiding extra checks
   self.parent:RemoveModifierByNameAndCaster("modifier_chibi_marci_1", self.parent)
   self.parent:RemoveModifierByNameAndCaster("modifier_chibi_marci_2", self.parent)
   self.parent:AddNewModifier(self.parent, self.ability, "modifier_chibi_marci_result", {} )
end

---------------------------------------------------------------------------------------------------------------------
-- RESULT MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_result = modifier_chibi_marci_result or class({})

function modifier_chibi_marci_result:IsHidden() return false end
function modifier_chibi_marci_result:IsDebuff() return false end
function modifier_chibi_marci_result:IsPurgable() return false end
function modifier_chibi_marci_result:IsPurgeException() return false end
function modifier_chibi_marci_result:RemoveOnDeath() return false end
function modifier_chibi_marci_result:OnCreated( kv )
    self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
    local combo = hCombinations[self.parent]
	--print(combo)
    if not IsServer() or not combo then
	    self:Destroy()
        return
    end
	
	self.combination = combo

	self:StartIntervalThink(0.2)
end
function modifier_chibi_marci_result:OnIntervalThink()
    self:Destroy()
	self:StartIntervalThink(-1)
end
function modifier_chibi_marci_result:OnDestroy()
    if not IsServer() or not self.combination then return end
	
    local ResultModifier = hBuffsTable[self.combination]
	--print(ResultModifier)
	if ResultModifier then
       self.parent:AddNewModifier(self.parent, self.ability, ResultModifier, {} )
	else
       EmitSoundOn("chibi.sad", self.parent)
	   return
	end
	
	hCombinations[self.parent] = nil
end

---------------------------------------------------------------------------------------------------------------------
-- BUFFS AND DEBUFFS HERE
-- TOO MANY MEMES
---------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------
-- BUFF GOLDEN LEGENDARY MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_golden_legendary = modifier_chibi_marci_golden_legendary or class({})

function modifier_chibi_marci_golden_legendary:IsHidden() return false end
function modifier_chibi_marci_golden_legendary:RemoveOnDeath() return true end
function modifier_chibi_marci_golden_legendary:IsDebuff() return false end
function modifier_chibi_marci_golden_legendary:IsStunDebuff() return false end
function modifier_chibi_marci_golden_legendary:IsPurgable() return false end
function modifier_chibi_marci_golden_legendary:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_golden_legendary:DeclareFunctions()
	local funcs = {
		              MODIFIER_PROPERTY_MODEL_SCALE,
					  MODIFIER_PROPERTY_HEALTH_BONUS,
					  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
			      }
	return funcs
end
function modifier_chibi_marci_golden_legendary:OnCreated(hTable)
    self.parent = self:GetParent()
	if not IsServer() then return end
    self.parent:EmitSound("chibi.golden_legendary")
	
	self:StartIntervalThink(20.0)
end
function modifier_chibi_marci_golden_legendary:OnIntervalThink()
    self:Destroy()
end
function modifier_chibi_marci_golden_legendary:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_chibi_marci_golden_legendary:GetEffectName()
    return "particles/custom/units/legendary_creep/effect.vpcf"
end
function modifier_chibi_marci_golden_legendary:StatusEffectPriority()
    return 999999
end
function modifier_chibi_marci_golden_legendary:GetStatusEffectName()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end
function modifier_chibi_marci_golden_legendary:GetModifierModelScale()
	return 25
end
function modifier_chibi_marci_golden_legendary:GetModifierHealthBonus()
	return 500
end
function modifier_chibi_marci_golden_legendary:GetModifierHealthRegenPercentage()
    return 5
end

---------------------------------------------------------------------------------------------------------------------
-- BUFF GIANT MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_giant = modifier_chibi_marci_giant or class({})

function modifier_chibi_marci_giant:IsHidden() return false end
function modifier_chibi_marci_giant:RemoveOnDeath() return true end
function modifier_chibi_marci_giant:IsDebuff() return false end
function modifier_chibi_marci_giant:IsStunDebuff() return false end
function modifier_chibi_marci_giant:IsPurgable() return false end
function modifier_chibi_marci_giant:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_giant:DeclareFunctions()
	local funcs = {
		              MODIFIER_PROPERTY_MODEL_SCALE,
					  MODIFIER_PROPERTY_HEALTH_BONUS,
					  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			      }
	return funcs
end
function modifier_chibi_marci_giant:OnCreated(hTable)
    if not IsServer() then return end
	self.parent = self:GetParent()
    self.parent:EmitSound("chibi.immortality")
    self.parent:EmitSound("chibi.godzilla")
	
	self:StartIntervalThink(20.0)
end
function modifier_chibi_marci_giant:OnIntervalThink()
    self:Destroy()
end
function modifier_chibi_marci_giant:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_chibi_marci_giant:GetModifierModelScale()
	return 200
end
function modifier_chibi_marci_giant:GetModifierHealthBonus()
    return 10000
end
function modifier_chibi_marci_giant:GetModifierMoveSpeedBonus_Constant()
	return -400
end
function modifier_chibi_marci_giant:GetModifierAttackSpeedBonus_Constant()
    return -700
end

---------------------------------------------------------------------------------------------------------------------
-- BUFF INSTANT TRASH MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_instant_trash = modifier_chibi_marci_instant_trash or class({})

function modifier_chibi_marci_instant_trash:IsHidden() return false end
function modifier_chibi_marci_instant_trash:RemoveOnDeath() return true end
function modifier_chibi_marci_instant_trash:IsDebuff() return false end
function modifier_chibi_marci_instant_trash:IsStunDebuff() return false end
function modifier_chibi_marci_instant_trash:IsPurgable() return false end
function modifier_chibi_marci_instant_trash:GetTexture() 
    return "chibi_marci"
end

---------------------------------------------------------------------------------------------------------------------
-- BUFF DARK SOULS MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_dark_souls = modifier_chibi_marci_dark_souls or class({})

function modifier_chibi_marci_dark_souls:IsHidden() return false end
function modifier_chibi_marci_dark_souls:RemoveOnDeath() return true end
function modifier_chibi_marci_dark_souls:IsDebuff() return false end
function modifier_chibi_marci_dark_souls:IsStunDebuff() return false end
function modifier_chibi_marci_dark_souls:IsPurgable() return false end
function modifier_chibi_marci_dark_souls:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_dark_souls:DeclareFunctions()
	local funcs = {
		              MODIFIER_PROPERTY_MODEL_SCALE,
			      }
	return funcs
end
function modifier_chibi_marci_dark_souls:OnCreated(hTable)
    self.parent = self:GetParent()
    
	if IsServer() then
        -- Add the extra ability to the hero
        local hExtraAbility = self.parent:AddAbility("dark_souls_roll")
        hExtraAbility:SetLevel(1)  -- Set the ability level
        
        -- Store a reference to the extra ability
        self.hExtraAbility = hExtraAbility
	    self:StartIntervalThink(10.0)
        self.parent:EmitSound("chibi.darksouls")
    end
end
function modifier_chibi_marci_dark_souls:OnIntervalThink()
    self:Destroy()
end
function modifier_chibi_marci_dark_souls:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_chibi_marci_dark_souls:GetModifierModelScale()
	return 20
end
function modifier_chibi_marci_dark_souls:OnDestroy()
    if IsServer() then
        -- Remove the extra ability when the modifier is destroyed
        local hExtraAbility = self.hExtraAbility
        if hExtraAbility then
            self.parent:RemoveAbility("dark_souls_roll")
        end
    end
end

---------------------------------------------------------------------------------------------------------------------
-- BUFF AMATERASU MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_amaterasu = modifier_chibi_marci_amaterasu or class({})

function modifier_chibi_marci_amaterasu:IsHidden() return false end
function modifier_chibi_marci_amaterasu:RemoveOnDeath() return true end
function modifier_chibi_marci_amaterasu:IsDebuff() return false end
function modifier_chibi_marci_amaterasu:IsStunDebuff() return false end
function modifier_chibi_marci_amaterasu:IsPurgable() return false end
function modifier_chibi_marci_amaterasu:GetTexture() 
    return "chibi_marci"
end
---------------------------------------------------------------------------------------------------------------------












---------------------------------------------------------------------------------------------------------------------
-- DEBUFF SLAVE MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_slave = modifier_chibi_marci_slave or class({})

function modifier_chibi_marci_slave:IsHidden() return false end
function modifier_chibi_marci_slave:RemoveOnDeath() return true end
function modifier_chibi_marci_slave:IsDebuff() return false end
function modifier_chibi_marci_slave:IsStunDebuff() return false end
function modifier_chibi_marci_slave:IsPurgable() return false end
function modifier_chibi_marci_slave:CheckState()
	local state = {
		              [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		              [MODIFIER_STATE_INVULNERABLE] = true,
		              [MODIFIER_STATE_STUNNED] = true,
	              }

	return state
end
function modifier_chibi_marci_slave:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_slave:OnCreated(hTable)
    if IsServer() then
	    self.parent = self:GetParent()
	    self.ability = self:GetAbility()
		
	    self.bDestroy = nil
	
        local sMessage = "F**** Slave."
        GameRules:SendCustomMessage(sMessage, 0, 0)
		
		EmitGlobalSound("chibi.slave")
	    self:StartIntervalThink(7.0)
	end
end
function modifier_chibi_marci_slave:OnIntervalThink()
    if not IsServer() then return end

    if not self.bDestroy then
	    -- NPC spawned name
        local sNpc = "npc_dota_fisting_billy"

	    -- Parameters for cone
	    local iConeRad = 200  -- Width
	    local iConeAng = 45    -- Angle

	    -- Get the target's position and facing direction
	    local vTargetPos = self.parent:GetAbsOrigin()
	    local vTargetForward = -self.parent:GetForwardVector()

	    -- Determine the step angle between NPCs in the cone
	    local fStepAng = iConeAng / 2
    
	    -- Determine the initial spawn direction behind the target
	    local vInitDir = RotatePosition(Vector(0, 0, 0), QAngle(0, -iConeAng / 2, 0), vTargetForward)
    
	    -- Spawn and position the NPCs in the cone behind the target
	    for i = 1, 3 do
            -- Rotate the initial direction based on the step angle
            local vDirection = RotatePosition(Vector(0, 0, 0), QAngle(0, (i - 1) * fStepAng, 0), vInitDir)
        
            -- Calculate the spawn position based on the direction
            local vSpawnPos = vTargetPos  + vDirection * iConeRad
        
            -- Spawn the NPC and set its position
            Timers:CreateTimer(i, function()
                local hNpc = CreateUnitByName(sNpc, vSpawnPos, true, nil, nil, DOTA_TEAM_NEUTRALS)
        
                -- Set the NPC's facing direction towards the target
                local vFacingAng = (vTargetPos  - vSpawnPos):Normalized()
                hNpc:SetForwardVector(vFacingAng)
		   
                -- Apply particle effects
                if not self.billyarrive then
	                local particle_cast = "particles/billy_return_to_heaven.vpcf"

	                -- Create Particle
	                local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self.parent )
	                ParticleManager:SetParticleControl( effect_cast, 0, vSpawnPos )
	                ParticleManager:SetParticleControl( effect_cast, 1, Vector( 200, 200, 200 ) )
	                ParticleManager:ReleaseParticleIndex( effect_cast )
	            end
        
                -- Apply invulnerability and untargetable modifier as mentioned earlier
                hNpc:AddNewModifier(self.parent, self, "modifier_chibi_marci_slave_fisting", { interval = i })
            end)
        
		end

		self.bDestroy = 1
		self:StartIntervalThink(26.5)
	else
	    self:Destroy()
	    self:StartIntervalThink(-1)
    end
end
function modifier_chibi_marci_slave:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_chibi_marci_slave:GetEffectName()
	return "particles/slave_cage.vpcf"
end
function modifier_chibi_marci_slave:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_chibi_marci_slave:OnDestroy()
    if not IsServer() or not self.parent then return end
	
	if not self.parent:IsAlive() then return end
	self.parent:ForceKill(false)
    self.parent:SetTimeUntilRespawn(2.0)
	StopGlobalSound("chibi.slave")
end

---------------------------------------------------------------------------------------------------------------------
-- DEBUFF EXPLODE MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_explode = modifier_chibi_marci_explode or class({})

function modifier_chibi_marci_explode:IsHidden() return false end
function modifier_chibi_marci_explode:RemoveOnDeath() return true end
function modifier_chibi_marci_explode:IsDebuff() return false end
function modifier_chibi_marci_explode:IsStunDebuff() return false end
function modifier_chibi_marci_explode:IsPurgable() return false end
function modifier_chibi_marci_explode:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_explode:DeclareFunctions()
	local funcs = {
		              MODIFIER_PROPERTY_MODEL_SCALE,
			      }
	return funcs
end
function modifier_chibi_marci_explode:OnCreated(hTable)
    self.parent = self:GetParent()
	
	if not IsServer() then return end
    self.parent:EmitSound("chibi.balloon1")
	
	self:StartIntervalThink(2.0)
end
function modifier_chibi_marci_explode:OnIntervalThink()
    if not IsServer() then return end
    self:Destroy()
    self.parent:EmitSound("chibi.balloon2")
    local particle = ParticleManager:CreateParticle("particles/blood_moon_explosion1.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
	self.parent:AddNoDraw()
end
function modifier_chibi_marci_explode:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_chibi_marci_explode:GetModifierModelScale()
	return 400
end
function modifier_chibi_marci_explode:OnDestroy()
    if IsServer() then
	   if self.parent and self.parent:IsAlive() then
	      self.parent:ForceKill(false)
          self.parent:SetTimeUntilRespawn(2.0)
		  local iRand = RandomInt(1, 2)
		  local Result = nil
		  if iRand == 1 then Result = "chibi.holyshit" else Result = "chibi.jojo_omg" end
          self.parent:EmitSound(Result)
	   end
	end
end

---------------------------------------------------------------------------------------------------------------------
-- DEBUFF AYAYA MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_AYAYA = modifier_chibi_marci_AYAYA or class({})

function modifier_chibi_marci_AYAYA:IsHidden() return false end
function modifier_chibi_marci_AYAYA:RemoveOnDeath() return true end
function modifier_chibi_marci_AYAYA:IsDebuff() return false end
function modifier_chibi_marci_AYAYA:IsStunDebuff() return false end
function modifier_chibi_marci_AYAYA:IsPurgable() return false end
function modifier_chibi_marci_AYAYA:CheckState()
    local state = {
                      [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                  }
    return state
end
function modifier_chibi_marci_AYAYA:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_AYAYA:OnCreated(hTable)
    self.parent = self:GetParent()
	if not IsServer() then return end
    self.parent:EmitSound("chibi.ayaya")
	self.counter = nil
	
	self:StartIntervalThink(1.5)
end
function modifier_chibi_marci_AYAYA:OnIntervalThink()
    if not IsServer() then return end
	
	if not self.counter then
	   self.parent:EmitSound("chibi.spotted")
	   self.counter = 1
    else
       self.parent:EmitSound("chibi.csgo_awp")
	   self:Destroy()
	   self:StartIntervalThink(-1)
	end
end
function modifier_chibi_marci_AYAYA:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_chibi_marci_AYAYA:GetEffectName()
	return "particles/chibi_marci_ayaya_overhead_real.vpcf"
end
function modifier_chibi_marci_AYAYA:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_chibi_marci_AYAYA:OnDestroy()
    if not IsServer() or not self.parent or not self.parent:IsAlive() then return end
	self.parent:ForceKill(false)
    self.parent:SetTimeUntilRespawn(2.0)
end

---------------------------------------------------------------------------------------------------------------------
-- DEBUFF ICECREAM MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_icecream = modifier_chibi_marci_icecream or class({})

function modifier_chibi_marci_icecream:IsHidden() return false end
function modifier_chibi_marci_icecream:RemoveOnDeath() return true end
function modifier_chibi_marci_icecream:IsDebuff() return false end
function modifier_chibi_marci_icecream:IsStunDebuff() return false end
function modifier_chibi_marci_icecream:IsPurgable() return false end
function modifier_chibi_marci_icecream:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_icecream:OnCreated(hTable)
    self.parent = self:GetParent()
	
	if not IsServer() then return end
    self.parent:EmitSound("chibi.icecream")
	self:StartIntervalThink(2.0)
end
function modifier_chibi_marci_icecream:OnIntervalThink()
    self:Destroy()
end
function modifier_chibi_marci_icecream:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_chibi_marci_icecream:GetEffectName()
	return "particles/chibi_marci_ayaya_overhead.vpcf"
end
function modifier_chibi_marci_icecream:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_chibi_marci_icecream:OnDestroy()
    if IsServer() then
	   if self.parent and self.parent:IsAlive() then
	      self.parent:ForceKill(false)
          self.parent:SetTimeUntilRespawn(2.0)
          local iPlayerID = self.parent:GetPlayerOwnerID()
          local sPlayerName = PlayerResource:GetPlayerName(iPlayerID)
          local sMessage = sPlayerName .. " died from brain damage."
          GameRules:SendCustomMessage(sMessage, 0, 0)
	   end
	end
end

---------------------------------------------------------------------------------------------------------------------
-- DEBUFF GAMBLE MODIFIER
---------------------------------------------------------------------------------------------------------------------
modifier_chibi_marci_gamble = modifier_chibi_marci_gamble or class({})

function modifier_chibi_marci_gamble:IsHidden() return false end
function modifier_chibi_marci_gamble:RemoveOnDeath() return true end
function modifier_chibi_marci_gamble:IsDebuff() return false end
function modifier_chibi_marci_gamble:IsStunDebuff() return false end
function modifier_chibi_marci_gamble:IsPurgable() return false end
function modifier_chibi_marci_gamble:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_gamble:OnCreated(hTable)
    self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.stacks = self:GetStackCount()
	
	self:StartIntervalThink(2.0)
end
function modifier_chibi_marci_gamble:OnIntervalThink()
end
function modifier_chibi_marci_gamble:OnRefresh(hTable)
	self:OnCreated(hTable)
end










---------------------------------------------------------------------------------------------------------------------
-- HELPER ABILITIES AND MODIFIERS
---------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------
-- INSTANT GARBAGE MODIFIER
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_chibi_marci_instant_trash_think", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE)

modifier_chibi_marci_instant_trash_think = modifier_chibi_marci_instant_trash_think or class({})

function modifier_chibi_marci_instant_trash_think:IsHidden() return false end
function modifier_chibi_marci_instant_trash_think:IsDebuff() return false end
function modifier_chibi_marci_instant_trash_think:IsPurgable() return false end
function modifier_chibi_marci_instant_trash_think:CheckState()
    local state = {
                      [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                  }
    return state
end
function modifier_chibi_marci_instant_trash_think:OnCreated( kv )
        if not IsServer() then return end
        self.caster = self:GetCaster()
	    self.parent = self:GetParent()
		self.ability = self:GetAbility()

		self.Target = EntIndexToHScript(kv.enemy_target) or nil
		self.vEnemyPos = self.Target:GetOrigin()
		self.iSpeed = 100
		self.iBreakDist = 100
		self.bFinished = false
		
		
		if self.Target == nil then self:Destroy() print("Something went wrong.") return end
		
		-- Add the particle here because if distance is too close it doesn't appear
		if not self.TrashBin then
		   self.TrashBin =  ParticleManager:CreateParticle("particles/spamton_trash_can.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)            
           self:AddParticle(self.TrashBin, false, false, -1, false, false)
		end
		
        self.hDamageTable = {
             victim = nil,
             attacker = self.caster,
             damage = 1500,
             damage_type = DAMAGE_TYPE_MAGICAL,
             ability = self.ability
            }
		
        self:StartIntervalThink(0.03)
end
function modifier_chibi_marci_instant_trash_think:OnIntervalThink()
    if IsServer() then
        local vEnemyPosition = nil

        if not self.bFinished then
		    -- Calculate new position
            local vDirection = (self.vEnemyPos - self.parent:GetAbsOrigin()):Normalized()
            vEnemyPosition = self.parent:GetOrigin() + vDirection * self.iSpeed
            self.parent:SetOrigin(vEnemyPosition)

            -- Check if the trash bin has hit somebody
	        local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(),	-- int, your team number
			                                 self.parent:GetOrigin(),	-- point, center point
			                                 nil,	-- handle, cacheUnit. (not known)
			                                 150,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			                                 DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			                                 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			                                 0,	-- int, flag filter
			                                 FIND_CLOSEST,	-- int, order filter
			                                 false	-- bool, can grow cache
		                                    )
		    for _,enemy in pairs(enemies) do
			    self.hDamageTable.victim = enemy
				ApplyDamage(self.hDamageTable)
				self.bFinished = true
	        end
			
			if self.bFinished or GetDistance(self.parent, self.vEnemyPos) <= self.iBreakDist then
		        if not self.StompEffect then
		            self.StompEffect =  ParticleManager:CreateParticle("particles/decompiled_particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)            
                    self:AddParticle(self.StompEffect, false, false, -1, false, false)
				end
				EmitSoundOn("chibi.trash", self.parent)
		        self:Destroy()
				return
			end
	    end
    end
end
function modifier_chibi_marci_instant_trash_think:OnRefresh( kv )
	self:OnCreated( kv )
end
--[[function modifier_chibi_marci_instant_trash_think:GetEffectName()
	return "particles/spamton_trash_can.vpcf"
end
function modifier_chibi_marci_instant_trash_think:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end]]--
function modifier_chibi_marci_instant_trash_think:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsRealHero() then
		    UTIL_Remove(self.parent)
		end
    end
end

---------------------------------------------------------------------------------------------------------------------
-- DARK SOULS ROLL AND MODIFIER
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_dark_souls_roll", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE)

dark_souls_roll = dark_souls_roll or class({})

function dark_souls_roll:OnSpellStart()
    if not IsServer() then return end

    local hCaster = self:GetCaster()
    local vForward = hCaster:GetForwardVector()
    local fDuration = 0.5
    local iDistance = 200

    -- Apply the roll modifier
    hCaster:AddNewModifier(hCaster, self, "modifier_dark_souls_roll", {
        duration = fDuration,
        forward_x = vForward.x,
        forward_y = vForward.y,
        distance = iDistance
    })
end

modifier_dark_souls_roll = modifier_dark_souls_roll or class({})

function modifier_dark_souls_roll:IsHidden() return false end
function modifier_dark_souls_roll:IsDebuff() return false end
function modifier_dark_souls_roll:IsPurgable() return false end
function modifier_dark_souls_roll:CheckState()
	local state = {
		              [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		              [MODIFIER_STATE_INVULNERABLE] = true,
		              [MODIFIER_STATE_STUNNED] = true,
	              }

	return state
end
function modifier_dark_souls_roll:OnCreated(keys)
    if not IsServer() then return end

    self.parent = self:GetParent()
    self.vForward = Vector(keys.forward_x, keys.forward_y, 0):Normalized()
    self.iDistance = keys.distance

    -- Rotate the player and move forward slightly on creation
    self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + self.vForward * self.iDistance)

    -- Add a motion controller to prevent other movements
    self:StartIntervalThink(0.03)
end
function modifier_dark_souls_roll:OnIntervalThink()
    if not IsServer() then return end

    local vRotation = self.parent:GetAnglesAsVector()
    vRotation.x = vRotation.x + 360 * 0.12
    self.parent:SetAngles(vRotation.x, vRotation.y, vRotation.z)
end
function modifier_dark_souls_roll:OnDestroy()
    if not IsServer() then return end

    -- Reset the player's motion controller and angles
    self.parent:InterruptMotionControllers(true)
    self.parent:SetAngles(0, 0, 0)
end

---------------------------------------------------------------------------------------------------------------------
-- AMATERASU TARGET MODIFIER
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_chibi_marci_amaterasu_target", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE)
modifier_chibi_marci_amaterasu_target = modifier_chibi_marci_amaterasu_target or class({})

function modifier_chibi_marci_amaterasu_target:IsHidden() return false end
function modifier_chibi_marci_amaterasu_target:RemoveOnDeath() return true end
function modifier_chibi_marci_amaterasu_target:IsDebuff() return false end
function modifier_chibi_marci_amaterasu_target:IsStunDebuff() return false end
function modifier_chibi_marci_amaterasu_target:IsPurgable() return false end
function modifier_chibi_marci_amaterasu_target:DeclareFunctions()
	local funcs = {
		              MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
			      }
	return funcs
end
function modifier_chibi_marci_amaterasu_target:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_amaterasu_target:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	self:StartIntervalThink(1.0)
end
function modifier_chibi_marci_amaterasu_target:OnIntervalThink()
    if not IsServer() then return end
    
	-- Ensure the parent is valid and is an enemy
    if self.parent and self.parent:IsAlive() and not self.parent:IsMagicImmune() and not self.parent:IsInvulnerable() then
        local maxHealth = self.parent:GetMaxHealth()
        local damage = maxHealth * 0.10  -- 10% of maximum health

        -- Apply damage to the enemy
        local hDamageTable = {
            victim = self.parent,
            attacker = self.caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability
        }

        ApplyDamage(hDamageTable)
    end
end
function modifier_chibi_marci_amaterasu_target:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_chibi_marci_amaterasu_target:GetEffectName()
	return "particles/custom/units/legendary_creep/effect_fire.vpcf"
end
function modifier_chibi_marci_amaterasu_target:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_chibi_marci_amaterasu_target:GetModifierHPRegenAmplify_Percentage()
	return -100
end

---------------------------------------------------------------------------------------------------------------------
-- AMATERASU PRE VISUAL MODIFIER
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_chibi_marci_amaterasu_pre", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE)
modifier_chibi_marci_amaterasu_pre = modifier_chibi_marci_amaterasu_pre or class({})

function modifier_chibi_marci_amaterasu_pre:IsHidden() return false end
function modifier_chibi_marci_amaterasu_pre:RemoveOnDeath() return true end
function modifier_chibi_marci_amaterasu_pre:IsDebuff() return true end
function modifier_chibi_marci_amaterasu_pre:IsStunDebuff() return false end
function modifier_chibi_marci_amaterasu_pre:IsPurgable() return false end
function modifier_chibi_marci_amaterasu_pre:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_amaterasu_pre:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
    if not IsServer() then return end
	self.parent:EmitSound("chibi.amaterasu")
	
	self:StartIntervalThink(2.0)
end
function modifier_chibi_marci_amaterasu_pre:OnIntervalThink()
    self:Destroy()
end
function modifier_chibi_marci_amaterasu_pre:OnDestroy()
    if IsServer() then
	   self.parent:AddNewModifier(self.parent, self.ability, "modifier_chibi_marci_amaterasu_target", {duration = 10.0} )
	end
end

---------------------------------------------------------------------------------------------------------------------
-- SLAVE MODIFIER FISTING
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_chibi_marci_slave_fisting", "items/item_chibi_marci", LUA_MODIFIER_MOTION_NONE)
modifier_chibi_marci_slave_fisting = modifier_chibi_marci_slave_fisting or class({})

function modifier_chibi_marci_slave_fisting:IsHidden() return false end
function modifier_chibi_marci_slave_fisting:RemoveOnDeath() return true end
function modifier_chibi_marci_slave_fisting:IsDebuff() return false end
function modifier_chibi_marci_slave_fisting:IsStunDebuff() return false end
function modifier_chibi_marci_slave_fisting:IsPurgable() return false end
function modifier_chibi_marci_slave_fisting:CheckState()
	local state = {
		              [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		              [MODIFIER_STATE_INVULNERABLE] = true,
		              [MODIFIER_STATE_STUNNED] = true,
	              }

	return state
end
function modifier_chibi_marci_slave_fisting:GetTexture() 
    return "chibi_marci"
end
function modifier_chibi_marci_slave_fisting:OnCreated( kv )
    if IsServer() then
	    self.parent = self:GetParent()
	    self.MuscleFlex = false
	    self.Fisting = false
	    self.Finish = false
	
	    self.interval = kv.interval / 1.0
	    
		self:StartIntervalThink(0.03)
    end
end
function modifier_chibi_marci_slave_fisting:OnIntervalThink()
    if not IsServer() then return end
    
	if not self.MuscleFlex then
	   self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	   self.MuscleFlex = true
       self.Fisting = true
	   self:StartIntervalThink(7.0 - self.interval )
	   return
	end
	
	if self.Fisting then
	   self.parent:StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)
       self.Fisting = false
	   self.Finish  = true
	   self:StartIntervalThink(19.0)
	   return
	end
	
	if self.Finish then
	   self:Destroy()
	   self:StartIntervalThink(-1)
	end
end
function modifier_chibi_marci_slave_fisting:OnRefresh( kv )
    self:OnCreated( kv )
end
function modifier_chibi_marci_slave_fisting:GetEffectName()
	return "particles/gachi_paradise.vpcf"
end
function modifier_chibi_marci_slave_fisting:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_chibi_marci_slave_fisting:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsRealHero() then
		    UTIL_Remove(self.parent)
		end
    end
end

