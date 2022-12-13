keyaru_heal = class({})
LinkLuaModifier( "modifier_keyaru_dong", "heroes/keyaru/keyaru.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_keyaru_heal_talent", "heroes/keyaru/keyaru.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defiled_healing", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE )
function keyaru_heal:GetCastRange( location , target)
	if self:GetCaster():HasTalent("special_bonus_keyaru_20") then
	
		return 400
		else
		return 100
	end
	
end

function keyaru_heal:GetIntrinsicModifierName()
    return "modifier_keyaru_dong"
end
function keyaru_heal:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local modifier = caster:FindModifierByNameAndCaster("modifier_hero_of_recovery",caster)
	local current = modifier:GetStackCount()
	local heal_special = current * 2
	local hp = self:GetSpecialValueFor("heal")
	local hp_percent = self:GetSpecialValueFor("heal_percent")
	local hero_hp = caster:GetHealth() * hp_percent
    local heal = hp + hero_hp + heal_special
       	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = self:GetSpecialValueFor("heal") + hero_hp + heal_special,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		end
	
if caster:HasTalent("special_bonus_keyaru_20") then
 target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_keyaru_heal_talent", -- modifier name
		{duration = 5} -- kv
	)
end
modifier:SetStackCount(current + 2)

	target:Heal( heal, self )
	
self:PlayEffects(target)

	local sound_cast = "keyaru.1"
	EmitSoundOn( sound_cast, target )
end
function keyaru_heal:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/keyaru_heal.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_keyaru_heal_talent = class({})

function modifier_keyaru_heal_talent:IsPurgable()
    return false
end
function modifier_keyaru_heal_talent:IsHidden()
    return true
end
function modifier_keyaru_heal_talent:OnCreated(table)
    self.caster = self:GetCaster()
	self.hp = self.caster:GetMaxHealth() * 0.01
	end
function modifier_keyaru_heal_talent:DeclareFunctions()
    local funcs = {
        
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_keyaru_heal_talent:GetModifierConstantHealthRegen()
    return self.hp
end

function modifier_keyaru_heal_talent:GetEffectName()
    return "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_ward_flame.vpcf"
end

function modifier_keyaru_heal_talent:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_keyaru_heal_talent:StatusEffectPriority()
    return 10
end
	
modifier_keyaru_dong = class ({})
function modifier_keyaru_dong:IsHidden() return true end
function modifier_keyaru_dong:IsDebuff() return false end
function modifier_keyaru_dong:IsPurgable() return false end
function modifier_keyaru_dong:IsPurgeException() return false end
function modifier_keyaru_dong:RemoveOnDeath() return false end

function modifier_keyaru_dong:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_keyaru_dong:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_keyaru_dong:OnIntervalThink()
    if IsServer() then
      
		local vongolle2 = self:GetParent():FindAbilityByName("keyaru_dong_slap")
        if vongolle2 and not vongolle2:IsNull() then
            if self:GetParent():HasScepter() then
                if vongolle2:IsHidden() then
                    vongolle2:SetHidden(false)
					vongolle2:SetLevel(1)
                end
            else
                if not vongolle2:IsHidden() then
                    vongolle2:SetHidden(true)
                end
            end
        end
    end
end
hero_of_recovery = class({})
LinkLuaModifier( "modifier_hero_of_recovery", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vengeance_mark", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function hero_of_recovery:GetIntrinsicModifierName()
	return "modifier_hero_of_recovery"
end
modifier_hero_of_recovery = class({})

--------------------------------------------------------------------------------

function modifier_hero_of_recovery:IsHidden()
	return false
end

function modifier_hero_of_recovery:IsDebuff()
	return false
end

function modifier_hero_of_recovery:IsPurgable()
	return false
end

function modifier_hero_of_recovery:RemoveOnDeath()
	return false
end
function modifier_hero_of_recovery:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_hero_of_recovery:OnCreated( kv )

	if IsServer() then
		self:SetStackCount(0)
		self:StartIntervalThink(0.5)
	end
end

function modifier_hero_of_recovery:OnIntervalThink( kv )

	if IsServer() then
	if self:GetStackCount() > 400 then
		self:SetStackCount(400)
		end
		
	end
end


--------------------------------------------------------------------------------

function modifier_hero_of_recovery:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,
		  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		
	}

	return funcs
end
function modifier_hero_of_recovery:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor('bonus_regen') + (self:GetStackCount() * 0.15)
end
function modifier_hero_of_recovery:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
		self:DeathLogic( params )
	end
end
function modifier_hero_of_recovery:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end

	-- logic
	if pass then
		 params.attacker:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_vengeance_mark", -- modifier name
		{} -- kv
	)
	end
end
function modifier_hero_of_recovery:KillLogic( params )
      
	local target = params.unit
	local attacker = params.attacker
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

	-- logic
	if pass then
		if target:HasModifier("modifier_vengeance_mark") then
		self:PlayEffects(target)
		self:AddStack(40)
		 target:RemoveModifierByName("modifier_vengeance_mark")
	EmitSoundOn("keyaru.2_"..RandomInt(1,4),self:GetCaster())
		


