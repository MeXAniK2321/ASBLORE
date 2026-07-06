
LinkLuaModifier("modifier_manipulation_book", "heroes/sirin/sirin.lua", LUA_MODIFIER_MOTION_NONE)

manipulation_book = class({})

function manipulation_book:IsStealable() return true end
function manipulation_book:IsHiddenWhenStolen() return false end

function manipulation_book:OnUpgrade()

local ability66 = self:GetCaster():FindAbilityByName("sirin_the_end")
    if ability66 and ability66:GetLevel() < self:GetLevel() then
        ability66:SetLevel(self:GetLevel())
    end
  local ability88 = self:GetCaster():FindAbilityByName("sirin_death_cage")
    if ability88 and ability88:GetLevel() < self:GetLevel() then
        ability88:SetLevel(self:GetLevel())
    end
  local ability322 = self:GetCaster():FindAbilityByName("manipulation_book_close")
    if ability322 and ability322:GetLevel() < self:GetLevel() then
        ability322:SetLevel(self:GetLevel())
    end
    local ability = self:GetCaster():FindAbilityByName("sirin_spear")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	 local ability2 = self:GetCaster():FindAbilityByName("sirin_spear_barrage")
    if ability2 and ability2:GetLevel() < self:GetLevel() then
        ability2:SetLevel(self:GetLevel())
    end
	 local ability3 = self:GetCaster():FindAbilityByName("sirin_cube_smash")
    if ability3 and ability3:GetLevel() < self:GetLevel() then
        ability3:SetLevel(self:GetLevel())
    end
	 local ability4 = self:GetCaster():FindAbilityByName("sirin_redirection_portal")
    if ability4 and ability4:GetLevel() < self:GetLevel() then
        ability4:SetLevel(self:GetLevel())
    end
end
function manipulation_book:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_manipulation_book", {})

end
---------------------------------------------------------------------------------------------------------------------
modifier_manipulation_book = class({})
function modifier_manipulation_book:IsHidden() return false end
function modifier_manipulation_book:IsDebuff() return true end
function modifier_manipulation_book:IsPurgable() return false end
function modifier_manipulation_book:IsPurgeException() return false end
function modifier_manipulation_book:RemoveOnDeath() return true end
function modifier_manipulation_book:AllowIllusionDuplicate() return true end


function modifier_manipulation_book:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()
if self.caster:HasModifier("modifier_truth_unlocked") then
if  self.caster:HasModifier("modifier_herrsher_mode_true") then
   self.skills_table = {
                            
							["manipulation_book"]="manipulation_book_close",
							["sirin_blink"]="sirin_spear",
							["sirin_death_cage"]="sirin_spear_barrage",
							["sirin_the_end"]="sirin_cube_smash",
								["sirin_thread_of_death"]="sirin_judgment",
							
							
                        }
					
					
	else

    self.skills_table = {
                            
							["manipulation_book"]="manipulation_book_close",
							["sirin_blink"]="sirin_spear",
							["sirin_death_cage"]="sirin_spear_barrage",
							["herrsher_mode"]="sirin_cube_smash",
							
							
                        }

end

else
	
	if self.caster:HasModifier("modifier_herrsher_mode") or self.caster:HasModifier("modifier_herrsher_mode_true") then
 if self.caster:HasScepter() then
	
	    self.skills_table = {
                            
							["manipulation_book"]="manipulation_book_close",
							["sirin_blink"]="sirin_spear",
							["sirin_blast"]="sirin_spear_barrage",
							["sirin_judgment"]="sirin_cube_smash",
							
							
                        }
					
					
	else

    self.skills_table = {
                            
							["manipulation_book"]="manipulation_book_close",
							["sirin_blink"]="sirin_spear",
							["sirin_blast"]="sirin_spear_barrage",
							["herrsher_mode"]="sirin_cube_smash",
						
							
                        }
						end
						else
						 self.skills_table = {
                            
							["manipulation_book"]="manipulation_book_close",
							["sirin_blink"]="sirin_spear",
							["sirin_blast"]="sirin_spear_barrage",
							["herrsher_mode"]="sirin_cube_smash",
							
							
                        }
						end
						
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

