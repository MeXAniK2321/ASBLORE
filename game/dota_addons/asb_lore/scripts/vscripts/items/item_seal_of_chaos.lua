item_seal_of_chaos = class({})
LinkLuaModifier("modifier_item_seal_of_chaos", "items/item_seal_of_chaos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_seal_of_chaos_buff", "items/item_seal_of_chaos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_seal_of_chaos_buff_cd", "items/item_seal_of_chaos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_seal_of_chaos_buff_invul", "items/item_seal_of_chaos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_seal_of_chaos_buff_astral", "items/item_seal_of_chaos", LUA_MODIFIER_MOTION_NONE)
function item_seal_of_chaos:GetIntrinsicModifierName()
	return "modifier_item_seal_of_chaos"
end
function item_seal_of_chaos:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget()
	local mana = caster:GetMana() * 0.5
	local spd = caster:GetSpellAmplification(false)
	local spd_damage = spd * 14
		local hp = target:GetMaxHealth()
		local target_hp = (mana * 0.4) + (hp * 0.07) + spd_damage
		local hp_to_kill = target_hp 
		if target:GetHealth() <= hp_to_kill and target:IsHero() and not target:IsIllusion() and not target:HasModifier("modifier_fountain_aura_effect_lua")  then
	target:AddNewModifier(caster, self, "modifier_item_seal_of_chaos_buff_invul", {duration = 3})
	EmitSoundOn("fatality.1", target)
	EmitSoundOn("fatality.1_1", target)
	else
	
	local damageTable = {
		attacker = caster,
		damage = mana * 0.4,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	damageTable.victim = target
		ApplyDamage(damageTable)
		EmitSoundOn("seal.open", caster)
	end
	caster:Script_ReduceMana( mana, self:GetAbility() )
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_seal_of_chaos = class({})
function modifier_item_seal_of_chaos:IsHidden() return true end
function modifier_item_seal_of_chaos:IsDebuff() return false end
function modifier_item_seal_of_chaos:IsPurgable() return false end
function modifier_item_seal_of_chaos:IsPurgeException() return false end
function modifier_item_seal_of_chaos:RemoveOnDeath() return false end
function modifier_item_seal_of_chaos:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
       MODIFIER_PROPERTY_MANA_BONUS,
    }

    return funcs
end

function modifier_item_seal_of_chaos:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('hp')
end

function modifier_item_seal_of_chaos:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_item_seal_of_chaos:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	
end

function modifier_item_seal_of_chaos:OnRefresh(table)
	self:OnCreated(table)
end




modifier_item_seal_of_chaos_buff_invul = class({})
function modifier_item_seal_of_chaos_buff_invul:IsHidden() return false end
function modifier_item_seal_of_chaos_buff_invul:IsDebuff() return true end
function modifier_item_seal_of_chaos_buff_invul:IsPurgable() return false end
function modifier_item_seal_of_chaos_buff_invul:IsPurgeException() return false end
function modifier_item_seal_of_chaos_buff_invul:RemoveOnDeath() return true end
function modifier_item_seal_of_chaos_buff_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_item_seal_of_chaos_buff_invul:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
self.caster = self:GetCaster()
self:PlayEffects()
	
end
function modifier_item_seal_of_chaos_buff_invul:OnDestroy()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.parent:AddNewModifier(self.caster, self, "modifier_item_seal_of_chaos_buff_astral", {duration = 2})
end
function modifier_item_seal_of_chaos_buff_invul:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/finish_him.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	

end
modifier_item_seal_of_chaos_buff_astral = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_seal_of_chaos_buff_astral:IsHidden()
	return false
end

function modifier_item_seal_of_chaos_buff_astral:IsDebuff()
	return false
end

function modifier_item_seal_of_chaos_buff_astral:IsStunDebuff()
	return true
end

function modifier_item_seal_of_chaos_buff_astral:IsPurgable()
	return true
end

function modifier_item_seal_of_chaos_buff_astral:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_seal_of_chaos_buff_astral:OnCreated( kv )
	
	self:PlayEffects()
	self:GetParent():AddNoDraw()
end




function modifier_item_seal_of_chaos_buff_astral:OnRemoved()
end

function modifier_item_seal_of_chaos_buff_astral:OnDestroy()
	if not IsServer() then return end
local caster = self:GetCaster()

	


	self:GetParent():RemoveNoDraw()

	self:PlayEffects2()
	self:GetParent():Kill(self,caster)
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_item_seal_of_chaos_buff_astral:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_item_seal_of_chaos_buff_astral:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/fatality_murder.vpcf"
	local particle_cast2 = ""
EmitSoundOn("fatality.2_1", self:GetParent())
EmitSoundOn("fatality.2_2", self:GetParent())

	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	

end
function modifier_item_seal_of_chaos_buff_astral:PlayEffects2()
	-- Get Resources
	local particle_cast1 = "particles/fatality.vpcf"
	local particle_cast2 = ""

EmitSoundOn("fatality.3", self:GetParent())
EmitSoundOn("fatality.3_1", self:GetParent())
	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	

end
