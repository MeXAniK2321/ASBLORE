kiana_combo_hit = class({})
LinkLuaModifier( "modifier_kiana_combo_hit", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "modifiers/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_kiana_combo_hit_2nd", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_basic_combo_2", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_basic_combo_3", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_nyan_nyan", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_basic_combo_4", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_basic_combo_5", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_basic_combo_4_punches", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_kiana_air_combo", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_finality_invul_combo", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_finality_double_slash", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_kiana_talent_bkb", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_basic_combo_grenade_speacial", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kiana_weapon_skill_slow", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kiana_weapon_skill_exp", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drifter_slashes", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kiana_talent_bkb_cd", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )



function kiana_combo_hit:GetCastRange( location , target)
if IsServer() then
local mod = self:GetCaster():FindModifierByName("modifier_nyan_nyan") 
if mod then
local stack = mod:GetStackCount()
if stack == 1 then
		return  self:GetSpecialValueFor("cast_range")
		else
		return 700
		end
	end
	return self:GetSpecialValueFor("cast_range")
	end
end





function kiana_combo_hit:GetIntrinsicModifierName()
    return "modifier_nyan_nyan"
end
--------------------------------------------------------------------------------
-- Ability Start
function kiana_combo_hit:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	local target = self:GetCursorTarget()
	--if not caster:HasModifier("modifier_kiana_talent_bkb_cd") then
	-- caster:AddNewModifier(caster, self, "modifier_kiana_talent_bkb", {duration = 0.5})
	 	-- caster:AddNewModifier(caster, self, "modifier_kiana_talent_bkb_cd", {duration = 5})
		-- end
	 --end
	self.damage = self:GetSpecialValueFor("base_damage")
	self.attack_scale = self:GetSpecialValueFor("attack_scale")

--	self.radius = self:GetSpecialValueFor("radius")
	--end
	--if caster:HasTalent("special_bonus_kiana_20") then
	--target:AddNewModifier(caster, self, "modifier_stunned", {duration = 0.5})
	--end
	if caster:HasModifier("modifier_core_upgrade_3") then
	self:FinalityCombo(target)
	elseif caster:HasModifier("modifier_core_upgrade_2") then
	self:FlameshionCombo(target)
	elseif caster:HasModifier("modifier_upgrade_core") then
	self:DrifterCombo(target)
	elseif caster:HasModifier("modifier_sirin_awakening") then
	self:SirinCombo(target)
    else
	self:BasicCombo(target)
	
	end

end
---------------------------------------------------------
--FinalityCombo
---------------------------------------------------------
function kiana_combo_hit:FinalityCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()

	
-- target:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.6})

	local mod = caster:FindModifierByName("modifier_nyan_nyan")
	local stack = mod:GetStackCount()
 if stack == 1 then
 	EmitSoundOn("finality.1",caster)
self:FinalityCombo1(target)
mod:SetStackCount(2)
elseif stack == 4 then
for i = 1, 5 do
	local delay = (i * 0.15)  

	Timers:CreateTimer(delay,function()
self:FinalityCombo2(target)
end)
end

mod:SetStackCount(5)
self:EndCooldown()
elseif stack == 5 then
self:FinalityCombo3(target)
mod:SetStackCount(1)
if self:GetCaster():HasTalent("special_bonus_kiana_25_alt") then
self:EndCooldown()
end
elseif stack == 6 then
for i = 1, 10 do
	local delay = (i * 0.13)  
	Timers:CreateTimer(delay,function()
self:FinalityCombo4(target)
end)
mod:SetStackCount(7)
end
else
	EmitSoundOn("finality.1",caster)
self:FinalityCombo1(target)
end
end
		



function kiana_combo_hit:FinalityCombo1(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.fast_slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.08,
                        duration = 0.08,
                        knockback_distance = 70,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + (scale * 0.5)
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
					self:PlayEffects_smashFinality(target)

local delay = 0.1

	Timers:CreateTimer(delay,function()
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.fast_slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )


	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.05,
                        duration = 0.05,
                        knockback_distance = 70,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
			--caught = true
			-- play effects
				self:PlayEffects_smashFinality(target)
	end)
end

function kiana_combo_hit:FinalityCombo2(target)
local caster = self:GetCaster()


	local blinkPosition = target:GetAbsOrigin() + RandomVector(400)


	-- Blink
	caster:SetOrigin( blinkPosition )
	self:PlayEffects_blink()
caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
	self.max_riko = 6
	self.riko = 0
local index = self:GetUniqueInt()
	EmitSoundOn("kiana.3", caster)
local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/kiana_final_bullets.vpcf",
						iMoveSpeed = 1000,
						bDodgeable = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
ExtraData = {
			index = index,
		}
						}
						
						

	ProjectileManager:CreateTrackingProjectile(projectile)
	local data = {}
	data.jump = 0
	data.hit_units = {}

	data.jumps = 10
	data.radius = 600
	data.projectile_info = projectile
	self.projectiles[index] = data

end
function kiana_combo_hit:FinalityCombo3(target)
local caster = self:GetCaster()
local origin = target:GetOrigin()
	EmitSoundOn("finality.3",caster)
	EmitSoundOn("sirin.fingersnap",caster)

	local origin = target:GetOrigin()
	self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_finality_exp_thinker", -- modifier name
		{ duration = 0.49 }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	
end

function kiana_combo_hit:PlayEffectsBlur( origin )

	local particle_cast = "particles/vergil_blur.vpcf"
local radius = 555
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

function kiana_combo_hit:FinalityCombo4(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + RandomVector(300)

	EmitSoundOn("kiana.hits",caster)
	-- Blink
		target:SetOrigin( blinkPosition )
		FindClearSpaceForUnit( target, blinkPosition, true )
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
		
 
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = RandomInt(-40,40),
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects_smashFinality(target)


end
function kiana_combo_hit:FinalityCombo5(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_NECRO_GHOST_SHROUD)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
		
 
			local knockback = { should_stun = 0,
                        knockback_duration = 0.3,
                        duration = 0.3,
                        knockback_distance = 200,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 2
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffectsFinalityEXP(target)


end
function kiana_combo_hit:PlayEffects_smashFinality( target )

	local particle_cast = "particles/kiana_star_hit.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 400, 400, 400) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function kiana_combo_hit:PlayEffectsFinalityEXP( target )

	local particle_cast = "particles/halo_7_exp3.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 400, 400, 400) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

-------------------------------------------------------------------
--FlameshionCombo
---------------------------------------------------------
function kiana_combo_hit:FlameshionCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	-- caster:AddNewModifier(caster, self, "modifier_generic_silenced_lua", {duration = 1.0})
 --target:AddNewModifier(caster, self, "modifier_stunned", {duration = 2.1})
	local mod = caster:FindModifierByName("modifier_nyan_nyan")
	local stack = mod:GetStackCount()
	 if stack == 1 then
	 	EmitSoundOn("flameshion.1",caster)
	 mod:SetStackCount(2)
self:FlameshionCombo1(target)
elseif stack == 4 then
	for i = 1, 5 do
	local delay = ((i + 0.01) * 0.15)  

	Timers:CreateTimer(delay,function()
self:FlameshionCombo2(target)
end)
end
mod:SetStackCount(5)
self:EndCooldown()
elseif stack == 5 then
self:FlameshionCombo3(target)
mod:SetStackCount(1)
if self:GetCaster():HasTalent("special_bonus_kiana_25_alt") then
self:EndCooldown()
end
elseif stack == 6 then
	for i = 1, 5 do
	local delay = ((i + 0.01) * 0.15)  

	Timers:CreateTimer(delay,function()
self:FlameshionCombo4(target)

end)
mod:SetStackCount(7)
end
else
	EmitSoundOn("flameshion.1",caster)
self:FlameshionCombo1(target)
end


			--for i = 1, 10 do
	--local delay = 0.4 + (i * 0.07)  

	--Timers:CreateTimer(delay,function()
	--self:FlameshionCombo4(target) -- Multiple hits aie
	--end)
	--end
end





function kiana_combo_hit:FlameshionCombo1(target)
print("fs1_b")
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.08,
                        duration = 0.08,
                        knockback_distance = 100,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)
				
				
				
				self:PlayEffects_slash_flameshion1(target:GetOrigin(),target)
	local delay = 0.15
local attack = caster:GetAverageTrueAttackDamage(target)
	Timers:CreateTimer(delay,function()
				
				local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_COLD_SNAP)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.08,
                        duration = 0.08,
                        knockback_distance = 100,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)

end)

end
function kiana_combo_hit:PlayEffects_CubeSmash(target)
	-- Get Resources
	local particle_cast = "particles/test_cube_smash.vpcf"
	self.parent_origin = target:GetOrigin()
	self.delay = 0.4

	-- Get Data
	local h1 = 800
	local h2 = -800
	local h0 = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, h1, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, h0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

local effect_cast2 = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast2, 0, self.parent_origin + Vector( 0, h2, 0 ) )
	ParticleManager:SetParticleControl( effect_cast2, 1, self.parent_origin + Vector( 0, h0, 0) )
	ParticleManager:SetParticleControl( effect_cast2, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast2 )
	
end

function kiana_combo_hit:FlameshionCombo2(target)
print("fs2_b")
local caster = self:GetCaster()


	local blinkPosition = target:GetAbsOrigin() + RandomVector(400)


	-- Blink
	caster:SetOrigin( blinkPosition )
	self:PlayEffects_blink()
caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
	self.max_riko = 3
	self.riko = 0
local index = self:GetUniqueInt()
	EmitSoundOn("kiana.mini_slash", caster)
local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/test_kiana_air_slash1.vpcf",
						iMoveSpeed = 800,
						bDodgeable = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
ExtraData = {
			index = index,
		}
						}
						
						

	ProjectileManager:CreateTrackingProjectile(projectile)
	local data = {}
	data.jump = 0
	data.hit_units = {}

	data.jumps = 10
	data.radius = 600
	data.projectile_info = projectile
	self.projectiles[index] = data
	
		end




function kiana_combo_hit:FlameshionCombo3(target)
print("fs3_b")
local caster = self:GetCaster()
local origin = target:GetOrigin()
	EmitSoundOn("flameshion.3",caster)
	EmitSoundOn("sirin.fingersnap",caster)

	self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_flameshion_exp_thinker", -- modifier name
		{ duration = 0.49 }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	end
	
	function kiana_combo_hit:FlameshionCombo4(target)
	print("fsU_b")
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 1,
                        knockback_duration = 0.08,
                        duration = 0.08,
                        knockback_distance = RandomInt(-150,150),
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
if target:HasModifier("modifier_kiana_air_combo") and not caster:HasModifier("modifier_kiana_air_combo") then
target:AddNewModifier(caster, self, "modifier_kiana_air_combo", {duration = 1})
   caster:AddNewModifier(caster, self, "modifier_kiana_air_combo", {duration = 1})
   end
   target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 1
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects_crit(target)
	EmitSoundOn("kiana.hits",caster)

end
function kiana_combo_hit:PlayEffects_crit( target )
	-- Load effects
	local particle_cast = "particles/test_kiana_multiple_hits.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_combo_hit:PlayEffects_slash_flameshion1( origin, target )
	-- Get Resources
	local particle_cast = "particles/kiana_slash_flameshion.vpcf"
	local sound_start = "kiana.void_slash"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )


	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	--EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end
function kiana_combo_hit:PlayEffects_smash( target )

	local particle_cast = "particles/kiana_flameshion_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 400, 400, 400) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
-------------------------------------------------------------------------
--DrifterCombo
-------------------------------------------------------------------------
function kiana_combo_hit:DrifterCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	
		-- caster:AddNewModifier(caster, self, "modifier_generic_silenced_lua", {duration = 1.0})
 --target:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.0})
 
 		local mod = caster:FindModifierByName("modifier_nyan_nyan")
	local stack = mod:GetStackCount()
	
	 if stack == 1 then
	 EmitSoundOn("kiana.drifter_1",caster)
self:DrifterCombo1(target)
mod:SetStackCount(2)
elseif stack == 4 then
self:DrifterCombo2(target)
mod:SetStackCount(5)
self:EndCooldown()
elseif stack == 5 then
self:DrifterCombo3(target)
mod:SetStackCount(1)
if self:GetCaster():HasTalent("special_bonus_kiana_25_alt") then
self:EndCooldown()
end
elseif stack == 6 then
self:DrifterCombo4(target)
mod:SetStackCount(7)
else
EmitSoundOn("kiana.drifter_1",caster)
self:DrifterCombo1(target)
end
 
end



function kiana_combo_hit:DrifterCombo2(target)
local caster = self:GetCaster()
local blinkDistance = 400
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + RandomVector(400)

--	EmitSoundOn("kiana.slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK)

	self.max_riko = 11
	self.riko = 0
local index = self:GetUniqueInt()
	EmitSoundOn("kiana.3", caster)

	local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/kiana_bullet.vpcf",
						iMoveSpeed = 900,
						bDodgeable = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
ExtraData = {
			index = index,
		}
						}
						
						

	ProjectileManager:CreateTrackingProjectile(projectile)
	local data = {}
	data.jump = 0
	data.hit_units = {}

	data.jumps = 10
	data.radius = 600
	data.projectile_info = projectile
	self.projectiles[index] = data
	
	local delay = 0.2

	Timers:CreateTimer(delay,function()
	local caster = self:GetCaster()
local blinkDistance = 400
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + RandomVector(400)

--	EmitSoundOn("kiana.slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK)

	self.max_riko = 11
	self.riko = 0
local index = self:GetUniqueInt()
	EmitSoundOn("kiana.3", caster)

	local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/kiana_bullet.vpcf",
						iMoveSpeed = 900,
						bDodgeable = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
ExtraData = {
			index = index,
		}
						}
						
						

	ProjectileManager:CreateTrackingProjectile(projectile)
	local data = {}
	data.jump = 0
	data.hit_units = {}

	data.jumps = 10
	data.radius = 600
	data.projectile_info = projectile
	self.projectiles[index] = data
	end)
	local delay = 0.45

	Timers:CreateTimer(delay,function()
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 1,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 150,
                        knockback_height = 200,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects_crit(target)
	EmitSoundOn("kiana.slash_hit",caster)
	
	end)
	end
function kiana_combo_hit:DrifterCombo3(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("sirin.exp",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
	
caster:StartGesture(ACT_DOTA_CAST_CHAOS_METEOR)

	local delay = 0.3

	Timers:CreateTimer(delay,function()
	local knockback = { should_stun = 1,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 200,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }


		-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = (caster:GetAverageTrueAttackDamage(target) * self.attack_scale) * 2,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
		-- silence
	
		
	end

end)
end


function kiana_combo_hit:DrifterCombo4(target)
local caster = self:GetCaster()
   caster:AddNewModifier(caster, self, "modifier_drifter_slashes", {duration = 1})

end

function kiana_combo_hit:DrifterCombo1(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 1,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 100,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)


end




--------------------------------------------------------------------------------
function kiana_combo_hit:PlayEffects_slash( origin, target )
	-- Get Resources
	local particle_cast = "particles/kiana_void_slash.vpcf"
	local sound_start = "kiana.void_slash"
	local sound_end = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

function kiana_combo_hit:PlayEffects_slash2( target )
	-- Get Resources
	local particle_cast = "particles/void_spirit_astral_step_impact1.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


------------------------------------------------------------
--Void Form Combo
-------------------------------------------------------------
function kiana_combo_hit:SirinCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	EmitSoundOn("sirin.1",caster)
		EmitSoundOn("kiana.spear_throw",caster)
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/kiana_void_spear.vpcf",
						iMoveSpeed = 1400,
						bDodgeable = true,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false }

	ProjectileManager:CreateTrackingProjectile(projectile)
	self.sirin_b1 = 0
	end
	
	
	
function kiana_combo_hit:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		return nil
	end

local caster = self:GetCaster()

		EmitSoundOn("kiana.spear_throw_impact",target)

	if self:GetCaster() then
		--hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")})
		end
		local scale = caster:GetAverageTrueAttackDamage(hTarget) * self.attack_scale


	local damage_table = {	victim = hTarget,
							attacker = self:GetCaster(),
							damage = (self:GetSpecialValueFor("damage") * 0.2) + (scale * 0.2),
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
	if self.sirin_b1 ==0 then
	self:SirinCombo2(hTarget)
	self.sirin_b1 = 1 end
end
	
function kiana_combo_hit:SirinCombo2(target)
local caster = self:GetCaster()
for i = 1, 10 do
local delay = 0.1 + (i * 0.1)
	Timers:CreateTimer(delay,function()
	self:SpearThrow(target)
end)
end
local delay = 1.2
	Timers:CreateTimer(delay,function()
	self:SirinCombo3(target)
	end)
	
end

function kiana_combo_hit:SpearThrow(target)
local caster = self:GetCaster()
local rng = target:GetAbsOrigin() + RandomVector(600)
local direction = target:GetOrigin() - rng
	local projectile_direction = direction:Normalized()
	local speed = 1400
local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = rng,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "particles/kiana_multiple_spears.vpcf",
	    fDistance = 1000,
	    fStartRadius = 150,
	    fEndRadius = 150,
		vVelocity = projectile_direction * speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)
EmitSoundOn("kiana.spear_throw_impact",target)
end	


function kiana_combo_hit:SirinCombo3(target)
local caster = self:GetCaster()
self:PlayEffects_Cube(target:GetOrigin())
	-- precache
local delay = 0.5
	Timers:CreateTimer(delay,function()
		local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
			local knockback = { should_stun = 1,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 0,
                        knockback_height = -200,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 3
damageTable.victim = target
		ApplyDamage(damageTable)
			EmitSoundOn("kiana.ground_shake",target)
			-- play effects
				end)



end
function kiana_combo_hit:PlayEffects_Cube(origin)
	-- Get Resources
	local particle_cast = "particles/kiana_cube_falling.vpcf"
	self.parent_origin =  origin
	self.delay = 0.5

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end


function kiana_combo_hit:PlayEffects_exp(origin)
	-- Get Resources
	local particle_cast = "particles/kiana_weapon_exp.vpcf"
	self.parent_origin =  origin
	self.delay = 0.5

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )


	-- Create Sound
	
end










-------------------------------------------------	
-------------------------------------------------
--Base Form Combo
-------------------------------------------------	
function kiana_combo_hit:BasicCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	
		local mod = caster:FindModifierByName("modifier_nyan_nyan")
	local stack = mod:GetStackCount()
	
		-- caster:AddNewModifier(caster, self, "modifier_generic_silenced_lua", {duration = 1.4})
-- target:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.5})
 if stack == 1 then
