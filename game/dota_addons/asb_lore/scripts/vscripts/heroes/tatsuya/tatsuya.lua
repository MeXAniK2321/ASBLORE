gram_dispersion = class({})
LinkLuaModifier( "modifier_gram_dispersion", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tatsuya_personal", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )

function gram_dispersion:GetIntrinsicModifierName()
return "modifier_tatsuya_personal"
end
function gram_dispersion:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

		self:Hit( target, false )

		
end

-- Helper
function gram_dispersion:Hit( target, dragonform )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_gram_dispersion", -- modifier name
		{ duration = duration } -- kv
	)
	


	local sound_cast = "tatsuya.1"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function gram_dispersion:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

modifier_gram_dispersion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gram_dispersion:IsHidden()
	return true
end

function modifier_gram_dispersion:IsDebuff()
	return true
end

function modifier_gram_dispersion:IsStunDebuff()
	return false
end

function modifier_gram_dispersion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_gram_dispersion:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_tatsuya_25")
self.cooldown = self:GetAbility():GetSpecialValueFor( "cooldown_increase" )
	self.silence = true
end

function modifier_gram_dispersion:OnRefresh( kv )
	
end

function modifier_gram_dispersion:OnRemoved()
end

function modifier_gram_dispersion:OnDestroy()
if self:GetCaster():HasTalent("special_bonus_tatsuya_25") then
if self.silence then
local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{ duration = 2 } -- kv
	)
end
end 
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_gram_dispersion:DeclareFunctions()
	local funcs = {
	
		MODIFIER_EVENT_ON_ABILITY_START,
	}

	return funcs
end



function modifier_gram_dispersion:OnAbilityStart( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end
params.ability:StartCooldown(self.cooldown)
	self:Silence()
end
--------------------------------------------------------------------------------
-- Interval Effects


--------------------------------------------------------------------------------
-- Helper
function modifier_gram_dispersion:Silence()
	-- add silence
self.silence = false
	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- play effects
	self:PlayEffects()
	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_gram_dispersion:GetEffectName()
	return "particles/gram_dispersion_visual.vpcf"
end

function modifier_gram_dispersion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_gram_dispersion:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/gram_dispersion_proc.vpcf"
	local sound_cast = "tatsuya.1_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
--------------------------------------------------------------------------------
modifier_tatsuya_personal = class ({})
function modifier_tatsuya_personal:IsHidden() return true end
function modifier_tatsuya_personal:IsDebuff() return false end
function modifier_tatsuya_personal:IsPurgable() return false end
function modifier_tatsuya_personal:IsPurgeException() return false end
function modifier_tatsuya_personal:RemoveOnDeath() return false end

function modifier_tatsuya_personal:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_tatsuya_personal:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_tatsuya_personal:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("flash_cast")
        if vongolle and not vongolle:IsNull() then
            if self:GetParent():HasModifier("modifier_item_ultimate_scepter")  then
                if vongolle:IsHidden() then
                    vongolle:SetHidden(false)
                end
            else
                if not vongolle:IsHidden() then
                    vongolle:SetHidden(true)
                end
            end
        end
		--        local vongolle2 = self:GetParent():FindAbilityByName("tatsuya_seal_off")
        -- if vongolle2 and not vongolle2:IsNull() then
        --     if self:GetParent():HasScepter() and not self:GetParent():HasModifier("modifier_tatsuya_seal_off") and not self:GetParent():HasModifier("modifier_silver_horn")  then
        --         if vongolle2:IsHidden() then
        --             vongolle2:SetHidden(false)
        --         end
        --     else
        --         if not vongolle2:IsHidden() then
        --             vongolle2:SetHidden(true)
        --         end
        --     end
        -- end
    end
	end
	
	
	
	
LinkLuaModifier( "modifier_elemental_sight", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE )
	
elemental_sight = class({})

function elemental_sight:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_elemental_sight", -- modifier name
		{ duration = 1.5 } -- kv
	)
	local radius = self:GetSpecialValueFor("radius")

	self:PlayEffects( radius  + self:GetCaster():FindTalentValue("special_bonus_tatsuya_20_alt"))
end

