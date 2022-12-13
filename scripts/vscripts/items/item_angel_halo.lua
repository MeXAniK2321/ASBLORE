item_angel_halo = class({})
LinkLuaModifier("modifier_angel_halo", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_start", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_cd", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stack", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_slow", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_root", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_shock", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_0", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_1", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_2", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_3", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_4", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_5", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_6", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_7", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_8", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_9", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_10", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_9_alt", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alice", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alice_8", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_10_invul", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_water", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_wind", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_succubus_orgy", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_warning_3rd_level", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_fire", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_earth", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_attack", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_heaven", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stack_cd", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_halo_stage_9_true", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_spirits_stats_1", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_spirits_stats_2", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_spirits_stats_3", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_halo_spirits_stats_4", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lust_awaken", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lust_armor_invul", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lust_armor_sealed", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lust_armor_awakened", "items/item_angel_halo", LUA_MODIFIER_MOTION_NONE)

function item_angel_halo:GetBehavior()
	if self:GetCaster():HasModifier("modifier_angel_halo_start") then
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
		
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function item_angel_halo:GetIntrinsicModifierName()
	return "modifier_angel_halo"
end
function item_angel_halo:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local modifier = caster:FindModifierByNameAndCaster("modifier_angel_halo_stack",caster)
	if modifier == nil then return end
	local current = modifier:GetStackCount()
	if caster:HasModifier("modifier_angel_halo_start") then
	if caster:HasModifier("modifier_angel_halo_stage_0") then
	self:GetCaster():PerformAttack (
		target,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)
	EmitSoundOn("halo.attack", caster)
	self:PlayEffects(target)
	
	elseif caster:HasModifier("modifier_angel_halo_stage_1") then
	
	self:GetCaster():PerformAttack (
		target,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)
	target:AddNewModifier(caster, self, "modifier_halo_slow", {duration = 2})
	EmitSoundOn("halo.water", caster)
	self:PlayEffects1(target)
	
	
	elseif caster:HasModifier("modifier_angel_halo_stage_2") then
	local modifier = self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_halo_attack",
		{}
	)
		self:GetCaster():PerformAttack (
		target,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)
	modifier:Destroy()
	EmitSoundOn("halo.crit", caster)
	self:PlayEffects2(target)
	
	
	
	elseif caster:HasModifier("modifier_angel_halo_stage_3") then
	
	target:AddNewModifier(caster, self, "modifier_halo_root", {duration = 2})
	EmitSoundOn("halo.root", caster)
	local damageTable = {
		attacker = caster,
		damage = 400,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
	
	elseif caster:HasModifier("modifier_angel_halo_stage_4") then
	
	target:AddNewModifier(caster, self, "modifier_halo_shock", {duration = 2.0})
	EmitSoundOn("halo.shock", caster)
	
	local damageTable = {
		attacker = caster,
		damage = 700,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
		self:PlayEffects10(target)
	elseif caster:HasModifier("modifier_angel_halo_stage_5") then
	
	        local max_health = target:GetMaxHealth()
			local target_hp = target:GetHealth()
			local damage_hp = (max_health - target_hp) * 0.3
			local enemy_hp = max_health - target_hp
			
			local damageTable = {
		attacker = caster,
		damage = damage_hp + 400,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
		self:PlayEffects3(target)
	EmitSoundOn("halo.shot", caster)
	
	elseif caster:HasModifier("modifier_angel_halo_stage_6") then
	
	
			self:GetCaster():PerformAttack (
		target,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)
	EmitSoundOn("halo.flame", caster)
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.0})
	target:AddNewModifier(caster, self, "modifier_halo_fire", {duration = 3.0})
	self:PlayEffects4(target)
	
	elseif caster:HasModifier("modifier_angel_halo_stage_7") then
	
	
	EmitSoundOn("halo.magic", caster)
	EmitSoundOn("halo.magic_exp", caster)
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.5})
	local delay = 1
	Timers:CreateTimer(delay,function()
	local damageTable = {
		attacker = caster,
		damage = 1200,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
		end)
		self:PlayEffects5(target)
	
	
	elseif caster:HasModifier("modifier_angel_halo_stage_8") then
	if target:GetUnitName()== "npc_dota_hero_axe" or  target:GetUnitName()== "npc_dota_hero_beastmaster" then
	EmitSoundOn("halo.succubus_gachi", caster)
	EmitSoundOn("halo.succubus_gachi_2", caster)
	else
	EmitSoundOn("halo.succubus", caster)
	EmitSoundOn("halo.succubus2", caster)
	end
	target:AddNewModifier(caster, self, "modifier_succubus_orgy", {duration = 4.5})
	
	
	elseif caster:HasModifier("modifier_angel_halo_stage_9") then
	
	local hp = target:GetMaxHealth()
local current_hp = target:GetHealth()
local hp_life = hp * 0.2

local hp_kill = hp - current_hp

if current_hp < hp_life or current_hp < 1500  then

target:Kill(self, caster)
caster:RemoveModifierByName("modifier_angel_halo_stage_9")
caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 60})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_9_true", {duration = 60})
else
	local damageTable = {
		attacker = caster,
		damage = 1500,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
	
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = 2.0})
	end
	self:PlayEffects6(target)
	EmitSoundOn("halo.death", caster)
	elseif caster:HasModifier("modifier_lust_armor_sealed") then
local damageTable = {
		attacker = caster,
		damage = 2000,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
		caster:Heal(2000,nil)
	
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = 2.0})
	self:PlayEffects15(target)
	
	EmitSoundOn("halo.lust_slash", caster)
	elseif caster:HasModifier("modifier_lust_armor_awakened") then
	
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = 1.0 } -- kv
	)
	
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
	caster:MoveToTargetToAttack(target)
		local sound_cast = "halo.lust_end"
	EmitSoundOn( sound_cast, target )

	self:PlayEffects16(target)
	
	local damageTable = {
		attacker = caster,
		damage = 3500,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
	elseif caster:HasModifier("modifier_angel_halo_stage_9_true") then
	
	
		local damageTable = {
		attacker = caster,
		damage = 2500,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
	
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = 2.0})
	self:PlayEffects7(target)
	
	EmitSoundOn("halo.death", caster)
	
	elseif caster:HasModifier("modifier_angel_halo_stage_9_alt") then
	EmitSoundOn("halo.heaven", caster)
	self:PlayEffects8(target)
	target:AddNewModifier(caster, self, "modifier_halo_heaven", {duration = 2.0})
local knockback = { should_stun = 1,
                        knockback_duration = 2.5,
                        duration = 2.5,
                        knockback_distance = 0,
                        knockback_height = 600,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
	 target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	elseif caster:HasModifier("modifier_angel_halo_stage_10") then
		local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = 1.0 } -- kv
	)
	
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
	caster:MoveToTargetToAttack(target)
		local sound_cast = "halo.teleport"
	EmitSoundOn( sound_cast, target )
	local sound_cast2 = "halo.slash"
	EmitSoundOn( sound_cast2, target )
	local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then
		self:PlayEffects12( target)
		else
	self:PlayEffects9( target)
	end
	local damageTable = {
		attacker = caster,
		damage = 1800,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
	else end
	
	else
	if caster:HasModifier("modifier_lust_awaken") then
	local Player = PlayerResource:GetPlayer(caster:GetPlayerID())
	   local kills = PlayerResource:GetKills(caster:GetPlayerID())
	   if kills > 29 and current == 800 then
	     caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 80})
	caster:AddNewModifier(caster, self, "modifier_lust_armor_awakened", {duration = 80})
	caster:AddNewModifier(caster, self, "modifier_lust_armor_invul", {duration = 3})
	self:EndCooldown()
	   else
	  caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 40})
	caster:AddNewModifier(caster, self, "modifier_lust_armor_sealed", {duration = 40})
	self:EndCooldown()
	end
	else
	if current < 20 then
	  caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 30})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_0", {duration = 30})
	self:EndCooldown()
	elseif current > 20 and current < 40 then
	
	  caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 30})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_1", {duration = 30})
	self:EndCooldown()
      elseif current > 40 and current < 60 then
	  
	  
	      caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 30})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_2", {duration = 30})
	  
	  self:EndCooldown()
	  
	   elseif current > 60 and current < 80 then
	    caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 30})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_3", {duration = 30})
	  
	  self:EndCooldown()
	  
	   elseif current > 80 and current < 120 then
	    caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 30})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_4", {duration = 30})
	  self:EndCooldown()
	  
	  
	   elseif current > 120 and current < 220 then
	    caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 40})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_5", {duration = 40})
	  
	  self:EndCooldown()
	  
	  
	  
	   elseif current > 220 and current < 300 then
	    caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 40})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_6", {duration = 40})
	  
	  
	  self:EndCooldown()
	  
	   elseif current > 300 and current < 400 then
	   caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 45})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_8", {duration = 45})
	  
	  
	  self:EndCooldown()
	   elseif current > 400 and current < 600 then
	   local number = RandomInt(1,4)
	  caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 60})
	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_7", {duration = 60, number = number})
	  
	  
	  self:EndCooldown()
	  
	   elseif current > 600 and current < 800 then
	    caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 60})
	  	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_9", {duration = 60})
	  self:EndCooldown()
	  elseif current == 800 then
	  caster:AddNewModifier(caster, self, "modifier_angel_halo_start", {duration = 63})
	  	caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_10", {duration = 63})
		caster:AddNewModifier(caster, self, "modifier_angel_halo_stage_10_invul", {duration = 3})
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY+DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_ALL,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then else
EmitGlobalSound("halo.alarm")
end
	-- apply slow
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			caster,
			self,
			"modifier_warning_3rd_level",
			{ duration = 3 }
		)
	end
		self:EndCooldown()
	end
	end
	end
	local modifier = caster:FindModifierByNameAndCaster("modifier_angel_halo_stack",caster)
	if modifier == nil then return end
	if not caster:HasModifier("modifier_stack_cd") then
	  caster:AddNewModifier(caster, self, "modifier_stack_cd", {duration = 60})
	local current = modifier:GetStackCount()
	local after = current + 10
	modifier:SetStackCount( after )
	end
	end
	