function modifier_manipulation_book:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_manipulation_book:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("manipulation_book_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end


manipulation_book_close = class({})

function manipulation_book_close:IsStealable() return true end
function manipulation_book_close:IsHiddenWhenStolen() return false end
function manipulation_book_close:OnSpellStart()
    local caster = self:GetCaster() 

    if caster:FindModifierByNameAndCaster("modifier_manipulation_book", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_manipulation_book", caster)

        --return nil
    end
end

LinkLuaModifier("modifier_sirin_spear_shard", "heroes/sirin/sirin.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_covenant_spear", "heroes/sirin/sirin.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_spear_shard_debugg", "heroes/sirin/sirin.lua", LUA_MODIFIER_MOTION_NONE)

sirin_spear = class({})
function sirin_spear:OnSpellStart()
	-- unit identifier
	if IsServer() then
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	local target = self:GetCursorTarget()
		self.damage = self:GetSpecialValueFor("damage")
	self.int_scale = self:GetSpecialValueFor("int_scale")
	if caster:HasModifier("modifier_sirin_spear_shard") then
	self:SirinSpearShard(target)
		 else
if caster:HasTalent("special_bonus_sirin_20") then
 caster:AddNewModifier(caster, self, "modifier_sirin_spear_shard", {duration = 3})
 self:EndCooldown()
end
	self:SirinSpearThrow(target)
	end
	
	end
	end
	
	
function sirin_spear:SirinSpearShard(target)
local caster = self:GetCaster()
EmitSoundOn("sirin.1_sp",caster)
 caster:AddNewModifier(caster, self, "modifier_sirin_spear_shard_debugg", {duration = 3})
for i = 1, 3 do
local delay = 0.1 + (i * 0.1)
	Timers:CreateTimer(delay,function()
	self:SpearShardThrow(target)
	
end)
end
	
end
	function sirin_spear:SpearShardThrow(target)
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
EmitSoundOn("sirin.1",caster)
end	

function sirin_spear:DirectedShot(origin,target)
local caster = self:GetCaster()
local rng = origin
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
EmitSoundOn("kiana.spear_throw",target)
end	
function sirin_spear:SirinSpearThrow(target)
	-- unit identifier
	local caster = self:GetCaster()
	EmitSoundOn("sirin.1",caster)
	
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
	
function sirin_spear:PlayEffects_Covenant_Spear(origin)
	-- Get Resources
	local particle_cast = "particles/kiana_covenant_spear.vpcf"
	self.delay = 0.39

	-- Get Data
	local rng1 = RandomInt(-400,400)
	local rng2 = RandomInt(-400,400)
	local height = RandomInt(100,600)
	local height_target = 0

	-- Create Particle
	 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, origin + Vector( rng1, rng2, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, origin )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

function sirin_spear:SpearShardThrowZone(spawn,destination)
local caster = self:GetCaster()
local rng = spawn
local direction = destination - rng
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
--EmitSoundOn("sirin.1",caster)
end
function sirin_spear:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		return nil
	end
self.int_scale = self:GetSpecialValueFor("int_scale")
local caster = self:GetCaster()

		EmitSoundOn("kiana.spear_throw_impact",target)

	if self:GetCaster() then
		--hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")})
		end
		local scale = caster:GetIntellect(false) * self.int_scale


	local damage_table = {	victim = hTarget,
							attacker = self:GetCaster(),
							damage = (self:GetSpecialValueFor("damage") + scale),
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
	if not caster:HasModifier("modifier_sirin_spear_shard_debugg") then
	if caster:HasModifier("modifier_herrsher_mode") or caster:HasModifier("modifier_herrsher_mode_true") then
for i = 1, 3 do
		local delay = i * 0.1

	Timers:CreateTimer(delay,function()
		CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_covenant_spear", -- modifier name
		{ duration = 0.4 }, -- kv
		hTarget:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects_Covenant_Spear( hTarget:GetOrigin() )
	end)
	end
	end
	end
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		vLocation,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		800,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	for _,enemy in pairs(enemies) do
	if enemy:GetUnitName() == "npc_sirin_portal" then
	self:DirectedShot(enemy:GetOrigin(),hTarget)
	enemy:Kill(self,self:GetCaster())
	end
	end
end

modifier_sirin_covenant_spear = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_covenant_spear:OnCreated( kv )
	-- references
	self.radius = 80

	if IsServer() then
		--self:PlayEffects()
	
	end
end

function modifier_sirin_covenant_spear:OnRefresh( kv )
	
end

function modifier_sirin_covenant_spear:OnRemoved()
end

function modifier_sirin_covenant_spear:OnDestroy()
local scale = self:GetCaster():GetIntellect(false)
    self.damage = scale
	local damage = self.damage
	self.radius = 300
	local caster = self:GetCaster()

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
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
		--  enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = 0.2})
		
	end
	
if IsServer() then
		UTIL_Remove( self:GetParent() )
	end

end

		 modifier_sirin_spear_shard_debugg = class({})
function modifier_sirin_spear_shard_debugg:IsHidden() return true end
function modifier_sirin_spear_shard_debugg:IsDebuff() return false end
function modifier_sirin_spear_shard_debugg:IsPurgable() return false end
function modifier_sirin_spear_shard_debugg:IsPurgeException() return false end
function modifier_sirin_spear_shard_debugg:RemoveOnDeath() return false end
function modifier_sirin_spear_shard_debugg:OnCreated()
end
	 modifier_sirin_spear_shard = class({})
function modifier_sirin_spear_shard:IsHidden() return true end
function modifier_sirin_spear_shard:IsDebuff() return false end
function modifier_sirin_spear_shard:IsPurgable() return false end
function modifier_sirin_spear_shard:IsPurgeException() return false end
function modifier_sirin_spear_shard:RemoveOnDeath() return true end
function modifier_sirin_spear_shard:OnCreated()
 if IsServer() then
local ability = self:GetAbility()
ability:EndCooldown()
end
 end
function modifier_sirin_spear_shard:OnDestroy()
 if IsServer() then
local ability = self:GetAbility()
ability:StartCooldown(ability:GetCooldown(-1)* self:GetParent():GetCooldownReduction())
end
 end
 
 
 sirin_spear_barrage = class({})
LinkLuaModifier( "modifier_sirin_spear_barrage", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function sirin_spear_barrage:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function sirin_spear_barrage:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5
EmitSoundOn("sirin.1_1",caster)
	-- load data

		CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_spear_barrage", -- modifier name
		{ duration = 1.5 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	for i = 1, 150 do
		local delay = (i * 0.01)  

	Timers:CreateTimer(delay,function()
	local rng = RandomInt(-300,300)
		local rng2 = RandomInt(-300,300)
	local new_pos = point + Vector(rng,rng2,0)
	self:PlayEffects_UpSpear( new_pos )
	end)
	end
	
	-- create thinker
	
end

function sirin_spear_barrage:PlayEffects_UpSpear(origin)
	-- Get Resources
	local particle_cast = "particles/kiana_upward_spear.vpcf"
	self.delay = 0.5

	-- Get Data
	local height = -100
	local height_target = 1000

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

modifier_sirin_spear_barrage = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_spear_barrage:OnCreated( kv )
	-- references
	

	if IsServer() then
	if self:GetCaster():HasModifier("modifier_herrsher_mode") or self:GetCaster():HasModifier("modifier_herrsher_mode_true") then
	self.r = 0.02
	self.radius = 500
	else
	self.r = 0
	self.radius = 300
	end
		--self:PlayEffects()
		self:StartIntervalThink(0.05 - self.r)
	end
end

function modifier_sirin_spear_barrage:OnRefresh( kv )
	
end

function modifier_sirin_spear_barrage:OnRemoved()
end

function modifier_sirin_spear_barrage:OnIntervalThink()
local scale = self:GetAbility():GetSpecialValueFor( "int_scale" ) * self:GetCaster():GetIntellect(false)
    self.damage = ((self:GetAbility():GetSpecialValueFor( "damage" ) + scale) * 0.05)
	local damage = self.damage

	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
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
		  enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_slow", {duration = 1})
	end


end


function modifier_sirin_spear_barrage:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end


 sirin_cube_smash = class({})
LinkLuaModifier( "modifier_sirin_cube_smash", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sirin_cube_smash_side", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_herrsher_cub_po_ebalu", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function sirin_cube_smash:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function sirin_cube_smash:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 0.5
EmitSoundOn("sirin.1_2",caster)

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_cube_smash", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	
	-- create thinker
	self:PlayEffects_Cube(point)
	

end
function sirin_cube_smash:CreateSpecialCube(origin)
	-- unit identifier
	local caster = self:GetCaster()
	local duration  = 0.5
    local point = origin

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_cube_smash_side", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	
	-- create thinker
	self:PlayEffects_Cube(point)
end

function sirin_cube_smash:CreateSideCubes(point,point2)
	-- unit identifier
	local caster = self:GetCaster()
	local duration  = 0.5


	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_cube_smash_side", -- modifier name
		{ duration = duration }, -- kv
		point2,
		caster:GetTeamNumber(),
		false
	)
	
	-- create thinker
	self:PlayEffects_CubeSmash(point,point2)
end

function sirin_cube_smash:PlayEffects_CubeSmash(point,point2)
	-- Get Resources
	local particle_cast = "particles/test_cube_smash.vpcf"
	self.parent_origin = point
	self.delay = 0.5
	local range = (point - point2):Length2D()
	if range < 500 then
	self.height = 1000
	else
	self.height = 0
	end


	

	-- Create Particle
	 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector(0,0,self.height) )
	ParticleManager:SetParticleControl( effect_cast, 1, point2 )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
end
	
function sirin_cube_smash:PlayEffects_Cube(origin)
	-- Get Resources
	local particle_cast = "particles/kiana_cube_falling.vpcf"
	self.parent_origin =  origin
	self.delay = 0.5

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end


modifier_herrsher_cub_po_ebalu = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_herrsher_cub_po_ebalu:OnCreated( kv )
	-- references
	self.radius = 80

	if IsServer() then
		self:StartIntervalThink(0.75)
	end
end

function modifier_herrsher_cub_po_ebalu:OnIntervalThink( kv )
local ability = self:GetAbility()
ability:CreateSpecialCube(self:GetParent():GetOrigin())
	
end

function modifier_herrsher_cub_po_ebalu:OnRemoved()
end
modifier_sirin_cube_smash = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_cube_smash:OnCreated( kv )
	-- references
	self.radius = 80

	if IsServer() then
		--self:PlayEffects()
	
	end
end

function modifier_sirin_cube_smash:OnRefresh( kv )
	
end

function modifier_sirin_cube_smash:OnRemoved()
end

function modifier_sirin_cube_smash:OnDestroy()
local scale = self:GetAbility():GetSpecialValueFor( "int_scale" ) * self:GetCaster():GetIntellect(false)
    self.damage = (self:GetAbility():GetSpecialValueFor( "damage" ) + scale)
	local damage = self.damage
	self.radius = 300
	local caster = self:GetCaster()
EmitSoundOn("sirin.1_2_shatter",self:GetParent())
	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
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
		  enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun")})
		if caster:HasModifier("modifier_herrsher_mode") or caster:HasModifier("modifier_herrsher_mode_true") then
 enemy:AddNewModifier(caster, self:GetAbility(), "modifier_herrsher_cub_po_ebalu", {duration = 1.5})
	end
	end
	
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		800,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	for _,enemy in pairs(enemies) do
	if enemy:GetUnitName() == "npc_sirin_portal" then
	self:GetAbility():CreateSideCubes(enemy:GetOrigin(),self:GetParent():GetOrigin())
	enemy:Kill(self:GetAbility(),self:GetCaster())
	end
if IsServer() then
		UTIL_Remove( self:GetParent() )
	end

end
end

modifier_sirin_cube_smash_side = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_cube_smash_side:OnCreated( kv )
	-- references
	self.radius = 80

	if IsServer() then
		--self:PlayEffects()
	
	end
end

function modifier_sirin_cube_smash_side:OnRefresh( kv )
	
end

function modifier_sirin_cube_smash_side:OnRemoved()
end

function modifier_sirin_cube_smash_side:OnDestroy()
local scale = self:GetAbility():GetSpecialValueFor( "int_scale" ) * self:GetCaster():GetIntellect(false)
    self.damage = (self:GetAbility():GetSpecialValueFor( "damage" ) + scale)
	local damage = self.damage
	self.radius = 300
	local caster = self:GetCaster()
EmitSoundOn("sirin.1_2_shatter",self:GetParent())
	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
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
		  enemy:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun")})
		
	end
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end


end


LinkLuaModifier("modifier_sirin_redirection_portal",  "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)

sirin_redirection_portal = class({})

function sirin_redirection_portal:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function sirin_redirection_portal:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
if caster:HasTalent("special_bonus_sirin_20") then

caster:Purge(false, true, false, true, true)
end
    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("sirin.1_4")
    caster:AddNewModifier(caster, self, "modifier_sirin_redirection_portal", { duration = duration } )
end

function sirin_redirection_portal:OnChannelFinish( bInterrupted )
	self:GetCaster():RemoveModifierByName("modifier_sirin_redirection_portal")
end



modifier_sirin_redirection_portal = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sirin_redirection_portal:IsHidden()
	return false
end

function modifier_sirin_redirection_portal:IsDebuff()
	return false
end

function modifier_sirin_redirection_portal:IsPurgable()
	return false
end

function modifier_sirin_redirection_portal:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------
-- Initializations

function modifier_sirin_redirection_portal:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_sirin_redirection_portal:OnCreated( kv )
	-- references
	self:SetStackCount(0)
	self.angle_back = 110

self.launcher_charge_fx = 	ParticleManager:CreateParticle("particles/sirin_redirection_portal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 0, self:GetCaster(), 5, "attach_hand", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 1, self:GetCaster(), 5, "attach_hand", Vector(0,0,0), true)

	self.threshold = 0
end

function modifier_sirin_redirection_portal:OnRefresh( kv )
	-- references
	
	
	self.angle_back = 110


end

function modifier_sirin_redirection_portal:OnDestroy( kv )
if IsServer() then
	if self.launcher_charge_fx then
	    ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
	
		end
end
end
function modifier_sirin_redirection_portal:OnRemoved()
end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sirin_redirection_portal:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	  --MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_sirin_redirection_portal:OnTakeDamage(keys)
	if IsServer() then
	
	if keys.attacker == self:GetParent() then return end
             
			 local stack = self:GetStackCount()
			 self:SetStackCount(stack + (keys.damage * 0.5))
			end
		end
		


function modifier_sirin_redirection_portal:GetModifierIncomingDamage_Percentage( params )
	if IsServer()  then
		local parent = self:GetParent()
		local attacker = params.attacker
	local facing_direction = parent:GetAnglesAsVector().y
		local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin()):Normalized()
		local attacker_direction = VectorToAngles( attacker_vector ).y
		local angle_diff = AngleDiff( facing_direction, attacker_direction )
		angle_diff = math.abs(angle_diff)

		-- calculate damage reduction
		if angle_diff < (180-self.angle_back) then
			
		return -100
		else
		return
	end
	end
	end


LinkLuaModifier("sirin_blink_modifier", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_blink_active_time_cd", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_blink_active_timestop", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_blink_active_timestop_effect", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kiana_combo_hit", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)

sirin_blink = class({})

function sirin_blink:OnSpellStart()
	local caster = self:GetCaster()
	
	self:Blink()

	
end


function sirin_blink:Blink()
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()

	caster:EmitSound("sirin.2")
	
		local max_cast_range = self:GetSpecialValueFor("blink_range") + self:GetCaster():GetCastRangeBonus()

local difference = point - caster:GetOrigin()
	if difference:Length2D() > max_cast_range then
		point = caster:GetOrigin() + (point - caster:GetOrigin()):Normalized() * max_cast_range
	end
		local target = point
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage

	for _,enemy in pairs(enemies) do 
	if caster:HasTalent("special_bonus_sirin_25_alt") then
	
		FindClearSpaceForUnit( enemy, point, true )
		end
	
	end
	self:PlayEffects_Tp(caster:GetOrigin(),caster:GetForwardVector())
	FindClearSpaceForUnit( caster, point, true )
	self:PlayEffects_Tp(caster:GetOrigin(),caster:GetForwardVector())
	self.cd_reducted = 1
	if caster:HasModifier("modifier_truth_unlocked") then
	self.cd_reduced = 0.2
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = caster:GetIntellect(false) * 2,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
		local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		target,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- perform attack
		
	
	
			self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play effects
		self:PlayEffects2( enemy )
end

	-- play effects
	self:PlayEffects1( origin, target )
	end
	
	
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

	for _,enemy in pairs(enemies) do
		-- damage
if caster:HasTalent("special_bonus_sirin_20_alt") then
		--if not caster:HasModifier("modifier_sirin_blink_active_time_cd") then
		self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_blink_active_timestop", -- modifier name
		{ duration = 0.5 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	--	end
		return
		end
		end
			local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	for _,enemy in pairs(enemies) do
	if enemy:GetUnitName() == "npc_sirin_portal" then
	enemy:Kill(self,self:GetCaster())
	self:EndCooldown()
	self:StartCooldown(self.cd_reducted)
	return
	end
	end
end
function sirin_blink:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/blood_combo_red_arc.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function sirin_blink:PlayEffects1( origin, target )
	-- Get Resources
	local particle_cast = "particles/econ/items/void_spirit/void_spirit_immortal_2021/void_spirit_10th_anniversary_astral_step.vpcf"
--	local sound_start = "sirin.blink_true"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )

end

function sirin_blink:PlayEffects_Tp( origin, direction )
	-- Get Resources

  self.particle_cast_a = "particles/sirin_teleport.vpcf"

	local sound_cast_a = "sirin.tp"


	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( self.particle_cast_a, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	end

modifier_sirin_blink_active_timestop = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_blink_active_timestop:OnCreated( kv )
	-- references
	self.radius = 300

	if IsServer() then
	
		self:PlayEffects()
		end
	end


function modifier_sirin_blink_active_timestop:OnRefresh( kv )
	
end

function modifier_sirin_blink_active_timestop:OnRemoved()
end

function modifier_sirin_blink_active_timestop:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_sirin_blink_active_timestop:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_sirin_blink_active_timestop:IsAura()
	return true
end

function modifier_sirin_blink_active_timestop:GetModifierAura()
	return "modifier_sirin_blink_active_timestop_effect"
end

function modifier_sirin_blink_active_timestop:GetAuraRadius()
	return self.radius
end

function modifier_sirin_blink_active_timestop:GetAuraDuration()
	return 0.01
end

function modifier_sirin_blink_active_timestop:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_sirin_blink_active_timestop:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_sirin_blink_active_timestop:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sirin_blink_active_timestop:PlayEffects()
	-- Get Resources
	local caster = self:GetCaster()
	
	self.particle = "particles/test_kiana_ultimate_evasion_timestop.vpcf"
	--local sound_cast = ""

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
function modifier_sirin_blink_active_timestop:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/homura_timestop2.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
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




modifier_sirin_blink_active_timestop_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sirin_blink_active_timestop_effect:IsHidden()
	return false
end

function modifier_sirin_blink_active_timestop_effect:IsDebuff()
	return not self:NotAffected()
end

function modifier_sirin_blink_active_timestop_effect:IsStunDebuff()
	return not self:NotAffected()
end

function modifier_sirin_blink_active_timestop_effect:IsPurgable()
	return false
end

function modifier_sirin_blink_active_timestop_effect:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_sirin_blink_active_timestop_effect:NotAffected()
	-- true owner
	if self:GetParent()==self:GetCaster() then return true end

	-- true if owner controlled
	if self:GetParent():GetPlayerOwnerID()==self:GetCaster():GetPlayerOwnerID() then return true end
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_blink_active_timestop_effect:OnCreated( kv )
	self.speed = 550

	if IsServer() then
		if not self:NotAffected() then
			self:GetParent():InterruptMotionControllers( false )
		else
			self:PlayEffects()
		end
	end
end

function modifier_sirin_blink_active_timestop_effect:OnRefresh( kv )
	
end

function modifier_sirin_blink_active_timestop_effect:OnRemoved()
end

function modifier_sirin_blink_active_timestop_effect:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sirin_blink_active_timestop_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end

function modifier_sirin_blink_active_timestop_effect:GetModifierMoveSpeed_AbsoluteMin()
	if self:NotAffected() then return self.speed end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_sirin_blink_active_timestop_effect:CheckState()
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
-- function modifier_sirin_blink_active_timestop_effect:GetEffectName()
-- 	return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
-- end

-- function modifier_sirin_blink_active_timestop_effect:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

-- function modifier_sirin_blink_active_timestop_effect:GetStatusEffectName()
-- 	return "status/effect/here.vpcf"
-- end

function modifier_sirin_blink_active_timestop_effect:PlayEffects()
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

sirin_portal = class({})


function sirin_portal:OnSpellStart()
	if not IsServer() then return end
    local caster = self:GetCaster()
    local player = caster:GetPlayerID()
    local level = self:GetLevel()
    local origin = self:GetCursorPosition()
	local duration = 30
	if caster:HasTalent("special_bonus_sirin_25") then
	self.r22 = 1
	else
	self.r22 = 0 
	end
	EmitSoundOn("sirin.2",caster)
	local number = self:GetSpecialValueFor("portals") + self.r22
	for i = 1, number do
        self.portal = CreateUnitByName("npc_sirin_portal", origin + RandomVector(400), true, caster, caster, caster:GetTeamNumber())
        self.portal:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration") + self:GetCaster():FindTalentValue("special_bonus_sirin_25")})
        
    end
	
end





 sirin_blast = class({})
LinkLuaModifier( "modifier_sirin_blast", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function sirin_blast:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function sirin_blast:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = self:GetSpecialValueFor("delay")


	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_blast", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	

end

modifier_sirin_blast = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sirin_blast:IsHidden()
	return true
end

function modifier_sirin_blast:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_blast:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()

self.honkai = caster:GetIntellect(false) * self:GetAbility():GetSpecialValueFor("int_scale")

	-- references
	self.duration = 0.5
	self.radius = 350
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self.honkai
EmitSoundOn("sirin.fingersnap",self:GetCaster())
	-- precache damage
	
	self:PlayEffects1()
end 
function modifier_sirin_blast:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/test_sirin_blast.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = self:GetAbility():GetSpecialValueFor("delay") - 0.2

	-- Get Data
	local height = 1700
	local height_target = -0

	-- Create Particle
	 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )

	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

function modifier_sirin_blast:OnRefresh( kv )
	
end

function modifier_sirin_blast:OnRemoved()
end

function modifier_sirin_blast:OnDestroy()
	if not IsServer() then return end
local caster = self:GetCaster()
	-- find enemies
	
	local damageTable = {
		attacker = caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
		
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = AsbStunDuration(caster,enemy,0.9) } -- kv
		)

		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )
		local hp_max = enemy:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("kill_percent")
		local hp = enemy:GetHealth()
		if hp < hp_max then
		enemy:Kill(self:GetAbility(),self:GetCaster())
		end
	end

	-- play effects
	self:PlayEffects()
EmitSoundOn("sirin.exp",self:GetParent())
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sirin_blast:PlayEffects()
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





LinkLuaModifier("modifier_herrsher_mode", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_herrsher_mode_true", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_herrsher_mode_invul", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)
herrsher_mode = class({})

function herrsher_mode:IsStealable() return true end
function herrsher_mode:IsHiddenWhenStolen() return false end

function herrsher_mode:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("sirin_judgment")
   if ability and ability:GetLevel() < self:GetLevel() then
       ability:SetLevel(self:GetLevel())
    end

end

function herrsher_mode:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = 400
	local duration = 1.0
	local damage = 500

	
	if caster:HasScepter() and caster:HasModifier("modifier_truth_unlocked") then
	 caster:AddNewModifier(caster, self, "modifier_herrsher_mode_true", {duration = 60})
	   caster:AddNewModifier(caster, self, "modifier_herrsher_mode_invul", {duration = 2})
	local tier = 2
AsbMusic(caster,"sirin.awakened",60,tier)
	 self:PlayEffects_true(500)
	elseif  caster:HasScepter() then
	 caster:AddNewModifier(caster, self, "modifier_herrsher_mode", {duration = 63})
	
	 self:PlayEffects(500)
	  caster:AddNewModifier(caster, self, "modifier_herrsher_mode_invul", {duration = 2})
		local tier = 2
AsbMusic(caster,"sirin.befall",60,tier)
else


    caster:AddNewModifier(caster, self, "modifier_herrsher_mode", {duration = fixed_duration})
	--caster:AddNewModifier(caster, self, "modifier_herrsher_mode_invul", {duration = 1.3})
	self:PlayEffects(500)
		local tier = 1
AsbMusic(caster,"npc_dota_hero_clinkz",fixed_duration,tier)
end

end
    

function herrsher_mode:PlayEffects( radius )

	local particle_cast = "particles/halo_stage_10_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

function herrsher_mode:PlayEffects_true( radius )

	local particle_cast = "particles/sirin_awakening_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

modifier_herrsher_mode_invul = class({})
function modifier_herrsher_mode_invul:IsHidden() return false end
function modifier_herrsher_mode_invul:IsDebuff() return true end
function modifier_herrsher_mode_invul:IsPurgable() return false end
function modifier_herrsher_mode_invul:IsPurgeException() return false end
function modifier_herrsher_mode_invul:RemoveOnDeath() return true end
function modifier_herrsher_mode_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_herrsher_mode_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_herrsher_mode_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end


---------------------------------------------------------------------------------------------------------------------
modifier_herrsher_mode = class({})
function modifier_herrsher_mode:IsHidden() return false end
function modifier_herrsher_mode:IsDebuff() return true end
function modifier_herrsher_mode:IsPurgable() return false end
function modifier_herrsher_mode:IsPurgeException() return false end
function modifier_herrsher_mode:RemoveOnDeath() return true end
function modifier_herrsher_mode:AllowIllusionDuplicate() return true end

function modifier_herrsher_mode:DeclareFunctions()
    local func = {  
    				
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_EVENT_ON_UNIT_MOVED
					 }
    return func
end


function modifier_herrsher_mode:PlayEffects_Tp( origin, direction )
	-- Get Resources

  self.particle_cast_a = "particles/sirin_teleport.vpcf"

	local sound_cast_a = "sirin.tp"


	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( self.particle_cast_a, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	end

function modifier_herrsher_mode:OnUnitMoved(params)
if IsServer() then
	if params.unit == self:GetParent() then
	if self.ms_count == 75 then
	    local caster = self:GetCaster()
		local point = caster:GetOrigin()
	local caster_vector = caster:GetForwardVector()
	local max_range = 300
	local EndPoint  = point + caster_vector * max_range
		FindClearSpaceForUnit( caster, EndPoint, true )
		self:PlayEffects_Tp(point,EndPoint)
		self.ms_count = 0
	else
	self.r33 = self.ms_count + 1
	    self.ms_count = self.r33
		end
		end
	
	end
end


function modifier_herrsher_mode:GetModifierSpellAmplify_Percentage()
	return 20
end







function modifier_herrsher_mode:OnCreated(table)
if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.ms_count = 0

	if self.caster:HasModifier("modifier_manipulation_book") then
	self.caster:RemoveModifierByName("modifier_manipulation_book")
	end

	 
 if self.caster:HasScepter() then
  self.skills_table = {
                            ["herrsher_mode"] = "sirin_judgment",
							

                            
                        }
						
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
						 EmitSoundOn("sirin.5_scepter", self.parent)
						 else
						  EmitSoundOn("sirin.5", self.parent)
						end


 
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/sirin_awakening_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
       
		
		end
        
 
        self.parent:Purge(false, true, false, true, true)
    end
	end



function modifier_herrsher_mode:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_herrsher_mode:OnDestroy()
    if IsServer() then

			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
	
 if self.caster:HasModifier("modifier_manipulation_book") then
	self.caster:RemoveModifierByName("modifier_manipulation_book")
	end
if self.caster:HasScepter() then
 if IsServer() then

        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			end
			end
			end

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
            
            end
        end
    end
	
	
	
	modifier_herrsher_mode_true = class({})
function modifier_herrsher_mode_true:IsHidden() return false end
function modifier_herrsher_mode_true:IsDebuff() return true end
function modifier_herrsher_mode_true:IsPurgable() return false end
function modifier_herrsher_mode_true:IsPurgeException() return false end
function modifier_herrsher_mode_true:RemoveOnDeath() return true end
function modifier_herrsher_mode_true:AllowIllusionDuplicate() return true end

function modifier_herrsher_mode_true:DeclareFunctions()
    local func = {  
    				
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_EVENT_ON_UNIT_MOVED
					 }
    return func
end


function modifier_herrsher_mode_true:PlayEffects_Tp( origin, direction )
	-- Get Resources

  self.particle_cast_a = "particles/sirin_teleport.vpcf"

	local sound_cast_a = "sirin.tp"


	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( self.particle_cast_a, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	end

function modifier_herrsher_mode_true:OnUnitMoved(params)
if IsServer() then
	if params.unit == self:GetParent() then
	if self.ms_count == 45 then
	    local caster = self:GetCaster()
		local point = caster:GetOrigin()
	local caster_vector = caster:GetForwardVector()
	local max_range = 250
	local EndPoint  = point + caster_vector * max_range
		FindClearSpaceForUnit( caster, EndPoint, true )
		self:PlayEffects_Tp(point,EndPoint)
		self.ms_count = 0
	else
	self.r33 = self.ms_count + 1
	    self.ms_count = self.r33
		end
		end
	
	end
end


function modifier_herrsher_mode_true:GetModifierSpellAmplify_Percentage()
	return 30
end







function modifier_herrsher_mode_true:OnCreated(table)
if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.ms_count = 0

	if self.caster:HasModifier("modifier_manipulation_book") then
	self.caster:RemoveModifierByName("modifier_manipulation_book")
	end

	 
 if self.caster:HasModifier("modifier_item_aghanims_shard") then
  self.skills_table = {
                            ["herrsher_mode"] = "sirin_the_end",
						
							

                            
                        }
 else
  self.skills_table = {
                            ["herrsher_mode"] = "sirin_the_end",
							
							

                            
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
						
						  EmitSoundOn("sirin.return", self.parent)
						end


 
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/halo_stage_10_true_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
          self.parent:Purge(false, true, false, true, true)
		
		end
        
 
     
    end




function modifier_herrsher_mode_true:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_herrsher_mode_true:OnDestroy()
    if IsServer() then

			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
	
 if self.caster:HasModifier("modifier_manipulation_book") then
	self.caster:RemoveModifierByName("modifier_manipulation_book")
	end
if self.caster:HasScepter() then
 if IsServer() then

        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			end
			end
			end

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
            
            end
        end
    end
	
sirin_judgment = class({})
LinkLuaModifier("modifier_judgment_invul_delay", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_judgment_invul", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_judgment_spear", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE)

function sirin_judgment:OnSpellStart()
local caster = self:GetCaster()

local point = self:GetCursorPosition()
 EmitSoundOn("sirin.ulti", caster)
	caster:AddNewModifier(caster, self, "modifier_judgment_invul_delay", {duration = 1.9})
local delay = 2
	Timers:CreateTimer(delay,function()
	caster:AddNewModifier(caster, self, "modifier_judgment_invul", {duration = 4})
for i = 1, 300 do
local delay = (i * 0.012)
	Timers:CreateTimer(delay,function()
	local rng1 = RandomInt(-600,600)
	local rng2 = RandomInt(-600,600)
	local point2 = point + Vector(rng1,rng2,0)
	self:Judgment(point2)
	self:PlayEffectsJudgmentSpear(point2)
end)
end
end)

end

function sirin_judgment:Judgment(point)
local caster = self:GetCaster()

CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_judgment_spear", -- modifier name
		{ duration = 0.2 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)


end	

function sirin_judgment:PlayEffectsJudgmentSpear(origin)
	-- Get Resources
	local particle_cast = "particles/kiana_covenant_spear.vpcf"
	self.delay = 0.49

	-- Get Data
	local rng1 = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * -400) + Vector(RandomInt(-400,400),RandomInt(-400,400),RandomInt(200,600))


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	
	ParticleManager:SetParticleControl( effect_cast, 0, rng1 )
	ParticleManager:SetParticleControl( effect_cast, 1, origin )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end
	

modifier_judgment_invul_delay = class({})
function modifier_judgment_invul_delay:IsHidden() return false end
function modifier_judgment_invul_delay:IsDebuff() return true end
function modifier_judgment_invul_delay:IsPurgable() return false end
function modifier_judgment_invul_delay:IsPurgeException() return false end
function modifier_judgment_invul_delay:RemoveOnDeath() return true end
function modifier_judgment_invul_delay:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_judgment_invul_delay:OnCreated()
if IsServer() then
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_CAST_ABILITY_5)

end
end

	

modifier_judgment_invul = class({})
function modifier_judgment_invul:IsHidden() return false end
function modifier_judgment_invul:IsDebuff() return true end
function modifier_judgment_invul:IsPurgable() return false end
function modifier_judgment_invul:IsPurgeException() return false end
function modifier_judgment_invul:RemoveOnDeath() return true end
function modifier_judgment_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_judgment_invul:OnCreated()
if IsServer() then

end
end

function modifier_judgment_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_judgment_invul:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_5
end



modifier_sirin_judgment_spear = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_judgment_spear:OnCreated( kv )
	-- references
	

	if IsServer() then
		--self:PlayEffects()
	
	end
end

function modifier_sirin_judgment_spear:OnRefresh( kv )
	
end

function modifier_sirin_judgment_spear:OnRemoved()
end

function modifier_sirin_judgment_spear:OnDestroy()
local scale = self:GetCaster():GetIntellect(false)
    self.damage = scale
	local damage = self.damage
	self.radius = 250
	local caster = self:GetCaster()

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
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
		  enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = 0.2})
		
	end
	
if IsServer() then
		UTIL_Remove( self:GetParent() )
	end

end

modifier_sirin_void_strike_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sirin_void_strike_debuff:IsHidden()
	return false
end

function modifier_sirin_void_strike_debuff:IsDebuff()
	return true
end

function modifier_sirin_void_strike_debuff:IsStunDebuff()
	return true
end

function modifier_sirin_void_strike_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_void_strike_debuff:OnCreated( kv )
	self.rate = 2
	self.pull_speed = 450
	self.rotate_speed = 120

	if IsServer() then
		-- center
		self.center = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )

		-- apply motion controller
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_sirin_void_strike_debuff:OnRefresh( kv )
	
