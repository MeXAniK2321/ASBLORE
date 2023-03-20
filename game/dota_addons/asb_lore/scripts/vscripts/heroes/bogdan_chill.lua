LinkLuaModifier("modifier_bogdan_chill", "heroes/bogdan_chill", LUA_MODIFIER_MOTION_NONE)
bogdan_chill = class({})
function bogdan_chill:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	 local damage = self:GetSpecialValueFor("damage")
local radius = 400
    caster:AddNewModifier(caster, self, "modifier_bogdan_chill", {duration = fixed_duration})
	
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
    local sound_cast = "anime_chatwheel_non_sorted_9_6"
	EmitSoundOn( sound_cast, self:GetCaster() )

   
end
modifier_bogdan_chill = class({})
function modifier_bogdan_chill:IsHidden() return false end
function modifier_bogdan_chill:IsDebuff() return true end
function modifier_bogdan_chill:IsPurgable() return false end
function modifier_bogdan_chill:IsPurgeException() return false end
function modifier_bogdan_chill:RemoveOnDeath() return true end
function modifier_bogdan_chill:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_bogdan_chill:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_MODEL_CHANGE,
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
					
                   
                    
                     }
    return func
end
function modifier_bogdan_chill:GetModifierModelChange()
    return "models/bogdan/skameika1.vmdl"
end
function modifier_bogdan_chill:GetModifierModelScale()
local caster = self:GetParent()

	if IsASBPatreon(caster) then
	return -50
	else
	return
end
end
function modifier_bogdan_chill:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end