function item_angel_halo:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_weapon_blur_critical.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects1( target )
	-- Load effects
	local particle_cast = "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_water_base.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/halo_crit.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects3( target )
	-- Load effects
	local particle_cast = "particles/dante_bicycle_explosion.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects4( target )
	-- Load effects
	local particle_cast = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_explosion.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects5( target )
	-- Load effects
	local particle_cast = "particles/halo_7_explosion.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects6( target )
	-- Load effects
	local particle_cast = "particles/kuroalice_necro_strike.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects7( target )
	-- Load effects
	local particle_cast = "particles/kuroalice_necro_strike_lvl2.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects8( target )
	-- Load effects
	local particle_cast = "particles/halo_9_angel_active.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects9( target )
	-- Load effects
	local particle_cast = "particles/halo_10_portal.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects10( target )
	-- Load effects
	local particle_cast = "particles/econ/items/antimage/antimage_ti7/antimage_blink_ti7_end_sparkles.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects12( target )
	-- Load effects
	local particle_cast = "particles/halo_stage_10_true_crit.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects16( target )
	-- Load effects
	local particle_cast = "particles/halo_lust_armor_active_awaken.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function item_angel_halo:PlayEffects15( target )
	-- Load effects
	local particle_cast = "particles/halo_lust_armor_active_sealed.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_angel_halo = class({})


function modifier_angel_halo:IsHidden()
    return true
end
function modifier_angel_halo:RemoveOnDeath() return false end
function modifier_angel_halo:IsPurgable()
    return false
end
function modifier_angel_halo:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_angel_halo_stack", {})
	end
end

function modifier_angel_halo:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_angel_halo:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end

function modifier_angel_halo:GetModifierMoveSpeedBonus_Constant()

	return 30
	end

function modifier_angel_halo:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end


function modifier_angel_halo:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_angel_halo:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_angel_halo:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_angel_halo:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility():GetSpecialValueFor('as')
end

                
   modifier_angel_halo_cd = class({})
function modifier_angel_halo_cd:IsHidden() return false end
function modifier_angel_halo_cd:IsDebuff() return false end
function modifier_angel_halo_cd:IsPurgable() return false end
function modifier_angel_halo_cd:IsPurgeException() return false end
function modifier_angel_halo_cd:RemoveOnDeath() return true end

modifier_angel_halo_stack = class({})
function modifier_angel_halo_stack:IsHidden() return false end
function modifier_angel_halo_stack:IsDebuff() return false end
function modifier_angel_halo_stack:IsPurgable() return false end
function modifier_angel_halo_stack:IsPurgeException() return false end
function modifier_angel_halo_stack:RemoveOnDeath() return false end

function modifier_angel_halo_stack:OnCreated( kv )
	-- get references
	self.kill = 800
	

	if IsServer() then
		self:SetStackCount(0)
	end
	self:StartIntervalThink(3.0)
end
function modifier_angel_halo_stack:OnIntervalThink()
if GameRules:GetGameTime() > 1800 then
self:AddStack(2)
else
self:AddStack(1)
end
end
function modifier_angel_halo_stack:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,
		   MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

	}

	return funcs
end
function modifier_angel_halo_stack:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount() * 0.5
end
function modifier_angel_halo_stack:GetModifierAttackSpeedBonus_Constant()
	 return self:GetStackCount() * 0.125
end

function modifier_angel_halo_stack:OnRefresh( kv )

	local max_stack = 800

	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
	end
end
function modifier_angel_halo_stack:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
	end
end
function modifier_angel_halo_stack:KillLogic( params )
	-- filter
	local target = params.unit
	local attacker = params.attacker
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

local Player = PlayerResource:GetPlayer(target:GetPlayerID())
	   local kills = PlayerResource:GetKills(target:GetPlayerID())
	   local death = PlayerResource:GetDeaths(target:GetPlayerID())
	if pass and (not self:GetParent():PassivesDisabled()) then
	if death - kill > 10 then
	else

		if target:IsRealHero() then
			self:AddStack(8)
		end
		end

		
	end
end

function modifier_angel_halo_stack:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
		if after > self.kill then
			after = self.kill
		end
	self:SetStackCount( after )
end
function modifier_angel_halo_stack:GetAbilityTextureName()
	
	return "angel_halo"
end

modifier_angel_halo_stage_0 = class({})

function modifier_angel_halo_stage_0:IsHidden()
	return false
end
function modifier_angel_halo_stage_0:RemoveOnDeath() return true end
function modifier_angel_halo_stage_0:AllowIllusionDuplicate()
	return true
end
function modifier_angel_halo_stage_0:OnCreated()
self:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
EmitSoundOnClient("halo.theme_1", Player) 

 end
 function modifier_angel_halo_stage_0:OnDestroy()

local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("halo.theme_1", Player)
 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(30)	
 end
function modifier_angel_halo_stage_0:IsPurgable()
    return false
end

function modifier_angel_halo_stage_0:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		
		
    }

    return funcs
end

function modifier_angel_halo_stage_0:GetModifierPreAttack_BonusDamage()
    return 150
end

function modifier_angel_halo_stage_0:GetModifierMoveSpeedBonus_Percentage()

	return 10
	end

function modifier_angel_halo_stage_0:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_0:GetEffectName()
	return "particles/halo_stage_0.vpcf"
end
function modifier_angel_halo_stage_0:StopAllMusic()
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme", Player)
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
	  for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player)
		end
		 for i = 1, 5  do
			StopSoundOn("halo.theme_"..i, Player)
		end
	
end

end
modifier_angel_halo_stage_1 = class({})

function modifier_angel_halo_stage_1:IsHidden()
	return false
end
function modifier_angel_halo_stage_1:RemoveOnDeath() return true end
function modifier_angel_halo_stage_1:AllowIllusionDuplicate()
	return true
end

function modifier_angel_halo_stage_1:IsPurgable()
    return false
end
function modifier_angel_halo_stage_1:OnCreated()
self:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
EmitSoundOnClient("halo.theme_2", Player) 

 end
 function modifier_angel_halo_stage_1:OnDestroy()

local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("halo.theme_2", Player)
 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(30)	
 end
function modifier_angel_halo_stage_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
		
		
    }

    return funcs
end

function modifier_angel_halo_stage_1:GetModifierPreAttack_BonusDamage()
    return 175
end

function modifier_angel_halo_stage_1:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 10
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_halo_slow", {duration = 2 })
			
		self:GetParent():EmitSound("halo.water")
			end
		end
	end
	end
end

function modifier_angel_halo_stage_1:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_1:GetEffectName()
	return "particles/halo_stage_1.vpcf"
