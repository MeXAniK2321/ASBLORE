modifier_fountain_aura_knockback = class({})

--------------------------------------------------------------------------------

function modifier_fountain_aura_knockback:IsHidden()
	return true
end



function modifier_fountain_aura_knockback:OnCreated( kv )
	-- references
	
	
	

	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end
function modifier_fountain_aura_knockback:OnIntervalThink()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1440,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
local radius = 400
	for _,enemy in pairs(enemies) do
		-- apply damage
		local knockback = { should_stun = 0,
                        knockback_duration = 0.1,
                        duration = 0.1,
                        knockback_distance = 700,
                        knockback_height = 0,
                        center_x = self:GetParent():GetAbsOrigin().x,
                        center_y = self:GetParent():GetAbsOrigin().y,
                        center_z = self:GetParent():GetAbsOrigin().z }

    enemy:AddNewModifier(self:GetParent(), self, "modifier_knockback", knockback)

	
		
	end
end

