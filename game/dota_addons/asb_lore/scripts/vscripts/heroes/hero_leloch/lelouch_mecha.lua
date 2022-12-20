LinkLuaModifier("modifier_mecha_forward", "heroes/hero_leloch/lelouch_mecha", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_mecha_owner", "heroes/hero_leloch/lelouch_mecha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mecha_timer", "heroes/hero_leloch/lelouch_mecha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lelouch_jump_pause", "heroes/hero_leloch/lelouch_mecha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lelouch_pepega", "heroes/hero_leloch/lelouch_mecha", LUA_MODIFIER_MOTION_HORIZONTAL)

modifier_mecha_owner = class({})

function modifier_mecha_owner:OnDestroy()
    self.parent = self:GetParent()
    FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
end
 

function modifier_mecha_owner:IsHidden() return true end

lelouch_mecha = class({})

function lelouch_mecha:OnSpellStart()
	local caster = self:GetCaster()
	local mecha = CreateUnitByName("lelouch_mecha", caster:GetAbsOrigin(), true, nil, nil, caster:GetTeamNumber())
		
	mecha:SetControllableByPlayer(caster:GetPlayerID(), true)
	mecha:SetOwner(caster)
	FindClearSpaceForUnit(mecha, mecha:GetAbsOrigin(), true)
    mecha:SetForwardVector(caster:GetForwardVector())
			
			-- Level abilities
	mecha:FindAbilityByName("tinker_laser_lua"):SetLevel(1)
	mecha:FindAbilityByName("tinker_heat_seeking_missile_lua"):SetLevel(1)
    mecha:FindAbilityByName("lelouch_mecha_forward"):SetLevel(1)

	mecha:AddNewModifier(hCaster, self, "modifier_kill", { duration = 30.0 })
    --mecha:AddNewModifier(caster, self, "modifier_mecha_timer", {duration = 30})
end

function lelouch_mecha:GetIntrinsicModifierName()
    return "modifier_lelouch_pepega"
end

modifier_lelouch_pepega = class ({})
function modifier_lelouch_pepega:IsHidden() return true end
function modifier_lelouch_pepega:IsDebuff() return false end
function modifier_lelouch_pepega:IsPurgable() return false end
function modifier_lelouch_pepega:IsPurgeException() return false end
function modifier_lelouch_pepega:RemoveOnDeath() return false end

function modifier_lelouch_pepega:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_lelouch_pepega:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_lelouch_pepega:OnIntervalThink()
    if IsServer() then
    local caster = self:GetParent()
        local vongolle = self:GetParent():FindAbilityByName("geass_2")
        if vongolle and not vongolle:IsNull() then
            if self:GetParent():HasScepter() then
                if vongolle:IsHidden() then
                    vongolle:SetHidden(false)
                    vongolle:SetLevel(self:GetAbility():GetLevel())
                end
            else
                if not vongolle:IsHidden() then
                    vongolle:SetHidden(true)
                end
            end
        end
    end
end

modifier_lelouch_jump_pause = class({})

function modifier_lelouch_jump_pause:IsHidden() return true end

function modifier_lelouch_jump_pause:OnCreated()
    self:GetCaster():AddEffects(EF_NODRAW)
    EmitSoundOn("op", self:GetParent())
end

function modifier_lelouch_jump_pause:OnRefresh()
end

function modifier_lelouch_jump_pause:OnDestroy()
    self:GetCaster():RemoveEffects(EF_NODRAW)
    StopSoundOn("op", self:GetParent())
end

function modifier_lelouch_jump_pause:CheckState()
    return { [MODIFIER_STATE_INVULNERABLE] = true,
             [MODIFIER_STATE_NO_HEALTH_BAR] = true,
             [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
             [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
             [MODIFIER_STATE_UNSELECTABLE] = true,
             [MODIFIER_STATE_STUNNED] = true}
end


--[[modifier_mecha_timer = class({})

function modifier_mecha_timer:GetIntrinsicModifierName()
    return "modifier_mecha_timer"
end

function modifier_mecha_timer:IsHidden() return false end
function modifier_mecha_timer:IsDebuff() return false end]]

lelouch_mecha_forward = class({})

function lelouch_mecha_forward:GetIntrinsicModifierName()
	return "modifier_mecha_forward"
end

modifier_mecha_forward = class({})

function modifier_mecha_forward:IsHidden() return true end

function modifier_mecha_forward:RemoveOnDeath() return true end

function modifier_mecha_forward:OnCreated()
	self:StartIntervalThink(FrameTime())
end

function modifier_mecha_forward:OnIntervalThink()
	self.parent = self:GetParent()
    self.owner = self.parent:GetOwner()
	if self.parent:IsAlive() then
        self.parent:GetOwner():AddNewModifier(self.owner, nil, "modifier_lelouch_jump_pause", { duration = FrameTime()*2 })
        self.parent:GetOwner():AddNewModifier(self.parent, self, "modifier_mecha_owner", {duration = FrameTime()*2})
		self.parent:GetOwner():SetOrigin(self.parent:GetAbsOrigin())
		self.parent:GetOwner():SetForwardVector(self.parent:GetForwardVector())
	end
end

tinker_heat_seeking_missile_lua = class({})

--------------------------------------------------------------------------------
-- Ability Start
function tinker_heat_seeking_missile_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()

    -- load data
    local radius = self:GetSpecialValueFor("radius")
    local damage = self:GetSpecialValueFor("damage")    
    local targets = self:GetSpecialValueFor("targets")
    if caster:HasScepter() then
        targets = self:GetSpecialValueFor("targets_scepter")
    end
    local projectile_name = "particles/units/heroes/hero_tinker/tinker_missile.vpcf"
    local projectile_speed = self:GetSpecialValueFor("speed")

    -- find enemies
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(), -- int, your team number
        caster:GetOrigin(), -- point, center point
        nil,    -- handle, cacheUnit. (not known)
        radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
        DOTA_UNIT_TARGET_HERO,  -- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, -- int, flag filter
        FIND_CLOSEST,   -- int, order filter
        false   -- bool, can grow cache
    )

    -- create projectile for each enemy
    local info = {
        Source = caster,
        -- Target = target,
        Ability = self,
        EffectName = projectile_name,
        iMoveSpeed = projectile_speed,
        bDodgeable = true,
        ExtraData = {
            damage = damage,
        }
    }
    for i=1,math.min(targets,#enemies) do
        info.Target = enemies[i]
        ProjectileManager:CreateTrackingProjectile( info )
    end

    -- effects
    if #enemies<1 then
        self:PlayEffects2()
    else
        local sound_cast = "Hero_Tinker.Heat-Seeking_Missile"
        EmitSoundOn( sound_cast, caster )
    end
end
--------------------------------------------------------------------------------
-- Projectile
function tinker_heat_seeking_missile_lua:OnProjectileHit_ExtraData( target, location, extraData )
    -- Apply damage
    local damage = {
        victim = target,
        attacker = self:GetCaster(),
        damage = extraData.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self
    }
    ApplyDamage( damage )

    -- effects
    self:PlayEffects1( target )
end

--------------------------------------------------------------------------------
-- Effects
function tinker_heat_seeking_missile_lua:PlayEffects1( target )
    local particle_cast = "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf"
    local sound_cast = "Hero_Tinker.Heat-Seeking_Missile.Impact"

    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn( sound_cast, target )
end

function tinker_heat_seeking_missile_lua:PlayEffects2()
    local particle_cast = "particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf"
    local sound_cast = "Hero_Tinker.Heat-Seeking_Missile_Dud"

    local attach = "attach_attack1"
    if self:GetCaster():ScriptLookupAttachment( "attach_attack3" )~=0 then attach = "attach_attack3" end
    local point = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( attach ) )

    -- play particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( effect_cast, 0, point )
    ParticleManager:SetParticleControlForward( effect_cast, 0, self:GetCaster():GetForwardVector() )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn( sound_cast, self:GetCaster() )
end

tinker_laser_lua = class({})
LinkLuaModifier( "modifier_tinker_laser_lua", "heroes/hero_leloch/lelouch_mecha", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Phase Start
function tinker_laser_lua:OnAbilityPhaseStart()
    -- effects
    local sound_cast = "Hero_Tinker.LaserAnim"
    EmitSoundOn( sound_cast, self:GetCaster() )

    return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function tinker_laser_lua:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- cancel if Linken
    if target:TriggerSpellAbsorb( self ) then
        return
    end

    -- load data
    local duration_hero = self:GetSpecialValueFor("duration_hero")
    local duration_creep = self:GetSpecialValueFor("duration_creep")
    local damage = self:GetSpecialValueFor("laser_damage")

    -- get targets
    local targets = {}
    table.insert( targets, target )
    if caster:HasScepter() then
        self:Refract( targets, 1 )
    end

    -- precache damage
    local damage = {
        -- victim = hTarget,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self
    }
    for _,enemy in pairs(targets) do
        -- apply damage
        damage.victim = enemy
        ApplyDamage( damage )

        -- add modifier
        local duration = duration_hero
        if enemy:IsCreep() then
            duration = duration_creep
        end
        enemy:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_tinker_laser_lua", -- modifier name
            { duration = duration } -- kv
        )
    end

    -- effects
    self:PlayEffects( targets )
end

function tinker_laser_lua:Refract( targets, jumps )
    -- load data
    local scepter_range = self:GetSpecialValueFor("scepter_bounce_range")

    -- Find Units in Radius
    local enemies = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),   -- int, your team number
        targets[jumps]:GetOrigin(), -- point, center point
        nil,    -- handle, cacheUnit. (not known)
        scepter_range,  -- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
        DOTA_UNIT_TARGET_HERO,  -- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, -- int, flag filter
        FIND_CLOSEST,   -- int, order filter
        false   -- bool, can grow cache
    )

    -- check for valid closest not-yet-affected next target 
    local next_target = nil
    for _,enemy in pairs(enemies) do
        local candidate = true
        for _,target in pairs(targets) do
            if enemy==target then
                candidate = false
                break
            end
        end
        if candidate then
            next_target = enemy
            break
        end
    end

    -- recursive
    if next_target then
        table.insert( targets, next_target )
        self:Refract( targets, jumps+1 )
    end
