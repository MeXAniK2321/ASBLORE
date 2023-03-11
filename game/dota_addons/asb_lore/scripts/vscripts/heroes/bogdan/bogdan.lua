gay_bar = class({})
LinkLuaModifier( "modifier_gay_bar", "heroes/bogdan/bogdan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gay_bar_target", "heroes/bogdan/bogdan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gay_bar_effect", "heroes/bogdan/bogdan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gay_bar_effect2", "heroes/bogdan/bogdan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gay_bar_effect_self", "heroes/bogdan/bogdan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
-- Ability Start
function gay_bar:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- check dragon modifier
	local modifier = caster:FindModifierByNameAndCaster( "modifier_dragon_knight_elder_dragon_form_lua", caster )

	-- check if simple form
	
		self:Hit( target, false )

end

-- Helper
function gay_bar:Hit( target, dragonform )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local origin = caster:GetOrigin() +  RandomVector(100)
	   if self.slave and IsValidEntity(self.slave) and self.slave:IsAlive() then
        FindClearSpaceForUnit(self.slave, origin, true)
        self.slave:SetHealth(self.slave:GetMaxHealth())
        
    else
        self.slave = CreateUnitByName("npc_dota_bogdan_slave", origin, true, caster, caster, caster:GetTeamNumber())
		    local player = caster:GetPlayerID()
        self.slave:SetControllableByPlayer(player, true)
		self.slave:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_gay_bar", -- modifier name
		{ duration = duration } -- kv
	)
		self.slave:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_gay_bar_effect", -- modifier name
		{ duration = duration } -- kv
	)
        	self.slave:MoveToTargetToAttack(target)
    end
	
	
	
	
	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_gay_bar_target", -- modifier name
		{ duration = duration } -- kv
	)

	-- Play effects

	local sound_cast = "gay.bar"
	EmitSoundOn( sound_cast, target )
end


--------------------------------------------------------------------------------
modifier_gay_bar_target = class ({})
function modifier_gay_bar_target:IsHidden() return true end
function modifier_gay_bar_target:IsDebuff() return false end
function modifier_gay_bar_target:IsPurgable() return false end
function modifier_gay_bar_target:IsPurgeException() return false end
function modifier_gay_bar_target:RemoveOnDeath() return false end

function modifier_gay_bar_target:OnCreated()
    if IsServer() then
    
       
    end
end
function modifier_gay_bar_target:OnDestroy()
    if IsServer() then
StopSoundOn("gay.bar",self:GetParent())
	
	end
	end
	
	
	
	
	modifier_gay_bar = class ({})
function modifier_gay_bar:IsHidden() return true end
function modifier_gay_bar:IsDebuff() return false end
function modifier_gay_bar:IsPurgable() return false end
function modifier_gay_bar:IsPurgeException() return false end
function modifier_gay_bar:RemoveOnDeath() return false end
function modifier_gay_bar:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		--[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end
function modifier_gay_bar:OnCreated()
    if IsServer() then
    
        self:StartIntervalThink(0.1)
    end
end
function modifier_gay_bar:OnIntervalThink()
    if IsServer() then
	local caster = self:GetParent()
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			1500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_gay_bar_target") then
	self.target = enemy
	        	caster:MoveToTargetToAttack(self.target)
				return
	end
	end
	end
	end
	
	
function modifier_gay_bar:OnDestroy()
    if IsServer() then
    
      if not self:GetParent():HasModifier("modifier_gay_bar_effect_self") then
	  self:GetParent():Kill(self,self:GetParent())
	  end
    end
end

	
	
	
modifier_gay_bar_effect = class ({})
function modifier_gay_bar_effect:IsHidden() return true end
function modifier_gay_bar_effect:IsDebuff() return false end
function modifier_gay_bar_effect:IsPurgable() return false end
function modifier_gay_bar_effect:IsPurgeException() return false end
function modifier_gay_bar_effect:RemoveOnDeath() return false end

function modifier_gay_bar_effect:OnCreated()
    if IsServer() then
    
        self:StartIntervalThink(0.1)
    end
end
function modifier_gay_bar_effect:OnIntervalThink()
    if IsServer() then
				local int = self:GetCaster():GetIntellect()
							local scale = self:GetAbility():GetSpecialValueFor("int_scale") * int
	local duration = self:GetAbility():GetSpecialValueFor("stun")
		self.damage = self:GetAbility():GetSpecialValueFor("damage") + int

	local caster = self:GetParent()
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			250,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_gay_bar_target") then
enemy:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_gay_bar_effect2", -- modifier name
		{ duration = duration,damage = self.damage } -- kv
	)
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_gay_bar_effect_self", -- modifier name
		{ duration = duration } -- kv
	)
	local target = enemy
	local target_loc_forward_vector = target:GetForwardVector()
	local final_pos = target:GetAbsOrigin() - target_loc_forward_vector * 150
	

		StopSoundOn("gay.bar",enemy)
	

	-- Blink
	caster:SetOrigin( final_pos )
	FindClearSpaceForUnit( caster, final_pos, true )
	caster:SetForwardVector(target_loc_forward_vector)
	self:Destroy()
				return
	end
	end
	end
	end	
	
	
	
	
	
	
	
	modifier_gay_bar_effect2 = class({})

