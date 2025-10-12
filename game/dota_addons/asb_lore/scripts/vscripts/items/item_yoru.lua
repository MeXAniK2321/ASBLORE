item_yoru = item_yoru or class({})
item_yoru_true = item_yoru_true or class({})
LinkLuaModifier("modifier_item_yoru", "items/item_yoru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_yoru_true", "items/item_yoru", LUA_MODIFIER_MOTION_NONE)
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
	local fDuration = self:GetSpecialValueFor("duration") or 0.1
    if target:TriggerSpellAbsorb( self ) then return end

	local blinkDistance = 180
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = fDuration } -- kv
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
	
	print("WTF")
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
modifier_item_yoru = modifier_item_yoru or class({})

function modifier_item_yoru:IsHidden() return true end
function modifier_item_yoru:IsDebuff() return false end
function modifier_item_yoru:IsPurgable() return false end
function modifier_item_yoru:IsPurgeException() return false end
function modifier_item_yoru:RemoveOnDeath() return false end
function modifier_item_yoru:OnCreated( kv )
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	if IsServer() then
		self:SetStackCount(0)
	end
	
	self:StartIntervalThink( 3.0 )
end
---------------------------------------------------------------------------------------------------------------------
function modifier_item_yoru:DeclareFunctions()
	local func = { 	
	                 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
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
	
	if IsServer() then
	   if not self.parent:IsRangedAttacker() and not self.parent:HasModifier("modifier_yoru_debuff") then
		  if params.attacker == self.parent and not params.attacker:IsIllusion() then	
		     if not params.attacker:HasItemInInventory("item_angel_halo") and not params.target:HasModifier("modifier_item_yoru_bashed") then
		        params.attacker:AddNewModifier(self.caster, self.ability, "modifier_yoru_attacking", {duration = 3.0 })
			    if RandomInt(0, 100)<self.crit_chance then
			      local point = params.attacker:GetOrigin()
			      params.target:AddNewModifier(self.caster, self.ability, "modifier_item_yoru_bashed", {duration = 2.0 })
			      params.target:AddNewModifier(self.caster, self.ability, "modifier_generic_stunned_lua", {duration = 1.5 })
			      params.attacker:AddNewModifier(self.caster, self.ability, "modifier_yoru_debuff", {duration = 2 })
		          EmitSoundOnLocationWithCaster( point, "bash.bash", self.caster )
		          self:SetStackCount(0)
		        else
		          self:AddStack(1)
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
	local after = self.stack + value
	if after > 6 then
	  after = 5
	end
	
	self:SetStackCount( after )
end


modifier_yoru_debuff = modifier_yoru_debuff or class({})

function modifier_yoru_debuff:IsHidden() return true end
function modifier_yoru_debuff:IsDebuff() return false end
function modifier_yoru_debuff:IsPurgable() return false end
function modifier_yoru_debuff:IsPurgeException() return false end
function modifier_yoru_debuff:RemoveOnDeath() return true end


modifier_item_yoru_active_cd = modifier_item_yoru_active_cd or class({})

function modifier_item_yoru_active_cd:IsHidden() return false end
function modifier_item_yoru_active_cd:IsDebuff() return false end
function modifier_item_yoru_active_cd:IsPurgable() return false end
function modifier_item_yoru_active_cd:IsPurgeException() return false end
function modifier_item_yoru_active_cd:RemoveOnDeath() return true end


modifier_item_yoru_attacking = modifier_item_yoru_attacking or class({})

function modifier_item_yoru_attacking:IsHidden() return false end
function modifier_item_yoru_attacking:IsDebuff() return false end
function modifier_item_yoru_attacking:IsPurgable() return false end
function modifier_item_yoru_attacking:IsPurgeException() return false end
function modifier_item_yoru_attacking:RemoveOnDeath() return true end


modifier_item_yoru_bashed = modifier_item_yoru_bashed or class({})

function modifier_item_yoru_bashed:IsHidden() return false end
function modifier_item_yoru_bashed:IsDebuff() return false end
function modifier_item_yoru_bashed:IsPurgable() return false end
function modifier_item_yoru_bashed:IsPurgeException() return false end
function modifier_item_yoru_bashed:RemoveOnDeath() return true end



---------------------------------------------------------------------------------
-- YORU TRUE --------------------------------------------------------------------
---------------------------------------------------------------------------------

function item_yoru_true:GetIntrinsicModifierName()
	return "modifier_item_yoru_true"
end
function item_yoru_true:OnSpellStart()
  -- HMMMMMMMM....
end

---------------------------------------------------------------------------------------------------------------------
modifier_item_yoru_true = modifier_item_yoru_true or class({})

function modifier_item_yoru_true:IsHidden() return true end
function modifier_item_yoru_true:IsDebuff() return false end
function modifier_item_yoru_true:IsPurgable() return false end
function modifier_item_yoru_true:IsPurgeException() return false end
function modifier_item_yoru_true:RemoveOnDeath() return false end
function modifier_item_yoru_true:OnCreated( kv )
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
	self.ability = self:GetAbility()
	
	self.fCleaveDamagePercent = self.ability:GetSpecialValueFor("cleave_damage_percent") * 0.01
	self.fCleaveStartingWidth = self.ability:GetSpecialValueFor("cleave_starting_width")
	self.fCleaveEndingWidth   = self.ability:GetSpecialValueFor("cleave_ending_width")
	self.fCleaveDistance 	  = self.ability:GetSpecialValueFor("cleave_distance")
	
	if IsServer() then
        self.iCASTER_TEAM          = self.caster:GetTeamNumber()
        self.iABILITY_TARGET_TEAM  = DOTA_UNIT_TARGET_TEAM_ENEMY
        self.iABILITY_TARGET_TYPE  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
        self.iABILITY_TARGET_FLAGS = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
	end
end
---------------------------------------------------------------------------------------------------------------------
function modifier_item_yoru_true:DeclareFunctions()
	local func = { 	
	                 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					 MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		         }
	
	return func
end
function modifier_item_yoru_true:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('damage')
end 
function modifier_item_yoru_true:GetModifierProcAttack_Feedback(keys)
	if IsServer() then
	        local hAttacker = keys.attacker
            local hTarget   = keys.target
			if hAttacker == self.parent
				and IsNotNull(hAttacker)
				and not hAttacker:IsIllusion()
				and not keys.ranged_attack
				and keys.process_procs
				and UnitFilter(	hTarget,
								self.iABILITY_TARGET_TEAM, 
								self.iABILITY_TARGET_TYPE,
								self.iABILITY_TARGET_FLAGS, 
								self.iCASTER_TEAM) == UF_SUCCESS then

				--local bCloseRangeNow = GetDistance(hTarget, hAttacker) <= ( hAttacker:Script_GetAttackRange() + hAttacker:GetAttackRangeBuffer() )
	        	DoCleaveAttack(	hAttacker,
        							hTarget,
        							self.ability,
        							( keys.original_damage * self.fCleaveDamagePercent ), 
        							self.fCleaveStartingWidth,
        							self.fCleaveEndingWidth,
        							self.fCleaveDistance,
        							"particles/item/yoru_true/yoru_true.vpcf"
        						)
	        end
		return 1
	end
end
function modifier_item_yoru_true:OnProcessCleave(keys)
--
end