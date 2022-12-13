reinforce_knockdown = class({})
LinkLuaModifier( "modifier_black_lady_2nd", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function reinforce_knockdown:GetIntrinsicModifierName()
    return "modifier_black_lady_2nd"
end
function reinforce_knockdown:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("reinforce_berserk")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
		     if ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
end

function reinforce_knockdown:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	local int = caster:GetIntellect()
	self.damage = self:GetSpecialValueFor("base_damage") + int
	self.radius = self:GetSpecialValueFor("radius")

	self:Knockdown(point)
if caster:HasModifier("modifier_reinforce_berserk_buff") then
self:EndCooldown()
self:StartCooldown(2)
end
end
function reinforce_knockdown:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/knockdown_hit.vpcf"



	
	
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


function reinforce_knockdown:Knockdown(point)
local caster = self:GetCaster()
if caster:HasTalent("special_bonus_reinforce_20") then
self.duration = 0.8
else
	self.duration = 0.3
	end
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local damageTable = {
		attacker = caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}




	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			

			-- knockback if not having spear stun
			local knockback = { should_stun = 1,
                        knockback_duration = self.duration,
                        duration = self.duration,
                        knockback_distance = 300,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
if not enemy:IsCreep() then
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end
	
damageTable.victim = enemy
		ApplyDamage(damageTable)
			caught = true
			-- play effects
			self:PlayEffects(enemy)
			self:PlayEffects1( caught, caster:GetForwardVector(),enemy:GetOrigin() )
		end
	end


	
	end
	
	


function reinforce_knockdown:PlayEffects1( caught, direction,origin )
	-- Get Resources
	local particle_cast = "particles/reinforce_knockdown.vpcf"
	
		local sound_cast = "reinforce.1"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end



modifier_black_lady_2nd = class ({})
function modifier_black_lady_2nd:IsHidden() return true end
function modifier_black_lady_2nd:IsDebuff() return false end
function modifier_black_lady_2nd:IsPurgable() return false end
function modifier_black_lady_2nd:IsPurgeException() return false end
function modifier_black_lady_2nd:RemoveOnDeath() return false end

function modifier_black_lady_2nd:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_black_lady_2nd:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_black_lady_2nd:OnIntervalThink()
	if IsServer() then
			local vongolle2 = self:GetParent():FindAbilityByName("reinforce_darkness_parade")
        if vongolle2 and not vongolle2:IsNull() then
            if self:GetParent():HasScepter() then
                if vongolle2:IsHidden() then
                    vongolle2:SetHidden(false)
					vongolle2:SetLevel(1)
                end
            else
                  vongolle2:SetHidden(true)
                end
            end
			end
        end






book_of_darkness = class({})
LinkLuaModifier( "modifier_book_of_darkness", "heroes/reinforce/reinforce.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "book_of_darkness_target", "heroes/reinforce/reinforce.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silence_item", "heroes/reinforce/reinforce.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muted", "modifiers/modifier_muted", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_reinforce_berserk_buff", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_reinforce_berserk_thinker", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_reinforce_berserk_thinker_effect", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_reinforce_berserk_invul", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_black_lady", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE)


function book_of_darkness:GetIntrinsicModifierName()
    return "modifier_black_lady"
end
function book_of_darkness:GetBehavior()
if self:GetCaster():HasModifier("modifier_book_of_darkness") then
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
	
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end
end
function book_of_darkness:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_book_of_darkness") then
	return "dante/dante_close"
	else
	
	return "reinforce/2"
	
	end
end
function book_of_darkness:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local result = UnitFilter(
		hTarget,	-- Target Filter
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- Team Filter
		DOTA_UNIT_TARGET_HERO,	-- Unit Filter
		0,	-- Unit Flag
		self:GetCaster():GetTeamNumber()	-- Team reference
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Cast Error Message
function book_of_darkness:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end
function book_of_darkness:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration = 5
	local radius = 400
	if caster:HasModifier("modifier_book_of_darkness") then
	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
		-- damage
		enemy:RemoveModifierByName("book_of_darkness_target")
	end
	return end
	if caster:GetTeamNumber() == target:GetTeamNumber() then
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"book_of_darkness_target", -- modifier name
		{} -- kv
	)
	
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_book_of_darkness", {} )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_muted", { duration = 0.2 } )
	
    EmitSoundOn("reinforce.2", caster)
	self:PlayEffects( radius )
	self:EndCooldown()
	self:StartCooldown(5)

end
end

function book_of_darkness:PlayEffects( radius )
	local particle_cast = "particles/book_of_darkness.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_book_of_darkness = class({})

function modifier_book_of_darkness:IsHidden()
    return false
end
function modifier_book_of_darkness:CheckState()
    local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,     
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
    }

    return state
end
function modifier_book_of_darkness:IsPurgable()
    return false
