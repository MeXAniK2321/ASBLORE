castle_teleport = class({})
LinkLuaModifier( "modifier_castle_teleport", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tp_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function castle_teleport:GetIntrinsicModifierName()
	return "modifier_castle_teleport"
end
modifier_castle_teleport = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_castle_teleport:IsHidden()
	return true
end

function modifier_castle_teleport:IsDebuff()
	return false
end

function modifier_castle_teleport:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_castle_teleport:OnCreated( kv )
if IsServer() then
	
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( 1.0 )
	self:OnIntervalThink()
	end
	end
	


function modifier_castle_teleport:OnRefresh( kv )
	
end

function modifier_castle_teleport:OnRemoved()

end
function modifier_castle_teleport:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_castle_teleport:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_castle_teleport:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	
	local origin2 = _G.CastleTp
self:PlayEffects(origin2)
	end
	end
	
end
	

function modifier_castle_teleport:PlayEffects(origin2)
if IsServer() then
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	FindClearSpaceForUnit( enemy, origin2, true )
	enemy:AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_tp_invul", -- modifier name
		{ duration = 3 } -- kv
	)
	PlayerResource:SetCameraTarget( enemy:GetPlayerID(), enemy )
	Timers:CreateTimer(0.1, function()
    PlayerResource:SetCameraTarget(enemy:GetPlayerOwnerID(), nil)
  end)
	end
	end
	
