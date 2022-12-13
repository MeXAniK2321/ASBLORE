item_spamton = class({})
LinkLuaModifier("modifier_item_spamton", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal1", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal2", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hyperlink_blocked", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal3", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal4", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_start", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal5", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_garbage_can", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal6", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal_7", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal8", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal9", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal10", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal_11", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_loh", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal_enemy1", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal_enemy2", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal_enemy3", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal_enemy4", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal_enemy5", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_tier2", "items/modifier_horn_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_tier3","items/modifier_horn_tier3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_event","items/modifier_event", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_event_1","items/modifier_event_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_event_2","items/modifier_event_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_1", "items/modifier_horn_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_2", "items/modifier_horn_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_3", "items/modifier_horn_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_4", "items/modifier_horn_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_5", "items/modifier_horn_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_6", "items/modifier_horn_6", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_7", "items/modifier_horn_7", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_1_1", "items/modifier_horn_1_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_1_2", "items/modifier_horn_1_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doki_doki", "items/modifier_doki_doki", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_truth", "items/modifier_horn_truth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_truth_invul", "items/modifier_horn_truth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_horn_truth_cd", "items/modifier_horn_truth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_abyss_horn_cd", "items/item_abyss_horn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death_cd", "items/modifier_horn_7", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal22", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal32", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal42", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal52", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spamton_deal62", "items/item_spamton", LUA_MODIFIER_MOTION_NONE)
function item_spamton:GetBehavior()
	if self:GetCaster():HasModifier("modifier_item_spamton_start") then
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
		
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function item_spamton:GetIntrinsicModifierName()
	return "modifier_item_spamton"