end		
	end
end
function modifier_hero_of_recovery:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/keyaru_vengeance.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_hero_of_recovery:AddStack( value )
  
    
   self.soul_max = 400
	local current = self:GetStackCount()
	local after = current + value
	if not self:GetParent():HasScepter() then
		if after > self.soul_max then
			after = self.soul_max
		end
	else
		if after > self.soul_max then
			after = self.soul_max
		end
	end
	self:SetStackCount( after )
end


modifier_vengeance_mark = class({})
function modifier_vengeance_mark:IsHidden() return true end
function modifier_vengeance_mark:IsDebuff() return false end
function modifier_vengeance_mark:IsPurgable() return false end
function modifier_vengeance_mark:IsPurgeException() return false end
function modifier_vengeance_mark:RemoveOnDeath() return false end
function modifier_vengeance_mark:OnCreated()
    if IsServer() then
	local caster = self:GetCaster()
	local particle_cast = "particles/vengeance_mark.vpcf"
    if not self:GetParent():IsIllusion() and not self:GetParent():IsCreep() and not self:GetParent():IsBuilding() then
        local Player = PlayerResource:GetPlayer(caster:GetPlayerID())

	self.effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent(),Player)
	
end

end
end
function modifier_vengeance_mark:OnDestroy( kv )
local caster = self:GetCaster()
   self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

		if self.effect_cast then
			ParticleManager:DestroyParticle(self.effect_cast, false)
        ParticleManager:ReleaseParticleIndex(self.effect_cast)
	

end


end

defiled_healing = class({})
LinkLuaModifier( "modifier_defiled_healing", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE )
function defiled_healing:GetCastRange( location , target)
	if self:GetCaster():HasTalent("special_bonus_keyaru_25") then
	
		return 400
		else
		return 100
	end
	
end

--------------------------------------------------------------------------------
-- Ability Start
function defiled_healing:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()


		self:Hit( target)



end

-- Helper
function defiled_healing:Hit( target )
	local caster = self:GetCaster()
		local modifier = caster:FindModifierByNameAndCaster("modifier_hero_of_recovery",caster)
	local current = modifier:GetStackCount()
	local int_scale = self:GetSpecialValueFor("int_scale")
	local int = caster:GetIntellect() * int_scale
	local damage_special = current + int
	print(damage_special)
	local duration = self:GetSpecialValueFor("duration")
local target_hp = target:GetHealth()	
if target:HasModifier("modifier_vengeance_mark") then
 self.damage =  (self:GetSpecialValueFor("damage") + damage_special) * 1.3
else
 self.damage =  self:GetSpecialValueFor("damage") + damage_special
 end
local stack = current + 5

modifier:SetStackCount(stack)
	
local damageTable = {
		victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	if target_hp < self.damage then
	  target:Kill(self, caster)
	  self:PlayEffects2(target)
	else
	ApplyDamage(damageTable)
	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_defiled_healing", -- modifier name
		{ duration = duration } -- kv
	)
	

end
self:PlayEffects(target)
	local sound_cast = "keyaru.1"
	EmitSoundOn( sound_cast, target )
end
function defiled_healing:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/keyaru_defiled_heal.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function defiled_healing:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/shuichi_hug_blood.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_defiled_healing = class({})

--------------------------------------------------------------------------------

function modifier_defiled_healing:IsDebuff()
	return true
end

function modifier_defiled_healing:IsStunDebuff()
	return false
end
function modifier_defiled_healing:IsHidden()
	return false
end
function modifier_defiled_healing:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_defiled_healing:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_defiled_healing:GetModifierMoveSpeedBonus_Percentage()
	return -100
end

--------------------------------------------------------------------------------

function modifier_defiled_healing:GetEffectName()
	return "particles/units/heroes/hero_demonartist/demonartist_darkaspect_debuff.vpcf"
end

function modifier_defiled_healing:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


--------------------------------------------




LinkLuaModifier("modifier_keyaru_switch", "heroes/keyaru/keyaru.lua", LUA_MODIFIER_MOTION_NONE)

keyaru_switch = class({})

function keyaru_switch:IsStealable() return true end
function keyaru_switch:IsHiddenWhenStolen() return false end

function keyaru_switch:OnUpgrade()
local level = self:GetLevel()
local FastAbilities = 
	{
		"keyaru_switch_close",
		"switch_setsuna",
		"switch_freya",
		"freya_fireball",
		"freya_exp",
		"freya_ryusei",
		"ice_claws",
		"setsuna_ice_barrage",
		"setsuna_jump_kill",
        "switch_keyaru",		
	}

	for _,FastAbility in pairs(FastAbilities) do
	   	FastAbility = self:GetCaster():FindAbilityByName(FastAbility)
	   	if self:GetCaster():IsRealHero() then
	      	if FastAbility then
	        	FastAbility:SetLevel(level)
	      	end
	    end
