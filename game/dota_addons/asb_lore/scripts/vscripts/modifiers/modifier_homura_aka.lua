modifier_homura_aka = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_homura_aka:IsHidden()
	return false
end

function modifier_homura_aka:IsDebuff()
	return false
end

function modifier_homura_aka:IsStunDebuff()
	return false
end

function modifier_homura_aka:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_homura_aka:OnCreated( kv )
	-- references
	local count = self:GetAbility():GetSpecialValueFor( "arrow_count" )
	local range = self:GetAbility():GetSpecialValueFor( "arrow_range_multiplier" )
	local width = self:GetAbility():GetSpecialValueFor( "arrow_width" )
	self.speed = self:GetAbility():GetSpecialValueFor( "arrow_speed" )
	-- self.angle = self:GetAbility():GetSpecialValueFor( "arrow_angle" )
	self.angle = 33.33

	if not IsServer() then return end

	-- none provided in kv file. shame on you volvo
	local vision = 100
	local delay = 0.1
	local wave = 4
	local wave_interval = 0.2
	self.arrow_delay = 0.022

	-- calculate stuff
	self.arrows = count/wave
	self.wave_delay = wave_interval - self.arrow_delay*(self.arrows-1)

	-- get projectile main direction
	local point = Vector(kv.x, kv.y, kv.z)
	self.direction = point-self:GetCaster():GetOrigin()
	self.direction.z = 0
	self.direction = self.direction:Normalized()

	-- set states
	self.state = STATE_SALVO
	self.current_arrows = 0
	self.current_wave = 0
	self.frost = false

	-- check frost arrows ability
	

	-- precache projectile
	local caster = self:GetCaster()
	local projectile_name
	
		projectile_name = "particles/test_projectile_1.vpcf"
	

	self.info = {
		Source = caster,
		Ability = self:GetAbility(),
		vSpawnOrigin = caster:GetAttachmentOrigin( caster:ScriptLookupAttachment( "attach_attack1" ) ),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = self:GetAbility():GetAbilityTargetTeam(),
	    iUnitTargetType = self:GetAbility():GetAbilityTargetType(),
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,

	    EffectName = projectile_name,
	    fDistance = caster:Script_GetAttackRange() * range,
	    fStartRadius = self.width,
	    fEndRadius = self.width,
		-- vVelocity = projectile_direction * self.speed,
	
		bProvidesVision = true,
		iVisionRadius = vision,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	-- ProjectileManager:CreateLinearProjectile(info)

	-- Start interval
	self:StartIntervalThink( delay )

	-- play effects
	local sound_cast = "homura.2"
	EmitSoundOn( sound_cast, caster )
end

function modifier_homura_aka:OnRefresh( kv )
end

function modifier_homura_aka:OnRemoved()
end

function modifier_homura_aka:OnDestroy()
	if not IsServer() then return end

	-- stop effects
	local sound_cast = "homura.2"
	StopSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_homura_aka:OnIntervalThink()
	-- count arrows
	if self.current_arrows<self.arrows then

		self:StartIntervalThink( self.arrow_delay )
	else
		self.current_arrows = 0
		self.current_wave = self.current_wave+1

		self:StartIntervalThink( self.wave_delay )
		return
	end

	-- calculate relative angle of current arrow against cast direction
	local step = self.angle/(self.arrows-1)
	local angle = -self.angle/2 + self.current_arrows*step

	-- calculate actual direction
	local projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, angle, 0 ), self.direction )

	-- launch projectile
	self.info.vVelocity = projectile_direction * self.speed
	self.info.ExtraData = {
		arrow = self.current_arrows,
		wave = self.current_wave,
		frost = self.frost,
	}
	ProjectileManager:CreateLinearProjectile(self.info)

	self:PlayEffects()

	self.current_arrows = self.current_arrows+1
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_homura_aka:PlayEffects()
	-- Get Resources
	local sound_cast
	
		sound_cast = ""
	

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
