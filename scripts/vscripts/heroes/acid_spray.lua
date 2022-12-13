function AcidSpraySound( event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	
    event.caster:EmitSound("yoshino.zayac_attack")
	target:EmitSound("sounds/weapons/hero/crystal_maiden/frostbite.vsnd")

	-- Stops the sound after the duration, a bit early to ensure the thinker still exists
	Timers:CreateTimer(duration-0.1, function() 
		target:StopSound("sounds/weapons/hero/crystal_maiden/frostbite.vsnd") 
	end)

end