self:BasicCombo1(target)
mod:SetStackCount(2)
elseif stack == 4 then
self:BasicCombo2(target)
mod:SetStackCount(5)
self:EndCooldown()
elseif stack == 5 then
self:BasicCombo3(target)
mod:SetStackCount(1)
if self:GetCaster():HasTalent("special_bonus_kiana_25_alt") then
self:EndCooldown()
end
elseif stack == 6 then
mod:SetStackCount(7)
self:BasicCombo4(target)
else
self:BasicCombo1(target)
end
end

function kiana_combo_hit:BasicCombo1(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
EmitSoundOn("kiana.1",caster)
EmitSoundOn("kiana.hits",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 80,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)
		local delay = 0.21

	Timers:CreateTimer(delay,function()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
			local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 100,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)

		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
				self:PlayEffects(target)
			EmitSoundOn("kiana.hits",target)
	end)


end

function kiana_combo_hit:BasicCombo2(target)
local caster = self:GetCaster()


	local blinkPosition = target:GetAbsOrigin() + RandomVector(400)


	-- Blink
	caster:SetOrigin( blinkPosition )
	self:PlayEffects_blink()
caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
	self.max_riko = 3
	self.riko = 0
local index = self:GetUniqueInt()
	EmitSoundOn("kiana.3", caster)
local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/kiana_bullet.vpcf",
						iMoveSpeed = 1000,
						bDodgeable = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
ExtraData = {
			index = index,
		}
						}
						
						

	ProjectileManager:CreateTrackingProjectile(projectile)
	local data = {}
	data.jump = 0
	data.hit_units = {}

	data.jumps = 10
	data.radius = 600
	data.projectile_info = projectile
	self.projectiles[index] = data
	local delay = 0.15
	Timers:CreateTimer(delay,function()
	
	
	local blinkPosition = target:GetAbsOrigin() + RandomVector(400)


	-- Blink
	caster:SetOrigin( blinkPosition )
	self:PlayEffects_blink()
caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
	self.max_riko = 3
	self.riko = 0
local index = self:GetUniqueInt()
	EmitSoundOn("kiana.3", caster)
local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/kiana_bullet.vpcf",
						iMoveSpeed = 1000,
						bDodgeable = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
ExtraData = {
			index = index,
		}
						}
						
						

	ProjectileManager:CreateTrackingProjectile(projectile)
	local data = {}
	data.jump = 0
	data.hit_units = {}

	data.jumps = 10
	data.radius = 600
	data.projectile_info = projectile
	self.projectiles[index] = data
	
	end)
		end




kiana_combo_hit.projectiles = {}
function kiana_combo_hit:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
local data = self.projectiles[ ExtraData.index ]
local caster = self:GetCaster()
local target = hTarget
	if not hTarget then
		return nil
	end

	if hTarget:IsMagicImmune() then
		return nil
	end
	
	if hTarget:TriggerSpellAbsorb(self) then
		return nil
	end

	
	if target and (not target:IsMagicImmune()) and (not target:IsInvulnerable()) then
		-- mark as hit
		data.hit_units[target] = true
	
	if self:GetCaster():HasModifier("modifier_upgrade_core") then
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_kiana_weapon_skill_exp", {duration = 0.01})
end

--else
self.honkai = 0
--end
local attack = caster:GetAverageTrueAttackDamage(target) * (self.attack_scale * 0.15)
	local damage_table = {	victim = hTarget,
							attacker = self:GetCaster(),
							damage = (self:GetSpecialValueFor("damage") * 0.3) + attack,
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
		EmitSoundOn("kiana.spear_throw_impact", hTarget)
	if self:GetCaster() then
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_kiana_weapon_skill_slow", {duration = self:GetSpecialValueFor("duration")})
		end
		
		data.jump = data.jump + 1
		if data.jump>=data.jumps then
		self:Ended(data)
			return
		end
	end

	-- jump to nearby target
	local pos = vLocation
	if target then
		pos = target:GetOrigin()
	end

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		data.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- pick next target
	local next_target = nil
	for _,enemy in pairs(enemies) do

		-- check if it is already hit
		local found = false
		for unit,_ in pairs(data.hit_units) do
			if enemy==unit then
				found = true
				break
			end
		end

		if not found then
			next_target = enemy
			break
		end
	end

	-- not found
	if not next_target then
		-- return projectile without target
		self:Ended( data )
		return
	end

	-- create bounce projectile
	data.projectile_info.Target = next_target
	data.projectile_info.Source = target
	ProjectileManager:CreateTrackingProjectile( data.projectile_info )
end



function kiana_combo_hit:Ended( data )
	-- unregister projectile
	local index = data.projectile_info.ExtraData.index
	self.projectiles[ index ] = nil
	self:DelUniqueInt( index )

	
end

--Хули смотришь падла!
kiana_combo_hit.unique = {}
kiana_combo_hit.i = 0
kiana_combo_hit.max = 65536
function kiana_combo_hit:GetUniqueInt()
	while self.unique[ self.i ] do
		self.i = self.i + 1
		if self.i==self.max then self.i = 0 end
	end

	self.unique[ self.i ] = true
	return self.i
end
function kiana_combo_hit:DelUniqueInt( i )
	self.unique[ i ] = nil
end




function kiana_combo_hit:BasicCombo4(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

 EmitSoundOn("kiana.hits", caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK_SPECIAL)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 160,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)


local delay = 0.25
	Timers:CreateTimer(delay,function()

local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

 EmitSoundOn("kiana.hits", caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK_SPECIAL)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = -200,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)
			 end)
end






function kiana_combo_hit:BasicCombo3(target)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_AMBUSH)

	 EmitSoundOn("sirin.exp", caster)
	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	local knockback = { should_stun = 0,
                        knockback_duration = 0.3,
                        duration = 0.3,
                        knockback_distance = 150,
                        knockback_height =0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)

	target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_basic_combo_grenade_speacial", -- modifier name
			{ duration = 0.3 } -- kv
		)

	
			
	--target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = (caster:GetAverageTrueAttackDamage(target) * self.attack_scale) * 2.5
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)

		

	self:PlayEffects4(target)
end


----------------------------------------------------------
----------------------------------------------------------
function kiana_combo_hit:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/dev/library/base_dust_hit.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_combo_hit:PlayEffects3( target )
	-- Load effects
	local particle_cast = "particles/dev/library/base_dust_hit.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function kiana_combo_hit:PlayEffects4( target )
	-- Load effects
	local particle_cast = "particles/homura_grenade_explosion.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "kiana.exp", self:GetCaster() )
