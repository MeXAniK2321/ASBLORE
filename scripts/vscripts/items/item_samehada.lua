item_samehada = class({})
LinkLuaModifier("modifier_samehada", "items/item_samehada", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_samehada_buff", "items/item_samehada", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_samehada_debuff", "items/item_samehada", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_samehada_aura", "items/item_samehada", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_samehada_aura_debuff", "items/item_samehada", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debate_club_debuff", "items/item_debate_club", LUA_MODIFIER_MOTION_NONE)
function item_samehada:GetIntrinsicModifierName()
	return "modifier_samehada"
end
function item_samehada:OnSpellStart()
local caster = self:GetCaster()
   caster:Purge(false, true, false, true, true)
	  if not IsServer() then return nil end
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local mana = target:GetMaxMana() * 0.15
	local damage = mana
	if target:TriggerSpellAbsorb(self) then return end
	target:AddNewModifier(self:GetCaster(), self, "modifier_item_samehada_debuff", {duration = 2.5})
local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional
	}
	ApplyDamage(damageTable)

	
target:ReduceMana( mana )
target:Purge(true, false, false, false, false)
	self:PlayEffects( target )
 EmitSoundOn("kyoka.use", caster)
end
function item_samehada:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/samehada_active.vpcf"

	-- Get Data
	local vec = target:GetOrigin()-self:GetCaster():GetOrigin()
	local attach = "attach_attack1"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 3, vec )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		4,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
---------------------------------------------------------------------------------------------------------------------
modifier_samehada = class({})
function modifier_samehada:IsHidden() return true end
function modifier_samehada:IsDebuff() return false end
function modifier_samehada:IsPurgable() return false end
function modifier_samehada:IsPurgeException() return false end
function modifier_samehada:RemoveOnDeath() return false end
function modifier_samehada:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	       MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					}
	return func
end

function modifier_samehada:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
	

		local target = params.target
		local result = UnitFilter(
			target,	-- Target Filter
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- Team Filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- Unit Filter
			DOTA_UNIT_TARGET_FLAG_MANA_ONLY,	-- Unit Flag
			self:GetParent():GetTeamNumber()	-- Team reference
		)
	
		if result == UF_SUCCESS then
		if params.attacker:IsIllusion() then
		self.mana_break = target:GetMaxMana() * 0.01
		self.base = 100
		else
		self.mana_break = target:GetMaxMana() * 0.05
		self.base = 150
		end
			local mana_burn =  math.min( target:GetMana(), self.mana_break )
			target:ReduceMana( mana_burn )

			self:PlayEffects( target )
			local burned_damage = mana_burn + self.base
			local burned_damage2 = burned_damage * 0.8

			return burned_damage2
		end

	end
end
function modifier_samehada:GetModifierBonusStats_Agility()

    return self:GetAbility():GetSpecialValueFor('agi')
end


function modifier_samehada:GetModifierBonusStats_Intellect()
 

    return self:GetAbility():GetSpecialValueFor('int')
end


function modifier_samehada:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/generic_gameplay/generic_manaburn.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
	-- ParticleManager:SetParticleControl( effect_cast, 0, vControlVector )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

function modifier_samehada:GetModifierAttackSpeedBonus_Constant()

    return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end

 function modifier_samehada:GetModifierBonusStats_Strength()

	return self:GetAbility():GetSpecialValueFor('str')
end

  function modifier_samehada:GetModifierPhysicalArmorBonus()

return self:GetAbility():GetSpecialValueFor('armor')
end

---------------------------------------------------------------------------------------------------------------------
  function modifier_samehada:GetModifierBaseAttack_BonusDamage()

return self:GetAbility():GetSpecialValueFor('damage')
end 



modifier_item_samehada_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_samehada_debuff:IsHidden()
	return false
end

function modifier_item_samehada_debuff:IsDebuff()
	return true
end

function modifier_item_samehada_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_samehada_debuff:OnCreated( kv )


end

function modifier_item_samehada_debuff:OnRefresh( kv )

end

function modifier_item_samehada_debuff:OnRemoved()
end

function modifier_item_samehada_debuff:OnDestroy()

end

--------------------------------------------------------------------------------
function modifier_item_samehada_debuff:DeclareFunctions()
	local func = {					
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					}
	return func
end
function modifier_item_samehada_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -40
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_item_samehada_debuff:OnIntervalThink()

	self:GetParent():Purge(true, false, false, false, false)
	end



function modifier_item_samehada_debuff:GetEffectName()
	return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

function modifier_item_samehada_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



