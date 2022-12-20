axe_berserkers_call_lua = class({})
LinkLuaModifier( "modifier_axe_berserkers_call_lua", "modifiers/modifier_axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_lua_debuff", "modifiers/modifier_axe_berserkers_call_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bogdangasm", "heroes/axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )
function axe_berserkers_call_lua:GetIntrinsicModifierName()
    return "modifier_bogdangasm"
end
function axe_berserkers_call_lua:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("bogdan_chill")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Phase Start
function axe_berserkers_call_lua:OnAbilityPhaseInterrupted()
	-- stop effects 
	local sound_cast = "bogdan.spank"
	StopGlobalSound( sound_cast )
end
function axe_berserkers_call_lua:OnAbilityPhaseStart()
	-- play effects 
	local sound_cast = "bogdan.spank"
	local caster = self:GetCaster()
	local point = caster:GetOrigin()
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function axe_berserkers_call_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = caster:GetOrigin()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	-- find units caught
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- call
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_axe_berserkers_call_lua_debuff", -- modifier name
			{ duration = duration } -- kv
		)
	end

	-- self buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_axe_berserkers_call_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	if #enemies>0 then
		local sound_cast = ""
		EmitSoundOn( sound_cast, self:GetCaster() )
	end
	local damage = self:GetSpecialValueFor( "damage" )+self:GetCaster():FindTalentValue("special_bonus_bogdan_20")
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- for each caught enemies
	for _,enemy in pairs(enemies) do
		-- Apply Damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- Apply stun debuff
		
	end
if IsASBPatreon(caster) then
	self:PlayEffects2()
	else
	self:PlayEffects()
	end
end

--------------------------------------------------------------------------------
function axe_berserkers_call_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/axe_beserkers_call_owner1.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
function axe_berserkers_call_lua:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/hurk_spank.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
		local sound_cast = "hurk.spank"
	EmitSoundOn( sound_cast, self:GetCaster() )
end
modifier_bogdangasm = class ({})
function modifier_bogdangasm:IsHidden() return true end
function modifier_bogdangasm:IsDebuff() return false end
function modifier_bogdangasm:IsPurgable() return false end
function modifier_bogdangasm:IsPurgeException() return false end
function modifier_bogdangasm:RemoveOnDeath() return false end

function modifier_bogdangasm:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_bogdangasm:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_bogdangasm:OnIntervalThink()
    if IsServer() then
        local dungeonmaster = self:GetParent():FindAbilityByName("bogdan_chill")
        if dungeonmaster and not dungeonmaster:IsNull() then
            if self:GetParent():HasScepter() then
                if dungeonmaster:IsHidden() then
                    dungeonmaster:SetHidden(false)
                end
            else
                if not dungeonmaster:IsHidden() then
                    dungeonmaster:SetHidden(true)
                end
            end
        end
    end
end