end
function kiana_combo_hit:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/kiana_upward_kick.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_combo_hit:PlayEffects_blink()
	-- Load effects
	local particle_cast = "particles/vergil_blur.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin():Normalized() ))
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
--------------------------------------------------------------------------------
-- Play Effects
function kiana_combo_hit:PlayEffects1( caught, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_combo_hit_start.vpcf"
	

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_combo_hit:PlayEffects22( caught, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_combo_hit_start.vpcf"
		

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end
function kiana_combo_hit:PlayEffects23( caught, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_combo_hit_2nd.vpcf"
	

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end

function kiana_combo_hit:PlayEffects63( caught, direction,origin )
	-- Get Resources
	local particle_cast = "particles/touma_3_alt_combo_2nd.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end








modifier_drifter_slashes = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_drifter_slashes:IsHidden()
	return false
end

function modifier_drifter_slashes:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_drifter_slashes:IsStunDebuff()
	return true
end

function modifier_drifter_slashes:IsPurgable()
	return true
end

function modifier_drifter_slashes:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_drifter_slashes:OnCreated( kv )
	-- references
	if IsServer() then
	self:StartIntervalThink(0.1)
	-- play effects
	self:GetParent():AddNoDraw()
	self:PlayEffects()
	self.attack_scale = self:GetAbility():GetSpecialValueFor("attack_scale")
	
end
end


function modifier_drifter_slashes:OnIntervalThink( kv )
	-- references
		if not IsServer() then return end
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = (caster:GetAverageTrueAttackDamage(enemy) * self.attack_scale) * 0.5,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	self:PlayEffects(enemy)

end
end

function modifier_drifter_slashes:OnRemoved()
end

function modifier_drifter_slashes:OnDestroy()
	if not IsServer() then return end

	-- play effects
	self:GetParent():RemoveNoDraw()

   
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_drifter_slashes:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end
function modifier_drifter_slashes:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/test_kiana_drifter_slashes.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_drifter_slashes:PlayEffects2()
	-- Get Resources
	local particle_cast1 = "particles/vergil_blur.vpcf"
	local particle_cast2 = ""
	--local sound_loop = "yukari.portal_out"

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
	--EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_loop, self:GetCaster() )
end



modifier_nyan_nyan = class ({})
function modifier_nyan_nyan:IsHidden() return true end
function modifier_nyan_nyan:IsDebuff() return false end
function modifier_nyan_nyan:IsPurgable() return false end
function modifier_nyan_nyan:IsPurgeException() return false end
function modifier_nyan_nyan:RemoveOnDeath() return false end

function modifier_nyan_nyan:OnCreated()
    if IsServer() then
    
self:SetStackCount(1)
      self.s1 = 0
	 -- self:StartIntervalThink(1)
    end
end
function modifier_nyan_nyan:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_nyan_nyan:OnIntervalThink()
if self:GetStackCount() == 1 then
self.s1 = 0 
return
end
if self.s1 == 6 then self:SetStackCount(1)
self.s1 = 0
return
end

local r22 = self.s1
self.s1 = r22 + 1
end


modifier_kiana_combo_hit = class({})
function modifier_kiana_combo_hit:IsHidden() return true end
function modifier_kiana_combo_hit:IsDebuff() return false end
function modifier_kiana_combo_hit:IsPurgable() return false end
function modifier_kiana_combo_hit:IsPurgeException() return false end
function modifier_kiana_combo_hit:RemoveOnDeath() return true end

 modifier_kiana_air_combo = class({})
function modifier_kiana_air_combo:IsDebuff()
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then return true end
	return false
end
function modifier_kiana_air_combo:IsHidden() return false end
function modifier_kiana_air_combo:IsPurgable() return false end
function modifier_kiana_air_combo:IsPurgeException() return false end
function modifier_kiana_air_combo:IsStunDebuff() return false end
function modifier_kiana_air_combo:IsMotionController() return true end
function modifier_kiana_air_combo:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_kiana_air_combo:CheckState()
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then return end
	local state = {
				[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end
-------------------------------------------

function modifier_kiana_air_combo:OnCreated( params )
	if IsServer() then
	local stack = self:SetStackCount(0)
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		self.parent = self:GetParent()
		self.z_height = 0
		self.duration = params.duration
		self.lift_animation = 0.1
		self.fall_animation = 0.1
		self.current_time = 0
self.final_loc = self:GetParent():GetAbsOrigin()
		-- Start thinking
		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
		
		Timers:CreateTimer(FrameTime(), function()
			self.duration = self:GetRemainingTime()
		end)
	end
end

function modifier_kiana_air_combo:OnIntervalThink()
	if IsServer() then
		-- Check motion controllers
		
if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end
		if self:GetStackCount() == 1 then
		local RNG = RandomInt(-500,500)
		self.final_loc = GetGroundPosition(self:GetParent():GetAbsOrigin()+self:GetParent():GetForwardVector()*RNG, nil)
		else
		self.final_loc = self:GetParent():GetAbsOrigin()
end
		-- Vertical Motion
		self:VerticalMotion(self.parent, self.frametime)

		-- Horizontal Motion
		--self:HorizontalMotion(self.parent, self.frametime)
	end
end

function modifier_kiana_air_combo:EndTransition()
	if IsServer() then
		if self.transition_end_commenced then
			return nil
		end

		self.transition_end_commenced = true

		local caster = self:GetCaster()
		local parent = self:GetParent()
		--local ability = self:GetAbility()
		local ally_cooldown_reduction = 0
		
		-- Set the thrown unit on the ground
		parent:SetUnitOnClearGround()
		ResolveNPCPositions(parent:GetAbsOrigin(), 64)

		-- Remove the stun/root modifier
		parent:RemoveModifierByName("modifier_kiana_air_combo_stun")
		parent:RemoveModifierByName("modifier_kiana_air_combo_root")

		local parent_pos = parent:GetAbsOrigin()

		-- Ability properties
		--local ability = self:GetAbility()
		local impact_radius = 200
		GridNav:DestroyTreesAroundPoint(parent_pos, impact_radius, true)

		-- Parameters
		local damage = 0
		local impact_stun_duration = 0
		local impact_radius = 0

		
		

		-- Play impact particle
		


		-- Special considerations for ally telekinesis		
		
	end
end

function modifier_kiana_air_combo:VerticalMotion(unit, dt)
	if IsServer() then
		self.current_time = self.current_time + dt

		local max_height = 280
		-- Check if it shall lift up
		if self.current_time <= self.lift_animation  then
			self.z_height = self.z_height + ((dt / self.lift_animation) * max_height)
			unit:SetAbsOrigin(GetGroundPosition(unit:GetAbsOrigin(), unit) + Vector(0,0,self.z_height))
		elseif self.current_time > (self.duration - self.fall_animation) then
			self.z_height = self.z_height - ((dt / self.fall_animation) * max_height)
			if self.z_height < 0 then self.z_height = 0 end
			unit:SetAbsOrigin(GetGroundPosition(unit:GetAbsOrigin(), unit) + Vector(0,0,self.z_height))
		else
			max_height = self.z_height
		end

		if self.current_time >= self.duration then
			self:EndTransition()
			self:Destroy()
		end
	end
end

function modifier_kiana_air_combo:HorizontalMotion(unit, dt)
	if IsServer() then

		self.distance = self.distance or 0
		if (self.current_time > (self.duration - self.fall_animation)) then
			if self.changed_target then
				local frames_to_end = math.ceil((self.duration - self.current_time) / dt)
				self.distance = (unit:GetAbsOrigin() - self.final_loc):Length2D() / frames_to_end
				self.changed_target = false
			end
			if (self.current_time + dt) >= self.duration then
				unit:SetAbsOrigin(self.final_loc)
				self:EndTransition()
			else
				unit:SetAbsOrigin( unit:GetAbsOrigin())
			end
		end
	end
end



function modifier_kiana_air_combo:OnDestroy()
	if IsServer() then
		-- If it was destroyed because of the parent dying, set the caster at the ground position.
		if not self.parent:IsAlive() then
			self.parent:SetUnitOnClearGround()
			
		end
		
		

	-- move parent
	
	end
end

modifier_basic_combo_2 = class({})
function modifier_basic_combo_2:IsHidden() return true end
function modifier_basic_combo_2:IsDebuff() return false end
function modifier_basic_combo_2:IsPurgable() return false end
function modifier_basic_combo_2:IsPurgeException() return false end
function modifier_basic_combo_2:RemoveOnDeath() return true end
function modifier_basic_combo_2:OnCreated()
 if IsServer() then
local ability = self:GetAbility()
ability:EndCooldown()
end
 end
function modifier_basic_combo_2:OnDestroy()
 if IsServer() then
local ability = self:GetAbility()
ability:StartCooldown(ability:GetCooldown(-1)* self:GetParent():GetCooldownReduction())
end
 end
 
 modifier_basic_combo_3 = class({})
function modifier_basic_combo_3:IsHidden() return true end
function modifier_basic_combo_3:IsDebuff() return false end
function modifier_basic_combo_3:IsPurgable() return false end
function modifier_basic_combo_3:IsPurgeException() return false end
function modifier_basic_combo_3:RemoveOnDeath() return true end
function modifier_basic_combo_3:OnCreated()
 if IsServer() then
local ability = self:GetAbility()
ability:EndCooldown()
end
 end
function modifier_basic_combo_3:OnDestroy()
 if IsServer() then
local ability = self:GetAbility()
ability:StartCooldown(ability:GetCooldown(-1)* self:GetParent():GetCooldownReduction())
end
 end
 
 modifier_basic_combo_4 = class({})
function modifier_basic_combo_4:IsHidden() return true end
function modifier_basic_combo_4:IsDebuff() return false end
function modifier_basic_combo_4:IsPurgable() return false end
function modifier_basic_combo_4:IsPurgeException() return false end
function modifier_basic_combo_4:RemoveOnDeath() return true end
function modifier_basic_combo_4:OnCreated()
 if IsServer() then
local ability = self:GetAbility()
ability:EndCooldown()
end
 end
function modifier_basic_combo_4:OnDestroy()
 if IsServer() then
local ability = self:GetAbility()
ability:StartCooldown(ability:GetCooldown(-1)* self:GetParent():GetCooldownReduction())
end
 end
 
 modifier_basic_combo_5 = class({})
function modifier_basic_combo_5:IsHidden() return true end
function modifier_basic_combo_5:IsDebuff() return false end
function modifier_basic_combo_5:IsPurgable() return false end
function modifier_basic_combo_5:IsPurgeException() return false end
function modifier_basic_combo_5:RemoveOnDeath() return true end
function modifier_basic_combo_5:OnCreated()
 if IsServer() then
local ability = self:GetAbility()
ability:EndCooldown()
end
 end
function modifier_basic_combo_5:OnDestroy()
 if IsServer() then
local ability = self:GetAbility()
ability:StartCooldown(ability:GetCooldown(-1)* self:GetParent():GetCooldownReduction())
end
 end

modifier_basic_combo_4_punches = class({})
function modifier_basic_combo_4_punches:IsHidden() return true end
function modifier_basic_combo_4_punches:IsDebuff() return false end
function modifier_basic_combo_4_punches:IsPurgable() return false end
function modifier_basic_combo_4_punches:IsPurgeException() return false end
function modifier_basic_combo_4_punches:RemoveOnDeath() return true end

function modifier_basic_combo_4_punches:OnCreated()
 if IsServer() then
self:StartIntervalThink(0.1)
self.damage = self:GetAbility():GetSpecialValueFor("base_damage") * 0.2
	self.attack_scale = self:GetAbility():GetSpecialValueFor("attack_scale") * 0.2
 end
 end
 function modifier_basic_combo_4_punches:OnIntervalThink()
 if IsServer() then
local caster = self:GetCaster()
 local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
local scale = caster:GetAverageTrueAttackDamage(self:GetParent()) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = self:GetParent()
		ApplyDamage(damageTable)
 end
 self:PlayEffects(self:GetParent())
 EmitSoundOn("kiana.hits",caster)

end
function modifier_basic_combo_4_punches:PlayEffects(target)
	-- Load effects
	local particle_cast = "particles/test_kiana_multiple_hits.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
















modifier_finality_double_slash = class({})
function modifier_finality_double_slash:IsHidden() return true end
function modifier_finality_double_slash:IsDebuff() return false end
function modifier_finality_double_slash:IsPurgable() return false end
function modifier_finality_double_slash:IsPurgeException() return false end
function modifier_finality_double_slash:RemoveOnDeath() return true end

function modifier_finality_double_slash:OnCreated()
 if IsServer() then
self:StartIntervalThink(0.1)
self.damage = self:GetAbility():GetSpecialValueFor("base_damage") 
	self.attack_scale = self:GetAbility():GetSpecialValueFor("attack_scale")
	 self:PlayEffects(self:GetParent())
 end
 end
 function modifier_finality_double_slash:OnIntervalThink()
 if IsServer() then
local caster = self:GetCaster()
 local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
local scale = caster:GetAverageTrueAttackDamage(self:GetParent()) * self.attack_scale
damageTable.damage = (self.damage + scale) * 0.5
damageTable.victim = self:GetParent()
		ApplyDamage(damageTable)
 end

 EmitSoundOn("kiana.fast_slash",caster)

end
function modifier_finality_double_slash:PlayEffects( target )

	local particle_cast = "particles/multiple_galaxy_slash_kiana.vpcf"
local radius = 500
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end



modifier_finality_invul_combo = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_finality_invul_combo:IsHidden()
	return false
end

function modifier_finality_invul_combo:IsDebuff()
	return false
end

function modifier_finality_invul_combo:IsStunDebuff()
	return true
end

function modifier_finality_invul_combo:IsPurgable()
	return true
end

function modifier_finality_invul_combo:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_finality_invul_combo:OnCreated( kv )
if IsServer() then
	--self:PlayEffects()
	self:GetParent():AddNoDraw()
	end
end




function modifier_finality_invul_combo:OnRemoved()
end

function modifier_finality_invul_combo:OnDestroy()
	if not IsServer() then return end


	


	self:GetParent():RemoveNoDraw()

	
	--self:GetParent():AddNewModifier(caster, self, "modifier_judgment_cut_end_invul_2", {duration = 1.0})	
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_finality_invul_combo:CheckState()
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




modifier_kiana_talent_bkb = class({})
function modifier_kiana_talent_bkb:IsHidden() return false end
function modifier_kiana_talent_bkb:IsDebuff() return false end
function modifier_kiana_talent_bkb:IsPurgable() return false end
function modifier_kiana_talent_bkb:IsPurgeException() return false end
function modifier_kiana_talent_bkb:RemoveOnDeath() return true end
function modifier_kiana_talent_bkb:CheckState()
	local state = {	[MODIFIER_STATE_MAGIC_IMMUNE] = true,}
	return state
end
function modifier_kiana_talent_bkb:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, }
	return func
end
function modifier_kiana_talent_bkb:GetModifierModelScale()
	return 1
end
function modifier_kiana_talent_bkb:GetModifierMagicalResistanceBonus()
	return 1
end

function modifier_kiana_talent_bkb:GetEffectName()
	return "particles/units/heroes/hero_pangolier/pangolier_shard_rollup_magic_immune.vpcf"
end
function modifier_kiana_talent_bkb:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end
function modifier_kiana_talent_bkb:StatusEffectPriority()
	return 10
end
function modifier_kiana_talent_bkb:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end









modifier_kiana_talent_bkb_cd = class({})
function modifier_kiana_talent_bkb_cd:IsHidden() return false end
function modifier_kiana_talent_bkb_cd:IsDebuff() return false end
function modifier_kiana_talent_bkb_cd:IsPurgable() return false end
function modifier_kiana_talent_bkb_cd:IsPurgeException() return false end
function modifier_kiana_talent_bkb_cd:RemoveOnDeath() return true end








modifier_basic_combo_grenade_speacial = class({})
function modifier_basic_combo_grenade_speacial:IsHidden() return true end
function modifier_basic_combo_grenade_speacial:IsDebuff() return false end
function modifier_basic_combo_grenade_speacial:IsPurgable() return false end
function modifier_basic_combo_grenade_speacial:IsPurgeException() return false end
function modifier_basic_combo_grenade_speacial:RemoveOnDeath() return true end

function modifier_basic_combo_grenade_speacial:OnCreated()
 if IsServer() then
self:StartIntervalThink(0.3)
self.damage = self:GetAbility():GetSpecialValueFor("base_damage") 
	self.attack_scale = self:GetAbility():GetSpecialValueFor("attack_scale")
	 self:PlayEffects(self:GetParent())
 end
 end
 function modifier_basic_combo_grenade_speacial:OnIntervalThink()
 if IsServer() then
local caster = self:GetCaster()
 local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(), --Optional.
	}
local scale = caster:GetAverageTrueAttackDamage(self:GetParent()) * self.attack_scale
damageTable.damage = (self.damage + scale) * 2
damageTable.victim = self:GetParent()
		ApplyDamage(damageTable)
 end

 EmitSoundOn("kiana.exp",caster)

end
function modifier_basic_combo_grenade_speacial:PlayEffects( target )

	local particle_cast = "particles/kiana_weapon_exp.vpcf"
local radius = 500
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end











































































































LinkLuaModifier("kiana_evasion_modifier", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ultimate_evasion_time_cd", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ultimate_evasion_timestop", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ultimate_evasion_timestop_effect", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kiana_combo_hit", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)

kiana_evasion = class({})

function kiana_evasion:OnSpellStart()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_core_upgrade_3") then
	self:PerfectEvasion()
	elseif caster:HasModifier("modifier_sirin_awakening") or caster:HasModifier("modifier_core_upgrade_2") then
	self:UltimateEvasion()
	else
	self:BaseEvasion()
	end
end
function kiana_evasion:PerfectEvasion()
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local point = self:GetCursorPosition()
	caster:EmitSound("sirin.2")
	self:PlayEffects_Tp(caster:GetOrigin(),caster:GetForwardVector())
	FindClearSpaceForUnit( caster, point, true )
	self:PlayEffects_Tp(caster:GetOrigin(),caster:GetForwardVector())
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		--damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		if caster:HasTalent("special_bonus_kiana_20_alt") then
		self.attack_scale = caster:GetAverageTrueAttackDamage(enemy) * 1.5
		else
		self.attack_scale = 0
		end
		--if not caster:HasModifier("modifier_ultimate_evasion_time_cd") then
		self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_ultimate_evasion_timestop", -- modifier name
		{ duration = 1 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
		--end
		caster:SetForwardVector(enemy:GetAbsOrigin())
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
		local delay = 0.3
		Timers:CreateTimer(delay,function()
		damageTable.damage = damage + self.attack_scale
			damageTable.victim = enemy
		ApplyDamage(damageTable)
		self:PlayEffectsEXP(enemy:GetOrigin())
			caster:EmitSound("finality.2")
		end)
		end
end
function kiana_evasion:PlayEffectsEXP( origin)
	-- Get Resources

	local particle_cast_a = "particles/halo_7_exp3.vpcf"
	local sound_cast_a = "sirin.ex"

local direction = self:GetCaster():GetForwardVector()
	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	
end
function kiana_evasion:UltimateEvasion()
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local point = self:GetCursorPosition()
	caster:EmitSound("sirin.2")
	self:PlayEffects_Tp(caster:GetOrigin(),caster:GetForwardVector())
	FindClearSpaceForUnit( caster, point, true )
	self:PlayEffects_Tp(caster:GetOrigin(),caster:GetForwardVector())
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		--damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
			if caster:HasTalent("special_bonus_kiana_20_alt") then
		self.attack_scale = caster:GetAverageTrueAttackDamage(enemy) * 1.5
		else
		self.attack_scale = 0
		end
		--if not caster:HasModifier("modifier_ultimate_evasion_time_cd") then
		self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_ultimate_evasion_timestop", -- modifier name
		{ duration = 1 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	--	end
	damageTable.damage = damage + self.attack_scale
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		--return
		end
end
----------------------
--Base
----------------------
function kiana_evasion:BaseEvasion()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "kiana_evasion_modifier", {})
	local justpoint = self:GetCursorPosition()
	caster:EmitSound("kiana.2")
	local jump = ParticleManager:CreateParticle("particles/blink.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(jump, 0, caster:GetAbsOrigin() + caster:GetForwardVector())
	ParticleManager:SetParticleControl(jump, 4, self:GetCursorPosition())
end
-------------------------------------
--Effects
-------------------------------------
function kiana_evasion:PlayEffects_Tp( origin, direction )
	-- Get Resources
	if self:GetCaster():HasModifier("modifier_core_upgrade_3") then
	  self.particle_cast_a = "particles/kiana_final_teleport.vpcf"
	else
  self.particle_cast_a = "particles/sirin_teleport.vpcf"
	end
	local sound_cast_a = "sirin.tp"


	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( self.particle_cast_a, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	
end

modifier_ultimate_evasion_time_cd = class({})

function modifier_ultimate_evasion_time_cd:IsPurgable()
    return false
end
function modifier_ultimate_evasion_time_cd:RemoveOnDeath()
    return false
end
function modifier_ultimate_evasion_time_cd:IsPurgeException()
    return false
end
function modifier_ultimate_evasion_time_cd:IsHidden()
    return false
end


modifier_ultimate_evasion_timestop = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_ultimate_evasion_timestop:OnCreated( kv )
	-- references
	self.radius = 300

	if IsServer() then
	
		self:PlayEffects()
		end
	end


function modifier_ultimate_evasion_timestop:OnRefresh( kv )
	
end

function modifier_ultimate_evasion_timestop:OnRemoved()
end

function modifier_ultimate_evasion_timestop:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ultimate_evasion_timestop:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_ultimate_evasion_timestop:IsAura()
	return true
end

function modifier_ultimate_evasion_timestop:GetModifierAura()
	return "modifier_ultimate_evasion_timestop_effect"
end

function modifier_ultimate_evasion_timestop:GetAuraRadius()
	return self.radius
end

function modifier_ultimate_evasion_timestop:GetAuraDuration()
	return 0.01
end

function modifier_ultimate_evasion_timestop:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_ultimate_evasion_timestop:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_ultimate_evasion_timestop:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ultimate_evasion_timestop:PlayEffects()
	-- Get Resources
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_core_upgrade_3") then
	self.particle = "particles/test_kiana_perfect_evasion_timestop.vpcf"
	else
	self.particle = "particles/test_kiana_ultimate_evasion_timestop.vpcf"
	--local sound_cast = ""
end
	-- Create Particle
   local effect_cast = ParticleManager:CreateParticle( self.particle, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	--EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_ultimate_evasion_timestop:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/homura_timestop2.vpcf"
	local sound_cast = ""

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end




modifier_ultimate_evasion_timestop_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ultimate_evasion_timestop_effect:IsHidden()
	return false
end

function modifier_ultimate_evasion_timestop_effect:IsDebuff()
	return not self:NotAffected()
end

function modifier_ultimate_evasion_timestop_effect:IsStunDebuff()
	return not self:NotAffected()
end

function modifier_ultimate_evasion_timestop_effect:IsPurgable()
	return false
end

function modifier_ultimate_evasion_timestop_effect:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_ultimate_evasion_timestop_effect:NotAffected()
	-- true owner
	if self:GetParent()==self:GetCaster() then return true end

	-- true if owner controlled
	if self:GetParent():GetPlayerOwnerID()==self:GetCaster():GetPlayerOwnerID() then return true end
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ultimate_evasion_timestop_effect:OnCreated( kv )
	self.speed = 550

	if IsServer() then
		if not self:NotAffected() then
			self:GetParent():InterruptMotionControllers( false )
		else
			self:PlayEffects()
		end
	end
end

function modifier_ultimate_evasion_timestop_effect:OnRefresh( kv )
	
end

function modifier_ultimate_evasion_timestop_effect:OnRemoved()
end

function modifier_ultimate_evasion_timestop_effect:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ultimate_evasion_timestop_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end

function modifier_ultimate_evasion_timestop_effect:GetModifierMoveSpeed_AbsoluteMin()
	if self:NotAffected() then return self.speed end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ultimate_evasion_timestop_effect:CheckState()
	local state1 = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	local state2 = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	if self:NotAffected() then return state1 else return state2 end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_ultimate_evasion_timestop_effect:GetEffectName()
-- 	return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
-- end

-- function modifier_ultimate_evasion_timestop_effect:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

-- function modifier_ultimate_evasion_timestop_effect:GetStatusEffectName()
-- 	return "status/effect/here.vpcf"
-- end

function modifier_ultimate_evasion_timestop_effect:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end






kiana_evasion_modifier = class({})
function kiana_evasion_modifier:GetPriority() return MODIFIER_PRIORITY_HIGH end
function kiana_evasion_modifier:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function kiana_evasion_modifier:CheckState()
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




function kiana_evasion_modifier:OnCreated(args)
	if not IsServer() then 
        return
    end 
	self.parent = self:GetParent()
self.parent:StartGesture(ACT_DOTA_CAST_COLD_SNAP)
		self.ability = self:GetAbility()
		self.point = self.ability:GetCursorPosition()
		self.distances = self.ability:GetSpecialValueFor("distance")
		self.direction = (self.point - self.parent:GetAbsOrigin()):Normalized()
		

	self:StartIntervalThink(FrameTime())
end


function kiana_evasion_modifier:OnIntervalThink()
	self:UpdateHorizontalMotion(self:GetParent(), FrameTime())
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_kiana_20_alt") then
	          local nearby_targets = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - caster:GetOrigin()):Length2D()
               
                local damage = caster:GetAverageTrueAttackDamage(target) * 1.5
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    ability = self
                }
                
				if not target:HasModifier("modifier_kiana_combo_hit") then
                target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kiana_combo_hit", {duration = 1})
    
                ApplyDamage(damage)  
				self:PlayEffects(target)
				end
            end
			end

end
function kiana_evasion_modifier:PlayEffects( target )

	local particle_cast = "particles/test_kiana_multiple_hits.vpcf"
local radius = 500
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function kiana_evasion_modifier:UpdateHorizontalMotion(hero, times)
	if self.distances >= 0 then 
		local speed = 1750 * times
		local parent_pos = self.parent:GetAbsOrigin()
		
		self.next_pos = parent_pos + self.direction * speed
		self.distances = self.distances - speed
		self.parent:SetOrigin(self.next_pos)
	--	self.parent:FaceTowards(self.point)
		else
	
		self:Destroy()
	end
end

function kiana_evasion_modifier:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
	end
end


function kiana_evasion_modifier:OnDestroy()
	
	if IsServer() then
        self.parent:InterruptMotionControllers(true)
	end
	
end


modifier_kiana_weapon_skill_exp = class({})
function modifier_kiana_weapon_skill_exp:IsHidden() return true end
function modifier_kiana_weapon_skill_exp:IsDebuff() return false end
function modifier_kiana_weapon_skill_exp:IsPurgable() return false end
function modifier_kiana_weapon_skill_exp:IsPurgeException() return false end
function modifier_kiana_weapon_skill_exp:RemoveOnDeath() return false end

 function modifier_kiana_weapon_skill_exp:OnCreated()
 if IsServer() then
 if self:GetParent():IsAlive() then
 local str = self:GetCaster():GetAverageTrueAttackDamage(self:GetParent()) * 1.0
self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(), --Optional.
	
	}

	self.damageTable.damage = str

local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
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

		end
	end
	end
end

















































































--оружие

kiana_weapon_skill = class({})
LinkLuaModifier("modifier_kiana_weapon_skill_slow", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_blast_thinker", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flameshion_exp_thinker", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_finality_exp_thinker", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kiana_weapon_skill_exp", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kiana_air_combo", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_kiana_talent_bkb", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kiana_talent_bkb_cd", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_upgrade_core", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_sirin_awakening", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_core_upgrade_2", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_core_upgrade_3", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_finality_herrsher_form", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flameshion_herrsher_form", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_herrsher_form", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drifter_core", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_herrsher_mode_cooldown", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)



function kiana_weapon_skill:GetCastRange( location , target)
if IsServer() then
local mod = self:GetCaster():FindModifierByName("modifier_nyan_nyan") 
if mod then
local stack = mod:GetStackCount()
if stack == 1 then
		return  self:GetSpecialValueFor("cast_range")
		else
		return 700
		end
	end
	return self:GetSpecialValueFor("cast_range")
	end
end




function kiana_weapon_skill:OnSpellStart()
if IsServer() then
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
		--	if not caster:HasModifier("modifier_kiana_talent_bkb_cd") then
	-- caster:AddNewModifier(caster, self, "modifier_kiana_talent_bkb", {duration = 0.5})
	-- 	 caster:AddNewModifier(caster, self, "modifier_kiana_talent_bkb_cd", {duration = 5})
		-- end
	self.attack_scale = self:GetSpecialValueFor("attack_scale")
	self.damage = self:GetSpecialValueFor("damage")
	if caster:HasModifier("modifier_core_upgrade_3") then
--	caster:StartGesture(ACT_DOTA_NECRO_GHOST_SHROUD)
	self:FinalitySkill()
	elseif caster:HasModifier("modifier_core_upgrade_2") then
--	caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
	self:FlameShionSkill()
	
	elseif caster:HasModifier("modifier_upgrade_core") then
--	caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
	self:DrifterSkill()
	elseif caster:HasModifier("modifier_sirin_awakening") then
--	caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
	self:SirinSkill()
else
	--caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
	self:WeaponSkill1()
	end
	end
end



function kiana_weapon_skill:FinalitySkill()

	local caster = self:GetCaster()
		local target = self:GetCursorTarget()
			local mod = caster:FindModifierByName("modifier_nyan_nyan")
	local stack = mod:GetStackCount()
	if stack == 2 then
	self:FinalitySkill1(target)
	mod:SetStackCount(3)
	self:EndCooldown()
	elseif stack == 3 then
		self:FinalitySkill2(target)
		mod:SetStackCount(1)
			if self:GetCaster():HasTalent("special_bonus_kiana_25_alt") then
		self:EndCooldown()
		end
	elseif stack == 7 then
		self:FinalitySkill_ultimate(target)
		mod:SetStackCount(1)
		self:EndCooldown()
	local ability =	self:GetCaster():FindAbilityByName("kiana_combo_hit")
	ability:EndCooldown()
	else
	mod:SetStackCount(4)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.fast_slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
		
 
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 150,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects_smashFinality(target)
	
	end
	end
	
	
function kiana_weapon_skill:FinalitySkill1(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.fast_slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
		
    target:AddNewModifier(caster, self, "modifier_kiana_air_combo", {duration = 0.49})
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects_smashFinality(target)

local delay = (0.1)  

	Timers:CreateTimer(delay,function()

local caster = self:GetCaster()
local origin = caster:GetOrigin()
self:PlayEffectsBlur(origin)
  caster:AddNewModifier(caster, self, "modifier_finality_invul_combo", {duration = 0.29})
	
		
    target:AddNewModifier(caster, self, "modifier_finality_double_slash", {duration = 0.29})
	
	end)
	
end

function kiana_weapon_skill:PlayEffectsBlur( origin )

	local particle_cast = "particles/vergil_blur.vpcf"
local radius = 555
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

function kiana_weapon_skill:FinalitySkill2(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.fast_slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
		
 
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 0,
                        knockback_height = -200,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects_smashFinality(target)


local delay = (0.15)  

	Timers:CreateTimer(delay,function()

local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK2)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
		
 
			local knockback = { should_stun = 0,
                        knockback_duration = 0.3,
                        duration = 0.3,
                        knockback_distance = 200,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 3
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffectsFinalityEXP(target)
				end)


end
function kiana_weapon_skill:PlayEffects_smashFinality( target )

	local particle_cast = "particles/kiana_star_hit.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 400, 400, 400) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function kiana_weapon_skill:PlayEffectsFinalityEXP( target )

	local particle_cast = "particles/halo_7_exp3.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 400, 400, 400) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
	function kiana_weapon_skill:PlayEffectsFinalityTimeExp( target )

	local particle_cast = "particles/kiana_final_time_exp.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 400, 400, 400) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
	
	
	
	function kiana_weapon_skill:FinalitySkill_ultimate(target)
local caster = self:GetCaster()
if IsServer() then
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.timestop_exp",caster)
		EmitSoundOn("kiana.timestop_exp_glass",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK)

		-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = (caster:GetAverageTrueAttackDamage(target) * self.attack_scale) * 5,
		damage_type = DAMAGE_TYPE_PHYSICAL,
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
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = 0.5 } -- kv
		)
		--self:PlayEffectsFinalityTimeExp(enemy)
	end
self:PlayEffectsFinalityTimeExp(target)
if caster:HasScepter() then
if caster:HasModifier("modifier_core_upgrade_3") then
if caster:HasModifier("modifier_ultimate_start") then
if not caster:HasModifier("modifier_herrsher_mode_cooldown") then
EmitSoundOn("kiana.final_words", caster)
		_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")	
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	_G.CurrentMusicUltima = "kiana.finality_theme"
_G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 60})
	caster:AddNewModifier(caster, self, "modifier_finality_herrsher_form", {duration = 60})
		caster:AddNewModifier(caster, self, "modifier_herrsher_mode_cooldown", {duration = 220 * caster:GetCooldownReduction()})
end
end
end
end
end
end
	
	
	
	
	
	
	
function kiana_weapon_skill:FlameShionSkill()

	local caster = self:GetCaster()
		local target = self:GetCursorTarget()
	local origin = target:GetOrigin()
		local mod = caster:FindModifierByName("modifier_nyan_nyan")
	local stack = mod:GetStackCount()
	if stack == 2 then
	self:FlameshionSkill1_2(target)
	mod:SetStackCount(3)
	self:EndCooldown()
	elseif stack == 3 then
	for i = 1, 12 do
	local delay = ((0.01 + i) * 0.1)  

	Timers:CreateTimer(delay,function()
		self:FlameshionSkill1_3(target)
		end)
		if self:GetCaster():HasTalent("special_bonus_kiana_25_alt") then
		self:EndCooldown()
		end
		end
		mod:SetStackCount(1)
	elseif stack == 7 then
		self:FlameshionSkill_ultimate(target)
		mod:SetStackCount(1)
local ability = self:GetCaster():FindAbilityByName("kiana_combo_hit")
		ability:EndCooldown()
self:EndCooldown()
		
	else
	mod:SetStackCount(4)
		self:FlameshionSkill1(target)
	end
	end

	
	
function kiana_weapon_skill:FlameshionSkill1(target)
print("fs1")
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_CHAOS_METEOR)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 100,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				--self:PlayEffects(target)
           --  caster:SetForwardVector(caster:GetForwardVector() * -1)
 EmitSoundOn("kiana.slash", caster)
 
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) 
damageTable.victim = target
		ApplyDamage(damageTable)
		end
	
	function kiana_weapon_skill:FlameshionSkill1_2(target)
	print("fs2")
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.slash",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.4,
                        duration = 0.4,
                        knockback_distance = 150,
                        knockback_height = 400,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
		 local delay = 0.1

	
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)


