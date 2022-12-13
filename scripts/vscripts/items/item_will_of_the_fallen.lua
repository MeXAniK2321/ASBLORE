item_will_of_the_fallen = class({})
LinkLuaModifier("modifier_will_of_the_fallen", "items/item_will_of_the_fallen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_will_of_the_fallen_base", "items/item_will_of_the_fallen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_will_of_the_fallen_advanced", "items/item_will_of_the_fallen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_will_of_the_fallen_count", "items/item_will_of_the_fallen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_will_of_the_fallen_cd", "items/item_will_of_the_fallen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_will_of_the_fallen_aura", "items/item_will_of_the_fallen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_will_of_the_fallen_int_overflow", "items/item_will_of_the_fallen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_will_of_the_fallen_ultimate", "items/item_will_of_the_fallen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_will_of_the_fallen_slow", "items/item_will_of_the_fallen", LUA_MODIFIER_MOTION_NONE)


function item_will_of_the_fallen:GetIntrinsicModifierName()
	return "modifier_will_of_the_fallen"
end
function item_will_of_the_fallen:OnSpellStart()
if IsServer() then
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local modifier = caster:FindModifierByNameAndCaster("modifier_will_of_the_fallen_count",caster)
		if modifier == nil then return end
	local current = modifier:GetStackCount()
	if current > 199 or current  == 200 then
	modifier:SetStackCount(0)
	_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")	
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	_G.CurrentMusicUltima = "will_of_the_fallen.ultimate"
_G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 80})
	caster:AddNewModifier(caster, self, "modifier_will_of_the_fallen_ultimate", {duration = 83})
	caster:AddNewModifier(caster, self, "modifier_will_of_the_fallen_advanced_invul", {duration = 3})
		self:StartCooldown(120)
	elseif current > 125 and current < 199 then
	modifier:SetStackCount(current - 25)
if not _G.MusicBox:HasModifier("modifier_star_tier2") then
	if not _G.MusicBox:HasModifier("modifier_star_tier3") then
	if _G.MusicBox:HasModifier("modifier_star_tier1") then
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	end
	_G.TicketTrack = "will_of_the_fallen.inspired_theme"
	_G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier1", {duration = 40})
	end
	end
	
	caster:AddNewModifier(caster, self, "modifier_will_of_the_fallen_advanced", {duration = 40})
	caster:AddNewModifier(caster, self, "modifier_will_of_the_fallen_advanced_invul", {duration = 3})
	self:StartCooldown(80)
	else
EmitSoundOn("will.base", caster)

	  caster:AddNewModifier(caster, self, "modifier_will_of_the_fallen_base", {duration = 20})
	end
	end
	end
	

	
	modifier_will_of_the_fallen_count = class({})
function modifier_will_of_the_fallen_count:IsHidden() return false end
function modifier_will_of_the_fallen_count:IsDebuff() return false end
function modifier_will_of_the_fallen_count:IsPurgable() return false end
function modifier_will_of_the_fallen_count:IsPurgeException() return false end
function modifier_will_of_the_fallen_count:RemoveOnDeath() return false end

function modifier_will_of_the_fallen_count:OnCreated( kv )
	-- get references
	self.kill = 200
	

	if IsServer() then
		self:SetStackCount(0)

	self:StartIntervalThink(5)
end
end

function modifier_will_of_the_fallen_count:OnIntervalThink( kv )
if IsServer() then
self:AddStack(1)
end
end
function modifier_will_of_the_fallen_count:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,

	}

	return funcs
end
function modifier_will_of_the_fallen_count:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
	end
end

function modifier_will_of_the_fallen_count:KillLogic( params )
      
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
		-- check if it is a hero
		if target:IsRealHero() then
		
		self:AddStack(10)	
	
		end

		end
	end
function modifier_will_of_the_fallen_count:OnRefresh( kv )

	local max_stack = 200

end

function modifier_will_of_the_fallen_count:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
		if after > self.kill then
			after = self.kill
		end
	self:SetStackCount( after )
end
function modifier_will_of_the_fallen_count:GetAbilityTextureName()
	
	return "will_of_the_fallen"
end

modifier_will_of_the_fallen = class({})


function modifier_will_of_the_fallen:IsHidden()
    return true
end
function modifier_will_of_the_fallen:RemoveOnDeath() return false end
function modifier_will_of_the_fallen:IsPurgable()
    return false
end
function modifier_will_of_the_fallen:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		--self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_will_of_the_fallen_count", {})
	end
end



function modifier_will_of_the_fallen:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		   MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		   MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		   MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		   MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		   

	
    }

    return funcs
end