end

function modifier_sirin_void_strike_debuff:OnRemoved()
end

function modifier_sirin_void_strike_debuff:OnDestroy()
	if IsServer() then
		-- motion compulsory interrupts
		self:GetParent():InterruptMotionControllers( true )
	end
end


--------------------------------------------------------------------------------
-- Status Effects
function modifier_sirin_void_strike_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_sirin_void_strike_debuff:UpdateHorizontalMotion( me, dt )
	-- get vector
	local target = self:GetParent():GetOrigin()-self.center
	target.z = 0

	-- reduce length by pull speed
	local targetL = target:Length2D()-self.pull_speed*dt


	-- rotate by rotate speed
	local targetN = target:Normalized()
	local deg = math.atan2( targetN.y, targetN.x )
	local targetN = Vector( math.cos(deg+self.rotate_speed*dt), math.sin(deg+self.rotate_speed*dt), 0 );

	self:GetParent():SetOrigin( self.center + targetN * targetL )


end

function modifier_sirin_void_strike_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end

modifier_sirin_void_strike = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sirin_void_strike:IsHidden()
	return false
end

function modifier_sirin_void_strike:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_void_strike:OnCreated( kv )
	-- references
	self.radius = 500
	self.interval = 1
	self.ticks = math.floor(self:GetDuration()/self.interval+0.5) -- round
	self.tick = 0

	if IsServer() then
		-- precache damage
	
	local sound_cast = "Sirin.VoidStrike"
	EmitSoundOn( sound_cast, self:GetCaster())
		-- Start interval
		self:StartIntervalThink( self.interval )
		self:PlayEffects()
	end