end
end
function keyaru_switch:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_keyaru_switch", {})

end
---------------------------------------------------------------------------------------------------------------------
modifier_keyaru_switch = class({})
function modifier_keyaru_switch:IsHidden() return false end
function modifier_keyaru_switch:IsDebuff() return true end
function modifier_keyaru_switch:IsPurgable() return false end
function modifier_keyaru_switch:IsPurgeException() return false end
function modifier_keyaru_switch:RemoveOnDeath() return true end
function modifier_keyaru_switch:AllowIllusionDuplicate() return true end


function modifier_keyaru_switch:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

	
if self.caster:HasModifier("modifier_switch_freya") then
 self.skills_table = {
                            
							["keyaru_switch"]="keyaru_switch_close",
							["freya_fireball"]="switch_freya",
							["freya_exp"]="switch_setsuna",
							["freya_ryusei"]="switch_keyaru",
							
							
                        }

elseif self.caster:HasModifier("modifier_switch_setsuna") then
 self.skills_table = {
                            
							["keyaru_switch"]="keyaru_switch_close",
							["ice_claws"]="switch_freya",
							["setsuna_ice_barrage"]="switch_setsuna",
							["setsuna_jump_kill"]="switch_keyaru",
							
							
                        }

else
    self.skills_table = {
                            
							["keyaru_switch"]="keyaru_switch_close",
							["keyaru_heal"]="switch_freya",
							["hero_of_recovery"]="switch_setsuna",
							["defiled_healing"]="switch_keyaru",
							
							
                        }
						end

    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                  
                end
            end
        end
		
           
        
		
      

  
    end
end
function modifier_keyaru_switch:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_keyaru_switch:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

         

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("keyaru_switch_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end


keyaru_switch_close = class({})

function keyaru_switch_close:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function keyaru_switch_close:IsStealable() return true end
function keyaru_switch_close:IsHiddenWhenStolen() return false end
function keyaru_switch_close:OnSpellStart()
    local caster = self:GetCaster() 

    if caster:FindModifierByNameAndCaster("modifier_keyaru_switch", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_keyaru_switch", caster)

        --return nil
    end
end


LinkLuaModifier("modifier_switch_freya", "heroes/keyaru/keyaru.lua", LUA_MODIFIER_MOTION_NONE)

switch_freya = class({})
function switch_freya:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function switch_freya:IsStealable() return true end
function switch_freya:IsHiddenWhenStolen() return false end

function switch_freya:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dog_bite")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function switch_freya:OnSpellStart()
    local caster = self:GetCaster()
 if caster:FindModifierByNameAndCaster("modifier_keyaru_switch", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_keyaru_switch", caster)
		caster:RemoveModifierByNameAndCaster("modifier_switch_setsuna", caster)

        --return nil
    end
	if caster:FindModifierByNameAndCaster("modifier_switch_freya", caster) then
	else
    caster:AddNewModifier(caster, self, "modifier_switch_freya", {})
	end
 EmitSoundOn("keyaru.4_1", caster)
 self:PlayEffects(300)
end
function switch_freya:PlayEffects( radius )

	local particle_cast = "particles/keyaru_switch_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_switch_freya = class({})
function modifier_switch_freya:IsHidden() return false end
function modifier_switch_freya:IsDebuff() return true end
function modifier_switch_freya:IsPurgable() return false end
function modifier_switch_freya:IsPurgeException() return false end
function modifier_switch_freya:RemoveOnDeath() return false end
function modifier_switch_freya:AllowIllusionDuplicate() return true end
function modifier_switch_freya:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
										MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		       MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
							 
	                 }
    return func
end
function modifier_switch_freya:GetModifierSpellAmplify_Percentage()
return 0
end
function modifier_switch_freya:GetModifierBonusStats_Strength()
    return 10
end

function modifier_switch_freya:GetModifierBonusStats_Agility()
    return -30
end

function modifier_switch_freya:GetModifierBonusStats_Intellect()
    return 15
end
function modifier_switch_freya:GetModifierBaseAttackTimeConstant()
	return 3.0
end
function modifier_switch_freya:GetModifierModelChange()

    return "models/keyaru/flare/flare.vmdl"

end
function modifier_switch_freya:GetAttackSound()
	return "keyaru.magic_attack"
end

function modifier_switch_freya:GetModifierProjectileName()
	return "particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf"
end

function modifier_switch_freya:GetModifierProjectileSpeedBonus()
	return 900
end
function modifier_switch_freya:GetModifierAttackRangeBonus()
	return 650
end
function modifier_switch_freya:GetModifierModelScale()

	return 1
	
end
function modifier_switch_freya:OnCreated(table)
    if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
self.parent:SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )
    self.ability_level = self.ability:GetLevel()

	 self.parent:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)

    self.skills_table = {
                            

							["keyaru_heal"]="freya_fireball",
							["hero_of_recovery"]="freya_exp",
							["defiled_healing"]="freya_ryusei",
							
							
                        }


        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                  
                end
            end
        
		
           
        
		
      

  
    end
	end