end

function kiana_weapon_skill:FlameshionSkill1_3(target)
print("fs3")
local caster = self:GetCaster()
	-- unit identifier
	if not caster:HasModifier("modifier_kiana_air_combo") then
			-- caster:AddNewModifier(caster, self, "modifier_kiana_air_combo", {duration = 1})
			  target:AddNewModifier(caster, self, "modifier_kiana_air_combo", {duration = 1})
			 end
	local target_origin = target:GetAbsOrigin() + RandomVector(900)
	local tp_point = target_origin
	
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
		local direction = (target:GetOrigin()-target_origin)
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	-- Blink
	caster:SetOrigin( target_origin )
	FindClearSpaceForUnit( caster, target_origin, true )
local location = GetGroundPosition(target:GetAbsOrigin()+direction*1000, nil)
	-- load data
local delay = 0.03

	Timers:CreateTimer(delay,function()

		local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale

	local radius = 150
	local max_dist = 20000000
	local min_dist = 500
	local origin = caster:GetOrigin()
	-- find destination
	local direction = (location-origin)
	local dist = 1800
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )

	-- teleport
	FindClearSpaceForUnit( caster, target, true )

	-- find units in line
	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		target,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- perform attack
	
damageTable.damage = (self.damage + scale)  * 0.6
damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- add modifier
		
	EmitSoundOnLocationWithCaster(enemy:GetOrigin(),"kiana.fast_slash",caster)
		-- play effects
		self:PlayEffects_slash2( enemy )
	end

	-- play effects
	self:PlayEffects_slash_flameshion1( origin, target )
	end)
end

function kiana_weapon_skill:PlayEffects_slash_flameshion1( origin, target )
	-- Get Resources
	local particle_cast = "particles/kiana_slash_flameshion.vpcf"
	local sound_start = "kiana.void_slash"
	local sound_end = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end
	function kiana_weapon_skill:PlayEffects_slash( origin, target )
	-- Get Resources
	local particle_cast = "particles/kiana_void_slash.vpcf"
	local sound_start = "kiana.void_slash"
	local sound_end = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

function kiana_weapon_skill:PlayEffects_slash2( target )
	-- Get Resources
	local particle_cast = "particles/void_spirit_astral_step_impact1.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
	
function kiana_weapon_skill:FlameshionSkill_ultimate(target)
	print("fsu")
	-- unit identifier
	if IsServer() then
	local target_origin = target:GetAbsOrigin() + RandomVector(900)
	local tp_point = target_origin
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
		local direction = (target:GetOrigin()-target_origin)
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	-- Blink
	caster:SetOrigin( target_origin )
	FindClearSpaceForUnit( caster, target_origin, true )
local location = GetGroundPosition(target:GetAbsOrigin()+direction*1000, nil)
	-- load data
local delay = 0.03

	Timers:CreateTimer(delay,function()

		local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale

	local radius = 150
	local max_dist = 20000000
	local min_dist = 500
	local origin = caster:GetOrigin()
	-- find destination
	local direction = (location-origin)
	local dist = 1800
	direction.z = 0
	direction = direction:Normalized()

	local target11 = GetGroundPosition( origin + direction*dist, nil )

	-- teleport
	FindClearSpaceForUnit( caster, target11, true )

	-- find units in line
	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		target11,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- perform attack
	
damageTable.damage = (self.damage + scale)  * 5
damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- add modifier
		
	EmitSoundOnLocationWithCaster(enemy:GetOrigin(),"kiana.fast_slash",caster)
		-- play effects
		self:PlayEffects_slash2( enemy )
	end
EmitSoundOnLocationWithCaster(target:GetOrigin(),"sirin.exp",caster)
	-- play effects
	self:PlayEffects_ulti_exp( target )
	end)
	if caster:HasScepter() then
	if caster:HasModifier("modifier_core_upgrade_2") then
	if caster:HasModifier("modifier_ultimate_start") then
if not caster:HasModifier("modifier_herrsher_mode_cooldown") then

	caster:AddNewModifier(caster, self, "modifier_flameshion_herrsher_form", {duration = 60})
		caster:AddNewModifier(caster, self, "modifier_herrsher_mode_cooldown", {duration = 220 * caster:GetCooldownReduction()})
		_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")	
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	_G.CurrentMusicUltima = "flameshion.base_theme"
_G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 60})
end
end
end
end
end
	
end
	
	
	
	
	
function kiana_weapon_skill:SirinSkill()

	local caster = self:GetCaster()
	EmitSoundOn("sirin.3",caster)
	local target = self:GetCursorTarget()
	local origin = target:GetOrigin()
	self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_blast_thinker", -- modifier name
		{ duration = 0.49 }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	
	local delay = 0.52

	Timers:CreateTimer(delay,function()
	self:SirinSkill2(target)
	end)
	end
function kiana_weapon_skill:SirinSkill2(target)
	local caster = self:GetCaster()
	self:PlayEffects_CubeSmash(target)
	local delay = 0.41
local attack = caster:GetAverageTrueAttackDamage(target)
	Timers:CreateTimer(delay,function()
		local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = (self:GetSpecialValueFor("damage") * 2) + attack,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
	EmitSoundOn("kiana.ground_shake",target)
	ApplyDamage( damageTable )
	end)
	end
function kiana_weapon_skill:PlayEffects_CubeSmash(target)
	-- Get Resources
	local particle_cast = "particles/test_cube_smash.vpcf"
	self.parent_origin = target:GetOrigin()
	self.delay = 0.4

	-- Get Data
	local h1 = 800
	local h2 = -800
	local h0 = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, h1, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, h0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

local effect_cast2 = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast2, 0, self.parent_origin + Vector( 0, h2, 0 ) )
	ParticleManager:SetParticleControl( effect_cast2, 1, self.parent_origin + Vector( 0, h0, 0) )
	ParticleManager:SetParticleControl( effect_cast2, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast2 )
	
end
	
	----------------------------------------------

function kiana_weapon_skill:WeaponSkill1()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local mod = caster:FindModifierByName("modifier_nyan_nyan")
	self.attack_scale = self:GetSpecialValueFor("attack_scale")
	self.damage = self:GetSpecialValueFor("damage")
	local stack = mod:GetStackCount()
	if stack == 2 then
	self:BasicCombo1_2(target)
	mod:SetStackCount(3)
	self:EndCooldown()
	elseif stack == 3 then
		self:BasicCombo1_3(target)
		mod:SetStackCount(1)
		if self:GetCaster():HasTalent("special_bonus_kiana_25_alt") then
self:EndCooldown()
end
	elseif stack == 7 then
		self:BasicCombo_ultimate(target)
		if self:GetCaster():HasTalent("special_bonus_kiana_25_alt") then
		local ability = self:GetCaster():FindAbilityByName("kiana_combo_hit")
		ability:EndCooldown()
self:EndCooldown()
mod:SetStackCount(1)
end
	else
	mod:SetStackCount(4)
	self.max_riko = self:GetSpecialValueFor("max_bounces")
	self.riko = 0
local index = self:GetUniqueInt()
	EmitSoundOn("kiana.3", caster)

	local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/kiana_bullet.vpcf",
						iMoveSpeed = self:GetSpecialValueFor("speed"),
						bDodgeable = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
ExtraData = {
			index = index,
		}
						}
						
						

	ProjectileManager:CreateTrackingProjectile(projectile)
	local data = {}
	data.jump = 0
	data.hit_units = {}

	data.jumps = 10
	data.radius = 600
	data.projectile_info = projectile
	self.projectiles[index] = data
	end
end

function kiana_weapon_skill:DrifterSkill()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local mod = caster:FindModifierByName("modifier_nyan_nyan")
	local stack = mod:GetStackCount()
	if stack == 2 then
	for i = 1, 10 do
	local delay = ((0.01 + i) * 0.1)  

	Timers:CreateTimer(delay,function()
	self:DrifterCombo1_2(target) -- Multiple hits aue
	end)
	end

	mod:SetStackCount(3)
	self:EndCooldown()
	elseif stack == 3 then
		self:DrifterCombo1_3(target)
		if self:GetCaster():HasTalent("special_bonus_kiana_25_alt") then
self:EndCooldown()
end
		mod:SetStackCount(1)
	elseif stack == 7 then
		self:DrifterCombo_ultimate(target)
				local ability = self:GetCaster():FindAbilityByName("kiana_combo_hit")
		ability:EndCooldown()
self:EndCooldown()
mod:SetStackCount(1)
	else
	mod:SetStackCount(4)
	self.max_riko = self:GetSpecialValueFor("max_bounces")
	self.riko = 0
local index = self:GetUniqueInt()
	EmitSoundOn("kiana.3", caster)

	local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/kiana_bullet.vpcf",
						iMoveSpeed = self:GetSpecialValueFor("speed"),
						bDodgeable = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
ExtraData = {
			index = index,
		}
						}
						
						

	ProjectileManager:CreateTrackingProjectile(projectile)
	local data = {}
	data.jump = 0
	data.hit_units = {}

	data.jumps = 10
	data.radius = 600
	data.projectile_info = projectile
	self.projectiles[index] = data
	end
	
end

function kiana_weapon_skill:DrifterCombo1_2(target)
	-- unit identifier
	
	
	local target_origin = target:GetAbsOrigin() + RandomVector(500)
	local tp_point = target_origin
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
		local direction = (target:GetOrigin()-target_origin)
		
	-- Blink
	caster:SetOrigin( target_origin )
	FindClearSpaceForUnit( caster, target_origin, true )
local location = GetGroundPosition(target:GetAbsOrigin()+direction*700, nil)
	-- load data
local delay = 0.05

	Timers:CreateTimer(delay,function()

	
	local radius = 150
	local max_dist = 20000000
	local min_dist = 500
	local origin = caster:GetOrigin()
	-- find destination
	local direction = (location-origin)
	local dist = 900
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )

	-- teleport
	FindClearSpaceForUnit( caster, target, true )
local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
	-- find units in line
	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		target,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- perform attack
	--	caster:PerformAttack( enemy, true, true, true, false, true, false, true )
local scale = caster:GetAverageTrueAttackDamage(enemy) * self.attack_scale
damageTable.damage = (self.damage + scale) * 0.6
damageTable.victim = enemy
		ApplyDamage(damageTable)
		-- add modifier
		
	EmitSoundOn("kiana.fast_slash",caster)
		-- play effects
		self:PlayEffects_slash2( enemy )
	end

	-- play effects
	self:PlayEffects_slash( origin, target )
	end)
