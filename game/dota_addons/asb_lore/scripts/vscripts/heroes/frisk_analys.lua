frisk_analys = class({})
LinkLuaModifier( "modifier_frisk_analys", "modifiers/modifier_frisk_analys", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_scary_child", "heroes/frisk_analys.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV

function frisk_analys:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rip_and_tear")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function frisk_analys:GetIntrinsicModifierName()
    return "modifier_scary_child"
end
--------------------------------------------------------------------------------
-- Ability Start
function frisk_analys:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

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
function frisk_analys:Hit( target, dragonform )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("stun_duration")
   local duration2 = self:GetSpecialValueFor("duration")
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end
 local damage =  self:GetSpecialValueFor("damage")
	-- load data
	
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
		"modifier_frisk_analys", -- modifier name
		{ duration = duration } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = duration2 } -- kv
	)

	-- Play effects

	local sound_cast = "frisk.3"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function frisk_analys:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

--------------------------------------------------------------------------------
modifier_scary_child = class ({})
function modifier_scary_child:IsHidden() return true end
function modifier_scary_child:IsDebuff() return false end
function modifier_scary_child:IsPurgable() return false end
function modifier_scary_child:IsPurgeException() return false end
function modifier_scary_child:RemoveOnDeath() return false end

function modifier_scary_child:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_scary_child:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_scary_child:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("do_you_wanna_touch_the_child")
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