end
function modifier_switch_freya:OnRefresh(table)
    if IsServer() then
    self:OnCreated(table)
	end
end
function modifier_switch_freya:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

         self.parent:SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("switch_freya_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end

LinkLuaModifier("modifier_switch_setsuna", "heroes/keyaru/keyaru.lua", LUA_MODIFIER_MOTION_NONE)

switch_setsuna = class({})
function switch_setsuna:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function switch_setsuna:IsStealable() return true end
function switch_setsuna:IsHiddenWhenStolen() return false end

function switch_setsuna:OnSpellStart()
    local caster = self:GetCaster()
 if caster:FindModifierByNameAndCaster("modifier_keyaru_switch", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_keyaru_switch", caster)
		caster:RemoveModifierByNameAndCaster("modifier_switch_freya", caster)

        --return nil
    end
	if caster:FindModifierByNameAndCaster("modifier_switch_setsuna", caster) then
	else
    caster:AddNewModifier(caster, self, "modifier_switch_setsuna", {})
	end
	 EmitSoundOn("keyaru.4_2", caster)
	 self:PlayEffects(300)
end
function switch_setsuna:PlayEffects( radius )

	local particle_cast = "particles/keyaru_switch_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_switch_setsuna = class({})
function modifier_switch_setsuna:IsHidden() return false end
function modifier_switch_setsuna:IsDebuff() return true end
function modifier_switch_setsuna:IsPurgable() return false end
function modifier_switch_setsuna:IsPurgeException() return false end
function modifier_switch_setsuna:RemoveOnDeath() return false end
function modifier_switch_setsuna:AllowIllusionDuplicate() return true end
function modifier_switch_setsuna:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
					MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
						MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
						 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					
							 
	                 }
    return func
end
function modifier_switch_setsuna:GetModifierMoveSpeedBonus_Constant()
  
	return 5
	
end
function modifier_switch_setsuna:GetModifierBonusStats_Strength()
    return -10
end

function modifier_switch_setsuna:GetModifierBonusStats_Agility()
    return 25
end

function modifier_switch_setsuna:GetModifierBonusStats_Intellect()
    return -10
end
function modifier_switch_setsuna:GetModifierBaseAttackTimeConstant()
	return 1.6
end

function modifier_switch_setsuna:GetModifierModelChange()

    return "models/keyaru/setsuna/setsuna.vmdl"

end

function modifier_switch_setsuna:GetModifierModelScale()

	return 1
	
end
function modifier_switch_setsuna:OnCreated(table)
    if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

	 self.parent:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY)

    self.skills_table = {
                            

							["keyaru_heal"]="ice_claws",
							["hero_of_recovery"]="setsuna_ice_barrage",
							["defiled_healing"]="setsuna_jump_kill",
							
							
                        }

    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                  
                end
            end
        end
		
           
        
		end
      

  
    end
end
function modifier_switch_setsuna:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_switch_setsuna:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

         

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("switch_setsuna_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end


switch_keyaru = class({})

function switch_keyaru:IsStealable() return true end
function switch_keyaru:IsHiddenWhenStolen() return false end
function switch_keyaru:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function switch_keyaru:OnSpellStart()
    local caster = self:GetCaster()
 if caster:FindModifierByNameAndCaster("modifier_keyaru_switch", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_keyaru_switch", caster)
		caster:RemoveModifierByNameAndCaster("modifier_switch_freya", caster)
		caster:RemoveModifierByNameAndCaster("modifier_switch_setsuna", caster)
			caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_INTELLECT)

    end
	self:PlayEffects(300)
	EmitSoundOn("keyaru.4", caster)
end



function switch_keyaru:PlayEffects( radius )

	local particle_cast = "particles/keyaru_switch_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end




--------------------------------------------


freya_fireball = class({})
function freya_fireball:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function freya_fireball:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	if target then
		point = target:GetOrigin()
	end

	local projectile_name = "particles/freya_fireball.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
	local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
	local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
	local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )

	-- get direction
	local direction = point-caster:GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	local sound_cast = "keyaru.fireball"
	
	EmitSoundOn( sound_cast, self:GetCaster() )

end

--------------------------------------------------------------------------------
-- Projectile
function freya_fireball:OnProjectileHitHandle( target, location, projectile )
	if not target then return end
	local caster = self:GetCaster()
	local int = self:GetCaster():GetIntellect()
	local scale = self:GetSpecialValueFor( "int_scale" ) * int
	if caster:HasTalent("special_bonus_keyaru_20_alt") and target:HasModifier("modifier_vengeance_mark") then
	self.add = 1.4
	else
	self.add = 1.0
	end

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = (self:GetAbilityDamage() + scale) * self.add,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()
    
	-- play effects
	self:PlayEffects( target, direction )
end

--------------------------------------------------------------------------------
function freya_fireball:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