end
function item_spamton:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local player_id = caster:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(player_id)
	self.tier1 = 10
	self.tier3 = 30
	self.god_tier = 1
	if caster:HasModifier("modifier_hyperlink_blocked") then
	self.modifier = caster:FindModifierByNameAndCaster("modifier_hyperlink_blocked",caster) 
	self.stack = self.modifier:GetStackCount()
	end
	if caster:HasModifier("modifier_item_spamton_start") then
	 self.chance = 30
	if target == caster then
	if self.stack < 20 then
	caster:AddNewModifier(caster, self, "modifier_item_spamton_deal2", {duration = 30})
	EmitSoundOnClient("spamton.deal_10", player)
	self:PlayEffects1()
	self:StartCooldown(70)
	elseif self.stack < 40 and self.stack > 20 or self.stack == 20 then
	caster:AddNewModifier(caster, self, "modifier_item_spamton_deal22", {duration = 35})
	EmitSoundOnClient("spamton.hyperlink_blocked", player)
	self:PlayEffects1()
	self:StartCooldown(75)
	elseif self.stack < 60 and self.stack > 40 or self.stack == 40 then
	caster:AddNewModifier(caster, self, "modifier_item_spamton_deal32", {duration = 40})
	EmitSoundOnClient("spamton.deal_2", player)
	self:PlayEffects1()
	self:StartCooldown(80)
	elseif self.stack < 80 and self.stack > 60 or self.stack == 60 then
	
	caster:AddNewModifier(caster, self, "modifier_item_spamton_deal42", {duration = 45})
	EmitSoundOnClient("spamton.sad", player)
	self:PlayEffects1()
	self:StartCooldown(85)
	elseif self.stack < 100 and self.stack > 80 or self.stack == 80 then
	caster:AddNewModifier(caster, self, "modifier_item_spamton_deal52", {duration = 50})
	EmitSoundOnClient("spamton.deal_6", player)
	self:PlayEffects1()
	self:StartCooldown(90)
	elseif self.stack == 100 then
	caster:AddNewModifier(caster, self, "modifier_item_spamton_deal62", {duration = 60})
 self:PlayEffects2()
 self:StartCooldown(100)
	end
	
	elseif target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
	if self.stack < 20 then
	target:AddNewModifier(caster, self, "modifier_item_spamton_deal1", {duration = 30})
	EmitSoundOnClient("spamton.deal_5_1", player)
	 self:StartCooldown(50)
	elseif self.stack < 40 and self.stack > 20 or self.stack == 20 then
	target:AddNewModifier(caster, self, "modifier_item_spamton_deal_7", {duration = 30})
	EmitSoundOnClient("spamton.deal_7", player)
	 self:StartCooldown(50)
	elseif self.stack < 60 and self.stack > 40 or self.stack == 40 then
	target:AddNewModifier(caster, self, "modifier_item_spamton_deal4", {duration = 30})
	EmitSoundOnClient("spamton.deal_4", player)
	 self:StartCooldown(50)
	elseif self.stack < 80 and self.stack > 60 or self.stack == 60 then
	target:AddNewModifier(caster, self, "modifier_item_spamton_deal9", {duration = 30})
	EmitSoundOnClient("spamton.deal_9", player)
	 self:StartCooldown(50)
	elseif self.stack < 100 and self.stack > 80 or self.stack == 80 then
	target:AddNewModifier(caster, self, "modifier_item_spamton_deal8", {duration = 30})
	EmitSoundOnClient("spamton.deal_8", player)
	 self:StartCooldown(50)
	elseif self.stack == 100 then
	target:AddNewModifier(caster, self, "modifier_item_spamton_deal_11", {duration = 30})
	EmitSoundOnClient("spamton.deal_11", player)
	 self:StartCooldown(70)
	 self:PlayEffects5(target)
	end
	
	
	else
	
		self.damageTable = {
		victim = target,
		attacker = caster,
		damage = 1000,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	
	
	if self.stack < 20 then
	target:AddNewModifier(caster, self, "modifier_item_spamton_deal_enemy3", {duration = 5})
	EmitSoundOnClient("spamton.deal_enemy_2", player)
	 self:StartCooldown(25)

		elseif self.stack < 40 and self.stack > 20 or self.stack == 20 then
		target:AddNewModifier(caster, self, "modifier_item_spamton_deal_enemy2", {duration = 3})
	EmitSoundOnClient("spamton.deal_enemy_3", player)
	 self:StartCooldown(25)
	elseif self.stack < 60 and self.stack > 40 or self.stack == 40 then
		target:AddNewModifier(caster, self, "modifier_item_spamton_deal_enemy1", {duration = 1.5})
	EmitSoundOnClient("spamton.deal_enemy_1", player)
	 self:StartCooldown(25)
	elseif self.stack < 80 and self.stack > 60 or self.stack == 60 then
		target:AddNewModifier(caster, self, "modifier_item_spamton_deal_enemy4", {duration = 1.5})
	EmitSoundOnClient("spamton.deal_enemy_4", player)
	 self:StartCooldown(25)
	elseif self.stack < 100 and self.stack > 80 or self.stack == 80 then
		target:AddNewModifier(caster, self, "modifier_item_spamton_garbage_can", {duration = 3})
	EmitSoundOnClient("spamton.garbage", player)
	 self:StartCooldown(40)
	elseif self.stack == 100 then
		target:AddNewModifier(caster, self, "modifier_item_spamton_loh", {duration = 3})
	EmitSoundOnClient("spamton.garbage_loh", player)
	 self:StartCooldown(40)
	end
	end
	
	else
	caster:AddNewModifier(caster, self, "modifier_item_spamton_start", {})
	caster:AddNewModifier(caster, self, "modifier_hyperlink_blocked", {})
	EmitSoundOnClient("spamton.start", player)
	local radius = 200
	self:PlayEffects(radius)
	self:EndCooldown()
	 self:StartCooldown(10)

end
end
function item_spamton:PlayEffects( radius )

	local particle_cast = "particles/spamton_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function item_spamton:PlayEffects5( target )
   local radius = 500
	local particle_cast = "particles/friendship.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function item_spamton:PlayEffects3( radius , target )

	local particle_cast = "particles/money_mark.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function item_spamton:PlayEffects1( radius )

	local particle_cast = "particles/spamton_big_shot_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function item_spamton:PlayEffects2( radius )

	local particle_cast = "particles/spamton_neo_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
modifier_item_spamton_start = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_spamton_start:IsHidden()
	return false
end

function modifier_item_spamton_start:IsDebuff()
	return false
end

function modifier_item_spamton_start:IsStunDebuff()
	return false
end

function modifier_item_spamton_start:IsPurgable()
	return false
end
function modifier_item_spamton_start:RemoveOnDeath()
	return false
end


function modifier_item_spamton_start:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_item_spamton_start:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,								
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_item_spamton_start:GetTexture()
	return "spamton_face"
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_spamton = class({})
function modifier_item_spamton:IsHidden() return true end
function modifier_item_spamton:IsDebuff() return false end
function modifier_item_spamton:IsPurgable() return false end
function modifier_item_spamton:IsPurgeException() return false end
function modifier_item_spamton:RemoveOnDeath() return false end
function modifier_item_spamton:DeclareFunctions()
	local func = { 	 MODIFIER_PROPERTY_MANA_BONUS,
MODIFIER_PROPERTY_HEALTH_BONUS,	
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,}
	return func
end

function modifier_item_spamton:GetModifierSpellAmplify_Percentage()

return 30
end

function modifier_item_spamton:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('stat')
end
function modifier_item_spamton:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('stat')
end

function modifier_item_spamton:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.strength = self.ability:GetSpecialValueFor("stat")
	self.agility = self.ability:GetSpecialValueFor("stat")
	self.intellect = self.ability:GetSpecialValueFor("stat")
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_spamton_deal1 = class({})

function modifier_item_spamton_deal1:IsHidden()
	return false
end
function modifier_item_spamton_deal1:RemoveOnDeath() return false end
function modifier_item_spamton_deal1:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal1:IsPurgable()
    return false
end

function modifier_item_spamton_deal1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
    }

    return funcs
