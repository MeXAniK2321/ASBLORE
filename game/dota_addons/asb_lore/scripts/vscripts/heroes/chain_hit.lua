chain_hit = class({})
LinkLuaModifier("modifier_generic_slow","modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_chains", "heroes/chain_hit.lua", LUA_MODIFIER_MOTION_NONE )

function chain_hit:GetIntrinsicModifierName()
    return "modifier_chains"
end
function chain_hit:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("steal_chain")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function chain_hit:IsStealable() return true end
function chain_hit:IsHiddenWhenStolen() return false end
function chain_hit:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function chain_hit:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition() 

	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("distance") + caster:GetCastRangeBonus()
	local width = self:GetSpecialValueFor("width")

	if point == caster:GetOrigin() then
		self:EndCooldown()
		return nil
	end
	
	self.vChainOffset = Vector( 0, 0, 96 )

	self.vStartPosition = caster:GetOrigin()

	local vDirection = self:GetCursorPosition() - self.vStartPosition
	vDirection.z = 0.0

	local vDirection = ( vDirection:Normalized() ) * distance

	self.vTargetPosition = self.vStartPosition + vDirection

	local vChainTarget = self.vTargetPosition + self.vChainOffset
	local vKillswitch = Vector( ( ( distance / speed ) * 2 ), 0, 0 )

	self.chain_particle = 	ParticleManager:CreateParticle( "particles/chain_test1.vpcf", PATTACH_CUSTOMORIGIN, caster )
								ParticleManager:SetParticleAlwaysSimulate( self.chain_particle )
								ParticleManager:SetParticleControlEnt( self.chain_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin() + self.vChainOffset, true )
								ParticleManager:SetParticleControl( self.chain_particle, 1, vChainTarget )
								ParticleManager:SetParticleControl( self.chain_particle, 2, Vector( speed, distance, width ) )
								ParticleManager:SetParticleControl( self.chain_particle, 3, vKillswitch )
								ParticleManager:SetParticleControl( self.chain_particle, 4, Vector( 1, 0, 0 ) )
								ParticleManager:SetParticleControl( self.chain_particle, 5, Vector( 0, 0, 0 ) )
								ParticleManager:SetParticleControlEnt( self.chain_particle, 7, caster, PATTACH_CUSTOMORIGIN, nil, caster:GetOrigin(), true )
	
	self.chain_projectile = {	Ability = self,
									vSpawnOrigin = caster:GetOrigin(),
									vVelocity = vDirection:Normalized() * speed,
									fDistance = distance,
									fStartRadius = width,
									fEndRadius = width,
									Source = caster,
									iUnitTargetTeam   = self:GetAbilityTargetTeam(),
									iUnitTargetType   = self:GetAbilityTargetType(),
									iUnitTargetFlags  = self:GetAbilityTargetFlags(),
									bProvidesVision	  = true,
									iVisionRadius	  = width,
									iVisionTeamNumber = caster:GetTeamNumber()}

	ProjectileManager:CreateLinearProjectile(self.chain_projectile)

	EmitSoundOn("kurapika.1", caster)

	self.first_hit = false
end
function chain_hit:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		ParticleManager:SetParticleControlEnt( self.chain_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + self.vChainOffset, true)
		return nil
	end

	if self.first_hit == false then
		local nFXIndex = 	ParticleManager:CreateParticle( "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_ti9_bloodspray_tgt.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
							ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
							ParticleManager:ReleaseParticleIndex( nFXIndex )

		
		local damage_table = {	victim = hTarget,
								attacker = self:GetCaster(),
								damage = self:GetSpecialValueFor("damage")+ self:GetCaster():FindTalentValue("special_bonus_kurapika_20"),
								damage_type = self:GetAbilityDamageType(),
								ability = self }

		ApplyDamage(damage_table)
		if self:GetCaster():HasModifier("modifier_emperor_time") then
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_generic_slow", {duration = 0.8})
		else
		end
	
		ParticleManager:SetParticleControlEnt( self.chain_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + self.vChainOffset, true)
	
		self.first_hit = true
	end
end
modifier_chains = class ({})
function modifier_chains:IsHidden() return true end
function modifier_chains:IsDebuff() return false end
function modifier_chains:IsPurgable() return false end
function modifier_chains:IsPurgeException() return false end
function modifier_chains:RemoveOnDeath() return false end

function modifier_chains:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_chains:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_chains:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_chains:GetModifierBaseAttackTimeConstant()
	return 1.8
end
function modifier_chains:OnIntervalThink()
    if IsServer() then
        local chain_bastard = self:GetParent():FindAbilityByName("steal_chain")
        if chain_bastard and not chain_bastard:IsNull() then
            if self:GetParent():HasScepter() then
                if chain_bastard:IsHidden() then
                    chain_bastard:SetHidden(false)
                end
            else
                if not chain_bastard:IsHidden() then
                    chain_bastard:SetHidden(true)
                end
            end
        end
    end
end