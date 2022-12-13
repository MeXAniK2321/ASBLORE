
-------------------------------------------------------------------------
LinkLuaModifier("modifier_goka_mekkaku_buff", "heroes/susano", LUA_MODIFIER_MOTION_NONE)

goka_mekkaku = class({})

function goka_mekkaku:IsStealable() return true end
function goka_mekkaku:IsHiddenWhenStolen() return false end
function goka_mekkaku:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	local direction = (point - caster:GetAbsOrigin()):Normalized()
	local distance 	  = self:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus()
	--self:GetSpecialValueFor("hellfire_distance")
	local width_start = self:GetSpecialValueFor("hellfire_width_start")
	local width_end   = self:GetSpecialValueFor("hellfire_width_end")
	local speed       = self:GetSpecialValueFor("hellfire_speed")

	local hellfire_projectile = {	Ability				= self,
									EffectName			= "particles/katon.vpcf",
									vSpawnOrigin		= caster:GetAbsOrigin() + Vector(0,0,220),
									fDistance			= distance,
									fStartRadius		= width_start,
									fEndRadius			= width_end,
									Source				= caster,
									bHasFrontalCone		= false,
									bReplaceExisting	= false,
									iUnitTargetTeam		= self:GetAbilityTargetTeam(),
									iUnitTargetFlags 	= self:GetAbilityTargetFlags(),
									iUnitTargetType		= self:GetAbilityTargetType(),
									fExpireTime 		= GameRules:GetGameTime() + 10.0,
									bDeleteOnHit		= false,
									vVelocity			= Vector(direction.x,direction.y,0) * speed,
									bProvidesVision		= false }
		
	local hellfires = 1 

	local qangle_rotation_rate = 360 / hellfires
	for i = 1, hellfires do
	  	local qangle = QAngle(0, qangle_rotation_rate, 0)
	 	point = RotatePosition(caster:GetAbsOrigin(), qangle, point)

		local direction   = (point - caster:GetAbsOrigin()):Normalized()

		hellfire_projectile.vSpawnOrigin = caster:GetAbsOrigin() + direction * 125
		hellfire_projectile.vVelocity = Vector(direction.x,direction.y,0) * speed

		ProjectileManager:CreateLinearProjectile(hellfire_projectile)
	end

	EmitSoundOn("Goka.Mekkaku", caster)
	EmitSoundOn("katon.flame", caster)
end
function goka_mekkaku:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		return nil
	end

	local damage 	= self:GetSpecialValueFor("hellfire_damage")
	local duration 	= self:GetSpecialValueFor("hellfire_duration")

	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_goka_mekkaku_buff", {duration = duration})

	local damageTable = {
							victim      = hTarget,
							attacker    = self:GetCaster(),
							damage      = damage,
							damage_type = self:GetAbilityDamageType(),
							ability     = self
						}

	ApplyDamage(damageTable)
end
---------------------------------------------------------------------------------------------------------------------
modifier_goka_mekkaku_buff = class({})

function modifier_goka_mekkaku_buff:IsHidden() return false end
function modifier_goka_mekkaku_buff:IsDebuff() return true end
function modifier_goka_mekkaku_buff:IsPurgable() return false end
function modifier_goka_mekkaku_buff:IsPurgeException() return true end
function modifier_goka_mekkaku_buff:RemoveOnDeath() return true end
function modifier_goka_mekkaku_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_goka_mekkaku_buff:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.hellfire_damage_interval 	= self.ability:GetSpecialValueFor("hellfire_damage_interval")
		self.hellfire_damage_second 	= (self.ability:GetSpecialValueFor("hellfire_damage_second")+self:GetCaster():FindTalentValue("special_bonus_madara_25")) * self.hellfire_damage_interval

		local burn_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		
		self:AddParticle(burn_fx, false, false, -1, true, true)

		self:StartIntervalThink(self.hellfire_damage_interval)
	end