function elemental_sight:PlayEffects( radius )
	local particle_cast = "particles/tatsuya_elemental_sight.vpcf"
	local sound_cast = "tatsuya.2"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
	modifier_elemental_sight = class ({})
function modifier_elemental_sight:IsHidden() return true end
function modifier_elemental_sight:IsDebuff() return false end
function modifier_elemental_sight:IsPurgable() return false end
function modifier_elemental_sight:IsPurgeException() return false end
function modifier_elemental_sight:RemoveOnDeath() return false end

function modifier_elemental_sight:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(0.3)
    end
end
function modifier_elemental_sight:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_elemental_sight:OnIntervalThink()
    if IsServer() then
        -- unit identifier
	local caster = self:GetCaster()

	local radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():FindTalentValue("special_bonus_tatsuya_20_alt")


	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do

		MinimapEvent(self:GetCaster():GetTeamNumber(), self:GetCaster(), enemy:GetAbsOrigin().x, enemy:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 2)
	end
    end
	end
	
ssid_breaker = class({})

function ssid_breaker:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local damage = self:GetSpecialValueFor("damage") 

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
		enemy:Purge(true, false, false, false, false)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = duration + self:GetCaster():FindTalentValue("special_bonus_tatsuya_20") } -- kv
		)
		self:PlayEffects2(enemy)
	end

	self:PlayEffects( radius )
end
function ssid_breaker:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/ssid_breaker_enemy.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function ssid_breaker:PlayEffects( radius )
	local particle_cast = "particles/ssid_breaker.vpcf"
	local sound_cast = "tatsuya.3"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end




mist_disparsion = class({})
LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE )


function mist_disparsion:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
	
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return manacost_percent
end

function mist_disparsion:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

--------------------------------------------------------------------------------
-- Ability Start
function mist_disparsion:OnSpellStart()
end

--------------------------------------------------------------------------------
-- Orb Effects
function mist_disparsion:GetProjectileName()
	return "particles/tatsuya_mist_disparsion_attack.vpcf"
end

function mist_disparsion:OnOrbFire( params )
	-- play effects
	local sound_cast = "tatsuya.1"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function mist_disparsion:OnOrbImpact( params )
	local caster = self:GetCaster()
local mana = params.target:GetMana()
if self:GetCaster():HasTalent("special_bonus_tatsuya_25_alt") then
self:GetCaster():GiveMana( mana * 0.010 )
end
	
	local int = caster:GetIntellect()
	local int_damage = self:GetSpecialValueFor( "int_damage" )
	local radius = self:GetSpecialValueFor( "radius" )

	-- precache damage
	local damage = int * int_damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,	
	}
	-- ApplyDamage(damageTable)

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		params.target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		local health = enemy:GetHealth()
		local max_health = enemy:GetMaxHealth()
		local percent = max_health * 0.08
		if health < percent or damage > health then
		 enemy:Kill(self, caster)
		 self:PlayEffects(enemy)
		 end
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		-- overhead event
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
			enemy,
			damageTable.damage,
			nil
		)
	end

	

	local sound_cast = "tatsuya.1_1"
	EmitSoundOn( sound_cast, params.target )
end
function mist_disparsion:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/deep_mist_disparsion_smoke.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end


modifier_generic_orb_effect_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_orb_effect_lua:IsHidden()
	return true
end

function modifier_generic_orb_effect_lua:IsDebuff()
	return false
end

function modifier_generic_orb_effect_lua:IsPurgable()
	return false
end

function modifier_generic_orb_effect_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_orb_effect_lua:OnCreated( kv )
	-- generate data
	self.ability = self:GetAbility()
	self.cast = false
	self.records = {}
end

function modifier_generic_orb_effect_lua:OnRefresh( kv )
end

function modifier_generic_orb_effect_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_orb_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,

		MODIFIER_EVENT_ON_ORDER,

		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}

	return funcs
end

function modifier_generic_orb_effect_lua:OnAttack( params )
	-- if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

	-- register attack if being cast and fully castable
	if self:ShouldLaunch( params.target ) then
		-- use mana and cd
		self.ability:UseResources( true, false, true )

		-- record the attack
		self.records[params.record] = true

		-- run OrbFire script if available
		if self.ability.OnOrbFire then self.ability:OnOrbFire( params ) end
	end

	self.cast = false
