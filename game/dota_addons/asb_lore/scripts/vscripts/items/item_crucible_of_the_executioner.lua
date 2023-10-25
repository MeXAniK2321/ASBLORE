item_crucible_of_the_executioner = item_crucible_of_the_executioner or class({})
LinkLuaModifier("modifier_item_crucible_of_the_executioner", "items/item_crucible_of_the_executioner", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_crucible_of_the_executioner_buff", "items/item_crucible_of_the_executioner", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)


function item_crucible_of_the_executioner:GetIntrinsicModifierName()
	return "modifier_item_crucible_of_the_executioner"
end
function item_crucible_of_the_executioner:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	
	--EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)

    caster:AddNewModifier(caster, self, "modifier_item_crucible_of_the_executioner_buff", {duration = duration})
	caster:AddNewModifier(caster, self, "modifier_item_anime_boombox", {duration = 0.01})
	--EmitGlobalSound("star.theme_12")
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_crucible_of_the_executioner = class({})
function modifier_item_crucible_of_the_executioner:IsHidden() return false end
function modifier_item_crucible_of_the_executioner:IsDebuff() return false end
function modifier_item_crucible_of_the_executioner:IsPurgable() return false end
function modifier_item_crucible_of_the_executioner:IsPurgeException() return false end
function modifier_item_crucible_of_the_executioner:RemoveOnDeath() return false end
function modifier_item_crucible_of_the_executioner:DeclareFunctions()
	local func = {	
	                 MODIFIER_PROPERTY_HEALTH_BONUS,
	                 MODIFIER_EVENT_ON_DEATH,
                     MODIFIER_PROPERTY_MANA_BONUS,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                     MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                     MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		             MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		             MODIFIER_EVENT_ON_TAKEDAMAGE,
			     }
	
	return func
end
function modifier_item_crucible_of_the_executioner:OnTakeDamage(keys)
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
				if self:GetParent():HasModifier("modifier_item_crucible_of_the_executioner_buff") then
				 	self.damage_table = {  victim = keys.unit,
                                     	attacker = self.parent,
                                    	damage = keys.damage * 0.3,
                                   		damage_type = DAMAGE_TYPE_PURE,
                                      	ability = self.ability,
                                      	damage_flags = keys.damage_flags + DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS}
				else
               	self.damage_table = {  victim = keys.unit,
                                     	attacker = self.parent,
                                    	damage = keys.damage * 0.2,
                                   		damage_type = DAMAGE_TYPE_PURE,
                                      	ability = self.ability,
                                      	damage_flags = keys.damage_flags + DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS}
                end
             	ApplyDamage(self.damage_table)
			end
		end
	end
end
function modifier_item_crucible_of_the_executioner:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end
function modifier_item_crucible_of_the_executioner:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_item_crucible_of_the_executioner:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_item_crucible_of_the_executioner:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('int')
end
function modifier_item_crucible_of_the_executioner:GetModifierSpellAmplify_Percentage()
    return self:GetParent():HasItemInInventory("item_yoru")
	       and 0
           or self:GetAbility():GetSpecialValueFor('amp') + math.min(self.kill,self:GetStackCount())
end
function modifier_item_crucible_of_the_executioner:OnCreated( kv )
	self.parent = self:GetParent()
	self.kill = self:GetAbility():GetSpecialValueFor("kill_charges")
	self.ability = self:GetAbility()

	if IsServer() then
		self:SetStackCount(0)
	end
end
function modifier_item_crucible_of_the_executioner:OnRefresh( kv )
	-- get references
	self.kill = self:GetAbility():GetSpecialValueFor("kill_charges")
end
function modifier_item_crucible_of_the_executioner:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
	end
end
function modifier_item_crucible_of_the_executioner:KillLogic( params )
	-- filter
	local target = params.unit
	local attacker = params.attacker
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

	-- logic
	if pass and (not self:GetParent():PassivesDisabled()) then
	   self:AddStack(0)
       local Player = PlayerResource:GetPlayer(target:GetPlayerID())
	   local kills = PlayerResource:GetKills(target:GetPlayerID())
	   local death = PlayerResource:GetDeaths(target:GetPlayerID())
	   if death - kills > 10 then
	   else
		if target:IsRealHero() then
			self:AddStack(1)
		end
		end
    end
end
function modifier_item_crucible_of_the_executioner:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
	if not self:GetParent():HasScepter() then
		if after > self.kill then
			after = self.kill
		end
	else
		if after > self.kill then
			after = self.kill
		end
	end
	self:SetStackCount( after )
end
function modifier_item_crucible_of_the_executioner:GetAbilityTextureName()
    return "crucible"
end

---------------------------------------------------------------------------------------------------------------------
modifier_item_crucible_of_the_executioner_buff = modifier_item_crucible_of_the_executioner_buff or class({})
function modifier_item_crucible_of_the_executioner_buff:IsHidden() return false end
function modifier_item_crucible_of_the_executioner_buff:IsDebuff() return false end
function modifier_item_crucible_of_the_executioner_buff:IsPurgable() return true end
function modifier_item_crucible_of_the_executioner_buff:IsPurgeException() return true end
function modifier_item_crucible_of_the_executioner_buff:RemoveOnDeath() return true end
function modifier_item_crucible_of_the_executioner_buff:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		

		--if not self.parent:HasModifier("modifier_item_bloodstone") then
		for i = 1, 100 do
			StopGlobalSound("star.theme_"..i)
		end
	for i = 1, 4 do
			StopGlobalSound("spd."..i)
		end
		for i = 1, 4 do
			StopGlobalSound("attack."..i)
		end
		for i = 1, 4 do
			StopGlobalSound("armor."..i)
		end
		for i = 1, 4 do
			StopGlobalSound("diff."..i)
		end
			self:StartIntervalThink(2)
		--end
	end
end
function modifier_item_crucible_of_the_executioner_buff:StopAllMusic2()
	if IsServer() then
		

		for i = 1, 49 do
			StopGlobalSound("item_anime_boombox_anime_themes_anime_theme_"..i)
		end

		for i = 1, 47 do
			StopGlobalSound("item_anime_boombox_anime_memes_anime_meme_"..i)
		end
		for i = 1, 26 do
			StopGlobalSound("item_anime_boombox_anime_legends_anime_legend_"..i)
		end
		for i = 1, 3 do
			StopGlobalSound("spd."..i)
		end
		for i = 1, 3 do
			StopGlobalSound("attack."..i)
		end
		for i = 1, 3 do
			StopGlobalSound("armor."..i)
		end
		for i = 1, 3 do
			StopGlobalSound("diff."..i)
		end

		

		
	end
end
function modifier_item_crucible_of_the_executioner_buff:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_crucible_of_the_executioner_buff:GetEffectName()
	return "particles/crucible.vpcf"
end
function modifier_item_crucible_of_the_executioner_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_item_crucible_of_the_executioner_buff:OnDestroy()
	if IsServer() then
		--StopGlobalSound("star.theme_12")
	end
end
function modifier_item_crucible_of_the_executioner_buff:GetAbilityTextureName()
    return "crucible"
end