end

function modifier_sirin_void_strike:OnRefresh( kv )
	
end

function modifier_sirin_void_strike:OnRemoved()
	if IsServer() then
	local ability = self:GetCaster():FindAbilityByName("sirin_spear")
		local damage = (self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():GetIntellect(true))
		local sound_cast = "Sirin.VoidStrike_end"
	EmitSoundOn( sound_cast, self:GetCaster())
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			-- damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}
		-- ensure last tick damage happens
		local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end
	
	for i = 1,4 do
	local rng = self:GetParent():GetOrigin() + RandomVector(600)
		ability:SpearShardThrowZone(rng,self:GetParent():GetOrigin())
end
		UTIL_Remove( self:GetParent() )
	end

	
end

function modifier_sirin_void_strike:OnDestroy()
	if IsServer() then
	end
end


--------------------------------------------------------------------------------
-- Aura Effects
function modifier_sirin_void_strike:IsAura()
	return true
end

function modifier_sirin_void_strike:GetModifierAura()
	return "modifier_sirin_void_strike_debuff"
end

function modifier_sirin_void_strike:GetAuraRadius()
	return self.radius
end

function modifier_sirin_void_strike:GetAuraDuration()
	return 0.1
end

function modifier_sirin_void_strike:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_sirin_void_strike:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_sirin_void_strike:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sirin_void_strike:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/sirin_void_strike.vpcf"


	-- Create Particle
	 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )

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