end

function modifier_angel_halo_stage_1:StopAllMusic()
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme", Player)
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
	  for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player)
		end
		 for i = 1, 5  do
			StopSoundOn("halo.theme_"..i, Player)
		end
	
end

end


modifier_halo_slow = class({})

--------------------------------------------------------------------------------

function modifier_halo_slow:IsDebuff()
	return true
end

function modifier_halo_slow:IsStunDebuff()
	return false
end
function modifier_halo_slow:IsHidden()
	return false
end
function modifier_halo_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_halo_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_halo_slow:GetModifierMoveSpeedBonus_Percentage()
	return -15
end

--------------------------------------------------------------------------------

function modifier_halo_slow:GetEffectName()
	return "particles/econ/events/ti10/high_five/high_five_lvl1_overhead_soap_bubbles.vpcf"
end

function modifier_halo_slow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end







modifier_angel_halo_stage_2 = class({})

function modifier_angel_halo_stage_2:IsHidden()
	return false
end
function modifier_angel_halo_stage_2:RemoveOnDeath() return true end
function modifier_angel_halo_stage_2:AllowIllusionDuplicate()
	return true
end

function modifier_angel_halo_stage_2:IsPurgable()
    return false
end
function modifier_angel_halo_stage_2:OnCreated()
    self.crit_chance = 10
	self.crit_bonus = 150
	self:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
EmitSoundOnClient("halo.theme_3", Player) 
end

 function modifier_angel_halo_stage_2:OnDestroy()

local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("halo.theme_3", Player)
 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(30)	
 end
function modifier_angel_halo_stage_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		
		
    }

    return funcs
end
function modifier_angel_halo_stage_2:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if self:RollChance( self.crit_chance ) then
			self.record = params.record
			return self.crit_bonus
		end
	end
end

function modifier_angel_halo_stage_2:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end
--------------------------------------------------------------------------------
-- Helper
function modifier_angel_halo_stage_2:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_angel_halo_stage_2:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local sound_cast = "halo.crit"

	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end
function modifier_angel_halo_stage_2:GetModifierPreAttack_BonusDamage()
    return 200
end

function modifier_angel_halo_stage_2:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_2:GetEffectName()
	return "particles/halo_stage_2.vpcf"
end

function modifier_angel_halo_stage_2:StopAllMusic()
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme", Player)
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
	  for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player)
		end
		 for i = 1, 5  do
			StopSoundOn("halo.theme_"..i, Player)
		end
	
end

end


modifier_halo_root = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_halo_root:IsHidden()
	return false
end

function modifier_halo_root:IsDebuff()
	return true
end

function modifier_halo_root:IsStunDebuff()
	return false
end

function modifier_halo_root:IsPurgable()
	return true
end

function modifier_halo_root:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------


function modifier_halo_root:OnRefresh( kv )
	
end

function modifier_halo_root:OnRemoved()
end

function modifier_halo_root:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_halo_root:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_halo_root:GetEffectName()
	return "particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root_small_cable.vpcf"
end

function modifier_halo_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_angel_halo_stage_3 = class({})

function modifier_angel_halo_stage_3:IsHidden()
	return false
end
function modifier_angel_halo_stage_3:RemoveOnDeath() return true end
function modifier_angel_halo_stage_3:AllowIllusionDuplicate()
	return true
end

function modifier_angel_halo_stage_3:IsPurgable()
    return false
end
function modifier_angel_halo_stage_3:OnCreated()

end
function modifier_angel_halo_stage_3:OnCreated()

	self:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
EmitSoundOnClient("halo.theme_4", Player) 
end

 function modifier_angel_halo_stage_3:OnDestroy()

local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("halo.theme_4", Player)
 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(30)	
 end
function modifier_angel_halo_stage_3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
		
		
    }

    return funcs
end
function modifier_angel_halo_stage_3:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 10
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			if not params.attacker:HasModifier("modifier_angel_halo_cd") then
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_angel_halo_cd", {duration = 3.5 })
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_halo_root", {duration = 1 })
			
		self:GetParent():EmitSound("halo.root")
			end
		end
	end
	end
	end
end

function modifier_angel_halo_stage_3:GetModifierPreAttack_BonusDamage()
    return 225
end

function modifier_angel_halo_stage_3:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_3:GetEffectName()
	return "particles/halo_stage_3.vpcf"
end

function modifier_angel_halo_stage_3:StopAllMusic()
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme", Player)
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
	  for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player)
		end
		 for i = 1, 5  do
			StopSoundOn("halo.theme_"..i, Player)
		end
	
end

end

modifier_halo_shock = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_halo_shock:IsHidden()
	return false
end

function modifier_halo_shock:IsDebuff()
	return true
end

function modifier_halo_shock:IsStunDebuff()
	return false
end

function modifier_halo_shock:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_halo_shock:OnCreated( kv )
	
	
		

end


function modifier_halo_shock:OnRefresh( kv )
end

function modifier_halo_shock:OnRemoved()
	
end

function modifier_halo_shock:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_halo_shock:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_halo_shock:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

modifier_angel_halo_stage_4 = class({})

function modifier_angel_halo_stage_4:IsHidden()
	return false
end
function modifier_angel_halo_stage_4:RemoveOnDeath() return true end
function modifier_angel_halo_stage_4:AllowIllusionDuplicate()
	return true
end

function modifier_angel_halo_stage_4:IsPurgable()
    return false
end
function modifier_angel_halo_stage_4:OnCreated()

	self:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
EmitSoundOnClient("halo.theme_5", Player) 
end

 function modifier_angel_halo_stage_4:OnDestroy()

local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("halo.theme_5", Player)
 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(30)	
 end
function modifier_angel_halo_stage_4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	
					
		
		
    }

    return funcs
end
function modifier_angel_halo_stage_4:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 10
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			if not params.attacker:HasModifier("modifier_angel_halo_cd") then
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_angel_halo_cd", {duration = 3.5 })
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_halo_shock", {duration = 1 })
			
		self:GetParent():EmitSound("halo.root")
			end
		end
	end
	end
	end
end

function modifier_angel_halo_stage_4:GetModifierPreAttack_BonusDamage()
    return 250
end

function modifier_angel_halo_stage_4:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_4:GetEffectName()
	return "particles/halo_stage_4.vpcf"
end
function modifier_angel_halo_stage_4:StopAllMusic()
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme", Player)
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
	  for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player)
		end
		 for i = 1, 5  do
			StopSoundOn("halo.theme_"..i, Player)
		end
	
end

end

modifier_angel_halo_stage_5 = class({})

function modifier_angel_halo_stage_5:IsHidden()
	return false
end
function modifier_angel_halo_stage_5:RemoveOnDeath() return true end
function modifier_angel_halo_stage_5:AllowIllusionDuplicate()
	return true
end

function modifier_angel_halo_stage_5:IsPurgable()
    return false
end
function modifier_angel_halo_stage_5:OnCreated()
if IsServer() then
		self:StopAllMusic()

	end
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
EmitSoundOnClient("halo.theme2_1", Player) 
end
function modifier_angel_halo_stage_5:OnDestroy()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("halo.theme2_1", Player) 
 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(50)	
end
function modifier_angel_halo_stage_5:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	
					
		
		
    }

    return funcs
end
function modifier_angel_halo_stage_5:OnAttackLanded(params)
	if IsServer()  then
	self.damage = 0.07
	if params.attacker == self:GetParent() then
		if self:GetParent():IsRealHero() then
	    if not params.attacker:IsIllusion() then
			local target = params.target
			local max_health = target:GetMaxHealth()
			local freeze_hp = max_health * 0.03
			local target_hp = target:GetHealth()
			local damage_hp = (max_health - target_hp) * self.damage
			local enemy_hp = max_health - target_hp
			
			local damageTable = {
		attacker = self:GetParent(),
		damage = damage_hp,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		self:PlayEffects(target)
		
  

                
			
			
			else
			end
		end
	end
	end
	end
function modifier_angel_halo_stage_5:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/econ/items/kunkka/kunkka_weapon_gunsword/kunkka_shot_gun.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_angel_halo_stage_5:GetModifierPreAttack_BonusDamage()
    return 300
end

function modifier_angel_halo_stage_5:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_5:GetEffectName()
	return "particles/halo_stage_5.vpcf"
end

function modifier_angel_halo_stage_5:StopAllMusic()
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme", Player)
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
	  for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player)
		end
		 for i = 1, 5  do
			StopSoundOn("halo.theme_"..i, Player)
		end
		 for i = 1, 3  do
			StopSoundOn("halo.theme2_"..i, Player)
		end
	
