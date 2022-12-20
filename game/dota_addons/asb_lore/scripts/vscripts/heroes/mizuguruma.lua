mizuguruma = class({})
LinkLuaModifier( "modifier_mizu", "heroes/mizuguruma.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function mizuguruma:GetIntrinsicModifierName()
    return "modifier_mizu"
end

-- Ability Start
function mizuguruma:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	if  self:GetCaster():HasModifier( "modifier_enbu" ) then
	self.damage = 1200
	else
	self.damage = self:GetSpecialValueFor("damage")+ self:GetCaster():FindTalentValue("special_bonus_tanjiro_20")
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
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		self:GetCaster():PerformAttack(enemy, true,
				true,
				true,
				true,
				true,
				false,
				true)

		-- silence
		
	end
   if  self:GetCaster():HasModifier( "modifier_enbu" ) then
   self:PlayEffects2( radius )
   else
	self:PlayEffects( radius )
	end
end

function mizuguruma:PlayEffects( radius )
	local particle_cast = "particles/tanjiro_circle.vpcf"
	local sound_cast = "tanjiro.1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function mizuguruma:PlayEffects2( radius )
	local particle_cast = "particles/hinokami_kagura_circle.vpcf"
	local sound_cast = "tanjiro.1_hinokami"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
modifier_mizu = class ({})
function modifier_mizu:IsHidden() return true end
function modifier_mizu:IsDebuff() return false end
function modifier_mizu:IsPurgable() return false end
function modifier_mizu:IsPurgeException() return false end
function modifier_mizu:RemoveOnDeath() return false end

function modifier_mizu:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_mizu:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_mizu:OnIntervalThink()
    if IsServer() then
        local water_guy = self:GetParent():FindAbilityByName("tanjiro_9")
        if water_guy and not water_guy:IsNull() then
            if self:GetParent():HasScepter() then
			if not self:GetParent():HasModifier("modifier_tanjiro_9") then
                if water_guy:IsHidden() then
                    water_guy:SetHidden(false)
                end
            else
                if not water_guy:IsHidden() then
                    water_guy:SetHidden(true)
                end
            end
        end
    end
end
end