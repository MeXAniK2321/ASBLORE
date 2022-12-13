LinkLuaModifier("modifier_magic_girl_wand", "items/item_magic_girl_wand", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magic_girl_wand_heal", "items/item_magic_girl_wand", LUA_MODIFIER_MOTION_NONE)


item_magic_girl_wand = class({})

function item_magic_girl_wand:GetIntrinsicModifierName()
    return "modifier_magic_girl_wand"
	end

function item_magic_girl_wand:OnSpellStart()
 local caster = self:GetCaster()
  
    caster:AddNewModifier(caster, self, "modifier_magic_girl_wand_heal", {duration = 6})
	EmitSoundOn("magic_girl.cringe", caster)
	
	end
	
	
	



modifier_magic_girl_wand = class({})


function modifier_magic_girl_wand:IsHidden()
    return true
end
function modifier_magic_girl_wand:RemoveOnDeath() return false end
function modifier_magic_girl_wand:IsPurgable()
    return false
end
function modifier_magic_girl_wand:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	
end

function modifier_magic_girl_wand:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_magic_girl_wand:DeclareFunctions()
    local funcs = {
      
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
    }

    return funcs
end


function modifier_magic_girl_wand:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mp')
end

function modifier_magic_girl_wand:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('int')
end
function modifier_magic_girl_wand:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('hp')
end
function modifier_magic_girl_wand:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker == self.parent and keys.damage_category == 0 and keys.inflictor ~= self:GetAbility() then
			if not self.parent.anime_stone_damage_copy then
				self.parent.anime_stone_damage_copy = self.ability
			end

			local flags = 0
			if keys.inflictor then
				flags = keys.inflictor:GetAbilityTargetFlags()
			end
			
			if self.parent.anime_stone_damage_copy == self.ability and  UnitFilter(	keys.unit,
																		DOTA_UNIT_TARGET_TEAM_BOTH,--keys.inflictor:GetAbilityTargetTeam(), 
																		DOTA_UNIT_TARGET_ALL,--keys.inflictor:GetAbilityTargetType(), 
																		flags + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES - DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
																		self.parent:GetTeamNumber()) == UF_SUCCESS then
				--print(keys.original_damage, "STONE ORIG, DAMAGE")
               
                local heal = keys.damage * 0.1
             	self.parent:Heal( heal, self:GetParent() )
			end
		end
	end
end
                     
					 
					 
					 
					 modifier_magic_girl_wand_heal = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_magic_girl_wand_heal:IsHidden()
	return false
end

function modifier_magic_girl_wand_heal:IsDebuff()
	return false
end

function modifier_magic_girl_wand_heal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_magic_girl_wand_heal:OnCreated( kv )
	-- references
	self.heal = self:GetParent():GetMaxMana()
	self.heal1 = self.heal * 0.03 + 40
	self.radius = 600


	self:StartIntervalThink( 0.3 )

	self:PlayEffects1()
end

function modifier_magic_girl_wand_heal:OnRefresh( kv )
	-- references
	self:OnCreated(kv)
end

function modifier_magic_girl_wand_heal:OnRemoved()
end

function modifier_magic_girl_wand_heal:OnDestroy()

end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- Interval Effects
function modifier_magic_girl_wand_heal:OnIntervalThink()
	-- find enemies
	local ally = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,baka in pairs(ally) do
		-- apply damage
		baka:Heal( self.heal1, self:GetParent() )
	end
end

function modifier_magic_girl_wand_heal:GetEffectName()
	return "particles/magic_girl_wand_aura.vpcf"
end

function modifier_magic_girl_wand_heal:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_magic_girl_wand_heal:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/magic_girl_wand_start.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