end

function kiana_weapon_skill:DrifterCombo1_3(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 1,
                        knockback_duration = 0.3,
                        duration = 0.3,
                        knockback_distance = 150,
                        knockback_height = 400,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 4
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects_crit(target)
	EmitSoundOn("kiana.slash_hit",caster)

end


function kiana_weapon_skill:DrifterCombo_ultimate(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	EmitSoundOn("kiana.4_effects",caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_CHAOS_METEOR)

		-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

local knockback = { should_stun = 1,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 300,
                        knockback_height = 400,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

   
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = (caster:GetAverageTrueAttackDamage(target) * self.attack_scale) * 5,
		damage_type = DAMAGE_TYPE_PHYSICAL,
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
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = 0.5 } -- kv
		)
		 enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)

	end
			self:PlayEffects_exp(caster:GetOrigin())
	if caster:HasScepter() then
if caster:HasModifier("modifier_upgrade_core") then
if caster:HasModifier("modifier_ultimate_start") then
if not caster:HasModifier("modifier_herrsher_mode_cooldown") then
	caster:AddNewModifier(caster, self, "modifier_drifter_core", {duration = 30})
		caster:AddNewModifier(caster, self, "modifier_herrsher_mode_cooldown", {duration = 140})
			_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")	
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	_G.CurrentMusicUltima = "kiana.drifter_theme"
_G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 30})
end
end
end
end

end

function kiana_weapon_skill:PlayEffects_exp(origin)
	-- Get Resources
	local particle_cast = "particles/kiana_weapon_exp.vpcf"
	self.parent_origin =  origin
	self.delay = 0.25

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )


	-- Create Sound
	
end


function kiana_weapon_skill:BasicCombo_ultimate(target)
	local caster = self:GetCaster()
	if IsServer() then


EmitSoundOn("kiana.base_ult", caster)
EmitSoundOn("sirin.exp", caster)

	if self.launcher_charge_fx then
	    ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
	end

	local delay = FrameTime() * 8
	
 Timers:CreateTimer(delay,function()
	end)

	

	if bInterrupted then
		caster:Interrupt()
	end
local damage = (caster:GetAverageTrueAttackDamage(target) * self.attack_scale) * 3
	self.launcher_damage = damage 

	local width = 400
	--print(width)
	local distance = self:GetCastRange(caster:GetAbsOrigin(),caster) + caster:GetCastRangeBonus()

	local cero_particle = "particles/kiana_laser.vpcf"
	local cero_particle_end = "particles/bomb_girl_explosion.vpcf"
	local pfx = ParticleManager:CreateParticle(cero_particle, PATTACH_WORLDORIGIN, nil )
	--local pfx_end = ParticleManager:CreateParticle(cero_particle_end, PATTACH_WORLDORIGIN, nil )
	local attach_point = caster:ScriptLookupAttachment("cero")

	ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
	--ParticleManager:SetParticleControl(pfx_end, 0, caster:GetAttachmentOrigin(attach_point))

	local endcapPos = caster:GetAbsOrigin() + caster:GetForwardVector() * distance
	
	GridNav:DestroyTreesAroundPoint(endcapPos, width, false)

	endcapPos = GetGroundPosition( endcapPos, nil )
	endcapPos.z = endcapPos.z + 92

	ParticleManager:SetParticleControl( pfx, 1, endcapPos )
	--ParticleManager:SetParticleControl( pfx_end, 3, endcapPos ) --IN ir EndCap your effect
	self:PlayEffects_bomb(endcapPos)

	local start_loc = caster:GetAbsOrigin() + caster:GetForwardVector() * 32
	local bonus_delay = delay * 3
	local end_delay = bonus_delay + 1
	local hits = 1
	
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

			ApplyDamage(damage_table)

					
		end
		--print("damage done ".. hits)
		if hits < 10 then
			hits = hits + 1
			return bonus_delay * 0.1
		end
	end)

	Timers:CreateTimer(bonus_delay,function()
		ParticleManager:DestroyParticle( pfx, true )
		ParticleManager:ReleaseParticleIndex( pfx )
	end)

	Timers:CreateTimer(end_delay,function()
		--ParticleManager:DestroyParticle( pfx_end, true )
		ParticleManager:ReleaseParticleIndex( pfx_end )
	end)
	end
end
function kiana_weapon_skill:PlayEffects_bomb(origin)
	-- Get Resources
	local particle_cast = "particles/bomb_girl_explosion.vpcf"
	--local sound_cast = "makima.3_2_exp"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 600, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	--EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

kiana_weapon_skill.projectiles = {}
function kiana_weapon_skill:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
local data = self.projectiles[ ExtraData.index ]
local caster = self:GetCaster()
local target = hTarget
	if not hTarget then
		return nil
	end

	if hTarget:IsMagicImmune() then
		return nil
	end
	
	if hTarget:TriggerSpellAbsorb(self) then
		return nil
	end

	
	if target and (not target:IsMagicImmune()) and (not target:IsInvulnerable()) then
		-- mark as hit
		data.hit_units[target] = true
	
	if self:GetCaster():HasModifier("modifier_upgrade_core") then
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_kiana_weapon_skill_exp", {duration = 0.01})
end
local modifier = caster:FindModifierByName("modifier_will_of_the_herrsher")

self.honkai = 0

local attack = caster:GetAverageTrueAttackDamage(target)
	local damage_table = {	victim = hTarget,
							attacker = self:GetCaster(),
							damage = (self:GetSpecialValueFor("damage") ) * 0.3 ,
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
		EmitSoundOn("kiana.spear_throw_impact", hTarget)
	if self:GetCaster() then
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_kiana_weapon_skill_slow", {duration = self:GetSpecialValueFor("duration")})
		end
		
		data.jump = data.jump + 1
		if data.jump>=data.jumps then
		self:Ended(data)
			return
		end
	end

	-- jump to nearby target
	local pos = vLocation
	if target then
		pos = target:GetOrigin()
	end

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		data.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- pick next target
	local next_target = nil
	for _,enemy in pairs(enemies) do

		-- check if it is already hit
		local found = false
		for unit,_ in pairs(data.hit_units) do
			if enemy==unit then
				found = true
				break
			end
		end

		if not found then
			next_target = enemy
			break
		end
	end

	-- not found
	if not next_target then
		-- return projectile without target
		self:Ended( data )
		return
	end

	-- create bounce projectile
	data.projectile_info.Target = next_target
	data.projectile_info.Source = target
	ProjectileManager:CreateTrackingProjectile( data.projectile_info )
end



function kiana_weapon_skill:Ended( data )
	-- unregister projectile
	local index = data.projectile_info.ExtraData.index
	self.projectiles[ index ] = nil
	self:DelUniqueInt( index )

	
end

--Хули смотришь падла!
kiana_weapon_skill.unique = {}
kiana_weapon_skill.i = 0
kiana_weapon_skill.max = 65536
function kiana_weapon_skill:GetUniqueInt()
	while self.unique[ self.i ] do
		self.i = self.i + 1
		if self.i==self.max then self.i = 0 end
	end

	self.unique[ self.i ] = true
	return self.i
end
function kiana_weapon_skill:DelUniqueInt( i )
	self.unique[ i ] = nil
end






function kiana_weapon_skill:BasicCombo1_2(target)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_ATTACK)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}


local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )

	-- precache
	local origin = caster:GetOrigin()
	
			local knockback = { should_stun = 0,
                        knockback_duration = 0.8,
                        duration = 0.8,
                        knockback_distance = 0,
                        knockback_height = 500,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * (self.attack_scale * 2)
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
			EmitSoundOn("kiana.hits",caster)
			self:PlayEffects2(target)
		end
		
function kiana_weapon_skill:BasicCombo1_3(target)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_ATTACK2)

	
	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}


EmitSoundOn("kiana.hits",caster)

			local knockback = { should_stun = 0,
                        knockback_duration = 0.19,
                        duration = 0.19,
                        knockback_distance = 50,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
		
			-- play effects
				self:PlayEffects3(target)
	
		local delay = 0.21

	Timers:CreateTimer(delay,function()
	
			local knockback = { should_stun = 1,
                        knockback_duration = 0.3,
                        duration = 0.3,
                        knockback_distance = 180,
                        knockback_height = 400,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	EmitSoundOn("kiana.last_hit",caster)
		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			self:PlayEffects4(target)
		end)
	

end
function kiana_weapon_skill:PlayEffects_ulti_exp( target )
	-- Load effects
	local particle_cast = "particles/kiana_ulti_exp.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )



end
function kiana_weapon_skill:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/dev/library/base_dust_hit.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_weapon_skill:PlayEffects_crit( target )
	-- Load effects
	local particle_cast = "particles/samurai_flash2.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_weapon_skill:PlayEffects3( target )
	-- Load effects
	local particle_cast = "particles/dev/library/base_dust_hit.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function kiana_weapon_skill:PlayEffects4( target )
	-- Load effects
	local particle_cast = "particles/homura_grenade_explosion.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "kiana.exp", self:GetCaster() )
end
function kiana_weapon_skill:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/kiana_upward_kick.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
--------------------------------------------------------------------------------
-- Play Effects
function kiana_weapon_skill:PlayEffects1( caught, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_weapon_skill_start.vpcf"
	

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_weapon_skill:PlayEffects22( caught, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_weapon_skill_start.vpcf"
		

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end
function kiana_weapon_skill:PlayEffects23( caught, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_weapon_skill_2nd.vpcf"
	

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end

function kiana_weapon_skill:PlayEffects63( caught, direction,origin )
	-- Get Resources
	local particle_cast = "particles/touma_3_alt_combo_2nd.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end
modifier_finality_exp_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_finality_exp_thinker:IsHidden()
	return true
end

function modifier_finality_exp_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_finality_exp_thinker:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()
local modifier = caster:FindModifierByName("modifier_will_of_the_herrsher")

self.honkai = 0

	-- references
	self.duration = 0.79
	self.radius = 350
	self.damage = (self:GetAbility():GetSpecialValueFor( "damage" ) * 1.5) + self.honkai
EmitSoundOn("sirin.fingersnap",self:GetCaster())
	-- precache damage
	
	self:PlayEffects1()
		local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
local parent = self:GetParent()
	for _,enemy in pairs(enemies) do
		-- stun
	
	local p1 = enemy:GetOrigin()
local p2 = self:GetParent():GetOrigin()

	local distance = (p1 - p2):Length2D()
	-- precache
	local origin = parent:GetOrigin()
			local knockback = { should_stun = 1,
                        knockback_duration = 0.4,
                        duration = 0.4,
                        knockback_distance =   (-1 * distance) + 120,
                        knockback_height = 400,
                        center_x = parent:GetAbsOrigin().x,
                        center_y = parent:GetAbsOrigin().y,
                        center_z = parent:GetAbsOrigin().z }

    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
end 
end
function modifier_finality_exp_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/finality_crack_exp.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 0.4

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

function modifier_finality_exp_thinker:OnRefresh( kv )
	
end

function modifier_finality_exp_thinker:OnRemoved()
end

function modifier_finality_exp_thinker:OnDestroy()
	if not IsServer() then return end
local caster = self:GetCaster()
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
		-- stun
		local attack = caster:GetAverageTrueAttackDamage(enemy)
		self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage + attack,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 0.5 } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()
EmitSoundOn("flameshion.exp",self:GetParent())
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_finality_exp_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "jibril.5_1_1"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	--EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end


modifier_sirin_blast_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sirin_blast_thinker:IsHidden()
	return true
end

function modifier_sirin_blast_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_blast_thinker:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()
local modifier = caster:FindModifierByName("modifier_will_of_the_herrsher")

self.honkai = 0

	-- references
	self.duration = 0.5
	self.radius = 350
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self.honkai
EmitSoundOn("sirin.fingersnap",self:GetCaster())
	-- precache damage
	
	self:PlayEffects1()
end 
function modifier_sirin_blast_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/test_sirin_blast.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 0.4

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

function modifier_sirin_blast_thinker:OnRefresh( kv )
	
end

function modifier_sirin_blast_thinker:OnRemoved()
end

function modifier_sirin_blast_thinker:OnDestroy()
	if not IsServer() then return end
local caster = self:GetCaster()
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
		-- stun
		local attack = caster:GetAverageTrueAttackDamage(enemy)
		self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage + attack,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 0.5 } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()
EmitSoundOn("sirin.exp",self:GetParent())
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sirin_blast_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "jibril.5_1_1"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	--EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end
modifier_flameshion_exp_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_flameshion_exp_thinker:IsHidden()
	return true
end

function modifier_flameshion_exp_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_flameshion_exp_thinker:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = 0.79
	self.radius = 350
	
EmitSoundOn("sirin.fingersnap",self:GetCaster())
	
	self:PlayEffects1()
		local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
local parent = self:GetParent()
	for _,enemy in pairs(enemies) do
		-- stun
	
	local p1 = enemy:GetOrigin()
local p2 = self:GetParent():GetOrigin()

	local distance = (p1 - p2):Length2D()
	-- precache
	local origin = parent:GetOrigin()
			local knockback = { should_stun = 1,
                        knockback_duration = 0.4,
                        duration = 0.4,
                        knockback_distance =   (-1 * distance) + 120,
                        knockback_height = 400,
                        center_x = parent:GetAbsOrigin().x,
                        center_y = parent:GetAbsOrigin().y,
                        center_z = parent:GetAbsOrigin().z }

    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
end 
end
function modifier_flameshion_exp_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/kiana_flameshion_portal.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 0.4

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

function modifier_flameshion_exp_thinker:OnRefresh( kv )
	
end

function modifier_flameshion_exp_thinker:OnRemoved()
end

function modifier_flameshion_exp_thinker:OnDestroy()
	if not IsServer() then return end
		local caster = self:GetCaster()
local modifier = caster:FindModifierByName("modifier_will_of_the_herrsher")

self.honkai = 0

self.damage = (self:GetAbility():GetSpecialValueFor("damage") * 1.25) + self.honkai
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
		-- stun
		local attack = caster:GetAverageTrueAttackDamage(enemy)
		self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage + attack,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 0.5 } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()
EmitSoundOn("flameshion.exp",self:GetParent())
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_flameshion_exp_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "jibril.5_1_1"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	--EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_kiana_weapon_skill_slow = class({})
function modifier_kiana_weapon_skill_slow:IsHidden() return false end
function modifier_kiana_weapon_skill_slow:IsDebuff() return true end
function modifier_kiana_weapon_skill_slow:IsPurgable() return true end
function modifier_kiana_weapon_skill_slow:IsPurgeException() return true end
function modifier_kiana_weapon_skill_slow:RemoveOnDeath() return true end
function modifier_kiana_weapon_skill_slow:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}
	return func
end
function modifier_kiana_weapon_skill_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end
function modifier_kiana_weapon_skill_slow:GetEffectName()
	return ""
end
function modifier_kiana_weapon_skill_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



kiana_ultimate = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kiana_ulti_buff", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sirin_up_spear", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drifter_knock_damage", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_flameshion_shield_converted", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier

function kiana_ultimate:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local mod = caster:FindModifierByName("modifier_nyan_nyan")
	local duration = self:GetSpecialValueFor("duration")
		mod:SetStackCount(6)
	if caster:HasModifier("modifier_core_upgrade_2") then
		self:FlameshionUltimate()
	elseif caster:HasModifier("modifier_sirin_awakening") then
	self:SirinUltimate()
	elseif caster:HasModifier("modifier_upgrade_core") then
		self:DrifterUltimate()
	else
	self:BasicUltimate()

	end
	end
function kiana_ultimate:FlameshionUltimate()
	-- unit identifier
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 0.7 } -- kv
		)
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_flameshion_shield_converted", -- modifier name
			{ duration = 5 } -- kv
		)
	-- load data
	local radius = 500
	local duration_stun = 1
	local damage = self:GetSpecialValueFor("damage")
	self.radius = 500
		local angle = 140/2
	local distance = 500
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
		local pos = GetGroundPosition(caster:GetAbsOrigin()+caster:GetForwardVector()*400, nil)
	-- logic
		local delay = 0.7

	Timers:CreateTimer(delay,function()
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
		damage = damage * 1.5,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
		damageTable.victim = enemy
		ApplyDamage(damageTable)

	

    enemy:AddNewModifier(caster, self, "modifier_kiana_air_combo", {duration = 1.5})
	    enemy:AddNewModifier(caster, self, "modifier_drifter_knock_damage", {duration = 1.49})
		--self:PlayEffects2(enemy)
	end
	end
		self:PlayEffectsFlameshionEXP( pos )
	end)
    EmitSoundOn("flameshion.4", caster)

end
	
