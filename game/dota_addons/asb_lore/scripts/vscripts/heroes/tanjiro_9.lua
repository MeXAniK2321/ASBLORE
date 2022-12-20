LinkLuaModifier("modifier_tanjiro_9", "heroes/tanjiro_9", LUA_MODIFIER_MOTION_NONE)

tanjiro_9 = class({})

function tanjiro_9:IsStealable() return true end
function tanjiro_9:IsHiddenWhenStolen() return false end

function tanjiro_9:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("tanjiro_blink")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function tanjiro_9:OnSpellStart()
    local caster = self:GetCaster()
    

    caster:AddNewModifier(caster, self, "modifier_tanjiro_9", {duration = 4.0})


    self:EndCooldown()

    EmitSoundOn("tanjiro.9", caster)
end

---------------------------------------------------------------------------------------------------------------------
modifier_tanjiro_9 = class({})
function modifier_tanjiro_9:IsHidden() return false end
function modifier_tanjiro_9:IsDebuff() return true end
function modifier_tanjiro_9:IsPurgable() return false end
function modifier_tanjiro_9:IsPurgeException() return false end
function modifier_tanjiro_9:RemoveOnDeath() return true end
function modifier_tanjiro_9:AllowIllusionDuplicate() return true end

function modifier_tanjiro_9:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()



    self.skills_table = {
                            ["tanjiro_9"] = "tanjiro_blink",
							
                            
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
          
     


		
        
        

       
    end
end

function modifier_tanjiro_9:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_tanjiro_9:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
              
                end
            end
			 self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
        end
    end
end


tanjiro_blink = class({})

--------------------------------------------------------------------------------
-- Ability Start
function tanjiro_blink:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	-- load data
	local max_range = self:GetSpecialValueFor("blink_range")

	-- determine target position
	local direction = (point - origin)
	if direction:Length2D() > max_range then
		direction = direction:Normalized() * max_range
	end

	-- teleport
	FindClearSpaceForUnit( caster, origin + direction, true )
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
	caster:PerformAttack(enemy, true,
				true,
				true,
				true,
				true,
				false,
				true)
	end

	-- Play effects
	self:PlayEffects( origin, direction )
end

--------------------------------------------------------------------------------
function tanjiro_blink:PlayEffects( origin, direction )
	-- Get Resources
	local particle_cast_a = "particles/econ/events/ti7/blink_dagger_end_ti7_lvl2.vpcf"
	local sound_cast_a = "tanjiro.9_blink"

	local particle_cast_b = "particles/tanjiro_9_blink.vpcf"
	local sound_cast_b = "tanjiro.9_blink"

	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	-- At original position
	local effect_cast_b = ParticleManager:CreateParticle( particle_cast_b, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_b, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast_b, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_b )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast_b, self:GetCaster() )
end