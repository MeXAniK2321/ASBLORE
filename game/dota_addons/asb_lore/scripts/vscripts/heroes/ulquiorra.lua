ulquiorra_bala = class({})

LinkLuaModifier( "modifier_ulquiorra_bala_thinker", "heroes/ulquiorra.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sonido_review", "heroes/ulquiorra.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bala_charges", "heroes/ulquiorra.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ulquiorra_bala:Spawn()
    if IsServer() then
        self:SetThink( "OnIntervalThink", self, 0.25 )
    end
end
function ulquiorra_bala:GetIntrinsicModifierName()
    return "modifier_sonido_review"
end
function ulquiorra_bala:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("ulquiorra_sonido")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function ulquiorra_bala:OnIntervalThink()
    if IsServer() then
        self:SetActivated(not self:GetCaster():HasModifier("modifier_doomslayer_doom"))
    end

    return 0.25
end

function ulquiorra_bala:IsStealable()
   return false
end

function ulquiorra_bala:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function ulquiorra_bala:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function ulquiorra_bala:OnSpellStart()
    if IsServer() then
        local target = CreateModifierThinker(self:GetCaster(), self, "modifier_ulquiorra_bala_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

        local info = {
			EffectName = "particles/bala_projectile.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "ulquiorra.1", self:GetCaster() )
    end
	if IsServer() then
        --self:SetStackCount(0)

       
    end
end


--------------------------------------------------------------------------------

function ulquiorra_bala:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
        EmitSoundOn( "ulquiorra.exp", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
  
          local particle_fx = "particles/bala_explosion.vpcf"

        local effect_fx =   ParticleManager:CreateParticle(particle_fx, PATTACH_WORLDORIGIN, caster)
                            ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                            ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
				
                self.r = self:GetSpecialValueFor("max_damage")
			
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = self.r,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                
               
    
                ApplyDamage(damage)  
            end
        end

		UTIL_Remove(hTarget)
	end

	return true
end


modifier_ulquiorra_bala_thinker = class ({})

function modifier_ulquiorra_bala_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_sonido_review = class ({})
function modifier_sonido_review:IsHidden() return true end
function modifier_sonido_review:IsDebuff() return false end
function modifier_sonido_review:IsPurgable() return false end
function modifier_sonido_review:IsPurgeException() return false end
function modifier_sonido_review:RemoveOnDeath() return false end

function modifier_sonido_review:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_sonido_review:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_sonido_review:OnIntervalThink()
    if IsServer() then
        local sosonido = self:GetParent():FindAbilityByName("ulquiorra_sonido")
        if sosonido and not sosonido:IsNull() then
            if self:GetParent():HasScepter() then
                if sosonido:IsHidden() then
                    sosonido:SetHidden(false)
                end
            else
                if not sosonido:IsHidden() then
                    sosonido:SetHidden(true)
                end
            end
        end
    end
	if self:GetParent():HasModifier("modifier_bala_charges") then 
	else
	if self:GetCaster():HasTalent("special_bonus_ulquiorra_25") then 
	self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_bala_charges", {})
	end
	end
end
modifier_bala_charges = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bala_charges:IsHidden()
	return not self.active
end

function modifier_bala_charges:IsDebuff()
	return false
end

function modifier_bala_charges:IsPurgable()
	return false
end

function modifier_bala_charges:DestroyOnExpire()
	return false
end

function modifier_bala_charges:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bala_charges:OnCreated( kv )
	-- references
	self.max_charges = 2
	self.charge_time = 16
	self.active = true

	if not IsServer() then return end
	self:SetStackCount( self.max_charges )
	self:CalculateCharge()
end

function modifier_bala_charges:OnRefresh( kv )
	-- references
	self.max_charges = 2
	self.charge_time = 10

	if not IsServer() then return end
	self:CalculateCharge()
end

function modifier_bala_charges:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_bala_charges:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_bala_charges:OnAbilityFullyCast( params )
	if IsServer() then
	local ability = self:GetParent():FindAbilityByName("ulquiorra_bala")
		if params.unit~=self:GetParent() or params.ability~=ability then
			return
		end

		self:DecrementStackCount()
		self:CalculateCharge()
	end
end
function modifier_bala_charges:GetTexture()
	return "ulquiorra/ulquiorra_1"
end
-----
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_bala_charges:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end

function modifier_bala_charges:CalculateCharge()
local ability = self:GetParent():FindAbilityByName("ulquiorra_bala")
	if self.active then
		ability:EndCooldown()
	end
	if self:GetStackCount()>=self.max_charges then
		-- stop charging
		self:SetDuration( -1, false )
		self:StartIntervalThink( -1 )
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local charge_time = ability:GetCooldown( -1 )
			if self.charge_time and self.active then
				charge_time = self.charge_time
			end
			self:StartIntervalThink( charge_time )
			self:SetDuration( charge_time, true )
		end

		-- set on cooldown if no charges
		if self:GetStackCount()==0 then
			ability:StartCooldown( self:GetRemainingTime() )
		end
	end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_bala_charges:SetActive( active )
	-- for server
	self.active = active

	-- todo: self.active should be known to client
end

hierro = class({})
LinkLuaModifier( "modifier_hierro", "heroes/ulquiorra.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function hierro:GetIntrinsicModifierName()
	return "modifier_hierro"
end


modifier_hierro = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hierro:IsHidden()
	return true
end

function modifier_hierro:IsDebuff()
	return false
end

function modifier_hierro:IsPurgable()
	return false
end

function modifier_hierro:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_hierro:OnCreated( kv )
	self.parent = self:GetParent()

	-- references
	self.block = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.block2 = self:GetAbility():GetSpecialValueFor( "armor" )
   self.regen = self:GetAbility():GetSpecialValueFor( "regen" )

	if not IsServer() then return end
	self.damage = 0
end

function modifier_hierro:OnRefresh( kv )
	-- references
	self.block = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.block2 = self:GetAbility():GetSpecialValueFor( "armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "regen" )

end

function modifier_hierro:OnRemoved()
end

function modifier_hierro:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_hierro:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return funcs
end

function modifier_hierro:GetModifierBaseAttackTimeConstant()
	return 2.0
end
function modifier_hierro:GetModifierIncomingDamage_Percentage( params )
	

		return self.block
	end
	
	  function modifier_hierro:GetModifierPhysicalArmorBonus()
return self.block2 
end  

function modifier_hierro:GetModifierConstantHealthRegen()
	if self.parent:PassivesDisabled() then return 0 end
	return self.regen
end









ulquiorra_cero = class({})

function ulquiorra_cero:IsStealable() return true end
function ulquiorra_cero:IsHiddenWhenStolen() return false end
function ulquiorra_cero:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_ulquiorra_ressurection") or self:GetCaster():HasModifier("modifier_ulquiorra_ressurection_segunda_etapa") or  self:GetCaster():HasModifier("modifier_passive_ressurection")then
		return "ulquiorra/ulquiorra_3_1"
	end
	return "ulquiorra/ulquiorra_3"
end
function ulquiorra_cero:OnAbilityPhaseStart()
           
	
    if self:GetCaster():HasModifier("modifier_ulquiorra_ressurection") or self:GetCaster():HasModifier("modifier_ulquiorra_ressurection_segunda_etapa") or  self:GetCaster():HasModifier("modifier_passive_ressurection")then
	self.launcher_charge_fx = 	ParticleManager:CreateParticle("particles/cero_osciras_finger.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 0, self:GetCaster(), 5, "cero", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 1, self:GetCaster(), 5, "cero", Vector(0,0,0), true)
								
								else
								self.launcher_charge_fx = 	ParticleManager:CreateParticle("particles/ulquiorra_cero_finger.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 0, self:GetCaster(), 5, "cero", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 1, self:GetCaster(), 5, "cero", Vector(0,0,0), true)
								end

    return true
end
function ulquiorra_cero:OnAbilityPhaseInterrupted()
	if self.launcher_charge_fx then
	    ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
	end
end
function ulquiorra_cero:OnSpellStart()
    local caster = self:GetCaster()
   if self:GetCaster():HasModifier("modifier_ulquiorra_ressurection") or self:GetCaster():HasModifier("modifier_ulquiorra_ressurection_segunda_etapa") or  self:GetCaster():HasModifier("modifier_passive_ressurection")then
   EmitSoundOn("ulquiorra.3_1", caster)
   else
	EmitSoundOn("ulquiorra.3", caster)
	end

    self.launcher_damage = self:GetSpecialValueFor("launcher_damage") + self:GetCaster():FindTalentValue("special_bonus_ulquiorra_20")
    self.launcher_damage = self.launcher_damage / self:GetChannelTime() or 1
end
function ulquiorra_cero:OnChannelFinish(bInterrupted)
	local caster = self:GetCaster()
	

StopSoundOn("ulquiorra.3", caster)
EmitSoundOn("ulquiorra.3_sfx", caster)

	if self.launcher_charge_fx then
	    ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
	end

	local delay = FrameTime() * 8
	
 Timers:CreateTimer(delay,function()
	end)

	

	if bInterrupted then
		caster:Interrupt()
	end

	self.launcher_damage = self.launcher_damage * (GameRules:GetGameTime() - self:GetChannelStartTime())

	local width = self:GetSpecialValueFor("launcher_width")
	--print(width)
	local distance = self:GetCastRange(caster:GetAbsOrigin(),caster) + caster:GetCastRangeBonus()
if self:GetCaster():HasModifier("modifier_ulquiorra_ressurection") or self:GetCaster():HasModifier("modifier_ulquiorra_ressurection_segunda_etapa") or  self:GetCaster():HasModifier("modifier_passive_ressurection")then
local cero_particle = "particles/ulquiorra_cero_osciras.vpcf"
	local cero_particle_end = "particles/ulquiorra_cero_end.vpcf"
	local pfx = ParticleManager:CreateParticle(cero_particle, PATTACH_WORLDORIGIN, nil )
	local pfx_end = ParticleManager:CreateParticle(cero_particle_end, PATTACH_WORLDORIGIN, nil )
	local attach_point = caster:ScriptLookupAttachment("cero")

	ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
	ParticleManager:SetParticleControl(pfx_end, 0, caster:GetAttachmentOrigin(attach_point))

	local endcapPos = caster:GetAbsOrigin() + caster:GetForwardVector() * distance
	
	GridNav:DestroyTreesAroundPoint(endcapPos, width, false)

	endcapPos = GetGroundPosition( endcapPos, nil )
	endcapPos.z = endcapPos.z + 92

	ParticleManager:SetParticleControl( pfx, 1, endcapPos )
	ParticleManager:SetParticleControl( pfx_end, 3, endcapPos ) --IN ir EndCap your effect

	local start_loc = caster:GetAbsOrigin() + caster:GetForwardVector() * 32
	local bonus_delay = delay * 3
	local end_delay = bonus_delay + 1
	local hits = 1
	
	Timers:CreateTimer(0, function()
		local enemies = FindUnitsInLine(caster:GetTeamNumber(),
										start_loc,
										endcapPos,
										nil,
										width,
										self:GetAbilityTargetTeam(),
										self:GetAbilityTargetType(),
										self:GetAbilityTargetFlags() )
		
		for _,enemy in pairs(enemies) do
			local damage_table = {	victim = enemy,
									attacker = caster,
									damage = self.launcher_damage * 0.15,
									damage_type = self:GetAbilityDamageType(),
									ability = self }

			ApplyDamage(damage_table)

					
		end
		--print("damage done ".. hits)
		if hits < 10 then
			hits = hits + 1
			return bonus_delay * 0.1
		end
	end)

	Timers:CreateTimer(bonus_delay,function()
		ParticleManager:DestroyParticle( pfx, true )
		ParticleManager:ReleaseParticleIndex( pfx )
	end)

	Timers:CreateTimer(end_delay,function()
		ParticleManager:DestroyParticle( pfx_end, true )
		ParticleManager:ReleaseParticleIndex( pfx_end )
	end)
else
	local cero_particle = "particles/ulquiorra_cero1.vpcf"
	local cero_particle_end = "particles/ulquiorra_cero_end.vpcf"
	local pfx = ParticleManager:CreateParticle(cero_particle, PATTACH_WORLDORIGIN, nil )
	local pfx_end = ParticleManager:CreateParticle(cero_particle_end, PATTACH_WORLDORIGIN, nil )
	local attach_point = caster:ScriptLookupAttachment("cero")

	ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
	ParticleManager:SetParticleControl(pfx_end, 0, caster:GetAttachmentOrigin(attach_point))

	local endcapPos = caster:GetAbsOrigin() + caster:GetForwardVector() * distance
	
	GridNav:DestroyTreesAroundPoint(endcapPos, width, false)

	endcapPos = GetGroundPosition( endcapPos, nil )
	endcapPos.z = endcapPos.z + 92

	ParticleManager:SetParticleControl( pfx, 1, endcapPos )
	ParticleManager:SetParticleControl( pfx_end, 3, endcapPos ) --IN ir EndCap your effect

	local start_loc = caster:GetAbsOrigin() + caster:GetForwardVector() * 32
	local bonus_delay = delay * 3
	local end_delay = bonus_delay + 1
	local hits = 1
	
	Timers:CreateTimer(0, function()
		local enemies = FindUnitsInLine(caster:GetTeamNumber(),
										start_loc,
										endcapPos,
										nil,
										width,
										self:GetAbilityTargetTeam(),
										self:GetAbilityTargetType(),
										self:GetAbilityTargetFlags() )
		
		for _,enemy in pairs(enemies) do
			local damage_table = {	victim = enemy,
									attacker = caster,
									damage = self.launcher_damage * 0.1,
									damage_type = self:GetAbilityDamageType(),
									ability = self }

			ApplyDamage(damage_table)

					
		end
		--print("damage done ".. hits)
		if hits < 10 then
			hits = hits + 1
			return bonus_delay * 0.1
		end
	end)

	Timers:CreateTimer(bonus_delay,function()
		ParticleManager:DestroyParticle( pfx, true )
		ParticleManager:ReleaseParticleIndex( pfx )
	end)

	Timers:CreateTimer(end_delay,function()
		ParticleManager:DestroyParticle( pfx_end, true )
		ParticleManager:ReleaseParticleIndex( pfx_end )
	end)
end
end




LinkLuaModifier("modifier_ulquiorra_ressurection", "heroes/ulquiorra", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
ulquiorra_ressurection = class({})

function ulquiorra_ressurection:IsStealable() return true end
function ulquiorra_ressurection:IsHiddenWhenStolen() return false end

function ulquiorra_ressurection:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("lansa_de_luna")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function ulquiorra_ressurection:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function ulquiorra_ressurection:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
   
    caster:AddNewModifier(caster, self, "modifier_ulquiorra_ressurection", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = fixed_duration})
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_ulquiorra_ressurection = class({})
function modifier_ulquiorra_ressurection:IsHidden() return false end
function modifier_ulquiorra_ressurection:IsDebuff() return true end
function modifier_ulquiorra_ressurection:IsPurgable() return false end
function modifier_ulquiorra_ressurection:IsPurgeException() return false end
function modifier_ulquiorra_ressurection:RemoveOnDeath() return true end
function modifier_ulquiorra_ressurection:AllowIllusionDuplicate() return true end
function modifier_ulquiorra_ressurection:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,                   
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
    return func
end

function modifier_ulquiorra_ressurection:GetModifierModelChange()
    return "models/ulqiorra/ulquiorra_murchielago.vmdl"
end
function modifier_ulquiorra_ressurection:GetModifierModelScale()
	return 70
end


function modifier_ulquiorra_ressurection:GetModifierSpellAmplify_Percentage()
    return 0
end

function modifier_ulquiorra_ressurection:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["ulquiorra_ressurection"] = "lansa_de_luna",
                            
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
       

        	 local hideit = 
	{
	"ulquiorra_ressurection_segunda_etapa",
		
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
		
        EmitSoundOn("ulquiorra.4", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_ulquiorra_ressurection:GetEffectName()

	return "particles/ulquiorra_ressurection.vpcf"
	end
function modifier_ulquiorra_ressurection:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_ulquiorra_ressurection:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			

            StopSoundOn("ulquiorra.4", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("ulquiorra_ressurection_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
			local HiddenAbilities = 
	{
	
		"ulquiorra_ressurection_segunda_etapa",
	}
 if self:GetParent():HasScepter() then
 else
	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end
	end
        end
    end
end



lansa_de_luna = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start
function lansa_de_luna:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	local projectile_name = "particles/lansa_de_luna.vpcf"
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
	 if self:GetCaster():HasModifier("modifier_passive_ressurection")then
	 
	 self:EndCooldown()
	 self:StartCooldown(30)
	 end

	self:PlayEffects1()
end

function lansa_de_luna:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end

	self:Hit( target, true )
	
	

	

	self:PlayEffects2( hTarget )
end
function lansa_de_luna:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	target:AddNewModifier(caster, self, "modifier_generic_stunned_lua", {duration = 1.5})
	

	
end

--------------------------------------------------------------------------------
function lansa_de_luna:PlayEffects1()
	-- Get Resources
	local sound_cast = "ulquiorra.4_1_1"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function lansa_de_luna:PlayEffects2( target )
	-- Get Resources
	local sound_target = "ulquiorra.exp"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end


LinkLuaModifier("modifier_ulquiorra_ressurection_segunda_etapa", "heroes/ulquiorra", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
ulquiorra_ressurection_segunda_etapa = class({})

function ulquiorra_ressurection_segunda_etapa:IsStealable() return true end
function ulquiorra_ressurection_segunda_etapa:IsHiddenWhenStolen() return false end

function ulquiorra_ressurection_segunda_etapa:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("lansa_de_relampago")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	if self:GetCaster():HasScepter() then
	else
		 local HiddenAbilities = 
	{
	
		"ulquiorra_ressurection_segunda_etapa",
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetCaster():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end
	end
end
function ulquiorra_ressurection_segunda_etapa:OnSpellStart()
    local caster = self:GetCaster()
	local radius = 600
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	 if self:GetCaster():HasModifier("modifier_passive_ressurection")then
	 else
    caster:RemoveModifierByName("modifier_ulquiorra_ressurection")
	caster:RemoveModifierByName("modifier_star_tier1")
	end
    caster:AddNewModifier(caster, self, "modifier_ulquiorra_ressurection_segunda_etapa", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
	

    self:EndCooldown()
	self:PlayEffects(radius)

 
end
function ulquiorra_ressurection_segunda_etapa:PlayEffects( radius )

	local particle_cast = "particles/segunda_etapa_exp.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_ulquiorra_ressurection_segunda_etapa = class({})
function modifier_ulquiorra_ressurection_segunda_etapa:IsHidden() return false end
function modifier_ulquiorra_ressurection_segunda_etapa:IsDebuff() return true end
function modifier_ulquiorra_ressurection_segunda_etapa:IsPurgable() return false end
function modifier_ulquiorra_ressurection_segunda_etapa:IsPurgeException() return false end
function modifier_ulquiorra_ressurection_segunda_etapa:RemoveOnDeath() return true end
function modifier_ulquiorra_ressurection_segunda_etapa:AllowIllusionDuplicate() return true end
function modifier_ulquiorra_ressurection_segunda_etapa:CheckState()
   
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}

    return state
end
function modifier_ulquiorra_ressurection_segunda_etapa:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,                   
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					MODIFIER_PROPERTY_HEALTH_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
    return func
end

function modifier_ulquiorra_ressurection_segunda_etapa:GetModifierModelChange()
    return "models/ulqiorra/ulqiorra_segunda_etapa.vmdl"
end
function modifier_ulquiorra_ressurection_segunda_etapa:GetModifierModelScale()
 if self:GetCaster():HasModifier("modifier_passive_ressurection")then
 return 1
 else
	return 60
	end
end
function modifier_ulquiorra_ressurection_segunda_etapa:GetModifierConstantHealthRegen()
    return 400
end

function modifier_ulquiorra_ressurection_segunda_etapa:GetModifierSpellAmplify_Percentage()
    return 50
end
function modifier_ulquiorra_ressurection_segunda_etapa:GetModifierHealthBonus()
    return 750
end

function modifier_ulquiorra_ressurection_segunda_etapa:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
	
	 if self:GetCaster():HasModifier("modifier_passive_ressurection")then
	     self.skills_table = {
                            
							["ulquiorra_ressurection_segunda_etapa"] = "lansa_de_relampago",
                            
                        }
	 else

    self.skills_table = {
                            ["ulquiorra_ressurection"] = "lansa_de_luna",
							["ulquiorra_ressurection_segunda_etapa"] = "lansa_de_relampago",
                            
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
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
       

        
		
        EmitSoundOn("ulquiorra.5", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_ulquiorra_ressurection_segunda_etapa:GetEffectName()

	return "particles/ulquiorra_ressurection_segunda_etapa.vpcf"
	end
function modifier_ulquiorra_ressurection_segunda_etapa:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_ulquiorra_ressurection_segunda_etapa:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			

            StopSoundOn("ulquiorra.5", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("ulquiorra_ressurection_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
				 local HiddenAbilities = 
	{
	
		"ulquiorra_ressurection_segunda_etapa",
	}
if not self:GetParent():HasModifier("modifier_passive_ressurection") then
	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end
            end
        end
    end
	end
end




lansa_de_relampago = class({})
LinkLuaModifier( "modifier_lansa_de_relampago_thinker", "heroes/ulquiorra.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function lansa_de_relampago:IsStealable()
   return false
end

function lansa_de_relampago:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function lansa_de_relampago:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function lansa_de_relampago:OnSpellStart()
    local caster = self:GetCaster()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)
	self.parent = self:GetCaster()
   
        EmitSoundOn( "ulquiorra.5_1", self:GetCaster() )
    
	if IsServer() then
        --self:SetStackCount(0)
self.bow_fx = 	ParticleManager:CreateParticle("particles/lansa_de_relampago_hand.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.bow_fx, 0, self:GetCaster(), 5, "lansa_del_relampago", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.bow_fx, 1, self:GetCaster(), 5, "lansa_del_relampago", Vector(0,0,0), true)
       
    end
end
function lansa_de_relampago:OnChannelFinish( bInterrupted )
	-- unit identifier
	local caster = self:GetCaster()
	 local target = CreateModifierThinker(self:GetCaster(), self, "modifier_lansa_de_relampago_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
        local info = {
			EffectName = "particles/lansa_de_relampago.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

        ProjectileManager:CreateTrackingProjectile( info )
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_6)
     local damage = self:GetSpecialValueFor( "damage" )

	self.bow_damage = damage*channel_pct
	if self.bow_fx then
	    ParticleManager:DestroyParticle(self.bow_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.bow_fx)
	end
		
end


--------------------------------------------------------------------------------

function lansa_de_relampago:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
        EmitSoundOn( "ulquiorra.nuke", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
  
          local particle_fx = "particles/lansa_de_relampago_exp.vpcf"

        local effect_fx =   ParticleManager:CreateParticle(particle_fx, PATTACH_WORLDORIGIN, caster)
                            ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                            ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
               
    
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = self.bow_damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                
                target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun")+ self:GetCaster():FindTalentValue("special_bonus_tsuna_25l")})
    
                ApplyDamage(damage)  
            end
        end

		UTIL_Remove(hTarget)
	end

	return true
end


modifier_lansa_de_relampago_thinker = class ({})

function modifier_lansa_de_relampago_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end





ulquiorra_sonido = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function ulquiorra_sonido:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()



	local radius = 300
	
	local debuffDuration = 1.5



if target:TriggerSpellAbsorb( self ) then return end

	local target_loc_forward_vector = target:GetForwardVector() 
	local final_pos = target:GetAbsOrigin() + target_loc_forward_vector * 150
	


	-- Blink
	caster:SetOrigin( final_pos )
	FindClearSpaceForUnit( caster, final_pos, true )
	caster:MoveToTargetToAttack(target)

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) 
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
 
	target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun")})
	
	
	
	self:PlayEffects( point, radius, debuffDuration )
	EmitSoundOn("ulquiorra.6", caster)
	EmitSoundOn("ulquiorra.6_1", caster)
	EmitSoundOn("ulquiorra.pierce", caster)
end
function ulquiorra_sonido:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/ulquiorra_sonido.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end