end
function modifier_generic_orb_effect_lua:GetModifierProcAttack_Feedback( params )
	if self.records[params.record] then
		-- apply the effect
		if self.ability.OnOrbImpact then self.ability:OnOrbImpact( params ) end
	end
end
function modifier_generic_orb_effect_lua:OnAttackFail( params )
	if self.records[params.record] then
		-- apply the fail effect
		if self.ability.OnOrbFail then self.ability:OnOrbFail( params ) end
	end
end
function modifier_generic_orb_effect_lua:OnAttackRecordDestroy( params )
	-- destroy attack record
	self.records[params.record] = nil
end

function modifier_generic_orb_effect_lua:OnOrder( params )
	if params.unit~=self:GetParent() then return end
local ability = self:GetParent():FindAbilityByName("mist_disparsion")
	if params.ability then
	if params.ability ~= ability then return end
		if params.ability==self:GetAbility() then
			self.cast = true
			return
		end

		-- if casting other ability that cancel channel while casting this ability, turn off
		local pass = false
		local behavior = params.ability:GetBehavior()
		if self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL ) or 
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT ) or
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL )
		then
			local pass = true -- do nothing
		end

		if self.cast and (not pass) then
			self.cast = false
		end
	else
		-- if ordering something which cancel channel, turn off
		if self.cast then
			if self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_POSITION ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_TARGET )	or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_MOVE ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_TARGET ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_STOP ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_HOLD_POSITION )
			then
				self.cast = false
			end
		end
	end
end

function modifier_generic_orb_effect_lua:GetModifierProjectileName()
	if not self.ability.GetProjectileName then return end

	if self:ShouldLaunch( self:GetCaster():GetAggroTarget() ) then
		return self.ability:GetProjectileName()
	end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_generic_orb_effect_lua:ShouldLaunch( target )
	-- check autocast
	if self.ability:GetAutoCastState() then
		-- filter whether target is valid
		if self.ability.CastFilterResultTarget~=CDOTA_Ability_Lua.CastFilterResultTarget then
			-- check if ability has custom target cast filter
			if self.ability:CastFilterResultTarget( target )==UF_SUCCESS then
				self.cast = true
			end
		else
			local nResult = UnitFilter(
				target,
				self.ability:GetAbilityTargetTeam(),
				self.ability:GetAbilityTargetType(),
				self.ability:GetAbilityTargetFlags(),
				self:GetCaster():GetTeamNumber()
			)
			if nResult == UF_SUCCESS then
				self.cast = true
			end
		end
	end

	if self.cast and self.ability:IsFullyCastable() and (not self:GetParent():IsSilenced()) then
		return true
	end

	return false
end

