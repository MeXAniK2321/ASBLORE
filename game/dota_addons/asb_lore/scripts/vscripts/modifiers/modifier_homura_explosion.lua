modifier_homura_explosion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_homura_explosion:IsHidden()
	return true
end

function modifier_homura_explosion:IsDebuff()
	return false
end

function modifier_homura_explosion:IsPurgable()
	return false
end



--------------------------------------------------------------------------------
-- Initializations
function modifier_homura_explosion:OnCreated( kv )
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_explosion2", -- modifier name
		{ duration = 60 } -- kv
	)
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_kill", -- modifier name
		{ duration = 59 } -- kv
	)
	
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.interval = 0.5
	self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
end
function modifier_homura_explosion:OnDestroy()

end

function modifier_homura_explosion:OnRefresh( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end
function modifier_homura_explosion:OnIntervalThink()
	

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage enemies
	for _,enemy in pairs(enemies) do
		if enemy:HasModifier( "modifier_homura_bomb_explosion" )  then
		self:GetParent():RemoveModifierByName("modifier_homura_explosion")
		else
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_homura_bomb_explosion", -- modifier name
			{ duration = 1.0 } -- kv
		)
		EmitSoundOn("homura.1_11", self:GetParent())
		
		end
	end

	-- effects: reposition cloud
	
end
function modifier_homura_explosion:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	return state
end


function modifier_homura_explosion:OnRemoved()
end



--------------------------------------------------------------------------------
-- Modifier Effects