end

function modifier_item_spamton_deal1:GetModifierHealthBonus()
    return 500
end
function modifier_item_spamton_deal1:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal1:GetEffectName()
	return "particles/spamton_deal1.vpcf"
end

modifier_item_spamton_deal2 = class({})

function modifier_item_spamton_deal2:IsHidden()
	return false
end
function modifier_item_spamton_deal2:RemoveOnDeath() return false end
function modifier_item_spamton_deal2:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal2:IsPurgable()
    return false
end
function modifier_item_spamton_deal2:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
self:StopAllMusic()
	
	if IsServer() then
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	EmitSoundOnClient("spamton.theme_1", Player)

		
			self:StartIntervalThink( 1 )
		end
		end
 function modifier_item_spamton_deal2:OnIntervalThink()

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local caster = self:GetCaster()

	-- damage enemies
	for _,enemy in pairs(enemies) do
		local gold = -25
		local gold2 = 25
	PlayerResource:ModifyGold(enemy:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
	PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(), gold2, false, DOTA_ModifyGold_Unspecified )
	end

	
end
	
function modifier_item_spamton_deal2:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	if IsServer() then
			for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
		  for i = 1, 6  do
			StopSoundOn("horn.hero_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.demon_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.samurai_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("spamton.theme_"..i, Player)
		end
	 for i = 1, 8  do
			StopSoundOn("new.year_theme_"..i, Player)
		end
end

end

function modifier_item_spamton_deal2:OnDestroy(table)
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme_1", Player)
end
function modifier_item_spamton_deal2:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
								  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
MODIFIER_PROPERTY_HEALTH_BONUS,	
		
    }

    return funcs
end

function modifier_item_spamton_deal2:GetModifierSpellAmplify_Percentage()
return 10
end

function modifier_item_spamton_deal2:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal2:GetEffectName()
	return "particles/spamton_tier1.vpcf"
end




--------------------------------------------


modifier_item_spamton_deal22 = class({})

function modifier_item_spamton_deal22:IsHidden()
	return false
end
function modifier_item_spamton_deal22:RemoveOnDeath() return false end
function modifier_item_spamton_deal22:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal22:IsPurgable()
    return false
end
function modifier_item_spamton_deal22:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
self:StopAllMusic()
	
	if IsServer() then
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	EmitSoundOnClient("spamton.theme_2", Player)

		
			self:StartIntervalThink( 1 )
		end
		end
 function modifier_item_spamton_deal22:OnIntervalThink()

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local caster = self:GetCaster()

	-- damage enemies
	for _,enemy in pairs(enemies) do
		local gold = -25
		local gold2 = 25
	PlayerResource:ModifyGold(enemy:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
	PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(), gold2, false, DOTA_ModifyGold_Unspecified )
	end

	
end
	
function modifier_item_spamton_deal22:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	if IsServer() then
			for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
		  for i = 1, 6  do
			StopSoundOn("horn.hero_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.demon_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.samurai_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("spamton.theme_"..i, Player)
		end
	 for i = 1, 8  do
			StopSoundOn("new.year_theme_"..i, Player)
		end
end

end

function modifier_item_spamton_deal22:OnDestroy(table)
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme_2", Player)
end
function modifier_item_spamton_deal22:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
								  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
MODIFIER_PROPERTY_HEALTH_BONUS,	

		
    }

    return funcs
end

function modifier_item_spamton_deal22:GetModifierSpellAmplify_Percentage()
return 15
end
function modifier_item_spamton_deal22:GetModifierHealthBonus()
    return 250
end
function modifier_item_spamton_deal22:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal22:GetEffectName()
	return "particles/spamton_tier2.vpcf"
end








------------------------------------------------------
modifier_item_spamton_deal32 = class({})

function modifier_item_spamton_deal32:IsHidden()
	return false
end
function modifier_item_spamton_deal32:RemoveOnDeath() return false end
function modifier_item_spamton_deal32:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal32:IsPurgable()
    return false