end

end
modifier_angel_halo_stage_6 = class({})

function modifier_angel_halo_stage_6:IsHidden()
	return false
end
function modifier_angel_halo_stage_6:RemoveOnDeath() return true end
function modifier_angel_halo_stage_6:AllowIllusionDuplicate()
	return true
end

function modifier_angel_halo_stage_6:IsPurgable()
    return false
end
function modifier_angel_halo_stage_6:OnCreated()
if IsServer() then
		self:StopAllMusic()
		

	end
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
EmitSoundOnClient("halo.theme2_2", Player) 
end
function modifier_angel_halo_stage_6:OnDestroy()
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("halo.theme2_2", Player) 
 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(55)	
end
function modifier_angel_halo_stage_6:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	
					
		
		
    }

    return funcs
end

function modifier_angel_halo_stage_6:GetModifierMagicalResistanceBonus()

    return 15
	
end
function modifier_angel_halo_stage_6:GetModifierPhysicalArmorBonus()

    return 10

end
function modifier_angel_halo_stage_6:OnAttackLanded(params)
	if IsServer()  then
	self.damage = 10
	if params.attacker == self:GetParent() then
		if self:GetParent():IsRealHero() then
	    if not params.attacker:IsIllusion() then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_halo_fire", {duration = 1 })
			

			
			
		self:PlayEffects(params.target)
		
  

                
			
			
			else
			end
		end
	end
	end
	end
function modifier_angel_halo_stage_6:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack_impact.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_angel_halo_stage_6:GetModifierPreAttack_BonusDamage()
    return 350
end

function modifier_angel_halo_stage_6:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_6:GetEffectName()
	return "particles/halo_stage_6.vpcf"
end
function modifier_angel_halo_stage_6:StopAllMusic()
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme", Player)
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
	  for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player)
		end
		 for i = 1, 5  do
			StopSoundOn("halo.theme_"..i, Player)
		end
		 for i = 1, 3  do
			StopSoundOn("halo.theme2_"..i, Player)
		end
	
end

end

modifier_angel_halo_stage_7 = class({})

function modifier_angel_halo_stage_7:IsHidden()
	return false
end
function modifier_angel_halo_stage_7:RemoveOnDeath() return true end
function modifier_angel_halo_stage_7:AllowIllusionDuplicate()
	return false
end

function modifier_angel_halo_stage_7:IsPurgable()
    return false
end

function modifier_angel_halo_stage_7:OnCreated(kv)
local caster = self:GetCaster()
self.shit  = RandomInt(1,4)
self.parent = self:GetParent()
local delay = 0.02
Timers:CreateTimer(delay,function()
if self.shit == 1 then
 
            self.shit_time =    ParticleManager:CreateParticle("particles/water_halo.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			 self.shit_time2 =    ParticleManager:CreateParticle("particles/spirit_overhead1.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
                                    caster:AddNewModifier(caster, self, "modifier_halo_spirits_stats_1", {duration = 60})
        
self:PlayEffects(300)


elseif self.shit == 2 then


            self.shit_time3 =    ParticleManager:CreateParticle("particles/earth_halo.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
             self.shit_time4 =    ParticleManager:CreateParticle("particles/spirit_overhead3.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)                         
       caster:AddNewModifier(caster, self, "modifier_halo_spirits_stats_2", {duration = 60})
self:PlayEffects1(300)

elseif self.shit == 3 then

            self.shit_time5 =    ParticleManager:CreateParticle("particles/wind_halo.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                     self.shit_time6 =    ParticleManager:CreateParticle("particles/spirit_overhead2.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)                             
        caster:AddNewModifier(caster, self, "modifier_halo_spirits_stats_3", {duration = 60})
self:PlayEffects2(300)
elseif self.shit == 4 then

  
            self.shit_time7 =    ParticleManager:CreateParticle("particles/fire_halo.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                         self.shit_time8 =    ParticleManager:CreateParticle("particles/spirit_overhead4.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
						 caster:AddNewModifier(caster, self, "modifier_halo_spirits_stats_4", {duration = 60})
self:PlayEffects3(300)		
end			
end)	 
        
if IsServer() then
		self:StopAllMusic()
		StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
self:StartIntervalThink(2)
	end
	local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then
		EmitGlobalSound("halo.theme_spirits_true")
		else
	EmitGlobalSound("halo.theme2_4")
	end
end
function modifier_angel_halo_stage_7:OnRefresh()
end
function modifier_angel_halo_stage_7:PlayEffects( radius )

	local particle_cast = "particles/water_halo_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_angel_halo_stage_7:PlayEffects1( radius )

	local particle_cast = "particles/earth_halo_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_angel_halo_stage_7:PlayEffects2( radius )

	local particle_cast = "particles/wind_halo_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_angel_halo_stage_7:PlayEffects3( radius )

	local particle_cast = "particles/fire_halo_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_angel_halo_stage_7:OnDestroy()
if self.shit_time then
 ParticleManager:DestroyParticle(self.shit_time, false)
        ParticleManager:ReleaseParticleIndex(self.shit_time)
		end
		if self.shit_time2 then
		 ParticleManager:DestroyParticle(self.shit_time2, false)
        ParticleManager:ReleaseParticleIndex(self.shit_time2)
		end
		if self.shit_time3 then
		 ParticleManager:DestroyParticle(self.shit_time3, false)
        ParticleManager:ReleaseParticleIndex(self.shit_time3)
		end
		if self.shit_time4 then
		 ParticleManager:DestroyParticle(self.shit_time4, false)
        ParticleManager:ReleaseParticleIndex(self.shit_time4)
		end
		if self.shit_time5 then
		 ParticleManager:DestroyParticle(self.shit_time5, false)
        ParticleManager:ReleaseParticleIndex(self.shit_time5)
		end
		if self.shit_time6 then
		 ParticleManager:DestroyParticle(self.shit_time6, false)
        ParticleManager:ReleaseParticleIndex(self.shit_time6)
		end
		if self.shit_time7 then
		 ParticleManager:DestroyParticle(self.shit_time7, false)
        ParticleManager:ReleaseParticleIndex(self.shit_time7)
		end
		if self.shit_time8 then
		 ParticleManager:DestroyParticle(self.shit_time8, false)
        ParticleManager:ReleaseParticleIndex(self.shit_time8)
		end
		local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then
					StopGlobalSound("halo.theme_spirits_true")
		else
			StopGlobalSound("halo.theme2_4")
			end
			 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(70)	
end
function modifier_angel_halo_stage_7:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		
    }

    return funcs
end


function modifier_angel_halo_stage_7:OnAttackLanded(params)
	if IsServer() then

		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if self.shit == 1 then
			local damageTable = {
		attacker = self:GetParent(),
		damage =  300,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_halo_water", {duration = 3 })

			elseif self.shit == 2 then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_halo_earth", {duration = 3 })
		
			elseif self.shit == 3 then

			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_halo_wind", {duration = 2 })
			else
	
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_halo_fire", {duration = 3 })
			
			end
		end
	end
	end
end

function modifier_angel_halo_stage_7:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_7:StopAllMusic()
	if IsServer() then
	

		for i = 1, 100 do
			StopGlobalSound("star.theme2_"..i)
		end
	
	
	
end
end
function modifier_angel_halo_stage_7:OnIntervalThink()
	if IsServer() then
		self:StopAllMusic2()
	end
	local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then
				StopGlobalSound("halo.theme2_4")
				end
end
function modifier_angel_halo_stage_7:StopAllMusic2()
	if IsServer() then
			 for i = 1, 5  do
			StopGlobalSound("halo.theme_"..i)
		end
		for i = 1, 3 do
			StopGlobalSound("halo.theme2_"..i)
		end
				for i = 1, 6 do
			StopGlobalSound("star.horn_"..i)
		end
			StopGlobalSound("spamton.theme")
self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		enemy:RemoveModifierByName("modifier_star_tier1")
		enemy:RemoveModifierByName("modifier_buff_chance")
		enemy:RemoveModifierByName("modifier_horn_tier1")
		enemy:RemoveModifierByName("modifier_debuff_chance")
	end
		

		
	end
end

modifier_halo_wind = class({})

function modifier_halo_wind:IsHidden()
	return false
end
function modifier_halo_wind:RemoveOnDeath() return true end
function modifier_halo_wind:AllowIllusionDuplicate()
	return true
end

function modifier_halo_wind:IsPurgable()
    return false
end

function modifier_halo_wind:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
       
        
		
    }

    return funcs
end

function modifier_halo_wind:GetModifierMoveSpeedBonus_Constant()

	return -150
	
end


function modifier_halo_wind:GetTexture()
	return "angel_halo"
end
function modifier_halo_wind:GetEffectName()
	return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_hud_ambient.vpcf"
end




modifier_halo_earth = class({})

function modifier_halo_earth:IsHidden()
	return false
end
function modifier_halo_earth:RemoveOnDeath() return true end
function modifier_halo_earth:AllowIllusionDuplicate()
	return true
end

function modifier_halo_earth:IsPurgable()
    return false
end

function modifier_halo_earth:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
       
        
		
    }

    return funcs
end

function modifier_halo_earth:GetModifierPhysicalArmorBonus()
    return -20
end


function modifier_halo_earth:GetTexture()
	return "angel_halo"
end
function modifier_halo_earth:GetEffectName()
	return "particles/earth_halo_debuff.vpcf"
end




modifier_halo_water = class({})

function modifier_halo_water:IsHidden()
	return false
end
function modifier_halo_water:RemoveOnDeath() return true end
function modifier_halo_water:AllowIllusionDuplicate()
	return false
end

function modifier_halo_water:IsPurgable()
    return false
end

function modifier_halo_water:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 		
		
    }

    return funcs
end

function modifier_halo_water:GetModifierMagicalResistanceBonus()
    return -20
end


function modifier_halo_water:GetTexture()
	return "angel_halo"
end
function modifier_halo_water:GetEffectName()
	return "particles/water_halo_debuff.vpcf"
end



modifier_halo_fire = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_halo_fire:IsHidden()
	return false
end

function modifier_halo_fire:IsDebuff()
	return true
end

function modifier_halo_fire:IsStunDebuff()
	return false
end

function modifier_halo_fire:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_halo_fire:OnCreated( kv )
	-- references
	local damage = 200
	

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.5 )
end