end
function modifier_book_of_darkness:OnCreated(hTable)
if IsServer() then
	 self:GetParent():AddNoDraw()

		if self:GetCaster():HasModifier("modifier_item_aghanims_shard") then
		else
      local HiddenAbilities = 
	{
		"reinforce_knockdown",
		"reinforce_way_to_darkness",

		
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(true)
        end
		end
		end
    end
	end



function modifier_book_of_darkness:OnDestroy( kv )
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
if not IsServer() then return end
local point = self:GetCaster():GetAbsOrigin()

FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin(), true)
    local chance = math.random(100)
    local npcName = self:GetParent():GetUnitName()
	local caster = self:GetCaster()
    
    self:GetParent():RemoveNoDraw()
  
			local radius = 400
	local duration = 1.0

	self:PlayEffects( radius )
	 local HiddenAbilities = 
	{
		"reinforce_knockdown",
		"reinforce_way_to_darkness",

		
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
		  if HiddenAbility and not HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(true)
        end
		end
end
function modifier_book_of_darkness:PlayEffects( radius )
	local particle_cast = "particles/book_of_darkness.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

book_of_darkness_target = class({})

function book_of_darkness_target:IsPurgable()
    return false
end

function book_of_darkness_target:OnCreated( kv )
    self:StartIntervalThink(0.03)
    if not IsServer() then return end
self.parent = self:GetParent()
   self.ability = self:GetAbility()
    self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
    
end

function book_of_darkness_target:OnIntervalThink()
    if not IsServer() then return end
    local target = self:GetCaster()
    local target_pos = target:GetAbsOrigin ()
    local caster = self:GetAbility ():GetCaster ()
	
	
    target:SetAbsOrigin (self:GetParent ():GetAbsOrigin ())
    if not self:GetParent ():IsAlive() then
	    caster:RemoveModifierByName ("modifier_book_of_darkness")
        target:RemoveModifierByName ("book_of_darkness_target")
    end
end
function book_of_darkness_target:OnDestroy( kv )
	if IsServer() then
		local target = self:GetCaster()
		local target_pos = target:GetAbsOrigin ()
		local caster = self:GetAbility ():GetCaster ()
		caster:RemoveModifierByName ("modifier_book_of_darkness")
		    target:RemoveModifierByName ("book_of_darkness_target")
			if not self:GetParent():IsAlive() then
			local ability = caster:FindAbilityByName("reinforce_berserk")
			if caster:GetLevel() > 29 then
			
			if ability:IsFullyCastable() then
				if caster:HasModifier("modifier_book_of_darkness_spellbook") then
					caster:RemoveModifierByName("modifier_book_of_darkness_spellbook")
				end
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_reinforce_berserk_buff", {duration = 48})
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_reinforce_berserk_invul", {duration = 3})
					self.thinker = CreateModifierThinker(
					caster, -- player source
					self:GetAbility(), -- ability source
					"modifier_reinforce_berserk_thinker", -- modifier name
					{ duration = 3 }, -- kv
					self:GetParent():GetOrigin(),
					caster:GetTeamNumber(),
					false)
				end
			end
		end
	end
end

function book_of_darkness_target:GetEffectName()
	return "particles/book_of_darkness_statsu.vpcf"
end

function book_of_darkness_target:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function book_of_darkness_target:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		   MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		   MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
		   

	
    }

    return funcs
end
function book_of_darkness_target:OnTakeDamage(keys)
	if IsServer() then
	if self:GetCaster():HasTalent("special_bonus_reinforce_20_alt") then
		if keys.attacker == self.parent and keys.damage_category == 0 and keys.inflictor ~= self:GetAbility() then
			if not self.parent.anime_stone_damage_copy then
				self.parent.anime_stone_damage_copy = self.ability
			end

			local flags = 0
			if keys.inflictor then
				flags = keys.inflictor:GetAbilityTargetFlags()
			end
			
			if self.parent.anime_stone_damage_copy == self.ability and  UnitFilter(	keys.unit,
																		DOTA_UNIT_TARGET_TEAM_BOTH,--keys.inflictor:GetAbilityTargetTeam(), 
																		DOTA_UNIT_TARGET_ALL,--keys.inflictor:GetAbilityTargetType(), 
																		flags + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES - DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
																		self.parent:GetTeamNumber()) == UF_SUCCESS then
				--print(keys.original_damage, "STONE ORIG, DAMAGE")
               
                local heal = keys.damage * 0.20
             	self.parent:Heal( heal, self:GetParent() )
			end
		end
	end
	end
end
function book_of_darkness_target:GetModifierTotalPercentageManaRegen()
    return self:GetAbility():GetSpecialValueFor('mp_regen')
end

function book_of_darkness_target:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mp')
end

modifier_silence_item = class({})

function modifier_silence_item:CheckState() 
  local state =
      {
   [MODIFIER_STATE_MUTED] = true
      }
  return state
end

function modifier_silence_item:IsPurgable()
    return false
end

function modifier_silence_item:IsHidden()
    return true
end



















LinkLuaModifier("modifier_book_of_darkness_spellbook", "heroes/reinforce/reinforce.lua", LUA_MODIFIER_MOTION_NONE)

book_of_darkness_spellbook = class({})

function book_of_darkness_spellbook:IsStealable() return true end
function book_of_darkness_spellbook:IsHiddenWhenStolen() return false end

function book_of_darkness_spellbook:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("reinforce_bloody_rockets")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function book_of_darkness_spellbook:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_book_of_darkness_spellbook", {})