end
function modifier_item_spamton_deal32:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
self:StopAllMusic()
	
	if IsServer() then
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	EmitSoundOnClient("spamton.theme_3", Player)

		
			self:StartIntervalThink( 1 )
		end
		end
 function modifier_item_spamton_deal32:OnIntervalThink()

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local caster = self:GetCaster()

	-- damage enemies
	for _,enemy in pairs(enemies) do
		local gold = -25
		local gold2 = 25
	PlayerResource:ModifyGold(enemy:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
	PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(), gold2, false, DOTA_ModifyGold_Unspecified )
	end

	
end
	
function modifier_item_spamton_deal32:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	if IsServer() then
			for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
		  for i = 1, 6  do
			StopSoundOn("horn.hero_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.demon_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.samurai_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("spamton.theme_"..i, Player)
		end
	 for i = 1, 8  do
			StopSoundOn("new.year_theme_"..i, Player)
		end
end

end

function modifier_item_spamton_deal32:OnDestroy(table)
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme_3", Player)
end
function modifier_item_spamton_deal32:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
								  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
MODIFIER_PROPERTY_HEALTH_BONUS,	
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		
    }

    return funcs
end

function modifier_item_spamton_deal32:GetModifierSpellAmplify_Percentage()
return 20
end
function modifier_item_spamton_deal32:GetModifierMoveSpeedBonus_Constant()

	return 20
	
end
function modifier_item_spamton_deal32:GetModifierHealthBonus()
    return 300
end
function modifier_item_spamton_deal32:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal32:GetEffectName()
	return "particles/spamton_tier3.vpcf"
end




-----------------------------------------

modifier_item_spamton_deal42 = class({})

function modifier_item_spamton_deal42:IsHidden()
	return false
end
function modifier_item_spamton_deal42:RemoveOnDeath() return false end
function modifier_item_spamton_deal42:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal42:IsPurgable()
    return false
end
function modifier_item_spamton_deal42:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
self:StopAllMusic()
self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}

	
	if IsServer() then
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	EmitSoundOnClient("spamton.theme_4", Player)

		
			self:StartIntervalThink( 1 )
		end
		end
 function modifier_item_spamton_deal42:OnIntervalThink()

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local caster = self:GetCaster()

	-- damage enemies
	for _,enemy in pairs(enemies) do
	self.damageTable.damage = 1/100*enemy:GetMaxHealth()
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		local gold = -25
		local gold2 = 25
	PlayerResource:ModifyGold(enemy:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
	PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(), gold2, false, DOTA_ModifyGold_Unspecified )
	end

	
end
	
function modifier_item_spamton_deal42:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	if IsServer() then
			for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
		  for i = 1, 6  do
			StopSoundOn("horn.hero_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.demon_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.samurai_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("spamton.theme_"..i, Player)
		end
	 for i = 1, 8  do
			StopSoundOn("new.year_theme_"..i, Player)
		end
end

end

function modifier_item_spamton_deal42:OnDestroy(table)
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme_4", Player)
end
function modifier_item_spamton_deal42:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
								  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
MODIFIER_PROPERTY_HEALTH_BONUS,	
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		
    }

    return funcs
end

function modifier_item_spamton_deal42:GetModifierSpellAmplify_Percentage()
return 25
end
function modifier_item_spamton_deal42:GetModifierMoveSpeedBonus_Constant()

	return 25
	
end
function modifier_item_spamton_deal42:GetModifierHealthBonus()
    return 350
end
function modifier_item_spamton_deal42:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal42:GetEffectName()
	return "particles/spamton_tier4.vpcf"
end




-----------------------------------------------------

modifier_item_spamton_deal52 = class({})

function modifier_item_spamton_deal52:IsHidden()
	return false
end
function modifier_item_spamton_deal52:RemoveOnDeath() return false end
function modifier_item_spamton_deal52:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal52:IsPurgable()
    return false
end
function modifier_item_spamton_deal52:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
self:StopAllMusic()
self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}

	
	if IsServer() then
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	EmitSoundOnClient("spamton.theme_5", Player)

		
			self:StartIntervalThink( 1 )
		end
		end
 function modifier_item_spamton_deal52:OnIntervalThink()

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local caster = self:GetCaster()

	-- damage enemies
	for _,enemy in pairs(enemies) do
	self.damageTable.damage = 1.5/100*enemy:GetMaxHealth()
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		local gold = -40
		local gold2 = 40
	PlayerResource:ModifyGold(enemy:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
	PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(), gold2, false, DOTA_ModifyGold_Unspecified )
	end

	
end
	
