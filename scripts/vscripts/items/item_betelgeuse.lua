item_betelgeuse = class({})
LinkLuaModifier("modifier_item_betelgeuse", "items/item_betelgeuse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_betelgeuse_buff", "items/item_betelgeuse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_betelgeuse", "items/item_betelgeuse", LUA_MODIFIER_MOTION_NONE)
function item_betelgeuse:GetIntrinsicModifierName()
	return "modifier_item_betelgeuse"
end
function item_betelgeuse:GetAbilityTextureName()
local caster = self:GetCaster()
 if caster:GetUnitName()== "npc_dota_hero_night_stalker" then
  return "subaru_betelgeuse"
 else
 return "betelgeuse"
 end
		
end
function item_betelgeuse:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_item_betelgeuse_buff", {duration = duration})
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
			"modifier_betelgeuse", -- modifier name
			{ duration = debuff_duration } -- kv
		)
	end

	
	if caster:GetUnitName()== "npc_dota_hero_night_stalker" then
	EmitSoundOn("betelgeuse.subaru", caster)
	self:PlayEffects2( radius )
	else
	EmitSoundOn("betelgeuse.1", caster)
	self:PlayEffects( radius )
	end
end
function item_betelgeuse:PlayEffects( radius )
	local particle_cast = "particles/betelgeuse.vpcf"
	local sound_cast = "betelgeuse.2"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function item_betelgeuse:PlayEffects2( radius )
	local particle_cast = "particles/subaru_betelgeuse.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_item_betelgeuse = class({})
function modifier_item_betelgeuse:IsHidden() return true end
function modifier_item_betelgeuse:IsDebuff() return false end
function modifier_item_betelgeuse:IsPurgable() return false end
function modifier_item_betelgeuse:IsPurgeException() return false end
function modifier_item_betelgeuse:RemoveOnDeath() return false end
function modifier_item_betelgeuse:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_betelgeuse:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					}
	return func
end
function modifier_item_betelgeuse:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_betelgeuse:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_betelgeuse:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('int')
end
  function modifier_item_betelgeuse:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('armor')
end    
 
---------------------------------------------------------------------------------------------------------------------
modifier_item_betelgeuse_buff = class({})
function modifier_item_betelgeuse_buff:IsHidden() return false end
function modifier_item_betelgeuse_buff:IsDebuff() return false end
function modifier_item_betelgeuse_buff:IsPurgable() return true end
function modifier_item_betelgeuse_buff:IsPurgeException() return true end
function modifier_item_betelgeuse_buff:RemoveOnDeath() return true end
function modifier_item_betelgeuse_buff:CheckState()
    

	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
modifier_betelgeuse = class({})
function modifier_betelgeuse:IsHidden() return false end
function modifier_betelgeuse:IsDebuff() return true end
function modifier_betelgeuse:IsPurgable() return true end
function modifier_betelgeuse:IsPurgeException() return false end
function modifier_betelgeuse:RemoveOnDeath() return true end
function modifier_betelgeuse:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_betelgeuse:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        
        
					}
	return func
end
function modifier_betelgeuse:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor('ms')
end