end
---------------------------------------------------------------------------------------------------------------------
modifier_book_of_darkness_spellbook = class({})
function modifier_book_of_darkness_spellbook:IsHidden() return false end
function modifier_book_of_darkness_spellbook:IsDebuff() return true end
function modifier_book_of_darkness_spellbook:IsPurgable() return false end
function modifier_book_of_darkness_spellbook:IsPurgeException() return false end
function modifier_book_of_darkness_spellbook:RemoveOnDeath() return true end
function modifier_book_of_darkness_spellbook:AllowIllusionDuplicate() return true end


function modifier_book_of_darkness_spellbook:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

	if self.caster:HasModifier("modifier_reinforce_berserk_buff") then
	    self.skills_table = {
                            
							["book_of_darkness_spellbook"]="darkness_barrier",
							["reinforce_knockdown"]="reinforce_bloody_rockets",
							["starlight_breaker"]="book_of_darkness_spellbook_close",
							["book_of_darkness"]="prison_of_eruption",
							["reinforce_way_to_darkness"]="reinforce_demolish",
							
                        }
	else

    self.skills_table = {
                            
							["book_of_darkness_spellbook"]="darkness_barrier",
							["reinforce_knockdown"]="reinforce_bloody_rockets",
							["reinforce_berserk"]="book_of_darkness_spellbook_close",
							["book_of_darkness"]="prison_of_eruption",
							["reinforce_way_to_darkness"]="reinforce_demolish",
							
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
function modifier_book_of_darkness_spellbook:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_book_of_darkness_spellbook:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("book_of_darkness_spellbook_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end


book_of_darkness_spellbook_close = class({})

function book_of_darkness_spellbook_close:OnSpellStart()
    local caster = self:GetCaster() 

    if caster:FindModifierByNameAndCaster("modifier_book_of_darkness_spellbook", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_book_of_darkness_spellbook", caster)

        --return nil
    end
end










-----------------------



reinforce_bloody_rockets = class({})
LinkLuaModifier( "modifier_reinforce_bloody_rockets", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_reinforce_bloody_rockets_true", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function reinforce_bloody_rockets:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function reinforce_bloody_rockets:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("darkness_barrier")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function reinforce_bloody_rockets:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = 300
	

	-- load data
	local delay = self:GetSpecialValueFor("delay")
	if caster:HasModifier("modifier_reinforce_berserk_buff") then
		CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_reinforce_bloody_rockets_true", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)



	
	
	self:PlayEffects2( point, radius, duration )
	else
	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_reinforce_bloody_rockets", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)



	
	
	self:PlayEffects( point, radius, duration )
end
end
function reinforce_bloody_rockets:PlayEffects2( point, radius, duration )
self.caster = self:GetCaster()
		self.arena_barrier11 = "particles/reinforce_true_blood_rocket.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, self.caster )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, point )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )
	ParticleManager:ReleaseParticleIndex( self.arena_barrier )


	local sound_cast = "reinforce.rockets"

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
function reinforce_bloody_rockets:PlayEffects( point, radius, duration )
self.caster = self:GetCaster()
		self.arena_barrier11 = "particles/reinforce_bloody_rockets.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, self.caster )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, point )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )
	ParticleManager:ReleaseParticleIndex( self.arena_barrier )


	local sound_cast = "reinforce.rockets"

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

modifier_reinforce_bloody_rockets_true = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_reinforce_bloody_rockets_true:IsHidden()
	return true
end

function modifier_reinforce_bloody_rockets_true:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_reinforce_bloody_rockets_true:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = 0.5
	self.radius = 550
	self.damage = 1000
	local caster = self:GetCaster()
	  local int = caster:GetIntellect()
	  self.scale = 3 * int

  self.damage = self.scale + self.damage


	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_reinforce_bloody_rockets_true:OnRefresh( kv )
	
end

function modifier_reinforce_bloody_rockets_true:OnRemoved()
end

function modifier_reinforce_bloody_rockets_true:OnDestroy()
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
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 0.2 } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	local sound_cast = "reinforce.rockets_exp"
	
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )

	UTIL_Remove( self:GetParent() )
end
modifier_reinforce_bloody_rockets = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_reinforce_bloody_rockets:IsHidden()
	return true
end

function modifier_reinforce_bloody_rockets:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_reinforce_bloody_rockets:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	local caster = self:GetCaster()
	  local int = caster:GetIntellect()
	  self.scale = self:GetAbility():GetSpecialValueFor( "int_scale" ) * int

  self.damage = self.scale + self.damage


	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_reinforce_bloody_rockets:OnRefresh( kv )
	
end

function modifier_reinforce_bloody_rockets:OnRemoved()
end

function modifier_reinforce_bloody_rockets:OnDestroy()
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
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 0.2 } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	local sound_cast = "reinforce.rockets_exp"
	
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------







LinkLuaModifier("modifier_darkness_barrier_buff_block", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE)

darkness_barrier = class({})

function darkness_barrier:IsHiddenWhenStolen()	return false end
function darkness_barrier:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("prison_of_eruption")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function darkness_barrier:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Play Sound
		caster:EmitSound("reinforce.barrier")
		

		-- Check health cost required due to over channel
		

		-- Strong Dispel


		local modifier_name_aphotic_shield = "modifier_darkness_barrier_buff_block"

		-- Remove previous aphotic shield
		-- Did not use RemoveModifierByNameAndCaster because it will not destroy the shield if it was stolen by rubick from another rubick who stole from abaddon
		target:RemoveModifierByName(modifier_name_aphotic_shield)

		local duration = self:GetSpecialValueFor("duration")
		-- Add new modifier
		target:AddNewModifier(caster, self, modifier_name_aphotic_shield, { duration = duration })
	end
end

modifier_darkness_barrier_buff_block = modifier_darkness_barrier_buff_block or class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return false end
})

