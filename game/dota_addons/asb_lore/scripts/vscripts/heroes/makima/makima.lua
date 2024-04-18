makima_contract = class({})
LinkLuaModifier( "modifier_makima_contract", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_makima_contract_self", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_devil_in_human_form", "heroes/makima/makima.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV

function makima_contract:GetIntrinsicModifierName()
    return "modifier_devil_in_human_form"
end
--------------------------------------------------------------------------------
-- Ability Start
function makima_contract:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- check dragon modifier
	if target == caster then self:EndCooldown()
	return
	else
		self:Hit( target, false )
end
		-- play effects
	end

-- Helper
function makima_contract:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if not target:IsIllusion() then
	if target:HasModifier("modifier_makima_contract")then 
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 1.5 } -- kv
	)
	local sound_cast = "makima.1_1"
	EmitSoundOn( sound_cast, target )
	else
	if target:GetTeamNumber()== caster:GetTeamNumber() then

	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_makima_contract", -- modifier name
		{} -- kv
	)
	self:PlayEffects(target)
caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_makima_contract_self", -- modifier name
		{} -- kv
	)
	-- Play effects

	local sound_cast = "makima.1"
	EmitSoundOn( sound_cast, target )
	else
	if caster:HasModifier("makima_temple_of_death") or caster:HasModifier("makima_temple_of_death_truth") or target:HasModifier("modifier_makima_control_3") then
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_makima_contract", -- modifier name
		{} -- kv
	)
	self:PlayEffects(target)
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_makima_contract_self", -- modifier name
		{} -- kv
	)
	else
	if caster:HasTalent("special_bonus_makima_20") then
	self.damage2 = {
			victim = target,
			attacker = caster,
			damage = caster:GetIntellect(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}

		ApplyDamage( self.damage2 )
		EmitSoundOn( "makima.impact", target )
		self:PlayEffects2(target)
	else
	self:EndCooldown()
	end
	end
	end
end
end
end
function makima_contract:PlayEffects(target)
	-- Get Resources
	local particle_cast = "particles/makima_contract_success.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function makima_contract:PlayEffects2(target)
	-- Get Resources
	local particle_cast = "particles/makima_control_mind_break.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_makima_contract = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_makima_contract:IsHidden()
	return false
end

function modifier_makima_contract:IsDebuff()
	return false
end

function modifier_makima_contract:IsStunDebuff()
	return false
end
function modifier_makima_contract:RemoveOnDeath()
	return true
end
function modifier_makima_contract:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_makima_contract:OnCreated( kv )
	-- references
	local level = self:GetCaster():GetLevel()
	self.spd = (level * 0.2) + 5
	self.attack = (level * 2) + 15



end



function modifier_makima_contract:OnDestroy( kv )
--self:GetCaster():RemoveModifierByName("modifier_makima_contract_self")
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_makima_contract:DeclareFunctions()
	local funcs = {
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end
function modifier_makima_contract:GetModifierSpellAmplify_Percentage()

    return self.spd
end

function modifier_makima_contract:GetModifierPreAttack_BonusDamage()
    return self.attack
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_makima_contract:GetEffectName()
	return "particles/makima_contract.vpcf"
end

function modifier_makima_contract:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_makima_contract_self = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_makima_contract_self:IsHidden()
	return false
end

function modifier_makima_contract_self:IsDebuff()
	return false
end

function modifier_makima_contract_self:IsStunDebuff()
	return false
end
function modifier_makima_contract_self:RemoveOnDeath()
	return false
end
function modifier_makima_contract_self:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_makima_contract_self:OnCreated( kv )
	

	if IsServer() then
		self:SetStackCount(1)
	    self:StartIntervalThink(FrameTime())
	end
end

function modifier_makima_contract_self:OnRefresh( kv )
--self:SetStackCount(self:GetStackCount() + 1)
end

function modifier_makima_contract_self:OnIntervalThink( kv )
local caster = self:GetCaster()
self.base = 0
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_makima_contract") and not enemy:IsInvulnerable() then
	local i1 = self.base
	self.base = i1 + 1
	end
	end
	self:SetStackCount(self.base)
end


--------------------------------------------------------------------------------
modifier_devil_in_human_form = class ({})
function modifier_devil_in_human_form:IsHidden() return true end
function modifier_devil_in_human_form:IsDebuff() return false end
function modifier_devil_in_human_form:IsPurgable() return false end
function modifier_devil_in_human_form:IsPurgeException() return false end
function modifier_devil_in_human_form:RemoveOnDeath() return false end

function modifier_devil_in_human_form:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_devil_in_human_form:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_devil_in_human_form:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("makima_bang")
        if vongolle and not vongolle:IsNull() then
            if self:GetParent():HasModifier("modifier_temple_of_death") or self:GetParent():HasModifier("modifier_temple_of_death_true")  then
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
	
	
	
	
	
	
LinkLuaModifier("modifier_control_devil", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_control_devil_damage_cd", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE)

control_devil = class({})

function control_devil:GetIntrinsicModifierName()
    return "modifier_control_devil"
end

function control_devil:OnSpellStart()
	local caster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local fv = caster:GetForwardVector()
	local position = caster:GetAbsOrigin() + fv * 100
	self.Dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
	--self.Dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1) 
	self.Dummy:SetAbsOrigin(position)
    fv.z = 0
    local fwtarget =  fv * -1
    self.Dummy:SetForwardVector((fwtarget ):Normalized())
    local Fx
    Fx = ParticleManager:CreateParticle( "particles/hostage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.Dummy )
    ParticleManager:SetParticleControl(Fx, 3, position ) 
    ParticleManager:SetParticleControl(Fx, 4, fwtarget ) 
	local dummy = self.Dummy 
	self:FindName(hTarget:GetName())
	Say(caster, "Say Say " .. self:FindName(hTarget:GetName()) .. ".", true)
	Timers:CreateTimer(2,function()
		GameRules:SendCustomMessage(self:FindName(hTarget:GetName()) .. "?..",0,0)
	end)
	Timers:CreateTimer(3.5,function()
		Say(caster, "Say good.", true)
		ParticleManager:DestroyParticle(Fx, true)
		ParticleManager:ReleaseParticleIndex(Fx)
		Fx2 = ParticleManager:CreateParticle( "particles/hostage_endcap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.Dummy )
		ParticleManager:SetParticleControl(Fx2, 3, position ) 
		ParticleManager:SetParticleControl(Fx2, 4, fwtarget ) 
	end)
	Timers:CreateTimer(4.5, function()
		
		ParticleManager:DestroyParticle(Fx2, true)
		ParticleManager:ReleaseParticleIndex(Fx2)
		UTIL_Remove(dummy)
		local damageTable = {
			victim = hTarget,
			attacker = caster,
			damage = self:GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		local slash_pfx =   ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_wildaxes_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControlEnt(slash_pfx, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(slash_pfx)
		ApplyDamage(damageTable)
	end)
end
function control_devil:FindName(name)
	local values = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
	local hHeroTable
	local index
	for i, tHeroTable in pairs(values) do
        if tHeroTable.override_hero == name then
			 hHeroTable = tHeroTable
			 index = i
		end
	end
	return index

end
--------------------------------------------------------------------------------
modifier_control_devil = class({})
function modifier_control_devil:IsHidden()
	return false
end

function modifier_control_devil:IsDebuff()
	return false
end

function modifier_control_devil:IsPurgable()
	return false
end

function modifier_control_devil:RemoveOnDeath()
	return false
end
function modifier_control_devil:AllowIllusionDuplicate()
 return true 
 end
--------------------------------------------------------------------------------

function modifier_control_devil:OnCreated( kv )
	self.parent = self:GetParent()	
end



--------------------------------------------------------------------------------

function modifier_control_devil:DeclareFunctions()
	local funcs = {

			MODIFIER_PROPERTY_MIN_HEALTH,
					MODIFIER_EVENT_ON_TAKEDAMAGE,

	}

	return funcs
end

function modifier_control_devil:GetMinHealth()
  local modifier = self:GetParent():FindModifierByNameAndCaster("modifier_makima_contract_self",self:GetParent())
  if modifier and modifier:GetStackCount() > 0 then
   if self.parent:HasScepter() and not self:GetParent():HasModifier("modifier_control_devil_damage_cd") and not self:GetParent():HasModifier("modifier_temple_of_death_2nd_arc") and not self:GetParent():HasModifier("modifier_temple_of_death_true") then
 return 1
else 
	return
	end
	else
	return
	end
end


function modifier_control_devil:OnTakeDamage(keys)
	if IsServer() then
    local caster = self:GetCaster()
	
		local attacker = keys.attacker
	local target = keys.unit
	
	--if attacker:HasModifier( "modifier_fountain_damage" ) then 
				--	else
			
			
		   
			
				if target == caster then
				if self:GetParent():GetHealth() <= 20 then
				if not self:GetParent():IsIllusion() then
				if self:GetParent():HasModifier("modifier_makima_contract_self") and not self:GetParent():HasModifier("modifier_temple_of_death") and self.parent:HasScepter() then
		        if not self:GetParent():HasModifier("modifier_control_devil_damage_cd") then
				
			local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_makima_contract") and not enemy:IsInvulnerable() then
				local hp = self:GetParent():GetMaxHealth() * 0.8
			     
				 self:GetParent():SetHealth(hp)
				enemy:Kill(self:GetAbility(),caster)
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_control_devil_damage_cd", {duration = 200})
					self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1})
					EmitSoundOn("makima.2_effect", self.parent)
					self:PlayEffects(444)
					
					return
				end
               
		end
			end
		end
		end
	end
end
end
end

function modifier_control_devil:PlayEffects( radius )

	local particle_cast = "particles/blood_moon_arc_exp2.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end


modifier_control_devil_damage_cd = class({})

--------------------------------------------------------------------------------

function modifier_control_devil_damage_cd:IsHidden()
	return false
end

function modifier_control_devil_damage_cd:IsDebuff()
	return false
end

function modifier_control_devil_damage_cd:IsPurgable()
	return false
end

function modifier_control_devil_damage_cd:RemoveOnDeath()
	return false
end


LinkLuaModifier("modifier_makima_slavebook", "heroes/makima/makima.lua", LUA_MODIFIER_MOTION_NONE)

makima_slavebook = class({})

function makima_slavebook:IsStealable() return true end
function makima_slavebook:IsHiddenWhenStolen() return false end

function makima_slavebook:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("angel_devil")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	self:GetCaster():FindAbilityByName("makima_slavebook_close"):SetLevel(1)
end
function makima_slavebook:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_makima_slavebook", {})

end
---------------------------------------------------------------------------------------------------------------------
modifier_makima_slavebook = class({})
function modifier_makima_slavebook:IsHidden() return false end
function modifier_makima_slavebook:IsDebuff() return true end
function modifier_makima_slavebook:IsPurgable() return false end
function modifier_makima_slavebook:IsPurgeException() return false end
function modifier_makima_slavebook:RemoveOnDeath() return true end
function modifier_makima_slavebook:AllowIllusionDuplicate() return true end


function modifier_makima_slavebook:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()


    self.skills_table = {
                            
							["makima_slavebook"]="makima_slavebook_close",
							["makima_contract"]="angel_devil",
							["control_devil"]="bomb_devil",
							["makima_control"]="katana_devil",
					
							
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
function modifier_makima_slavebook:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_makima_slavebook:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("makima_slavebook_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end


makima_slavebook_close = class({})

function makima_slavebook_close:OnSpellStart()
    local caster = self:GetCaster() 

    if caster:FindModifierByNameAndCaster("modifier_makima_slavebook", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_makima_slavebook", caster)

        --return nil
    end
end




angel_devil = class({})
LinkLuaModifier("modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angel_devil_curse", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE)

function angel_devil:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("bomb_devil")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function angel_devil:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/angel_devil_model.vpcf"
	local projectile_speed = self:GetSpecialValueFor("speed")
	local projectile_distance = self:GetSpecialValueFor("range")
	local projectile_start_radius = self:GetSpecialValueFor("width")
	local projectile_end_radius = self:GetSpecialValueFor("width")
	local projectile_vision = 0

local iint = self:GetSpecialValueFor( "int_scale" )
self.int = caster:GetIntellect() * iint

	local min_damage = self:GetSpecialValueFor( "damage" ) + self.int
	local max_distance = self:GetSpecialValueFor("range")
	local slow = self:GetSpecialValueFor( "slow" )
	local duration = self:GetSpecialValueFor( "slow_duration" )


	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()

	-- logic
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),

		ExtraData = {
			originX = origin.x,
			originY = origin.y,
			originZ = origin.z,

			max_distance = max_distance,
			min_stun = duration,
			max_stun = duration,

			min_damage = min_damage,
			bonus_damage = 0,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Effects
	local sound_cast = "makima.3_1"
	EmitSoundOn( sound_cast, caster )
	local sound_cast = "makima.3_1_2"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Projectile
function angel_devil:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
local caster = self:GetCaster()
	if hTarget==nil then return end
local percent = hTarget:GetMaxHealth() * 0.05
	-- calculate distance percentage
	local origin = Vector( extraData.originX, extraData.originY, extraData.originZ )
	local distance = (vLocation-origin):Length2D()
	local bonus_pct = math.min(1,distance/extraData.max_distance)

	-- damage
	
	local damageTable = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = extraData.min_damage + extraData.bonus_damage*bonus_pct + percent,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun
	hTarget:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_root", -- modifier name
		{ duration = 1.5 } -- kv
	)

if caster:HasTalent("special_bonus_makima_25_alt") then
hTarget:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_angel_devil_curse", -- modifier name
		{ duration = 5 } -- kv
	)
end

	-- effects
	local sound_cast = "makima.3_1_1"
	EmitSoundOn( sound_cast, hTarget )

	return true
end
modifier_angel_devil_curse = class({})
function modifier_angel_devil_curse:IsHidden() return false end
function modifier_angel_devil_curse:IsDebuff() return true end
function modifier_angel_devil_curse:IsPurgable() return false end
function modifier_angel_devil_curse:IsPurgeException() return false end
function modifier_angel_devil_curse:RemoveOnDeath() return true end
function modifier_angel_devil_curse:AllowIllusionDuplicate() return false end





function modifier_angel_devil_curse:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

        self:StartIntervalThink(0.5)

       
    end

function modifier_angel_devil_curse:OnIntervalThink()
self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.

	}		self.damageTable.victim = self:GetParent()
	self.damageTable.damage = 1.5/100*self:GetParent():GetMaxHealth()
	ApplyDamage( self.damageTable )

	
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_angel_devil_curse:GetEffectName()
	return "particles/angel_devil_burn.vpcf"
end

function modifier_angel_devil_curse:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




bomb_devil = class({})
LinkLuaModifier( "modifier_bomb_devil", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
function bomb_devil:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("katana_devil")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function bomb_devil:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function bomb_devil:OnSpellStart()
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
		"modifier_bomb_devil", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
	EmitGlobalSound("makima.3_2")
end
function bomb_devil:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/bomb_devil_explosion_area.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end



modifier_bomb_devil = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bomb_devil:IsHidden()
	return true
end

function modifier_bomb_devil:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bomb_devil:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if self:GetCaster():HasTalent("special_bonus_makima_20_alt") then
	self.int = self:GetCaster():GetIntellect()
	else
	self.int = 0
	end
	local damage = self:GetAbility():GetAbilityDamage() + self.int

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
function modifier_bomb_devil:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/test_bomb_devil_nuke.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 0.9

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

function modifier_bomb_devil:OnRefresh( kv )
	
end

function modifier_bomb_devil:OnRemoved()
end

function modifier_bomb_devil:OnDestroy()
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
function modifier_bomb_devil:PlayEffects()
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "makima.3_2_exp"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

katana_devil = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_katana_devil", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_money_money", "heroes/makima/makima.lua", LUA_MODIFIER_MOTION_NONE )
function katana_devil:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("makima_slavebook")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function katana_devil:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end

	-- add debuff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_katana_devil", -- modifier name
		{ duration = 1 } -- kv
	)

	-- play effects
	self:PlayEffects1()
end
function katana_devil:PlayEffects1()
	-- Get Resources
	local sound_cast = "makima.3_3"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end





modifier_katana_devil = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_katana_devil:IsHidden()
	return true
end

function modifier_katana_devil:IsDebuff()
	return true
end

function modifier_katana_devil:IsStunDebuff()
	return false
end

function modifier_katana_devil:IsPurgable()
	return false
end

function modifier_katana_devil:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_katana_devil:OnCreated( kv )
if IsServer() then
	local caster = self:GetCaster()
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	  local int = caster:GetIntellect()
	  local scale = self:GetAbility():GetSpecialValueFor( "int_scale" ) * int

	  self.damage = self:GetAbility():GetSpecialValueFor( "damage" )  +scale
	 
	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
end
end

function modifier_katana_devil:OnRefresh( kv )
	
end

function modifier_katana_devil:OnRemoved()
end

function modifier_katana_devil:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_katana_devil:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function modifier_katana_devil:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_katana_devil:Silence()
	-- add silence


	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- play effects
	self:PlayEffects()

	local sound_cast = "makima.3_3_3"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_katana_devil:GetEffectName()
	return ""
end

function modifier_katana_devil:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_katana_devil:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/katana_devil_cuts.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end




makima_control = class({})

LinkLuaModifier("modifier_makima_control", "heroes/makima/makima.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_makima_control_chains", "heroes/makima/makima.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_makima_control_3", "heroes/makima/makima.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_makima_control_agro", "heroes/makima/makima.lua", LUA_MODIFIER_MOTION_NONE)

function makima_control:OnSpellStart()
local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
local target = self:GetCursorTarget()

	local modifier = target:FindModifierByNameAndCaster("modifier_makima_control_chains",caster)
	if not modifier then
	if caster:HasTalent("special_bonus_makima_25") then
		self.damage2 = {
			victim = target,
			attacker = caster,
			damage = caster:GetIntellect() * 1.5,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}

		ApplyDamage( self.damage2 )
		end
local duration2 = self:GetSpecialValueFor("stun_duration")
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = duration2})
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_makima_control_chains", {})
	EmitSoundOn("makima.4_chains", self:GetCursorTarget())
		EmitSoundOn("makima.4_chains1", self:GetCursorTarget())
	self:PlayEffects(target)
	else
	local stack = modifier:GetStackCount()
	if stack == 1 then
	if caster:HasTalent("special_bonus_makima_25") then
		self.damage2 = {
			victim = target,
			attacker = caster,
			damage = caster:GetIntellect() * 1.5,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}

		ApplyDamage( self.damage2 )
		end
	local duration3 = self:GetSpecialValueFor("agro_duration")
	modifier:SetStackCount(2)
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_makima_control_agro", {duration = duration3})
			EmitSoundOn("makima.4_order", self:GetCursorTarget())
			EmitSoundOn("makima.4_order1", self:GetCursorTarget())
		--	self:PlayEffects1(target)
	elseif stack == 2 then
	self:PlayEffects2(target)
	local int = caster:GetIntellect()
	local scale = self:GetSpecialValueFor("int_scale")
	local damage = int * scale
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
		modifier:SetStackCount(3)
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_makima_control_3", {})
			EmitSoundOn("makima.4_almost_controlled", self:GetCursorTarget())
			EmitSoundOn("makima.4_almost_controlled1", self:GetCursorTarget())
	else
	self:PlayEffects3(target)
	target:RemoveModifierByNameAndCaster("modifier_makima_control_chains",caster)
	target:RemoveModifierByNameAndCaster("modifier_makima_control_3",caster)
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_makima_control", {duration = duration})
			EmitSoundOn("makima.4_control", self:GetCursorTarget())

	
   	end
	end
end
function makima_control:PlayEffects(target)
	-- Get Resources
	local particle_cast = "particles/makima_control_begil.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

function makima_control:PlayEffects2(target)
	-- Get Resources
	local particle_cast = "particles/makima_control_mind_break.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function makima_control:PlayEffects3(target)
	-- Get Resources
	local particle_cast = "particles/makima_full_control.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_makima_control_agro = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_makima_control_agro:IsHidden()
	return false
end

function modifier_makima_control_agro:IsDebuff()
	return true
end

function modifier_makima_control_agro:IsStunDebuff()
	return false
end

function modifier_makima_control_agro:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_makima_control_agro:OnCreated( kv )
	if IsServer() then
	self:StartIntervalThink(1)
	local caster = self:GetCaster()
		-- two not working...?
		-- self:GetParent():SetAggroTarget( self:GetCaster() )
		-- self:GetParent():SetAttacking( self:GetCaster() )
		local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	
		self:GetParent():SetForceAttackTarget( enemy ) -- for creeps
		self:GetParent():MoveToTargetToAttack( enemy ) -- for heroes
		return
		end
	end
end
--end

function modifier_makima_control_agro:OnIntervalThink( kv )

if IsServer() then
local caster = self:GetCaster()
		-- two not working...?
		-- self:GetParent():SetAggroTarget( self:GetCaster() )
		-- self:GetParent():SetAttacking( self:GetCaster() )
		local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	if not enemy == caster then
		self:GetParent():SetForceAttackTarget( enemy ) -- for creeps
		self:GetParent():MoveToTargetToAttack( enemy ) -- for heroes
		return
		end
	end
end
end

function modifier_makima_control_agro:OnRemoved()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )
	end