function kiana_ultimate:DrifterUltimate()
	-- unit identifier
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration_stun = self:GetSpecialValueFor("stun")
	local damage = self:GetSpecialValueFor("damage")

	-- logic
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
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		local knockback = { should_stun = 1,
                        knockback_duration = 1.5,
                        duration = 1.5,
                        knockback_distance = 0,
                        knockback_height = 600,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	    enemy:AddNewModifier(caster, self, "modifier_drifter_knock_damage", {duration = 1.49})
		--self:PlayEffects2(enemy)
	end
    EmitSoundOn("kiana.drifter_4", caster)
	self:PlayEffectsBlackHole( radius )
end
	
	function kiana_ultimate:SirinUltimate()
	-- unit identifier
  
	local caster = self:GetCaster()
	 EmitSoundOn("sirin.1_1",caster)
	 EmitSoundOn("sirin.4", caster)
	local duration = self:GetSpecialValueFor("duration")
	for i = 1, 100 do
		local delay = i * 0.02

	Timers:CreateTimer(delay,function()
		local rng = RandomInt(10,400)
	local rng = caster:GetOrigin() + RandomVector(rng)
	
		self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_up_spear", -- modifier name
		{ duration = 0.1 }, -- kv
		rng,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects_UpSpear(rng)
	end)
	end
	end
	
function kiana_ultimate:PlayEffects_UpSpear(origin)
	-- Get Resources
	local particle_cast = "particles/kiana_upward_spear.vpcf"
	self.delay = 0.5

	-- Get Data
	local height = -100
	local height_target = 1000

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

	
--------------------------------------------------------------------------------
-- Ability Start
function kiana_ultimate:BasicUltimate()
	-- unit identifier
	local caster = self:GetCaster()
	 EmitSoundOn("kiana.4", caster)
	 EmitSoundOn("kiana.4_effects", caster)
	local duration = self:GetSpecialValueFor("duration")
caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_kiana_ulti_buff", -- modifier name
			{ duration = duration } -- kv
		)
	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration_stun = self:GetSpecialValueFor("stun")
	local damage = self:GetSpecialValueFor("damage")

	-- logic
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
		damage_type = DAMAGE_TYPE_PHYSICAL,
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
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = 0.5 } -- kv
		)
		self:PlayEffects2(enemy)
	end
    EmitSoundOn("kiana.ulti", caster)
	self:PlayEffects( radius )
end

function kiana_ultimate:PlayEffects( radius )
	local particle_cast = "particles/kiana_ultimate.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_ultimate:PlayEffectsFlameshionEXP( position )
	local particle_cast = "particles/kiana_flameshion_ult_exp.vpcf"

local radius = 500
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, position )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_ultimate:PlayEffectsBlackHole( radius )
	local particle_cast = "particles/void_drifter_ultimate.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_ultimate:PlayEffects2( target )
	local particle_cast = "particles/kiana_neko_chan_paw.vpcf"

local radius = 500
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_flameshion_shield_converted = modifier_flameshion_shield_converted or class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return false end
})

function modifier_flameshion_shield_converted:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_flameshion_shield_converted:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local shield_size = target:GetModelRadius() * 0.7
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel()
		local target_origin = target:GetAbsOrigin()
		local attach_hitloc = "attach_hitloc"
        local init_health = caster:GetHealth()
		self.shield_init_value = (caster:GetMaxHealth() * 0.5) 
		self.shield_remaining = self.shield_init_value
		self.target_current_health = target:GetHealth()
		self:SetStackCount(self.target_current_health)
		if caster:HasTalent("special_bonus_kiana_20") then
		else
		caster:SetHealth(init_health - (caster:GetHealth() * 0.35))
		end
	local particle = ParticleManager:CreateParticle("particles/kiana_flame_shield_visual.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local common_vector = Vector(shield_size,0,shield_size)
		ParticleManager:SetParticleControl(particle, 1, common_vector)
		ParticleManager:SetParticleControl(particle, 2, common_vector)
		ParticleManager:SetParticleControl(particle, 4, common_vector)
		ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc, target_origin, true)
		self:AddParticle(particle, false, false, -1, false, false)
		-- Talent : During the first second of Aphotic Shield, it absorbs all damage done to it and adds it to it's health/damage
		

		
	
		
	end
end

function modifier_flameshion_shield_converted:OnDestroy()
	if IsServer() then
		local target 				= self:GetParent()
		local caster 				= self:GetCaster()
		local ability 				= self:GetAbility()
		local ability_level 		= ability:GetLevel()
		local radius 				= 400
		local explode_target_team 	= DOTA_UNIT_TARGET_TEAM_BOTH
		local explode_target_type 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_vector			= target:GetAbsOrigin()

		

		local particle = ParticleManager:CreateParticle("particles/dante_bicycle_explosion.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, target_vector)
		ParticleManager:ReleaseParticleIndex(particle)
	end
end


--Block damage
function modifier_flameshion_shield_converted:GetModifierTotal_ConstantBlock(kv)
	if IsServer() then
		local target 					= self:GetParent()
		local original_shield_amount	= self.shield_remaining
	
		-- Avoid blocking when borrowed time is active						--No need for block when there is no damage
		if not target:HasModifier("modifier_imba_borrowed_time_buff_hot_caster")  and kv.damage > 0 and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then

			if self.has_talent and not self.invulnerability_expired then
				-- damage_absorbtion_end is calculated in OnCreated
				if GameRules:GetGameTime() <= self.damage_absorption_end then
					self.shield_remaining = self.shield_remaining + kv.damage
					original_shield_amount = self.shield_remaining
					-- Increase the max capacity. The if check is just for sanity
					if self.shield_remaining > self.shield_init_value then
						self.shield_init_value = self.shield_remaining
					end
				else
					-- copy-paste of code, but that allows skipping on GetGameTime calls in the if
					self.shield_remaining = self.shield_remaining - kv.damage
					self.invulnerability_expired = true
				end
			else
				--Reduce the amount of shield remaining
				self.shield_remaining = self.shield_remaining - kv.damage
			end
	self:SetStackCount(self.shield_remaining)

			--If there is enough shield to block everything, then block everything.
			if kv.damage < original_shield_amount then
				--Emit damage blocking effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, kv.damage, nil)
				return kv.damage
					--Else, reduce what you can and blow up the shield
			else
				--Emit damage block effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, original_shield_amount, nil)
				self:Destroy()
				return original_shield_amount
			end

		end
	end

end

function modifier_flameshion_shield_converted:ResetAndExtendBy(seconds)
	self.shield_remaining = self.shield_init_value
	self:SetDuration(self:GetRemainingTime() + seconds, true)
end

modifier_drifter_knock_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_drifter_knock_damage:IsHidden()
	return true
end

function modifier_drifter_knock_damage:IsDebuff()
	return true
end

function modifier_drifter_knock_damage:IsStunDebuff()
	return false
end

function modifier_drifter_knock_damage:IsPurgable()
	return true
end

function modifier_drifter_knock_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_drifter_knock_damage:OnCreated( kv )
	-- references
	self.duration = 1.49
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
	
end

function modifier_drifter_knock_damage:OnRefresh( kv )
	
end

function modifier_drifter_knock_damage:OnRemoved()
end

function modifier_drifter_knock_damage:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_drifter_knock_damage:DeclareFunctions()
	local funcs = {
		

	--	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_drifter_knock_damage:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_drifter_knock_damage:Silence()
	-- add silence
	

	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )


self:PlayEffects(300)
	self:Destroy()
end

function modifier_drifter_knock_damage:PlayEffects( radius )
	local particle_cast = "particles/centaur_warstomp1.vpcf"
	local sound_cast = "kiana.ground_shake"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
modifier_sirin_up_spear = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_up_spear:OnCreated( kv )
	-- references
	self.radius = 80

	if IsServer() then
		--self:PlayEffects()
	end
end

function modifier_sirin_up_spear:OnRefresh( kv )
	
end

function modifier_sirin_up_spear:OnRemoved()
end

function modifier_sirin_up_spear:OnDestroy()

    self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) * 0.05
	local damage = self.damage
	self.radius = 300
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(), --Optional.
	}
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
 --  EmitSoundOn("kiana.slash", enemy)
		-- play overhead event
		
	end






	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end




modifier_kiana_ulti_buff = class({})
function modifier_kiana_ulti_buff:IsHidden() return true end
function modifier_kiana_ulti_buff:IsDebuff() return false end
function modifier_kiana_ulti_buff:IsPurgable() return false end
function modifier_kiana_ulti_buff:IsPurgeException() return false end
function modifier_kiana_ulti_buff:RemoveOnDeath() return false end

---------------------------------------------------------------------------------------------------------------------
function modifier_kiana_ulti_buff:DeclareFunctions()
	local func = { 	
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return func
end

  function modifier_kiana_ulti_buff:GetModifierPreAttack_BonusDamage()
 local r = 150
  self.damage = self:GetAbility():GetSpecialValueFor("boost") * r
return self.damage
end 




kiana_special = class({})
LinkLuaModifier( "modifier_kiana_special", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "modifiers/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )

function kiana_special:GetCastRange( location , target)
	if self:GetCaster():HasModifier("modifier_sirin_awakening") then
	
		return 800
	end
	return 250
end
--------------------------------------------------------------------------------
-- Ability Start
function kiana_special:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	local target = self:GetCursorTarget()
	self.damage = self:GetSpecialValueFor("base_damage")
	self.attack_scale = self:GetSpecialValueFor("attack_scale")
--	self.radius = self:GetSpecialValueFor("radius")
	--end
	if caster:HasModifier("modifier_core_upgrade_3") then
	self:FinalityCombo(target)
	elseif caster:HasModifier("modifier_core_upgrade_2") then
	self:FlameshionCombo(target)
	elseif caster:HasModifier("modifier_sirin_awakening") then
	self:SirinCombo(target)
	elseif caster:HasModifier("modifier_upgrade_core") then
	self:DrifterCombo(target)
	else
	self:BasicCombo(target)
	
	end

end

----------------------
--FinalityCombo
----------------------
function kiana_special:FinalityCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
		 caster:AddNewModifier(caster, self, "modifier_generic_silenced_lua", {duration = 0.8})
	    EmitSoundOn("finality.6", caster)
self:FinalityCombo1(target)
local delay = 0.4

	Timers:CreateTimer(delay,function()
	self:FinalityCombo2(target)
	end)
	
	local delay = 0.6

	Timers:CreateTimer(delay,function()
	self:FinalityCombo3(target)
	end)
	local delay = 0.8
	Timers:CreateTimer(delay,function()
	self:FinalityCombo4(target)
	end)
	
end

function kiana_special:FinalityCombo1(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

 EmitSoundOn("kiana.hits", caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 100,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffectsStarHit(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)
	local delay = 0.15
 EmitSoundOn("kiana.hits", caster)
	Timers:CreateTimer(delay,function()
		local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 100,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffectsStarHit(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)
	
	end)
		local delay = 0.3
 EmitSoundOn("kiana.hits", caster)
	Timers:CreateTimer(delay,function()
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.05,
                        duration = 0.05,
                        knockback_distance = 200,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffectsStarHit(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)
			 end)
end
function kiana_special:FinalityCombo2(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

 EmitSoundOn("kiana.slash", caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK2)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = -300,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffectsStarHit(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)


end
function kiana_special:FinalityCombo3(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

 EmitSoundOn("kiana.hits", caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK2)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = -300,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffectsStarHit(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)


end
function kiana_special:FinalityCombo4(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
 EmitSoundOn("kiana.last_hit", caster)

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}




	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 2
damageTable.victim = target
		ApplyDamage(damageTable)
		
			-- play effects
				self:PlayEffectsExplosionFinality(target)
	
	


	

end
function kiana_special:PlayEffectsExplosionFinality( target )
	-- Load effects
	local particle_cast = "particles/darkness_parade_explosion.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_special:PlayEffectsStarHit( target )
	-- Load effects
	local particle_cast = "particles/kiana_star_hit.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

------------------------------------\
--FlameshionCombo
------------------------------------
function kiana_special:FlameshionCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	 --   caster:AddNewModifier(caster, self, "modifier_sirin_special", {duration = 1.0})
	  EmitSoundOn("flameshion.6", caster)
	 self:FlameshionCombo1(target)
		 caster:AddNewModifier(caster, self, "modifier_generic_silenced_lua", {duration = 0.8})
end




function kiana_special:FlameshionCombo1(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_CHAOS_METEOR)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 125,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				--self:PlayEffects(target)
           --  caster:SetForwardVector(caster:GetForwardVector() * -1)
 EmitSoundOn("kiana.slash", caster)
 
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale 
damageTable.damage = (self.damage + scale)  * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
 local delay = 0.15

	Timers:CreateTimer(delay,function()
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
--caster:StartGesture(ACT_DOTA_CAST_ABILITY_7)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 135,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				--self:PlayEffects(target)
            -- caster:SetForwardVector(caster:GetForwardVector() * -1)
 EmitSoundOn("kiana.slash", caster)
		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale)  * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
	end)
 local delay = 0.3

	Timers:CreateTimer(delay,function()
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
--caster:StartGesture(ACT_DOTA_CAST_ABILITY_7)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 135,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				--self:PlayEffects(target)
          --   caster:SetForwardVector(caster:GetForwardVector() * -1)
 EmitSoundOn("kiana.slash", caster)
		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale)  * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
	end)
	 local delay = 0.45

	Timers:CreateTimer(delay,function()
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 135,
                        knockback_height = 200,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				--self:PlayEffects(target)
           --  caster:SetForwardVector(caster:GetForwardVector() * -1)
 EmitSoundOn("kiana.slash", caster)
		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
	end)
	 local delay = 0.6

	Timers:CreateTimer(delay,function()
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_COLD_SNAP)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.15,
                        duration = 0.15,
                        knockback_distance = 135,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				--self:PlayEffects(target)
           --  caster:SetForwardVector(caster:GetForwardVector() * -1)
 EmitSoundOn("kiana.slash", caster)
		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale)  * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
	end)
	 local delay = 0.8

	Timers:CreateTimer(delay,function()
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK2)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 1,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 0,
                        knockback_height = -300,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				self:PlayEffectsExplosionFlameshion(target)
            -- caster:SetForwardVector(caster:GetForwardVector() * -1)
 EmitSoundOn("sirin.exp", caster)
		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale)  * 2
damageTable.victim = target
		ApplyDamage(damageTable)
	end)
end


function kiana_special:PlayEffectsExplosionFlameshion( target )
	-- Load effects
	local particle_cast = "particles/flameshion_exp1.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end







---------------------
--------------------------------------
--VoidDrifter-------------------------
--------------------------------------

function kiana_special:DrifterCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	 --   caster:AddNewModifier(caster, self, "modifier_sirin_special", {duration = 1.0})
	  EmitSoundOn("kiana.drifter_shard", caster)
	  		 caster:AddNewModifier(caster, self, "modifier_generic_silenced_lua", {duration = 0.8})
	 self:DrifterCombo1(target)
for i = 1, 20 do
local delay = i * 0.03

	Timers:CreateTimer(delay,function()
	self:DrifterCombo2(target)
	end)
	end
	
	local delay = 0.7

	Timers:CreateTimer(delay,function()
	self:DrifterCombo3(target)
	end)

	
end





function kiana_special:DrifterCombo1(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_CAST_ABILITY_7)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 1,
                        knockback_duration = 0.6,
                        duration = 0.6,
                        knockback_distance = 70,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				--self:PlayEffects(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)
 EmitSoundOn("kiana.slash", caster)

end



function kiana_special:DrifterCombo2(target)
local caster = self:GetCaster()

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}




	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 0.2
damageTable.victim = target
		ApplyDamage(damageTable)
		
			-- play effects
				self:PlayEffectsHits(target)


 EmitSoundOn("kiana.slash", caster)
	

end

function kiana_special:PlayEffectsHits(target)
	-- Load effects
	local particle_cast = "particles/test_kiana_multiple_hits.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

function kiana_special:DrifterCombo3(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

 EmitSoundOn("kiana.slash", caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
--caster:StartGesture(ACT_DOTA_CAST_ABILITY_7)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 1,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 70,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				--self:PlayEffects(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)
			 	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) 
damageTable.victim = target
		ApplyDamage(damageTable)
				self:PlayEffects(target)
local delay = 0.12
	Timers:CreateTimer(delay,function()
	local knockback = { should_stun = 1,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 70,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				self:PlayEffects(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)
			 	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) 
damageTable.victim = target
		ApplyDamage(damageTable)
		 EmitSoundOn("kiana.slash", caster)
		end)
		local delay = 0.24
	Timers:CreateTimer(delay,function()
	local knockback = { should_stun = 1,
                        knockback_duration = 0.4,
                        duration = 0.4,
                        knockback_distance = 400,
                        knockback_height = 1000,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
				--self:PlayEffects(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)
			 	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale)
damageTable.victim = target
		ApplyDamage(damageTable)
				self:PlayEffectsLastHit(target)
				 EmitSoundOn("kiana.slash", caster)
		end)
end

function kiana_special:PlayEffectsLastHit(target)
	-- Load effects
	local particle_cast = "particles/void_drifter_crit.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end


-------------------------------------
--Sirin
------------------------------------




function kiana_special:SirinCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	    caster:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.0})
 EmitSoundOn("sirin.6", caster)
self:SirinCombo1(target)
local delay = 0.4

	Timers:CreateTimer(delay,function()
	self:SirinCombo2(target)
	end)
	
	local delay = 0.7

	Timers:CreateTimer(delay,function()
	self:SirinCombo3(target)
	end)
	local delay = 1.0
	Timers:CreateTimer(delay,function()
	self:SirinCombo4(target)
	end)
	
end



function kiana_special:SirinCombo1(target)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
local p1 = target:GetOrigin()
local p2 = caster:GetOrigin()
 EmitSoundOn("sirin.swoosh", caster)
	local distance = (p1 - p2):Length2D()
	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.3,
                        duration = 0.3,
                        knockback_distance =   (-1 * distance) + 120,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	
				self:PlayEffects(target)
    
local delay = 0.3

	Timers:CreateTimer(delay,function()
	self:PlayEffects(target)
	end)

end



