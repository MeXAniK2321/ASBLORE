LinkLuaModifier("modifier_all_fiction_self", "heroes/all_fiction_self", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_all_fiction_self2", "heroes/all_fiction_self", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_all_fiction_position", "heroes/all_fiction_self", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_all_fiction_check", "heroes/all_fiction_self", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_asta_sword_buff", "items/item_asta_sword", LUA_MODIFIER_MOTION_NONE)
all_fiction_self = class({})

function all_fiction_self:IsStealable() return true end
function all_fiction_self:IsHiddenWhenStolen() return false end
function all_fiction_self:OnSpellStart()
    local caster = self:GetCaster()
	
  if caster:IsHero() then
  if self:GetCaster():HasModifier("modifier_all_fiction") then
  EmitSoundOn("kumagawa.4_1", caster)
		EmitSoundOn("kumagawa.4", caster)
		caster:AddNewModifier(caster, self, "modifier_item_asta_sword_buff", {duration = 1.0})
		self:PlayEffects()
		local radius = 400
	local duration = 0.5
	local damage = 1400
	

	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = 1500,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = duration } -- kv
		)
		
	end
		
  else
  caster:AddNewModifier( self:GetCaster(), self, "modifier_all_fiction_self", {duration = 1.2} )
        caster:Kill(self, caster)
		
		
		EmitSoundOn("kumagawa.4_1", caster)
			local delay = 0.2
		Timers:CreateTimer(delay,function()	
		EmitSoundOn("kumagawa.4", caster)
		caster:AddNewModifier(caster, self, "modifier_item_asta_sword_buff", {duration = 2.5})
		end)
		self:PlayEffects()
		local radius = 400
	local duration = 0.5
	local damage = 1400
	

	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = 1400,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = duration } -- kv
		)
		
	end
	end
	
end

end


function all_fiction_self:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/all_fiction_self_reincarnate.vpcf"
	local caster = self:GetCaster()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end
---------------------------------------------------------------------------------------------------------------------
modifier_all_fiction_self = class({})
function modifier_all_fiction_self:IsHidden() return false end
function modifier_all_fiction_self:IsDebuff() return true end
function modifier_all_fiction_self:IsPurgable() return false end
function modifier_all_fiction_self:IsPurgeException() return false end
function modifier_all_fiction_self:RemoveOnDeath() return true end
function modifier_all_fiction_self:AllowIllusionDuplicate() return true end
function modifier_all_fiction_self:DeclareFunctions()
    local func = {  
    				MODIFIER_EVENT_ON_DEATH,
MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,	
MODIFIER_EVENT_ON_TAKEDAMAGE,				}
    return func
end



function modifier_all_fiction_self:OnDeath( params )
local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	if IsServer() then
	if not self:GetParent():IsIllusion() then
		
		local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end

	-- logic
	if pass then
		self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_all_fiction_position", -- modifier name
		{ duration = 1 }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	local origin2 = self.thinker:GetOrigin()
	caster:SetRespawnPosition(origin2)
	self:GetParent():AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_all_fiction_check", -- modifier name
			{ duration = 1 } -- kv
		)
	
	
		
		end
	
		end
		end
		end
	
	


function modifier_all_fiction_self:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/all_fiction_self_reincarnate.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

modifier_all_fiction_position = class({})
function modifier_all_fiction_position:IsHidden() return true end
function modifier_all_fiction_position:IsDebuff() return false end
function modifier_all_fiction_position:IsPurgable() return false end
function modifier_all_fiction_position:IsPurgeException() return true end
function modifier_all_fiction_position:RemoveOnDeath() return false end



modifier_all_fiction_check = class({})
function modifier_all_fiction_check:IsHidden() return true end
function modifier_all_fiction_check:IsDebuff() return false end
function modifier_all_fiction_check:IsPurgable() return false end
function modifier_all_fiction_check:IsPurgeException() return true end
function modifier_all_fiction_check:RemoveOnDeath() return false end