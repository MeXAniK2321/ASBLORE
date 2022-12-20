round_kick = class({})
LinkLuaModifier( "modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_original", "heroes/round_kick.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hidden_move", "heroes/round_kick.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function round_kick:GetIntrinsicModifierName()
    return "modifier_original"
end
function round_kick:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("jin_mori_original3")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function round_kick:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")+ self:GetCaster():FindTalentValue("special_bonus_mori_20")
	local damage = self:GetSpecialValueFor("damage")
	if self:GetCaster():HasModifier("modifier_secret_move") then
	caster:AddNewModifier(caster, self, "modifier_hidden_move", {duration = 5})
	else
	end

	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = damage,
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
			"modifier_root", -- modifier name
			{ duration = duration } -- kv
		)
	end

	self:PlayEffects( radius )
end

function round_kick:PlayEffects( radius )
	local particle_cast = "particles/jin_mori_kick.vpcf"
	local sound_cast = "mori.1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
modifier_original = class ({})
function modifier_original:IsHidden() return true end
function modifier_original:IsDebuff() return false end
function modifier_original:IsPurgable() return false end
function modifier_original:IsPurgeException() return false end
function modifier_original:RemoveOnDeath() return false end

function modifier_original:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_original:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_original:OnIntervalThink()
    if IsServer() then
        local monkey_kong = self:GetParent():FindAbilityByName("jin_mori_original3")
        if monkey_kong and not monkey_kong:IsNull() then
            if self:GetParent():HasScepter() then
                if monkey_kong:IsHidden() then
                    monkey_kong:SetHidden(false)
                end
            else
                if not monkey_kong:IsHidden() then
                    monkey_kong:SetHidden(true)
                end
            end
        end
    end
end
modifier_hidden_move = class({})
function modifier_hidden_move:IsHidden() return true end
function modifier_hidden_move:IsDebuff() return false end
function modifier_hidden_move:IsPurgable() return false end
function modifier_hidden_move:IsPurgeException() return false end
function modifier_hidden_move:RemoveOnDeath() return true end