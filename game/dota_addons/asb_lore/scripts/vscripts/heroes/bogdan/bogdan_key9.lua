bogdan_key9 = class({})
LinkLuaModifier( "modifier_bogdan_key9", "heroes/bogdan/bogdan_key9", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gay_sex", "heroes/bogdan/bogdan_key9", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gachi_overheat", "heroes/bogdan/bogdan_key9", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gachi_start_heat", "heroes/bogdan/bogdan_key9", LUA_MODIFIER_MOTION_NONE )

-- function bogdan_key9:GetIntrinsicModifierName()
--     return "modifier_gay_sex"
-- end
--------------------------------------------------------------------------------
-- Ability Start
function bogdan_key9:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if self:GetCaster():HasScepter() and not caster:HasModifier("modifier_gachi_overheat") then
	if not caster:HasModifier("modifier_gachi_start_heat") then
	caster:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_gachi_start_heat",
		{duration = 1.2}
	)
	end
	self:EndCooldown()
    self:StartCooldown(0.2)
	end
local point = self:GetCursorPosition()
local origin = caster:GetOrigin()
	-- get projectile_data
	if IsASBPatreon(caster) then
		local projectile_name = "particles/bogdan_key9_arcana.vpcf"
		-- load data

	local projectile_speed = self:GetSpecialValueFor("speed")
	local projectile_distance = self:GetSpecialValueFor("range")
	local projectile_start_radius = self:GetSpecialValueFor("width")
	local projectile_end_radius = self:GetSpecialValueFor("width")
	local projectile_vision = 0
	local int_scale =  self:GetSpecialValueFor("int_scale")
	local scale = caster:GetIntellect() * int_scale
self.int = caster:GetIntellect() * scale


	local min_damage = self:GetSpecialValueFor( "damage" ) + self.int
	local max_distance = self:GetSpecialValueFor("range")
	local slow = 0
	local duration = 0


	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()

	-- logic
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),

		ExtraData = {
			originX = origin.x,
			originY = origin.y,
			originZ = origin.z,

			max_distance = max_distance,
			min_stun = duration,
			max_stun = duration,

			min_damage = min_damage,
			bonus_damage = 0,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Effects

	self:PlayEffects1_1()
	else
	local projectile_name = "particles/bogdan_key9.vpcf"
		local projectile_speed = self:GetSpecialValueFor("speed")
	local projectile_distance = self:GetSpecialValueFor("range")
	local projectile_start_radius = self:GetSpecialValueFor("width")
	local projectile_end_radius = self:GetSpecialValueFor("width")
	local projectile_vision = 0
	local int_scale =  self:GetSpecialValueFor("int_scale")
	local scale = caster:GetIntellect() * int_scale
self.int = caster:GetIntellect() * scale


	local min_damage = self:GetSpecialValueFor( "damage" ) + self.int
	local max_distance = self:GetSpecialValueFor("range")
	local slow = 0
	local duration = 0


	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()

	-- logic
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),

		ExtraData = {
			originX = origin.x,
			originY = origin.y,
			originZ = origin.z,

			max_distance = max_distance,
			min_stun = duration,
			max_stun = duration,

			min_damage = min_damage,
			bonus_damage = 0,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Effects

	self:PlayEffects1()
end
end

function bogdan_key9:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	
	

	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_bogdan_key9",
		{duration = 10}
	)
	local caster = self:GetCaster()
if IsASBPatreon(caster) then
	self:PlayEffects2_1( hTarget )
	else
	self:PlayEffects2( hTarget )
	end
	return true
end

--------------------------------------------------------------------------------
function bogdan_key9:PlayEffects1()
	-- Get Resources
	local sound_cast = "bogdan.boy"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function bogdan_key9:PlayEffects1_1()
	-- Get Resources
	local sound_cast = "hurk.cum_1"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function bogdan_key9:PlayEffects2_1()
	-- Get Resources
	local sound_cast = "hurk.cum"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function bogdan_key9:PlayEffects2( target )
	-- Get Resources
	local sound_target = "bogdan.key_hit"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end

  modifier_gachi_overheat = class({})
function modifier_gachi_overheat:IsHidden() return true end
function modifier_gachi_overheat:IsDebuff() return false end
function modifier_gachi_overheat:IsPurgable() return false end
function modifier_gachi_overheat:IsPurgeException() return false end
function modifier_gachi_overheat:RemoveOnDeath() return true end

  modifier_gachi_start_heat = class({})
function modifier_gachi_start_heat:IsHidden() return true end
function modifier_gachi_start_heat:IsDebuff() return false end
function modifier_gachi_start_heat:IsPurgable() return false end
function modifier_gachi_start_heat:IsPurgeException() return false end
function modifier_gachi_start_heat:RemoveOnDeath() return true end
function modifier_gachi_start_heat:OnCreated() 
 if IsServer() then
local ability = self:GetParent():FindAbilityByName("bogdan_key9")
ability:EndCooldown()
end
 end
function modifier_gachi_start_heat:OnDestroy() 
 if IsServer() then
local ability = self:GetParent():FindAbilityByName("bogdan_key9")
ability:StartCooldown(ability:GetCooldown(-1))
 end
 end

modifier_gay_sex = class ({})
function modifier_gay_sex:IsHidden() return true end
function modifier_gay_sex:IsDebuff() return false end
function modifier_gay_sex:IsPurgable() return false end
function modifier_gay_sex:IsPurgeException() return false end
function modifier_gay_sex:RemoveOnDeath() return false end

function modifier_gay_sex:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_gay_sex:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_gay_sex:OnIntervalThink()
    if IsServer() then
        local sosonido = self:GetParent():FindAbilityByName("unlimited_gay_works")
        if sosonido and not sosonido:IsNull() then
            if self:GetParent():HasScepter() and not self:GetParent():HasModifier("modifier_unlimited_gay_works") then
                if sosonido:IsHidden() then
                    sosonido:SetHidden(false)
                end
            else
                if not sosonido:IsHidden() then
                    sosonido:SetHidden(true)
                end
            end
        end
          local sosonido2 = self:GetParent():FindAbilityByName("gachi_storm")
        if sosonido2 and not sosonido2:IsNull() then
            if self:GetParent():HasScepter() and self:GetParent():HasModifier("modifier_unlimited_gay_works") then
                if sosonido2:IsHidden() then
                    sosonido2:SetHidden(false)
                end
            else
                if not sosonido2:IsHidden() then
                    sosonido2:SetHidden(true)
                end
            end
        end
		end
end















modifier_bogdan_key9 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bogdan_key9:IsHidden()
	return false
end
function modifier_bogdan_key9:OnCreated()
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

end

function modifier_bogdan_key9:IsDebuff()
	return true
end

function modifier_bogdan_key9:IsStunDebuff()
	return false
end

function modifier_bogdan_key9:IsPurgable()
	return true
end

function modifier_bogdan_key9:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------


function modifier_bogdan_key9:OnRefresh( kv )
	
end

function modifier_bogdan_key9:OnRemoved()
end

function modifier_bogdan_key9:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_bogdan_key9:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_bogdan_key9:GetEffectName()
	return "particles/hurk_cum1.vpcf"
end

function modifier_bogdan_key9:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end