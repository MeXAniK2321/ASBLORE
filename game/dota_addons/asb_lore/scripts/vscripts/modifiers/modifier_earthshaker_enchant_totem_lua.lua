modifier_earthshaker_enchant_totem_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_enchant_totem_lua:IsHidden()
	return false
end

function modifier_earthshaker_enchant_totem_lua:IsDebuff()
	return false
end

function modifier_earthshaker_enchant_totem_lua:IsPurgable()
	return true
end
function modifier_earthshaker_enchant_totem_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_enchant_totem_lua:OnCreated( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "totem_damage_percentage" ) -- special value
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" ) -- special value
	if IsServer() then
	local caster = self:GetCaster()
  
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
                local r = self:GetSpecialValueFor("max_damage") 
    
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = r,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                
                target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun")})
    
                ApplyDamage(damage)  
            end
        end
		
	end


function modifier_earthshaker_enchant_totem_lua:OnRefresh( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "totem_damage_percentage" ) -- special value
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" ) -- special value
end

function modifier_earthshaker_enchant_totem_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_earthshaker_enchant_totem_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end

function modifier_earthshaker_enchant_totem_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus
end

function modifier_earthshaker_enchant_totem_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- effects
		local sound_cast = "Hero_EarthShaker.Totem.Attack"
		EmitSoundOn( sound_cast, params.target )

		self:Destroy()
	end
end

function modifier_earthshaker_enchant_totem_lua:GetModifierAttackRangeBonus()
	return self.range
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_earthshaker_enchant_totem_lua:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_earthshaker_enchant_totem_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_totem" )~=0 then attach = "attach_totem" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end