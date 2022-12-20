aizen_kyouka_suigetsu = class({})
LinkLuaModifier( "modifier_generic_stunned_lua2", "heroes/aizen_kyouka_suigetsu", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aizen_kyouka_suigetsu_hit", "modifiers/modifier_aizen_kyouka_suigetsu_hit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aizen_kyouka_suigetsu_hit_debuff", "modifiers/modifier_aizen_kyouka_suigetsu_hit_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aizen_kyouka_damage", "modifiers/modifier_aizen_kyouka_damage", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function aizen_kyouka_suigetsu:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
    local player = caster:GetPlayerID()
	local unit_name = caster:GetUnitName()
	local origin = target:GetAbsOrigin() + RandomVector(10)
	local duration = 5
	local outgoingDamage = 1
	local incomingDamage = 5
	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(caster:GetPlayerID())
	illusion:SetControllableByPlayer(player, true)
	
	-- Level Up the unit to the casters level
	local casterLevel = caster:GetLevel()
	for i=1,casterLevel-1 do
		illusion:HeroLevelUp(false)
	end

	-- Set the skill points to 0 and learn the skills of the caster
	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = caster:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			illusionAbility:SetLevel(abilityLevel)
		end
	end

	-- Recreate the items of the caster
	for itemSlot=0,5 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	illusion:AddNewModifier(caster, ability, "modifier_aizen_kyouka_suigetsu_hit",{duration = duration})
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()

	-- check if simple form
	if not modifier then
		-- cancel if linken
		if target:TriggerSpellAbsorb( self ) then return end

		-- directly hit
		self:Hit( target, false )

		-- play effects
		local sound_cast = ""
		EmitSoundOn( sound_cast, caster )
		return
	end

	-- dragon form

	-- get data
	local projectile_name = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
		}
	ProjectileManager:CreateTrackingProjectile(info)
end

-- Helper
function aizen_kyouka_suigetsu:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data

	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	

	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua2", -- modifier name
		{ duration = duration } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_aizen_kyouka_damage", -- modifier name
		{ duration = 0.7 } -- kv
	)

	-- Play effects

	local sound_cast = "aizen.4"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile


--------------------------------------------------------------------------------


modifier_generic_stunned_lua2 = class({})

--------------------------------------------------------------------------------

function modifier_generic_stunned_lua2:IsHidden()
    return false
end

function modifier_generic_stunned_lua2:IsPurgable()
    return false
end
function modifier_generic_stunned_lua2:OnDestroy()

	self:PlayEffects()
end

--------------------------------------------------------------------------------

function modifier_generic_stunned_lua2:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end
function modifier_generic_stunned_lua2:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/test3.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end