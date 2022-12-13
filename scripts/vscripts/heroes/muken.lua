muken = class({})
LinkLuaModifier( "modifier_muken", "modifiers/modifier_muken", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hidden_move", "heroes/muken.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_original", "heroes/muken.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function muken:GetIntrinsicModifierName()
    return "modifier_original"
end
function muken:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("jin_mori_original3")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function muken:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	if target then
		point = target:GetOrigin()
	end
if self:GetCaster():HasModifier("modifier_secret_move") then
	caster:AddNewModifier(caster, self, "modifier_hidden_move", {duration = 5})
	else
	end
	-- load data
	local projectile_name = "particles/muken.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
	local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
	local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
	local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )

	-- get direction
	local direction = point-caster:GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	local sound_cast = "mori.1"
	local sound_projectile = "mori.1_1"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_projectile, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Projectile
function muken:OnProjectileHitHandle( target, location, projectile )
	if not target then return end
	local bduration = self:GetSpecialValueFor("bleed")
	
	

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	target:AddNewModifier(self:GetCaster(), self, "modifier_muken", {duration = self:GetSpecialValueFor("bleed") })

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()
    
	-- play effects
	self:PlayEffects( target, direction )
end

--------------------------------------------------------------------------------
function muken:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
modifier_original = class ({})
function modifier_original:IsHidden() return true end
function modifier_original:IsDebuff() return false end
function modifier_original:IsPurgable() return false end
function modifier_original:IsPurgeException() return false end
function modifier_original:RemoveOnDeath() return false end

function modifier_original:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_original:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_original:OnIntervalThink()
    if IsServer() then
        local monkey_kong = self:GetParent():FindAbilityByName("jin_mori_original3")
        if monkey_kong and not monkey_kong:IsNull() then
            if self:GetParent():HasScepter() then
                if monkey_kong:IsHidden() then
                    monkey_kong:SetHidden(false)
                end
            else
                if not monkey_kong:IsHidden() then
                    monkey_kong:SetHidden(true)
                end
            end
        end
    end
end
modifier_hidden_move = class({})
function modifier_hidden_move:IsHidden() return true end
function modifier_hidden_move:IsDebuff() return false end
function modifier_hidden_move:IsPurgable() return false end
function modifier_hidden_move:IsPurgeException() return false end
function modifier_hidden_move:RemoveOnDeath() return true end