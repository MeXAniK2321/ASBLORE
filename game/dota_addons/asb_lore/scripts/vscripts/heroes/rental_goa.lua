rental_goa = class({})
LinkLuaModifier( "modifier_rental_goa", "modifiers/modifier_rental_goa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_subaru_debil", "heroes/rental_goa.lua", LUA_MODIFIER_MOTION_NONE )

function rental_goa:GetIntrinsicModifierName()
    return "modifier_subaru_debil"
end
function rental_goa:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("cor_leonis")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function rental_goa:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	local projectile_name = "particles/rental_goa.vpcf"
	local projectile_speed = self:GetSpecialValueFor("dagger_speed") + self:GetCaster():FindTalentValue("special_bonus_subaru_25")
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
end

function rental_goa:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end
    if target:TriggerSpellAbsorb( self ) then return end
	
	
	self:Hit( target, true )

	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_rental_goa",
		{duration = self:GetDuration()}
	)

	self:PlayEffects2( hTarget )
end
function rental_goa:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "boom" ) + self:GetCaster():FindTalentValue("special_bonus_subaru_25")

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	
	

	
end


--------------------------------------------------------------------------------
function rental_goa:PlayEffects1()
	-- Get Resources
	local sound_cast = "subaru.2"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function rental_goa:PlayEffects2( target )
	-- Get Resources
	local sound_target = "lelouch.nightmare2"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end


modifier_x_canon_thinker = class ({})

function modifier_x_canon_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_subaru_debil = class ({})
function modifier_subaru_debil:IsHidden() return true end
function modifier_subaru_debil:IsDebuff() return false end
function modifier_subaru_debil:IsPurgable() return false end
function modifier_subaru_debil:IsPurgeException() return false end
function modifier_subaru_debil:RemoveOnDeath() return false end

function modifier_subaru_debil:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_subaru_debil:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_subaru_debil:OnIntervalThink()
    if IsServer() then
	if not self:GetParent():HasModifier("modifier_cor_leonis_self") and not self:GetParent():HasModifier("modifier_return_from_death_buff")  then
        local vongolle = self:GetParent():FindAbilityByName("cor_leonis")
        if vongolle and not vongolle:IsNull() then
            if self:GetParent():HasScepter() then
                if vongolle:IsHidden() then
                    vongolle:SetHidden(false)
                end
            else
                if not vongolle:IsHidden() then
                    vongolle:SetHidden(true)
                end
            end
        end
    end
	end
	end