function modifier_item_spamton_deal52:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	if IsServer() then
			for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
		  for i = 1, 6  do
			StopSoundOn("horn.hero_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.demon_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.samurai_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("spamton.theme_"..i, Player)
		end
	 for i = 1, 8  do
			StopSoundOn("new.year_theme_"..i, Player)
		end
end

end

function modifier_item_spamton_deal52:OnDestroy(table)
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.theme_5", Player)
end
function modifier_item_spamton_deal52:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
								  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
MODIFIER_PROPERTY_HEALTH_BONUS,	
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		
    }

    return funcs
end

function modifier_item_spamton_deal52:GetModifierSpellAmplify_Percentage()
return 30
end
function modifier_item_spamton_deal52:GetModifierMoveSpeedBonus_Constant()

	return 30
	
end
function modifier_item_spamton_deal52:GetModifierHealthBonus()
    return 400
end
function modifier_item_spamton_deal52:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal52:GetEffectName()
	return "particles/spamton_tier5.vpcf"
end


---------------------------


modifier_item_spamton_deal62 = class({})

function modifier_item_spamton_deal62:IsHidden()
	return false
end
function modifier_item_spamton_deal62:RemoveOnDeath() return false end
function modifier_item_spamton_deal62:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal62:IsPurgable()
    return false
end
function modifier_item_spamton_deal62:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
self:StopAllMusic()
self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}

	
	if IsServer() then

	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	EmitSoundOnClient("spamton.theme_6", Player)

		
			self:StartIntervalThink( 1 )
		end
		end
		
function modifier_item_spamton_deal62:StopAllMusic()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	if IsServer() then
			for i = 1, 30 do
			StopSoundOn("star.theme_"..i, Player)
		end
		  for i = 1, 6  do
			StopSoundOn("horn.hero_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.demon_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("horn.samurai_"..i, Player)
		end
		 for i = 1, 6  do
			StopSoundOn("spamton.theme_"..i, Player)
		end
	 for i = 1, 8  do
			StopSoundOn("new.year_theme_"..i, Player)
		end
end

end
 function modifier_item_spamton_deal62:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local caster = self:GetCaster()

	-- damage enemies
	for _,enemy in pairs(enemies) do
	self.damageTable.damage = 1.5/100*enemy:GetMaxHealth()
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		local gold = -40
		local gold2 = 40
	PlayerResource:ModifyGold(enemy:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
	PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(), gold2, false, DOTA_ModifyGold_Unspecified )
	end

	
end
	

function modifier_item_spamton_deal62:OnDestroy(table)

	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	StopSoundOn("spamton.theme_6", Player)
end
function modifier_item_spamton_deal62:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
								  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
MODIFIER_PROPERTY_HEALTH_BONUS,	
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	   MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		
    }

    return funcs
end

function modifier_item_spamton_deal62:GetModifierSpellAmplify_Percentage()
return 40
end
function modifier_item_spamton_deal62:GetModifierMoveSpeedBonus_Constant()

	return 35
	
end
function modifier_item_spamton_deal62:GetModifierHealthBonus()
    return 500
end
  function modifier_item_spamton_deal62:GetModifierPhysicalArmorBonus()
return 5
end   

function modifier_item_spamton_deal62:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal62:GetEffectName()
	return "particles/spamton_tier6.vpcf"
end


modifier_item_spamton_deal_11 = class({})

function modifier_item_spamton_deal_11:IsHidden()
	return false
end
function modifier_item_spamton_deal_11:RemoveOnDeath() return true end
function modifier_item_spamton_deal_11:AllowIllusionDuplicate()
	return true
end
function modifier_item_spamton_deal_11:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()

	
	if IsServer() then
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	EmitSoundOnClient("spamton.friendship_theme", Player)

		
			
		end
		end
	


function modifier_item_spamton_deal_11:OnDestroy(table)
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
StopSoundOn("spamton.friendship_theme", Player)
end

function modifier_item_spamton_deal_11:IsPurgable()
    return false
end
function modifier_item_spamton_deal_11:CheckState()
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end

function modifier_item_spamton_deal_11:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,	
MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,  					
       
        
		
    }

    return funcs
end
function modifier_item_spamton_deal_11:GetModifierHealthRegenPercentage()
    return 1.5
end
function modifier_item_spamton_deal_11:GetModifierBonusStats_Strength()
	return 25
end
function modifier_item_spamton_deal_11:GetModifierBonusStats_Agility()
	return 25
end
function modifier_item_spamton_deal_11:GetModifierBonusStats_Intellect()
	return 25
end
	function modifier_item_spamton_deal_11:GetModifierSpellAmplify_PercentageUnique()
    return 15