--function modifier_will_of_the_fallen:GetModifierDamageOutgoing_Percentage()
	--return -90
--end
function modifier_will_of_the_fallen:GetModifierCastRangeBonus()
	return 150
end
function modifier_will_of_the_fallen:OnTakeDamage(keys)
	if IsServer() then
	local caster = self:GetCaster()
	local rng = 100
	local damage = keys.original_damage
	if RollPercentage(rng) and damage > 350 then
	if not self:GetParent():HasModifier("modifier_will_of_the_fallen_cd") then
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
               
               local damage_type = keys.damage_type
			   if damage_type == DAMAGE_TYPE_MAGICAL then
			   local int = self:GetParent():GetIntellect()
			   local damageTable = {
				victim			= keys.unit,
				damage			= int,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker		= self:GetParent(),
				ability			= self:GetAbility()
			}
			ApplyDamage(damageTable)
	
			local target = keys.unit
					EmitSoundOn("fallen.slash", target)
			if self:GetParent():HasModifier("modifier_will_of_the_fallen_advanced") then
			keys.unit:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_int_overflow", {duration = 10})
			 keys.unit:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_slow", {duration = 2})
			  caster:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_cd", {duration = 1.3})
			  self:PlayEffects2(target)
			elseif self:GetParent():HasModifier("modifier_will_of_the_fallen_ultimate") then
			 keys.unit:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_int_overflow", {duration = 10})
			 	 keys.unit:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_slow", {duration = 2})
			  caster:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_cd", {duration = 1.3})
			  self:PlayEffects3(target)
			  self.parent:Heal( int * 0.5, self:GetParent() )
			else
			    caster:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_cd", {duration = 1.3})
				keys.unit:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_int_overflow", {duration = 10})
				self:PlayEffects(target)
			   end
			   end
			end
		end
		end
	end
	end
	end
function modifier_will_of_the_fallen:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/white_slash.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_will_of_the_fallen:PlayEffects3( target )
	-- Load effects
	local particle_cast = "particles/galaxy_slash.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_will_of_the_fallen:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/gold_slash.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_will_of_the_fallen:GetModifierBonusStats_Intellect()

    return self:GetAbility():GetSpecialValueFor('int')
end
function modifier_will_of_the_fallen:GetModifierHealthBonus()
if self:GetParent():HasItemInInventory("item_yoru") then
return 0
else
    return self:GetAbility():GetSpecialValueFor('hp')
end
end

--function modifier_will_of_the_fallen:IsAura()
	--return true
--end

--function modifier_will_of_the_fallen:GetModifierAura()
	--return "modifier_will_of_the_fallen_aura"
--end

--function modifier_will_of_the_fallen:GetAuraSearchTeam()
	--return DOTA_UNIT_TARGET_TEAM_ENEMY
--end

--------------------------------------------------------------------------------

--function modifier_will_of_the_fallen:GetAuraSearchType()
	--return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
--end


--function modifier_will_of_the_fallen:GetAuraRadius()
	--return 99999
--end






modifier_will_of_the_fallen_slow = class({})

--------------------------------------------------------------------------------

function modifier_will_of_the_fallen_slow:IsDebuff()
	return true
end

function modifier_will_of_the_fallen_slow:IsStunDebuff()
	return false
end
function modifier_will_of_the_fallen_slow:IsHidden()
	return false
end
function modifier_will_of_the_fallen_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_will_of_the_fallen_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_will_of_the_fallen_slow:GetModifierMoveSpeedBonus_Percentage()
	return -25
end

--------------------------------------------------------------------------------

function modifier_will_of_the_fallen_slow:GetEffectName()
	return "particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf"
end

function modifier_will_of_the_fallen_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_will_of_the_fallen_int_overflow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_will_of_the_fallen_int_overflow:IsHidden()
	return false
end

function modifier_will_of_the_fallen_int_overflow:IsDebuff()
	return true
end

function modifier_will_of_the_fallen_int_overflow:IsStunDebuff()
	return false
end

function modifier_will_of_the_fallen_int_overflow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_will_of_the_fallen_int_overflow:OnCreated( kv )
	-- references

	if IsServer() then
		self:SetStackCount(1)
	
	local int2 = self:GetCaster():GetIntellect()
	local stack = self:GetStackCount()
self.damage = int2 * 0.2
 local damageTable = {
				victim			= self:GetParent(),
				damage			= self.damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				attacker		= self:GetCaster(),
				ability			= self:GetAbility()
			}
			ApplyDamage(damageTable)
end
end

