item_red_spear = item_red_spear or class({})
LinkLuaModifier( "modifier_item_red_spear", "items/item_red_spear", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_red_spear_buff", "items/item_red_spear", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_red_spear_souls", "items/item_red_spear", LUA_MODIFIER_MOTION_NONE )
function item_red_spear:GetIntrinsicModifierName()
	return "modifier_item_red_spear"
end
function item_red_spear:OnToggle()
	local hCaster = self:GetCaster()
	EmitSoundOn("gay.gay", hCaster)

	if self:GetItemState() == 1 then
		if self:GetToggleState() == true then
			hCaster:AddNewModifier(hCaster, self, "modifier_item_red_spear_buff", {})

			self:EndCooldown()
		else
			if hCaster:HasModifier("modifier_item_red_spear_buff") then
				hCaster:RemoveModifierByNameAndCaster("modifier_item_red_spear_buff", hCaster)
			end
		end
	end
end
function item_red_spear:GetAbilityTextureName()
	return self:GetToggleState()
		   and "red_spear"
		   or "red_spear"
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_red_spear = modifier_item_red_spear or class({})
function modifier_item_red_spear:IsHidden() return true end
function modifier_item_red_spear:IsDebuff() return false end
function modifier_item_red_spear:IsPurgable() return false end
function modifier_item_red_spear:IsPurgeException() return false end
function modifier_item_red_spear:RemoveOnDeath() return false end
function modifier_item_red_spear:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					MODIFIER_PROPERTY_HEALTH_BONUS,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
				 }	
	
	return func
end
function modifier_item_red_spear:OnCreated(hTable)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_health		= self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_spell_amp		= self.ability:GetSpecialValueFor("bonus_spell_amp")
	self.bonus_armor 	= self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_str 		= self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi 		= self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_int 		= self.ability:GetSpecialValueFor("bonus_int")


	if IsServer() then
		if self.ability:GetToggleState() == true and self.ability:IsFullyCastable() then
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_red_spear_buff", {})
		end
	end
end
function modifier_item_red_spear:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end
function modifier_item_red_spear:GetModifierHealthBonus()
    return self.bonus_health
end
function modifier_item_red_spear:GetModifierSpellAmplify_Percentage()
    return self.bonus_spell_amp
end
function modifier_item_red_spear:GetModifierBonusStats_Strength()
	return self.bonus_str
end
function modifier_item_red_spear:GetModifierBonusStats_Agility()
	return self.bonus_agi
end
function modifier_item_red_spear:GetModifierBonusStats_Intellect()
	return self.bonus_int
end
function modifier_item_red_spear:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_item_red_spear:OnDestroy()
	if IsServer() then
		if not self.parent or self.parent:IsNull() or not IsValidEntity(self.parent) then
			return nil
		end
		
		self.parent:RemoveModifierByNameAndCaster("modifier_item_red_spear_buff", self.parent)
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_red_spear_buff = modifier_item_red_spear_buff or class({})
function modifier_item_red_spear_buff:IsHidden() return false end
function modifier_item_red_spear_buff:IsDebuff() return false end
function modifier_item_red_spear_buff:IsPurgable() return false end
function modifier_item_red_spear_buff:IsAura() return true end
function modifier_item_red_spear_buff:IsAuraActiveOnDeath() return false end
function modifier_item_red_spear_buff:IsPurgeException() return false end
function modifier_item_red_spear_buff:RemoveOnDeath() return true end
function modifier_item_red_spear_buff:DeclareFunctions()
	local func = {	
                    MODIFIER_EVENT_ON_TAKEDAMAGE,
				}
	return func
end
function modifier_item_red_spear_buff:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	self.mana_drain = self.ability:GetSpecialValueFor("mana_drain")
	self.base_percent = self.ability:GetSpecialValueFor("base_percent")
	self.percent_bonus = self.ability:GetSpecialValueFor("percent_bonus")
	self.percent_limit = self.ability:GetSpecialValueFor("percent_limit")
	self.damage = self.ability:GetSpecialValueFor("damage")
	

	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end
function modifier_item_red_spear_buff:OnTakeDamage(params)
        if not IsServer() then return end 
        -- Get the stack count from modifier_item_red_spear_souls
        local AlphaModifierStacks = self.parent:FindModifierByName("modifier_item_red_spear_souls")
        local TrueStacks = 0
        
		if AlphaModifierStacks then
          TrueStacks = AlphaModifierStacks:GetStackCount()
        end
		
          -- Check if the damage has killed the target
          local FinalHP = params.unit:GetHealth()
          if FinalHP <= 0 and
             params.attacker == self:GetParent() and
             params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		    -- Add the stacks modifier
		    if not self.parent:HasModifier("modifier_item_red_spear_souls") then
              self.parent:AddNewModifier(self.parent, self, "modifier_item_red_spear_souls", {})
			end
			-- Check if the parent has the modifier and increment the stacks
            local iStacksModifier = self.parent:FindModifierByName("modifier_item_red_spear_souls")
            if iStacksModifier then
              local iCurStacks = iStacksModifier:GetStackCount()
              iStacksModifier:SetStackCount(iCurStacks + self.percent_bonus)
            end
          end
		
		-- Set the pure damage chance and perform the necessary checks
		local extra_pure_dmg_chance = self.base_percent + TrueStacks
		local randFloat = RandomFloat(0, 1) <= extra_pure_dmg_chance / 100
		
	    if params.attacker == self:GetParent() and 
		   params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and 
		   randFloat and
           params.unit and params.unit:IsAlive() then
          local hDamageTable = {
            victim = params.unit,
            attacker = self:GetParent(),
            damage = self.damage,
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
          }
          -- Add Crit Particle
          local CritParticle = ParticleManager:CreateParticle("particles/red_spear_crit.vpcf", PATTACH_ABSORIGIN, params.unit)
          ParticleManager:ReleaseParticleIndex(CritParticle)
		  -- Apply the Damage
		  ApplyDamage(hDamageTable)
        end
end
function modifier_item_red_spear_buff:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_red_spear_buff:OnDestroy()
	if IsServer() then
		if self.ability and not self.ability:IsNull() then

			self.ability:StartCooldown(0.1)

			if self.ability:GetToggleState() == true then
				self.ability:ToggleAbility()
			end
		end
	end
end
function modifier_item_red_spear_buff:OnIntervalThink()
	if IsServer() and self.parent:IsRealHero() then
		if not self.ability or self.ability:IsNull() then
			return nil
		end
		
	   local Mana = self.parent:GetMana()
	   local Manamax = self.parent:GetMaxMana()
	   local ManaDrained = Manamax * self.mana_drain / 100
	   
	   if (Mana/Manamax) * 100 < self.mana_drain then
	      if self.ability:GetToggleState() == true then
		    self.ability:ToggleAbility()
		  end
	    end

	   self.parent:Script_ReduceMana( ManaDrained , self:GetAbility())
	end
end
function modifier_item_red_spear_buff:GetEffectName()
	return "particles/red_spear_buff.vpcf"
end
function modifier_item_red_spear_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end







modifier_item_red_spear_souls = modifier_item_red_spear_souls or class({})

--------------------------------------------------------------------------------

function modifier_item_red_spear_souls:IsDebuff() return false end
function modifier_item_red_spear_souls:IsStunDebuff() return false end
function modifier_item_red_spear_souls:IsHidden() return false end
function modifier_item_red_spear_souls:IsPurgable() return false end
function modifier_item_red_spear_souls:RemoveOnDeath() return false end
function modifier_item_red_spear_souls:GetTexture() 
    return "red_spear"
end