function modifier_darkness_barrier_buff_block:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_darkness_barrier_buff_block:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local shield_size = target:GetModelRadius() * 0.7
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel()
		local target_origin = target:GetAbsOrigin()
		local attach_hitloc = "attach_hitloc"
        local mana = caster:GetMaxMana()
		self.shield_init_value = self:GetAbility():GetSpecialValueFor("mana_shield") * mana
local mana2 = caster:GetMana() 
if self.shield_init_value > mana2 then
self.shield_init_value = mana2
else
end
caster:ReduceMana( self.shield_init_value )
		self.shield_remaining = self.shield_init_value
		self.target_current_health = target:GetHealth()

		-- Talent : During the first second of Aphotic Shield, it absorbs all damage done to it and adds it to it's health/damage
		

		local particle = ParticleManager:CreateParticle("particles/darkness_barrier.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local common_vector = Vector(shield_size,0,shield_size)
		ParticleManager:SetParticleControl(particle, 1, common_vector)
		ParticleManager:SetParticleControl(particle, 2, common_vector)
		ParticleManager:SetParticleControl(particle, 4, common_vector)
		ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc, target_origin, true)
		self:AddParticle(particle, false, false, -1, false, false)

	
		
	end
end

function modifier_darkness_barrier_buff_block:OnDestroy()
	if IsServer() then
		local target 				= self:GetParent()
		local caster 				= self:GetCaster()
		local ability 				= self:GetAbility()
		local ability_level 		= ability:GetLevel()
		local radius 				= 400
		local explode_target_team 	= DOTA_UNIT_TARGET_TEAM_BOTH
		local explode_target_type 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_vector			= target:GetAbsOrigin()
	
		target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")

		-- Explosion particle is shown by default when the particle is to be removed, however that does not work for illusions. Hence this added explosion is to make the particle show when illusions die
		local particle = ParticleManager:CreateParticle("particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance_explosion.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, target_vector)
		ParticleManager:ReleaseParticleIndex(particle)
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
	
			
			end
	end


--Block damage
function modifier_darkness_barrier_buff_block:GetModifierTotal_ConstantBlock(kv)
	if IsServer() then
		local target 					= self:GetParent()
		local original_shield_amount	= self.shield_remaining
		local shield_hit_particle 		= "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf"
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

function modifier_darkness_barrier_buff_block:ResetAndExtendBy(seconds)
	self.shield_remaining = self.shield_init_value
	self:SetDuration(self:GetRemainingTime() + seconds, true)
end












prison_of_eruption = class({})
LinkLuaModifier( "modifier_prison_of_eruption", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rein_unheal", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function prison_of_eruption:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function prison_of_eruption:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("reinforce_demolish")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function prison_of_eruption:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_prison_of_eruption", -- modifier name
		{}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

end
-- --------------------------------------------------------------------------------
-- function darkness_barrier_lua:PlayEffects()
-- 	-- Get Resources
-- 	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
-- 	local sound_cast = "string"

-- 	-- Get Data

-- 	-- Create Particle
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
-- 	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
-- 	ParticleManager:SetParticleControlEnt(
-- 		effect_cast,
-- 		iControlPoint,
-- 		hTarget,
-- 		PATTACH_NAME,
-- 		"attach_name",
-- 		vOrigin, -- unknown
-- 		bool -- unknown, true
-- 	)
-- 	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
-- 	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )

-- 	-- Create Sound
-- 	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
-- 	EmitSoundOn( sound_target, target )
-- end












modifier_prison_of_eruption = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_prison_of_eruption:IsHidden()
	return false
end

function modifier_prison_of_eruption:IsDebuff()
	return true
end

function modifier_prison_of_eruption:IsPurgable()
	return true
end

function modifier_prison_of_eruption:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_prison_of_eruption:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.owner = kv.isProvidedByAura~=1

	if self.owner then
		-- thinker references
		self.delay = self:GetAbility():GetSpecialValueFor( "formation_time" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
		
		-- set duration
		self:SetDuration( self.delay + self.duration, false )

		-- add delay
		self.formed = false
		self:StartIntervalThink( self.delay )

		-- play effects
		self:PlayEffects1()
		self.sound_loop = "reinforce.cage"
		EmitSoundOn( self.sound_loop, self:GetParent() )
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
		if self:GetParent():HasTalent("special_bonus_reinforce_25") then
		self:StartIntervalThink(0.1)
		end
	end
end

function modifier_prison_of_eruption:OnIntervalThink( kv )
if IsServer() then
local caster = self:GetCaster()
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

	-- Precache damage	

	
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_rein_unheal", {} )
		end
		end
end

function modifier_prison_of_eruption:OnRemoved()
end

function modifier_prison_of_eruption:OnDestroy()
	if not IsServer() then return end
	if self.owner then
		-- stop sound
		

		-- remove thinker
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_prison_of_eruption:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}

	return funcs
end
function modifier_prison_of_eruption:GetModifierMoveSpeedBonus_Percentage()
if self:GetCaster():HasTalent("special_bonus_reinforce_25") then
	return -20
	else return 0 end
end
function modifier_prison_of_eruption:GetDisableHealing()
if self:GetCaster():HasTalent("special_bonus_reinforce_25") then
	return 1
	else return 0 end
end
function modifier_prison_of_eruption:GetModifierMoveSpeed_Limit( params )
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
function modifier_prison_of_eruption:RemoveMotions()
	local modifiers = self.parent:FindAllModifiers(  )

	for _,modifier in pairs(modifiers) do
		-- print("modifier:",modifier,modifier:GetName())
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_prison_of_eruption:OnIntervalThink()
	self:StartIntervalThink( -1 )
	self.formed = true

	-- play effects
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_prison_of_eruption:IsAura()
	return self.owner and self.formed
end

function modifier_prison_of_eruption:GetModifierAura()
	return "modifier_prison_of_eruption"
end

function modifier_prison_of_eruption:GetAuraRadius()
	return self.radius
end

function modifier_prison_of_eruption:GetAuraDuration()
	return 0.3
end

function modifier_prison_of_eruption:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_prison_of_eruption:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_prison_of_eruption:GetAuraSearchFlags()
	return 0
end

function modifier_prison_of_eruption:GetAuraEntityReject( hEntity )
	if IsServer() then
		
	end

	return false
end

-- --------------------------------------------------------------------------------
-- -- Graphics & Animations
-- function modifier_prison_of_eruption:GetEffectName()
-- 	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
-- end

-- function modifier_prison_of_eruption:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

-- function modifier_prison_of_eruption:GetStatusEffectName()
-- 	return "status/effect/here.vpcf"
-- end

function modifier_prison_of_eruption:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/darkness_barrier_formation.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_prison_of_eruption:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/darkness_barrier_cage.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_rein_unheal = class({})

--------------------------------------------------------------------------------

function modifier_rein_unheal:IsDebuff()
	return true
end

function modifier_rein_unheal:IsStunDebuff()
	return false
end
function modifier_rein_unheal:IsHidden()
	return false
end
function modifier_rein_unheal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rein_unheal:OnDestroy( kv )
	-- references

		
	end


--------------------------------------------------------------------------------

function modifier_rein_unheal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}

	return funcs