end

function modifier_makima_control_agro:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_makima_control_agro:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_makima_control_agro:GetStatusEffectName()
	return "particles/makima_control_2nd.vpcf"
end
modifier_makima_control_3 = class({})
function modifier_makima_control_3:IsHidden() return false end
function modifier_makima_control_3:IsDebuff() return false end
function modifier_makima_control_3:IsPurgable() return false end
function modifier_makima_control_3:IsPurgeException() return false end
function modifier_makima_control_3:RemoveOnDeath() return false end


modifier_makima_control_chains = class({})
function modifier_makima_control_chains:IsHidden() return false end
function modifier_makima_control_chains:IsDebuff() return true end
function modifier_makima_control_chains:IsPurgable() return false end
function modifier_makima_control_chains:IsPurgeException() return false end
function modifier_makima_control_chains:RemoveOnDeath() return false end
function modifier_makima_control_chains:OnCreated()
if IsServer() then
self:SetStackCount(1)
	local caster = self:GetCaster()
	local particle_cast = "particles/makima_control_visual.vpcf"
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(caster:GetPlayerID())

	self.effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent(),Player)
	end
end

end

function modifier_makima_control_chains:OnDestroy( kv )
if IsServer() then
local caster = self:GetCaster()
   self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

		if self.effect_cast then
			ParticleManager:DestroyParticle(self.effect_cast, false)
        ParticleManager:ReleaseParticleIndex(self.effect_cast)
	

