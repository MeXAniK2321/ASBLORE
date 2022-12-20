
esdeath_arena = class({})
LinkLuaModifier("modifier_esdeath_arena", "heroes/arena", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_underlord_firestorm_lua", "modifiers/modifier_underlord_firestorm_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_underlord_firestorm_lua_thinker", "modifiers/modifier_underlord_firestorm_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_leashed_lua", "modifiers/modifier_generic_leashed_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_esdeath_arena_buff", "heroes/arena", LUA_MODIFIER_MOTION_NONE)
function esdeath_arena:IsStealable() return true end
function esdeath_arena:IsHiddenWhenStolen() return false end
function esdeath_arena:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function esdeath_arena:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("faceless_void_chronosphere_lua")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function esdeath_arena:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function esdeath_arena:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")
    local vision = self:GetSpecialValueFor("vision_range")
  caster:AddNewModifier(caster, self, "modifier_esdeath_arena_buff", {duration = duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = duration})

    self:EndCooldown()
    local ices = 120
    local radius = self:GetAOERadius() - 50
    local angle = math.pi/2

    if target then
        if target:TriggerSpellAbsorb(self) then
            return nil
        end
    end

    for i = 1, ices do
        local position = Vector(point.x+radius*math.sin(angle), point.y+radius*math.cos(angle), point.z)
        
        local ice_unit = CreateModifierThinker(caster, self, "modifier_esdeath_arena", {duration = duration}, position, caster:GetTeamNumber(), true)
        --CreateTempTreeWithModel(position, duration, nil)
        
        angle = angle + math.pi/22
    end

    ResolveNPCPositions(point, self:GetAOERadius())

    AddFOWViewer(caster:GetTeam(), point, vision, duration, false)
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_underlord_firestorm_lua_thinker", -- modifier name
		{}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
    self:PlayEffects(point)
    EmitSoundOn("Esdeath.Arena", caster)
end
function esdeath_arena:PlayEffects( point )
local particle_cast = "particles/esdeath_arena_flash.vpcf"


	-- get data
	local radius = self:GetSpecialValueFor( "radius" )

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 2, 2, 2 ) )

	-- Create Sound
	
end
function esdeath_arena:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

---------------------------------------------------------------------------------------------------------------------
modifier_esdeath_arena = class({})
function modifier_esdeath_arena:IsHidden() return true end
function modifier_esdeath_arena:IsDebuff() return false end
function modifier_esdeath_arena:IsPurgable() return false end
function modifier_esdeath_arena:IsPurgeException() return false end
function modifier_esdeath_arena:RemoveOnDeath() return true end
function modifier_esdeath_arena:CheckState()
    local state = { [MODIFIER_STATE_INVULNERABLE] = true,}
    return state
end
function modifier_esdeath_arena:OnCreated()
    if IsServer() then
        self:GetParent():SetOriginalModel("models/particle/ice_shards.vmdl")
        self:GetParent():SetModelScale(45)
        self:GetParent():SetHullRadius(self:GetParent():GetHullRadius()*4)
    end
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
modifier_esdeath_arena_buff = class({})
function modifier_esdeath_arena_buff:IsHidden() return false end
function modifier_esdeath_arena_buff:IsDebuff() return true end
function modifier_esdeath_arena_buff:IsPurgable() return false end
function modifier_esdeath_arena_buff:IsPurgeException() return false end
function modifier_esdeath_arena_buff:RemoveOnDeath() return true end
function modifier_esdeath_arena_buff:AllowIllusionDuplicate() return true end
function modifier_esdeath_arena_buff:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("esdeath_morph_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_esdeath_arena_buff:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end



function modifier_esdeath_arena_buff:GetModifierAttackSpeedBonus_Constant()
    return 150
end
function modifier_esdeath_arena_buff:GetModifierProcAttack_BonusDamage_Magical()
    return 500
end
function modifier_esdeath_arena_buff:GetModifierSpellAmplify_Percentage()
    return 50
end





function modifier_esdeath_arena_buff:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["esdeath_arena"] = "faceless_void_chronosphere_lua",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/esdeath_arena_particle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
    
       

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_esdeath_arena_buff:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_esdeath_arena_buff:OnDestroy()
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

         
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("esdeath_morph_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end