modifier_doppel_hit = modifier_doppel_hit or class({})

--------------------------------------------------------------------------------
function modifier_doppel_hit:IsHidden() return false end
function modifier_doppel_hit:IsDebuff() return false end
function modifier_doppel_hit:IsPurgable() return false end
function modifier_doppel_hit:RemoveOnDeath() return false end
function modifier_doppel_hit:AllowIllusionDuplicate() return false end
--------------------------------------------------------------------------------
function modifier_doppel_hit:OnCreated( kv )
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	self.soul_max = self:GetAbility():GetSpecialValueFor("soul_max")
    self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" ) 
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.duration2 = self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction()
	self.crit_bonus = 100
	
    -- Vergil particle effect aura from ANIME Illya hero
	if IsClient() then
        if not self.iBerserkPFX then
            self.iBerserkPFX =  ParticleManager:CreateParticle("particles/heroes/anime_hero_illya/illya_berserk_summon_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                --[[ParticleManager:SetParticleControlEnt(  self.iBerserkPFX,
                                                                        1,
                                                                        self.parent,
                                                                        PATTACH_POINT_FOLLOW,
                                                                        "attach_hitloc",
                                                                        Vector(0,0,0),
                                                                        true)]]
                                --ParticleManager:SetParticleControl(self.iBerserkPFX, 1, Vector(self.fRadius, 0, 0))
                                ParticleManager:SetParticleControl(self.iBerserkPFX, 60, Vector(0, 0, 0))
                                ParticleManager:SetParticleControl(self.iBerserkPFX, 61, Vector(0, 0, 0))

            self:AddParticle(self.iBerserkPFX, false, false, -1, false, false)
			
	    end
    end

	if IsServer() then
		self:SetStackCount(0)
	end
	
	-- Add Aghanim Scepter
	if IsServer() and not self.parent:HasModifier("modifier_item_ultimate_scepter") then
      self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end

end

function modifier_doppel_hit:OnRefresh( kv )
    self:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_doppel_hit:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
function modifier_doppel_hit:OnAttackLanded(params)
	if IsServer() then
		if RandomInt(0, 100)<self.crit_chance and params.attacker == self.parent and not params.attacker:IsIllusion() then
		   if self:GetAbility():IsFullyCastable() then
		      if not self:GetParent():HasModifier( "modifier_judgment_cut_cd" ) then
			     self.ability = self:GetAbility()
			     local cool = self.duration2
			     if self:GetCaster():HasTalent("special_bonus_vergil_25") then
			        self.ability:StartCooldown(2.5)
			     else
	                self.ability:StartCooldown(cool)
	             end
		      self:GetParent():PerformAttack(params.target, true, true, true, true, true, false, true)
		      self:PlayEffects(params.target)
		      end
		   end
        end
    end
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_doppel_hit:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/doppel_hit.vpcf"
	local sound_cast = "vergil.2"
	
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

	EmitSoundOn( sound_cast, target )
end