function modifier_will_of_the_fallen_int_overflow:OnRefresh( kv )
	-- references
	
	local max_stack = 10

	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
	
	local int2 = self:GetCaster():GetIntellect()
	local stack = self:GetStackCount() * int2
self.damage = stack * 0.2
 local damageTable = {
				victim			= self:GetParent(),
				damage			= self.damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				attacker		= self:GetCaster(),
				ability			= self:GetAbility()
			}
			ApplyDamage(damageTable)
end
end

function modifier_will_of_the_fallen_int_overflow:OnDestroy( kv )

end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_will_of_the_fallen_int_overflow:GetEffectName()
	return "particles/econ/events/spring_2021/high_five_spring_2021_travel_overhead_flames.vpcf"
end

function modifier_will_of_the_fallen_int_overflow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end




modifier_will_of_the_fallen_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_will_of_the_fallen_aura:IsHidden()
	return true
end

function modifier_will_of_the_fallen_aura:IsDebuff()
	return false
end

function modifier_will_of_the_fallen_aura:IsStunDebuff()
	return false
end

function modifier_will_of_the_fallen_aura:IsPurgable()
	return false
end

function modifier_will_of_the_fallen_aura:RemoveOnDeath()
	return false
end

function modifier_will_of_the_fallen_aura:DeclareFunctions()
    local func = {  
    				
                    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,	
				}
    return func
end

function modifier_will_of_the_fallen_aura:GetModifierIncomingDamage_Percentage( params )
if self:GetParent():IsNeutralUnitType() then
local damage_type = params.damage_type
if damage_type == DAMAGE_TYPE_MAGICAL and params.attacker:HasItemInInventory("item_will_of_the_fallen") and not self:GetParent():HasModifier("modifier_item_sad_vodoo_doll_debuff")  then
   
		return 20
		else 
		
		return 0
		end
	end
end	







                
modifier_will_of_the_fallen_base = class({})

function modifier_will_of_the_fallen_base:IsHidden()
	return true
end
function modifier_will_of_the_fallen_base:RemoveOnDeath() return true end
function modifier_will_of_the_fallen_base:AllowIllusionDuplicate()
	return false
end

function modifier_will_of_the_fallen_base:IsPurgable()
    return false