end



sirin_thread_of_death = class({})
LinkLuaModifier( "modifier_sirin_thread_of_death", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sirin_murder", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sirin_the_end_invul", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sirin_void_strike", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sirin_void_strike_debuff", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function sirin_thread_of_death:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	local target = self:GetCursorTarget()
	 self.portal_number = 0 
		local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		800,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	for _,enemy in pairs(enemies) do
	if enemy:GetUnitName() == "npc_sirin_portal" then
	enemy:Kill(self,self:GetCaster())
	local tk = self.portal_number 
	self.portal_number = tk + 1
	end
	end
if caster:HasModifier("modifier_truth_unlocked") then
if self.portal_number > 3 or caster:HasModifier("modifier_herrsher_mode_true")  then
self:Massacre(target)
else
self:Murder(target)
end
else
if self.portal_number > 3 or caster:HasModifier("modifier_herrsher_mode") then
self:VoidStrike(target)
else
	self:UseThread(target)
	end
	end
	
end

function sirin_thread_of_death:VoidStrike(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = target:GetOrigin()
	self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_void_strike", -- modifier name
		{ duration = 2.5 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	end
	
	
	function sirin_thread_of_death:Massacre(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = target:GetOrigin()
	self:PlayEffects_CubeSmash228(target)
	self.damageTable = {
		--	victim = target,
			attacker = self:GetCaster(),
			damage = (self:GetSpecialValueFor("damage") + caster:GetIntellect(true)) * 1.5,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
	 EmitSoundOn("sirin.massacre", caster)
	local delay = 0.4 
		Timers:CreateTimer(delay,function()
		 EmitSoundOn("kiana.ground_shake", caster)
	self:PlayEffects_GroundCubeBig(point,caster:GetForwardVector())
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			point,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- damage
		for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = AsbStunDuration(caster,enemy, 2.0) } -- kv
	)
		end
		end)
		local delay = 2.4
		Timers:CreateTimer(delay,function()
		 EmitSoundOn("sirin.deep_cut", caster)
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			point,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- damage
		for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
		
		end
		
		end)



		end
	
function sirin_thread_of_death:Murder(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
		
	self:SirinCombo1(target)
	local delay = 0.2

	Timers:CreateTimer(delay,function()
	    caster:AddNewModifier(caster, self, "modifier_sirin_the_end_invul", {duration = 0.6})
		target:AddNewModifier(caster, self, "modifier_sirin_murder", {duration = 0.6})
		 EmitSoundOn("sirin.murder", caster)
		 end)
		



		end

function sirin_thread_of_death:UseThread(target)
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	    caster:AddNewModifier(caster, self, "modifier_stunned", {duration = 0.5})
		target:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.0})
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



function sirin_thread_of_death:SirinCombo1(target)
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



function sirin_thread_of_death:SirinCombo2(target)
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
                        knockback_distance =  600,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	
				self:PlayEffects(target)
    
self:PlayEffects_GroundCube(pos_cube,target:GetForwardVector() * -1)

end

function sirin_thread_of_death:PlayEffects_GroundCube( origin, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_combo_standing_cube.vpcf"
	

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end

function sirin_thread_of_death:PlayEffects_GroundCubeBig( origin, direction )
	-- Get Resources
	local particle_cast = "particles/kiana_combo_standing_cube_big.vpcf"
	

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end

function sirin_thread_of_death:SirinCombo3(target)
local caster = self:GetCaster()

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}




	local scale = caster:GetIntellect(false) * self:GetSpecialValueFor("int_scale")
damageTable.damage = (self:GetSpecialValueFor("damage") + scale) * 0.5
damageTable.victim = target
		ApplyDamage(damageTable)
		
			-- play effects
				self:PlayEffects_CubeSmash(target)


  EmitSoundOn("kiana.ground_shake", caster)
	

end
function sirin_thread_of_death:PlayEffects_CubeSmash(target)
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

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + h1 )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + h2 )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + h3 )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + h4 )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
end
	function sirin_thread_of_death:PlayEffects_CubeSmash228(target)
	-- Get Resources
	local particle_cast = "particles/test_cube_smash_big.vpcf"
	self.parent_origin = target:GetOrigin()
	self.delay = 0.4

	-- Get Data
	local h1 =  Vector(0,0,800)


	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + h1 )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end