end

function modifier_rein_unheal:GetModifierMoveSpeedBonus_Percentage()
	return -20
end
function modifier_rein_unheal:GetDisableHealing()
	return 1
end

--------------------------------------------------------------------------------

function modifier_rein_unheal:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff_frost.vpcf"
end

function modifier_rein_unheal:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


reinforce_demolish = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV

function reinforce_demolish:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("book_of_darkness_spellbook")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--------------------------------------------------------------------------------
-- Ability Start
function reinforce_demolish:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- check dragon modifier
	local modifier = caster:FindModifierByNameAndCaster( "modifier_dragon_knight_elder_dragon_form_lua", caster )

	-- check if simple form
	if not modifier then
		-- cancel if linken
		if target:TriggerSpellAbsorb( self ) then return end

		-- directly hit
		self:Hit( target, false )

		-- play effects
		local sound_cast = ""
		EmitSoundOn( sound_cast, caster )
		return
	end

	-- dragon form

end

-- Helper
function reinforce_demolish:Hit( target, dragonform )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("stun_duration")
   local duration2 = self:GetSpecialValueFor("duration")
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end
	local int = caster:GetIntellect()
	local scale = self:GetSpecialValueFor("int_scale") * int
 local damage =  self:GetSpecialValueFor("damage") + scale
	-- load data
	
local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	-- stun
	if self:GetCaster():HasTalent("special_bonus_reinforce_25_alt") then

target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_slow", -- modifier name
			{ duration = 1.0 } -- kv
		)

end
	-- Play effects
self:PlayEffects(target)
	local sound_cast = "reinforce.demolish"
	EmitSoundOn( sound_cast, target )
end
function reinforce_demolish:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/reinforce_demolish.vpcf"
	local sound_cast = ""

	-- Get Data
	local forward = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
	ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function reinforce_demolish:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end