end
function modifier_will_of_the_fallen_base:OnCreated()
if IsServer() then
self.int = self:GetCaster():GetIntellect() * 0.8
self.parent = self:GetParent()
            self.shit_time1 =    ParticleManager:CreateParticle("particles/will_of_the_fallen_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    
self:PlayEffects(400)
   self:StartIntervalThink(1)
end
end
function modifier_will_of_the_fallen_base:OnIntervalThink()
if IsServer() then
local int = self:GetParent():GetIntellect()
self.damageTable = {
		attacker = self:GetCaster(),
		damage = int * 2,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	local heroes = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		550,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,hero in pairs(heroes) do
		-- apply damage
		if hero:GetUnitName()== "npc_dota_demon_tower" or hero:GetUnitName()== "npc_dota_human_tower" or hero:GetUnitName()== "npc_dota_elf_tower" or hero:GetUnitName()== "npc_dota_necro_tower" then
		self.damageTable.victim = hero
		ApplyDamage( self.damageTable )

		-- play overhead event
		end
		end
		end
	end
	function modifier_will_of_the_fallen_base:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_clinkz/clinkz_burning_army_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
	
function modifier_will_of_the_fallen_base:OnDestroy()
if IsServer() then
if self.shit_time1 then
 ParticleManager:DestroyParticle(self.shit_time1, false)
        ParticleManager:ReleaseParticleIndex(self.shit_time1)
		end
		
end
end
function modifier_will_of_the_fallen_base:DeclareFunctions()
    local funcs = {
   MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
    }

    return funcs
end

function modifier_will_of_the_fallen_base:GetModifierBonusStats_Intellect()
    return 150
end

function modifier_will_of_the_fallen_base:PlayEffects( radius )

	local particle_cast = "particles/will_of_the_fallen_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end



modifier_will_of_the_fallen_advanced = class({})
function modifier_will_of_the_fallen_advanced:IsHidden() return false end
function modifier_will_of_the_fallen_advanced:IsDebuff() return true end
function modifier_will_of_the_fallen_advanced:IsPurgable() return false end
function modifier_will_of_the_fallen_advanced:IsPurgeException() return false end
function modifier_will_of_the_fallen_advanced:RemoveOnDeath() return true end
function modifier_will_of_the_fallen_advanced:AllowIllusionDuplicate() return false end

function modifier_will_of_the_fallen_advanced:DeclareFunctions()
    local func = {  
	                 MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
				
                    				}
    return func
end
function modifier_will_of_the_fallen_advanced:GetModifierBonusStats_Intellect()
    return 225
end

function modifier_will_of_the_fallen_advanced:OnCreated(table)
if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
self.int = self:GetParent():GetIntellect() * 1.75
    self.ability_level = self.ability:GetLevel()
 self.ability:StartCooldown(80)
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/will_of_the_fallen_advance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end  
		
		
        self:StartIntervalThink(1)
self:PlayEffects3(self:GetParent():GetOrigin(),500,2)
        self.parent:Purge(false, true, false, true, true)
    end
	end
end
function modifier_will_of_the_fallen_advanced:OnIntervalThink()
if IsServer() then
local int = self:GetParent():GetIntellect()
self.damageTable = {
		attacker = self:GetCaster(),
		damage = int * 2,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	local heroes = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		550,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,hero in pairs(heroes) do
		-- apply damage
		if hero:GetUnitName()== "npc_dota_demon_tower" or hero:GetUnitName()== "npc_dota_human_tower" or hero:GetUnitName()== "npc_dota_elf_tower" or hero:GetUnitName()== "npc_dota_necro_tower" then
		self.damageTable.victim = hero
		ApplyDamage( self.damageTable )

		-- play overhead event
		end
		end
		end
	end
function modifier_will_of_the_fallen_advanced:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_will_of_the_fallen_advanced:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
           
          
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
local caster = self:GetCaster()
            end
        end
		end
		
	function modifier_will_of_the_fallen_advanced:PlayEffects3( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/will_of_the_fallen_start2.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

function modifier_will_of_the_fallen_advanced:AddStack( value )
	local current = self:GetStackCount()
	self.kill = 5
	local after = current + value
		if after > self.kill then
			after = self.kill
		end
	self:SetStackCount( after )
end
function modifier_will_of_the_fallen_advanced:GetAbilityTextureName()
	
	return "will_of_the_fallen"
end
   
   
   modifier_will_of_the_fallen_cd = class({})
function modifier_will_of_the_fallen_cd:IsHidden() return false end
function modifier_will_of_the_fallen_cd:IsDebuff() return false end
function modifier_will_of_the_fallen_cd:IsPurgable() return false end
function modifier_will_of_the_fallen_cd:IsPurgeException() return false end
function modifier_will_of_the_fallen_cd:RemoveOnDeath() return true end

modifier_will_of_the_fallen_ultimate = class({})
function modifier_will_of_the_fallen_ultimate:IsHidden() return false end
function modifier_will_of_the_fallen_ultimate:IsDebuff() return true end
function modifier_will_of_the_fallen_ultimate:IsPurgable() return false end
function modifier_will_of_the_fallen_ultimate:IsPurgeException() return false end
function modifier_will_of_the_fallen_ultimate:RemoveOnDeath() return true end
function modifier_will_of_the_fallen_ultimate:AllowIllusionDuplicate() return false end

function modifier_will_of_the_fallen_ultimate:DeclareFunctions()
    local func = {  
	                 MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
				
                    				}
    return func
end
function modifier_will_of_the_fallen_ultimate:GetModifierBonusStats_Intellect()
    return 300
end


function modifier_will_of_the_fallen_ultimate:OnCreated(table)
    self.parent = self:GetParent()
self.int = self.parent:GetIntellect() * 2.5

    

   

    
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/will_of_the_fallen_ultimate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
		
		self:PlayEffects3(self:GetParent():GetOrigin(),400,2)
	
  
		self:StartIntervalThink(1)
	
        

        self.parent:Purge(false, true, false, true, true)
    end
	end

function modifier_will_of_the_fallen_ultimate:OnIntervalThink()
if IsServer() then
local int = self:GetParent():GetIntellect()
self.damageTable = {
		attacker = self:GetCaster(),
		damage = int * 2,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
	}
	local heroes = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		550,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,hero in pairs(heroes) do
		-- apply damage
		if hero:GetUnitName()== "npc_dota_demon_tower" or hero:GetUnitName()== "npc_dota_human_tower" or hero:GetUnitName()== "npc_dota_elf_tower" or hero:GetUnitName()== "npc_dota_necro_tower" then
		self.damageTable.victim = hero
		ApplyDamage( self.damageTable )

		-- play overhead event
		end
		end
		end
	end
function modifier_will_of_the_fallen_ultimate:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_will_of_the_fallen_ultimate:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
           
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

          
self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_will_of_the_fallen_advanced_debuff", {duration = 60})
          
            end
        end
		
		
			function modifier_will_of_the_fallen_ultimate:PlayEffects3( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/will_of_the_fallen_start_ultimate.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end