function sirin_thread_of_death:PlayEffects( target )
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
function sirin_thread_of_death:SirinCombo4(target)
local caster = self:GetCaster()

	local damageTable = {
		attacker = caster,
		--damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}




local delay = 0.4
	Timers:CreateTimer(delay,function()
		local scale = caster:GetIntellect(false) * self:GetSpecialValueFor("int_scale")
damageTable.damage = (self:GetSpecialValueFor("damage") + scale) * 0.5
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

function sirin_thread_of_death:PlayEffectsExplosion( target )
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

modifier_sirin_murder = class({})

--------------------------------------------------------------------------------

function modifier_sirin_murder:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_sirin_murder:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_sirin_murder:OnCreated( kv )
	self.dismember_damage = kv.damage
	local caster = self:GetCaster()

self.tick_rate = 0.1


	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
	

end

--------------------------------------------------------------------------------

function modifier_sirin_murder:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	--StopSoundOn( "arcueid.neko_brawl", self:GetParent() )
	
end

--------------------------------------------------------------------------------

function modifier_sirin_murder:OnIntervalThink()
	if IsServer() then
	local radius = 300

		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetIntellect(false) * 0.5,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage( self.damageTable )
	local caster = self:GetCaster()
	
		EmitSoundOn( "sirin_cut", self:GetParent() )

	self:PlayEffects1(radius)

	
end
end


--------------------------------------------------------------------------------

function modifier_sirin_murder:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_sirin_murder:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end


function modifier_sirin_murder:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_sirin_murder:PlayEffects1( radius )

	local particle_cast = "particles/test_sirin_slashes.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


sirin_death_cage = class({})
LinkLuaModifier( "modifier_sirin_death_cage", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function sirin_death_cage:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- Add modifier
	self.modifier = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_death_cage", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	EmitSoundOn("sirin.7", caster)
end

--------------------------------------------------------------------------------
-- Ability Channeling
-- function sirin_death_cage:GetChannelTime()

-- end

function sirin_death_cage:OnChannelFinish( bInterrupted )
local caster = self:GetCaster()
	if self.modifier then
		self.modifier:Destroy()
		self.modifier = nil
	end
	StopSoundOn("sirin.7", caster)
	--ApplyDamage(damageTable)
end


modifier_sirin_death_cage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sirin_death_cage:IsHidden()
	return false
end

function modifier_sirin_death_cage:IsDebuff()
	return true
end

function modifier_sirin_death_cage:IsPurgable()
	return true
end

function modifier_sirin_death_cage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_death_cage:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.radius = 600
self.time = GameRules:GetGameTime()
	self.owner = kv.isProvidedByAura~=1

	if self.owner then
		-- thinker references
		self.delay = 0.3
		self.duration = 3
		
		-- set duration
		self:SetDuration( self.delay + self.duration, false )

		-- add delay
		self.formed = false
		self:StartIntervalThink( self.delay )

		-- play effects
		self:PlayEffects1()
		--self.sound_loop = "reinforce.cage"
		--EmitSoundOn( self.sound_loop, self:GetParent() )
	else
		-- aura references
		self.aura_origin = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
		self.parent = self:GetParent()
		self.width = 100
		self.max_speed = 550
		self.min_speed = 0.1
		self.max_min = self.max_speed-self.min_speed

		-- check inside/outside
		self.inside = (self.parent:GetOrigin()-self.aura_origin):Length2D() < self.radius
		
	end
end

function modifier_sirin_death_cage:OnRemoved()
end

function modifier_sirin_death_cage:OnDestroy()
	if not IsServer() then return end
	self.end_time = GameRules:GetGameTime()
	self.bonus = (self.end_time - self.time)/ 3
	
	local int_scale = self:GetAbility():GetSpecialValueFor("int_scale") * 0.7
	local damage = self:GetAbility():GetSpecialValueFor("damage_max") * 0.7
	self.damage = (int_scale + damage) * self.bonus
	if self.owner then
		-- stop sound
		self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = (2.0 * self.bonus) } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects_boom()
		-- remove thinker
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sirin_death_cage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}

	return funcs