function kiana_special:SirinCombo2(target)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_ATTACK_SPECIAL)
local p1 = target:GetOrigin()
local p2 = caster:GetOrigin()
 EmitSoundOn("sirin.fingersnap", caster)
  EmitSoundOn("kiana.ground_shake", caster)
	local distance = (p1 - p2):Length2D()
	local pos_cube = GetGroundPosition(caster:GetAbsOrigin()+caster:GetForwardVector()*720,nil)
	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.25,
                        duration = 0.25,
                        knockback_distance =  400,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	
				self:PlayEffects(target)
    
self:PlayEffects_GroundCube(pos_cube,target:GetForwardVector() * -1)

end

function kiana_special:PlayEffects_GroundCube( origin, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_combo_standing_cube.vpcf"
	

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end


function kiana_special:SirinCombo3(target)
local caster = self:GetCaster()

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}




	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 2
damageTable.victim = target
		ApplyDamage(damageTable)
		
			-- play effects
				self:PlayEffects_CubeSmash(target)


  EmitSoundOn("kiana.ground_shake", caster)
	

end
function kiana_special:PlayEffects_CubeSmash(target)
	-- Get Resources
	local particle_cast = "particles/test_cube_smash.vpcf"
	self.parent_origin = target:GetOrigin()
	self.delay = 0.4

	-- Get Data
	local h1 =  Vector(0,800,0)
	local h2 = Vector(0,-800,0)
	local h3 =  Vector(800,0,0)
	local h4 = Vector(-800,0,0)
	local h0 = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + h1 )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + h2 )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
		local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + h3 )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + h4 )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
end
	

function kiana_special:SirinCombo4(target)
local caster = self:GetCaster()

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}




local delay = 0.4
	Timers:CreateTimer(delay,function()
		local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = (self.damage + scale) * 3
damageTable.victim = target
		ApplyDamage(damageTable)
			local knockback = { should_stun = 0,
                        knockback_duration = 0.25,
                        duration = 0.25,
                        knockback_distance =  0,
                        knockback_height = -400,
                        center_x = target:GetAbsOrigin().x,
                        center_y = target:GetAbsOrigin().y,
                        center_z = target:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	  EmitSoundOn("kiana.slash", target)
	    EmitSoundOn("sirin.exp", target)
		end)
		
			-- play effects
				self:PlayEffectsExplosion(target)
	



	

end

function kiana_special:PlayEffectsExplosion( target )
	-- Load effects
	local particle_cast = "particles/sirin_cuts.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
---------------------------------------------
--Base
----------------------------------------------

function kiana_special:BasicCombo(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
			 caster:AddNewModifier(caster, self, "modifier_generic_silenced_lua", {duration = 0.8})
	    EmitSoundOn("kiana.6_base", caster)
self:BasicCombo1(target)
local delay = 0.25

	Timers:CreateTimer(delay,function()
	self:BasicCombo2(target)
	end)
	
	local delay = 0.5

	Timers:CreateTimer(delay,function()
	self:BasicCombo3(target)
	end)
	local delay = 0.75
	Timers:CreateTimer(delay,function()
	self:BasicCombo4(target)
	end)
	
end

function kiana_special:BasicCombo1(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

 EmitSoundOn("kiana.hits", caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK_SPECIAL)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 300,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)


end
function kiana_special:BasicCombo2(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

 EmitSoundOn("kiana.hits", caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK_SPECIAL)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = -500,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)


end
function kiana_special:BasicCombo3(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

 EmitSoundOn("kiana.hits", caster)
	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK_SPECIAL)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}

	-- precache
	local origin = caster:GetOrigin()
			local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = -200,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
			caught = true
			-- play effects
				self:PlayEffects(target)
             caster:SetForwardVector(caster:GetForwardVector() * -1)


end
function kiana_special:BasicCombo4(target)
local caster = self:GetCaster()
local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
 EmitSoundOn("kiana.last_hit", caster)

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
caster:StartGesture(ACT_DOTA_ATTACK_EVENT_BASH)

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}




	local scale = caster:GetAverageTrueAttackDamage(target) * self.attack_scale
damageTable.damage = self.damage + scale
damageTable.victim = target
		ApplyDamage(damageTable)
		
			-- play effects
				self:PlayEffects4(target)
	
		local delay = 0.21


	

end
function kiana_special:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/dev/library/base_dust_hit.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function kiana_special:PlayEffects3( target )
	-- Load effects
	local particle_cast = "particles/dev/library/base_dust_hit.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "kiana.exp", self:GetCaster() )
end
function kiana_special:PlayEffects4( target )
	-- Load effects
	local particle_cast = "particles/homura_grenade_explosion.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "kiana.exp", self:GetCaster() )
