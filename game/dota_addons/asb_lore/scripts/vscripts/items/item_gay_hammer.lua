item_gay_hammer = item_gay_hammer or class({})

LinkLuaModifier( "modifier_emit_video", "items/item_gay_hammer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gay_garbage", "items/item_gay_hammer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE )
-----------------------------------------------------------------------------------------------------------------------------------
local hero_replaced
local adminPlayerID = 82664205 -- xdddd

-- Listen to the chat event
ListenToGameEvent("player_chat", function(event)
    local playerID = event.playerid
    local text = event.text
    local id32 = PlayerResource:IsFakeClient(playerID) and playerID * 32 or PlayerResource:GetSteamAccountID(playerID)
	if id32 ~= adminPlayerID then return end

    -- Check if the chat message is intended to set the hero_replaced variable
    if string.sub(text, 1, 8) == "-sethero" then
        local words = {}
        for word in string.gmatch(text, "%S+") do
            table.insert(words, word)
        end

        if #words >= 2 then
            -- The second word should be the hero name
            hero_replaced = words[2]
            print("The current hero is: " .. hero_replaced)
        end
    end
end, nil)
-----------------------------------------------------------------------------------------------------------------------------------
function item_gay_hammer:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	
    -- Absolute cringe format, make it nicer later...
        local arcana = 137775440
		local arcana1 = 418417801   --Chumba
	local arcana2 = 167912041	--Miku
    local arcana6 = 174719954	--Sanya
	local arcana7 = 117795030   --Tlen
	local arcana8 = 82664205    -- M1
	
	if id32 == arcana8 then
	  if hero_replaced ~= "gay_garbage" then
	    local items = {}
	  
	    -- Change items 
	    for i = DOTA_ITEM_SLOT_1, DOTA_STASH_SLOT_6 + 2 do
	      local item = target:GetItemInSlot(i)
		  if item and item ~= self then
	        table.insert(items, i, item)
		    target:TakeItem(item)
		  end
	    end


      -- Change the hero
	  local hero = PlayerResource:ReplaceHeroWith(target:GetPlayerOwnerID(), hero_replaced, 0, 0)
	    for k, v in pairs(items) do
		  if k and v then
		    local item = hero:AddItem(v)
		    hero:SwapItems(item:GetItemSlot(), k)
		  end
	    end

      -- Modify Gold and XP
	  hero:ModifyGold(target:GetGold() - hero:GetGold(), true, 0)
      hero:AddExperience(target:GetCurrentXP() - hero:GetCurrentXP(), 0, false, false)

	  -- Particles and Sound Effects
	  local cast_fx = ParticleManager:CreateParticle("particles/baal_shattered_screen_ultimate.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					  ParticleManager:ReleaseParticleIndex(cast_fx)

	  local table_sounds = {	"gay.hammer" }

	  EmitSoundOn(table_sounds[RandomInt(1, #table_sounds)], hero)
	  else
	    target:AddNewModifier(caster, self, "modifier_gay_garbage", {duration = 30})
      end
	else
      caster:AddNewModifier(caster, self, "modifier_gay_garbage", {duration = 30})
    end
end


modifier_emit_video = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_emit_video:IsHidden()
	return true
end

function modifier_emit_video:IsDebuff()
	return true
end

function modifier_emit_video:IsStunDebuff()
	return false
end
function modifier_emit_video:RemoveOnDeath() return false end
function modifier_emit_video:IsPurgable()
	return false
end

function modifier_emit_video:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations


function modifier_emit_video:OnRefresh( kv )
	
end

function modifier_emit_video:OnRemoved()
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_emit_video:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end
function modifier_emit_video:GetModifierProvidesFOWVision()
	return 1
end
function modifier_emit_video:GetModifierIncomingDamage_Percentage( params )
		return 100
end
function modifier_emit_video:OnDeath()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    	self.video = "emit_video"
	 local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
        CustomGameEventManager:Send_ServerToPlayer(Player, self.video, {} )
end
function modifier_emit_video:OnUnitMoved(params)

local caster = self:GetCaster()
	if IsServer() then
	if not self:GetParent():IsIllusion() then
		local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end
	if pass then
  local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
        CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_end", {} )
	return 
end
end
end
end


modifier_gay_garbage = modifier_gay_garbage or class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gay_garbage:IsHidden() return false end
function modifier_gay_garbage:IsDebuff() return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber() end
function modifier_gay_garbage:IsStunDebuff() return true end
function modifier_gay_garbage:IsPurgable() return true end
function modifier_gay_garbage:RemoveOnDeath() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_gay_garbage:OnCreated( kv )
	-- references
	local damage = 0
	self.radius = 150
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	local sound_cast = "kiberbulling.yes"
	EmitSoundOn( sound_cast, self:GetCaster() )
	self:GetParent():AddNoDraw()
	self:PlayEffects()
	
end
function modifier_gay_garbage:OnRefresh( kv )
	-- references
	local damage = 0
	self.radius = 150

	if not IsServer() then return end
	self.damageTable.damage = damage
end
function modifier_gay_garbage:OnRemoved()
end
function modifier_gay_garbage:OnDestroy()
	if not IsServer() then return end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play overhead event
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
			self:GetParent(),
			self.damageTable.damage,
			nil
		)
	end
	

	-- play effects
	self:GetParent():RemoveNoDraw()
	

	local sound_cast = "spamton.trash_explosion"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	local caster = self:GetCaster()
	local knockback = { should_stun = 1,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 0,
                        knockback_height = 300,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    self:GetParent():AddNewModifier(caster, self, "modifier_knockback", knockback)
	self:PlayEffects2()
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_gay_garbage:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_gay_garbage:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/gay_garbage.vpcf"
	local particle_cast2 = ""
	
	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end
function modifier_gay_garbage:PlayEffects2()
	-- Get Resources
	local particle_cast1 = "particles/homura_grenade_explosion.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end