end

function modifier_item_spamton_deal_11:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal_11:GetEffectName()
	return "particles/spamton_deal_11.vpcf"
end


modifier_hyperlink_blocked = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hyperlink_blocked:IsHidden()
	return false
end

function modifier_hyperlink_blocked:IsDebuff()
	return false
end

function modifier_hyperlink_blocked:IsStunDebuff()
	return false
end

function modifier_hyperlink_blocked:IsPurgable()
	return false
end
function modifier_hyperlink_blocked:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_hyperlink_blocked:OnCreated( kv )
self.kill = 100
	if IsServer() then
		self:SetStackCount(1)
		self:StartIntervalThink(6)
	end
end
function modifier_hyperlink_blocked:OnIntervalThink()
self:AddStack(1)
end
function modifier_hyperlink_blocked:OnRefresh( kv )

	local max_stack = 100

	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
	end
end

function modifier_hyperlink_blocked:OnDestroy( kv )

end

function modifier_hyperlink_blocked:GetTexture()
	return "spamton_face"
end
function modifier_hyperlink_blocked:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
		if after > self.kill then
			after = self.kill
		end
	self:SetStackCount( after )
end
modifier_item_spamton_deal3 = class({})

function modifier_item_spamton_deal3:IsHidden()
	return false
end
function modifier_item_spamton_deal3:RemoveOnDeath() return false end
function modifier_item_spamton_deal3:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal3:IsPurgable()
    return false
end

function modifier_item_spamton_deal3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		
    }

    return funcs
end
function modifier_item_spamton_deal3:GetModifierHealthBonus()
    return 500
end
function modifier_item_spamton_deal3:GetModifierMoveSpeedBonus_Constant()

	return 25
	end



function modifier_item_spamton_deal3:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal3:GetEffectName()
	return "particles/spamton_deal3.vpcf"
end

modifier_item_spamton_deal4 = class({})

function modifier_item_spamton_deal4:IsHidden()
	return false
end
function modifier_item_spamton_deal4:RemoveOnDeath() return false end
function modifier_item_spamton_deal4:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal4:IsPurgable()
    return false
end

function modifier_item_spamton_deal4:DeclareFunctions()
    local funcs = {
            	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		
    }

    return funcs
end

function modifier_item_spamton_deal4:GetBonusNightVision()
    return 250
end
function modifier_item_spamton_deal4:GetBonusDayVision()

    return 250

end



function modifier_item_spamton_deal4:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal4:GetEffectName()
	return "particles/spamton_deal4.vpcf"
end


modifier_item_spamton_deal_enemy1 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_spamton_deal_enemy1:IsHidden()
	return false
end

function modifier_item_spamton_deal_enemy1:IsDebuff()
	return true
end

function modifier_item_spamton_deal_enemy1:IsStunDebuff()
	return false
end

function modifier_item_spamton_deal_enemy1:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_spamton_deal_enemy1:OnCreated( kv )
	
	
		

end


function modifier_item_spamton_deal_enemy1:OnRefresh( kv )
end

function modifier_item_spamton_deal_enemy1:OnRemoved()
	
end

function modifier_item_spamton_deal_enemy1:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_item_spamton_deal_enemy1:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_item_spamton_deal_enemy1:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal_enemy1:GetEffectName()
	return "particles/spamton_deal_enemy1.vpcf"
end

modifier_item_spamton_deal_enemy2 = class({})

function modifier_item_spamton_deal_enemy2:IsHidden()
	return false
end
function modifier_item_spamton_deal_enemy2:RemoveOnDeath() return false end
function modifier_item_spamton_deal_enemy2:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal_enemy2:IsPurgable()
    return false
end

function modifier_item_spamton_deal_enemy2:DeclareFunctions()
    local funcs = {
         	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
		
    }

    return funcs
end

function modifier_item_spamton_deal_enemy2:GetBonusNightVision()
    return -500
end
function modifier_item_spamton_deal_enemy2:GetBonusDayVision()

    return -500

end



function modifier_item_spamton_deal_enemy2:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal_enemy2:GetEffectName()
	return "particles/spamton_deal_enemy2.vpcf"
end

modifier_item_spamton_deal_enemy3 = class({})

function modifier_item_spamton_deal_enemy3:IsHidden()
	return false
end
function modifier_item_spamton_deal_enemy3:RemoveOnDeath() return true end
function modifier_item_spamton_deal_enemy3:AllowIllusionDuplicate()
	return true
end

function modifier_item_spamton_deal_enemy3:IsPurgable()
    return false
end

function modifier_item_spamton_deal_enemy3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,  		
       
        
		
    }

    return funcs
