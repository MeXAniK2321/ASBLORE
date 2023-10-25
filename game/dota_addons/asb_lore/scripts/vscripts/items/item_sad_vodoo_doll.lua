item_sad_vodoo_doll = item_sad_vodoo_doll or class({})
LinkLuaModifier("modifier_item_sad_vodoo_doll", "items/item_sad_vodoo_doll", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sad_vodoo_doll_debuff", "items/item_sad_vodoo_doll", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sad_vodoo_doll_cooldown", "items/item_sad_vodoo_doll", LUA_MODIFIER_MOTION_NONE)

function item_sad_vodoo_doll:GetIntrinsicModifierName()
	return "modifier_item_sad_vodoo_doll"
end
function item_sad_vodoo_doll:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(self:GetCaster(), self, "modifier_item_sad_vodoo_doll_debuff", {duration = self:GetSpecialValueFor("duration")})
	caster:EmitSound("voodoo.sfx")
end

---------------------------------------------------------------------------------------------------------------------
modifier_item_sad_vodoo_doll = modifier_item_sad_vodoo_doll or class({})

function modifier_item_sad_vodoo_doll:IsHidden() return true end
function modifier_item_sad_vodoo_doll:IsDebuff() return false end
function modifier_item_sad_vodoo_doll:IsPurgable() return false end
function modifier_item_sad_vodoo_doll:IsPurgeException() return false end
function modifier_item_sad_vodoo_doll:RemoveOnDeath() return false end
function modifier_item_sad_vodoo_doll:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_sad_vodoo_doll:DeclareFunctions()
	local func = { 	
	                 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	                 MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	                 MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	                 MODIFIER_PROPERTY_HEALTH_BONUS,
	                 MODIFIER_PROPERTY_MANA_BONUS,
				 }
	
	return func
end
function modifier_item_sad_vodoo_doll:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end
function modifier_item_sad_vodoo_doll:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_item_sad_vodoo_doll:GetModifierBonusStats_Strength()
	return self.strength
end
function modifier_item_sad_vodoo_doll:GetModifierBonusStats_Agility()
	return self.agility
end
function modifier_item_sad_vodoo_doll:GetModifierBonusStats_Intellect()
	return self.intellect
end
function modifier_item_sad_vodoo_doll:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.strength = self.ability:GetSpecialValueFor("bonus_strength")
	self.agility = self.ability:GetSpecialValueFor("bonus_agility")
	self.intellect = self.ability:GetSpecialValueFor("bonus_intellect")
end


---------------------------------------------------------------------------------------------------------------------
modifier_item_sad_vodoo_doll_debuff = modifier_item_sad_vodoo_doll_debuff or class({})

function modifier_item_sad_vodoo_doll_debuff:IsHidden() return false end
function modifier_item_sad_vodoo_doll_debuff:IsDebuff() return true end
function modifier_item_sad_vodoo_doll_debuff:IsPurgable() return false end
function modifier_item_sad_vodoo_doll_debuff:IsPurgeException() return false end
function modifier_item_sad_vodoo_doll_debuff:RemoveOnDeath() return true end
 function modifier_item_sad_vodoo_doll_debuff:DeclareFunctions()
	local func = { 
				     MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
				     MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
				     MODIFIER_PROPERTY_DISABLE_HEALING,   
				 }
	
	return func
end
function modifier_item_sad_vodoo_doll_debuff:GetDisableHealing()
	return 1
end
function modifier_item_sad_vodoo_doll_debuff:GetModifierIncomingDamage_Percentage( params )
    return 13
end
function modifier_item_sad_vodoo_doll_debuff:OnAbilityFullyCast(params)
	if IsServer() then
	
	self.mana = self:GetParent():GetMaxMana()
	self.damage = self.mana * 0.35
	local unit = params.unit
	local pass = false
	
	    if unit == self:GetParent() then
	      pass = true
	    end
		
	    if params.ability:IsItem() then return end

	    if pass then
		    self.damageTable = {
		    victim = self:GetParent(),
		    attacker = self:GetCaster(),
		    damage = self.damage,
		    damage_type = DAMAGE_TYPE_MAGICAL,
		    ability = self:GetAbility(),
		    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
		    }
		
		    local mana_burn =  math.min( self:GetParent():GetMana(), self.damage )
		    self:GetParent():Script_ReduceMana( mana_burn, self:GetAbility() )		
		    ApplyDamage( self.damageTable )
		    self:PlayEffects()
	    end
	end
end	
function modifier_item_sad_vodoo_doll_debuff:GetEffectName()
	return "particles/vodoo_doll_curse_target.vpcf"
end
function modifier_item_sad_vodoo_doll_debuff:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end
function modifier_item_sad_vodoo_doll_debuff:OnCreated(table)
	if IsServer() then
	  local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
      EmitSoundOnClient("star.theme_7", Player)
	
	  self:StartIntervalThink( 0.5 )
	end
end
function modifier_item_sad_vodoo_doll_debuff:OnIntervalThink()
	if self:GetParent():HasModifier("modifier_fountain_aura_effect_lua") then
	  self:Destroy()
    end
end
function modifier_item_sad_vodoo_doll_debuff:OnDestroy(table)
	if IsServer() then
	  local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
      StopSoundOn("star.theme_7", Player)
	end
end
function modifier_item_sad_vodoo_doll_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vodoo_doll_curse.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	-- ParticleManager:SetParticleControl( effect_cast, 0, vControlVector )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end