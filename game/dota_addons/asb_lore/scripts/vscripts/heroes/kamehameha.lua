kamehameha = class({})


--------------------------------------------------------------------------------
-- Ability Start
function kamehameha:GetAbilityTextureName()
 
	if self:GetCaster():HasModifier("modifier_super_saiyan4") then
		return "goku_1_1"
	
	else return "goku_1"
	end
end
function kamehameha:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)
	self.parent = self:GetCaster()

	-- Play effects
	local sound_cast = "goku.1"
	if IsASBPatreon(caster) then
	 self.particle_time =    ParticleManager:CreateParticle("particles/drip_kamehameha_hands.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "kamehameha", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
	else
	if IsServer() then
	
			   self.particle_time =    ParticleManager:CreateParticle("particles/goku_kamehameha.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "kamehameha", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
						
			end
			end
			
	EmitSoundOnLocationForAllies( caster:GetOrigin(), sound_cast, caster )
	if self:GetCaster():HasModifier("modifier_super_saiyan4") or self:GetCaster():HasModifier("modifier_ultra_instinct")  then
	self.particle_time2=    ParticleManager:CreateParticle("particles/super_saiyan_kamehameha.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "kamehameha", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
						
			end
			end
	



--------------------------------------------------------------------------------
-- Ability Channeling
function kamehameha:OnChannelFinish( bInterrupted )
	-- unit identifier
	if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") and self:GetCaster():HasModifier("modifier_super_saiyan4") or self:GetCaster():HasModifier("modifier_ultra_instinct") then
	local caster = self:GetCaster()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	-- load data
	local damage = self:GetSpecialValueFor( "powershot_damage3") + self:GetCaster():FindTalentValue("special_bonus_goku_20")
	local reduction = 1-self:GetSpecialValueFor( "damage_reduction" )
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	if IsASBPatreon(caster) then
	self.projectile_name = "particles/ss_blue_drip_kamehameha.vpcf"
	else
	self.projectile_name = "particles/ss_blue_kamehameha.vpcf"
	end
	
	local projectile_speed = self:GetSpecialValueFor( "arrow_speed" )
	local projectile_distance = self:GetSpecialValueFor( "arrow_range" )
	local projectile_radius = self:GetSpecialValueFor( "arrow_width" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = self.projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	-- register projectile data
	self.projectiles[projectile] = {}
	self.projectiles[projectile].damage = damage*channel_pct
	self.projectiles[projectile].reduction = reduction
	local caster = self:GetCaster()
	StopSoundOn("goku.1", caster)
	EmitSoundOn("goku.1_1", caster)
	ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

	-- Play effects
	elseif self:GetCaster():HasModifier("modifier_super_saiyan4") then
	local caster = self:GetCaster()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	-- load data
	local damage = self:GetSpecialValueFor( "powershot_damage2") + self:GetCaster():FindTalentValue("special_bonus_goku_20")
	local reduction = 1-self:GetSpecialValueFor( "damage_reduction" )
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	if IsASBPatreon(caster) then
	self.projectile_name = "particles/super_saiyan_drip_kamehameha_blast.vpcf"
	else
	self.projectile_name = "particles/super_saiyan_kamehameha_blast.vpcf"
	end
	local projectile_speed = self:GetSpecialValueFor( "arrow_speed" )
	local projectile_distance = self:GetSpecialValueFor( "arrow_range" )
	local projectile_radius = self:GetSpecialValueFor( "arrow_width" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = self.projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	-- register projectile data
	self.projectiles[projectile] = {}
	self.projectiles[projectile].damage = damage*channel_pct
	self.projectiles[projectile].reduction = reduction
	local caster = self:GetCaster()
	StopSoundOn("goku.1", caster)
	EmitSoundOn("goku.1_1", caster)
	ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

	-- Play effects
	
		else
		local caster = self:GetCaster()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	-- load data
	local damage = self:GetSpecialValueFor( "powershot_damage" ) + self:GetCaster():FindTalentValue("special_bonus_goku_20")
	local reduction = 1-self:GetSpecialValueFor( "damage_reduction" )
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
		if IsASBPatreon(caster) then
	self.projectile_name = "particles/kamehameha_drip.vpcf"
	else
	self.projectile_name = "particles/kamehameha.vpcf"
	end
	local projectile_speed = self:GetSpecialValueFor( "arrow_speed" )
	local projectile_distance = self:GetSpecialValueFor( "arrow_range" )
	local projectile_radius = self:GetSpecialValueFor( "arrow_width" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = self.projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	-- register projectile data
	self.projectiles[projectile] = {}
	self.projectiles[projectile].damage = damage*channel_pct
	self.projectiles[projectile].reduction = reduction

	-- Play effects


    local caster = self:GetCaster()
	StopSoundOn("goku.1", caster)
	EmitSoundOn("goku.1_1", caster)
	ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		
end
end


--------------------------------------------------------------------------------
-- Projectile
-- projectile data table
kamehameha.projectiles = {}

function kamehameha:OnProjectileHitHandle( target, location, handle )
	if not target then
		-- unregister projectile
		self.projectiles[handle] = nil

		-- create Vision
		local vision_radius = self:GetSpecialValueFor( "vision_radius" )
		local vision_duration = self:GetSpecialValueFor( "vision_duration" )
		AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, false )

		return
	end

	-- get data
	local data = self.projectiles[handle]

	
	
	local damage = data.damage
	

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- reduce damage
	
	
	
	data.damage = damage 
	

	-- Play effects
	local sound_cast = ""
	EmitSoundOn( sound_cast, target )
end

function kamehameha:OnProjectileThink( location )
	
end