end

--------------------------------------------------------------------------------
function tinker_laser_lua:PlayEffects( targets )
    -- Get Resources
    local particle_cast = "particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf"
    local sound_cast = "Hero_Tinker.Laser"
    local sound_target = "Hero_Tinker.LaserImpact"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

    local attach = "attach_attack1"
    if self:GetCaster():ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        9,
        self:GetCaster(),
        PATTACH_POINT_FOLLOW,
        attach,
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        targets[1],
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( sound_cast, self:GetCaster() )
    EmitSoundOn( sound_target, targets[1] )

    if #targets>1 then
        for i=2,#targets do
            -- Create Particle
            local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControlEnt(
                effect_cast,
                9,
                targets[i-1],
                PATTACH_POINT_FOLLOW,
                "attach_hitloc",
                Vector(0,0,0), -- unknown
                true -- unknown, true
            )
            ParticleManager:SetParticleControlEnt(
                effect_cast,
                1,
                targets[i],
                PATTACH_POINT_FOLLOW,
                "attach_hitloc",
                Vector(0,0,0), -- unknown
                true -- unknown, true
            )
            ParticleManager:ReleaseParticleIndex( effect_cast )

            -- create sound
            EmitSoundOn( sound_target, targets[i] )
        end
    end
end

modifier_tinker_laser_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tinker_laser_lua:IsHidden()
    return false
end

function modifier_tinker_laser_lua:IsDebuff()
    return true
end

function modifier_tinker_laser_lua:IsStunDebuff()
    return false
end

function modifier_tinker_laser_lua:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tinker_laser_lua:OnCreated( kv )
    -- references
    self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end

function modifier_tinker_laser_lua:OnRefresh( kv )
    -- references
    self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end

function modifier_tinker_laser_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_tinker_laser_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MISS_PERCENTAGE,
    }

    return funcs
end

function modifier_tinker_laser_lua:GetModifierMiss_Percentage()
    return self.miss_rate
end