end


function modifier_sirin_death_cage:GetModifierMoveSpeed_Limit( params )
	if not IsServer() then return end
	-- do nothing if thinker
	if self.owner then return 0 end

	-- get data
	local parent_vector = self.parent:GetOrigin()-self.aura_origin
	local parent_direction = parent_vector:Normalized()

	-- check inside/outside
	local actual_distance = parent_vector:Length2D()
	local wall_distance = actual_distance-self.radius
	local over_walls = false
	if self.inside ~= (wall_distance<0) then
		-- moved to other side, check buffer
		if math.abs( wall_distance )>self.width then
			-- flip
			self.inside = not self.inside
		else
			over_walls = true
		end
	end	

	-- no limit if outside width
	wall_distance = math.abs(wall_distance)
	if wall_distance>self.width then return 0 end

	-- calculate facing angle
	local parent_angle = 0
	if self.inside then
		parent_angle = VectorToAngles(parent_direction).y
	else
		parent_angle = VectorToAngles(-parent_direction).y
	end
	local unit_angle = self:GetParent():GetAnglesAsVector().y
	local wall_angle = math.abs( AngleDiff( parent_angle, unit_angle ) )

	-- calculate movespeed limit
	local limit = 0
	if wall_angle<=90 then
		-- facing and touching wall
		if over_walls then
			limit = self.min_speed
			self:RemoveMotions()
		else
			-- interpolate
			limit = (wall_distance/self.width)*self.max_min + self.min_speed
		end
	else
		-- no limit if facing away
		limit = 0
	end

	return limit