end
function modifier_goka_mekkaku_buff:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_goka_mekkaku_buff:OnIntervalThink()
	if IsServer() then
		local damageTable = {
								victim 	 	= self.parent,
								attacker 	= self.caster,
								damage   	= self.hellfire_damage_second,
								damage_type = self.ability:GetAbilityDamageType(),
								ability 	= self.ability
							}

		ApplyDamage(damageTable)
	end
end
----------------------------------------------------------------------------------------
LinkLuaModifier("modifier_susano_slash", "heroes/susano", LUA_MODIFIER_MOTION_NONE)

susano_slash = class({})

function susano_slash:IsStealable() return true end
function susano_slash:IsHiddenWhenStolen() return false end
function susano_slash:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function susano_slash:OnAbilityPhaseStart()
    if IsServer() then
        self.swing_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_shockwave.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
        local swing = self.swing_fx
        ParticleManager:SetParticleControlEnt(self.swing_fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.swing_fx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
        
        Timers:CreateTimer(self:GetBackswingTime(), function()
            ParticleManager:DestroyParticle(swing, false)
            ParticleManager:ReleaseParticleIndex(swing)
        end)

        EmitSoundOn("Susano.Hit", self:GetCaster())

        return true
    end
end
function susano_slash:OnAbilityPhaseInterrupted()
    if IsServer() then
        ParticleManager:DestroyParticle(self.swing_fx, false)

        StopSoundOn("Susano.Hit", self:GetCaster())
    end
end
function susano_slash:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    if point == caster:GetAbsOrigin() then
        point = caster:GetAbsOrigin() + caster:GetForwardVector() * 25
    end

    local distance = self:GetCastRange(caster:GetAbsOrigin(),caster)
    local direction = (point - caster:GetAbsOrigin()):Normalized()

    local width = self:GetSpecialValueFor("width")
    local speed = self:GetSpecialValueFor("speed")

    self.slash_projectile = {   Ability = self,
                                EffectName = "particles/susano_slash.vpcf",
                                vSpawnOrigin = caster:GetAbsOrigin(),
                                vVelocity = Vector(direction.x,direction.y,0) * speed,
                                fDistance = distance,
                                fStartRadius = width,
                                fEndRadius = width,
                                Source = caster,
                                iUnitTargetTeam   = self:GetAbilityTargetTeam(),
                                iUnitTargetType   = self:GetAbilityTargetType(),
                                iUnitTargetFlags  = self:GetAbilityTargetFlags(),
                                bProvidesVision   = false,
                                iVisionRadius     = width,
                                iVisionTeamNumber = caster:GetTeamNumber()}

    ProjectileManager:CreateLinearProjectile(self.slash_projectile)

end
function susano_slash:OnProjectileHit(hTarget, vLocation)
    if not hTarget then
        return nil
    end

    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_susano_slash", {duration = self:GetSpecialValueFor("slow_duration")})

    
    local damage_table = {  victim = hTarget,
                            attacker = self:GetCaster(),
                            damage = self:GetSpecialValueFor("damage"),
                            damage_type = self:GetAbilityDamageType(),
                            ability = self}

    self.anime_overhead_effect_damage = OVERHEAD_ALERT_DAMAGE

    ApplyDamage(damage_table)
end
---------------------------------------------------------------------------------------------------------------------
modifier_susano_slash = class({})
function modifier_susano_slash:IsHidden() return false end
function modifier_susano_slash:IsDebuff() return true end
function modifier_susano_slash:IsPurgable() return true end
function modifier_susano_slash:IsPurgeException() return true end
function modifier_susano_slash:RemoveOnDeath() return true end
function modifier_susano_slash:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_susano_slash:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}
    return func
end
function modifier_susano_slash:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("move_slow") * (-1)
end
function modifier_susano_slash:OnCreated()
    if IsServer() then
        --self:IncrementStackCount()
    end
end
function modifier_susano_slash:OnRefresh()
    if IsServer() then
        --self:OnCreated()
    end
end