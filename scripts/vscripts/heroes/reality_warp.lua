reality_warp = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_glory", "heroes/reality_warp.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV

function reality_warp:GetIntrinsicModifierName()
    return "modifier_glory"
end
function reality_warp:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("memory_erase")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start

function reality_warp:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local origin = target:GetAbsOrigin() + RandomVector(500)




local ally = false
	if target:GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		ally = true
	end
	if ally  then
	FindClearSpaceForUnit( target, origin , true )
	else
	
end



	-- check dragon modifier
	local modifier = caster:FindModifierByNameAndCaster( "modifier_dragon_knight_elder_dragon_form_lua", caster )

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
function reality_warp:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" )  + self:GetCaster():FindTalentValue("special_bonus_pandora_25")
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	local ally = false
	if target:GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		ally = true
	end
	if ally  then
	else
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = duration } -- kv
	)
	end

	-- Play effects
	self:PlayEffects( target, dragonform )
	local sound_cast = "Pandora.1"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function reality_warp:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

--------------------------------------------------------------------------------
function reality_warp:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/reality_warp.vpcf"

	-- Get Data
	local vec = target:GetOrigin()-self:GetCaster():GetOrigin()
	local attach = "attach_attack1"
	if dragonform then
		attach = "attach_attack2"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 3, vec )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		4,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_glory = class ({})
function modifier_glory:IsHidden() return true end
function modifier_glory:IsDebuff() return false end
function modifier_glory:IsPurgable() return false end
function modifier_glory:IsPurgeException() return false end
function modifier_glory:RemoveOnDeath() return false end

function modifier_glory:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_glory:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_glory:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_glory:GetModifierBaseAttackTimeConstant()
	return 5.0
end
function modifier_glory:OnIntervalThink()
    if IsServer() then
        local vain = self:GetParent():FindAbilityByName("memory_erase")
        if vain and not vain:IsNull() then
            if self:GetParent():HasScepter() then
                if vain:IsHidden() then
                    vain:SetHidden(false)
                end
            else
                if not vain:IsHidden() then
                    vain:SetHidden(true)
                end
            end
        end
    end
end