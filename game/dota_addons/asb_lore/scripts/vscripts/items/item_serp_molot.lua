
LinkLuaModifier( "modifier_item_serp_molot", "items/item_serp_molot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_serp_molot_buff", "items/item_serp_molot", LUA_MODIFIER_MOTION_NONE )
item_serp_molot = item_serp_molot or class({})

function item_serp_molot:GetIntrinsicModifierName()
    return "modifier_item_serp_molot"
end
function item_serp_molot:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration_buff")
	local radius = 400
    local damage = 0

	caster:AddNewModifier(caster, self, "modifier_item_serp_molot_buff", {duration = duration})

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
	end

	local cast_fx = ParticleManager:CreateParticle("", PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:ReleaseParticleIndex(cast_fx)
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_serp_molot = modifier_item_serp_molot or class({})

function modifier_item_serp_molot:IsHidden() return true end
function modifier_item_serp_molot:IsDebuff() return false end
function modifier_item_serp_molot:IsPurgable() return false end
function modifier_item_serp_molot:IsPurgeException() return false end
function modifier_item_serp_molot:RemoveOnDeath() return false end
function modifier_item_serp_molot:DeclareFunctions()
	local func = {	
				     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
				     MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
				     MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
				     MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
				     MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
				     MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 
				     MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
				     MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,					
				 }
	
	return func
end
function modifier_item_serp_molot:GetModifierBonusStats_Strength()
    return 15
end
function modifier_item_serp_molot:GetModifierPhysicalArmorBonus()
    return 8
end      
function modifier_item_serp_molot:GetModifierBonusStats_Agility()
    return 15
end
function modifier_item_serp_molot:GetModifierBonusStats_Intellect()
    return 15
end
function modifier_item_serp_molot:GetModifierIncomingDamage_Percentage( params )
    return -10
end
function modifier_item_serp_molot:GetModifierMagicalResistanceBonus()
    return 25
end
function modifier_item_serp_molot:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor('hp_regen')
end
function modifier_item_serp_molot:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor('mp_regen')
end


modifier_item_serp_molot_buff = modifier_item_serp_molot_buff or class({})

function modifier_item_serp_molot_buff:IsHidden() return false end
function modifier_item_serp_molot_buff:IsDebuff() return false end
function modifier_item_serp_molot_buff:IsPurgable() return false end
function modifier_item_serp_molot_buff:IsPurgeException() return true end
function modifier_item_serp_molot_buff:RemoveOnDeath() return true end
function modifier_item_serp_molot_buff:DeclareFunctions()
	local func = {	
	                 MODIFIER_EVENT_ON_TAKEDAMAGE,
	                 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
				 }
	return func
end
function modifier_item_serp_molot_buff:GetModifierIncomingDamage_Percentage( params )
    return -5
end
function modifier_item_serp_molot_buff:OnTakeDamage(keys)
	if not IsServer() then return end
	
	local attacker = keys.attacker
	local target = keys.unit
	local original_damage = keys.original_damage
	local damage_type = keys.damage_type
	local damage_flags = keys.damage_flags
	if keys.unit == self:GetParent() and not keys.attacker:IsBuilding() and not keys.attacker:IsMagicImmune() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then	
		if not keys.unit:IsOther() then
			EmitSoundOnClient("DOTA_Item.BladeMail.Damage", keys.attacker:GetPlayerOwner())
			local damageTable = {
				victim			= keys.attacker,
				damage			= keys.original_damage,
				damage_type		= keys.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker		= self:GetParent(),
				ability			= self:GetAbility()
			}
			ApplyDamage(damageTable)
		end
	end
end
function modifier_item_serp_molot_buff:OnCreated(table)
    local caster = self:GetCaster()
	if IsServer() then
		self.ability = self:GetAbility()
		--EmitSoundOn("serp.molot", caster)
	end
end
function modifier_item_serp_molot_buff:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
function modifier_item_serp_molot_buff:OnDestroy()
    local caster = self:GetCaster()
	if IsServer() then
		--StopSoundOn("serp.molot", caster)
    end	
end

function modifier_item_serp_molot_buff:GetEffectName()
	return "particles/serp_molot1.vpcf"
end
function modifier_item_serp_molot_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
