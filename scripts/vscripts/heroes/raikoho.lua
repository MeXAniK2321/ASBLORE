raikoho = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gonryu_tenmeits", "heroes/raikoho.lua", LUA_MODIFIER_MOTION_NONE )
function raikoho:GetIntrinsicModifierName()
    return "modifier_gonryu_tenmeits"
end
function raikoho:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("hado_99")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function raikoho:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	-- unit target just indicates point
	if target then point = target:GetOrigin() end

	local value1 = self:GetSpecialValueFor("some_value")
	
	-- load projectile
	local projectile_name = "particles/raikoho.vpcf"
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
	local sound_cast = "aizen.1"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function raikoho:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_aizen_25")
	local duration = self:GetSpecialValueFor( "duration" )

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
end
modifier_gonryu_tenmeits = class ({})
function modifier_gonryu_tenmeits:IsHidden() return true end
function modifier_gonryu_tenmeits:IsDebuff() return false end
function modifier_gonryu_tenmeits:IsPurgable() return false end
function modifier_gonryu_tenmeits:IsPurgeException() return false end
function modifier_gonryu_tenmeits:RemoveOnDeath() return false end

function modifier_gonryu_tenmeits:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_gonryu_tenmeits:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_gonryu_tenmeits:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_gonryu_tenmeits:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_gonryu_tenmeits:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("hado_99")
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