--------------------------------------------------------------------------------
function modifier_gay_bar_effect2:CheckState()
	local state = {
		--[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		--[MODIFIER_STATE_UNSELECTABLE] = true,
		--[MODIFIER_STATE_INVULNERABLE] = true,
		--[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end
function modifier_gay_bar_effect2:IsDebuff()
	return true
end
function modifier_gay_bar_effect2:IsPurgable()
	return false
end
function modifier_gay_bar_effect2:IsStunDebuff()
	return true
end

function modifier_gay_bar_effect2:OnCreated(kv)	
if IsServer() then
self.damage = kv.damage
self:PlayEffects(self:GetParent():GetOrigin(),600,1.0)
end
end
function modifier_gay_bar_effect2:OnDestroy(kv)	
if IsServer() then
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage( damageTable )

end
end
	
	
	
function modifier_gay_bar_effect2:PlayEffects( point, radius, duration )
	-- Get Resources
	self.sound_cast = "bogdan.slave_fuck"
	EmitSoundOn( self.sound_cast, self:GetParent() )
	local particle_cast = "particles/test_bogdan_slave_fuck.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
	
	
	modifier_gay_bar_effect_self = class ({})
function modifier_gay_bar_effect_self:IsHidden() return true end
function modifier_gay_bar_effect_self:IsDebuff() return false end
function modifier_gay_bar_effect_self:IsPurgable() return false end
function modifier_gay_bar_effect_self:IsPurgeException() return false end
function modifier_gay_bar_effect_self:RemoveOnDeath() return false end
function modifier_gay_bar_effect_self:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end
function modifier_gay_bar_effect_self:OnCreated()
    if IsServer() then
    
      self:GetParent():StartGesture(ACT_DOTA_CHANNEL_ABILITY_1)
    end
end
function modifier_gay_bar_effect_self:OnIntervalThink()
    if IsServer() then
	local caster = self:GetParent()
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			1500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_gay_bar_effect_self_target") then
	self.target = enemy
	        	caster:MoveToTargetToAttack(self.target)
				return
	end
	end
	end
	end
	
	
function modifier_gay_bar_effect_self:OnDestroy()
    if IsServer() then
    
      
	  self:GetParent():Kill(self,self:GetParent())
	  
    end
end









unlimited_gay_works = class({})
LinkLuaModifier("modifier_unlimited_gay_works", "heroes/bogdan/bogdan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_unlimited_gay_works_count", "heroes/bogdan/bogdan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_unlimited_gay_works_invul", "heroes/bogdan/bogdan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gay_works_thinker", "heroes/bogdan/bogdan", LUA_MODIFIER_MOTION_NONE)
function unlimited_gay_works:IsStealable() return true end
function unlimited_gay_works:IsHiddenWhenStolen() return false end

function unlimited_gay_works:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("gaynado")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	    local ability2 = self:GetCaster():FindAbilityByName("gachi_storm")
    if ability2 and ability2:GetLevel() < self:GetLevel() then
        ability2:SetLevel(self:GetLevel())
    end
end

function unlimited_gay_works:OnSpellStart()
    local caster = self:GetCaster()
	if not caster:HasModifier("modifier_unlimited_gay_works_count") then
		caster:AddNewModifier(caster, self, "modifier_unlimited_gay_works_count", {})
		else
		local modifier = caster:FindModifierByNameAndCaster("modifier_unlimited_gay_works_count",caster)
			local current = modifier:GetStackCount()
		modifier:SetStackCount(current + 1)
		end
		local modifier = caster:FindModifierByNameAndCaster("modifier_unlimited_gay_works_count",caster)
local current = modifier:GetStackCount()
if current > 7 then

        EmitSoundOn("bogdan.key_works_8", caster)
	
	   caster:AddNewModifier(caster, self, "modifier_unlimited_gay_works", {duration = 60})
	caster:AddNewModifier(caster, self, "modifier_unlimited_gay_works_invul", {duration = 2.0})
		caster:RemoveModifierByName("modifier_unlimited_gay_works_count")
	 

	  caster:RemoveModifierByName("modifier_star_tier2")
  	  --caster:RemoveModifierByName("modifier_star_tier3")
	
	 -- caster:RemoveModifierByName("modifier_star_tier1")
		--_G.CurrentMusicUltima = "bogdan.gay_bar"
		EmitSoundOn("gay.bar", caster)
	  caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = 60})


	local point2 = Vector(0,0,-1536)
	local delay22 = 2
		Timers:CreateTimer(delay22,function()
    CreateModifierThinker(caster, self, "modifier_gay_works_thinker", {duration = 57.9}, point2, caster:GetTeamNumber(), false)
end)
    self:EndCooldown()
	self:PlayEffects()
	else
	
local number = modifier:GetStackCount()
if number == 1 then
EmitSoundOn("unlimited.gay_works_1",self:GetCaster())
elseif number == 2 then
EmitSoundOn("unlimited.gay_works_2",self:GetCaster())
elseif number == 3 then
EmitSoundOn("unlimited.gay_works_3",self:GetCaster())
elseif number == 4 then
EmitSoundOn("unlimited.gay_works_4",self:GetCaster())
elseif number == 5 then
EmitSoundOn("unlimited.gay_works_5",self:GetCaster())
elseif number == 6 then
EmitSoundOn("unlimited.gay_works_6",self:GetCaster())
elseif number == 7 then
EmitSoundOn("unlimited.gay_works_7",self:GetCaster())
end
	end
	end
	
	

 
function unlimited_gay_works:PlayEffects( )

	local particle_cast = "particles/gay_bar_activation.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )


end

modifier_unlimited_gay_works_invul = class({})
function modifier_unlimited_gay_works_invul:IsHidden() return false end
function modifier_unlimited_gay_works_invul:IsDebuff() return true end
function modifier_unlimited_gay_works_invul:IsPurgable() return false end
function modifier_unlimited_gay_works_invul:IsPurgeException() return false end
function modifier_unlimited_gay_works_invul:RemoveOnDeath() return true end
function modifier_unlimited_gay_works_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_unlimited_gay_works_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_unlimited_gay_works_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end


---------------------------------------------------------------------------------------------------------------------
modifier_unlimited_gay_works = class({})
function modifier_unlimited_gay_works:IsHidden() return false end
function modifier_unlimited_gay_works:IsDebuff() return true end
function modifier_unlimited_gay_works:IsPurgable() return false end
function modifier_unlimited_gay_works:IsPurgeException() return false end
function modifier_unlimited_gay_works:RemoveOnDeath() return false end
function modifier_unlimited_gay_works:AllowIllusionDuplicate() return true end
function modifier_unlimited_gay_works:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("unlimited_gay_works_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_unlimited_gay_works:DeclareFunctions()
    local func = {  
    				
	               	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					 MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, }
    return func
end



function modifier_unlimited_gay_works:GetModifierSpellAmplify_Percentage()
    return 50
end
function modifier_unlimited_gay_works:GetModifierBonusStats_Strength()
    return 100
end


function modifier_unlimited_gay_works:GetModifierPhysicalArmorBonus()

return 30
end


function modifier_unlimited_gay_works:GetModifierPercentageCooldown()
  
    return 30
end


function modifier_unlimited_gay_works:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
    self.skills_table = {
                            ["unlimited_gay_works"] = "gaynado",
							["gachi_storm"] = "gachi_storm"
						
							
							
                            
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
		if IsASBPatreon(self.caster) then
		self.particle_time =    ParticleManager:CreateParticle("particles/bogdan_gachi_bar_aura_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		else
            self.particle_time =    ParticleManager:CreateParticle("particles/bogdan_gachi_bar_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
end
      
     
		

    
        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_unlimited_gay_works:OnRefresh(table)
    self:OnCreated(table)
end

function modifier_unlimited_gay_works:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

            if self.particle_time then
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
        	end


            if self.parent:IsRealHero() then
                self.ability:StartCooldown(160)
                local ability = self.parent:FindAbilityByName("unlimited_gay_works_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end


modifier_gay_works_thinker = class({})

function modifier_gay_works_thinker:OnCreated( kv )
if IsServer() then
	self.caster = self:GetParent()
	self.parent = self:GetParent()
	self:StartIntervalThink(0.1)
	self.radius = 4000
self.arena_barrier11 = "particles/test_bogdan_key_works.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, self.caster:GetOrigin() )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )
	self:OnIntervalThink()
	end
	end
	


function modifier_gay_works_thinker:OnRefresh( kv )
	
end

function modifier_gay_works_thinker:OnDestroy()
   if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
end
function modifier_gay_works_thinker:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end



function modifier_gay_works_thinker:OnIntervalThink()
if IsServer() then

	AddFOWViewer(DOTA_TEAM_GOODGUYS, self:GetParent():GetAbsOrigin(), 50, 1, false)
	AddFOWViewer(DOTA_TEAM_BADGUYS, self:GetParent():GetAbsOrigin(), 50, 1, false)
	AddFOWViewer(DOTA_TEAM_CUSTOM_1, self:GetParent():GetAbsOrigin(), 50, 1, false)
	AddFOWViewer(DOTA_TEAM_CUSTOM_2, self:GetParent():GetAbsOrigin(), 50, 1, false)
	AddFOWViewer(DOTA_TEAM_CUSTOM_3, self:GetParent():GetAbsOrigin(), 50, 1, false)

	end
	end
	
	
	
	modifier_unlimited_gay_works_count = class({})
function modifier_unlimited_gay_works_count:IsHidden() return false end
function modifier_unlimited_gay_works_count:IsDebuff() return true end
function modifier_unlimited_gay_works_count:IsPurgable() return false end
function modifier_unlimited_gay_works_count:IsPurgeException() return false end
function modifier_unlimited_gay_works_count:RemoveOnDeath() return false end
function modifier_unlimited_gay_works_count:OnCreated()
self:SetStackCount(1)
end