function modifier_halo_fire:OnRefresh( kv )
	-- references
	local damage = 200
	

	if not IsServer() then return end

	-- update damage
	self.damageTable.damage = damage	
end

function modifier_halo_fire:OnRemoved()
end

function modifier_halo_fire:OnDestroy()
end

-- Interval Effects
function modifier_halo_fire:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_halo_fire:GetEffectName()
	return "particles/econ/items/clinkz/clinkz_ti9_immortal/clinkz_ti9_summon_army.vpcf"
end

function modifier_halo_fire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_halo_spirits_stats_1 = class({})

function modifier_halo_spirits_stats_1:IsHidden()
	return true
end
function modifier_halo_spirits_stats_1:RemoveOnDeath() return true end
function modifier_halo_spirits_stats_1:AllowIllusionDuplicate()
	return false
end

function modifier_halo_spirits_stats_1:IsPurgable()
    return false
end

function modifier_halo_spirits_stats_1:DeclareFunctions()
    local funcs = {
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,   
		
    }

    return funcs
end
function modifier_halo_spirits_stats_1:GetModifierMagicalResistanceBonus()

    return 12
	
end

function modifier_halo_spirits_stats_1:GetModifierPreAttack_BonusDamage()
    return 450
end
modifier_halo_spirits_stats_2 = class({})

function modifier_halo_spirits_stats_2:IsHidden()
	return true
end
function modifier_halo_spirits_stats_2:RemoveOnDeath() return true end
function modifier_halo_spirits_stats_2:AllowIllusionDuplicate()
	return false
end

function modifier_halo_spirits_stats_2:IsPurgable()
    return false
end

function modifier_halo_spirits_stats_2:DeclareFunctions()
    local funcs = {
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,   
		
    }

    return funcs
end
function modifier_halo_spirits_stats_2:GetModifierPhysicalArmorBonus()

    return 15

end
function modifier_halo_spirits_stats_2:GetModifierPreAttack_BonusDamage()
    return 550
end
modifier_halo_spirits_stats_3 = class({})

function modifier_halo_spirits_stats_3:IsHidden()
	return true
end
function modifier_halo_spirits_stats_3:RemoveOnDeath() return true end
function modifier_halo_spirits_stats_3:AllowIllusionDuplicate()
	return false
end

function modifier_halo_spirits_stats_3:IsPurgable()
    return false
end

function modifier_halo_spirits_stats_3:DeclareFunctions()
    local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,   
		
    }

    return funcs
end
function modifier_halo_spirits_stats_3:GetModifierMoveSpeedBonus_Constant()

	return 80

	end
	
function modifier_halo_spirits_stats_3:GetModifierAttackSpeedBonus_Constant()

	 return 80

end
function modifier_halo_spirits_stats_3:GetModifierPreAttack_BonusDamage()
    return 500
end

modifier_halo_spirits_stats_4 = class({})

function modifier_halo_spirits_stats_4:IsHidden()
	return true
end
function modifier_halo_spirits_stats_4:RemoveOnDeath() return true end
function modifier_halo_spirits_stats_4:AllowIllusionDuplicate()
	return false
end

function modifier_halo_spirits_stats_4:IsPurgable()
    return false
end

function modifier_halo_spirits_stats_4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,   
		
    }

    return funcs
end

function modifier_halo_spirits_stats_4:GetModifierPreAttack_BonusDamage()
    return 800
end



modifier_angel_halo_stage_8 = class({})

function modifier_angel_halo_stage_8:IsHidden()
	return false
end
function modifier_angel_halo_stage_8:RemoveOnDeath() return true end
function modifier_angel_halo_stage_8:AllowIllusionDuplicate()
	return true
end

function modifier_angel_halo_stage_8:IsPurgable()
    return false
end
function modifier_angel_halo_stage_8:OnCreated()
if IsServer() then
		self:StopAllMusic()
	
	end
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
EmitSoundOnClient("halo.theme2_3", Player) 
end
function modifier_angel_halo_stage_8:OnDestroy()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("halo.theme2_3", Player) 
 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(60)	
end
function modifier_angel_halo_stage_8:StopAllMusic()
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme", Player)
		for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
	  for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player)
		end
		 for i = 1, 5  do
			StopSoundOn("halo.theme_"..i, Player)
		end
		 for i = 1, 3  do
			StopSoundOn("halo.theme2_"..i, Player)
		end
	
end

end
function modifier_angel_halo_stage_8:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	
					
		
		
    }

    return funcs
end
function modifier_angel_halo_stage_8:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 10
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			if not params.attacker:HasModifier("modifier_angel_halo_cd") then
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_angel_halo_cd", {duration = 3.5 })
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_halo_shock", {duration = 2 })
			self:PlayEffects(params.target)
		self:GetParent():EmitSound("halo.magic")
			end
		end
	end
	end
	end
end
function modifier_angel_halo_stage_8:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/test_love.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_angel_halo_stage_8:GetModifierPreAttack_BonusDamage()
    return 500
end

function modifier_angel_halo_stage_8:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_8:GetEffectName()
	return "particles/halo_stage_8.vpcf"
end








modifier_succubus_orgy = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_succubus_orgy:IsHidden()
	return false
end

function modifier_succubus_orgy:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_succubus_orgy:IsStunDebuff()
	return true
end

function modifier_succubus_orgy:IsPurgable()
	return true
end

function modifier_succubus_orgy:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_succubus_orgy:OnCreated( kv )
	-- references
	local damage = 2000
	self.radius = 50
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(),
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	-- ApplyDamage(damageTable)

	-- play effects
	self:GetParent():AddNoDraw()
	self:PlayEffects()
	
end


function modifier_succubus_orgy:OnRefresh( kv )
	-- references
	local damage = 2000
	self.radius = 50

	if not IsServer() then return end
	self.damageTable.damage = damage
end

function modifier_succubus_orgy:OnRemoved()
end

