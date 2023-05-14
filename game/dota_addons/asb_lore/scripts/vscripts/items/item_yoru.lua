item_yoru = class({})
LinkLuaModifier("modifier_item_yoru", "items/item_yoru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_yoru_debuff", "items/item_yoru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_yoru_active_cd", "items/item_yoru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_yoru_attacking", "items/item_yoru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_yoru_bashed", "items/item_yoru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)

function item_yoru:GetIntrinsicModifierName()
	return "modifier_item_yoru"
end
function item_yoru:CastFilterResultTarget(target)
    if target:HasModifier("modifier_item_yoru_active_cd") then
        return UF_FAIL_CUSTOM
    end
    if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        return UF_FAIL_ENEMY
    end
    return UF_SUCCESS
end 

function item_yoru:GetCustomCastErrorTarget(target)
    if target:HasModifier("modifier_item_yoru_active_cd")  then
        return "#dota_hud_error_cant_cast_on_other"
    end
end
function item_yoru:OnSpellStart()
local caster = self:GetCaster()
	local target = self:GetCursorTarget()
if target:TriggerSpellAbsorb( self ) then return end

	local blinkDistance = 180
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 0.0 } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_item_yoru_active_cd", -- modifier name
		{ duration = 3.0 } -- kv
	)
	
	caster:AddNewModifier(self:GetCaster(), self, "modifier_yoru_debuff", {duration = 2 })

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
	caster:MoveToTargetToAttack(target)
		local sound_cast = "bash.active"
	EmitSoundOn( sound_cast, target )
	self:PlayEffects( target)
end
function item_yoru:PlayEffects(target)
	-- Get Resources
	local particle_cast = "particles/test_frienship_sfx.vpcf"

	-- Get Data
	local vec = target:GetOrigin()-self:GetCaster():GetOrigin()
	local attach = "attach_attack1"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
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
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_yoru = class({})
function modifier_item_yoru:IsHidden() return true end
function modifier_item_yoru:IsDebuff() return false end
function modifier_item_yoru:IsPurgable() return false end
function modifier_item_yoru:IsPurgeException() return false end
function modifier_item_yoru:RemoveOnDeath() return false end

function modifier_item_yoru:OnCreated( kv )
if IsServer() then
		self:SetStackCount(0)
	end
	self:StartIntervalThink( 3.0 )
	
end

---------------------------------------------------------------------------------------------------------------------
function modifier_item_yoru:DeclareFunctions()
	local func = { 	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
		 MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
		}
	return func
end

  function modifier_item_yoru:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end 
  function modifier_item_yoru:GetModifierPreAttack_BonusDamage()
return self:GetAbility():GetSpecialValueFor('damage')
end 
function modifier_item_yoru:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('int')
end

function modifier_item_yoru:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('str')
end

function modifier_item_yoru:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor('armor')
end
function modifier_item_yoru:OnAttackLanded(params)
self.stack = self:GetStackCount()
self.crit_chance = 10 * self.stack
	self.crit_chance2= 0
	if IsServer() then
	 if not self:GetParent():HasModifier("modifier_yoru_debuff") then
	
	local point = self:GetParent():GetOrigin()
	   
	    if self:GetParent():IsRangedAttacker() then
		
	else
	
	
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if not params.attacker:HasItemInInventory("item_angel_halo") then
			if not params.target:HasModifier("modifier_item_yoru_bashed") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_yoru_attacking", {duration = 3.0 })
			if RandomInt(0, 100)<self.crit_chance then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_yoru_bashed", {duration = 2.0 })
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_stunned_lua", {duration = 1.5 })
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_yoru_debuff", {duration = 2 })
		EmitSoundOnLocationWithCaster( point, "bash.bash", self:GetCaster() )
		self:SetStackCount(0)
		else
		self:AddStack(1)
			end
		end
		end
	end
	end
	end
	end
	end
end
function modifier_item_yoru:OnIntervalThink()
	 if not self:GetParent():HasModifier("modifier_yoru_attacking") then
	 self:SetStackCount(0)
	 end
end
function modifier_item_yoru:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
	if not self:GetParent():HasScepter() then
		if after > 6 then
			after = 5
		end
	else
		if after > 6 then
			after = 5
		end
	end
	self:SetStackCount( after )
end
modifier_yoru_debuff = class({})
function modifier_yoru_debuff:IsHidden() return true end
function modifier_yoru_debuff:IsDebuff() return false end
function modifier_yoru_debuff:IsPurgable() return false end
function modifier_yoru_debuff:IsPurgeException() return false end
function modifier_yoru_debuff:RemoveOnDeath() return true end
modifier_item_yoru_active_cd = class({})
function modifier_item_yoru_active_cd:IsHidden() return false end
function modifier_item_yoru_active_cd:IsDebuff() return false end
function modifier_item_yoru_active_cd:IsPurgable() return false end
function modifier_item_yoru_active_cd:IsPurgeException() return false end
function modifier_item_yoru_active_cd:RemoveOnDeath() return true end
modifier_item_yoru_attacking = class({})
function modifier_item_yoru_attacking:IsHidden() return false end
function modifier_item_yoru_attacking:IsDebuff() return false end
function modifier_item_yoru_attacking:IsPurgable() return false end
function modifier_item_yoru_attacking:IsPurgeException() return false end
function modifier_item_yoru_attacking:RemoveOnDeath() return true end


modifier_item_yoru_bashed = class({})
function modifier_item_yoru_bashed:IsHidden() return false end
function modifier_item_yoru_bashed:IsDebuff() return false end
function modifier_item_yoru_bashed:IsPurgable() return false end
function modifier_item_yoru_bashed:IsPurgeException() return false end
function modifier_item_yoru_bashed:RemoveOnDeath() return true end