reinforce_way_to_darkness = class({})
LinkLuaModifier( "modifier_reinforce_way_to_darkness", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function reinforce_way_to_darkness:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function reinforce_way_to_darkness:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_reinforce_way_to_darkness", -- modifier name
		{}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	-- effects
	local sound_cast = "reinforce.4"
	EmitSoundOn( sound_cast, caster )
end






modifier_reinforce_way_to_darkness = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_reinforce_way_to_darkness:IsHidden()
	return false
end

function modifier_reinforce_way_to_darkness:IsDebuff()
	return true
end

function modifier_reinforce_way_to_darkness:IsStunDebuff()
	return false
end

function modifier_reinforce_way_to_darkness:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_reinforce_way_to_darkness:OnCreated( kv )
	 


	if not IsServer() then return end

	-- check if it is thinker or aura targets
	self.owner = kv.isProvidedByAura~=1
	if not self.owner then return end

	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.pulses = self:GetAbility():GetSpecialValueFor( "pulses" )
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local int = self:GetCaster():GetIntellect()
	local int_scale = self:GetAbility():GetSpecialValueFor( "int_scale" ) * int
	local damage = self:GetAbility():GetSpecialValueFor( "damage_max" ) + int_scale
	
	
	-- calculate interval
	local interval = duration/self.pulses

	-- calculate damage
	local max_tick_damage = damage
	self.tick_damage = max_tick_damage
	self.pulse = 0

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		-- damage = 500,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	-- Start interval
	self:StartIntervalThink( interval )
	-- self:OnIntervalThink()

	-- play effects
	self:PlayEffects1( duration )
	self.sound_loop = "reinforce.4_storm"
	EmitSoundOn( self.sound_loop, self:GetParent() )
end

function modifier_reinforce_way_to_darkness:OnRefresh( kv )
	
end

function modifier_reinforce_way_to_darkness:OnRemoved()
end

function modifier_reinforce_way_to_darkness:OnDestroy()
	if not IsServer() then return end

	if self.owner then
		-- end sound
		StopSoundOn( self.sound_loop, self:GetParent() )
		local sound_stop = "reinforce.4_storm"
		EmitSoundOn( sound_stop, self:GetParent() )

		UTIL_Remove( self:GetParent() )
	end
end
function modifier_reinforce_way_to_darkness:DeclareFunctions()
	local func = { 
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					}
	return func
end
--------------------------------------------------------------------------------
-- Status Effects

function modifier_reinforce_way_to_darkness:GetModifierMagicalResistanceBonus()

	return self:GetAbility():GetSpecialValueFor( "magic_resist" )

end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_reinforce_way_to_darkness:OnIntervalThink()
	-- increment pulse
	self.pulse = self.pulse + 1

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

	-- set damage
	self.damageTable.damage = self.tick_damage 

	for _,enemy in pairs(enemies) do
		-- damage enemies
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- effects
		self:PlayEffects2(enemy)
	end

	-- check for pulses
	if self.pulse >= self.pulses then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_reinforce_way_to_darkness:IsAura()
	return self.owner
end

function modifier_reinforce_way_to_darkness:GetModifierAura()
	return "modifier_reinforce_way_to_darkness"
end

function modifier_reinforce_way_to_darkness:GetAuraRadius()
	return self.radius
end

function modifier_reinforce_way_to_darkness:GetAuraDuration()
	return 0.3
end

function modifier_reinforce_way_to_darkness:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_reinforce_way_to_darkness:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_reinforce_way_to_darkness:PlayEffects1( duration )
	-- Get Resources
	local particle_cast = "particles/reinforce_way_to_darkness.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_reinforce_way_to_darkness:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/econ/events/ti9/shivas_guard_ti9_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end















reinforce_berserk = class({})
LinkLuaModifier( "modifier_reinforce_berserk", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function reinforce_berserk:GetIntrinsicModifierName()
	return "modifier_reinforce_berserk"
end
function reinforce_berserk:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("starlight_breaker")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end


modifier_reinforce_berserk = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_reinforce_berserk:IsHidden()
	return true
end

function modifier_reinforce_berserk:IsDebuff()
	return false
end
function modifier_reinforce_berserk:RemoveOnDeath()
	return false
end
function modifier_reinforce_berserk:IsPurgable()
	return false
end
function modifier_reinforce_berserk:AllowIllusionDuplicate() return true end















modifier_reinforce_berserk_thinker = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_reinforce_berserk_thinker:OnCreated( kv )
	-- references
	self.radius = 600

	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_reinforce_berserk_thinker:OnRefresh( kv )
	
end

function modifier_reinforce_berserk_thinker:OnRemoved()
end

function modifier_reinforce_berserk_thinker:OnDestroy()
	if IsServer() then
	
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_ALL,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- apply slow
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_stunned",
			{ duration = 2 }
		)
	end
	self:PlayEffects2(600)
		UTIL_Remove( self:GetParent() )
	end
end
function modifier_reinforce_berserk_thinker:PlayEffects2( radius )

	local particle_cast = "particles/darkness_parade_shockwave.vpcf"

	-- Create Particle
local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_reinforce_berserk_thinker:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_reinforce_berserk_thinker:PlayEffects()
	-- Get Resources
	
local particle_cast = "particles/test_reinforce_screen.vpcf"
	local sound_cast = ""

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 2000, 2000, 2000 ) )

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


modifier_reinforce_berserk_thinker_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_reinforce_berserk_thinker_effect:IsHidden()
	return false
end

function modifier_reinforce_berserk_thinker_effect:IsDebuff()
	return true
end

function modifier_reinforce_berserk_thinker_effect:IsStunDebuff()
	return true
