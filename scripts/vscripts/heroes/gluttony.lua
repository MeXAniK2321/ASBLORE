gluttony = class({})
LinkLuaModifier( "modifier_slime", "heroes/gluttony.lua", LUA_MODIFIER_MOTION_NONE )


function gluttony:GetIntrinsicModifierName()
    return "modifier_slime"
end
--------------------------------------------------------------------------------
-- Ability Start
function gluttony:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_spider")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function gluttony:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	if target then
		point = target:GetOrigin()
	end

	-- load data
	local projectile_name = "particles/rimuru_gluttony.vpcf"
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
	local sound_cast = "rimuru.gluttony"

	EmitSoundOn( sound_cast, self:GetCaster() )

end

--------------------------------------------------------------------------------
-- Projectile
function gluttony:OnProjectileHitHandle( target, location, projectile )
local heal = self:GetSpecialValueFor( "heal" )+ self:GetCaster():FindTalentValue("special_bonus_rimuru_10")
local caster = self:GetCaster()
	if not target then return end

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage() + self:GetCaster():FindTalentValue("special_bonus_rimuru_15"),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	caster:Heal( heal, caster )

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()

	-- play effects

end



modifier_slime = class ({})
function modifier_slime:IsHidden() return true end
function modifier_slime:IsDebuff() return false end
function modifier_slime:IsPurgable() return false end
function modifier_slime:IsPurgeException() return false end
function modifier_slime:RemoveOnDeath() return false end

function modifier_slime:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_slime:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_slime:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_slime:GetModifierBaseAttackTimeConstant()
	return 5.0
end
function modifier_slime:OnIntervalThink()
    if IsServer() then
        local cute_slime = self:GetParent():FindAbilityByName("rimuru_paralysis_gas")
        if cute_slime and not cute_slime:IsNull() then
            if self:GetParent():HasScepter() then
                if cute_slime:IsHidden() then
                    cute_slime:SetHidden(false)
                end
            else
                if not cute_slime:IsHidden() then
                    cute_slime:SetHidden(true)
                end
            end
        end
    end
end

