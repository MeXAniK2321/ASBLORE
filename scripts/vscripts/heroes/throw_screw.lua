throw_screw = class({})
LinkLuaModifier( "modifier_throw_screw", "modifiers/modifier_throw_screw", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unlucky_guy", "heroes/throw_screw.lua", LUA_MODIFIER_MOTION_NONE )
function throw_screw:GetIntrinsicModifierName()
    return "modifier_unlucky_guy"
end
function throw_screw:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("bookmaker")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function throw_screw:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	local projectile_name = "particles/kumagawa_screw.vpcf"
	local projectile_speed = self:GetSpecialValueFor("dagger_speed")
	local projectile_vision = 450

	-- Create Projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,				-- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	self:PlayEffects1()
	if self:GetCaster():HasModifier( "modifier_leg_eating_forest_aura" ) then
	self:EndCooldown()
	self:StartCooldown(3)

	end
end

function throw_screw:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end

	self:Hit( target, true )
	
	

	

	self:PlayEffects2( hTarget )
end
function throw_screw:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_kumagawa_20")
    local duration = self:GetSpecialValueFor( "duration" ) 
	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	caster:PerformAttack(
				target,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
	target:AddNewModifier(caster, self, "modifier_throw_screw", {duration = duration})
	
	
end

--------------------------------------------------------------------------------
function throw_screw:PlayEffects1()
	-- Get Resources
	local sound_cast = "kumagawa.1"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	local sound_cast2 = "kumagawa.1_1_1"

	-- Create Sound
	EmitSoundOn( sound_cast2, self:GetCaster() )
end

function throw_screw:PlayEffects2( target )
	-- Get Resources
	local sound_target = "kumagawa.1_1"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end
modifier_unlucky_guy = class ({})
function modifier_unlucky_guy:IsHidden() return true end
function modifier_unlucky_guy:IsDebuff() return false end
function modifier_unlucky_guy:IsPurgable() return false end
function modifier_unlucky_guy:IsPurgeException() return false end
function modifier_unlucky_guy:RemoveOnDeath() return false end

function modifier_unlucky_guy:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_unlucky_guy:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_unlucky_guy:OnIntervalThink()
    if IsServer() then
        local luckless = self:GetParent():FindAbilityByName("bookmaker")
        if luckless and not luckless:IsNull() then
            if self:GetParent():HasScepter() then
                if luckless:IsHidden() then
                    luckless:SetHidden(false)
                end
            else
                if not luckless:IsHidden() then
                    luckless:SetHidden(true)
                end
            end
        end
    end
end