end

function modifier_reinforce_berserk_thinker_effect:IsPurgable()
	return false
end

function modifier_reinforce_berserk_thinker_effect:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end


--------------------------------------------------------------------------------
-- Initializations
function modifier_reinforce_berserk_thinker_effect:OnCreated( kv )
	

end

function modifier_reinforce_berserk_thinker_effect:OnRefresh( kv )
	
end

function modifier_reinforce_berserk_thinker_effect:OnRemoved()
end

function modifier_reinforce_berserk_thinker_effect:OnDestroy()
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Status Effects
function modifier_reinforce_berserk_thinker_effect:CheckState()

	local state2 = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	 return state2 end
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 modifier_reinforce_berserk_invul = class({})
function modifier_reinforce_berserk_invul:IsHidden() return false end
function modifier_reinforce_berserk_invul:IsDebuff() return true end
function modifier_reinforce_berserk_invul:IsPurgable() return false end
function modifier_reinforce_berserk_invul:IsPurgeException() return false end
function modifier_reinforce_berserk_invul:RemoveOnDeath() return true end
function modifier_reinforce_berserk_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_reinforce_berserk_invul:OnCreated()
if IsServer() then
        --self:SetStackCount(0)
self.screw_fx = 	ParticleManager:CreateParticle("particles/reinforce_berserk_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
								
       
    end
end
function modifier_reinforce_berserk_invul:OnDestroy()
if IsServer() then
local caster = self:GetCaster()

if self.screw_fx then
	    ParticleManager:DestroyParticle(self.screw_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx)
	end
	end
end


---------------------------------------------------------------------------------------------------------------------
modifier_reinforce_berserk_buff = class({})
function modifier_reinforce_berserk_buff:IsHidden() return false end
function modifier_reinforce_berserk_buff:IsDebuff() return true end
function modifier_reinforce_berserk_buff:IsPurgable() return false end
function modifier_reinforce_berserk_buff:IsPurgeException() return false end
function modifier_reinforce_berserk_buff:RemoveOnDeath() return true end
function modifier_reinforce_berserk_buff:AllowIllusionDuplicate() return true end
function modifier_reinforce_berserk_buff:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("reinforce_berserk_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_reinforce_berserk_buff:DeclareFunctions()
    local func = {  
    				
	              MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
				   MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
		}
    return func
end


function modifier_reinforce_berserk_buff:GetModifierBonusStats_Intellect()
    return 150
end

function modifier_reinforce_berserk_buff:GetModifierModelChange()
    return "models/reinforce/reinforce_2nd.vmdl"
end
function modifier_reinforce_berserk_buff:GetModifierModelScale()
	return 1
end

function modifier_reinforce_berserk_buff:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
	
	 

    self.skills_table = {
                            ["reinforce_berserk"] = "starlight_breaker",
							
                            
                        }
						
					
					
	
 

    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/reinforce_berserk_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		 
        EmitSoundOn("reinforce.5", self.parent)
		EmitSoundOn("reinforce.5_5", self.parent)
		end
		local ability11 = self:GetCaster():FindAbilityByName("reinforce_berserk")
        ability11:StartCooldown(220)

        self.parent:Purge(false, true, false, true, true)
    end
	end


function modifier_reinforce_berserk_buff:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_reinforce_berserk_buff:OnDestroy()
    if IsServer() then
	if self.parent:HasModifier("modifier_book_of_darkness_spellbook") then
	self.parent:RemoveModifierByName("modifier_book_of_darkness_spellbook") end
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

           

            if self.parent:IsRealHero() then
			 local ability3 = self.parent:FindAbilityByName("reinforce_berserk")
                ability3:StartCooldown(ability3:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("reinforce_berserk_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
				if IsServer() then
       
    end
end
end
end




starlight_breaker = class({})
LinkLuaModifier( "modifier_starlight_breaker", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_starlight_breaker_thinker", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_starlight_breaker_main", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
function starlight_breaker:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("book_of_darkness_spellbook_close")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function starlight_breaker:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = 2000
	local duration = 12

	-- Add modifier
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_starlight_breaker_thinker", -- modifier name
		{ duration = 4.18 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self.modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_starlight_breaker", -- modifier name
		{ duration = 4.18 } -- kv
	)
	StopSoundOn("reinforce.5", caster)
	StopSoundOn("reinforce.5_5", caster)
	EmitSoundOn("reinforce_starlight_breaker", caster)
		self:PlayEffects( point, radius, duration )
end
function starlight_breaker:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/starlight_breaker_visual.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	
end
--------------------------------------------------------------------------------
-- Ability Channeling
-- function starlight_breaker:GetChannelTime()

-- end
modifier_starlight_breaker_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_starlight_breaker_thinker:IsHidden()
	return true
end

function modifier_starlight_breaker_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_starlight_breaker_thinker:OnCreated( kv )
	if not IsServer() then return end

	-- references

	self.radius = 2000
	local int = self:GetCaster():GetIntellect() * 40
	self.damage = int
	local caster = self:GetCaster()


 

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_starlight_breaker_thinker:OnRefresh( kv )
	
end

function modifier_starlight_breaker_thinker:OnRemoved()
end

function modifier_starlight_breaker_thinker:OnDestroy()
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
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 3 } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_starlight_breaker_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/♣.vpcf"
	local sound_cast = "reinforce.starlight_explosion"


	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )

end

 modifier_starlight_breaker = class({})
function modifier_starlight_breaker:IsHidden() return false end
function modifier_starlight_breaker:IsDebuff() return true end
function modifier_starlight_breaker:IsPurgable() return false end
function modifier_starlight_breaker:IsPurgeException() return false end
function modifier_starlight_breaker:RemoveOnDeath() return true end
function modifier_starlight_breaker:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_starlight_breaker:OnCreated()
if IsServer() then
local caster = self:GetCaster()
caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_6, 2)
        --self:SetStackCount(0)
self.screw_fx = 	ParticleManager:CreateParticle("particles/starlight_breaker_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
								
       
    end
end
function modifier_starlight_breaker:OnDestroy()
if IsServer() then
local caster = self:GetCaster()
	caster:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_starlight_breaker_main", -- modifier name
			{ duration = 10 } -- kv
		)
if self.screw_fx then
	    ParticleManager:DestroyParticle(self.screw_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx)
	end
	end
end









modifier_starlight_breaker_main = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_starlight_breaker_main:IsHidden()
	return true
end

function modifier_starlight_breaker_main:IsDebuff()
	return false
end

function modifier_starlight_breaker_main:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Aura

--------------------------------------------------------------------------------
-- Initializations
function modifier_starlight_breaker_main:OnCreated( kv )
	-- references
	self.slow_radius = 8000
	self.explosion_radius = 250
	self.explosion_interval = 0.15
	self.explosion_min_dist = 0
	self.explosion_max_dist = 1500
	local int = self:GetCaster():GetIntellect() * 4
	local explosion_damage = int

	-- generate data
	self.quartal = -1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()

		-- Play Effects
	
	end
end

function modifier_starlight_breaker_main:OnRefresh( kv )
	-- references
	self:OnCreated(kv)
end

function modifier_starlight_breaker_main:OnDestroy( kv )

	if IsServer() then
		self:StartIntervalThink( -1 )
		self:StopEffects1()
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_starlight_breaker_main:OnIntervalThink()
	-- Set explosion quartal
	self.quartal = self.quartal+1
	if self.quartal>3 then self.quartal = 0 end

	-- determine explosion relative position
	local a = RandomInt(0,90) + self.quartal*90
	local r = RandomInt(self.explosion_min_dist,self.explosion_max_dist)
	local point = Vector( math.cos(a), math.sin(a), 0 ):Normalized() * r

	-- actual position
	point = self:GetCaster():GetOrigin() + point

	-- Explode at point
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.explosion_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage units
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- Play effects
	AddFOWViewer(DOTA_TEAM_GOODGUYS, self:GetParent():GetAbsOrigin(), 2, 1, false)
	AddFOWViewer(DOTA_TEAM_BADGUYS, self:GetParent():GetAbsOrigin(), 2, 1, false)
	AddFOWViewer(DOTA_TEAM_CUSTOM_1, self:GetParent():GetAbsOrigin(), 2, 1, false)
	AddFOWViewer(DOTA_TEAM_CUSTOM_2, self:GetParent():GetAbsOrigin(), 2, 1, false)
	self:PlayEffects2( point )
end

function modifier_starlight_breaker_main:PlayEffects2( point )
	-- Get Resources
	local particle_cast = "particles/starlight_breaker_beam3.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 400, 1, 400 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

local sound_cast = "starlight.breker_beam"
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
	
end
function modifier_starlight_breaker_main:StopEffects1()
	StopSoundOn( self.sound_cast, self:GetCaster() )
end



reinforce_darkness_parade = class({})
LinkLuaModifier( "modifier_reinforce_darkness_parade", "heroes/reinforce/reinforce", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function reinforce_darkness_parade:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function reinforce_darkness_parade:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = 300
	

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_reinforce_darkness_parade", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	
	if caster:HasModifier("modifier_reinforce_berserk_buff") then
	for i = 1,3 do
	local origin = point + RandomVector(500)
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_reinforce_darkness_parade", -- modifier name
		{ duration = delay }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( origin, radius, duration )
	end
	end
	self:PlayEffects( point, radius, duration )
	EmitSoundOn("reinforce.darkness_parade", caster)
end
function reinforce_darkness_parade:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/reinforce_darkness_parade.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	
end
modifier_reinforce_darkness_parade = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_reinforce_darkness_parade:IsHidden()
	return true
end

function modifier_reinforce_darkness_parade:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_reinforce_darkness_parade:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local caster = self:GetCaster()
	  local gold = caster:GetIntellect()

  self.damage = (gold * 4)

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_reinforce_darkness_parade:OnRefresh( kv )
	
end

function modifier_reinforce_darkness_parade:OnRemoved()
end

function modifier_reinforce_darkness_parade:OnDestroy()
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
		-- stun
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

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_reinforce_darkness_parade:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/darkness_parade_explosion.vpcf"
	local sound_cast = "reinforce.parade_exp"


	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )

end