--------------------------------------------------------------------------------
-- Helper: Flags
function modifier_generic_orb_effect_lua:FlagExist(a,b)--Bitwise Exist
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end
LinkLuaModifier("modifier_tatsuya_seal_off", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tatsuya_seal_off_invul", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)


tatsuya_seal_off = class({})

function tatsuya_seal_off:IsStealable() return true end
function tatsuya_seal_off:IsHiddenWhenStolen() return false end
function tatsuya_seal_off:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end
function tatsuya_seal_off:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("material_burst")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function tatsuya_seal_off:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
	local duration = 3.0
	local damage = 2000

	

	

    caster:AddNewModifier(caster, self, "modifier_tatsuya_seal_off", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_tatsuya_seal_off_invul", {duration = 2.5})	
-- 	if _G.MusicBox:HasModifier("modifier_star_tier2") then
-- 	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")
-- 	end
-- 	if _G.MusicBox:HasModifier("modifier_star_tier1") then
-- 	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
-- 	end
	
	
-- 	if not _G.MusicBox:HasModifier("modifier_star_tier3") then
-- _G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
-- end
    self:EndCooldown()
	self:PlayEffects(500)
end
function tatsuya_seal_off:PlayEffects( radius )
	local particle_cast = "particles/tatsuya_seal_off.vpcf"
	local sound_cast = "tatsuya.5"
	local sound_cast1 = "tatsuya.5_active"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast1, self:GetCaster() )
end
modifier_tatsuya_seal_off_invul = class({})
function modifier_tatsuya_seal_off_invul:IsHidden() return false end
function modifier_tatsuya_seal_off_invul:IsDebuff() return true end
function modifier_tatsuya_seal_off_invul:IsPurgable() return false end
function modifier_tatsuya_seal_off_invul:IsPurgeException() return false end
function modifier_tatsuya_seal_off_invul:RemoveOnDeath() return true end
function modifier_tatsuya_seal_off_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_tatsuya_seal_off_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_tatsuya_seal_off_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end


---------------------------------------------------------------------------------------------------------------------
modifier_tatsuya_seal_off = class({})
function modifier_tatsuya_seal_off:IsHidden() return false end
function modifier_tatsuya_seal_off:IsDebuff() return true end
function modifier_tatsuya_seal_off:IsPurgable() return false end
function modifier_tatsuya_seal_off:IsPurgeException() return false end
function modifier_tatsuya_seal_off:RemoveOnDeath() return true end
function modifier_tatsuya_seal_off:AllowIllusionDuplicate() return true end
function modifier_tatsuya_seal_off:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("tatsuya_seal_off_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_tatsuya_seal_off:DeclareFunctions()
    local func = {  
    				
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_HEALTH_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,	
			}
    return func
end
function modifier_tatsuya_seal_off:GetModifierHealthBonus()

    return 500

	

end

function modifier_tatsuya_seal_off:GetModifierBonusStats_Agility()

    return 50

	

end
function modifier_tatsuya_seal_off:GetModifierBonusStats_Intellect()
    return 100
end

function modifier_tatsuya_seal_off:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.intellect = self:GetCaster():GetIntellect()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
	
	  

    self.skills_table = {
                            ["tatsuya_seal_off"] = "material_burst",
							["elemental_sight"] = "regrowth",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/tatsuya_seal_off_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
		end


		 
    
		
	
        

        self.parent:Purge(false, true, false, true, true)
    end
	end


function modifier_tatsuya_seal_off:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_tatsuya_seal_off:OnDestroy()
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

       

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("tatsuya_seal_off_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
				if IsServer() then
        local ability2 = self:GetParent():FindAbilityByName("angel_initialize")
        if ability2 and not ability2:IsActivated() then
            ability2:SetActivated(true)
        
    end
        end
    end
end
end
material_burst = class({})
LinkLuaModifier( "modifier_material_burst", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_material_burst_invul", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function material_burst:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function material_burst:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 3.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")

caster:AddNewModifier(caster, self, "modifier_material_burst_invul", {duration = 2.5})
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_material_burst", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, 2200, 5 )
end
function material_burst:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/material_burst_warning.vpcf"
	local sound_cast = "tatsuya.5_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
modifier_material_burst_invul = class({})
function modifier_material_burst_invul:IsHidden() return false end
function modifier_material_burst_invul:IsDebuff() return true end
function modifier_material_burst_invul:IsPurgable() return false end
function modifier_material_burst_invul:IsPurgeException() return false end
function modifier_material_burst_invul:RemoveOnDeath() return true end
function modifier_material_burst_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_material_burst_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end
function modifier_material_burst_invul:OnCreated()
if IsServer() then
	self:PlayEffects()
end
end
function modifier_material_burst_invul:OnDestroy()
if IsServer() then
	self:PlayEffects2()
end
end
function modifier_material_burst_invul:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_5
end
function modifier_material_burst_invul:PlayEffects( radius )
	local particle_cast = "particles/tatsuya_material_burst_effects.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	

	
end
function modifier_material_burst_invul:PlayEffects2( radius )
	local particle_cast = "particles/vergil_flash.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end
modifier_material_burst = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_material_burst:IsHidden()
	return true
end

function modifier_material_burst:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_material_burst:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local int  = self:GetCaster():GetIntellect()
	local damage = self:GetAbility():GetAbilityDamage() * int

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_material_burst:OnRefresh( kv )
	
end

function modifier_material_burst:OnRemoved()
end

function modifier_material_burst:OnDestroy()
	if not IsServer() then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_material_burst:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/material_burst.vpcf"
	local sound_cast = "tatsuya.5_1_exp"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end


regrowth = class({})


function regrowth:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local hp = target:GetMaxHealth()
	self.duration = 1.0
	local current_hp = target:GetHealth()
	local heal = hp - current_hp
		local heal_caster = hp

target:Purge( false, true, false, true, false)

	target:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration } -- kv
		)
	target:Heal( heal, self )
	
	
self:PlayEffects(target)
	local sound_cast = "tatsuya.5_2"
	EmitSoundOn( sound_cast, target )
end
function regrowth:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/regrowth_afterimage.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end





flash_cast = class({})	
LinkLuaModifier("modifier_flash_cast_cast", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE)	-- Motion + invuln
LinkLuaModifier("modifier_silver_burst", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE)	-- Motion + invuln

function flash_cast:IsHiddenWhenStolen() return false end
function flash_cast:IsNetherWardStealable() return false end

function flash_cast:OnSpellStart()
	local caster = self:GetCaster()
	local slow_radius = 350
	local position	= self:GetCursorPosition()
	self.old_position = self:GetCaster():GetAbsOrigin()
	if caster:HasScepter() then
caster:AddNewModifier(caster, ability, "modifier_silver_burst", {duration = 1.2})
end
local sound_cast = "tatsuya.6"
	EmitSoundOn( sound_cast, caster )
	local max_cast_range = self:GetSpecialValueFor("range") + self:GetCaster():GetCastRangeBonus()


	caster:AddNewModifier(caster, self, "modifier_flash_cast_cast", {
		duration	= math.min((position - self:GetCaster():GetAbsOrigin()):Length2D(), max_cast_range) / self:GetSpecialValueFor("speed") + 0.5, -- Arbitrary increase to account for some poor programming causing the ability to not go full range with cast range bonuses -_-
		x			= position.x,
		y 			= position.y,
		z			= position.z
	})

	
	local aoe_pfx = ParticleManager:CreateParticle("particles/tatsuya_flash_cast_start.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(aoe_pfx, 1, Vector(slow_radius,0,0))
	ParticleManager:ReleaseParticleIndex(aoe_pfx)
	ProjectileManager:ProjectileDodge(caster)
end

modifier_silver_burst = class({})


function modifier_silver_burst:IsHidden()
    return true
end
function modifier_silver_burst:RemoveOnDeath() return false end
function modifier_silver_burst:IsPurgable()
    return false
end

modifier_flash_cast_cast = class({})
function modifier_flash_cast_cast:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_flash_cast_cast:IsPurgable() return	false end
function modifier_flash_cast_cast:IsDebuff() return	false end
function modifier_flash_cast_cast:IsHidden() return	true end
function modifier_flash_cast_cast:IgnoreTenacity() return true end
function modifier_flash_cast_cast:IsMotionController() return true end
function modifier_flash_cast_cast:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_flash_cast_cast:GetEffectName()
	return "particles/tatsuya_flash_cast_particle.vpcf" end

function modifier_flash_cast_cast:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_flash_cast_cast:CheckState()
	return {
		[MODIFIER_STATE_STUNNED]			= true,
		[MODIFIER_STATE_INVULNERABLE]		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]	= true
	}
end

function modifier_flash_cast_cast:OnCreated(params)
	

	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local position = GetGroundPosition(Vector(params.x, params.y, params.z), nil)

		-- Compare distance to cast point and max distance, use whichever is closer
		local max_distance = ability:GetSpecialValueFor("range") + self:GetCaster():GetCastRangeBonus()

	
		local distance = math.min((caster:GetAbsOrigin() - position):Length2D(), max_distance)

	

		-- Initialize variables for HorizontalMotion
		self.velocity = ability:GetSpecialValueFor("speed")
		self.direction = (position - self:GetParent():GetAbsOrigin()):Normalized()
		self.distance_traveled = 0
		self.distance = distance
		
		local particle = ParticleManager:CreateParticle("particles/tatsuya_flash_cast_afterimage.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin() + self.direction * distance)
		ParticleManager:SetParticleControlEnt(particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetForwardVector(), true)
		ParticleManager:ReleaseParticleIndex(particle)

		self.frametime = FrameTime()
		self:OnIntervalThink()
		self:StartIntervalThink(self.frametime)
	end
end

function modifier_flash_cast_cast:OnIntervalThink()

	-- Check Motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), self.frametime)

	local ability = self:GetAbility()

	if ability:GetAbilityName() == "flash_cast" then
		local caster = self:GetParent()

		local aoe = self:GetAbility():GetSpecialValueFor("slow_radius")
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		

		-- Slow enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _,enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_gram_dispersion") then

				-- If the enemy is a real hero index their move and attack speed, and grant a chronocharge
				if enemy:IsRealHero() then

				

				-- Play hit particle only on hit heroes, and their illusions to prevent the caster from finding the real hero with this skill.
				if enemy:IsHero() then
					local particle = ParticleManager:CreateParticle("particles/tatsuya_flash_cast_afterimage_enemy.vpcf", PATTACH_ABSORIGIN, enemy)
					ParticleManager:SetParticleControl(particle, 0, enemy:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle)
				end

				-- Apply the slow
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})
			end
			end
		end

		-- If spell not stolen, add chronocharges
		
	end