function modifier_succubus_orgy:OnDestroy()
local caster = self:GetCaster()
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
		self:GetParent():RemoveNoDraw()
	local health = self:GetParent():GetHealth()
	local max_hp = self:GetParent():GetMaxHealth()
	local hp_to_kill = max_hp * 0.15

	
	

	



	local knockback = { should_stun = 1,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 0,
                        knockback_height = 8000,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    self:GetParent():AddNewModifier(caster, self, "modifier_knockback", knockback)
	self:PlayEffects2()
	end



--------------------------------------------------------------------------------
-- Status Effects
function modifier_succubus_orgy:CheckState()
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
function modifier_succubus_orgy:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/succubus_orgy_start.vpcf"
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
function modifier_succubus_orgy:PlayEffects2()
	-- Get Resources
	local particle_cast1 = "particles/test_love.vpcf"
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
function modifier_succubus_orgy:PlayEffects3()
	-- Get Resources
	local particle_cast1 = "particles/dark_armor_kill.vpcf"
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

modifier_angel_halo_stage_9 = class({})
function modifier_angel_halo_stage_9:RemoveOnDeath()
	return true
end
function modifier_angel_halo_stage_9:IsHidden()
	return false
end

function modifier_angel_halo_stage_9:IsPurgable()
	return false
end
function modifier_angel_halo_stage_9:OnCreated()
    if not IsServer() then return end
    self.carapaced_units = {}
    self.caster_stun = true
	self:StartIntervalThink(2)
	
	if IsServer() then
		self:StopAllMusic()
		StopGlobalSound("spamton.neo_theme")
			for i = 1, 40 do
			StopGlobalSound("star.theme3_"..i)
			end
			for i = 1, 3 do
			StopGlobalSound("halo.theme3_"..i)
		end
	end
	EmitGlobalSound("halo.theme3_1")
end
function modifier_angel_halo_stage_9:OnDestroy()

	StopGlobalSound("halo.theme3_1")
	 self.ability = self:GetAbility()
	
	self.ability:EndCooldown()
	 self.ability:StartCooldown(80)	
	
end
function modifier_angel_halo_stage_9:OnIntervalThink()
	if IsServer() then
		self:StopAllMusic2()
		self:StopAllMusic()
	end
end
function modifier_angel_halo_stage_9:StopAllMusic()
	if IsServer() then
		
StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
		for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
	
	for i = 1, 4 do
			StopGlobalSound("halo.theme2_"..i)
		end
			 for i = 1, 5  do
			StopGlobalSound("halo.theme_"..i)
		end
end
end
function modifier_angel_halo_stage_9:StopAllMusic2()
	if IsServer() then
		


		  for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		for i = 1, 2  do
			StopGlobalSound("star.event_"..i)
		end
		for i = 1, 6  do
			StopGlobalSound("star.horn_"..i)
		end
		for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)

		

		
	end
end
end
function modifier_angel_halo_stage_9:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end
function modifier_angel_halo_stage_9:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 10
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			if not params.attacker:HasModifier("modifier_angel_halo_cd") then
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_angel_halo_cd", {duration = 3.5 })
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1.5 })
			self:PlayEffects(params.target)
		self:GetParent():EmitSound("halo.root")
			end
			end
		end
	end
	end
end
function modifier_angel_halo_stage_9:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/root_tentacles.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_angel_halo_stage_9:GetModifierPreAttack_BonusDamage()
    return 800
end

function modifier_angel_halo_stage_9:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_9:GetEffectName()
	return "particles/halo_stage_9.vpcf"
end

function modifier_angel_halo_stage_9:GetModifierBonusStats_Strength()
    return 25
end

function modifier_angel_halo_stage_9:GetModifierBonusStats_Agility()
    return 25
end

function modifier_angel_halo_stage_9:GetModifierBonusStats_Intellect()
    return 25
end


modifier_angel_halo_stage_9_true = class({})
function modifier_angel_halo_stage_9_true:IsHidden()
	return false
end
function modifier_angel_halo_stage_9_true:RemoveOnDeath()
	return true
end
function modifier_angel_halo_stage_9_true:IsPurgable()
	return false
end
function modifier_angel_halo_stage_9_true:OnCreated(kv)
    if not IsServer() then return end
    self.carapaced_units = {}
    self.caster_stun = true
	self:StartIntervalThink(2)
	
	if IsServer() then
		self:StopAllMusic()
		StopGlobalSound("spamton.neo_theme")
			for i = 1, 40 do
			StopGlobalSound("star.theme3_"..i)
			end
			for i = 1, 3 do
			StopGlobalSound("halo.theme3_"..i)
		end
	end
	EmitGlobalSound("halo.theme3_2")
	self:PlayEffects2(self:GetParent())
	  self.ability = self:GetAbility()
	
	self.ability:EndCooldown()
end
function modifier_angel_halo_stage_9_true:OnDestroy()

	StopGlobalSound("halo.theme3_2")
 self.ability:StartCooldown(80)	
end
function modifier_angel_halo_stage_9_true:OnIntervalThink()
	if IsServer() then
		self:StopAllMusic2()
		self:StopAllMusic()
	end
end
function modifier_angel_halo_stage_9_true:StopAllMusic()
	if IsServer() then
		
StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
		for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
	
	for i = 1, 4 do
			StopGlobalSound("halo.theme2_"..i)
		end
		 for i = 1, 5  do
			StopGlobalSound("halo.theme_"..i)
		end
end
end
function modifier_angel_halo_stage_9_true:StopAllMusic2()
	if IsServer() then
		


		  for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		for i = 1, 2  do
			StopGlobalSound("star.event_"..i)
		end
		for i = 1, 6  do
			StopGlobalSound("star.horn_"..i)
		end
		for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)

		

		
	end
end
end

function modifier_angel_halo_stage_9_true:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end
function modifier_angel_halo_stage_9_true:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 10
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			if not params.attacker:HasModifier("modifier_angel_halo_cd") then
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_angel_halo_cd", {duration = 3.5 })
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 2.0 })
			self:PlayEffects(params.target)
		self:GetParent():EmitSound("halo.root")
			end
		end
	end
	end
	end
end
function modifier_angel_halo_stage_9_true:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/root_tentacles.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_angel_halo_stage_9_true:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/cerma_explosion.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_angel_halo_stage_9_true:GetModifierPreAttack_BonusDamage()
    return 1000
end
function modifier_angel_halo_stage_9_true:GetModifierBonusStats_Strength()
    return 40
end

function modifier_angel_halo_stage_9_true:GetModifierBonusStats_Agility()
    return 40
end

function modifier_angel_halo_stage_9_true:GetModifierBonusStats_Intellect()
    return 40
end
function modifier_angel_halo_stage_9_true:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_9_true:GetEffectName()
	return "particles/halo_stage_9_true.vpcf"
end



modifier_angel_halo_stage_9_alt = class({})
function modifier_angel_halo_stage_9_alt:IsHidden()
	return false
end
function modifier_angel_halo_stage_9_alt:RemoveOnDeath()
	return false
end
function modifier_angel_halo_stage_9_alt:IsPurgable()
	return false
end
function modifier_angel_halo_stage_9_alt:OnCreated()
    if not IsServer() then return end
    self.carapaced_units = {}
    self.caster_stun = true
	self:StartIntervalThink(2)
	
	if IsServer() then
		self:StopAllMusic()
		StopGlobalSound("spamton.neo_theme")
			for i = 1, 40 do
			StopGlobalSound("star.theme3_"..i)
			end
			for i = 1, 3 do
			StopGlobalSound("halo.theme3_"..i)
		end
	end
	EmitGlobalSound("halo.theme3_3")

end
function modifier_angel_halo_stage_9_alt:OnDestroy()

	StopGlobalSound("halo.theme3_3")
	 self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(50)	
end
function modifier_angel_halo_stage_9_alt:OnIntervalThink()
	if IsServer() then
		self:StopAllMusic2()
		self:StopAllMusic()
	end
end
function modifier_angel_halo_stage_9_alt:StopAllMusic()
	if IsServer() then
		
StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
		for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
	
	for i = 1, 4 do
			StopGlobalSound("halo.theme2_"..i)
		end
			 for i = 1, 5  do
			StopGlobalSound("halo.theme_"..i)
		end
end
end
function modifier_angel_halo_stage_9_alt:StopAllMusic2()
	if IsServer() then
		


		  for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		for i = 1, 2  do
			StopGlobalSound("star.event_"..i)
		end
		for i = 1, 6  do
			StopGlobalSound("star.horn_"..i)
		end
		for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)

		

		
	end
end
end

function modifier_angel_halo_stage_9_alt:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end

function modifier_angel_halo_stage_9_alt:GetModifierPreAttack_BonusDamage()
    return 700
end