end

--------------------------------------------------------------------------------
-- Helper
function modifier_sirin_death_cage:RemoveMotions()
	local modifiers = self.parent:FindAllModifiers(  )

	for _,modifier in pairs(modifiers) do
		-- print("modifier:",modifier,modifier:GetName())
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sirin_death_cage:OnIntervalThink()

	self:StartIntervalThink( -1 )
	self.formed = true

	-- play effects
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_sirin_death_cage:IsAura()
	return self.owner and self.formed
end

function modifier_sirin_death_cage:GetModifierAura()
	return "modifier_sirin_death_cage"
end

function modifier_sirin_death_cage:GetAuraRadius()
	return self.radius
end

function modifier_sirin_death_cage:GetAuraDuration()
	return 0.3
end

function modifier_sirin_death_cage:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_sirin_death_cage:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_sirin_death_cage:GetAuraSearchFlags()
	return 0
end

function modifier_sirin_death_cage:GetAuraEntityReject( hEntity )
	if IsServer() then
		
	end

	return false
end

-- --------------------------------------------------------------------------------
-- -- Graphics & Animations
-- function modifier_sirin_death_cage:GetEffectName()
-- 	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
-- end

-- function modifier_sirin_death_cage:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

-- function modifier_sirin_death_cage:GetStatusEffectName()
-- 	return "status/effect/here.vpcf"
-- end

function modifier_sirin_death_cage:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/sirin_cage_of_death_formation.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_sirin_death_cage:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/sirin_death_cage.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


function modifier_sirin_death_cage:PlayEffects_boom()
	-- Get Resources
	local particle_cast = "particles/sirin_deep_cut.vpcf"
	local sound_cast = "sirin.deep_cut"


	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )

end
---------
	
	

sirin_the_end = class({})
LinkLuaModifier( "modifier_sirin_the_end_invul", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sirin_the_end", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sirin_the_end_damage", "heroes/sirin/sirin", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start

function sirin_the_end:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
local point = self:GetCursorPosition()
	local radius = 1200
	local duration = 8
	local damage = 9999999
	
	
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sirin_the_end", -- modifier name
		{ duration = 2.5 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	
caster:AddNewModifier(caster, self, "modifier_sirin_the_end_invul", {duration = 8})	

	self.sound_cast = "sirin.the_end"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
	
	self:PlayEffects(1000,point)
	


	
end
function sirin_the_end:PlayEffects( radius,point )
	local particle_cast = "particles/sirin_end_radius.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


modifier_sirin_the_end_invul = class({})
function modifier_sirin_the_end_invul:IsHidden() return false end
function modifier_sirin_the_end_invul:IsDebuff() return true end
function modifier_sirin_the_end_invul:IsPurgable() return false end
function modifier_sirin_the_end_invul:IsPurgeException() return false end
function modifier_sirin_the_end_invul:RemoveOnDeath() return true end
function modifier_sirin_the_end_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_sirin_the_end_invul:OnCreated()
if IsServer() then
        --self:SetStackCount(0)
     self:PlayEffects()
	 self:GetCaster():AddNoDraw()
    end
end
function modifier_sirin_the_end_invul:OnDestroy()
if not IsServer() then return end
local caster = self:GetCaster()
 self:GetCaster():RemoveNoDraw()
	self:PlayEffects()
	
end
function modifier_sirin_the_end_invul:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vergil_blur.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end

function modifier_sirin_the_end_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_sirin_the_end_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end









modifier_sirin_the_end = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sirin_the_end:IsHidden()
	return false
end

function modifier_sirin_the_end:IsDebuff()
	return true
end

function modifier_sirin_the_end:IsStunDebuff()
	return false
end

function modifier_sirin_the_end:IsPurgable()
	return true
end

function modifier_sirin_the_end:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_the_end:OnCreated( kv )
if IsServer() then
	end
	
end

function modifier_sirin_the_end:OnRefresh( kv )
	
end

function modifier_sirin_the_end:OnRemoved()
end

function modifier_sirin_the_end:OnDestroy()
if IsServer() then
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_sirin_the_end_damage", -- modifier name
			{ duration = 3.0 } -- kv
		)

	
	end
end
end





modifier_sirin_the_end_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sirin_the_end_damage:IsHidden()
	return false
end

function modifier_sirin_the_end_damage:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_sirin_the_end_damage:IsStunDebuff()
	return true
end

function modifier_sirin_the_end_damage:IsPurgable()
	return true
end

function modifier_sirin_the_end_damage:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sirin_the_end_damage:OnCreated( kv )
	-- references

	self.radius = 25
	

	if not IsServer() then return end
	local caster = self:GetCaster()
	-- precache damage
	
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = 999999,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	self:GetParent():AddNoDraw()
	self:PlayEffects()
	
end


function modifier_sirin_the_end_damage:OnRefresh( kv )
	-- references

	self.radius = 200

	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = self.damage
end

function modifier_sirin_the_end_damage:OnRemoved()
end

function modifier_sirin_the_end_damage:OnDestroy()
	if not IsServer() then return end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
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
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_end1", {} )
	self:PlayEffectsCut(self:GetParent())
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_sirin_the_end_damage:CheckState()
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
function modifier_sirin_the_end_damage:PlayEffects()
	-- Get Resources
	local particle_cast1 = ""
	local particle_cast2 = ""
	
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	CustomGameEventManager:Send_ServerToPlayer(Player, "sirin_end_cut", {} )

end



function modifier_sirin_the_end_damage:PlayEffectsCut()
	-- Get Resources
	local particle_cast = "particles/sirin_deep_cut.vpcf"
	


	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	

end

















	
	