end

function modifier_item_spamton_deal_enemy3:GetModifierPhysicalArmorBonus()
    return -10
end
function modifier_item_spamton_deal_enemy3:GetModifierMagicalResistanceBonus()
    return -15
end

function modifier_item_spamton_deal_enemy3:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal_enemy3:GetEffectName()
	return "particles/spamton_deal_enemy3.vpcf"
end


modifier_item_spamton_deal_enemy4 = class({})

--------------------------------------------------------------------------------

function modifier_item_spamton_deal_enemy4:IsDebuff()
	return true
end

function modifier_item_spamton_deal_enemy4:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_spamton_deal_enemy4:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_item_spamton_deal_enemy4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_item_spamton_deal_enemy4:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_item_spamton_deal_enemy4:GetEffectName()
	return "particles/spamton_deal_debuff4.vpcf"
end

function modifier_item_spamton_deal_enemy4:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_item_spamton_deal_enemy4:GetTexture()
	return "spamton_face"
end


modifier_item_spamton_deal_7 = class({})

function modifier_item_spamton_deal_7:IsHidden()
	return false
end
function modifier_item_spamton_deal_7:RemoveOnDeath() return true end
function modifier_item_spamton_deal_7:AllowIllusionDuplicate()
	return true
end

function modifier_item_spamton_deal_7:IsPurgable()
    return false
end

function modifier_item_spamton_deal_7:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,		
       
        
		
    }

    return funcs
end

function modifier_item_spamton_deal_7:GetModifierIncomingDamage_Percentage( params )
	

		return -10
end
	function modifier_item_spamton_deal_7:GetModifierSpellAmplify_PercentageUnique()
    return 10
end

function modifier_item_spamton_deal_7:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal_7:GetEffectName()
	return "particles/spamton_deal_7.vpcf"
end

modifier_item_spamton_deal8 = class({})

function modifier_item_spamton_deal8:IsHidden()
	return false
end
function modifier_item_spamton_deal8:RemoveOnDeath() return false end
function modifier_item_spamton_deal8:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal8:IsPurgable()
    return false
end

function modifier_item_spamton_deal8:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		  MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		          MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
		
    }

    return funcs
end
function modifier_item_spamton_deal8:GetModifierTurnRate_Percentage()
    return 50
end
function modifier_item_spamton_deal8:GetModifierMoveSpeedBonus_Constant()

	return 45
	end
	function modifier_item_spamton_deal8:GetModifierSpellAmplify_PercentageUnique()
    return 15
end
function modifier_item_spamton_deal8:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal8:GetEffectName()
	return "particles/spamton_deal8.vpcf"
end

modifier_item_spamton_deal_enemy5 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_spamton_deal_enemy5:IsHidden()
	return false
end

function modifier_item_spamton_deal_enemy5:IsDebuff()
	return true
end

function modifier_item_spamton_deal_enemy5:IsStunDebuff()
	return false
end

function modifier_item_spamton_deal_enemy5:IsPurgable()
	return true
end

function modifier_item_spamton_deal_enemy5:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_spamton_deal_enemy5:OnCreated( kv )
	-- references
	self.duration = 4.4
	self.damage = 4000

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
end

function modifier_item_spamton_deal_enemy5:OnRefresh( kv )
	
end

function modifier_item_spamton_deal_enemy5:OnRemoved()
end

function modifier_item_spamton_deal_enemy5:OnDestroy()
end


function modifier_item_spamton_deal_enemy5:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_item_spamton_deal_enemy5:Silence()
	-- add silence
	
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_stunned", -- modifier name
		{ duration = 9 } -- kv
	)
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_item_spamton_loh", -- modifier name
		{ duration = 8 } -- kv
	)

	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_item_spamton_deal_enemy5:GetEffectName()
	return "particles/ebat_loh_debuff.vpcf"
end

function modifier_item_spamton_deal_enemy5:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

modifier_item_spamton_loh = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_spamton_loh:IsHidden()
	return false
end

function modifier_item_spamton_loh:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_item_spamton_loh:IsStunDebuff()
	return true
end

function modifier_item_spamton_loh:IsPurgable()
	return true
end

function modifier_item_spamton_loh:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_spamton_loh:OnCreated( kv )
	-- references
	local damage = 1500
	self.radius = 150
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- play effects
	self:GetParent():AddNoDraw()
	self:PlayEffects()
	
end


function modifier_item_spamton_loh:OnRefresh( kv )
	-- references
	local damage = 1500
	self.radius = 150

	if not IsServer() then return end
	self.damageTable.damage = damage
end