end

function modifier_flash_cast_cast:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local duration = ability:GetSpecialValueFor("duration")
		local aoe = 350
		local damage = self:GetAbility():GetSpecialValueFor("damage")
self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	

			for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
				self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		if enemy:HasModifier("modifier_gram_dispersion") then
		enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})
		end
			end
		
		
		-- Timer because it has a slight offset otherwise
		Timers:CreateTimer(0.1, function()
			-- Play particle around landing point
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_walk_slow.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle, 1, Vector(aoe,aoe,aoe))
			ParticleManager:ReleaseParticleIndex(particle)

			-- Stop the casting animation and remove caster modifier
			caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
		end)
	end
	end


function modifier_flash_cast_cast:HorizontalMotion( me, dt )
	if self.distance_traveled < self.distance then
		self:GetCaster():SetAbsOrigin(self:GetCaster():GetAbsOrigin() + (self.direction * math.min(self.velocity * dt, self.distance - self.distance_traveled)))
		self.distance_traveled = self.distance_traveled + math.min(self.velocity * dt, self.distance - self.distance_traveled)
	else
		self:Destroy()
	end
end


deep_mist_disparsion = class({})
LinkLuaModifier( "modifier_deep_mist_disparsion", "heroes/tatsuya/tatsuya", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )


function deep_mist_disparsion:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

		self:Hit( target, false )

		
end

-- Helper
function deep_mist_disparsion:Hit( target, dragonform )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_deep_mist_disparsion", -- modifier name
		{ duration = duration } -- kv
	)
	


	local sound_cast = "tatsuya.7"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function deep_mist_disparsion:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

modifier_deep_mist_disparsion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_deep_mist_disparsion:IsHidden()
	return true
end

function modifier_deep_mist_disparsion:IsDebuff()
	return true
end

function modifier_deep_mist_disparsion:IsStunDebuff()
	return false
end

function modifier_deep_mist_disparsion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_deep_mist_disparsion:OnCreated( kv )

	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_tatsuya_25")

end

function modifier_deep_mist_disparsion:OnRefresh( kv )
	
end

function modifier_deep_mist_disparsion:OnRemoved()
end

function modifier_deep_mist_disparsion:OnDestroy()
if IsServer() then
local health = self:GetParent():GetHealth()
local max_health = self:GetParent():GetMaxHealth()
local diff = max_health * 0.2
if health < diff then
self:GetParent():Kill(self, self:GetCaster())
 end
local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = 2 } -- kv
	)
	self:PlayEffects()
end
end


function modifier_deep_mist_disparsion:GetEffectName()
	return "particles/deep_mist_disparsion_visual.vpcf"
end

function modifier_deep_mist_disparsion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_deep_mist_disparsion:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/deep_mist_disparsion_smoke.vpcf"
	local sound_cast = "tatsuya.7_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end