function modifier_angel_halo_stage_9_alt:GetTexture()
	return "angel_halo"
end
function modifier_angel_halo_stage_9_alt:GetEffectName()
	return "particles/halo_stage_9_alt.vpcf"
end

function modifier_angel_halo_stage_9_alt:GetModifierBonusStats_Strength()
    return 15
end

function modifier_angel_halo_stage_9_alt:GetModifierBonusStats_Agility()
    return 15
end

function modifier_angel_halo_stage_9_alt:GetModifierBonusStats_Intellect()
    return 15
end
function modifier_angel_halo_stage_9_alt:OnTakeDamage(keys)
	if not IsServer() then return end
	
	local attacker = keys.attacker
	local target = keys.unit
	local original_damage = keys.original_damage
	local damage_type = keys.damage_type
	local damage_flags = keys.damage_flags
	if keys.unit == self:GetParent() and not keys.attacker:IsBuilding() and not keys.attacker:IsMagicImmune() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then	
		if not keys.unit:IsOther() then
			local damageTable = {
				victim			= keys.attacker,
				damage			= keys.original_damage * 0.5,
				damage_type		= keys.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker		= self:GetParent(),
				ability			= self:GetAbility()
			}
			ApplyDamage(damageTable)
		end
	end
end




modifier_halo_heaven = class({})

--------------------------------------------------------------------------------

function modifier_halo_heaven:IsDebuff()
	return true
end

function modifier_halo_heaven:IsStunDebuff()
	return true
end
function modifier_halo_heaven:OnDestroy()
local caster = self:GetCaster()
local hp = self:GetParent():GetMaxHealth()
local current_hp = self:GetParent():GetHealth()
local hp_life = hp * 0.3

local hp_kill = hp - current_hp

if current_hp < hp_life then

self:GetParent():Kill(self, caster)
end
self.damage = 2000	
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	ApplyDamage( damageTable )
self:PlayEffects()

end

--------------------------------------------------------------------------------

function modifier_halo_heaven:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_halo_heaven:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_halo_heaven:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_halo_heaven:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_halo_heaven:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_halo_heaven:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/halo_ascend_end.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end



modifier_angel_halo_stage_10_invul = class({})
function modifier_angel_halo_stage_10_invul:IsHidden() return false end
function modifier_angel_halo_stage_10_invul:IsDebuff() return true end
function modifier_angel_halo_stage_10_invul:IsPurgable() return false end
function modifier_angel_halo_stage_10_invul:IsPurgeException() return false end
function modifier_angel_halo_stage_10_invul:RemoveOnDeath() return true end
function modifier_angel_halo_stage_10_invul:CheckState()
	local state = {

	
		
	}

	return state
end
function modifier_angel_halo_stage_10_invul:OnCreated()
if IsServer() then
local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then
		self.screw_fx = 	ParticleManager:CreateParticle("particles/halo_stage_10_true_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			self.screw_fx2 = 	ParticleManager:CreateParticle("particles/test_10_halo_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())					
		else
self.screw_fx = 	ParticleManager:CreateParticle("particles/halo_stage_10_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
					
       
    end
	end
end
function modifier_angel_halo_stage_10_invul:OnDestroy()
local caster = self:GetCaster()
if self.screw_fx then
	    ParticleManager:DestroyParticle(self.screw_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx)
		end
		if self.screw_fx2 then
	  ParticleManager:DestroyParticle(self.screw_fx2, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx2)
end

	self:PlayEffects()
	
end


function modifier_angel_halo_stage_10_invul:PlayEffects()
	-- get resources
	local particle_cast = "particles/halo_stage_10_explosion.vpcf"
	local sound_cast = "halo.explosion"

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.reincarnate_time, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end






modifier_warning_3rd_level = class({})

--------------------------------------------------------------------------------

function modifier_warning_3rd_level:IsHidden()
    return false
end

function modifier_warning_3rd_level:IsPurgable()
    return false
end
function modifier_warning_3rd_level:OnCreated()

	self:PlayEffects()
end

--------------------------------------------------------------------------------


function modifier_warning_3rd_level:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/halo_warning.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end


modifier_angel_halo_stage_10 = class({})
function modifier_angel_halo_stage_10:IsHidden() return false end
function modifier_angel_halo_stage_10:IsDebuff() return true end
function modifier_angel_halo_stage_10:IsPurgable() return false end
function modifier_angel_halo_stage_10:IsPurgeException() return false end
function modifier_angel_halo_stage_10:RemoveOnDeath() return true end
function modifier_angel_halo_stage_10:AllowIllusionDuplicate() return false end

function modifier_angel_halo_stage_10:DeclareFunctions()
    local func = {  
	                MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
					MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					MODIFIER_EVENT_ON_ATTACK_LANDED,
                    				}
    return func
end

function modifier_angel_halo_stage_10:GetModifierPreAttack_BonusDamage()
    return 1000
end


function modifier_angel_halo_stage_10:GetModifierBonusStats_Strength()
    return 60
end

function modifier_angel_halo_stage_10:GetModifierBonusStats_Agility()
    return 60
end

function modifier_angel_halo_stage_10:GetModifierBonusStats_Intellect()
    return 60
end

function modifier_angel_halo_stage_10:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 20
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if self:RollChance( self.crit_chance ) then
			self.record = params.record
			local damageTable = {
		attacker = self:GetParent(),
		damage = 800,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
	}
	damageTable.victim = params.target
	params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1.5 })
		ApplyDamage(damageTable)
			end
		end
	end
	end
end

function modifier_angel_halo_stage_10:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then
		self:PlayEffects2( params.target )
		else
			self:PlayEffects( params.target )
			end
		end
	end
end
--------------------------------------------------------------------------------
-- Helper
function modifier_angel_halo_stage_10:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end
function modifier_angel_halo_stage_10:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/halo_stage_10_true_crit.vpcf"
	local sound_cast = "halo.death"

	-- if target:IsMechanical() then
	-- 	particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
	-- 	sound_cast = "Hero_PhantomAssassin.CoupDeGrace.Mech"
	-- end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_angel_halo_stage_10:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/halo_stage_10_crit.vpcf"
	local sound_cast = "halo.death"

	-- if target:IsMechanical() then
	-- 	particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
	-- 	sound_cast = "Hero_PhantomAssassin.CoupDeGrace.Mech"
	-- end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end

function modifier_angel_halo_stage_10:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
self.crit_chance = 10
self.crit_bonus = 300
    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
		local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then
		  EmitGlobalSound("halo.theme4_true")
		 if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/halo_stage_10_true_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
		else
		  EmitGlobalSound("halo.theme4")
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/halo_stage_10_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
		end

      
		
		
      
		
		end
        
self:StartIntervalThink(0.5)
        self.parent:Purge(false, true, false, true, true)
    end

function modifier_angel_halo_stage_10:OnIntervalThink()
	local caster = self:GetCaster()
	local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then
		
		StopGlobalSound("halo.theme4")
			for i = 1, 3 do
			StopGlobalSound("halo.theme3_"..i)
		end
		  for i = 1, 10  do
			StopGlobalSound("star.theme3_"..i)
		end
			 StopGlobalSound("star.horn_unknown")
		else
		end
		for i = 1, 4 do
			StopGlobalSound("halo.theme2_"..i)
		end
			 for i = 1, 5  do
			StopGlobalSound("halo.theme_"..i)
		end
	
        for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		 for i = 1, 2  do
			StopGlobalSound("star.event_"..i)
		end
	for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)
			end
		for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		for i = 1, 5 do
			StopGlobalSound("star.horn_"..i)
		end
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
		
			StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
end


function modifier_angel_halo_stage_10:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_angel_halo_stage_10:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
           
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

             self.ability = self:GetAbility()
	self.ability:EndCooldown()
	 self.ability:StartCooldown(140)
local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440
		if id32 == arcana then
		 StopGlobalSound("halo.theme4_true")
else		
 StopGlobalSound("halo.theme4")
          
            end
			end
        end
   
   
   
   
   
modifier_angel_halo_start = class({})


function modifier_angel_halo_start:IsHidden()
    return true
end
function modifier_angel_halo_start:RemoveOnDeath() return true end
function modifier_angel_halo_start:IsPurgable()
    return false
end


modifier_alice = class({})


function modifier_alice:IsHidden()
    return true
end
function modifier_alice:RemoveOnDeath() return true end
function modifier_alice:IsPurgable()
    return false
end

modifier_alice_8 = class({})


