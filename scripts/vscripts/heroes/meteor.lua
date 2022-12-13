LinkLuaModifier("modifier_meteor", "heroes/meteor", LUA_MODIFIER_MOTION_NONE)


meteor = class({})






function meteor:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("jellal.3")
    caster:AddNewModifier(caster, self, "modifier_meteor", { duration = duration } )
end

modifier_meteor = class({})
function modifier_meteor:IsHidden() return false end
function modifier_meteor:IsDebuff() return false end
function modifier_meteor:IsPurgable() return true end
function modifier_meteor:RemoveOnDeath() return true end
function modifier_meteor:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor('damage')+ self:GetCaster():FindTalentValue("special_bonus_jellal_25")
	self.radius = 250

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
		ability = self:GetAbility(), --Optional.
	}

	-- Start interval
	self:StartIntervalThink( 0.8 )

	-- Play effects
	
end
function modifier_meteor:OnIntervalThink()
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
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play effects
		
	end
end
function modifier_meteor:CheckState()
    
if self:GetParent():HasModifier( "modifier_heavenly_body_magic" ) then
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
	
	

    

    return state
	else 
	return state 
	end
end
function modifier_meteor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end

function modifier_meteor:GetModifierMoveSpeed_AbsoluteMin()
	 return self:GetAbility():GetSpecialValueFor('bonus_movement_speed')
end
function modifier_meteor:GetEffectName()
	return "particles/meteor.vpcf"
end