end
castle_teleport_origin = class({})
LinkLuaModifier( "modifier_castle_teleport_origin", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tp_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function castle_teleport_origin:GetIntrinsicModifierName()
	return "modifier_castle_teleport_origin"
end
modifier_castle_teleport_origin = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_castle_teleport_origin:IsHidden()
	return true
end

function modifier_castle_teleport_origin:IsDebuff()
	return false
end

function modifier_castle_teleport_origin:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_castle_teleport_origin:OnCreated( kv )
if IsServer() then
_G.CastleTp = self:GetParent():GetOrigin()
	end
	end
	demon_teleport_origin = class({})
LinkLuaModifier( "modifier_demon_teleport_origin", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tp_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function demon_teleport_origin:GetIntrinsicModifierName()
	return "modifier_demon_teleport_origin"
end
modifier_demon_teleport_origin = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_demon_teleport_origin:IsHidden()
	return true
end

function modifier_demon_teleport_origin:IsDebuff()
	return false
end

function modifier_demon_teleport_origin:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_demon_teleport_origin:OnCreated( kv )
if IsServer() then
_G.DemonTp = self:GetParent():GetOrigin()
	end
	end
	elf_teleport_origin = class({})
LinkLuaModifier( "modifier_elf_teleport_origin", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tp_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function elf_teleport_origin:GetIntrinsicModifierName()
	return "modifier_elf_teleport_origin"
end
modifier_elf_teleport_origin = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_elf_teleport_origin:IsHidden()
	return true
end

function modifier_elf_teleport_origin:IsDebuff()
	return false
end

function modifier_elf_teleport_origin:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_elf_teleport_origin:OnCreated( kv )
if IsServer() then
_G.elfTp = self:GetParent():GetOrigin()
	end
	end
	necro_teleport_origin = class({})
LinkLuaModifier( "modifier_necro_teleport_origin", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tp_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function necro_teleport_origin:GetIntrinsicModifierName()
	return "modifier_necro_teleport_origin"
end
modifier_necro_teleport_origin = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_necro_teleport_origin:IsHidden()
	return true
end

function modifier_necro_teleport_origin:IsDebuff()
	return false
end

function modifier_necro_teleport_origin:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_necro_teleport_origin:OnCreated( kv )
if IsServer() then
_G.necroTp = self:GetParent():GetOrigin()
	end
	end

demon_teleport = class({})
LinkLuaModifier( "modifier_demon_teleport", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tp_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function demon_teleport:GetIntrinsicModifierName()
	return "modifier_demon_teleport"
end
modifier_demon_teleport = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_demon_teleport:IsHidden()
	return true
end

function modifier_demon_teleport:IsDebuff()
	return false
end

function modifier_demon_teleport:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_demon_teleport:OnCreated( kv )
if IsServer() then

	self.tp_origin = _G.DemonTp
	
	
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( 1.0 )
	self:OnIntervalThink()
	end
	end
	


function modifier_demon_teleport:OnRefresh( kv )
	
end

function modifier_demon_teleport:OnRemoved()

end
function modifier_demon_teleport:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_demon_teleport:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_demon_teleport:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
	local spawnPoint2 = Vector( -6297.45, 2040.75, -1620 )
		
	local origin = self.tp_origin
	local origin2 = origin
self:PlayEffects()
	end
	end
	end

	

function modifier_demon_teleport:PlayEffects()
if IsServer() then
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	FindClearSpaceForUnit( enemy, _G.DemonTp, true )
	enemy:AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_tp_invul", -- modifier name
		{ duration = 3 } -- kv
	)
	PlayerResource:SetCameraTarget( enemy:GetPlayerID(), enemy )
	Timers:CreateTimer(0.1, function()
    PlayerResource:SetCameraTarget(enemy:GetPlayerOwnerID(), nil)
  end)
	end
	end
end

elf_teleport = class({})
LinkLuaModifier( "modifier_elf_teleport", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tp_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function elf_teleport:GetIntrinsicModifierName()
	return "modifier_elf_teleport"
end
modifier_elf_teleport = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_elf_teleport:IsHidden()
	return true
end

function modifier_elf_teleport:IsDebuff()
	return false
end

function modifier_elf_teleport:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_elf_teleport:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( 1.0 )
	self:OnIntervalThink()
	end
	end


function modifier_elf_teleport:OnRefresh( kv )
	
end

function modifier_elf_teleport:OnRemoved()

end
function modifier_elf_teleport:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_elf_teleport:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_elf_teleport:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	

	local spawnPoint2 = _G.elfTp
	

	local origin2 = _G.elfTp
self:PlayEffects(origin2)
	end
	
end
end
	

function modifier_elf_teleport:PlayEffects(origin2)
if IsServer() then
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	FindClearSpaceForUnit( enemy, origin2, true )
		enemy:AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_tp_invul", -- modifier name
		{ duration = 3 } -- kv
	)
	PlayerResource:SetCameraTarget( enemy:GetPlayerID(), enemy )
	Timers:CreateTimer(0.1, function()
    PlayerResource:SetCameraTarget(enemy:GetPlayerOwnerID(), nil)
  end)
	end
	end
end

necro_teleport = class({})
LinkLuaModifier( "modifier_necro_teleport", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tp_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function necro_teleport:GetIntrinsicModifierName()
	return "modifier_necro_teleport"
end
modifier_necro_teleport = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_necro_teleport:IsHidden()
	return true
end

function modifier_necro_teleport:IsDebuff()
	return false
end

function modifier_necro_teleport:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_necro_teleport:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( 1.0 )
	self:OnIntervalThink()
	end
	end
	


function modifier_necro_teleport:OnRefresh( kv )
	
end

function modifier_necro_teleport:OnRemoved()

end
function modifier_necro_teleport:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_necro_teleport:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_necro_teleport:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
	local spawnPoint2 = _G.necroTp
		
	local origin2 = _G.necroTp
self:PlayEffects(origin2)
	end
	end
	end

	

function modifier_necro_teleport:PlayEffects(origin2)
if IsServer() then
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	FindClearSpaceForUnit( enemy, origin2, true )
			enemy:AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_tp_invul", -- modifier name
		{ duration = 3 } -- kv
	)
	PlayerResource:SetCameraTarget( enemy:GetPlayerID(), enemy )
	Timers:CreateTimer(0.1, function()
    PlayerResource:SetCameraTarget(enemy:GetPlayerOwnerID(), nil)
  end)
	end
	end
end


control_point_instrinct = class({})
LinkLuaModifier( "modifier_point_captured", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

function control_point_instrinct:GetIntrinsicModifierName()
	return "modifier_point_captured"
end
----------------------------------------------


asb_control_point = class({})
LinkLuaModifier( "modifier_asb_control_point", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elven_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_human_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_necro_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_point_captured", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_captured_once_current", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence_mp_regen", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function asb_control_point:GetIntrinsicModifierName()
	return "modifier_asb_control_point"
end
modifier_asb_control_point = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_asb_control_point:IsHidden()
	return true
end

function modifier_asb_control_point:IsDebuff()
	return false
end

function modifier_asb_control_point:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_asb_control_point:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( 0.9 )
	self:OnIntervalThink()
	end
	end
	


function modifier_asb_control_point:OnRefresh( kv )
	
end

function modifier_asb_control_point:OnRemoved()

end
function modifier_asb_control_point:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_asb_control_point:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_asb_control_point:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
local origin = self:GetParent():GetOrigin()
self:PlayEffects(origin)
	end
	end
	end
	

	

function modifier_asb_control_point:PlayEffects(origin)
if IsServer() then
if self:GetParent():HasModifier("modifier_captured_once_current") then return end
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if not enemy:HasModifier("modifier_duel_chrono_effect") then
	local team = enemy:GetTeamNumber()
	if not enemy:IsIllusion() then
	if team == self:GetParent():GetTeamNumber() then
	self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_ally_defence", -- modifier name
		{ duration = 10 } -- kv
	)
	else
	local jj = GameRules:GetGameTime()
if jj > 300 and _G.ControlStop == 0 then
	if team == DOTA_TEAM_GOODGUYS then
	self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_human_capture", -- modifier name
		{ duration = 10 } -- kv
	)
    
	
	elseif team  == DOTA_TEAM_BADGUYS then
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_demon_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	elseif team == DOTA_TEAM_CUSTOM_1 then
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_elven_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	else
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_necro_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	end
	
	end
	end
	end
	end
	end
end
end
	



modifier_human_capture = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_human_capture:IsHidden()
	return false
end

function modifier_human_capture:IsDebuff()
	return true
end

function modifier_human_capture:IsStunDebuff()
	return false
end

function modifier_human_capture:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_human_capture:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(1)

	local iPlayerID = self:GetCaster():GetTeamNumber()
	local iPlayerID2 = self:GetParent():GetTeamNumber()
	      local hNotificationTable1 = {   
                                        text       = "Control Point Capture Started!",
                                        style   =   {
                                                        color         = "#008000",
                                                        ["font-size"] = "24px",
                                                        
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									  local hNotificationTable2 = {   
                                        text       = "Your Control Point is in DANGER!!!",
                                        style   =   {
                                                        color         = "#FF0000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
	Notifications:TopToTeam(iPlayerID, hNotificationTable1)
	Notifications:TopToTeam(iPlayerID2, hNotificationTable2)
	self:StartIntervalThink(3)
	end
end

function modifier_human_capture:OnRefresh( kv )
if IsServer() then
self.ally = false
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		3000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	self.ally = true
	end
if self:GetParent():HasModifier("modifier_captured_once_current") then return end
local iPlayerID = self:GetCaster():GetTeamNumber()
local stack = self:GetStackCount()
local max_stack = 35
local origin = self:GetParent():GetOrigin()

if IsServer() then
if self:GetStackCount()>max_stack or self:GetStackCount() == max_stack then
if self:GetParent():HasModifier("modifier_point_captured") then
self:GetParent():RemoveModifierByName("modifier_point_captured")
end
if self:GetParent():HasModifier("modifier_human_capture") then
self:GetParent():RemoveModifierByName("modifier_human_capture")
end
if self:GetParent():HasModifier("modifier_demon_capture") then
self:GetParent():RemoveModifierByName("modifier_demon_capture")
end
if self:GetParent():HasModifier("modifier_elven_capture") then
self:GetParent():RemoveModifierByName("modifier_elven_capture")
end
if self:GetParent():HasModifier("modifier_necro_capture") then
self:GetParent():RemoveModifierByName("modifier_necro_capture")
end
local casterid = self:GetCaster():GetPlayerID()
local team = PlayerResource:GetTeam(casterid)
self:GetParent():SetTeam(team)
self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_point_captured", {})
self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_captured_once_current", {duration = 60})
self:Destroy()
		else
		
		self:IncrementStackCount()
		if self.ally == false then
		local stk = self:GetStackCount()
		self:SetStackCount(stk + 1)
		end
		end
	end
end
end
function modifier_human_capture:DeclareFunctions()
	local func = {	
					

					MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

				
					}
	return func
end

function modifier_human_capture:OnStackCountChanged(iStackCount)
	if IsServer() then
		self.parent = self:GetParent()

		

		local stacks = self:GetStackCount()
self:PlayEffects(self:GetParent(),stacks,self:GetCaster():GetTeamNumber())
	
        end
	end
	function modifier_human_capture:PlayEffects( caster, counter, team )
if team == DOTA_TEAM_GOODGUYS then
self.particle_cast = "particles/test_capture_circle_1.vpcf"
elseif team == DOTA_TEAM_BADGUYS then
self.particle_cast = "particles/test_capture_circle_2.vpcf"
elseif team == DOTA_TEAM_CUSTOM_1 then
self.particle_cast = "particles/test_capture_circle_3.vpcf"
else
self.particle_cast = "particles/test_capture_circle_4.vpcf"
end
	local decrease =  counter * 6

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( self.particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 0, decrease, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle


	-- save index for later

end
function modifier_human_capture:OnIntervalThink( kv )
if IsServer() then
local stack = self:GetStackCount()
local iPlayerID = self:GetCaster():GetTeamNumber()
local iPlayerID2 = self:GetParent():GetTeamNumber()
local name = "Control Point Capture Progress:"..stack.." of 35"
local name2 = "Your Control Point Is Being Captured:"..stack.." of 35"
	      local hNotificationTable1 = {   
                                        text       = name,
                                        style   =   {
                                                        color         = "#008000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
	
	      local hNotificationTable2 = {   
                                        text       = name2,
                                        style   =   {
                                                        color         = "#FF0000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									Notifications:TopToTeam(iPlayerID, hNotificationTable1)
									Notifications:TopToTeam(iPlayerID2, hNotificationTable2)

end
end


function modifier_human_capture:GetEffectName()
	return "particles/asb_capture.vpcf"
end

function modifier_human_capture:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_human_capture:OnDestroy( kv )
	                          if self.Charge_FX2 then
			ParticleManager:DestroyParticle(self.Charge_FX2, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX2)
		end

		if self.Charge_FX3 then
			ParticleManager:DestroyParticle(self.Charge_FX3, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX3)
		end
		                          if self.Charge_FX4 then
			ParticleManager:DestroyParticle(self.Charge_FX4, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX4)
		end

		if self.Charge_FX5 then
			ParticleManager:DestroyParticle(self.Charge_FX5, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX5)
		end
	            if self.Charge_FX6 then
			ParticleManager:DestroyParticle(self.Charge_FX, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX)
		end          
		  if self.Charge_FX6 then
			ParticleManager:DestroyParticle(self.Charge_FX6, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX6)
		end         
end

modifier_demon_capture = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_demon_capture:IsHidden()
	return false
end

function modifier_demon_capture:IsDebuff()
	return true
end

function modifier_demon_capture:IsStunDebuff()
	return false
end

function modifier_demon_capture:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_demon_capture:OnCreated( kv )
if IsServer() then
		self:SetStackCount(1)
		local iPlayerID = self:GetCaster():GetTeamNumber()
	local iPlayerID2 = self:GetParent():GetTeamNumber()
	      local hNotificationTable1 = {   
                                        text       = "Control Point Capture Started!",
                                        style   =   {
                                                        color         = "#008000",
                                                        ["font-size"] = "24px",
                                                        
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									  local hNotificationTable2 = {   
                                        text       = "Your Control Point is in DANGER!!!",
                                        style   =   {
                                                        color         = "#FF0000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
	Notifications:TopToTeam(iPlayerID, hNotificationTable1)
	Notifications:TopToTeam(iPlayerID2, hNotificationTable2)
	self:StartIntervalThink(3)
end
end
function modifier_demon_capture:DeclareFunctions()
	local func = {	
					

					MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

				
					}
	return func
end

function modifier_demon_capture:OnStackCountChanged(iStackCount)
	if IsServer() then
		self.parent = self:GetParent()

		

		local stacks = self:GetStackCount()
self:PlayEffects(self:GetParent(),stacks,self:GetCaster():GetTeamNumber())
	
        end
	end
	function modifier_demon_capture:PlayEffects( caster, counter, team )
if team == DOTA_TEAM_GOODGUYS then
self.particle_cast = "particles/test_capture_circle_1.vpcf"
elseif team == DOTA_TEAM_BADGUYS then
self.particle_cast = "particles/test_capture_circle_2.vpcf"
elseif team == DOTA_TEAM_CUSTOM_1 then
self.particle_cast = "particles/test_capture_circle_3.vpcf"
else
self.particle_cast = "particles/test_capture_circle_4.vpcf"
end
	local decrease =  counter * 6

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( self.particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 0, decrease, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle


	-- save index for later

end
function modifier_demon_capture:OnRefresh( kv )
if IsServer() then
if self:GetParent():HasModifier("modifier_captured_once_current") then return end
local iPlayerID = self:GetCaster():GetTeamNumber()
local stack = self:GetStackCount()
local max_stack = 35
local origin = self:GetParent():GetOrigin()
self.ally = false
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		3000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	self.ally = true
	end
if IsServer() then
if self:GetStackCount()>max_stack or self:GetStackCount() == max_stack then
if self:GetParent():HasModifier("modifier_point_captured") then
self:GetParent():RemoveModifierByName("modifier_point_captured")
end
if self:GetParent():HasModifier("modifier_human_capture") then
self:GetParent():RemoveModifierByName("modifier_human_capture")
end
if self:GetParent():HasModifier("modifier_demon_capture") then
self:GetParent():RemoveModifierByName("modifier_demon_capture")
end
if self:GetParent():HasModifier("modifier_elven_capture") then
self:GetParent():RemoveModifierByName("modifier_elven_capture")
end
if self:GetParent():HasModifier("modifier_necro_capture") then
self:GetParent():RemoveModifierByName("modifier_necro_capture")
end
local casterid = self:GetCaster():GetPlayerID()
local team = PlayerResource:GetTeam(casterid)
self:GetParent():SetTeam(team)
self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_point_captured", {})
self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_captured_once_current", {duration = 60})
self:Destroy()
		else
		self:IncrementStackCount()
		
	if self.ally == false then
		local stk = self:GetStackCount()
		self:SetStackCount(stk + 1)
		end
		end
	end
end
end

function modifier_demon_capture:OnIntervalThink( kv )
if IsServer() then
local stack = self:GetStackCount()
local iPlayerID = self:GetCaster():GetTeamNumber()
local iPlayerID2 = self:GetParent():GetTeamNumber()
local name = "Control Point Capture Progress:"..stack.." of 35"
local name2 = "Your Control Point Is Being Captured:"..stack.." of 35"
	      local hNotificationTable1 = {   
                                        text       = name,
                                        style   =   {
                                                        color         = "#008000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									
	      local hNotificationTable2 = {   
                                        text       = name2,
                                        style   =   {
                                                        color         = "#FF0000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									Notifications:TopToTeam(iPlayerID, hNotificationTable1)
									Notifications:TopToTeam(iPlayerID2, hNotificationTable2)

end
end

function modifier_demon_capture:GetEffectName()
	return "particles/asb_capture.vpcf"
end

function modifier_demon_capture:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

modifier_elven_capture = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_elven_capture:IsHidden()
	return false
end

function modifier_elven_capture:IsDebuff()
	return true
end

function modifier_elven_capture:IsStunDebuff()
	return false
end

function modifier_elven_capture:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_elven_capture:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(1)
	
	local iPlayerID = self:GetCaster():GetTeamNumber()
	local iPlayerID2 = self:GetParent():GetTeamNumber()
	      local hNotificationTable1 = {   
                                        text       = "Control Point Capture Started!",
                                        style   =   {
                                                        color         = "#008000",
                                                        ["font-size"] = "24px",
                                                        
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									  local hNotificationTable2 = {   
                                        text       = "Your Control Point is in DANGER!!!",
                                        style   =   {
                                                        color         = "#FF0000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
	Notifications:TopToTeam(iPlayerID, hNotificationTable1)
	Notifications:TopToTeam(iPlayerID2, hNotificationTable2)
	self:StartIntervalThink(3)
end
end
function modifier_elven_capture:DeclareFunctions()
	local func = {	
					

					MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

				
					}
	return func
end
function modifier_elven_capture:OnStackCountChanged(iStackCount)
	if IsServer() then
		self.parent = self:GetParent()

		

		local stacks = self:GetStackCount()
self:PlayEffects(self:GetParent(),stacks,self:GetCaster():GetTeamNumber())
	
        end
	end
	function modifier_elven_capture:PlayEffects( caster, counter, team )
if team == DOTA_TEAM_GOODGUYS then
self.particle_cast = "particles/test_capture_circle_1.vpcf"
elseif team == DOTA_TEAM_BADGUYS then
self.particle_cast = "particles/test_capture_circle_2.vpcf"
elseif team == DOTA_TEAM_CUSTOM_1 then
self.particle_cast = "particles/test_capture_circle_3.vpcf"
else
self.particle_cast = "particles/test_capture_circle_4.vpcf"
end
	local decrease =  counter * 6

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( self.particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 0, decrease, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle


	-- save index for later

end

function modifier_elven_capture:OnRefresh( kv )
if IsServer() then

self.ally = false
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		3000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	self.ally = true
	end
if self:GetParent():HasModifier("modifier_captured_once_current") then return end
local iPlayerID = self:GetCaster():GetTeamNumber()
local stack = self:GetStackCount()
local max_stack = 35
local origin = self:GetParent():GetOrigin()

if IsServer() then
if self:GetStackCount()>max_stack or self:GetStackCount() == max_stack then
if self:GetParent():HasModifier("modifier_point_captured") then
self:GetParent():RemoveModifierByName("modifier_point_captured")
end
if self:GetParent():HasModifier("modifier_human_capture") then
self:GetParent():RemoveModifierByName("modifier_human_capture")
end
if self:GetParent():HasModifier("modifier_demon_capture") then
self:GetParent():RemoveModifierByName("modifier_demon_capture")
end
if self:GetParent():HasModifier("modifier_elven_capture") then
self:GetParent():RemoveModifierByName("modifier_elven_capture")
end
if self:GetParent():HasModifier("modifier_necro_capture") then
self:GetParent():RemoveModifierByName("modifier_necro_capture")
end
local casterid = self:GetCaster():GetPlayerID()
local team = PlayerResource:GetTeam(casterid)
self:GetParent():SetTeam(team)
self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_point_captured", {})
self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_captured_once_current", {duration = 60})
self:Destroy()
		else
			if self.ally == false then
		local stk = self:GetStackCount()
		self:SetStackCount(stk + 1)
		end
		self:IncrementStackCount()
		end
	end
end
end
function modifier_elven_capture:OnIntervalThink( kv )
if IsServer() then
local stack = self:GetStackCount()
local iPlayerID = self:GetCaster():GetTeamNumber()
local iPlayerID2 = self:GetParent():GetTeamNumber()
local name = "Control Point Capture Progress:"..stack.." of 35"
local name2 = "Your Control Point Is Being Captured:"..stack.." of 35"
	      local hNotificationTable1 = {   
                                        text       = name,
                                        style   =   {
                                                        color         = "#008000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									
	      local hNotificationTable2 = {   
                                        text       = name2,
                                        style   =   {
                                                        color         = "#FF0000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									Notifications:TopToTeam(iPlayerID, hNotificationTable1)
									Notifications:TopToTeam(iPlayerID2, hNotificationTable2)

end
end

function modifier_elven_capture:GetEffectName()
	return "particles/asb_capture.vpcf"
end

function modifier_elven_capture:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

modifier_necro_capture = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_necro_capture:IsHidden()
	return false
end

function modifier_necro_capture:IsDebuff()
	return true
end

function modifier_necro_capture:IsStunDebuff()
	return false
end

function modifier_necro_capture:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_necro_capture:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(1)

	local iPlayerID = self:GetCaster():GetTeamNumber()
	local iPlayerID2 = self:GetParent():GetTeamNumber()
	      local hNotificationTable1 = {   
                                        text       = "Control Point Capture Started!",
                                        style   =   {
                                                        color         = "#008000",
                                                        ["font-size"] = "24px",
                                                        
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									  local hNotificationTable2 = {   
                                        text       = "Your Control Point is in DANGER!!!",
                                        style   =   {
                                                        color         = "#FF0000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
	Notifications:TopToTeam(iPlayerID, hNotificationTable1)
	Notifications:TopToTeam(iPlayerID2, hNotificationTable2)
	self:StartIntervalThink(3)
end
end

function modifier_necro_capture:OnRefresh( kv )
if IsServer() then
self.ally = false
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		3000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	self.ally = true
	end
if self:GetParent():HasModifier("modifier_captured_once_current") then return end
local iPlayerID = self:GetCaster():GetTeamNumber()
local stack = self:GetStackCount()
local max_stack = 35
local origin = self:GetParent():GetOrigin()

if IsServer() then
if self:GetStackCount()>max_stack or self:GetStackCount() == max_stack then
if self:GetParent():HasModifier("modifier_point_captured") then
self:GetParent():RemoveModifierByName("modifier_point_captured")
end
if self:GetParent():HasModifier("modifier_human_capture") then
self:GetParent():RemoveModifierByName("modifier_human_capture")
end
if self:GetParent():HasModifier("modifier_demon_capture") then
self:GetParent():RemoveModifierByName("modifier_demon_capture")
end
if self:GetParent():HasModifier("modifier_elven_capture") then
self:GetParent():RemoveModifierByName("modifier_elven_capture")
end
if self:GetParent():HasModifier("modifier_necro_capture") then
self:GetParent():RemoveModifierByName("modifier_necro_capture")
end
local casterid = self:GetCaster():GetPlayerID()
local team = PlayerResource:GetTeam(casterid)
self:GetParent():SetTeam(team)
self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_point_captured", {})
self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_captured_once_current", {duration = 60})
self:Destroy()
		else
			if self.ally == false then
		local stk = self:GetStackCount()
		self:SetStackCount(stk + 1)
		end
		self:IncrementStackCount()
		end
	end
end
end
function modifier_necro_capture:DeclareFunctions()
	local func = {	
					

					MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

				
					}
	return func
end

function modifier_necro_capture:OnStackCountChanged(iStackCount)
	if IsServer() then
		self.parent = self:GetParent()

		

		local stacks = self:GetStackCount()
self:PlayEffects(self:GetParent(),stacks,self:GetCaster():GetTeamNumber())
	
        end
	end
	function modifier_necro_capture:PlayEffects( caster, counter, team )
if team == DOTA_TEAM_GOODGUYS then
self.particle_cast = "particles/test_capture_circle_1.vpcf"
elseif team == DOTA_TEAM_BADGUYS then
self.particle_cast = "particles/test_capture_circle_2.vpcf"
elseif team == DOTA_TEAM_CUSTOM_1 then
self.particle_cast = "particles/test_capture_circle_3.vpcf"
else
self.particle_cast = "particles/test_capture_circle_4.vpcf"
end
	local decrease =  counter * 6

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( self.particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 0, decrease, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle


	-- save index for later

end
function modifier_necro_capture:OnIntervalThink( kv )
if IsServer() then
local stack = self:GetStackCount()
local iPlayerID = self:GetCaster():GetTeamNumber()
local iPlayerID2 = self:GetParent():GetTeamNumber()
local name = "Control Point Capture Progress:"..stack.." of 35"
local name2 = "Your Control Point Is Being Captured:"..stack.." of 35"
	      local hNotificationTable1 = {   
                                        text       = name,
                                        style   =   {
                                                        color         = "#008000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									
	      local hNotificationTable2 = {   
                                        text       = name2,
                                        style   =   {
                                                        color         = "#FF0000",
                                                        ["font-size"] = "24px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 2.0,
                                    }
									Notifications:TopToTeam(iPlayerID, hNotificationTable1)
									Notifications:TopToTeam(iPlayerID2, hNotificationTable2)

end

end
function modifier_necro_capture:GetEffectName()
	return "particles/asb_capture.vpcf"
end

function modifier_necro_capture:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


modifier_ally_defence = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ally_defence:IsHidden()
	return false
end

function modifier_ally_defence:IsDebuff()
	return true
end

function modifier_ally_defence:IsStunDebuff()
	return false
end

function modifier_ally_defence:IsPurgable()
	return false
end
function modifier_ally_defence:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_ally_defence:GetModifierAura()
	return "modifier_ally_defence_mp_regen"
end

--------------------------------------------------------------------------------

function modifier_ally_defence:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_ally_defence:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--function modifier_vengefulspirit_command_aura_lua:GetAuraSearchFlags()
--	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
--end

--------------------------------------------------------------------------------

function modifier_ally_defence:GetAuraRadius()
	return 400
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ally_defence:OnCreated( kv )
if IsServer() then
self.parent = self:GetParent()
end
end

function modifier_ally_defence:OnRefresh( kv )
if IsServer() then

	if self:GetParent():HasModifier("modifier_human_capture") then
	local modifier = self.parent:FindModifierByName("modifier_human_capture")
	if modifier then
	local current = modifier:GetStackCount()
	modifier:SetStackCount(current - 1)
	end
	end
	
		if self:GetParent():HasModifier("modifier_demon_capture") then
	local modifier2 = self.parent:FindModifierByName("modifier_demon_capture")
	if modifier2 then
	local current2 = modifier2:GetStackCount()
	modifier2:SetStackCount(current2 - 1)
	end
	end
	
	
	if self:GetParent():HasModifier("modifier_elven_capture") then
	local modifier3 = self.parent:FindModifierByName("modifier_elven_capture")
	if modifier3 then
	local current3 = modifier3:GetStackCount()
	modifier3:SetStackCount(current3 - 1)
	end
	end
	
	if self:GetParent():HasModifier("modifier_necro_capture") then
	local modifier4 = self.parent:FindModifierByName("modifier_necro_capture")
	if modifier4 then
	local current4 = modifier4:GetStackCount()
	modifier4:SetStackCount(current4 - 1)
	end
	end
	
	end
end
modifier_ally_defence_mp_regen = class({})

--------------------------------------------------------------------------------

function modifier_ally_defence_mp_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,

	}
	return funcs
end


function modifier_ally_defence_mp_regen:GetModifierHealthRegenPercentage( params )
	return 1
end


function modifier_ally_defence_mp_regen:GetModifierTotalPercentageManaRegen( params )
	return 2.5
end


modifier_point_captured = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_point_captured:IsHidden()
	return false
end

function modifier_point_captured:IsDebuff()
	return false
end

function modifier_point_captured:IsStunDebuff()
	return false
end

function modifier_point_captured:IsPurgable()
	return false
end
function modifier_point_captured:OnCreated()
if IsServer() then
self:PlayEffects()
	self:StartIntervalThink(20)
	end
end
function modifier_point_captured:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
					 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       
        
		
    }

    return funcs
end

function modifier_point_captured:GetBonusNightVision()
    return -2000
end
function modifier_point_captured:GetBonusDayVision()

    return -2000

end
function modifier_point_captured:OnIntervalThink()
if IsServer() then
	local jj = GameRules:GetGameTime()
	if _G.ControlStop == 0 then
	if jj > 600  then
	if _G.DuelTimerCheck == 0 then
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	COverthrowGameMode:IncreaseGamePointsForPlayer(enemy:GetPlayerID(),3,enemy)
	break
	end
	end
	end
	end
end
end
function modifier_point_captured:PlayEffects()
	-- Load effects
	if IsServer() then
	local particle_cast = "particles/point_captured.vpcf"

	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
end

modifier_captured_once = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_captured_once:IsHidden()
	return false
end

function modifier_captured_once:IsDebuff()
	return false
end

function modifier_captured_once:IsStunDebuff()
	return false
end

function modifier_captured_once:IsPurgable()
	return false
end

function modifier_captured_once:GetEffectName()
	return "particles/generic_overhead_shield.vpcf"
end

function modifier_captured_once:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


modifier_captured_once_current = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_captured_once_current:IsHidden()
	return false
end

function modifier_captured_once_current:IsDebuff()
	return false
end

function modifier_captured_once_current:IsStunDebuff()
	return false
end

function modifier_captured_once_current:IsPurgable()
	return false
end

function modifier_captured_once_current:GetEffectName()
	return "particles/generic_overhead_shield.vpcf"
end

function modifier_captured_once_current:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

asb_control_point_2 = class({})
LinkLuaModifier( "modifier_asb_control_point_2", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elven_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_human_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_necro_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_point_captured", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_captured_once_current", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence_mp_regen", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

function asb_control_point_2:GetIntrinsicModifierName()
	return "modifier_asb_control_point_2"
end
modifier_asb_control_point_2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_asb_control_point_2:IsHidden()
	return true
end

function modifier_asb_control_point_2:IsDebuff()
	return false
end

function modifier_asb_control_point_2:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_asb_control_point_2:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( 1.0 )
	self:OnIntervalThink()
	end
	end
	


function modifier_asb_control_point_2:OnRefresh( kv )
	
end

function modifier_asb_control_point_2:OnRemoved()

end
function modifier_asb_control_point_2:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_asb_control_point_2:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_asb_control_point_2:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
local origin = self:GetParent():GetOrigin()
self:PlayEffects(origin)
	end
	end
	end
	

	

function modifier_asb_control_point_2:PlayEffects(origin)
if IsServer() then
if self:GetParent():HasModifier("modifier_captured_once_current") then return end
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if not enemy:IsIllusion() then
	if not enemy:HasModifier("modifier_duel_chrono_effect") then
	local team = enemy:GetTeamNumber()
	if team == self:GetParent():GetTeamNumber() then
	self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_ally_defence", -- modifier name
		{ duration = 10 } -- kv
	)
	else
	local jj = GameRules:GetGameTime()
if jj > 300 and _G.ControlStop == 0 then
	if team == DOTA_TEAM_GOODGUYS then
	self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_human_capture", -- modifier name
		{ duration = 10 } -- kv
	)
    
	
	elseif team  == DOTA_TEAM_BADGUYS then
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_demon_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	elseif team == DOTA_TEAM_CUSTOM_1 then
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_elven_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	else
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_necro_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	end
	
	end
	end
	end
	end
	end
end
end

asb_control_point_3 = class({})
LinkLuaModifier( "modifier_asb_control_point_3", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elven_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_human_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_necro_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_point_captured", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_captured_once_current", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence_mp_regen", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

function asb_control_point_3:GetIntrinsicModifierName()
	return "modifier_asb_control_point_3"
end
modifier_asb_control_point_3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_asb_control_point_3:IsHidden()
	return true
end

function modifier_asb_control_point_3:IsDebuff()
	return false
end

function modifier_asb_control_point_3:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_asb_control_point_3:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
		local delay = 200
	self:StartIntervalThink( 0.9 )
	self:OnIntervalThink()
	end
	end
	


function modifier_asb_control_point_3:OnRefresh( kv )
	
end

function modifier_asb_control_point_3:OnRemoved()

end
function modifier_asb_control_point_3:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_asb_control_point_3:OnDestroy()
if IsServer() then
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_asb_control_point_3:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
local origin = self:GetParent():GetOrigin()
self:PlayEffects(origin)
	end
	end
	end
	

	

function modifier_asb_control_point_3:PlayEffects(origin)
if IsServer() then
if self:GetParent():HasModifier("modifier_captured_once_current") then return end
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if not enemy:IsIllusion() then
	if not enemy:HasModifier("modifier_duel_chrono_effect") then
	local team = enemy:GetTeamNumber()
	if team == self:GetParent():GetTeamNumber() then
	self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_ally_defence", -- modifier name
		{ duration = 10 } -- kv
	)
	else
		local jj = GameRules:GetGameTime()
if jj > 300 and _G.ControlStop == 0 then
	if team == DOTA_TEAM_GOODGUYS then
	self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_human_capture", -- modifier name
		{ duration = 10 } -- kv
	)
    
	
	elseif team  == DOTA_TEAM_BADGUYS then
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_demon_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	elseif team == DOTA_TEAM_CUSTOM_1 then
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_elven_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	else
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_necro_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	end
	
	end
	end
	end
	end
end
end
	end
	
	
	
	asb_control_point_4 = class({})
LinkLuaModifier( "modifier_asb_control_point_4", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elven_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_human_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_necro_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_point_captured", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_captured_once_current", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence_mp_regen", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

function asb_control_point_4:GetIntrinsicModifierName()
	return "modifier_asb_control_point_4"
end
modifier_asb_control_point_4 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_asb_control_point_4:IsHidden()
	return true
end

function modifier_asb_control_point_4:IsDebuff()
	return false
end

function modifier_asb_control_point_4:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_asb_control_point_4:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
		
	
	self:StartIntervalThink( 0.9 )
	self:OnIntervalThink()
	end
	end
	


function modifier_asb_control_point_4:OnRefresh( kv )
	
end

function modifier_asb_control_point_4:OnRemoved()

end
function modifier_asb_control_point_4:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_asb_control_point_4:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_asb_control_point_4:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	


	local origin = self:GetParent():GetOrigin()
self:PlayEffects(origin)
	end
	end
	end
	

	

function modifier_asb_control_point_4:PlayEffects(origin)
if IsServer() then
if self:GetParent():HasModifier("modifier_captured_once_current") then return end
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if not enemy:IsIllusion() then
	if not enemy:HasModifier("modifier_duel_chrono_effect") then
	if not enemy:IsIllusion() then
	local team = enemy:GetTeamNumber()
	if team == self:GetParent():GetTeamNumber() then
	self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_ally_defence", -- modifier name
		{ duration = 10 } -- kv
	)
	else
		local jj = GameRules:GetGameTime()
if jj > 300 and _G.ControlStop == 0 then
	if team == DOTA_TEAM_GOODGUYS then
	self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_human_capture", -- modifier name
		{ duration = 10 } -- kv
	)
    
	
	elseif team  == DOTA_TEAM_BADGUYS then
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_demon_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	elseif team == DOTA_TEAM_CUSTOM_1 then
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_elven_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	else
		self:GetParent():AddNewModifier(
		enemy, -- player source
		self:GetAbility(), -- ability source
		"modifier_necro_capture", -- modifier name
		{ duration = 10 } -- kv
	)
	end
	
	end
	end
	end
end
end
	end
	end
	end
	
	asb_magic_immune = class({})
LinkLuaModifier( "modifier_asb_magic_immune", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function asb_magic_immune:GetIntrinsicModifierName()
	return "modifier_asb_magic_immune"
end
modifier_asb_magic_immune = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_asb_magic_immune:IsHidden()
	return true
end

function modifier_asb_magic_immune:IsDebuff()
	return false
end

function modifier_asb_magic_immune:IsPurgable()
	return false
end
function modifier_asb_magic_immune:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_asb_magic_immune:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
end
	end
	


function modifier_asb_magic_immune:OnRefresh( kv )
	
end

function modifier_asb_magic_immune:OnRemoved()

end
function modifier_asb_magic_immune:CheckState()
	local state = {	[MODIFIER_STATE_MAGIC_IMMUNE] = true,}
	return state
end

-------------------------------------------------








anti_sanya_system = class({})
LinkLuaModifier( "modifier_anti_sanya_system", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function anti_sanya_system:GetIntrinsicModifierName()
	return "modifier_anti_sanya_system"
end
modifier_anti_sanya_system = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_anti_sanya_system:IsHidden()
	return true
end

function modifier_anti_sanya_system:IsDebuff()
	return false
end

function modifier_anti_sanya_system:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_anti_sanya_system:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( FrameTime() )
	self:OnIntervalThink()
	end
	end
	


function modifier_anti_sanya_system:OnRefresh( kv )
	
end

function modifier_anti_sanya_system:OnRemoved()

end
function modifier_anti_sanya_system:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end



function modifier_anti_sanya_system:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
local origin = self:GetParent():GetOrigin()
self.center = self:GetParent():GetAbsOrigin()
local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1800,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_base_spawn") or enemy:HasModifier("modifier_lunatic_nightmare_location") or enemy:IsIllusion() then
	else
	  local direction = (enemy:GetAbsOrigin() - self.center):Normalized()
	  local distance = (self.center - enemy:GetAbsOrigin()):Length2D()
            self.old_pos = self.center + direction * 4000

            enemy:SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(enemy, self.old_pos, true)
	
	end
	end
	end
	
	end
	end
	
	
	
	
	
	
	
	
	
	
	modifier_tp_invul = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tp_invul:IsHidden()
	return false
end

function modifier_tp_invul:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_tp_invul:IsStunDebuff()
	return true
end

function modifier_tp_invul:IsPurgable()
	return true
end

function modifier_tp_invul:RemoveOnDeath()
	return false
end
function modifier_tp_invul:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end


function modifier_tp_invul:GetModifierMoveSpeed_AbsoluteMin()
local minute = GameRules:GetGameTime()
if minute > 600 then
	 return 600 
	 else
	 return 
	 end
	 end
function modifier_tp_invul:CheckState()
	local state = {

		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

function modifier_tp_invul:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf"
end











-------------------------------
creep_gold_exp = class({})
LinkLuaModifier( "modifier_creep_gold_exp", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

function creep_gold_exp:GetIntrinsicModifierName()
	return "modifier_creep_gold_exp"
end

modifier_creep_gold_exp = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creep_gold_exp:IsHidden()
	return false
end

function modifier_creep_gold_exp:IsDebuff()
	return false
end

function modifier_creep_gold_exp:IsStunDebuff()
	return true
end

function modifier_creep_gold_exp:IsPurgable()
	return true
end

function modifier_creep_gold_exp:RemoveOnDeath()
	return false
end
function modifier_creep_gold_exp:OnCreated()
if IsServer() then
local hp = self:GetParent():GetMaxHealth()
local gold = self:GetParent():GetGoldBounty()
local damage_min = self:GetParent():GetBaseDamageMin()
local damage_max = self:GetParent():GetBaseDamageMax()
local exp_reward = self:GetParent():GetDeathXP()
local as = self:GetParent():GetAttackSpeed()
local jj = GameRules:GetGameTime()
if jj > 1080 then
self.gold = gold + 100
self.hp = hp + 500
self.damage_max = damage_max + 60
self.damage_min = damage_min + 60
self.exp = exp_reward + 150
self.as = as + 30
else
local increase_hp = 37
local increase_damage = 5
local increase_gold = 9
local increase_exp = 12
local increase_as = 3
self.hp = hp + (increase_hp * (jj * 0.01))
self.gold = gold + (increase_gold * (jj * 0.01))
self.damage_max = damage_max + (increase_damage * (jj * 0.01))
self.damage_min = damage_min + (increase_damage * (jj * 0.01))
self.exp = exp_reward + (increase_exp * (jj * 0.01))
self.as = as + (increase_as * (jj * 0.01))
end
			self:GetParent():SetBaseMaxHealth(self.hp)
			self:GetParent():SetHealth(self.hp)
			self:GetParent():SetMinimumGoldBounty(self.gold - 10 )
			self:GetParent():SetMaximumGoldBounty(self.gold)	
            self:GetParent():SetBaseDamageMax(self.damage_max)
            self:GetParent():SetBaseDamageMin(self.damage_min)
            self:GetParent():SetDeathXP(self.exp)
           -- self:GetParent():SetMaximumAttackSpeed(self.as)
            --self:GetParent():SetMinimumAttackSpeed(self.as)			
end

end

function modifier_creep_gold_exp:DeclareFunctions()
    local func = {  
    				
                    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,	
				}
    return func
end

function modifier_creep_gold_exp:GetModifierIncomingDamage_Percentage( params )
if self:GetParent():IsNeutralUnitType() then
	if  params.attacker:HasModifier("modifier_rat_contract_effect")  then
    
		return -60
		else 
		
		return 0
		end
	end
end	


creep_gold_exp_tier2 = class({})
LinkLuaModifier( "modifier_creep_gold_exp_tier2", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

function creep_gold_exp_tier2:GetIntrinsicModifierName()
	return "modifier_creep_gold_exp_tier2"
end

modifier_creep_gold_exp_tier2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creep_gold_exp_tier2:IsHidden()
	return false
end

function modifier_creep_gold_exp_tier2:IsDebuff()
	return false
end

function modifier_creep_gold_exp_tier2:IsStunDebuff()
	return true
end

function modifier_creep_gold_exp_tier2:IsPurgable()
	return true
end

function modifier_creep_gold_exp_tier2:RemoveOnDeath()
	return false
end
function modifier_creep_gold_exp_tier2:OnCreated()
if IsServer() then
local hp = self:GetParent():GetMaxHealth()
local gold = self:GetParent():GetGoldBounty()
local damage_min = self:GetParent():GetBaseDamageMin()
local damage_max = self:GetParent():GetBaseDamageMax()
local exp_reward = self:GetParent():GetDeathXP()
local as = self:GetParent():GetAttackSpeed()
local arm = self:GetParent():GetPhysicalArmorBaseValue()
local jj = GameRules:GetGameTime()
if jj > 1080 then
self.gold = gold + 150
self.hp = hp + 800
self.damage_max = damage_max + 100
self.damage_min = damage_min + 100
self.exp = exp_reward + 200
self.as = as + 45
self.arm = arm + 10
else
local increase_hp = 60
local increase_damage = 8
local increase_gold = 12
local increase_exp = 22
local increase_as = 4
local increase_arm = 0.8
self.hp = hp + (increase_hp * (jj * 0.01))
self.gold = gold + (increase_gold * (jj * 0.01))
self.damage_max = damage_max + (increase_damage * (jj * 0.01))
self.damage_min = damage_min + (increase_damage * (jj * 0.01))
self.exp = exp_reward + (increase_exp * (jj * 0.01))
self.as = as + (increase_as * (jj * 0.01))
self.arm = arm + (increase_arm * (jj * 0.01))
end
			self:GetParent():SetBaseMaxHealth(self.hp)
			self:GetParent():SetHealth(self.hp)
			self:GetParent():SetMinimumGoldBounty(self.gold - 10 )
			self:GetParent():SetMaximumGoldBounty(self.gold)	
            self:GetParent():SetBaseDamageMax(self.damage_max)
            self:GetParent():SetBaseDamageMin(self.damage_min)
            self:GetParent():SetDeathXP(self.exp)
           -- self:GetParent():SetMaximumAttackSpeed(self.as)
          --  self:GetParent():SetMinimumAttackSpeed(self.as)
            self:GetParent():SetPhysicalArmorBaseValue(self.arm)			
end

end


function modifier_creep_gold_exp_tier2:DeclareFunctions()
    local func = {  
    				
                    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,	
				}
    return func
end

function modifier_creep_gold_exp_tier2:GetModifierIncomingDamage_Percentage( params )
if self:GetParent():IsNeutralUnitType() then
	if  params.attacker:HasModifier("modifier_rat_contract_effect")  then
    
		return -60
		else
		
		return 0
		end
	end 
	end

creep_gold_exp_tier3 = class({})
LinkLuaModifier( "modifier_creep_gold_exp_tier3", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

function creep_gold_exp_tier3:GetIntrinsicModifierName()
	return "modifier_creep_gold_exp_tier3"
end

modifier_creep_gold_exp_tier3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creep_gold_exp_tier3:IsHidden()
	return false
end

function modifier_creep_gold_exp_tier3:IsDebuff()
	return false
end

function modifier_creep_gold_exp_tier3:IsStunDebuff()
	return true
end

function modifier_creep_gold_exp_tier3:IsPurgable()
	return true
end

function modifier_creep_gold_exp_tier3:RemoveOnDeath()
	return false
end
function modifier_creep_gold_exp_tier3:OnCreated()
if IsServer() then

end
end
function modifier_creep_gold_exp_tier3:CheckState()
	local state = {
	
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end
function modifier_creep_gold_exp_tier3:DeclareFunctions()
    local func = {  
    				
                    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
MODIFIER_EVENT_ON_DEATH,					
				}
    return func
end
function modifier_creep_gold_exp_tier3:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
	end
end
function modifier_creep_gold_exp_tier3:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end

	-- logic
	if pass then
	local caster = params.attacker

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
		for _,enemy in pairs(enemies) do
		if not enemy:IsIllusion() then
				PlayerResource:ModifyGold( enemy:GetPlayerOwnerID(), 1000, false, DOTA_ModifyGold_Unspecified )
				  enemy:AddExperience( 1500, 0, false, false )
	end
	end
	end
end
function modifier_creep_gold_exp_tier3:GetModifierIncomingDamage_Percentage( params )
if self:GetParent():IsNeutralUnitType() then
	if params.attacker:HasModifier("modifier_rat_contract_effect")  then
    
		return -75
		else
		
		return 0
		end
	end 
	end

-----------------------------------

tower_defence = class({})
LinkLuaModifier( "modifier_tower_defence", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_defence_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function tower_defence:GetIntrinsicModifierName()
	return "modifier_tower_defence"
end


modifier_tower_defence = class({})
function modifier_tower_defence:IsHidden() return false end
function modifier_tower_defence:IsDebuff() return true end
function modifier_tower_defence:IsPurgable() return false end
function modifier_tower_defence:IsPurgeException() return false end
function modifier_tower_defence:RemoveOnDeath() return true end
function modifier_tower_defence:AllowIllusionDuplicate() return false end
function modifier_tower_defence:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end
function modifier_tower_defence:DeclareFunctions()
    local func = {  
    				
MODIFIER_EVENT_ON_TAKEDAMAGE,
MODIFIER_PROPERTY_MIN_HEALTH					}
    return func
end
function modifier_tower_defence:GetMinHealth()
   
	return 1 
	end

function modifier_tower_defence:OnTakeDamage(keys)
	if IsServer() then
    local caster = self:GetCaster()
	
		local attacker = keys.attacker
	local target = keys.unit
	
				if self:GetParent():GetHealth() < 2 then
				if not self:GetParent():IsIllusion() then	
				if not self:GetParent():HasModifier("modifier_tower_defence_invul")	then
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_tower_defence_invul", {duration = 300})
					EmitSoundOn("tower.dormant", self:GetParent())
					self:PlayEffects(self:GetParent())
				
local enemies = FindUnitsInRadius(
		keys.attacker:GetTeamNumber(),	-- int, your team number
		keys.attacker:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
		for _,enemy in pairs(enemies) do
				PlayerResource:ModifyGold( enemy:GetPlayerOwnerID(), 250, false, DOTA_ModifyGold_Unspecified )
	end
				
				end
               
		end
		end
		end
		end
		function modifier_tower_defence:PlayEffects(target)
		if IsServer() then
	-- Get Resources
	local particle_cast = "particles/dire_fx/bad_barracks001_melee_destroy.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	end

end

		
		modifier_tower_defence_invul = class({})
function modifier_tower_defence_invul:IsHidden() return false end
function modifier_tower_defence_invul:IsDebuff() return true end
function modifier_tower_defence_invul:IsPurgable() return false end
function modifier_tower_defence_invul:IsPurgeException() return false end
function modifier_tower_defence_invul:RemoveOnDeath() return true end
function modifier_tower_defence_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_tower_defence_invul:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
					 
       
        
		
    }

    return funcs
end
function modifier_tower_defence_invul:GetBonusNightVision()
    return -1200
end
function modifier_tower_defence_invul:GetBonusDayVision()

    return -600

end
function modifier_tower_defence_invul:GetEffectName()
	return "particles/econ/items/omniknight/omni_ti8_head/omniknight_repel_buff_ti8.vpcf"
end

function modifier_tower_defence_invul:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end










music_box = class({})
LinkLuaModifier( "modifier_music_box", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function music_box:GetIntrinsicModifierName()
	return "modifier_music_box"
end


modifier_music_box = class({})
function modifier_music_box:IsHidden() return false end
function modifier_music_box:IsDebuff() return true end
function modifier_music_box:IsPurgable() return false end
function modifier_music_box:IsPurgeException() return false end
function modifier_music_box:RemoveOnDeath() return true end
function modifier_music_box:AllowIllusionDuplicate() return false end
function modifier_music_box:CheckState()
	local state = {	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = false,}
	return state
end
function modifier_music_box:DeclareFunctions()
	local func = {	
					 
                    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					MODIFIER_PROPERTY_MIN_HEALTH
			}
	return func
end
function modifier_music_box:GetMinHealth()
   
	return 100 
	end
function modifier_music_box:GetModifierIncomingDamage_Percentage( params )
	

		return -100
	end
function modifier_music_box:OnCreated(table)
if IsServer() then
_G.MusicBox = self:GetParent()
self:StartIntervalThink(0.1)
end
end

function modifier_music_box:OnIntervalThink(table)
if IsServer() then
if not _G.SoundCheck == true then
	_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	else
	if not self:GetParent():HasModifier("modifier_star_tier3") and not self:GetParent():HasModifier("modifier_star_tier2") and not self:GetParent():HasModifier("modifier_star_tier1") then
	_G.SoundCheck = false
	end
	
end
end
end



base_invul = class({})
LinkLuaModifier( "modifier_base_invul", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function base_invul:GetIntrinsicModifierName()
	return "modifier_base_invul"
end
modifier_base_invul = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_base_invul:IsHidden()
	return true
end

function modifier_base_invul:IsDebuff()
	return false
end

function modifier_base_invul:IsPurgable()
	return false
end



function modifier_base_invul:OnRefresh( kv )
	
end

function modifier_base_invul:OnRemoved()

end
function modifier_base_invul:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end












seraphim_crit = class({})
LinkLuaModifier( "modifier_seraphim_crit", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function seraphim_crit:GetIntrinsicModifierName()
	return "modifier_seraphim_crit"
end

function seraphim_crit:OnSpellStart()
	local caster = self:GetCaster()
	local damageTable = {
		attacker = caster,
		damage = 600,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
	}
	self:PlayEffects(caster)

				
local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
		for _,enemy in pairs(enemies) do
		if enemy:GetTeamNumber() == caster:GetTeamNumber() then
		local heal = 1000
		enemy:Heal( heal, caster )
		else
		
					damageTable.victim = enemy
		ApplyDamage(damageTable)
				
				end
               
		end
end
		function seraphim_crit:PlayEffects(target)
		if IsServer() then
	-- Get Resources
	local particle_cast = "particles/blood_angel_crit.vpcf"
   EmitSoundOn("seraphim.crit", target)

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	end

end
modifier_seraphim_crit = class({})
function modifier_seraphim_crit:IsHidden() return false end
function modifier_seraphim_crit:IsDebuff() return true end
function modifier_seraphim_crit:IsPurgable() return false end
function modifier_seraphim_crit:IsPurgeException() return false end
function modifier_seraphim_crit:RemoveOnDeath() return true end
function modifier_seraphim_crit:AllowIllusionDuplicate() return false end

function modifier_seraphim_crit:DeclareFunctions()
    local func = {  
    				
MODIFIER_EVENT_ON_TAKEDAMAGE,
MODIFIER_EVENT_ON_ATTACK_LANDED,
					}
    return func
end
function modifier_seraphim_crit:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetParent():Heal(params.damage * 0.4, nil)
			local damageTable = {
		attacker = self:GetParent(),
		damage = params.damage * 0.2,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(),
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		end
	end
end
function modifier_seraphim_crit:OnTakeDamage(keys)
	if IsServer() then
    local caster = self:GetCaster()
	
		local attacker = keys.attacker
	local target = keys.unit
	            if not self:GetParent():IsStunned() and not self:GetParent():IsSilenced() then
	           	if self:GetParent():IsAlive() then
				local max_health = self:GetParent():GetMaxHealth() * 0.24
				if self:GetParent():GetHealth() < max_health then
	            if self:GetAbility():IsFullyCastable() then
				self:GetAbility():StartCooldown(40)
				if not self:GetParent():IsIllusion() then	
					self:PlayEffects(self:GetParent())
					local damageTable = {
		attacker = self:GetParent(),
		damage = 500,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(),
	}

				
local enemies = FindUnitsInRadius(
		keys.attacker:GetTeamNumber(),	-- int, your team number
		keys.attacker:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
		for _,enemy in pairs(enemies) do
		if enemy:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		local heal = 1000
		enemy:Heal( heal, self:GetParent() )
		else
		
					damageTable.victim = enemy
		ApplyDamage(damageTable)
				
				end
               
		end
		end
		end
		end
		end
		end
		end
		end
		function modifier_seraphim_crit:PlayEffects(target)
		if IsServer() then
	-- Get Resources
	local particle_cast = "particles/blood_angel_crit.vpcf"
EmitSoundOn("seraphim.crit", self:GetParent())

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	end

end


devils_fire = class({})
LinkLuaModifier( "modifier_devils_fire", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_devil_burn", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function devils_fire:GetIntrinsicModifierName()
	return "modifier_devils_fire"
end

function devils_fire:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = target:GetOrigin()
	local origin = caster:GetOrigin()
	local direction = self:GetCaster():GetForwardVector()
	

	-- load data


	-- teleport
	FindClearSpaceForUnit( caster, point, true )
	local radius = 400
	local damage = 500
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		end

	-- Play effects
	self:PlayEffects( origin, direction )
end
function devils_fire:PlayEffects( origin, direction )

	self.particle_cast_a = "particles/hinokami_6_blink.vpcf"
	self.sound_cast_a = "devil.tp"

	self.particle_cast_b = "particles/hinokami_6_blink.vpcf"
	self.sound_cast_b = "devil.tp"
	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( self.particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, self.sound_cast_a, self:GetCaster() )

	-- At original position
	local effect_cast_b = ParticleManager:CreateParticle( self.particle_cast_b, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_b, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast_b, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_b )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), self.sound_cast_b, self:GetCaster() )
end
modifier_devils_fire = class({})
function modifier_devils_fire:IsHidden() return false end
function modifier_devils_fire:IsDebuff() return true end
function modifier_devils_fire:IsPurgable() return false end
function modifier_devils_fire:IsPurgeException() return false end
function modifier_devils_fire:RemoveOnDeath() return true end
function modifier_devils_fire:AllowIllusionDuplicate() return false end
function modifier_devils_fire:OnCreated(params)
	if IsServer() then
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = 50,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	self:StartIntervalThink(1)
	end
	end
	function modifier_devils_fire:OnIntervalThink()
	-- find enemies
	if self:GetParent():IsAlive() then
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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

		-- play effects
		self:PlayEffects( enemy )
	end
	end
end
function modifier_devils_fire:GetEffectName()
	return "particles/devil_fire_aura.vpcf"
end
function modifier_devils_fire:DeclareFunctions()
    local func = {  
    				
MODIFIER_EVENT_ON_TAKEDAMAGE,
MODIFIER_EVENT_ON_ATTACK_LANDED,
MODIFIER_EVENT_ON_DEATH,
					}
    return func
end
function modifier_devils_fire:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
	end
end
function modifier_devils_fire:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end

	-- logic
	if pass then
	local caster = self:GetCaster()
	local radius = 500
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = 1000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_devil_burn", -- modifier name
			{ duration = 3 } -- kv
		)
		self:PlayEffects2()
	end
	 EmitSoundOn("devil.death",self:GetParent())
	end
end
function modifier_devils_fire:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_devil_burn", {duration = 2.0})
		end
	end
end

function modifier_devils_fire:PlayEffects(target)
		if IsServer() then
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_clinkz/clinkz_burning_army_start_flames.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	end

end

function modifier_devils_fire:PlayEffects2()
		if IsServer() then
	-- Get Resources
	local target = self:GetParent()
	local particle_cast = "particles/devil_death.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	end

end
modifier_devil_burn = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_devil_burn:IsHidden()
	return false
end

function modifier_devil_burn:IsDebuff()
	return true
end

function modifier_devil_burn:IsStunDebuff()
	return false
end

function modifier_devil_burn:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_devil_burn:OnCreated( kv )
	-- references
	local damage = 100
	

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.5 )
end

function modifier_devil_burn:OnRefresh( kv )
	-- references
	local damage = 100
	

	if not IsServer() then return end

	-- update damage
	self.damageTable.damage = damage	
end

function modifier_devil_burn:OnRemoved()
end

function modifier_devil_burn:OnDestroy()
end

-- Interval Effects
function modifier_devil_burn:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_devil_burn:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_devil_burn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end





duel_unit_passive = class({})
LinkLuaModifier( "modifier_duel_unit_passive", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function duel_unit_passive:GetIntrinsicModifierName()
	return "modifier_duel_unit_passive"
end
modifier_duel_unit_passive = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_duel_unit_passive:IsHidden()
	return true
end

function modifier_duel_unit_passive:IsDebuff()
	return false
end

function modifier_duel_unit_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_duel_unit_passive:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( 3 )
	self:OnIntervalThink()
	local caster = self:GetParent()
	
	
end
	end
	


function modifier_duel_unit_passive:OnRefresh( kv )
	
end

function modifier_duel_unit_passive:OnRemoved()

end
	

function modifier_duel_unit_passive:OnIntervalThink()
if IsServer() then
if self:GetParent():IsAlive() then
self.duel_not_over = false
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_duel_unit_passive") or enemy:HasAbility("duel_unit_passive") then
	self.duel_not_over = true
	end
	end
	if self.duel_not_over  then
	_G.InDuelCheck = 0
	else
	_G.InDuelCheck = 1
	end
	else	
end
end
end

function modifier_duel_unit_passive:DeclareFunctions()
    local func = {  
    				
MODIFIER_EVENT_ON_DEATH,
					}
    return func
end
function modifier_duel_unit_passive:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
	end
end
function modifier_duel_unit_passive:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end
	if pass then
	local attacker = params.attacker 
	local enemies = FindUnitsInRadius(
		params.attacker:GetTeamNumber(),	-- int, your team number
		_G.DuelCenter,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	if not enemy:IsIllusion() then
	local playerid = enemy:GetPlayerID()
	if params.attacker:GetPlayerOwner() == PlayerResource:GetPlayer(playerid) then
				  COverthrowGameMode:IncreaseGamePointsForPlayer(enemy:GetPlayerID(),2,enemy)
	end
	end
	end
	end
end

anti_rat_duel = class({})
LinkLuaModifier( "modifier_anti_rat_duel", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function anti_rat_duel:GetIntrinsicModifierName()
	return "modifier_anti_rat_duel"
end
modifier_anti_rat_duel = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_anti_rat_duel:IsHidden()
	return true
end

function modifier_anti_rat_duel:IsDebuff()
	return false
end

function modifier_anti_rat_duel:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_anti_rat_duel:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	_G.DuelCenter = self.parent:GetOrigin()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, self:GetParent():GetAbsOrigin(), 3500, 99999, false)
	AddFOWViewer(DOTA_TEAM_BADGUYS, self:GetParent():GetAbsOrigin(), 3500, 99999, false)
	AddFOWViewer(DOTA_TEAM_CUSTOM_1, self:GetParent():GetAbsOrigin(), 3500, 99999, false)
	AddFOWViewer(DOTA_TEAM_CUSTOM_2, self:GetParent():GetAbsOrigin(), 3500, 99999, false)
	self:StartIntervalThink( FrameTime() )
	self:OnIntervalThink()
	end
	end
	


function modifier_anti_rat_duel:OnRefresh( kv )
	
end

function modifier_anti_rat_duel:OnRemoved()

end
function modifier_anti_rat_duel:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end



function modifier_anti_rat_duel:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
local origin = self:GetParent():GetOrigin()
self.center = self:GetParent():GetAbsOrigin()
local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		3500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_duel_unit_passive") or enemy:HasModifier("modifier_lunatic_nightmare_location") or enemy:IsIllusion() then
	else
	  local direction = (enemy:GetAbsOrigin() - self.center):Normalized()
	  local distance = (self.center - enemy:GetAbsOrigin()):Length2D()
            self.old_pos = self.center + direction * 5000

            enemy:SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(enemy, self.old_pos, true)
	
	end
	end
	end
	
	end
	end
	
	
	
	
	
	anti_rat_duel_treasure = class({})
LinkLuaModifier( "modifier_anti_rat_duel_treasure", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function anti_rat_duel_treasure:GetIntrinsicModifierName()
	return "modifier_anti_rat_duel_treasure"
end
modifier_anti_rat_duel_treasure = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_anti_rat_duel_treasure:IsHidden()
	return true
end

function modifier_anti_rat_duel_treasure:IsDebuff()
	return false
end

function modifier_anti_rat_duel_treasure:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_anti_rat_duel_treasure:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( 60 )
	end
	end
	


function modifier_anti_rat_duel_treasure:OnRefresh( kv )
	
end

function modifier_anti_rat_duel_treasure:OnRemoved()

end




function modifier_anti_rat_duel_treasure:OnIntervalThink()
if IsServer() then
local origin = self:GetParent():GetOrigin()
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
local reward = 0
local enemies = FindUnitsInRadius(
		DOTA_TEAM_GOODGUYS,	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
for _,enemy in pairs(enemies) do
if enemy:GetUnitName()== "npc_duel_box" then
reward = 1
end

end
if reward == 0 then

 local duel_box = CreateUnitByName("npc_duel_box", origin, true, nil, nil, DOTA_TEAM_NEUTRALS)
 reward = 1
end
end
	end
	end
	
	
	
	
	
	
	
	
	-----------------------------------------------
	
	
	
	
	duel_treasure_box = class({})
LinkLuaModifier( "modifier_duel_treasure_box", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_box_arcane", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_box_double_damage", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_duel_box_slow", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function duel_treasure_box:GetIntrinsicModifierName()
	return "modifier_duel_treasure_box"
end

modifier_duel_treasure_box = class({})
function modifier_duel_treasure_box:IsHidden() return false end
function modifier_duel_treasure_box:IsDebuff() return true end
function modifier_duel_treasure_box:IsPurgable() return false end
function modifier_duel_treasure_box:IsPurgeException() return false end
function modifier_duel_treasure_box:RemoveOnDeath() return true end
function modifier_duel_treasure_box:AllowIllusionDuplicate() return false end
function modifier_duel_treasure_box:DeclareFunctions()
    local func = {  
    				
MODIFIER_EVENT_ON_DEATH,
					}
    return func
end
function modifier_duel_treasure_box:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
	end
end
function modifier_duel_treasure_box:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end
	if pass then
	local rng = RandomInt(1,3)
	if rng == 1 or rng == 2 then
	local rnjesus = RandomInt(1,3)
	if rnjesus == 1 then
	params.attacker:Heal( 99999, self:GetParent() )
	 EmitSoundOn("duel_treasure.heal",params.attacker)
	 self:PlayEffects2(params.attacker)
	elseif rnjesus == 2 then
	EmitSoundOn("duel_treasure.damage",params.attacker)
	params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_box_double_damage", {duration = 15})
	else
	EmitSoundOn("duel_treasure.arcane",params.attacker)
	params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_box_arcane", {duration = 15})
	end
	else
	local rnjesus = RandomInt(1,3)
	if rnjesus == 1 then
	EmitSoundOn("duel_treasure.death",params.attacker)
	self:PlayEffects(params.attacker)
	 params.attacker:Kill(self:GetAbility(), self:GetCaster())
	elseif rnjesus == 2 then
	EmitSoundOn("duel_treasure.slow",params.attacker)
	params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_duel_box_slow", {duration = 6 })
	else
	EmitSoundOn("duel_treasure.stun",params.attacker)
	params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 3.0 })
	end
	
	
	
	end
	
	end
end


function modifier_duel_treasure_box:PlayEffects(target)
		if IsServer() then
	-- Get Resources
	local particle_cast = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	end

end

function modifier_duel_treasure_box:PlayEffects2(target)
		if IsServer() then
	-- Get Resources

	local particle_cast = "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal_cast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	end

end



modifier_box_double_damage = class({})

function modifier_box_double_damage:IsHidden()
	return false
end
function modifier_box_double_damage:RemoveOnDeath() return true end
function modifier_box_double_damage:AllowIllusionDuplicate()
	return true
end

function modifier_box_double_damage:IsPurgable()
    return false
end

function modifier_box_double_damage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,   
		
    }

    return funcs
end

function modifier_box_double_damage:GetModifierPreAttack_BonusDamage()
    return 400
end

function modifier_box_double_damage:GetEffectName()
	return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end


modifier_box_arcane = class({})

function modifier_box_arcane:IsHidden()
	return false
end
function modifier_box_arcane:RemoveOnDeath() return true end
function modifier_box_arcane:AllowIllusionDuplicate()
	return true
end

function modifier_box_arcane:IsPurgable()
    return false
end

function modifier_box_arcane:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,    
		
    }

    return funcs
end

function modifier_box_arcane:GetModifierSpellAmplify_Percentage()
    return 100
end


function modifier_box_arcane:GetEffectName()
	return "particles/generic_gameplay/rune_arcane_owner_e.vpcf"
end



modifier_duel_box_slow = class({})

function modifier_duel_box_slow:IsHidden()
	return false
end
function modifier_duel_box_slow:RemoveOnDeath() return true end
function modifier_duel_box_slow:AllowIllusionDuplicate()
	return true
end

function modifier_duel_box_slow:IsPurgable()
    return false
end

function modifier_duel_box_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
       
        
		
    }

    return funcs
end

function modifier_duel_box_slow:GetModifierMoveSpeedBonus_Constant()

	return -300
	
end


function modifier_duel_box_slow:GetEffectName()
	return "particles/econ/items/phantom_lancer/phantom_lancer_immortal_ti6/phantom_lancer_immortal_ti6_spiritlance_target_slowparent.vpcf"
end













asb_casino = class({})
LinkLuaModifier( "modifier_asb_casino", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_casino_cd", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_casino_arcane", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_casino_damage", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_casino_doki_doki", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_casino_glory", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_casino_legend_buff", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_casino_reduction", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_casino_slow", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_casino_regeneration", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_casino_as_slow", "heroes/new_asb/building_ability/general", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
-- Passive Modifier
function asb_casino:GetIntrinsicModifierName()
	return "modifier_asb_casino"
end


modifier_asb_casino = class({})
function modifier_asb_casino:IsHidden() return false end
function modifier_asb_casino:IsDebuff() return true end
function modifier_asb_casino:IsPurgable() return false end
function modifier_asb_casino:IsPurgeException() return false end
function modifier_asb_casino:RemoveOnDeath() return true end
function modifier_asb_casino:AllowIllusionDuplicate() return false end
function modifier_asb_casino:CheckState()
	local state = {	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	                [MODIFIER_STATE_NO_HEALTH_BAR] = true,
					}
	return state
end
function modifier_asb_casino:DeclareFunctions()
	local func = {	
					 
                    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					MODIFIER_PROPERTY_MIN_HEALTH,
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_EVENT_ON_ATTACK_START,
			}
	return func
end

function modifier_asb_casino:OnAttackStart( params )
	if IsServer() then
		if params.target~=self:GetParent() then return end

		params.attacker:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_casino_as_slow", -- modifier name
			{  } -- kv
		)
	end
end
function modifier_asb_casino:GetMinHealth()
   
	return 100 
	end
function modifier_asb_casino:GetModifierIncomingDamage_Percentage( params )
	

		return -200
	end

function modifier_asb_casino:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 60
	self.legend = 10
		if params.target == self:GetParent() then	
		if not params.attacker:HasModifier("modifier_casino_cd") then
			if not params.attacker:IsIllusion() then
			local gold = params.attacker:GetGold()
			if gold > 4500 then
			params.attacker:SpendGold(2000, DOTA_ModifyGold_AbilityCost )
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_cd", {duration = 60 })
			if RandomInt(0, 100)<self.crit_chance then
			local rng = RandomInt(1,5)
		if rng == 1 then
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_regeneration", {duration = 30 })
			
		self:GetParent():EmitSound("casino.regeneration")
		elseif rng == 2 then
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_arcane", {duration = 50 })
			
		self:GetParent():EmitSound("casino.arcane")
		elseif rng == 3 then
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_damage", {duration = 50 })
			
		self:GetParent():EmitSound("casino.damage")
		elseif rng == 4 then
		if RandomInt(0,100)< self.legend then
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_legend_buff", {duration = 60 })
					_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")	
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	_G.CurrentMusicUltima = "casino.devil_trigger"
_G.MusicBox:AddNewModifier(params.attacker, self:GetAbility(), "modifier_star_tier3", {duration = 60})
		self:GetParent():EmitSound("casino.legend.buff")
		else
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_regeneration", {duration = 30 })
			
		self:GetParent():EmitSound("casino.regeneration")
		end
		else
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_glory", {duration = 50 })
			
		self:GetParent():EmitSound("casino.glory")
		end
			
		else
		local rng = RandomInt(1,5)
		if rng == 1 then
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_slow", {duration = 25 })
			
		self:GetParent():EmitSound("casino.slow")
		elseif rng == 2 then
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_doki_doki", {duration = 30 })
			
		self:GetParent():EmitSound("casino.doki_doki")
		elseif rng == 3 then
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_reduction", {duration = 40 })
			
		self:GetParent():EmitSound("casino.reduction")
		elseif rng == 4 then
		
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_casino_slow", {duration = 15 })
			
		self:GetParent():EmitSound("casino.slow")
		
		else
		
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_let_me_die", {duration = 60 })
			
		self:GetParent():EmitSound("casino.let_me_die")
		 params.attacker:Kill(self:GetAbility(), self:GetCaster())
		end
		end
			end
		end
	end
	end
end
end
modifier_casino_cd = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_casino_cd:IsHidden()
	return false
end

function modifier_casino_cd:IsDebuff()
	return true
end

function modifier_casino_cd:IsStunDebuff()
	return false
end

function modifier_casino_cd:IsPurgable()
	return false
end
function modifier_casino_cd:RemoveOnDeath()
	return false
end

modifier_casino_as_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_casino_as_slow:IsHidden()
	return false
end

function modifier_casino_as_slow:IsDebuff()
	return true
end

function modifier_casino_as_slow:IsStunDebuff()
	return false
end

function modifier_casino_as_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_casino_as_slow:OnCreated( kv )
	-- references
	self.slow = -100
	self.duration = 1
end

function modifier_casino_as_slow:OnRefresh( kv )
	-- references
	self.slow = -100
	self.duration = 1
end

function modifier_casino_as_slow:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_casino_as_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PRE_ATTACK,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_casino_as_slow:GetModifierPreAttack( params )
	if IsServer() then
		-- record the attack that causes slow
		if not self.HasAttacked then
			self.record = params.record
		end

		-- check if start attacking another
		if params.target~=self:GetCaster() then
			self.attackOther = true
		end
	end
end

function modifier_casino_as_slow:OnAttack( params )
	if IsServer() then
		if params.record~=self.record then return end

		-- let the debuff persists
		self:SetDuration(self.duration, true)
		self.HasAttacked = true
	end
end

function modifier_casino_as_slow:OnAttackFinished( params )
	if IsServer() then
		if params.attacker~=self:GetParent() then return end
		
		-- destroy if cancel before attacks
		if not self.HasAttacked then
			self:Destroy()
		end

		-- destroy if finished attacking other units
		if self.attackOther then
			self:Destroy()
		end
	end
end

function modifier_casino_as_slow:GetModifierAttackSpeedBonus_Constant()
	if IsServer() then
		if self:GetParent():GetAggroTarget()==self:GetCaster() then
			return self.slow
		else
			return 0
		end
	end

	return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_casino_as_slow:GetEffectName()
	return "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf"
end

function modifier_casino_as_slow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
modifier_casino_damage = class({})

function modifier_casino_damage:IsHidden()
	return false
end
function modifier_casino_damage:RemoveOnDeath() return true end
function modifier_casino_damage:AllowIllusionDuplicate()
	return true
end

function modifier_casino_damage:IsPurgable()
    return false
end

function modifier_casino_damage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,		
		
    }

    return funcs
end

function modifier_casino_damage:GetModifierPreAttack_BonusDamage()
    return 200
end
  function modifier_casino_damage:GetModifierAttackSpeedBonus_Constant()
return 50
end 
function modifier_casino_damage:GetEffectName()
	return "particles/holy_lyre_aura.vpcf"
end


modifier_casino_arcane = class({})

function modifier_casino_arcane:IsHidden()
	return false
end
function modifier_casino_arcane:RemoveOnDeath() return true end
function modifier_casino_arcane:AllowIllusionDuplicate()
	return true
end

function modifier_casino_arcane:IsPurgable()
    return false
end

function modifier_casino_arcane:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,		
		
    }

    return funcs
end

function modifier_casino_arcane:GetModifierSpellAmplify_Percentage()
    return 30
end
function modifier_casino_arcane:GetModifierPercentageManacost()
    return 50
end

function modifier_casino_arcane:GetEffectName()
	return "particles/holy_lyre_aura_spd.vpcf"
end



modifier_casino_slow = class({})

function modifier_casino_slow:IsHidden()
	return false
end
function modifier_casino_slow:RemoveOnDeath() return true end
function modifier_casino_slow:AllowIllusionDuplicate()
	return true
end

function modifier_casino_slow:IsPurgable()
    return false
end

function modifier_casino_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
       
        
		
    }

    return funcs
end

function modifier_casino_slow:GetModifierMoveSpeedBonus_Constant()

	return -250
	
end


function modifier_casino_slow:GetEffectName()
	return "particles/econ/items/phantom_lancer/phantom_lancer_immortal_ti6/phantom_lancer_immortal_ti6_spiritlance_target_slowparent.vpcf"
end



modifier_casino_doki_doki = class({})

function modifier_casino_doki_doki:IsHidden()
	return false
end
function modifier_casino_doki_doki:RemoveOnDeath() return true end
function modifier_casino_doki_doki:AllowIllusionDuplicate()
	return true
end

function modifier_casino_doki_doki:IsPurgable()
    return false
end

function modifier_casino_doki_doki:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
					 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       
        
		
    }

    return funcs
end

function modifier_casino_doki_doki:GetBonusNightVision()
    return -800
end
function modifier_casino_doki_doki:GetBonusDayVision()

    return -800

end
function modifier_casino_doki_doki:GetModifierIncomingDamage_Percentage( params )
	

		return 15
	end


function modifier_casino_doki_doki:GetEffectName()
	return "particles/altair_explosion2.vpcf"
end



modifier_casino_reduction = class({})

function modifier_casino_reduction:IsHidden()
	return false
end
function modifier_casino_reduction:RemoveOnDeath() return true end
function modifier_casino_reduction:AllowIllusionDuplicate()
	return true
end

function modifier_casino_reduction:IsPurgable()
    return false
end

function modifier_casino_reduction:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,		
       
        
		
    }

    return funcs
end

function modifier_casino_reduction:GetModifierPreAttack_BonusDamage()
    return -200
end
function modifier_casino_reduction:GetModifierSpellAmplify_Percentage()
    return -30
end
function modifier_casino_reduction:GetTexture()
	return "note"
end
function modifier_casino_reduction:GetEffectName()
	return "particles/debuff_8.vpcf"
end






modifier_casino_regeneration = class({})

function modifier_casino_regeneration:IsHidden()
	return false
end
function modifier_casino_regeneration:RemoveOnDeath() return true end
function modifier_casino_regeneration:AllowIllusionDuplicate()
	return true
end

function modifier_casino_regeneration:IsPurgable()
    return false
end

function modifier_casino_regeneration:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE		
		
    }

    return funcs
end

function modifier_casino_regeneration:GetModifierTotalPercentageManaRegen()
    return 2
end
function modifier_casino_regeneration:GetModifierHealthRegenPercentage()
    return 2
end

function modifier_casino_regeneration:GetTexture()
	return "note"
end
function modifier_casino_regeneration:GetEffectName()
	return "particles/heal_great.vpcf"
end



modifier_casino_glory = class({})

function modifier_casino_glory:IsHidden()
	return false
end

function modifier_casino_glory:AllowIllusionDuplicate()
	return true
end
function modifier_casino_glory:RemoveOnDeath() return true end
function modifier_casino_glory:IsPurgable()
    return false
end

function modifier_casino_glory:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
 MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 		
		
    }

    return funcs
end

function modifier_casino_glory:GetModifierPhysicalArmorBonus()
    return 20
end
function modifier_casino_glory:GetModifierMagicalResistanceBonus()

    return 15
end
function modifier_casino_glory:GetTexture()
	return "note"
end
function modifier_casino_glory:GetEffectName()
	return "particles/armor_great.vpcf"
end



modifier_let_me_die = class({})

function modifier_let_me_die:IsHidden()
	return false
end
function modifier_let_me_die:RemoveOnDeath() return false end
function modifier_let_me_die:AllowIllusionDuplicate()
	return true
end

function modifier_let_me_die:IsPurgable()
    return false
end
function modifier_let_me_die:OnCreated(table)
	
	
end


function modifier_let_me_die:GetTexture()
	return "note"
end
function modifier_let_me_die:GetEffectName()
	return "particles/event_ghoul.vpcf"
end



modifier_boku_no_piko = class({})

function modifier_boku_no_piko:IsHidden()
	return false
end
function modifier_boku_no_piko:RemoveOnDeath() return true end
function modifier_boku_no_piko:AllowIllusionDuplicate()
	return false
end

function modifier_boku_no_piko:IsPurgable()
    return false
end

function modifier_boku_no_piko:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

		
	}

	return funcs
end

function modifier_boku_no_piko:GetModifierProvidesFOWVision()
	return 1
end
function modifier_boku_no_piko:GetModifierIncomingDamage_Percentage( params )
		return 100
end
function modifier_boku_no_piko:OnDestroy()
	
	
end

function modifier_boku_no_piko:GetTexture()
	return "note"
end
function modifier_boku_no_piko:GetEffectName()
	return "particles/event_2.vpcf"
end



modifier_casino_legend_buff = class({})

function modifier_casino_legend_buff:IsHidden()
	return false
end
function modifier_casino_legend_buff:RemoveOnDeath() return true end
function modifier_casino_legend_buff:AllowIllusionDuplicate()
	return false
end

function modifier_casino_legend_buff:IsPurgable()
    return false
end

function modifier_casino_legend_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
       
        
		
    }

    return funcs
end
function modifier_casino_legend_buff:GetModifierPreAttack_BonusDamage()
    return 400
end
function modifier_casino_legend_buff:GetModifierSpellAmplify_Percentage()
    return 75
end

function modifier_casino_legend_buff:OnTakeDamage(keys)
	if IsServer() then
    local caster = self:GetCaster()
	
		local attacker = keys.attacker
	local target = keys.unit
	
	
				
			
			
		   
			
				
				if self:GetParent():GetHealth() <= 20 then
				if not self:GetParent():IsIllusion() then
				local hp = self:GetParent():GetMaxHealth() * 0.8
			     
				 self:GetParent():SetHealth(hp)
				
					
					self:Destroy()
					
					
					return
				end
               
		end
			end
		end
function modifier_casino_legend_buff:OnDestroy()

	
end

function modifier_casino_legend_buff:GetTexture()
	return "note"
end
function modifier_casino_legend_buff:GetEffectName()
	return "particles/event_1.vpcf"
end









ability_guide = class({})

function ability_guide:IsStealable() return true end
function ability_guide:IsHiddenWhenStolen() return false end


function ability_guide:OnSpellStart()
if IsServer() then
    local caster = self:GetCaster()

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		_G.DuelCenter,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	if not enemy:IsIllusion() then
	local playerid = enemy:GetPlayerID()
	if caster:GetPlayerOwner() == PlayerResource:GetPlayer(playerid) then
				  self.player = playerid
	end
	end
	end
	local name = caster:GetUnitName()
	if name == "npc_duel_hero_1" then
self.name = "Your Hero is Aria: Tranform your hero into her for 10 seconds and shot youre opponents down!"
elseif name == "npc_duel_hero_2" then
self.name = "Your Hero is Rori Mercury: Full transformation grants +30 movespeed and +100 attack damage and other usefull abilities!"
elseif name == "npc_duel_hero_3" then
self.name = "Your Hero is Eight Grade Girl(Mikola Pidr): Full transformation grants +500 health and new abilities to beat the crap out of your opponents!"
elseif name == "npc_duel_hero_4" then
self.name = "Your Hero is Enma Ai: Use this ability to curse enemy hero.If enemy hero kills anyone(except of you) he will be banished to hell. If only 1 opponent left in arena this ability will instantly lead enemy to hell."
elseif name == "npc_duel_hero_5" then
self.name = "Your Hero is Nero Claudius: Transform you hero for 7 second to Padoru that grants 550 movespeed.When song is over you will deal any nearby enemi 1250 damage!"
elseif name == "npc_duel_hero_6" then
self.name = "Your Hero is Fujiwara Chika: When activated starts dancing(Channeled) and deal all enemies in arena pereodical damage!"
elseif name == "npc_duel_hero_7" then
self.name = "Your Hero is Sakata Gintoki: Ride the bike that explodes at the end!"
elseif name == "npc_duel_hero_8" then
self.name = "Your Hero is Imposter: Kill all enemies using new ability set!"
elseif name == "npc_duel_hero_9" then
self.name = "Your Hero is Big MOM: Transform grants +25% magic resist and +10 armor and new abilities!"
elseif name == "npc_duel_hero_10" then
self.name = "Your Hero is Licht Baah: Transform into Plunderer with high attack power and range.Also grants very high jump!"
elseif name == "npc_duel_hero_11" then
self.name = "Your Hero is Yagami Light: Your ability sets 20 second timer to enemy.After it selected enemy will die.If only 1 enemy left Light will definetly kill him."
elseif name == "npc_duel_hero_12" then
self.name = "Your Hero is Katsura Kotaro: Your ability will counter next damage taken within a second of buff and create massive explosion dealing 1000 magical damage around to any enemy.If received damage is lethal you will teleport to enemy and explode him!"
elseif name == "npc_duel_hero_13" then
self.name = "Your Hero is Sayaka Miki: Ability grants 1 second buff(refreshes self duration when stunned).When you die under that buff you will teleport to enemy and murder him with new hero!"
elseif name == "npc_duel_hero_14" then
self.name = "Your Hero is William Afton: Transform to Purple Guy and try to survive!!!"
elseif name == "npc_duel_hero_15" then
self.name = "Your Hero is Gayzma: 15 seconds transformation to annoing bastard that rejects any 600+ incoming damage"
else
self.name = "Чё пыришься пидор"
end
  local hNotificationTable1 = {   
                                        text       = self.name,
                                        style   =   {
                                                        color         = "#D3D3D3",
                                                        ["font-size"] = "45px",
                                                       
                                                    },
                                       
                                        duration   = fDuration or 3.0,
                                    }
									Notifications:Bottom(self.player,hNotificationTable1)
end
end











asb_holy_grail = class({})
LinkLuaModifier( "modifier_asb_holy_grail", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

function asb_holy_grail:GetIntrinsicModifierName()
	return "modifier_asb_holy_grail"
end
modifier_asb_holy_grail = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_asb_holy_grail:IsHidden()
	return true
end

function modifier_asb_holy_grail:IsDebuff()
	return false
end

function modifier_asb_holy_grail:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_asb_holy_grail:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink( 6.5 )
	self:OnIntervalThink()
	self:SetStackCount(0)
	self.rr = 0
	self.timer2 = 0
	end
	end
	


function modifier_asb_holy_grail:OnRefresh( kv )
	
end
function modifier_asb_holy_grail:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,

	}

	return funcs
end

function modifier_asb_holy_grail:OnDeath( params )
	if IsServer() then
		--self:KillLogic( params )
	end
end

function modifier_asb_holy_grail:KillLogic( params )
      local minute = GameRules:GetGameTime()
	local target = params.unit
	local attacker = params.attacker
	local pass = false
	if attacker:IsRealHero() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

	-- logic
	if pass then
		-- check if it is a hero
		if target:IsRealHero() then
		if self:GetStackCount() > 25 and _G.GrailExist == 0 then
			local newItem = CreateItem( "item_holy_grail", nil, nil )
			local spawnPoint = Vector(-2796.1,-2806.39,-1515.92)
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )

	newItem:LaunchLootInitialHeight( false, 0, 500, 0.75, spawnPoint )
	local hNotificationTable1 = {   
                                        text       = "Holy Grail Appeared in Center.Take it to your Citadel to earn reward!!!",
                                        style   =   {
                                                        color         = "#FFD700",
                                                        ["font-size"] = "40px",
                                                        
                                                    },
                                       
                                        duration   = fDuration or 8.0,
                                    }
    EmitGlobalSound("grail.spawn")
	Notifications:TopToAll(hNotificationTable1)
	_G.GrailExist = 1
	self:SetStackCount(0)
		else
		local stc = self:GetStackCount()
		local stc2 = stc + 1
		self:SetStackCount(stc2)	
		end
		end
		end
	end

function modifier_asb_holy_grail:OnRemoved()

end
function modifier_asb_holy_grail:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end

function modifier_asb_holy_grail:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_asb_holy_grail:OnIntervalThink()
if IsServer() then
local nNewState = GameRules:State_Get()
if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
local origin = self:GetParent():GetOrigin()
self:PlayEffects(origin)

self:PlayEffects2(origin)

end
end

	end
	
	function modifier_asb_holy_grail:PlayEffects3( origin )
local radius = 900
	local particle_cast = "particles/center_visual.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

	

function modifier_asb_holy_grail:PlayEffects(origin)
if IsServer() then
local jj = GameRules:GetGameTime()
 if jj > 600 and _G.ControlStop == 0 then
  local hNotificationTable1 = {   
                                        text       = "Grail Activated. Center now grants gold&EXP&Victory Points aura.Each kill now grants even more point!",
                                        style   =   {
                                                        color         = "#FF0000",
                                                        ["font-size"] = "30px",
                                                        
                                                    },
                                       
                                        duration   = fDuration or 8.0,
                                    }
									
	Notifications:TopToAll(hNotificationTable1)
 _G.ControlStop = 1
 
 end
 self.gold = 200 +  jj * 0.15
 self.exp1 = 250 + jj * 0.2
 if self.gold > 250 then
 self.gold = 400
 self.exp1 = 550
 end
 if _G.ControlStop == 1 then
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		900,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if not enemy:IsIllusion() then
	if not enemy:HasModifier("modifier_duel_chrono_effect") then
PlayerResource:ModifyGold( enemy:GetPlayerOwnerID(), self.gold, false, DOTA_ModifyGold_Unspecified )
				  enemy:AddExperience( self.exp1, 0, false, false )
				 
	end
	end
	end
end
end
end

function modifier_asb_holy_grail:PlayEffects2(origin)
if IsServer() then
local jj = GameRules:GetGameTime()
 if jj > 600  then
 if  self.timer2 == 0 then
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		900,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if not enemy:IsIllusion() then
	if not enemy:HasModifier("modifier_duel_chrono_effect") then
				  COverthrowGameMode:IncreaseGamePointsForPlayer(enemy:GetPlayerID(),1,enemy)
	end
	end
	end
	self:PlayEffects3(origin)
	self.timer2 = 1


elseif jj > 1200 then
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		900,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if not enemy:IsIllusion() then
	if not enemy:HasModifier("modifier_duel_chrono_effect") then
				  COverthrowGameMode:IncreaseGamePointsForPlayer(enemy:GetPlayerID(),1,enemy)
	end
	end
	end
	self:PlayEffects3(origin)
	self.timer2 = 1
else self.timer2 = 0 
end
end
end
end



base_asb_heal = class({})
LinkLuaModifier( "modifier_base_asb_heal", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_base_asb_heal_effect", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function base_asb_heal:GetIntrinsicModifierName()
	return "modifier_base_asb_heal"
end



modifier_base_asb_heal = class({})

--------------------------------------------------------------------------------

function modifier_base_asb_heal:IsHidden()
	return true
end



function modifier_base_asb_heal:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] =  true,	}

	return state
end
--------------------------------------------------------------------------------

function modifier_base_asb_heal:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_base_asb_heal:GetModifierAura()
	return "modifier_base_asb_heal_effect"
end

--------------------------------------------------------------------------------

function modifier_base_asb_heal:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_base_asb_heal:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

--function modifier_vengefulspirit_command_aura_lua:GetAuraSearchFlags()
--	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
--end

--------------------------------------------------------------------------------

function modifier_base_asb_heal:GetAuraRadius()
	return 600
end



modifier_base_asb_heal_effect = class({})

--------------------------------------------------------------------------------

function modifier_base_asb_heal_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end


function modifier_base_asb_heal_effect:GetTexture()
	return "jin_mori_2"
end

--------------------------------------------------------------------------------

function modifier_base_asb_heal_effect:GetModifierHealthRegenPercentage( params )
	return 2
end

--------------------------------------------------------------------------------

function modifier_base_asb_heal_effect:GetModifierTotalPercentageManaRegen( params )
	return 2
end

--------------------------------------------------------------------------------

function modifier_base_asb_heal_effect:GetModifierConstantManaRegen( params )
	return 10
end












asb_grand_bench = class({})
LinkLuaModifier( "modifier_asb_grand_bench", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elven_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_human_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_necro_capture", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_point_captured", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_captured_once_current", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_defence_mp_regen", "heroes/new_asb/building_ability/general.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function asb_grand_bench:GetIntrinsicModifierName()
	return "modifier_asb_grand_bench"
end
modifier_asb_grand_bench = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_asb_grand_bench:IsHidden()
	return true
end

function modifier_asb_grand_bench:IsDebuff()
	return false
end

function modifier_asb_grand_bench:IsPurgable()
	return false
end

	


function modifier_asb_grand_bench:OnRefresh( kv )
	
end

function modifier_asb_grand_bench:OnRemoved()

end
function modifier_asb_grand_bench:CheckState()
	local state = {

		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end

function modifier_asb_grand_bench:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

