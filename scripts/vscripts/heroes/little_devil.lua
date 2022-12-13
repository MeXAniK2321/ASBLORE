LinkLuaModifier("modifier_little_devil", "heroes/little_devil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_little_nightmare", "heroes/little_devil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_little_devil_invul", "heroes/little_devil", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chara_screamer", "modifiers/modifier_chara_screamer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)


little_devil = class({})

function little_devil:IsStealable() return true end
function little_devil:IsHiddenWhenStolen() return false end

function little_devil:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("critical_error")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function little_devil:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
	local duration = 1.0
	local damage = 1000

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
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		

	if self:GetCaster():HasModifier( "modifier_genocide_complited" ) then
	enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_chara_screamer", -- modifier name
			{ duration = 7.9 } -- kv
		)
	else
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_dark_willow_terrorize_lua", -- modifier name
			{ duration = duration } -- kv
		)
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		end
	end

	
if self:GetCaster():HasModifier( "modifier_genocide_complited" ) then
    caster:AddNewModifier(caster, self, "modifier_little_nightmare", {duration = fixed_duration})
	
caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = fixed_duration})
	self:PlayEffects(radius)
else
    caster:AddNewModifier(caster, self, "modifier_little_devil", {duration = fixed_duration})
	
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
end
    self:EndCooldown()

    
end
function little_devil:PlayEffects( radius )

	local particle_cast = "particles/chara_true_genocide.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_little_devil = class({})
function modifier_little_devil:IsHidden() return false end
function modifier_little_devil:IsDebuff() return true end
function modifier_little_devil:IsPurgable() return false end
function modifier_little_devil:IsPurgeException() return false end
function modifier_little_devil:RemoveOnDeath() return true end
function modifier_little_devil:AllowIllusionDuplicate() return true end

function modifier_little_devil:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end


function modifier_little_devil:GetModifierModelChange()

    
	return "models/frisk/chara.vmdl"

end

function modifier_little_devil:GetModifierPreAttack_BonusDamage()
    return 300
end
function modifier_little_devil:GetModifierBonusStats_Strength()
    return 75
end

function modifier_little_devil:GetModifierBonusStats_Agility()

    return 100
	
end




function modifier_little_devil:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["little_devil"] = "critical_error",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/chara_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
        EmitSoundOn("chara.5_1", self.parent)
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_little_devil:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_little_devil:OnDestroy()
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

            StopSoundOn("chara.5_1", self.parent)

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("little_devil_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end


modifier_little_nightmare = class({})
function modifier_little_nightmare:IsHidden() return false end
function modifier_little_nightmare:IsDebuff() return true end
function modifier_little_nightmare:IsPurgable() return false end
function modifier_little_nightmare:IsPurgeException() return false end
function modifier_little_nightmare:RemoveOnDeath() return true end
function modifier_little_nightmare:AllowIllusionDuplicate() return true end

function modifier_little_nightmare:DeclareFunctions()
    local func = {  
    				
	                MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end

function modifier_little_nightmare:GetModifierPreAttack_BonusDamage()
    return 600
end
function modifier_little_nightmare:GetModifierBonusStats_Strength()
    return 200
end

function modifier_little_nightmare:GetModifierBonusStats_Agility()

    return 250
	
end




function modifier_little_nightmare:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

     self.skills_table = {
                            ["little_devil"] = "critical_error",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/true_genocide_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
        EmitSoundOn("chara.5_1", self.parent)
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_little_nightmare:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_little_nightmare:OnDestroy()
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

            StopSoundOn("chara.5_1", self.parent)
self.ability:StartCooldown(200)
local caster = self:GetCaster()
local modifier = caster:FindModifierByNameAndCaster("modifier_determination",caster)
local modifier2 = caster:FindModifierByNameAndCaster("modifier_genocide_complited",caster)
modifier:SetStackCount(0)
caster:RemoveModifierByName("modifier_genocide_complited")
            
        end
    end
end