end
function kiana_special:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/kiana_upward_kick.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
--------------------------------------------------------------------------------
-- Play Effects
function kiana_special:PlayEffects1( caught, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_special_start.vpcf"
	
		--local sound_cast = "touma.1"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	--EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function kiana_special:PlayEffects22( caught, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_special_start.vpcf"
		--local sound_cast = "touma.1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	--EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function kiana_special:PlayEffects23( caught, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_special_2nd.vpcf"
	
	--	local sound_cast = "touma.1_1"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	--EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function kiana_special:PlayEffects63( caught, direction,origin )
	-- Get Resources
	local particle_cast = "particles/touma_3_alt_combo_2nd.vpcf"
	
		--local sound_cast = "touma.1_2"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	--EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end


kiana_final_form = class({})
LinkLuaModifier("modifier_core_upgrade_3", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)

function kiana_final_form:IsStealable() return true end
function kiana_final_form:IsHiddenWhenStolen() return false end


function kiana_final_form:OnSpellStart()
    local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("will_of_the_herrsher")
	Kiana_Scepter(ability, caster:HasScepter())
	if caster:HasModifier("modifier_core_upgrade_3") then self:EndCooldown() return end
	local mod = caster:FindModifierByName("modifier_will_of_the_herrsher")
	local stack = mod:GetStackCount()
	if stack >= 110000 then
 if caster:FindModifierByNameAndCaster("modifier_form_swap", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_form_swap", caster)
		
		end
		caster:RemoveModifierByNameAndCaster("modifier_upgrade_core", caster)
			caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_2", caster)
			--	caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_3", caster)
					caster:RemoveModifierByNameAndCaster("modifier_sirin_awakening", caster)
				
		
   caster:AddNewModifier(caster, self, "modifier_core_upgrade_3", {})
 EmitSoundOn("kiana.swap", caster)
 self:PlayEffects(300)
	if caster:HasModifier("modifier_item_aghanims_shard") then
				local FastAbilities = 
	{
		"kiana_combo_hit",
		"kiana_weapon_skill",
		
		
	}

	for _,FastAbility in pairs(FastAbilities) do
	   	FastAbility = self:GetCaster():FindAbilityByName(FastAbility)
	   	if self:GetCaster():IsRealHero() then
	      	if FastAbility then
	        	FastAbility:EndCooldown()
	      	end
	    end
		end
		end
 end
end
function kiana_final_form:PlayEffects( radius )

	local particle_cast = "particles/void_drifter_activation_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


kiana_flameshion_form = class({})
LinkLuaModifier("modifier_core_upgrade_2", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)

function kiana_flameshion_form:IsStealable() return true end
function kiana_flameshion_form:IsHiddenWhenStolen() return false end


function kiana_flameshion_form:OnSpellStart()
    local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("will_of_the_herrsher")
	Kiana_Scepter(ability, caster:HasScepter())
	if caster:HasModifier("modifier_core_upgrade_2") then self:EndCooldown() return end
		local mod = caster:FindModifierByName("modifier_will_of_the_herrsher")
	local stack = mod:GetStackCount()
	if stack >= 80000 then
 if caster:FindModifierByNameAndCaster("modifier_form_swap", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_form_swap", caster)
		
		end
		caster:RemoveModifierByNameAndCaster("modifier_upgrade_core", caster)
			--caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_2", caster)
			caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_3", caster)
					caster:RemoveModifierByNameAndCaster("modifier_sirin_awakening", caster)
				
   caster:AddNewModifier(caster, self, "modifier_core_upgrade_2", {})
 EmitSoundOn("kiana.swap", caster)
 self:PlayEffects(300)
 	if caster:HasModifier("modifier_item_aghanims_shard") then
				local FastAbilities = 
	{
		"kiana_combo_hit",
		"kiana_weapon_skill",
		
		
	}

	for _,FastAbility in pairs(FastAbilities) do
	   	FastAbility = self:GetCaster():FindAbilityByName(FastAbility)
	   	if self:GetCaster():IsRealHero() then
	      	if FastAbility then
	        	FastAbility:EndCooldown()
	      	end
	    end
		end
		end
end
end
function kiana_flameshion_form:PlayEffects( radius )

	local particle_cast = "particles/void_drifter_activation_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


kiana_sirin_form = class({})
LinkLuaModifier( "modifier_sirin_awakening", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )

function kiana_sirin_form:IsStealable() return true end
function kiana_sirin_form:IsHiddenWhenStolen() return false end


function kiana_sirin_form:OnSpellStart()
    local caster = self:GetCaster()
	if caster:HasModifier("modifier_sirin_awakening") then self:EndCooldown() return end
		local mod = caster:FindModifierByName("modifier_will_of_the_herrsher")
	local stack = mod:GetStackCount()
	if stack >= 50000 then
 if caster:FindModifierByNameAndCaster("modifier_form_swap", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_form_swap", caster)
		
		end
		caster:RemoveModifierByNameAndCaster("modifier_upgrade_core", caster)
			caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_2", caster)
				caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_3", caster)
					--caster:RemoveModifierByNameAndCaster("modifier_sirin_awakening", caster)
				
   caster:AddNewModifier(caster, self, "modifier_sirin_awakening", {})
 EmitSoundOn("kiana.swap", caster)
 self:PlayEffects(300)
 local FastAbilities = 
	{
		"kiana_combo_hit",
		--"kiana_weapon_skill",
		"kiana_special",
		
	}

	for _,FastAbility in pairs(FastAbilities) do
	   	FastAbility = self:GetCaster():FindAbilityByName(FastAbility)
	   	if self:GetCaster():IsRealHero() then
	      	if FastAbility then
	        	FastAbility:EndCooldown()
	      	end
	    end
		end
end
end
function kiana_sirin_form:PlayEffects( radius )

	local particle_cast = "particles/void_drifter_activation_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


kiana_drifter_form = class({})
LinkLuaModifier("modifier_upgrade_core", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)

function kiana_drifter_form:IsStealable() return true end
function kiana_drifter_form:IsHiddenWhenStolen() return false end


function kiana_drifter_form:OnSpellStart()
    local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("will_of_the_herrsher")
	Kiana_Scepter(ability, caster:HasScepter())
	if caster:HasModifier("modifier_upgrade_core") then self:EndCooldown() return end
 if caster:FindModifierByNameAndCaster("modifier_form_swap", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_form_swap", caster)
		
		end
		--caster:RemoveModifierByNameAndCaster("modifier_upgrade_core", caster)
			caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_2", caster)
				caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_3", caster)
					caster:RemoveModifierByNameAndCaster("modifier_sirin_awakening", caster)
					if caster:HasModifier("modifier_item_aghanims_shard") then
				local FastAbilities = 
	{
		"kiana_combo_hit",
		"kiana_weapon_skill",
		
		
	}

	for _,FastAbility in pairs(FastAbilities) do
	   	FastAbility = self:GetCaster():FindAbilityByName(FastAbility)
	   	if self:GetCaster():IsRealHero() then
	      	if FastAbility then
	        	FastAbility:EndCooldown()
	      	end
	    end
		end
		end
   caster:AddNewModifier(caster, self, "modifier_upgrade_core", {})
 EmitSoundOn("kiana.swap", caster)
 self:PlayEffects(300)
end
function kiana_drifter_form:PlayEffects( radius )

	local particle_cast = "particles/void_drifter_activation_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

function Kiana_Scepter(hAbility, bScepter)
    if bScepter or not hAbility then
		return
	end
    hAbility:StartCooldown(10)
end


kiana_base_form = class({})

function kiana_base_form:IsStealable() return true end
function kiana_base_form:IsHiddenWhenStolen() return false end


function kiana_base_form:OnSpellStart()
    local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("will_of_the_herrsher")
	Kiana_Scepter(ability, caster:HasScepter())
	if caster:HasModifier("modifier_sirin_awakening") or caster:HasModifier("modifier_upgrade_core") or caster:HasModifier("modifier_core_upgrade_2") or caster:HasModifier("modifier_core_upgrade_3") then
 if caster:FindModifierByNameAndCaster("modifier_form_swap", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_form_swap", caster)
		
		end
		caster:RemoveModifierByNameAndCaster("modifier_upgrade_core", caster)
			caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_2", caster)
				caster:RemoveModifierByNameAndCaster("modifier_core_upgrade_3", caster)
					caster:RemoveModifierByNameAndCaster("modifier_sirin_awakening", caster)
				
	if caster:HasModifier("modifier_item_aghanims_shard") then
				local FastAbilities = 
	{
		"kiana_combo_hit",
		"kiana_weapon_skill",
		
		
	}

	for _,FastAbility in pairs(FastAbilities) do
	   	FastAbility = self:GetCaster():FindAbilityByName(FastAbility)
	   	if self:GetCaster():IsRealHero() then
	      	if FastAbility then
	        	FastAbility:EndCooldown()
	      	end
	    end
		end
		end
 EmitSoundOn("kiana.swap", caster)
 self:PlayEffects(300)
 else
 self:EndCooldown()
 end
end

function kiana_base_form:PlayEffects( radius )

	local particle_cast = "particles/void_drifter_activation_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


will_of_the_herrsher_close = class({})


function will_of_the_herrsher_close:IsStealable() return true end
function will_of_the_herrsher_close:IsHiddenWhenStolen() return false end
function will_of_the_herrsher_close:OnSpellStart()
    local caster = self:GetCaster() 

    if caster:FindModifierByNameAndCaster("modifier_form_swap", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_form_swap", caster)

        --return nil
    end
end



will_of_the_herrsher = class({})
LinkLuaModifier( "modifier_will_of_the_herrsher", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sirin_awakening", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_divine_energy", "new_element_modifier/divine_energy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_divine_check", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier("modifier_upgrade_core", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_sirin_awakening", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_core_upgrade_2", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_core_upgrade_3", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier( "modifier_form_swap", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function will_of_the_herrsher:GetIntrinsicModifierName()
	return "modifier_will_of_the_herrsher"
end


function will_of_the_herrsher:Spawn()
    if IsServer() then
		Timers:CreateTimer(0.1, function()
			self:SetLevel(1)
		end)
    end
end
function will_of_the_herrsher:OnUpgrade()
local level = self:GetLevel()
local FastAbilities = 
	{
		"kiana_base_form",
		"kiana_drifter_form",
		"kiana_sirin_form",
		"kiana_flameshion_form",
		"kiana_final_form",
		"will_of_the_herrsher_close"
	}

	for _,FastAbility in pairs(FastAbilities) do
	   	FastAbility = self:GetCaster():FindAbilityByName(FastAbility)
	   	if self:GetCaster():IsRealHero() then
	      	if FastAbility then
	        	FastAbility:SetLevel(level)
	      	end
	    end
end
end




function will_of_the_herrsher:OnSpellStart()
 local caster = self:GetCaster()
local modifier = caster:FindModifierByName("modifier_will_of_the_herrsher")
if modifier then
local stack = modifier:GetStackCount()
  caster:AddNewModifier(caster, self, "modifier_form_swap", {})
  

	end
	end
	



modifier_form_swap = class({})
function modifier_form_swap:IsHidden() return false end
function modifier_form_swap:IsDebuff() return true end
function modifier_form_swap:IsPurgable() return false end
function modifier_form_swap:IsPurgeException() return false end
function modifier_form_swap:RemoveOnDeath() return true end
function modifier_form_swap:AllowIllusionDuplicate() return true end


function modifier_form_swap:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

	if self.caster:HasModifier("modifier_core_upgrade_3") then
	
	 self.skills_table = {
                            
							["will_of_the_herrsher"]="will_of_the_herrsher_close",
							["kiana_combo_hit"]="kiana_base_form",
							["kiana_evasion"]="kiana_drifter_form",
							["kiana_weapon_skill"]="kiana_sirin_form",
								["kiana_global_kick"]="kiana_flameshion_form",
								["kiana_special"]="kiana_final_form",
				
							}
	else
	

    self.skills_table = {
                            
							["will_of_the_herrsher"]="will_of_the_herrsher_close",
							["kiana_combo_hit"]="kiana_base_form",
							["kiana_evasion"]="kiana_drifter_form",
							["kiana_weapon_skill"]="kiana_sirin_form",
								["kiana_ultimate"]="kiana_flameshion_form",
								["kiana_special"]="kiana_final_form",
							
							
							
                        }
						
						end
					

    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                  
                end
            end
        end
		
           
        
		
      

  
    end
end
function modifier_form_swap:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_form_swap:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

         

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("keyaru_switch_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end




modifier_divine_check = class({})

--------------------------------------------------------------------------------

function modifier_divine_check:IsHidden()
	return true
end

function modifier_divine_check:IsDebuff()
	return false
end

function modifier_divine_check:IsPurgable()
	return false
end

function modifier_divine_check:RemoveOnDeath()
	return false
end
function modifier_divine_check:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_divine_check:OnCreated( kv )
	-- get references
	if IsServer() then
		self:SetStackCount(0)
	end
end

modifier_will_of_the_herrsher = class({})

--------------------------------------------------------------------------------

function modifier_will_of_the_herrsher:IsHidden()
	return false
end

function modifier_will_of_the_herrsher:IsDebuff()
	return false
end

function modifier_will_of_the_herrsher:IsPurgable()
	return false
end

function modifier_will_of_the_herrsher:RemoveOnDeath()
	return false
end
function modifier_will_of_the_herrsher:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_will_of_the_herrsher:OnCreated( kv )
	-- get references
	if IsServer() then
	self.G1 = 0
		self:SetStackCount(0)
		self:StartIntervalThink(0.1)
	end
end


function modifier_will_of_the_herrsher:OnIntervalThink( kv )
self.parent = self:GetParent()
local caster = self:GetCaster()

	if IsServer() then
	if self:GetCaster():HasTalent("special_bonus_kiana_25") then
	if self:GetCaster():HasModifier("modifier_divine_check") then
	local mod22 = caster:FindModifierByName("modifier_divine_check")
	self.old = mod22:GetStackCount()
	local diff = (self:GetStackCount() * 0.003) - self.old
	mod22:SetStackCount(self:GetStackCount() * 0.003)
local mod = caster:FindModifierByNameAndCaster("modifier_divine_energy",caster)
local stack = mod:GetStackCount()
mod:SetStackCount(stack + diff)
	else
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_divine_check", {})
local mod22 = caster:FindModifierByName("modifier_divine_check")
mod22:SetStackCount(self:GetStackCount() * 0.003)
self.value22 = mod22:GetStackCount()
		if not self.parent:HasModifier("modifier_divine_energy") then
caster:AddNewModifier(caster, self, "modifier_divine_energy", {})
end
local mod = caster:FindModifierByNameAndCaster("modifier_divine_energy",caster)
local stack = mod:GetStackCount()
mod:SetStackCount(stack + self.value22)
end
	end
	
	local value = self:GetStackCount()
	if value > 200000 then self:SetStackCount(200000) return end
		self:SetStackCount(value + 5)
	end
end

--------------------------------------------------------------------------------

function modifier_will_of_the_herrsher:DeclareFunctions()
	local funcs = {

	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,

	}

	return funcs
end
function modifier_will_of_the_herrsher:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end
	local level = params.ability:GetLevel()
	local manacost = params.ability:GetManaCost(level)
	local ability = params.ability
	if manacost > 50 then
	local ability1 = self:GetParent():FindAbilityByName("kiana_ultimate")
	if ability == ability1 then
	self.approximate = 1200
	else
	self.approximate = 600
	end
	local r22 = self:GetStackCount()
	self:SetStackCount(r22 + self.approximate)
		--self:PlayEffects(self:GetParent():GetOrigin())
	end
end

function modifier_will_of_the_herrsher:PlayEffects( radius )

	local particle_cast = "particles/void_drifter_activation_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end



modifier_sirin_awakening = class({})
function modifier_sirin_awakening:IsHidden() return false end
function modifier_sirin_awakening:IsDebuff() return true end
function modifier_sirin_awakening:IsPurgable() return false end
function modifier_sirin_awakening:IsPurgeException() return false end
function modifier_sirin_awakening:RemoveOnDeath() return false end
function modifier_sirin_awakening:AllowIllusionDuplicate() return true end

function modifier_sirin_awakening:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
                    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
							MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			}
    return func
end
function modifier_sirin_awakening:GetModifierModelChange()
    return "models/kiana/sirin/sirin.vmdl"
end
function modifier_sirin_awakening:GetModifierModelScale()
	return 1
end


function modifier_sirin_awakening:GetModifierMoveSpeedBonus_Constant()
    
    return -60
end
  
function modifier_sirin_awakening:GetAttackSound()
	return "kiana.spear"
end
function modifier_sirin_awakening:GetModifierPreAttack_BonusDamage()
    return 150
end
function modifier_sirin_awakening:GetModifierProjectileName()
	return "particles/sirin_spear_projectile.vpcf"
end

function modifier_sirin_awakening:GetModifierProjectileSpeedBonus()
	return 900
end
function modifier_sirin_awakening:GetModifierAttackRangeBonus()
	return 500
end

function modifier_sirin_awakening:OnCreated(table)
 if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()
self.parent:SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )
	

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

   


   
      
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
       if not self.particle_time then
            --self.particle_time =    ParticleManager:CreateParticle("particles/sirin_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
	

        
		
        EmitSoundOn("sirin.awakening", self.parent)

        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_sirin_awakening:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_sirin_awakening:OnDestroy()
    if IsServer() then
 
			self.parent:SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )
if self.particle_time then
           ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		
			end

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("zenitsu_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end

		-- EmitSoundOn("kiana.return_control", self.parent)
    end






sirin_spear_barrage = class({})
LinkLuaModifier("modifier_spear_barrage_invul_delay", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spear_barrage_invul", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE)

function sirin_spear_barrage:OnSpellStart()
local caster = self:GetCaster()
self.attack_scale = self:GetSpecialValueFor("attack_scale")
local point = self:GetCursorPosition()
 EmitSoundOn("sirin.ulti", caster)
	caster:AddNewModifier(caster, self, "modifier_spear_barrage_invul_delay", {duration = 1.9})
local delay = 2
	Timers:CreateTimer(delay,function()
	caster:AddNewModifier(caster, self, "modifier_spear_barrage_invul", {duration = 4})
for i = 1, 300 do
local delay = (i * 0.012)
	Timers:CreateTimer(delay,function()
	self:SpearBarrage(point,i)
end)
end
end)

end

function sirin_spear_barrage:SpearBarrage(point,number)
local caster = self:GetCaster()
  self.iHoldFlyingRadius  = 600
local fParentScale = caster:GetModelScale()
 local vCasterRight = caster:GetRightVector()
local rng1 = RandomInt(0,500)
local rng2 = RandomInt(-300,300)
local bckv = GetGroundPosition(caster:GetAbsOrigin()-caster:GetForwardVector()*300, nil)
local spawnPoint = bckv + Vector(0,0,rng1) * fParentScale
local vEndPoint  = spawnPoint + caster:GetForwardVector() * 2000
 local vSideDirection = vCasterRight
 local rng22 = RandomInt(1,100)
                local iSideOffset    = rng22
                if  number%2 == 0 then
                    vSideDirection = -vCasterRight
                    iSideOffset    = rng22
                end
				local rand  = RandomFloat(0.1,10) 
                iSideOffset = iSideOffset * 2

                local origin = ( spawnPoint + vSideDirection * ( self.iHoldFlyingRadius - iSideOffset * rand  ) ) + Vector(0, 0, iSideOffset)
				 local end_origin = ( vEndPoint + vSideDirection * ( self.iHoldFlyingRadius - iSideOffset * rand  ) ) + Vector(0, 0, iSideOffset)
                local direction = GetDirection(end_origin, origin, true)


	local projectile_direction = direction:Normalized()
	local speed = 1400
local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = origin,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "particles/kiana_spear_barrage.vpcf",
	    fDistance = 3000,
	    fStartRadius = 150,
	    fEndRadius = 150,
		vVelocity = projectile_direction * speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

end	

function sirin_spear_barrage:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		return nil
	end

local caster = self:GetCaster()

	

	if self:GetCaster() then
	--	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")})
		end
		local scale = caster:GetAverageTrueAttackDamage(hTarget) * self.attack_scale
 EmitSoundOn("kiana.spear_throw_impact", hTarget)

	local damage_table = {	victim = hTarget,
							attacker = self:GetCaster(),
							damage = (self:GetSpecialValueFor("damage") + scale),
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
	
end
	

modifier_spear_barrage_invul_delay = class({})
function modifier_spear_barrage_invul_delay:IsHidden() return false end
function modifier_spear_barrage_invul_delay:IsDebuff() return true end
function modifier_spear_barrage_invul_delay:IsPurgable() return false end
function modifier_spear_barrage_invul_delay:IsPurgeException() return false end
function modifier_spear_barrage_invul_delay:RemoveOnDeath() return true end
function modifier_spear_barrage_invul_delay:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_spear_barrage_invul_delay:OnCreated()
if IsServer() then
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_CAST_ABILITY_5)

end
end

	

modifier_spear_barrage_invul = class({})
function modifier_spear_barrage_invul:IsHidden() return false end
function modifier_spear_barrage_invul:IsDebuff() return true end
function modifier_spear_barrage_invul:IsPurgable() return false end
function modifier_spear_barrage_invul:IsPurgeException() return false end
function modifier_spear_barrage_invul:RemoveOnDeath() return true end
function modifier_spear_barrage_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_spear_barrage_invul:OnCreated()
if IsServer() then

end
end

function modifier_spear_barrage_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_spear_barrage_invul:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_5
end









kiana_final_slash = class({})
LinkLuaModifier( "modifier_kiana_final_slash", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kiana_final_slash_anim", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function kiana_final_slash:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function kiana_combo_hit:GetIntrinsicModifierName()
    return "modifier_nyan_nyan"
end
--------------------------------------------------------------------------------
-- Ability Start
function kiana_final_slash:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5
caster:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_kiana_final_slash_anim", -- modifier name
			{ duration = 2 } -- kv
		)
	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_kiana_final_slash", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
end
function kiana_final_slash:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/kiana_flameshion_warning_circle.vpcf"
	local sound_cast = "flameshion.true_ulti"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitGlobalSound(sound_cast)
end

modifier_kiana_final_slash = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_kiana_final_slash:IsHidden()
	return true
end

function modifier_kiana_final_slash:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_kiana_final_slash:OnCreated( kv )
	if not IsServer() then return end
local caster = self:GetCaster()
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	local damage = self:GetAbility():GetSpecialValueFor( "attack_scale" ) * caster:GetAverageTrueAttackDamage(caster)

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_kiana_final_slash:OnRefresh( kv )
	
end

function modifier_kiana_final_slash:OnRemoved()
end

function modifier_kiana_final_slash:OnDestroy()
	if not IsServer() then return end
local caster = self:GetCaster()
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
	
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration } -- kv
		)
	
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
--	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations

modifier_kiana_final_slash_anim = class({})
function modifier_kiana_final_slash_anim:IsHidden() return false end
function modifier_kiana_final_slash_anim:IsDebuff() return true end
function modifier_kiana_final_slash_anim:IsPurgable() return false end
function modifier_kiana_final_slash_anim:IsPurgeException() return false end
function modifier_kiana_final_slash_anim:RemoveOnDeath() return true end
function modifier_kiana_final_slash_anim:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end


function modifier_kiana_final_slash_anim:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_kiana_final_slash_anim:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end













kiana_perfect_timestop = class({})
LinkLuaModifier( "modifier_kiana_perfect_timestop_thinker", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kiana_perfect_timestop_effect", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kiana_perfect_timestop_buff", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function kiana_perfect_timestop:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end



--------------------------------------------------------------------------------
-- Ability Start
function kiana_perfect_timestop:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = caster:GetOrigin()
	for o = 0, 15 do
		local ability = caster:GetAbilityByIndex(o)
		if ability then
	
					if ability:IsCooldownReady() then
						--target.ability.cooldown = 0
					else
					--	target.ability.cooldown = target.ability:GetCooldownTimeRemaining()
						ability:EndCooldown()
					end
				end
			end
	-- load data
	local duration = self:GetSpecialValueFor("duration")
	local vision = self:GetSpecialValueFor("vision_radius")

	-- create thinker
	self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_kiana_perfect_timestop_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self.thinker = self.thinker:FindModifierByName("modifier_kiana_perfect_timestop_thinker")
     caster:AddNewModifier(self:GetCaster(), self, "modifier_kiana_perfect_timestop_buff", {duration = duration})
	-- create fov
--	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision, duration, false)
	
	 EmitSoundOn("Kiana.timestop", caster) 

	self:EndCooldown()
	self:StartCooldown(200)
end



modifier_kiana_perfect_timestop_thinker = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_kiana_perfect_timestop_thinker:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_kiana_perfect_timestop_thinker:OnRefresh( kv )
	
end

function modifier_kiana_perfect_timestop_thinker:OnRemoved()
end

function modifier_kiana_perfect_timestop_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_kiana_perfect_timestop_thinker:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_kiana_perfect_timestop_thinker:IsAura()
	return true
end

function modifier_kiana_perfect_timestop_thinker:GetModifierAura()
	return "modifier_kiana_perfect_timestop_effect"
end

function modifier_kiana_perfect_timestop_thinker:GetAuraRadius()
	return self.radius
end

function modifier_kiana_perfect_timestop_thinker:GetAuraDuration()
	return 0.01
end

function modifier_kiana_perfect_timestop_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_kiana_perfect_timestop_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_kiana_perfect_timestop_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_kiana_perfect_timestop_thinker:GetAuraEntityReject( hEntity )
	if IsServer() then
		-- -- reject if owner
		-- if hEntity==self:GetCaster() then return true end

		-- -- reject if owner controlled
		-- if hEntity:GetPlayerOwnerID()==self:GetCaster():GetPlayerOwnerID() then return true end

		-- reject if unit is named faceless void
		

	return false
end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_kiana_perfect_timestop_thinker:PlayEffects()
	-- Get Resources
	
local particle_cast = "particles/test_kiana_perfect_timestop.vpcf"
	local sound_cast = ""

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
	

	
end


modifier_kiana_perfect_timestop_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_kiana_perfect_timestop_effect:IsHidden()
	return false
end

function modifier_kiana_perfect_timestop_effect:IsDebuff()
	return not self:NotAffected()
end

function modifier_kiana_perfect_timestop_effect:IsStunDebuff()
	return not self:NotAffected()
end

function modifier_kiana_perfect_timestop_effect:IsPurgable()
	return false
end

function modifier_kiana_perfect_timestop_effect:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_kiana_perfect_timestop_effect:NotAffected()
	-- true owner
	if self:GetParent()==self:GetCaster() then return true end

	-- true if owner controlled
	if self:GetParent():GetPlayerOwnerID()==self:GetCaster():GetPlayerOwnerID() then return true end
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_kiana_perfect_timestop_effect:OnCreated( kv )
	self.speed = 400

	if IsServer() then
		if not self:NotAffected() then
			self:GetParent():InterruptMotionControllers( false )
		else
			self:PlayEffects()
		end
	end
end

function modifier_kiana_perfect_timestop_effect:OnRefresh( kv )
	
end

function modifier_kiana_perfect_timestop_effect:OnRemoved()
end

function modifier_kiana_perfect_timestop_effect:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_kiana_perfect_timestop_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		     MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_kiana_perfect_timestop_effect:GetModifierMoveSpeed_AbsoluteMin()
	if self:NotAffected() then return self.speed end
end
function modifier_kiana_perfect_timestop_effect:GetModifierTotalDamageOutgoing_Percentage(keys)
local caster = self:GetCaster()
if keys.attacker == caster then
		return 100
		else return end
  end
 
--end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_kiana_perfect_timestop_effect:CheckState()
	local state1 = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	local state2 = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	if self:NotAffected() then return state1 else return state2 end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_kiana_perfect_timestop_effect:GetEffectName()
-- 	return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
-- end

-- function modifier_kiana_perfect_timestop_effect:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

-- function modifier_kiana_perfect_timestop_effect:GetStatusEffectName()
-- 	return "status/effect/here.vpcf"
-- end

function modifier_kiana_perfect_timestop_effect:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_arcana_base_ambient.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end


kiana_global_kick = class({})
LinkLuaModifier( "modifier_kiana_global_kick", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kiana_global_kick_anim", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function kiana_global_kick:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function kiana_global_kick:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5
	local origin = caster:GetOrigin()
	local mod = caster:FindModifierByName("modifier_nyan_nyan")
	mod:SetStackCount(6)
	caster:SetOrigin( point )
	FindClearSpaceForUnit( caster, point, true )
	self:PlayEffectsBlur(origin)
caster:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_kiana_global_kick_anim", -- modifier name
			{ duration = 2.7, } -- kv
		)
	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_kiana_global_kick", -- modifier name
		{ duration = 3 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, 1000, duration )
end
function kiana_global_kick:PlayEffectsBlur( origin )

	local particle_cast = "particles/vergil_blur.vpcf"
local radius = 555
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function kiana_global_kick:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/kiana_global_kick.vpcf"
	local sound_cast = "kiana.final_ulti"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitGlobalSound(sound_cast)
end

modifier_kiana_global_kick = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_kiana_global_kick:IsHidden()
	return true
end

function modifier_kiana_global_kick:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_kiana_global_kick:OnCreated( kv )
	if not IsServer() then return end
local caster = self:GetCaster()
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = 1200

	local damage = 2000

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_kiana_global_kick:OnRefresh( kv )
	
end

function modifier_kiana_global_kick:OnRemoved()
end

function modifier_kiana_global_kick:OnDestroy()
	if not IsServer() then return end
local caster = self:GetCaster()
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
	
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration } -- kv
		)
	
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
--	self:PlayEffects()
EmitGlobalSound("kiana.final_ulti_exp")
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations

modifier_kiana_global_kick_anim = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_kiana_global_kick_anim:IsHidden()
	return false
end

function modifier_kiana_global_kick_anim:IsDebuff()
	return false
end

function modifier_kiana_global_kick_anim:IsStunDebuff()
	return true
end

function modifier_kiana_global_kick_anim:IsPurgable()
	return true
end

function modifier_kiana_global_kick_anim:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_kiana_global_kick_anim:OnCreated( kv )
if not IsServer() then return end
	self:GetParent():AddNoDraw()
end




function modifier_kiana_global_kick_anim:OnRemoved()
end

function modifier_kiana_global_kick_anim:OnDestroy()
	if not IsServer() then return end


	
	self:GetParent():RemoveNoDraw()
self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_5)
	
	--self:GetParent():AddNewModifier(caster, self, "modifier_judgment_cut_end_invul_2", {duration = 1.0})	
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_kiana_global_kick_anim:CheckState()
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