freya_exp = class({})
LinkLuaModifier( "modifier_generic_burn", "modifiers/modifier_generic_burn", LUA_MODIFIER_MOTION_NONE )

function freya_exp:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function freya_exp:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration") 
	local int = caster:GetIntellect()
	local damage = self:GetSpecialValueFor("damage") * int

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
		damage = self:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_burn", -- modifier name
			{ duration = duration } -- kv
		)
	
		
	end


		self:PlayEffects( radius )
	end



function freya_exp:PlayEffects( radius )
	local particle_cast = "particles/freya_exp.vpcf"
	local sound_cast = "keyaru.exp"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end


freya_ryusei = class({})
LinkLuaModifier( "modifier_freya_ryusei", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
function freya_ryusei:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function freya_ryusei:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function freya_ryusei:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_freya_ryusei", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
	EmitGlobalSound("keyaru.4_1_1")
end
function freya_ryusei:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/freya_ryusei.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end


modifier_freya_ryusei = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_freya_ryusei:IsHidden()
	return true
end

function modifier_freya_ryusei:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_freya_ryusei:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local int = self:GetCaster():GetIntellect()
	local scale = self:GetAbility():GetSpecialValueFor( "int_scale" ) * int
	local damage = self:GetAbility():GetAbilityDamage() + scale

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	self:PlayEffects1()
end 
function modifier_freya_ryusei:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/freya_ryusei_model.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 1.3

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

function modifier_freya_ryusei:OnRefresh( kv )
	
end

function modifier_freya_ryusei:OnRemoved()
end

function modifier_freya_ryusei:OnDestroy()
	if not IsServer() then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = self.duration } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_freya_ryusei:PlayEffects()
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "keyaru.big_exp"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end


LinkLuaModifier("modifier_ice_claws", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ice_claws_debuff", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ice_claw_crit_cd", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE)
ice_claws = class({})
function ice_claws:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function ice_claws:GetIntrinsicModifierName()
    return "modifier_grand_donut"
end

function ice_claws:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 

    caster:EmitSound("keyaru.ice_claws")

    caster:AddNewModifier(caster, self, "modifier_ice_claws", { duration = duration } )
end
modifier_ice_claw_crit_cd = class({})

function modifier_ice_claw_crit_cd:IsPurgable()
    return false
end

modifier_ice_claws = class({})

function modifier_ice_claws:IsPurgable()
    return true
end

function modifier_ice_claws:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
			MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }

    return funcs
end

function modifier_ice_claws:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end
function modifier_ice_claws:GetEffectName()
    return "particles/ice_claws_buff.vpcf"
end

function modifier_ice_claws:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_ice_claws:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then		
			if not params.attacker:IsIllusion() then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ice_claws_debuff", {duration = 0.45 })
			end
		end
	end
end
function modifier_ice_claws:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end

		if self:GetCaster():HasTalent("special_bonus_keyaru_25_alt") and not self:GetCaster():HasModifier("modifier_ice_claw_crit_cd") then
		self.chance = 20
		else
		self.chance = 0
		end
		if RandomInt(0, 100)<self.chance then
			self.record = params.record
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ice_claw_crit_cd", {duration = 1.2 })
			return 140
		end
	end
end
function modifier_ice_claws:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil

			-- Play effects

		end
	end
end
function modifier_ice_claws:GetStatusEffectName()
    return "particles/ice_claws_buff.vpcf" 
end

function modifier_ice_claws:StatusEffectPriority()
    return 5
end


modifier_ice_claws_debuff = class({})

function modifier_ice_claws_debuff:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_ice_claws_debuff:GetModifierAttackSpeedBonus_Constant()
    return -50
end

function modifier_ice_claws_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -15
end

function modifier_ice_claws_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_ice_claws_debuff:StatusEffectPriority()
    return 10
end



setsuna_ice_barrage = class({})
LinkLuaModifier( "modifier_setsuna_ice_barrage", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE )
function setsuna_ice_barrage:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function setsuna_ice_barrage:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function setsuna_ice_barrage:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 0.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_setsuna_ice_barrage", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
end
function setsuna_ice_barrage:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/ice_barrage_ground.vpcf"
	local sound_cast = "keyaru.ice_barrage"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end


modifier_setsuna_ice_barrage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_setsuna_ice_barrage:IsHidden()
	return true
end

function modifier_setsuna_ice_barrage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_setsuna_ice_barrage:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetAbilityDamage()

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_setsuna_ice_barrage:OnRefresh( kv )
	
end

function modifier_setsuna_ice_barrage:OnRemoved()
end

function modifier_setsuna_ice_barrage:OnDestroy()
	if not IsServer() then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_setsuna_ice_barrage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/ice_barrage_crystal.vpcf"


	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end

setsuna_jump_kill = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_setsuna_jump_kill_astral", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV

function setsuna_jump_kill:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("keyaru_switch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function setsuna_jump_kill:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()



	local radius = 300
	
	local debuffDuration = 1.25



if target:TriggerSpellAbsorb( self ) then return end

	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )

	-- load data
   caster:AddNewModifier(caster, self, "modifier_setsuna_jump_kill_astral", {duration = 0.2})	
	
	
	
	

end


modifier_setsuna_jump_kill_astral = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_setsuna_jump_kill_astral:IsHidden()
	return false
end

function modifier_setsuna_jump_kill_astral:IsDebuff()
	return false
end

function modifier_setsuna_jump_kill_astral:IsStunDebuff()
	return true
end

function modifier_setsuna_jump_kill_astral:IsPurgable()
	return true
end

function modifier_setsuna_jump_kill_astral:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_setsuna_jump_kill_astral:OnCreated( kv )
	    if IsServer() then
	self:PlayEffects()
	self:GetParent():AddNoDraw()
end
end



function modifier_setsuna_jump_kill_astral:OnRemoved()
end

function modifier_setsuna_jump_kill_astral:OnDestroy()
	if not IsServer() then return end


	local caster = self:GetCaster()


	self:GetParent():RemoveNoDraw()

	
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	local damage = self:GetAbility():GetSpecialValueFor( "damage" ) 
	local duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
	
	

local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
			for _,enemy in pairs(enemies) do
    enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = 1})
damageTable.victim = enemy	
	ApplyDamage(damageTable)
	end
	local point = caster:GetOrigin()
	local radius = 350
		self:PlayEffects( point, radius, 2 )
		self:PlayEffects2( point, radius, 2 )
	EmitSoundOn("keyaru.4_2_1", caster)
