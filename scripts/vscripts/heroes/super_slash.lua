super_slash = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dignity", "heroes/super_slash.lua", LUA_MODIFIER_MOTION_NONE )
function super_slash:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("escanor_fear")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function super_slash:GetIntrinsicModifierName()
    return "modifier_dignity"
end
function super_slash:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	-- unit target just indicates point


	local value1 = self:GetSpecialValueFor("some_value")
	
	-- load projectile
	local projectile_name = "particles/super_slash.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "range" )
	local projectile_start_radius = self:GetSpecialValueFor( "start_radius" )
	local projectile_end_radius = self:GetSpecialValueFor( "end_radius" )
	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local projectile_direction = point - caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}
	ProjectileManager:CreateLinearProjectile(info)

	-- play effects
	local sound_cast = "escanor.1"
	EmitSoundOn( sound_cast, caster )
	
end
--------------------------------------------------------------------------------
-- Projectile
function super_slash:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_escanor_20")
	local duration = self:GetSpecialValueFor( "duration" )
	local caster = self:GetCaster()

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- debuff
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_slow", -- modifier name
		{ duration = duration } -- kv
	)
	local sound_cast = "escanor.1_1"
	EmitSoundOn( sound_cast, caster )
end
modifier_dignity = class ({})
function modifier_dignity:IsHidden() return true end
function modifier_dignity:IsDebuff() return false end
function modifier_dignity:IsPurgable() return false end
function modifier_dignity:IsPurgeException() return false end
function modifier_dignity:RemoveOnDeath() return false end

function modifier_dignity:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_dignity:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_dignity:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_dignity:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_dignity:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("exploding_dignity")
        if vongolle and not vongolle:IsNull() then
            if self:GetParent():HasScepter() then
                if vongolle:IsHidden() then
                    vongolle:SetHidden(false)
                end
            else
                if not vongolle:IsHidden() then
                    vongolle:SetHidden(true)
                end
            end
        end
    end
end
