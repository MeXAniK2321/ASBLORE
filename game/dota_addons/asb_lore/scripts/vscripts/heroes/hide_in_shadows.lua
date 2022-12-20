hide_in_shadows = class({})
LinkLuaModifier( "modifier_hide_in_shadows", "heroes/hide_in_shadows.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "hide_in_shadows_target", "heroes/hide_in_shadows.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silence_item", "heroes/hide_in_shadows.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muted", "modifiers/modifier_muted", LUA_MODIFIER_MOTION_NONE )
function hide_in_shadows:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("hide_in_shadows_leave")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function hide_in_shadows:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local result = UnitFilter(
		hTarget,	-- Target Filter
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- Team Filter
		DOTA_UNIT_TARGET_HERO,	-- Unit Filter
		0,	-- Unit Flag
		self:GetCaster():GetTeamNumber()	-- Team reference
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Cast Error Message
function hide_in_shadows:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end
function hide_in_shadows:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration = 30
	local radius = 400
	
	if caster:GetTeamNumber() == target:GetTeamNumber() then
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"hide_in_shadows_target", -- modifier name
		{ duration = 100 } -- kv
	)
	
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hide_in_shadows", { duration = 100.05 } )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_muted", { duration = 0.2 } )
	if caster:HasModifier("modifier_kisshot") then
	 EmitSoundOn("Shinobu.4_ts", caster)
	else
    EmitSoundOn("Ka.ka", caster)
	end
	self:PlayEffects( radius )
	else
	if target:TriggerSpellAbsorb( self ) then return end
	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"hide_in_shadows_target", -- modifier name
		{ duration = duration  } -- kv
	)
	
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hide_in_shadows", { duration = 20.05 } )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_muted", { duration = 0.2 } )
    self:EmitSound("Ka.ka")
	self:PlayEffects( radius )
end
end

function hide_in_shadows:PlayEffects( radius )
	local particle_cast = "particles/hide_in_shadows.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_hide_in_shadows = class({})

function modifier_hide_in_shadows:IsHidden()
    return false
end
function modifier_hide_in_shadows:CheckState()
    local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,     
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
    }

    return state
end
function modifier_hide_in_shadows:IsPurgable()
    return false
end
function modifier_hide_in_shadows:OnCreated(hTable)

	 self:GetParent():AddNoDraw()
	  self.skills_table = {
                            ["hide_in_shadows"] = "hide_in_shadows_leave",
                            
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self:GetParent():SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self:GetParent():FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
	
       local HiddenAbilities = 
	{
	"mars_gods_rebuke_lua",
		"kisshot",
		"grand_panaino",
		"pudge_dismember_lua",
		
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end
	end
end

function modifier_hide_in_shadows:OnDestroy( kv )
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
if not IsServer() then return end
local point = self:GetCaster():GetAbsOrigin()

FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin(), true)
    local chance = math.random(100)
    local npcName = self:GetParent():GetUnitName()
	local caster = self:GetCaster()
    
    self:GetParent():RemoveNoDraw()
    if IsServer() then
        if self:GetParent() and not self:GetParent():IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self:GetParent():SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			end
			end
			local radius = 400
	local duration = 1.0
	local damage = 1800

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
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end
	if caster:HasModifier("modifier_kisshot") then
	self:PlayEffects2( radius )
	else
	self:PlayEffects( radius )
	end
	 local HiddenAbilities = 
	{
		"mars_gods_rebuke_lua",
		"kisshot",
		"grand_panaino",
		"pudge_dismember_lua",
		
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
		  if HiddenAbility and not HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(true)
        end
		end
end
function modifier_hide_in_shadows:PlayEffects( radius )
	local particle_cast = "particles/shinobu_hide_blood.vpcf"
	local sound_cast = "Shinobu.punch"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function modifier_hide_in_shadows:PlayEffects2( radius )
	local particle_cast = "particles/shinobu_hide_blood_ts.vpcf"
	local sound_cast = "Shinobu.4_1_ts"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
hide_in_shadows_target = class({})

function hide_in_shadows_target:IsPurgable()
    return false
end

function hide_in_shadows_target:OnCreated( kv )
    self:StartIntervalThink(0.03)
    if not IsServer() then return end
    self:StartIntervalThink(0.1)
   
    self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
    
end

function hide_in_shadows_target:OnIntervalThink()
    if not IsServer() then return end
    local target = self:GetCaster()
    local target_pos = target:GetAbsOrigin ()
    local caster = self:GetAbility ():GetCaster ()
    target:SetAbsOrigin (self:GetParent ():GetAbsOrigin ())
    if not self:GetParent ():IsAlive() then
	    caster:RemoveModifierByName ("modifier_hide_in_shadows")
        target:RemoveModifierByName ("hide_in_shadows_target")
    end
end
function hide_in_shadows_target:OnDestroy( kv )
 local target = self:GetCaster()
    local target_pos = target:GetAbsOrigin ()
    local caster = self:GetAbility ():GetCaster ()
    caster:RemoveModifierByName ("modifier_hide_in_shadows")
        target:RemoveModifierByName ("hide_in_shadows_target")
    
end
function hide_in_shadows_target:GetEffectName()
	return "particles/shinobu_shadow.vpcf"
end

function hide_in_shadows_target:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_silence_item = class({})

function modifier_silence_item:CheckState() 
  local state =
      {
   [MODIFIER_STATE_MUTED] = true
      }
  return state
end

function modifier_silence_item:IsPurgable()
    return false
end

function modifier_silence_item:IsHidden()
    return true
end