function modifier_alice_8:IsHidden()
    return true
end
function modifier_alice_8:RemoveOnDeath() return true end
function modifier_alice_8:IsPurgable()
    return false
end






modifier_halo_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_halo_attack:IsHidden()
	return true
end
function modifier_halo_attack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_halo_attack:OnCreated( kv )
	-- references
	self.base_damage = 50	
	self.attack_factor = 100
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_halo_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

	}

	return funcs
end

function modifier_halo_attack:GetModifierDamageOutgoing_Percentage( params )
	if IsServer() then
		return self.attack_factor
	end
end
function modifier_halo_attack:GetModifierPreAttack_BonusDamage( params )
	if IsServer() then
		-- base damage will get reduced, so multiply it by its inverse
		return 500
	end
end



modifier_stack_cd = class({})


function modifier_stack_cd:IsHidden()
    return true
end
function modifier_stack_cd:RemoveOnDeath() return true end
function modifier_stack_cd:IsPurgable()
    return false
end






modifier_lust_awaken = class({})


function modifier_lust_awaken:IsHidden()
    return false
end
function modifier_lust_awaken:RemoveOnDeath() 
return false 
end
function modifier_lust_awaken:IsPurgable()
    return false
end



modifier_lust_armor_sealed = class({})
function modifier_lust_armor_sealed:RemoveOnDeath()
	return true
end
function modifier_lust_armor_sealed:IsHidden()
	return false
end

function modifier_lust_armor_sealed:IsPurgable()
	return false
end
function modifier_lust_armor_sealed:OnCreated()
    if not IsServer() then return end
    self.carapaced_units = {}
    self.caster_stun = true
	self:StartIntervalThink(2)
	
	if IsServer() then
		self:StopAllMusic()
		StopGlobalSound("spamton.neo_theme")
		StopGlobalSound("halo.lust_1")
			for i = 1, 40 do
			StopGlobalSound("star.theme3_"..i)
			end
			for i = 1, 3 do
			StopGlobalSound("halo.theme3_"..i)
		end
	end
	EmitGlobalSound("halo.lust_1")
end
function modifier_lust_armor_sealed:OnDestroy()

	StopGlobalSound("halo.lust_1")
	 self.ability = self:GetAbility()
	
	self.ability:EndCooldown()
	 self.ability:StartCooldown(80)	
	
end
function modifier_lust_armor_sealed:OnIntervalThink()
	if IsServer() then
		self:StopAllMusic2()
		self:StopAllMusic()
	end
end
function modifier_lust_armor_sealed:StopAllMusic()
	if IsServer() then
		
StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
		for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
	
	for i = 1, 4 do
			StopGlobalSound("halo.theme2_"..i)
		end
		for i = 1, 2 do
			StopGlobalSound("halo.theme3_"..i)
		end
			 for i = 1, 5  do
			StopGlobalSound("halo.theme_"..i)
		end
end
end
function modifier_lust_armor_sealed:StopAllMusic2()
	if IsServer() then
		


		  for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		for i = 1, 2  do
			StopGlobalSound("star.event_"..i)
		end
		for i = 1, 6  do
			StopGlobalSound("star.horn_"..i)
		end
		for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)

		

		
	end
end
end
function modifier_lust_armor_sealed:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end
function modifier_lust_armor_sealed:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 20
	local caster = self:GetCaster()
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			if not params.attacker:HasModifier("modifier_angel_halo_cd") then
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_angel_halo_cd", {duration = 2.0 })
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1.5 })
			self:PlayEffects(params.target)
		self:GetParent():EmitSound("halo.lust_slash")
		self:GetParent():Heal(params.damage,caster)
			end
			end
		end
	end
	end
end
function modifier_lust_armor_sealed:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/dark_armor_kill.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_lust_armor_sealed:GetModifierPreAttack_BonusDamage()
    return 800
end

function modifier_lust_armor_sealed:GetTexture()
	return "angel_halo"
end
function modifier_lust_armor_sealed:GetEffectName()
	return "particles/halo_lust_armor_sealed.vpcf"
end

function modifier_lust_armor_sealed:GetModifierBonusStats_Strength()
    return 35
end

function modifier_lust_armor_sealed:GetModifierBonusStats_Agility()
    return 35
end

function modifier_lust_armor_sealed:GetModifierBonusStats_Intellect()
    return 35
end

modifier_lust_armor_invul = class({})
function modifier_lust_armor_invul:IsHidden() return false end
function modifier_lust_armor_invul:IsDebuff() return true end
function modifier_lust_armor_invul:IsPurgable() return false end
function modifier_lust_armor_invul:IsPurgeException() return false end
function modifier_lust_armor_invul:RemoveOnDeath() return true end
function modifier_lust_armor_invul:CheckState()
	local state = {
	
		
		
	}

	return state
end
function modifier_lust_armor_invul:OnCreated()
if IsServer() then
local player = self:GetCaster()

self.screw_fx = 	ParticleManager:CreateParticle("particles/halo_lust_armor_awaken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
					
       end
    
	
end
function modifier_lust_armor_invul:OnDestroy()
local caster = self:GetCaster()
if self.screw_fx then
	    ParticleManager:DestroyParticle(self.screw_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx)
		end
		if self.screw_fx2 then
	  ParticleManager:DestroyParticle(self.screw_fx2, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx2)
end


	
end





modifier_lust_armor_awakened = class({})
function modifier_lust_armor_awakened:RemoveOnDeath()
	return true
end
function modifier_lust_armor_awakened:IsHidden()
	return false
end

function modifier_lust_armor_awakened:IsPurgable()
	return false
end
function modifier_lust_armor_awakened:OnCreated()
    if not IsServer() then return end
    self.carapaced_units = {}
    self.caster_stun = true
	self:StartIntervalThink(2)
	
	if IsServer() then
		self:StopAllMusic()
		StopGlobalSound("halo.lust_2")
		StopGlobalSound("spamton.neo_theme")
			for i = 1, 40 do
			StopGlobalSound("star.theme3_"..i)
			end
			for i = 1, 3 do
			StopGlobalSound("halo.theme3_"..i)
		end
	end
	EmitGlobalSound("halo.lust_2")
end
function modifier_lust_armor_awakened:OnDestroy()

	StopGlobalSound("halo.lust_2")
	 self.ability = self:GetAbility()
	
	self.ability:EndCooldown()
	 self.ability:StartCooldown(80)	
	
end
function modifier_lust_armor_awakened:OnIntervalThink()
	if IsServer() then
		self:StopAllMusic2()
		self:StopAllMusic()
	end
end
function modifier_lust_armor_awakened:StopAllMusic()
	if IsServer() then
		
StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
		for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
	
	for i = 1, 4 do
			StopGlobalSound("halo.theme2_"..i)
		end
			for i = 0, 1 do
			StopGlobalSound("halo.lust_"..i)
		end
		for i = 1, 2 do
			StopGlobalSound("halo.theme4_"..i)
		end
		for i = 1, 2 do
			StopGlobalSound("halo.theme3_"..i)
		end
			 for i = 1, 5  do
			StopGlobalSound("halo.theme_"..i)
		end
end
end
function modifier_lust_armor_awakened:StopAllMusic2()
	if IsServer() then
		


		  for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		for i = 1, 2  do
			StopGlobalSound("star.event_"..i)
		end
		for i = 1, 6  do
			StopGlobalSound("star.horn_"..i)
		end
		for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)

		

		
	end
end
end
function modifier_lust_armor_awakened:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end
function modifier_lust_armor_awakened:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 25
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 2.0 })
			self:PlayEffects(params.target)
		self:GetParent():EmitSound("halo.lust_slash")
		self:GetParent():Heal(params.damage,self)
			end
			end
		end
	end
	end
function modifier_lust_armor_awakened:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/dark_armor_kill_awakened.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_lust_armor_awakened:GetModifierPreAttack_BonusDamage()
    return 1500
end

function modifier_lust_armor_awakened:GetTexture()
	return "angel_halo"
end
function modifier_lust_armor_awakened:GetEffectName()
	return "particles/halo_lust_armor_awakened.vpcf"
end

function modifier_lust_armor_awakened:GetModifierBonusStats_Strength()
    return 100
end

function modifier_lust_armor_awakened:GetModifierBonusStats_Agility()
    return 100
end

function modifier_lust_armor_awakened:GetModifierBonusStats_Intellect()
    return 100
end
