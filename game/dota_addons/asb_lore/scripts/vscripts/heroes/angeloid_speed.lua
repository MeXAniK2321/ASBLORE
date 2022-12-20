LinkLuaModifier("modifier_angeloid_speed", "heroes/angeloid_speed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angeloid_speed_damage", "heroes/angeloid_speed", LUA_MODIFIER_MOTION_NONE)

angeloid_speed = class({})






function angeloid_speed:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("ikaros.3")
	caster:EmitSound("ikaros.3_1")
    caster:AddNewModifier(caster, self, "modifier_angeloid_speed", { duration = duration + self:GetCaster():FindTalentValue("special_bonus_ikaros_25") } )
end

modifier_angeloid_speed = class({})
function modifier_angeloid_speed:IsHidden() return false end
function modifier_angeloid_speed:IsDebuff() return false end
function modifier_angeloid_speed:IsPurgable() return true end
function modifier_angeloid_speed:RemoveOnDeath() return true end
function modifier_angeloid_speed:OnCreated( kv )
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

	-- Play effects
	
end
function modifier_angeloid_speed:OnIntervalThink()
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
		if enemy:HasModifier("modifier_angeloid_speed_damage") then
		else
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_angeloid_speed_damage", -- modifier name
		{ duration = 2  } -- kv
	)
	end

		-- play effects
		
	end
end
function modifier_angeloid_speed:CheckState()
    

	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
	
	

    

	return state 
	end

function modifier_angeloid_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end

function modifier_angeloid_speed:GetModifierMoveSpeed_AbsoluteMin()
	 return self:GetAbility():GetSpecialValueFor('bonus_movement_speed')
end
function modifier_angeloid_speed:GetEffectName()
	return "particles/angeloid_speed.vpcf"
end
modifier_angeloid_speed_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_angeloid_speed_damage:IsHidden()
	return false
end

function modifier_angeloid_speed_damage:IsDebuff()
	return true
end

function modifier_angeloid_speed_damage:IsStunDebuff()
	return false
end

function modifier_angeloid_speed_damage:IsPurgable()
	return true
end

function modifier_angeloid_speed_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_angeloid_speed_damage:OnCreated( kv )
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
	local sound_cast = "ikaros.1_1"
	EmitSoundOn( sound_cast, self:GetParent() )
end