x_burner = class({})

function x_burner:IsStealable() return true end
function x_burner:IsHiddenWhenStolen() return false end
function x_burner:OnAbilityPhaseStart()
            self:GetCaster():SetSingleMeshGroup("2")
	

	self.launcher_charge_fx = 	ParticleManager:CreateParticle("particles/phoenix_sunray_left.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 0, self:GetCaster(), 5, "attach_left_arm", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 1, self:GetCaster(), 5, "attach_left_arm", Vector(0,0,0), true)

    return true
end
function x_burner:OnAbilityPhaseInterrupted()
      caster:SetSingleMeshGroup("1")

	if self.launcher_charge_fx then
	    ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
	end
end
function x_burner:OnSpellStart()
    local caster = self:GetCaster()

	EmitSoundOn("x_burner.1", caster)

    self.launcher_damage = self:GetSpecialValueFor("launcher_damage") 
    self.launcher_damage = self.launcher_damage / self:GetChannelTime() or 1
end
function x_burner:OnChannelFinish(bInterrupted)
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_AMBUSH)


	

	EmitSoundOn("x_burner.2", caster)

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

	local cero_particle = "particles/phoenix_sunray_right.vpcf"
	local cero_particle_end = "particles/phoenix_sunray_energy_right.vpcf"
	local pfx = ParticleManager:CreateParticle(cero_particle, PATTACH_WORLDORIGIN, nil )
	local pfx_end = ParticleManager:CreateParticle(cero_particle_end, PATTACH_WORLDORIGIN, nil )
	local attach_point = caster:ScriptLookupAttachment("attach_right_arm")

	ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
	ParticleManager:SetParticleControl(pfx_end, 0, caster:GetAttachmentOrigin(attach_point))

	local endcapPos = caster:GetAbsOrigin() + caster:GetForwardVector() * distance
	
	GridNav:DestroyTreesAroundPoint(endcapPos, width, false)

	endcapPos = GetGroundPosition( endcapPos, nil )
	endcapPos.z = endcapPos.z + 92

	ParticleManager:SetParticleControl( pfx, 1, endcapPos )
	ParticleManager:SetParticleControl( pfx_end, 3, endcapPos ) --IN ir EndCap your effect

	local start_loc = caster:GetAbsOrigin() + caster:GetForwardVector() * 250
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

			EmitSoundOn("x_burner.3", enemy)		
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
