dante_drive = class({})
LinkLuaModifier( "modifier_dante_debil", "heroes/dante", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dante_stinger_combo", "heroes/dante", LUA_MODIFIER_MOTION_NONE )


function dante_drive:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dante_pistols_charge")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function dante_drive:GetIntrinsicModifierName()
    return "modifier_dante_debil"
end
function dante_drive:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	if target then
		point = target:GetOrigin()
	end

 caster:AddNewModifier(caster, self, "modifier_dante_stinger_combo", {duration = 1})
	local projectile_name = "particles/dante_drive.vpcf"
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
	local sound_cast = "dante.1"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Projectile
function dante_drive:OnProjectileHitHandle( target, location, projectile )
	if not target then return end
	local damage = self:GetSpecialValueFor( "damage" )+ self:GetCaster():FindTalentValue("special_bonus_dante_20")
	
	

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()
    
	-- play effects
	self:PlayEffects( target, direction )
end

--------------------------------------------------------------------------------
function dante_drive:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_dante_debil = class ({})
function modifier_dante_debil:IsHidden() return true end
function modifier_dante_debil:IsDebuff() return false end
function modifier_dante_debil:IsPurgable() return false end
function modifier_dante_debil:IsPurgeException() return false end
function modifier_dante_debil:RemoveOnDeath() return false end

function modifier_dante_debil:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_dante_debil:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_dante_debil:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("dante_striptiz")
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
modifier_dante_stinger_combo = class({})


function modifier_dante_stinger_combo:IsHidden()
    return true
end
function modifier_dante_stinger_combo:RemoveOnDeath() return true end
function modifier_dante_stinger_combo:IsPurgable()
    return false
end

dante_stinger = class({})
LinkLuaModifier("modifier_dante_stinger_dash", "heroes/dante", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dante_stinger", "heroes/dante", LUA_MODIFIER_MOTION_NONE)

function dante_stinger:IsStealable() return true end
function dante_stinger:IsHiddenWhenStolen() return false end
function dante_stinger:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dante_range")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function dante_stinger:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function dante_stinger:OnSpellStart()
	local caster = self:GetCaster()
    EmitSoundOn("dante.2_1", caster)
	caster:AddNewModifier(caster, self, "modifier_dante_stinger_dash", {})
end
---------------------------------------------------------------------------------------------------------------------
modifier_dante_stinger_dash = class({})
function modifier_dante_stinger_dash:IsHidden() return true end
function modifier_dante_stinger_dash:IsDebuff() return false end
function modifier_dante_stinger_dash:IsPurgable() return false end
function modifier_dante_stinger_dash:IsPurgeException() return false end
function modifier_dante_stinger_dash:RemoveOnDeath() return true end
function modifier_dante_stinger_dash:GetMotionControllerPriority() 
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM 
end
function modifier_dante_stinger_dash:CheckState()
	if IsServer() then
		if self:GetParent() then
			state = {	[MODIFIER_STATE_STUNNED] = true,
						[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
						[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
						[MODIFIER_STATE_INVULNERABLE] = true,
						[MODIFIER_STATE_NO_HEALTH_BAR] = true,
						[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
						}
		else
			state = {	[MODIFIER_STATE_STUNNED] = true,
						[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
						[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
		end
		return state
	end
end
function modifier_dante_stinger_dash:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,}
	return func
end
function modifier_dante_stinger_dash:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_7
end
function modifier_dante_stinger_dash:OnIntervalThink()
	if IsServer() then
		self:HorizontalMotion(self:GetParent(), self.interval)
	end
end
function modifier_dante_stinger_dash:HorizontalMotion(unit, time)
	if IsServer() then
		self.time = self.time + time
		if self.time < self.dash_time then
			local location = unit:GetAbsOrigin() + self.direction * self.speed * time
			unit:SetAbsOrigin(location)
			--FindClearSpaceForUnit(unit, location, true)        
		else
		    self:Destroy()
			unit:AddNewModifier(unit, self:GetAbility(), "modifier_dante_stinger", {})
			
		end
	end 
end
function modifier_dante_stinger_dash:OnCreated()
	if IsServer() then
		self.time = 0
		self.speed = self:GetAbility():GetSpecialValueFor("speed")
		self.point = self:GetAbility():GetCursorPosition()
		self.distance = (self:GetParent():GetAbsOrigin() - self.point):Length2D()
		self.dash_time = self.distance/self.speed
		self.direction = (self.point - self:GetParent():GetAbsOrigin()):Normalized()

		self.interval = FrameTime()
		self:StartIntervalThink(self.interval)
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_dante_stinger = class({})
function modifier_dante_stinger:IsHidden() return true end
function modifier_dante_stinger:IsDebuff() return false end
function modifier_dante_stinger:IsPurgable() return false end
function modifier_dante_stinger:IsPurgeException() return false end
function modifier_dante_stinger:RemoveOnDeath() return true end
function modifier_dante_stinger:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,}
	return func
end
function modifier_dante_stinger:CheckState()
	local state = {	[MODIFIER_STATE_STUNNED] = true,}
	return state
end
function modifier_dante_stinger:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end
function modifier_dante_stinger:OnCreated()
	if IsServer() then
		self.attacks = self:GetAbility():GetSpecialValueFor("attacks")
		self.distance = self:GetAbility():GetSpecialValueFor("distance")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.width = self:GetAbility():GetSpecialValueFor("width")

		self.i = 0

		self:StartIntervalThink(self.interval)
	end
end
function modifier_dante_stinger:OnIntervalThink()
	if IsServer() then
		self.i = self.i + 1
		if self.i >= self.attacks then
			self:Destroy()
		end
		
		

		local particle =   	ParticleManager:CreateParticle("particles/dante_stinger_crit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			            	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())

		local enemies = FindUnitsInLine(self:GetParent():GetTeamNumber(),
										self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 150,
										self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * self.distance,
										nil,
										self.width,
										self:GetAbility():GetAbilityTargetTeam(),
										self:GetAbility():GetAbilityTargetType(),
										self:GetAbility():GetAbilityTargetFlags() )

		for _,enemy in pairs(enemies) do
			if not enemy:IsAttackImmune() then
				local damage_table = {	victim = enemy,
										attacker = self:GetParent(),
										damage = self:GetAbility():GetSpecialValueFor("damage")+ self:GetCaster():FindTalentValue("special_bonus_dante_25"),
										damage_type = self:GetAbility():GetAbilityDamageType(),
										ability = self:GetAbility() }	

				if self.i <= self.attacks - 1 then
					

					damage_table.damage = damage_table.damage * (self.attacks - 1)
				end

				ApplyDamage(damage_table)

				
			end
		end
	end
end

LinkLuaModifier("modifier_dante_style", "heroes/dante", LUA_MODIFIER_MOTION_NONE)

dante_style = class({})

function dante_style:IsStealable() return true end
function dante_style:IsHiddenWhenStolen() return false end
function dante_style:GetIntrinsicModifierName()
	return "modifier_dante_style"
end
function dante_style:GetAbilityTextureName()
	local caster = self:GetCaster()
	local stacks = caster:GetModifierStackCount("modifier_dante_style", caster)
	if stacks == 3 then
		return "dante/dante_3_2"
	elseif stacks == 1 then
		return "dante/dante_3_3"
		elseif stacks == 2 then
		return "dante/dante_3_4"
	end

	return self.BaseClass.GetAbilityTextureName(self)
end
function dante_style:OnSpellStart()
	local caster = self:GetCaster()
	local style = caster:FindModifierByNameAndCaster("modifier_dante_style", caster)
	if style and not style:IsNull() then
		local stacks = style:GetStackCount()
		if stacks >= 3 then
			style:SetStackCount(0)
		else
			style:IncrementStackCount()
		end

			if stacks == 1 then
			EmitSoundOn("dante.3_4", caster)
			
			elseif stacks == 2 then
			EmitSoundOn("dante.3_2", caster)
			
				elseif stacks == 3 then
				EmitSoundOn("dante.3_1", caster)
				
			end
			
			if stacks == 0 then 
			EmitSoundOn("dante.3_3", caster)
			end

			

			
		end
	end
---------------------------------------------------------------------------------------------------------------------
modifier_dante_style = class({})
function modifier_dante_style:IsHidden() return true end
function modifier_dante_style:IsDebuff() return false end
function modifier_dante_style:IsPurgable() return false end
function modifier_dante_style:IsPurgeException() return false end
function modifier_dante_style:RemoveOnDeath() return false end
function modifier_dante_style:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

					MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

					MODIFIER_PROPERTY_EVASION_CONSTANT,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					}
	return func
end
function modifier_dante_style:GetModifierPreAttack_BonusDamage()
	if self.parent:PassivesDisabled() or self:GetStackCount() ~= 1 then
		return nil
	end

	return self.attack
end
function modifier_dante_style:GetModifierAttackSpeedBonus_Constant()
	if self.parent:PassivesDisabled() or self:GetStackCount() ~= 0 then
		return nil
	end

	return self.as
end
function modifier_dante_style:GetModifierEvasion_Constant()
	if self.parent:PassivesDisabled() or self:GetStackCount() ~= 3 then
		return nil
	end

	return self.ev
end
function modifier_dante_style:GetModifierPhysicalArmorBonus()
	if self.parent:PassivesDisabled() or self:GetStackCount() ~= 2 then
		return nil
	end

	return self.ms
end
function modifier_dante_style:OnStackCountChanged(iStackCount)
	if IsServer() then
		self:ForceRefresh()

		if self.Charge_FX then
			ParticleManager:DestroyParticle(self.Charge_FX, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX)
		end

		if self.Charge_FX2 then
			ParticleManager:DestroyParticle(self.Charge_FX2, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX2)
		end
		

		local stacks = self:GetStackCount()

		if stacks == 0 then
			self.Charge_FX =   	ParticleManager:CreateParticle("particles/dante_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
								ParticleManager:SetParticleControl(self.Charge_FX, 0, self.parent:GetAbsOrigin())
	                            ParticleManager:SetParticleControlEnt(  self.Charge_FX,
	                                                                    0,
	                                                                    self.parent,
	                                                                    PATTACH_POINT_FOLLOW,
	                                                                    "attach_sword",
	                                                                    Vector(0,0,0),
	                                                                    true)
																		self.Charge_FX2 =  	ParticleManager:CreateParticle("particles/dante_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX2,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attach_sword2",
                                                                    	Vector(0,0,0),
                                                                    	true)
																		
	     elseif stacks == 3 then
	  		self.Charge_FX =   	ParticleManager:CreateParticle("particles/dante_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attach_hands",
                                                                    	Vector(0,0,0),
                                                                    	true)
	self.Charge_FX2 =  	ParticleManager:CreateParticle("particles/dante_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX2,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attach_hand2",
                                                                    	Vector(0,0,0),
                                                                    	true)																			
		elseif stacks == 1 then
	  		self.Charge_FX =   	ParticleManager:CreateParticle("particles/dante_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attach_leg",
                                                                    	Vector(0,0,0),
                                                                    	true)
		self.Charge_FX2 =  	ParticleManager:CreateParticle("particles/dante_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX2,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attach_leg2",
                                                                    	Vector(0,0,0),
                                                                    	true)																
																		

	  		

		else
	  		self.Charge_FX =   	ParticleManager:CreateParticle("particles/dante_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attach_body",
                                                                    	Vector(0,0,0),
                                                                    	true)

	  			
        end
	end
end
function modifier_dante_style:OnCreated(hTable)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()


	self.attack = self.ability:GetSpecialValueFor("attack")
	self.ev = self.ability:GetSpecialValueFor("evasion")
	self.as = self.ability:GetSpecialValueFor("as")
	self.ms = self.ability:GetSpecialValueFor("armor")

	if IsServer() then
		if not self.first_learned then
			self.first_learned = true
			
			self:SetStackCount(0)
		end
	end
end
function modifier_dante_style:OnRefresh(hTable)
	self:OnCreated(hTable)
end


















LinkLuaModifier("modifier_dante_range", "heroes/dante", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dante_range", "heroes/dante", LUA_MODIFIER_MOTION_NONE)
dante_range = class({})

function dante_range:IsStealable() return true end
function dante_range:IsHiddenWhenStolen() return false end

function dante_range:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dante_blink")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function dante_range:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("duration")
	
    caster:AddNewModifier(caster, self, "modifier_dante_range", {duration = fixed_duration})
 
end
---------------------------------------------------------------------------------------------------------------------
modifier_dante_range = class({})
function modifier_dante_range:IsHidden() return false end
function modifier_dante_range:IsDebuff() return true end
function modifier_dante_range:IsPurgable() return false end
function modifier_dante_range:IsPurgeException() return false end
function modifier_dante_range:RemoveOnDeath() return true end
function modifier_dante_range:AllowIllusionDuplicate() return true end
function modifier_dante_range:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,	              
							MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
				}
    return func
end
function modifier_dante_range:GetModifierModelChange()

	return "models/dante/donte_no_sword.vmdl"
	
	end
	function modifier_dante_range:GetModifierAttackSpeedBonus_Constant()
	return 100
end
function modifier_dante_range:GetModifierModelScale()
	return 1
end
function modifier_dante_range:GetAttackSound()
	return "dante.range"
end

function modifier_dante_range:GetModifierProjectileName()
	return "particles/units/heroes/hero_snapfire/hero_snapfire_base_attack.vpcf"
end
function modifier_dante_range:GetModifierProjectileSpeedBonus()
	return 800
end
function modifier_dante_range:GetModifierAttackRangeBonus()
	return 400
end
function modifier_dante_range:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- decrement stack
		self:DecrementStackCount()

		-- destroy if reach zero
		if self:GetStackCount() < 1 then
			self:Destroy()
		end
	end
end

function modifier_dante_range:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()
	self.parent:SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )

    self.shots = self.ability:GetSpecialValueFor("shots")

  

  
     
	
local HiddenAbilities = 
	{
	
		"dante_style",
		"dante_bicycle_ride",
		"dante_sin_devil_trigger",
		"dante_stinger",
		"dante_drive",

		
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end
        
		
        local delay = 0.01
			Timers:CreateTimer(delay,function()
        self:PlayEffects1()
		self:PlayEffects()
		end)
self:SetStackCount(self.shots)

    end

function modifier_dante_range:PlayEffects()
		-- Get Resources
	
	


	self.pistol_fx = 	ParticleManager:CreateParticle("particles/dante_pistol.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.pistol_fx, 0, self:GetCaster(), 5, "attach_hands", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.pistol_fx, 1, self:GetCaster(), 5, "attach_hands", Vector(0,0,0), true)
     

	-- buff particle
	

	-- Emit sound
	
end
function modifier_dante_range:PlayEffects1()
		-- Get Resources
	
	


	self.pistol_fx2 = 	ParticleManager:CreateParticle("particles/dante_pistol2.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.pistol_fx2, 0, self:GetCaster(), 5, "attach_hand2", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.pistol_fx2, 1, self:GetCaster(), 5, "attach_hand2", Vector(0,0,0), true)
     

	

	
	
end
function modifier_dante_range:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_dante_range:OnDestroy()
    if IsServer() then
        
			self.parent:SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )

          if self.pistol_fx then
	    ParticleManager:DestroyParticle(self.pistol_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.pistol_fx)
		ParticleManager:DestroyParticle(self.pistol_fx2, false)
	    ParticleManager:ReleaseParticleIndex(self.pistol_fx2)
		end
			self.parent:RemoveModifierByName("modifier_dante_pistols_charge")
 local hideit = 
	{
	
		"dante_style",
		"dante_bicycle_ride",
		"dante_sin_devil_trigger",
		"dante_stinger",
			"dante_drive",
		
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
           
                end
            end
        
   
   LinkLuaModifier("modifier_dante_pistols_charge", "heroes/dante", LUA_MODIFIER_MOTION_NONE)
   LinkLuaModifier("modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE)
dante_pistols_charge = class({})

function dante_pistols_charge:IsStealable() return true end
function dante_pistols_charge:IsHiddenWhenStolen() return false end


function dante_pistols_charge:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("duration")
	
    caster:AddNewModifier(caster, self, "modifier_dante_pistols_charge", {duration = fixed_duration})
	caster:EmitSound("dante.2_2")
 
end

modifier_dante_pistols_charge = class({})

--------------------------------------------------------------------------------

function modifier_dante_pistols_charge:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_dante_pistols_charge:OnCreated( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor("damage")
	self.max_attacks = self:GetAbility():GetSpecialValueFor("hits")

	-- Increase stack

	if IsServer() then
		self:SetStackCount(self.max_attacks)

		
	end
end

function modifier_dante_pistols_charge:OnRefresh( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor("damage")
	self.max_attacks = self:GetAbility():GetSpecialValueFor("hits")

	-- Increase stack
	
end


--------------------------------------------------------------------------------

function modifier_dante_pistols_charge:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function modifier_dante_pistols_charge:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.5 })
			local damageTable = {
		attacker = self:GetParent(),
		damage = self.bonus,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		self:Destroy()
		
			end
		end
	end
	end
	function modifier_dante_pistols_charge:GetEffectName()
	return "particles/rimuru_harvest_aura_test1.vpcf"
end
function modifier_dante_pistols_charge:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

dante_blink = class({})


function dante_blink:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("royal_guard")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function dante_blink:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local damage =  self:GetSpecialValueFor("damage")
	local origin = caster:GetOrigin()
	  if not IsServer() then return nil end
    local caster = self:GetCaster()
	local max_range = self:GetSpecialValueFor("blink_range")
	local direction = (point - origin)
	if direction:Length2D() > max_range then
		direction = direction:Normalized() * max_range
	end
	FindClearSpaceForUnit( caster, origin + direction, true )
	local radius = self:GetSpecialValueFor("radius")
	
	local duration = self:GetSpecialValueFor("duration")
	if caster:HasModifier("modifier_dante_stinger_combo") then
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
	local knockback = { should_stun = 1,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 0,
                        knockback_height = 300,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
		
	end
	self:PlayEffects2( origin, direction )
	else
	self:PlayEffects( origin, direction )
	end
end

--------------------------------------------------------------------------------
function dante_blink:PlayEffects( origin, direction )
	-- Get Resources
	local particle_cast_a = "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf"
	local sound_cast_a = "dante.2_3"


	

	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	-- At original position
	

end
 function dante_blink:PlayEffects2( origin, direction )
	-- Get Resources
	local particle_cast_a = "particles/dante_crit_combo.vpcf"
	local sound_cast_a = "dante.2_4_1"


	

	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	-- At original position
	

end
LinkLuaModifier("modifier_royal_guard",  "heroes/dante", LUA_MODIFIER_MOTION_NONE)

royal_guard = class({})

function royal_guard:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("style_open")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function royal_guard:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function royal_guard:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("dante.2_4")
    caster:AddNewModifier(caster, self, "modifier_royal_guard", { duration = duration } )
end

function royal_guard:OnChannelFinish( bInterrupted )
	self:GetCaster():RemoveModifierByName("modifier_royal_guard")
end


modifier_royal_guard = class({})

function modifier_royal_guard:GetEffectName()
	return "particles/dante_royal_guard.vpcf"
end
function modifier_royal_guard:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_royal_guard:OnCreated()
    if not IsServer() then return end
    self.carapaced_units = {}
    self.caster_stun = true
end
function modifier_royal_guard:OnDestroy()
local caster = self:GetParent()
    if self:GetParent():HasModifier("modifier_dante_uebok") then
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = 1000,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = 1 } -- kv
		)
		 EmitSoundOn("dante.2_4_1", caster)
		
	end
	self:PlayEffects(500)
	else
	end
end
function modifier_royal_guard:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end
function modifier_royal_guard:GetOverrideAnimation( params )
	return ACT_DOTA_CHANNEL_ABILITY_3
end
function modifier_royal_guard:GetModifierIncomingDamage_Percentage( params )
	

		return -100
	end
function modifier_royal_guard:GetModifierModelChange()
 if self:GetParent():HasModifier("modifier_dante_range") then
 return end
	return "models/dante/donte_no_sword.vmdl"
	
	end
function modifier_royal_guard:GetModifierModelScale()
	return 1
end

function modifier_royal_guard:PlayEffects( radius )

	local particle_cast = "particles/royal_guard_exp.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


LinkLuaModifier("modifier_dante_bicycle_ride", "heroes/dante", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dante_bicycle_ride_damage", "heroes/dante", LUA_MODIFIER_MOTION_NONE)

dante_bicycle_ride = class({})




function dante_bicycle_ride:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_dante_bicycle_ride") then
		return "dante/dante_4_1"
	end
	return "dante/dante_4"
end

function dante_bicycle_ride:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
	if self:GetCaster():HasModifier("modifier_dante_bicycle_ride") then
		local radius = 350
	local duration = 1.5
	local damage = 1000

	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = duration  } -- kv
		)
		
	end

	self:PlayEffects( radius )
	caster:RemoveModifierByName("modifier_dante_bicycle_ride")
	else
	  caster:EmitSound("dante.4")
	caster:EmitSound("dante.4_1")
    caster:AddNewModifier(caster, self, "modifier_dante_bicycle_ride", { duration = duration} )
	self:EndCooldown()
	

	
	end
end
function dante_bicycle_ride:PlayEffects( radius )
	local particle_cast = "particles/dante_bicycle_explosion.vpcf"
	local sound_cast = "dante.bicycle_exp"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
modifier_dante_bicycle_ride = class({})
function modifier_dante_bicycle_ride:IsHidden() return false end
function modifier_dante_bicycle_ride:IsDebuff() return false end
function modifier_dante_bicycle_ride:IsPurgable() return false end
function modifier_dante_bicycle_ride:RemoveOnDeath() return true end
function modifier_dante_bicycle_ride:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor('damage')
	self.radius = 350

	if not IsServer() then return end
	local interval = 1 
	self.owner = kv.isProvidedByAura~=1

	if not self.owner then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
		--Optional.
	}

	-- Start interval
	self:StartIntervalThink( 0.1 )
	local delay = 0.1
	Timers:CreateTimer(delay,function()
	self.launcher_charge_fx = 	ParticleManager:CreateParticle("particles/bicycle.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 0, self:GetCaster(), 5, "attach_bicycle", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 1, self:GetCaster(), 5, "attach_bicycle", Vector(0,0,0), true)
								end)
								
								
								local HiddenAbilities = 
	{
	
		"dante_drive",
		"dante_stinger",
		"dante_style",
		"dante_range",
		"dante_pistols_charge",
		"dante_blink",
		"royal_guard",
		"dante_sin_devil_trigger",
		"dante_striptiz",
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end
	
end
function modifier_dante_bicycle_ride:OnDestroy( )
if self.launcher_charge_fx then
	    ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
	end
 self.ability = self:GetAbility()
 self.ability:EndCooldown()
 self.ability:StartCooldown(self.ability:GetCooldown(-1) * self:GetParent():GetCooldownReduction())
 
  local hideit = 
	{
	
		"dante_drive",
		"dante_stinger",
		"dante_style",
		"dante_range",
		"dante_pistols_charge",
		"dante_blink",
		"royal_guard",
		"dante_sin_devil_trigger",
		"dante_striptiz",
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
end
function modifier_dante_bicycle_ride:OnIntervalThink()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
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
	
		-- apply damage
		if enemy:HasModifier("modifier_dante_bicycle_ride_damage") then
		else
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_dante_bicycle_ride_damage", -- modifier name
		{ duration = 2  } -- kv
	)
	end

		-- play effects
		
	end
end
function modifier_dante_bicycle_ride:CheckState()
	local state = {

		[MODIFIER_STATE_DISARMED] = true,
		
	}

	return state
end
function modifier_dante_bicycle_ride:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
					MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
			
	}

	return funcs
end
function modifier_dante_bicycle_ride:GetOverrideAnimation( params )
	return ACT_DOTA_CHANNEL_ABILITY_4
end
function modifier_dante_bicycle_ride:GetModifierTurnRate_Percentage()
	return -50
end
	function modifier_dante_bicycle_ride:GetModifierModelChange()

	return "models/dante/donte_no_sword.vmdl"
	
	end
function modifier_dante_bicycle_ride:GetModifierModelScale()
	return 1
end

function modifier_dante_bicycle_ride:GetModifierMoveSpeed_AbsoluteMin()
	 return self:GetAbility():GetSpecialValueFor('bonus_movement_speed')
end



modifier_dante_bicycle_ride_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dante_bicycle_ride_damage:IsHidden()
	return false
end

function modifier_dante_bicycle_ride_damage:IsDebuff()
	return true
end

function modifier_dante_bicycle_ride_damage:IsStunDebuff()
	return false
end

function modifier_dante_bicycle_ride_damage:IsPurgable()
	return true
end

function modifier_dante_bicycle_ride_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dante_bicycle_ride_damage:OnCreated( kv )
	-- references

	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 

self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self, --Optional.
		}
		ApplyDamage( self.damageTable )

	self:GetCaster():PerformAttack(
				self:GetParent(),
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)


	-- play effects
	local sound_cast = "dante.bom"
	EmitSoundOn( sound_cast, self:GetParent() )
end



LinkLuaModifier("modifier_dante_sin_devil_trigger", "heroes/dante", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
dante_sin_devil_trigger = class({})

function dante_sin_devil_trigger:IsStealable() return true end
function dante_sin_devil_trigger:IsHiddenWhenStolen() return false end

function dante_sin_devil_trigger:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dante_judgment")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function dante_sin_devil_trigger:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function dante_sin_devil_trigger:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_dante_sin_devil_trigger", {duration = fixed_duration})
    caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
    self:EndCooldown()
    radius = 600
    self:PlayEffects(radius)
end
function dante_sin_devil_trigger:PlayEffects( radius )

	local particle_cast = "particles/dante_sin_devil_trigger_activate.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_dante_sin_devil_trigger = class({})
function modifier_dante_sin_devil_trigger:IsHidden() return false end
function modifier_dante_sin_devil_trigger:IsDebuff() return true end
function modifier_dante_sin_devil_trigger:IsPurgable() return false end
function modifier_dante_sin_devil_trigger:IsPurgeException() return false end
function modifier_dante_sin_devil_trigger:RemoveOnDeath() return true end
function modifier_dante_sin_devil_trigger:AllowIllusionDuplicate() return true end
function modifier_dante_sin_devil_trigger:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("dante_sin_devil_trigger_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_dante_sin_devil_trigger:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end
function modifier_dante_sin_devil_trigger:GetModifierModelChange()
    return "models/dante/dante_sin_trigger/dante_sin_tr.vmdl"
end
function modifier_dante_sin_devil_trigger:GetModifierModelScale()
	return -30
end
function modifier_dante_sin_devil_trigger:GetModifierBonusStats_Strength()
    return 85
end
function modifier_dante_sin_devil_trigger:GetModifierBonusStats_Agility()

    return 50
	
end
function modifier_dante_sin_devil_trigger:GetModifierPreAttack_BonusDamage()
    return 300
end

function modifier_dante_sin_devil_trigger:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {                          
                            ["dante_sin_devil_trigger"] = "dante_judgment",
							["dante_bicycle_ride"] = "dante_hell_portal",
							["dante_style"] = "dante_hell_rockets",
							["style_open"] = "dante_blink",
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
               
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
         if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/dante_sin_devil_trigger.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		EmitSoundOn("dante.5", self.parent)
       	local delay = 0.2

	local HiddenAbilities = 
	{
	
		"dante_stinger",
	"royal_guard",
	"dante_range",
	"dante_striptiz",
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end

        self.parent:Purge(false, true, false, true, true)
    end
end
end

function modifier_dante_sin_devil_trigger:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_dante_sin_devil_trigger:OnDestroy()
    if IsServer() then
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
			
 local hideit = 
	{
	"dante_stinger",
	"royal_guard",
	"dante_range",
	"dante_striptiz",
		
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("dante_sin_devil_trigger_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end



































dante_hell_rockets = class({})
LinkLuaModifier( "modifier_dante_hell_rockets", "heroes/dante", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function dante_hell_rockets:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	self.target = self:GetCursorTarget()


	
     self.target:AddNewModifier(caster, ability, "modifier_dante_hell_rockets",{duration = 2.0})
	

	self:PlayEffects1()
end


function dante_hell_rockets:PlayEffects1()
	-- Get Resources
	local sound_cast = "dante.5_2"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end


function dante_hell_rockets:OnChannelFinish( bInterrupted )
	if self.target ~= nil then
		self.target:RemoveModifierByName( "modifier_dante_hell_rockets" )
	end
	local sound_cast = "dante.5_2"

	-- Create Sound
	StopSoundOn( sound_cast, self:GetCaster() )
	
end


modifier_dante_hell_rockets = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dante_hell_rockets:IsHidden()
	return false
end

function modifier_dante_hell_rockets:IsDebuff()
	return true
end

function modifier_dante_hell_rockets:IsStunDebuff()
	return false
end

function modifier_dante_hell_rockets:IsPurgable()
return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dante_hell_rockets:OnCreated( kv )

	self.interval = 0.2
		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()


	
end

function modifier_dante_hell_rockets:OnRefresh( kv )
	-- references	
		self:StartIntervalThink( self.interval )

	
end

function modifier_dante_hell_rockets:OnDestroy()

end


function modifier_dante_hell_rockets:OnIntervalThink()
local caster = self:GetCaster()

	local projectile_name = "particles/dante_hell_rocket.vpcf"
	local projectile_speed = 2500
	local projectile_vision = 0

	-- Create Projectile
	local info = {
		Target = self:GetParent(),
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,				-- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
	
	self:GetCaster():PerformAttack(
				self:GetParent(),
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
end






dante_hell_portal = class({})
LinkLuaModifier( "modifier_dante_hell_portal", "heroes/dante", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muted", "modifiers/modifier_muted", LUA_MODIFIER_MOTION_NONE )


function dante_hell_portal:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	

	-- load data
	local duration = self:GetSpecialValueFor( "prison_duration" )
	

if target:HasModifier("modifier_fountain_aura_effect_lua") then
else
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_muted", -- modifier name
		{ duration = duration + 0.1 } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_dante_hell_portal", -- modifier name
		{ duration = duration } -- kv
	)
	end

	-- play effects
	local sound_cast = "dante.hell_portal"
	EmitSoundOn( sound_cast, caster )
	end
	
	
	
	
	
	modifier_dante_hell_portal = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dante_hell_portal:IsHidden()
	return false
end

function modifier_dante_hell_portal:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_dante_hell_portal:IsStunDebuff()
	return true
end

function modifier_dante_hell_portal:IsPurgable()
	return true
end

function modifier_dante_hell_portal:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dante_hell_portal:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = 2000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- play effects
	self:GetParent():AddNoDraw()
	self:PlayEffects()
	
end


function modifier_dante_hell_portal:OnRefresh( kv )
	-- references
	local damage = 2000
	self.radius = 200

	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = damage
end

function modifier_dante_hell_portal:OnRemoved()
end

function modifier_dante_hell_portal:OnDestroy()
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
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play overhead event
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
			self:GetParent(),
			self.damageTable.damage,
			nil
		)
	end
	

	-- play effects
	self:GetParent():RemoveNoDraw()
	local caster = self:GetCaster()
	local knockback = { should_stun = 1,
                        knockback_duration = 1.5,
                        duration = 1.5,
                        knockback_distance = 0,
                        knockback_height = 300,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    self:GetParent():AddNewModifier(caster, self, "modifier_knockback", knockback)
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_dante_hell_portal:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dante_hell_portal:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/dante_hell_portal_open.vpcf"
	local particle_cast2 = ""
	

	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end
function modifier_dante_hell_portal:PlayEffects2()
	-- Get Resources
	local particle_cast1 = "particles/pandora_blood_exp.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end


dante_judgment = class({})
LinkLuaModifier( "modifier_dante_judgment", "heroes/dante" ,LUA_MODIFIER_MOTION_NONE )

--[[Author: Valve
	Date: 26.09.2015.]]
--------------------------------------------------------------------------------

function dante_judgment:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function dante_judgment:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end


function dante_judgment:GetChannelTime()
	self.creep_duration = self:GetSpecialValueFor( "creep_duration" )
	self.hero_duration = self:GetSpecialValueFor( "hero_duration" )

	if IsServer() then
		if self.hVictim ~= nil then
			if self.hVictim:IsConsideredHero() then
				return self.hero_duration
			else
				return self.creep_duration
			end
		end

		return 0.0
	end

	return self.hero_duration
end

--------------------------------------------------------------------------------

function dante_judgment:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function dante_judgment:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_dante_judgment", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
	local radius = 250
	self:PlayEffects2(radius )
end


--------------------------------------------------------------------------------

function dante_judgment:OnChannelFinish( bInterrupted )
	
	local radius = 500
	local caster = self:GetCaster()
	local damage = 4500
    local point = caster:GetOrigin()
	local duration = 1
	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

end
if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_dante_judgment" )
	end
end


function dante_judgment:PlayEffects2( radius )
	local particle_cast = "particles/dante_judgment.vpcf"
	local sound_cast = "dante.5_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end





modifier_dante_judgment = class({})

--------------------------------------------------------------------------------

function modifier_dante_judgment:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_dante_judgment:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_dante_judgment:OnCreated( kv )

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( 0.5)
	end
end

--------------------------------------------------------------------------------

function modifier_dante_judgment:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
		local point = self:GetParent():GetOrigin()
		local radius = 600 
		local duration = 2
		self:PlayEffects(point, radius, duration  )
	end
end
function modifier_dante_judgment:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/dante_judgment_explosion.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end
--------------------------------------------------------------------------------

function modifier_dante_judgment:OnIntervalThink()
	if IsServer() then
		local flDamage = 1500
		self:GetCaster():PerformAttack(self:GetParent(), true,
				true,
				true,
				true,
				true,
				false,
				true)

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
		
		
				
	end
	
end

--------------------------------------------------------------------------------

function modifier_dante_judgment:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_dante_judgment:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
function modifier_dante_judgment:GetEffectName()
	return ""
end

function modifier_dante_judgment:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_dante_judgment:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end













dante_striptiz = class({})
LinkLuaModifier( "modifier_dante_striptiz", "heroes/dante", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_disarm_silence", "modifiers/modifier_generic_disarm_silence", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function dante_striptiz:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor("duration")
	print(duration)

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_dante_striptiz", -- modifier name
		{
			duration = duration,
			start = true,
		} -- kv
	)

	-- effects
	local sound_cast = ""
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Ability Channeling
-- function dante_striptiz:GetChannelTime()

-- end

function dante_striptiz:OnChannelFinish( bInterrupted )
	local delay = self:GetSpecialValueFor("sand_storm_invis_delay")
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_dante_striptiz", -- modifier name
		{
			duration = delay,
			start = false,
		} -- kv
	)
end

modifier_dante_striptiz = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dante_striptiz:IsHidden()
	return false
end

function modifier_dante_striptiz:IsDebuff()
	return false
end

function modifier_dante_striptiz:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dante_striptiz:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "sand_storm_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "sand_storm_radius" ) -- special value
	self.interval = 1

	if IsServer() then
		-- initialize
		self.active = true
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self.damage ,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		--Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- start effects
		self:PlayEffects( self.radius )
	end
end

function modifier_dante_striptiz:OnRefresh( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "sand_storm_damage" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "sand_storm_radius" ) -- special value

	if IsServer() then
		-- initialize
		self.damageTable.damage = self.damage 
		self.active = kv.start
		self:SetDuration( kv.duration, true )
	end
end

function modifier_dante_striptiz:OnDestroy( kv )
	if IsServer() then
		-- stop effects
		self:StopEffects()
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects

function modifier_dante_striptiz:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
					MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}

	return funcs
end
function modifier_dante_striptiz:GetOverrideAnimation( params )
	return ACT_DOTA_CHANNEL_ABILITY_6
end
	function modifier_dante_striptiz:GetModifierModelChange()

	return "models/dante/donte_no_sword.vmdl"
	
	end
function modifier_dante_striptiz:GetModifierModelScale()
	return 1
end
--------------------------------------------------------------------------------
-- Status Effects


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dante_striptiz:OnIntervalThink()
	print(self.active)
	if self.active==0 then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local caster = self:GetCaster()

	-- damage enemies
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_disarm_silence", -- modifier name
			{ duration = 1.5 } -- kv
		)
		local gold = -100
	PlayerResource:ModifyGold(enemy:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
	end

	-- effects: reposition cloud
	if self.effect_cast then
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dante_striptiz:PlayEffects( radius )
	-- Get Resources
	local particle_cast = "particles/dante_striptiz.vpcf"
	local sound_cast = "dante.6"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, radius, radius ) )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_dante_striptiz:StopEffects()
	-- Stop particles
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Stop sound
	local sound_cast = ""
	StopSoundOn( "dante.6", self:GetParent() )
	

end


















LinkLuaModifier("modifier_style_open", "heroes/dante.lua", LUA_MODIFIER_MOTION_NONE)

style_open = class({})

function style_open:IsStealable() return true end
function style_open:IsHiddenWhenStolen() return false end

function style_open:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dante_stinger")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function style_open:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_style_open", {})

end
---------------------------------------------------------------------------------------------------------------------
modifier_style_open = class({})
function modifier_style_open:IsHidden() return false end
function modifier_style_open:IsDebuff() return true end
function modifier_style_open:IsPurgable() return false end
function modifier_style_open:IsPurgeException() return false end
function modifier_style_open:RemoveOnDeath() return true end
function modifier_style_open:AllowIllusionDuplicate() return true end


function modifier_style_open:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

	 if self:GetCaster():HasModifier("modifier_dante_sin_devil_trigger") then
	 
	 
	 self.skills_table = {
                            
							["style_open"]="dante_blink",
							["dante_drive"]="style_close",
							
                        }
						else

    self.skills_table = {
                            
							["style_open"]="dante_blink",
							["dante_drive"]="dante_stinger",
							["dante_bicycle_ride"]="royal_guard",
							["dante_style"]="dante_range",
							["dante_sin_devil_trigger"]="style_close",
							
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
function modifier_style_open:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_style_open:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("style_open_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end


style_close = class({})

function style_close:IsStealable() return true end
function style_close:IsHiddenWhenStolen() return false end
function style_close:OnSpellStart()
    local caster = self:GetCaster() 

    if caster:FindModifierByNameAndCaster("modifier_style_open", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_style_open", caster)

        --return nil
    end
end