end
end

end


modifier_makima_control = class({})

function modifier_makima_control:IsHidden()
	return false
end

function modifier_makima_control:IsPurgable()
	return false
end

function modifier_makima_control:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_makima_control:CheckState()
	local state = {
		[MODIFIER_STATE_MUTED] = true,
		--[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end
function modifier_makima_control:OnCreated()
	local caster = self:GetCaster()
	local casterID = caster:GetPlayerID()
	local target = self:GetParent()
	local targetID = target:GetPlayerID()
	targetpos = target:GetAbsOrigin()
	caster.oldHullRadius = caster:GetHullRadius()
	target.oldTeam = target:GetTeamNumber()
	target:SetControllableByPlayer(casterID, true)
	target:SetTeam(caster:GetTeamNumber())
	PlayerResource:SetCameraTarget(casterID, target)
	PlayerResource:SetCameraTarget(casterID, nil)
	for o = 0, 15 do
		target.ability = target:GetAbilityByIndex(o)
		if target.ability then
	
					if target.ability:IsCooldownReady() then
						target.ability.cooldown = 0
					else
						target.ability.cooldown = target.ability:GetCooldownTimeRemaining()
						target.ability:EndCooldown()
					end
				end
			end
	
	for i = 0, 8 do
		target.item = target:GetItemInSlot(i) 
		if target.item then
			if target.item:IsSellable() then
				target.item:SetSellable(false)
			end
			if target.item:IsDroppable() then
				target.item:SetDroppable(false)
			end
			if target.item:IsCooldownReady() then
				target.item.cooldown = 0
			else
				target.item.cooldown = target.item:GetCooldownTimeRemaining()
				target.item:EndCooldown()
			end
		end
	end
end

function modifier_makima_control:OnDestroy()
	local caster = self:GetCaster()
	local casterID = caster:GetPlayerID()
	local target = self:GetParent()
	local targetID = target:GetPlayerID()
	target:SetControllableByPlayer(targetID, true)
	target:SetTeam(target.oldTeam)
	target:SetAbsOrigin(targetpos)
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	for i = 0, 8 do
		target.item = target:GetItemInSlot(i) 
		if target.item then
			if not target.item:IsSellable() then
				target.item:SetSellable(true)
			end
			if not target.item:IsDroppable() then
				target.item:SetDroppable(true)
			end
			if target.item then
				target.item:EndCooldown()
				target.item:StartCooldown(target.item.cooldown)
			end
		end
	end
local delay = 0.3

	if self:GetCaster():HasScepter() then
		self:GetParent():Kill(self:GetAbility(),self:GetCaster())
	end
	Timers:CreateTimer(delay,function()
	for o = 0, 15 do
		target.ability = target:GetAbilityByIndex(o)
		if target.ability then
			target.ability:EndCooldown()
			if target.ability.cooldown then
				target.ability:StartCooldown(target.ability.cooldown)
			end
		end
	end
	if self:GetAbility().reflected_ability then
		self:GetAbility():RemoveSelf()
	end
	end)
end

function modifier_makima_control:GetStatusEffectName()
	return "particles/makima_control_2nd.vpcf"
end


LinkLuaModifier("modifier_temple_of_death", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_temple_of_death_2nd_arc", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_temple_of_death_true", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE)
temple_of_death = class({})

function temple_of_death:IsStealable() return true end
function temple_of_death:IsHiddenWhenStolen() return false end

function temple_of_death:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("makima_bang")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function temple_of_death:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function temple_of_death:OnSpellStart()
    local caster = self:GetCaster()
	caster:FindAbilityByName("temple_sacrifice_execute"):SetLevel(1)
	caster:FindAbilityByName("makima_big_bang"):SetLevel(1)
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
    local origin = caster:GetOrigin()
	if caster:HasModifier("modifier_temple_of_death_2nd_arc") then
	caster:RemoveModifierByName("modifier_temple_of_death_2nd_arc") 
	EmitSoundOn( "makima.2nd_theme", caster )
	 caster:AddNewModifier(caster, self, "modifier_temple_of_death_true", {duration = 25})
	else
    caster:AddNewModifier(caster, self, "modifier_temple_of_death", {duration = fixed_duration})


    self:EndCooldown()

   
self:PlayEffects2(caster)
end
end

function temple_of_death:PlayEffects2(target)
	-- Get Resources
	local particle_cast = "particles/temple_of_death_activation.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end
---------------------------------------------------------------------------------------------------------------------
modifier_temple_of_death = class({})
function modifier_temple_of_death:IsHidden() return false end
function modifier_temple_of_death:IsDebuff() return true end
function modifier_temple_of_death:IsPurgable() return false end
function modifier_temple_of_death:IsPurgeException() return false end
function modifier_temple_of_death:RemoveOnDeath() return true end
function modifier_temple_of_death:AllowIllusionDuplicate() return false end

function modifier_temple_of_death:DeclareFunctions()
    local func = {  
    				MODIFIER_EVENT_ON_TAKEDAMAGE,		
 			}
    return func
end



function modifier_temple_of_death:OnTakeDamage( keys )
    if IsServer() then
    local caster = self:GetCaster()
	
		local attacker = keys.attacker
	local target = keys.unit
	
	--if attacker:HasModifier( "modifier_fountain_damage" ) then 
				--	else
			
			
		   
			
				if target == caster then
				if self:GetParent():GetHealth() <= 20 then
				if not self:GetParent():IsIllusion() then
				if self:GetParent():HasModifier("modifier_makima_contract_self")  then
		        if not self:GetParent():HasModifier("modifier_control_devil_damage_cd") then
				
			local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_makima_contract") then
		enemy:Kill(self:GetAbility(),caster)
			caster:AddNewModifier(
		caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_temple_of_death_2nd_arc", -- modifier name
		{} -- kv
	) 
	attacker:AddNewModifier(
		caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_makima_temple_vision", -- modifier name
		{duration = 30} -- kv
	) 
	self:Destroy()
	caster:Kill(self:GetAbility(),attacker)
	return
	end
	end
		end
		end
		end
		caster:Kill(self:GetAbility(),attacker)
		end
end
		end
	end

function modifier_temple_of_death:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self:StartIntervalThink(1)
    self.ability_level = self.ability:GetLevel()
	self.parent:FindAbilityByName("temple_sacrifice"):SetLevel(1)
    self.skills_table = {
                            ["temple_of_death"] = "temple_sacrifice",
                           
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
		self.particle_time =    ParticleManager:CreateParticle("particles/temple_of_death_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		end

        
	  
        EmitSoundOn("makima.5", self.parent)
		
        
		end
        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_temple_of_death:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_temple_of_death:OnDestroy()
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

            StopSoundOn("makima.5", self.parent)
       

            if self.parent:IsRealHero() then
			if not self.parent:HasModifier("modifier_temple_of_death_2nd_arc") then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
				end
                local ability = self.parent:FindAbilityByName("temple_of_death_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end

modifier_temple_of_death_2nd_arc = class({})
function modifier_temple_of_death_2nd_arc:IsHidden() return false end
function modifier_temple_of_death_2nd_arc:IsDebuff() return true end
function modifier_temple_of_death_2nd_arc:IsPurgable() return false end
function modifier_temple_of_death_2nd_arc:IsPurgeException() return false end
function modifier_temple_of_death_2nd_arc:RemoveOnDeath() return false end
function modifier_temple_of_death_2nd_arc:AllowIllusionDuplicate() return false end

function modifier_temple_of_death_2nd_arc:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	if IsServer() then
      self.ability:EndCooldown()
	end
end

modifier_temple_of_death_true = class({})
function modifier_temple_of_death_true:IsHidden() return false end
function modifier_temple_of_death_true:IsDebuff() return true end
function modifier_temple_of_death_true:IsPurgable() return false end
function modifier_temple_of_death_true:IsPurgeException() return false end
function modifier_temple_of_death_true:RemoveOnDeath() return true end
function modifier_temple_of_death_true:AllowIllusionDuplicate() return false end

function modifier_temple_of_death_true:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
self:StartIntervalThink(1)
    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            ["temple_of_death"] = "makima_big_bang",
                           
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
		self.particle_time =    ParticleManager:CreateParticle("particles/temple_of_death_true.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		end

        
	  
        
		end
        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_temple_of_death_true:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_temple_of_death_true:OnDestroy()
	StopSoundOn( "makima.2nd_theme", caster )
    if IsServer() then
	if self.parent:HasModifier("modifier_temple_sacrifice_begin") then
	self.parent:RemoveModifierByName("modifier_temple_sacrifice_begin")
	end
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

            StopSoundOn("makima.5_2nd", self.parent)
       

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(200)
                local ability = self.parent:FindAbilityByName("temple_of_death_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end


makima_bang = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function makima_bang:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()



if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetAbilityDamage()
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
 local knockback = { should_stun = 1,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 1000,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	
	
	self:PlayEffects1(caster:GetForwardVector(),target:GetOrigin() )
	self:PlayEffects(target)
	EmitSoundOn("makima.bang", caster)
end
function makima_bang:PlayEffects1( direction,origin )
	-- Get Resources
	local particle_cast = "particles/makima_bang.vpcf"
	
		local sound_cast = "makima.bang"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function makima_bang:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/pandora_blood_exp.vpcf"
	local sound_cast = ""

	-- Get Data
	local forward = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
	ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end




temple_sacrifice = class({})
LinkLuaModifier( "modifier_temple_sacrifice_victim", "modifiers/modifier_temple_sacrifice_victim", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_temple_sacrifice_begin", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_temple_sacrifice_victim", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_makima_temple_vision", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function temple_sacrifice:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

if target:HasModifier("modifier_makima_contract") and not target:IsIllusion() and target:IsRealHero() then
    caster:AddNewModifier(caster, self, "modifier_temple_sacrifice_begin",{duration = 7})
    target:AddNewModifier(caster, self, "modifier_temple_sacrifice_victim",{duration = 7})
	
	

	self:PlayEffects(target)
	EmitSoundOn("makima.word", caster)
	else
	self:EndCooldown()
	end
end


function temple_sacrifice:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/makima_temple_sacrifice_target.vpcf"
	local sound_cast = ""

	-- Get Data
	local forward = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
	ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end


modifier_temple_sacrifice_begin = class({})
function modifier_temple_sacrifice_begin:IsHidden() return false end
function modifier_temple_sacrifice_begin:IsDebuff() return true end
function modifier_temple_sacrifice_begin:IsPurgable() return false end
function modifier_temple_sacrifice_begin:IsPurgeException() return false end
function modifier_temple_sacrifice_begin:RemoveOnDeath() return true end
function modifier_temple_sacrifice_begin:AllowIllusionDuplicate() return false end
function modifier_temple_sacrifice_begin:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end
function modifier_temple_sacrifice_begin:DeclareFunctions()
	local func = {	
	
                    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

   }
	return func
end

function modifier_temple_sacrifice_begin:GetModifierIncomingDamage_Percentage( params )
	

		return -200
	end
	
function modifier_temple_sacrifice_begin:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            ["temple_sacrifice"] = "temple_sacrifice_execute",
                           
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
    
        self.parent:Purge(false, true, false, true, true)
        self:StartIntervalThink(0.1)
    end
end
function modifier_temple_sacrifice_begin:OnIntervalThink()
	  local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
       if not enemy:HasModifier("modifier_makima_temple_vision") then
		  enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_makima_temple_vision", {duration = 6})
       end
	end
end

function modifier_temple_sacrifice_begin:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_temple_sacrifice_begin:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
		

     
       

          
        end
    end
end

modifier_makima_temple_vision = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_makima_temple_vision:IsHidden()
	return false
end

function modifier_makima_temple_vision:IsDebuff()
	return false
end

function modifier_makima_temple_vision:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_makima_temple_vision:OnCreated( kv )
	-- references
	self.radius = 300


	-- start interval
    if IsServer() then
	    self:StartIntervalThink( 0.1 )
	    self:OnIntervalThink()
    end

	-- play effects
	
	
	
		

end

function modifier_makima_temple_vision:OnRefresh( kv )
	
end

function modifier_makima_temple_vision:OnRemoved()

end

function modifier_makima_temple_vision:OnDestroy()
	if not IsServer() then return end

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_makima_temple_vision:OnIntervalThink()
	-- Using aura's sticky duration doesn't allow it to be purged, so here we are
   if IsNotNull(self:GetCaster()) then
       if not self:GetCaster():HasModifier("modifier_temple_sacrifice_begin") then
           self:Destroy()
           return
       end
       AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 300, 0.2, false)
    else
       self:Destroy()
       return
   end
	-- find enemies
	
	end

modifier_temple_sacrifice_victim = class({})

--------------------------------------------------------------------------------

function modifier_temple_sacrifice_victim:IsDebuff()
	return true
end

function modifier_temple_sacrifice_victim:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_temple_sacrifice_victim:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_temple_sacrifice_victim:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_temple_sacrifice_victim:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
function modifier_temple_sacrifice_victim:GetModifierIncomingDamage_Percentage( params )
	

		return -100
	end
	
	modifier_makima_disabled_vision = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_makima_disabled_vision:IsHidden()
	return true
end

function modifier_makima_disabled_vision:IsDebuff()
	return false
end

function modifier_makima_disabled_vision:IsPurgable()
	return false
end
function modifier_makima_disabled_vision:RemoveOnDeath()
	return false
end

	
--------------------------------------------------------------------------------
temple_sacrifice_execute = class({})
LinkLuaModifier( "modifier_temple_sacrifice_execute", "heroes/makima/makima" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_makima_disabled_vision", "heroes/makima/makima" ,LUA_MODIFIER_MOTION_NONE )

--[[Author: Valve
	Date: 26.09.2015.]]
--------------------------------------------------------------------------------

function temple_sacrifice_execute:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function temple_sacrifice_execute:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function temple_sacrifice_execute:GetChannelTime()
	self.creep_duration = self:GetSpecialValueFor( "creep_duration" )
	self.hero_duration = self:GetSpecialValueFor( "hero_duration" )

	if IsServer() then
		if self.hVictim ~= nil then
			if self.hVictim:IsConsideredHero() then
				return self.hero_duration
			else
				return self.creep_duration
			end
		end

		return 0.0
	end

	return self.hero_duration
end

--------------------------------------------------------------------------------

function temple_sacrifice_execute:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function temple_sacrifice_execute:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
	--self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_makima_disabled_vision", { duration = 400} ) -- What is the point of this ??? WTF ???
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_temple_sacrifice_execute", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function temple_sacrifice_execute:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_temple_sacrifice_execute" )
	end
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO ,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier("modifier_temple_sacrifice_victim") then
	enemy:Kill(self,self:GetCaster())
	end
	end
    self:GetCaster():RemoveModifierByName("modifier_temple_sacrifice_begin")  
end
modifier_temple_sacrifice_execute = class({})

--------------------------------------------------------------------------------

function modifier_temple_sacrifice_execute:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_temple_sacrifice_execute:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_temple_sacrifice_execute:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "strength_damage_scepter" )

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end

end

--------------------------------------------------------------------------------

function modifier_temple_sacrifice_execute:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	
		self.damage2 = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = 10000,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( self.damage2 )
		EmitSoundOn( "makima.temple_death", self:GetParent() )
		self:PlayEffects(self:GetParent())
end
end
function modifier_temple_sacrifice_execute:PlayEffects(target)
	-- Get Resources
	local particle_cast = "particles/pandora_blood_exp.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end
--------------------------------------------------------------------------------

function modifier_temple_sacrifice_execute:OnIntervalThink()
	if IsServer() then
		local flDamage = self.dismember_damage
		if self:GetCaster():HasScepter() then
			flDamage = flDamage + ( self:GetCaster():GetStrength() * self.strength_damage_scepter )
			self:GetCaster():Heal( flDamage, self:GetAbility() )
		end

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
	
	end
end

--------------------------------------------------------------------------------

function modifier_temple_sacrifice_execute:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_temple_sacrifice_execute:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
function modifier_temple_sacrifice_execute:GetEffectName()

	return "particles/kisshot_kill.vpcf"

end


function modifier_temple_sacrifice_execute:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
--------------------------------------------------------------------------------

function modifier_temple_sacrifice_execute:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

makima_big_bang = class({})
LinkLuaModifier( "modifier_makima_big_bang", "heroes/makima/makima", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function makima_big_bang:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function makima_big_bang:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = target:GetOrigin()
    point.z     = point.z + 50.0
	local duration  = 2.0

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_makima_big_bang", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
	EmitGlobalSound("makima.last_word")
end
function makima_big_bang:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/makima_big_bang.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end


modifier_makima_big_bang = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_makima_big_bang:IsHidden()
	return true
end

function modifier_makima_big_bang:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_makima_big_bang:OnCreated( kv )
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
	--self:PlayEffects1()
		local sound_cast = "makima.big_bang_devil"
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end 


function modifier_makima_big_bang:OnRefresh( kv )
	
end

function modifier_makima_big_bang:OnRemoved()
end

function modifier_makima_big_bang:OnDestroy()
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
function modifier_makima_big_bang:PlayEffects()
	-- Get Resources
	local particle_cast = ""

	local sound_cast1 = "makima.big_bang_end"
	local sound_cast2	= "makima.big_bang_cuts"
	local sound_cast3  = "makima.big_bang_cuts"
     local sound_cast4  = "makima.big_bang_cuts"
	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast1, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast2, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast3, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast4, self:GetCaster() )
end