end
function modifier_setsuna_jump_kill_astral:PlayEffects2( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/ice_blood.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_setsuna_jump_kill_astral:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_setsuna_jump_kill_astral:PlayEffects()
	-- Get Resources
	    if IsServer() then
	local particle_cast1 = "particles/vergil_blur.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetCaster():GetOrigin() )

	
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	end

end


LinkLuaModifier("modifier_georgius_armor", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_georgius_armor_awakened", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_georgius_armor_invul", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_keyaru_music", "heroes/keyaru/keyaru", LUA_MODIFIER_MOTION_NONE)
 

georgius_armor = class({})

function georgius_armor:IsStealable() return true end
function georgius_armor:IsHiddenWhenStolen() return false end

function georgius_armor:OnUpgrade()
local FastAbilities = 
	{
		"pain_of_the_weak",
		"keyaru_mass_heal",
	
	}

	for _,FastAbility in pairs(FastAbilities) do
	   	FastAbility = self:GetCaster():FindAbilityByName(FastAbility)
	   	if self:GetCaster():IsRealHero() then
	      	if FastAbility then
	        	FastAbility:SetLevel(1)
	      	end
	    end
end
end

function georgius_armor:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
       caster:RemoveModifierByNameAndCaster("modifier_keyaru_switch", caster)
		caster:RemoveModifierByNameAndCaster("modifier_switch_setsuna", caster)
        caster:RemoveModifierByNameAndCaster("modifier_switch_freya", caster)
local modifier = caster:FindModifierByNameAndCaster("modifier_hero_of_recovery",caster)
	local current = modifier:GetStackCount()
	caster:AddNewModifier(caster, self, "modifier_georgius_armor_invul", {duration = 1.8})
	if  current > 300 then
 	   caster:AddNewModifier(caster, self, "modifier_georgius_armor_awakened", {duration = fixed_duration})
	   self:PlayEffects2(500)
	  else
 		caster:AddNewModifier(caster, self, "modifier_georgius_armor", {duration = fixed_duration})
 		self:PlayEffects(400)
end
    self:EndCooldown()

   
end

function georgius_armor:PlayEffects( radius )

	local particle_cast = "particles/georgius_armor_active.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )


end
function georgius_armor:PlayEffects2( radius )

	local particle_cast = "particles/georgius_armor_active_2nd.vpcf"

	-- Create Particle
local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

end
modifier_georgius_armor_invul = class({})
function modifier_georgius_armor_invul:IsHidden() return false end
function modifier_georgius_armor_invul:IsDebuff() return true end
function modifier_georgius_armor_invul:IsPurgable() return false end
function modifier_georgius_armor_invul:IsPurgeException() return false end
function modifier_georgius_armor_invul:RemoveOnDeath() return true end
function modifier_georgius_armor_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_georgius_armor_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_georgius_armor_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end


---------------------------------------------------------------------------------------------------------------------
modifier_georgius_armor = class({})
function modifier_georgius_armor:IsHidden() return false end
function modifier_georgius_armor:IsDebuff() return true end
function modifier_georgius_armor:IsPurgable() return false end
function modifier_georgius_armor:IsPurgeException() return false end
function modifier_georgius_armor:RemoveOnDeath() return true end
function modifier_georgius_armor:AllowIllusionDuplicate() return true end
function modifier_georgius_armor:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("georgius_armor_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_georgius_armor:DeclareFunctions()
    local func = {  
    				
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,						}
    return func
end

function modifier_georgius_armor:GetModifierBonusStats_Intellect()
    return 100
end
function modifier_georgius_armor:GetModifierProcAttack_BonusDamage_Magical()

    return 100
end


function modifier_georgius_armor:GetModifierBonusStats_Strength()
	return 25

end

function modifier_georgius_armor:GetModifierBonusStats_Agility()

    return 25


end




function modifier_georgius_armor:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

 self.skills_table = {
                            ["georgius_armor"] = "pain_of_the_weak",
							["keyaru_switch"] = "keyaru_mass_heal",
							
                            
                        }
		
    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/georgius_armor_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

		EmitGlobalSound("keyaru.theme")
		EmitSoundOn("keyaru.5", self.parent)
		
		
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_georgius_armor:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_georgius_armor:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		StopGlobalSound("keyaru.theme")

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("georgius_armor_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
modifier_georgius_armor_awakened = class({})
function modifier_georgius_armor_awakened:IsHidden() return false end
function modifier_georgius_armor_awakened:IsDebuff() return true end
function modifier_georgius_armor_awakened:IsPurgable() return false end
function modifier_georgius_armor_awakened:IsPurgeException() return false end
function modifier_georgius_armor_awakened:RemoveOnDeath() return true end
function modifier_georgius_armor_awakened:AllowIllusionDuplicate() return true end
function modifier_georgius_armor_awakened:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("georgius_armor_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_georgius_armor_awakened:DeclareFunctions()
    local func = {  
    				
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,	
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end

function modifier_georgius_armor_awakened:GetModifierBonusStats_Intellect()
    return 150
end
function modifier_georgius_armor_awakened:GetModifierProcAttack_BonusDamage_Magical()

    return 150
end


function modifier_georgius_armor_awakened:GetModifierBonusStats_Strength()
	return 40

end
function modifier_georgius_armor_awakened:GetModifierBonusStats_Agility()

    return 40


end




function modifier_georgius_armor_awakened:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

 self.skills_table = {
                            ["georgius_armor"] = "pain_of_the_weak",
							["keyaru_switch"] = "keyaru_mass_heal",
							
                            
                        }
		
    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/georgius_armor_aura_awakened.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

    
		EmitSoundOn("keyaru.2_5", self.parent)
		EmitGlobalSound("keyaru.true_theme")
		
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_georgius_armor_awakened:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_georgius_armor_awakened:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		StopGlobalSound("keyaru.true_theme")

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("georgius_armor_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end


pain_of_the_weak = class({})
LinkLuaModifier("modifier_pain_of_the_weak_enemy", "heroes/keyaru/keyaru.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pain_of_the_weak_self", "heroes/keyaru/keyaru.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pain_of_the_weak_damage", "heroes/keyaru/keyaru.lua", LUA_MODIFIER_MOTION_NONE)

function pain_of_the_weak:OnSpellStart()
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = target:GetOrigin()
    local duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = 7})
	target:AddNewModifier(caster, self, "modifier_pain_of_the_weak_damage", {duration = 7.02})
	target:AddNewModifier(caster, self, "modifier_pain_of_the_weak_enemy", {duration = 7})
    caster:AddNewModifier(caster, self, "modifier_pain_of_the_weak_self", {duration = 4})
		self.sound_cast = "keyaru.6"
	EmitSoundOn( self.sound_cast, caster )
	local modifier = caster:FindModifierByNameAndCaster("modifier_hero_of_recovery",caster)
	local current = modifier:GetStackCount()
	if current > 250  then
	self:PlayEffects2(point,250,7)
	else
	self:PlayEffects(point,250,7)
	end
	end
function pain_of_the_weak:PlayEffects( point, radius, duration )
self.caster = self:GetCaster()
		self.arena_barrier11 = "particles/pain_of_the_weak_base.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, self.caster )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, point )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )
	ParticleManager:ReleaseParticleIndex( self.arena_barrier )

end
function pain_of_the_weak:PlayEffects2( point, radius, duration )
self.caster = self:GetCaster()
		self.arena_barrier11 = "particles/pain_of_the_weak_advanced.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, self.caster )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, point )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )
	ParticleManager:ReleaseParticleIndex( self.arena_barrier )

end
modifier_pain_of_the_weak_self = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_pain_of_the_weak_self:IsHidden()
	return false
end

function modifier_pain_of_the_weak_self:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_pain_of_the_weak_self:IsStunDebuff()
	return true
end

function modifier_pain_of_the_weak_self:IsPurgable()
	return false
end

function modifier_pain_of_the_weak_self:RemoveOnDeath()
	return false
end


function modifier_pain_of_the_weak_self:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_pain_of_the_weak_self:GetOverrideAnimation()
	return ACT_DOTA_AMBUSH
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_pain_of_the_weak_self:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end


modifier_pain_of_the_weak_damage = class({})

--------------------------------------------------------------------------------

function modifier_pain_of_the_weak_damage:IsDebuff()
	return true
end
function modifier_pain_of_the_weak_damage:IsPurgable()
	return false
end
function modifier_pain_of_the_weak_damage:IsStunDebuff()
	return true
end
function modifier_pain_of_the_weak_damage:OnDestroy()
local caster = self:GetCaster()
local modifier = caster:FindModifierByNameAndCaster("modifier_hero_of_recovery",caster)
	local current = modifier:GetStackCount()
	if current > 250  then	
	self.damage = 15000	
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = 15000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
		ApplyDamage( self.damageTable )
	else
self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = 15000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
		ApplyDamage( self.damageTable )
end
	



end


modifier_pain_of_the_weak_enemy = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_pain_of_the_weak_enemy:IsHidden()
	return false
end

function modifier_pain_of_the_weak_enemy:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_pain_of_the_weak_enemy:IsStunDebuff()
	return true
end

function modifier_pain_of_the_weak_enemy:IsPurgable()
	return false
end

function modifier_pain_of_the_weak_enemy:RemoveOnDeath()
	return false
end

function modifier_pain_of_the_weak_enemy:OnCreated()
    if IsServer() then
self:StartIntervalThink(4.0)
end

end
function modifier_pain_of_the_weak_enemy:OnIntervalThink()
    if IsServer() then
local caster = self:GetCaster()
local modifier = caster:FindModifierByNameAndCaster("modifier_hero_of_recovery",caster)
	local current = modifier:GetStackCount()
if  current > 250 then
self.sound_cast4 = "keyaru.6_5"
	EmitSoundOn( self.sound_cast4, caster )
else
		self.sound_cast = "keyaru.6_1"
	EmitSoundOn( self.sound_cast, caster )
			self.sound_cast2 = "keyaru.6_2"
	EmitSoundOn( self.sound_cast2, caster )
			self.sound_cast3 = "keyaru.6_3"
	EmitSoundOn( self.sound_cast3, caster )
	self.sound_cast4 = "keyaru.6_4"
	EmitSoundOn( self.sound_cast4, caster )
end
end
end
function modifier_pain_of_the_weak_enemy:OnRemoved()
end



--------------------------------------------------------------------------------
-- Status Effects
function modifier_pain_of_the_weak_enemy:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end



keyaru_mass_heal = class({})
LinkLuaModifier( "modifier_keyaru_mass_heal", "modifiers/modifier_keyaru_mass_heal", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function keyaru_mass_heal:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function keyaru_mass_heal:OnSpellStart()
	-- unit identifier
	
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
local modifier = caster:FindModifierByNameAndCaster("modifier_hero_of_recovery",caster)
	local current = modifier:GetStackCount()
	local int = self:GetCaster():GetIntellect() * 2
	local heal_special = current * 2 + int
	local damage = self:GetSpecialValueFor("damage") + heal_special
modifier:SetStackCount(current + 5)
	local radius = self:GetSpecialValueFor("radius") 
	
	local debuffDuration = self:GetSpecialValueFor("duration")
	
	
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	

	local vision_radius = 900
	local vision_duration = 6

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

	-- Precache damage	 
	
	for _,enemy in pairs(enemies) do
		-- Apply damage
			damageTable.victim = enemy
		ApplyDamage(damageTable)
     if current > 249 then
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 1.0 } -- kv
		)
		end
		self:PlayEffects( enemy )
		
		
		
	end

	

	self.sound_cast4 = "keyaru.mass_heal"
	EmitSoundOn( self.sound_cast4, caster )
	
		self:PlayEffects2( point,radius, 1.5 )
	
	end
function keyaru_mass_heal:PlayEffects2( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/keyaru_mass_heal.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function keyaru_mass_heal:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/keyaru_defiled_heal.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end






keyaru_dong_slap = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV

function keyaru_dong_slap:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local result = UnitFilter(
		hTarget,	-- Target Filter
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- Team Filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- Unit Filter
		0,	-- Unit Flag
		self:GetCaster():GetTeamNumber()	-- Team reference
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS
end
--------------------------------------------------------------------------------
-- Ability Start
function keyaru_dong_slap:OnSpellStart()
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
function keyaru_dong_slap:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	if target:HasModifier("modifier_vengeance_mark") then
		self.damage = self:GetAbilityDamage() * 1.5
	self.duration = self:GetSpecialValueFor( "stun_duration" ) * 1.5
	else
	self.damage = self:GetAbilityDamage()
	self.duration = self:GetSpecialValueFor( "stun_duration" )
	end

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
		damage = self.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = self.duration } -- kv
	)
	end

	-- Play effects
	self:PlayEffects( target, target:GetOrigin() , caster:GetForwardVector() )
	local sound_cast = "keyaru.7"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function keyaru_dong_slap:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

--------------------------------------------------------------------------------
function keyaru_dong_slap:PlayEffects( target, origin, direction )
	-- Get Resources
	local particle_cast = "particles/dong_slap.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end