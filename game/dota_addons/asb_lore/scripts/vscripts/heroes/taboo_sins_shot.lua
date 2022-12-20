taboo_sins_shot = class({})
LinkLuaModifier( "modifier_bloodly", "heroes/taboo_sins_shot", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function taboo_sins_shot:GetIntrinsicModifierName()
    return "modifier_bloodly"
end
function taboo_sins_shot:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("taboo_spirits_of_the_past")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function taboo_sins_shot:OnSpellStart()
	-- unit identifier
	self.caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local point_caster = self:GetCaster():GetOrigin()

	-- load data
	local radius = self:GetSpecialValueFor("area_of_effect")
	self.screamDamage = self:GetSpecialValueFor("damage") + self:GetCaster():FindTalentValue("special_bonus_flandr_20")

	local projectile_name = "particles/flandr_sin.vpcf"
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- Prebuilt Projectile info
	local info = {
		-- Target = target,
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		vSourceLoc= point_caster,                -- Optional (HOW)
		bDodgeable = true,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = false,                           -- Optional
	}

	-- create projectile to all enemies hit
	for _,enemy in pairs(enemies) do
		info.Target = enemy
		
		ProjectileManager:CreateTrackingProjectile(info)
		
		
		
	end

	-- Play effects
	self:PlayEffects( point )
end
--------------------------------------------------------------------------------
-- Projectile
function taboo_sins_shot:OnProjectileHit( target, location )
	-- Apply Damage	 
	if  target:IsMagicImmune() then
	else
	local damageTable = {
		victim = target,
		attacker = self.caster,
		damage = self.screamDamage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
     
	

	ApplyDamage(damageTable)
	EmitSoundOn("flandr.4_1", self.caster)
	if self:GetCaster():HasModifier("modifier_un_owen_was_her") then
	 local caster = self:GetCaster()
    local duration = 1.5
    local incoming = 100
    local outgoing = 25
    local clones = 1 



    for i = 1,clones do
        local clone = CreateIllusionForPlayer(caster, caster, caster, self, target:GetAbsOrigin() + RandomVector(100), duration, 1, incoming, outgoing)
    end
	
	elseif self:GetCaster():HasModifier("modifier_lunatic_nightmare") then
	 local caster = self:GetCaster()
    local duration = 1.5
    local incoming = 100
    local outgoing = 25
    local clones = 2 



    for i = 1,clones do
        local clone = CreateIllusionForPlayer(caster, caster, caster, self, target:GetAbsOrigin() + RandomVector(100), duration, 1, incoming, outgoing)
    end
	end
	end
end


--------------------------------------------------------------------------------
-- Ability Considerations
function taboo_sins_shot:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end

--------------------------------------------------------------------------------
function taboo_sins_shot:PlayEffects( location )
	-- Get Resources
	local particle_cast = "particles/flandr_sin_owner.vpcf"
	local sound_cast = "flandr.1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end


modifier_bloodly = class ({})
function modifier_bloodly:IsHidden() return true end
function modifier_bloodly:IsDebuff() return false end
function modifier_bloodly:IsPurgable() return false end
function modifier_bloodly:IsPurgeException() return false end
function modifier_bloodly:RemoveOnDeath() return false end

function modifier_bloodly:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_bloodly:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_bloodly:OnIntervalThink()
    if IsServer() then
        local bloodsucker = self:GetParent():FindAbilityByName("taboo_spirits_of_the_past")
        if bloodsucker and not bloodsucker:IsNull() then
            if self:GetParent():HasScepter() then
                if bloodsucker:IsHidden() then
                    bloodsucker:SetHidden(false)
                end
            else
                if not bloodsucker:IsHidden() then
                    bloodsucker:SetHidden(true)
                end
            end
        end
    end
end