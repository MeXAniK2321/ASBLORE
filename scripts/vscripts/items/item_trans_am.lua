item_trans_am = class({})
LinkLuaModifier("modifier_item_trans_am", "items/item_trans_am", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_trans_am_buff", "items/item_trans_am", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_trans_am", "items/item_trans_am", LUA_MODIFIER_MOTION_NONE)
function item_trans_am:GetIntrinsicModifierName()
	return "modifier_item_trans_am"
end

function item_trans_am:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_item_trans_am_buff", {duration = duration})
	local radius = self:GetSpecialValueFor("radius")
	local debuff_duration = self:GetSpecialValueFor("debuff_duration")
	
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

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_trans_am", -- modifier name
			{ duration = debuff_duration } -- kv
		)
		local knockback = { should_stun = 1,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 500,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end

	
	
	EmitSoundOn("trans_am", caster)
	self:PlayEffects( radius )

end
function item_trans_am:PlayEffects( radius )
	local particle_cast = "particles/trans_am.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

---------------------------------------------------------------------------------------------------------------------
modifier_item_trans_am = class({})
function modifier_item_trans_am:IsHidden() return true end
function modifier_item_trans_am:IsDebuff() return false end
function modifier_item_trans_am:IsPurgable() return false end
function modifier_item_trans_am:IsPurgeException() return false end
function modifier_item_trans_am:RemoveOnDeath() return false end
function modifier_item_trans_am:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_trans_am:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					}
	return func
end
function modifier_item_trans_am:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_trans_am:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_trans_am:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
  function modifier_item_trans_am:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('armor')
end

 
---------------------------------------------------------------------------------------------------------------------
modifier_item_trans_am_buff = class({})
function modifier_item_trans_am_buff:IsHidden() return false end
function modifier_item_trans_am_buff:IsDebuff() return false end
function modifier_item_trans_am_buff:IsPurgable() return true end
function modifier_item_trans_am_buff:IsPurgeException() return true end
function modifier_item_trans_am_buff:RemoveOnDeath() return true end
function modifier_item_trans_am_buff:CheckState()
    

	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_item_trans_am_buff:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        
        
					}
	return func
end
function modifier_item_trans_am_buff:GetModifierMoveSpeedBonus_Percentage()
    return 15
end

modifier_trans_am = class({})
function modifier_trans_am:IsHidden() return false end
function modifier_trans_am:IsDebuff() return true end
function modifier_trans_am:IsPurgable() return true end
function modifier_trans_am:IsPurgeException() return false end
function modifier_trans_am:RemoveOnDeath() return true end
function modifier_trans_am:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_trans_am:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
      
        
					}
	return func
end
function modifier_trans_am:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor('ms')
end