function modifier_item_spamton_loh:OnRemoved()
end

function modifier_item_spamton_loh:OnDestroy()
	if not IsServer() then return end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play overhead event
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
			self:GetParent(),
			self.damageTable.damage,
			nil
		)
	end
	

	-- play effects
	self:GetParent():RemoveNoDraw()
	

	local sound_cast = "spamton.trash_explosion"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	local caster = self:GetCaster()
	local knockback = { should_stun = 1,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 0,
                        knockback_height = 300,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    self:GetParent():AddNewModifier(caster, self, "modifier_knockback", knockback)
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_item_spamton_loh:CheckState()
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
function modifier_item_spamton_loh:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/loh_garbage.vpcf"
	local particle_cast2 = ""
	
	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end
function modifier_item_spamton_loh:PlayEffects2()
	-- Get Resources
	local particle_cast1 = "particles/ebat_loh_explosion.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end

modifier_item_spamton_garbage_can = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_spamton_garbage_can:IsHidden()
	return false
end

function modifier_item_spamton_garbage_can:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_item_spamton_garbage_can:IsStunDebuff()
	return true
end

function modifier_item_spamton_garbage_can:IsPurgable()
	return true
end

function modifier_item_spamton_garbage_can:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_spamton_garbage_can:OnCreated( kv )
	-- references
	local damage = 2000
	self.radius = 150
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- play effects
	self:GetParent():AddNoDraw()
	self:PlayEffects()
	
end


function modifier_item_spamton_garbage_can:OnRefresh( kv )
	-- references
	local damage = 750
	self.radius = 150

	if not IsServer() then return end
	self.damageTable.damage = damage
end

function modifier_item_spamton_garbage_can:OnRemoved()
end

function modifier_item_spamton_garbage_can:OnDestroy()
	if not IsServer() then return end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play overhead event
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
			self:GetParent(),
			self.damageTable.damage,
			nil
		)
	end
	

	-- play effects
	self:GetParent():RemoveNoDraw()
	

	local sound_cast = "spamton.trash_explosion"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	local caster = self:GetCaster()
	local knockback = { should_stun = 1,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 0,
                        knockback_height = 300,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    self:GetParent():AddNewModifier(caster, self, "modifier_knockback", knockback)
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_item_spamton_garbage_can:CheckState()
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
function modifier_item_spamton_garbage_can:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/spamton_trash_can.vpcf"
	local particle_cast2 = ""
	
	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end
function modifier_item_spamton_garbage_can:PlayEffects2()
	-- Get Resources
	local particle_cast1 = "particles/homura_grenade_explosion.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end




modifier_item_spamton_deal9 = class({})

function modifier_item_spamton_deal9:IsHidden()
	return false
end
function modifier_item_spamton_deal9:RemoveOnDeath() return true end
function modifier_item_spamton_deal9:AllowIllusionDuplicate()
	return true
end

function modifier_item_spamton_deal9:IsPurgable()
    return false
end

function modifier_item_spamton_deal9:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

       
        
		
    }

    return funcs
end

function modifier_item_spamton_deal9:GetModifierPhysicalArmorBonus()
    return 10
end
function modifier_item_spamton_deal9:GetModifierMagicalResistanceBonus()
    return 10
end
function modifier_item_spamton_deal9:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal9:GetEffectName()
	return "particles/spamton_deal9.vpcf"
end






modifier_item_spamton_deal10 = class({})

function modifier_item_spamton_deal10:IsHidden()
	return false
end
function modifier_item_spamton_deal10:RemoveOnDeath() return false end
function modifier_item_spamton_deal10:AllowIllusionDuplicate()
	return false
end

function modifier_item_spamton_deal10:IsPurgable()
    return false
end
function modifier_item_spamton_deal10:OnCreated(table)
local interval = 1
self:StartIntervalThink( interval )
end
function modifier_item_spamton_deal10:OnIntervalThink()
self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	-- update damage
	self.damageTable.damage = 2/100*self:GetParent():GetHealth()


	ApplyDamage( self.damageTable )
	
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = 100,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		
	}
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	for _,enemy in pairs(enemies) do
		-- Apply damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		end
end
function modifier_item_spamton_deal10:DeclareFunctions()
    local funcs = {
            	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		
    }

    return funcs
end

function modifier_item_spamton_deal10:GetBonusNightVision()
    return 200
end
function modifier_item_spamton_deal10:GetBonusDayVision()

    return 200

end



function modifier_item_spamton_deal10:GetTexture()
	return "spamton_face"
end
function modifier_item_spamton_deal10:GetEffectName()
	return "particles/spamton_deal10.vpcf"
end




