function Blink(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()
	local difference = point - casterPos
	local ability = keys.ability
	local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))

	if difference:Length2D() > range then
		point = casterPos + (point - casterPos):Normalized() * range
	end

	FindClearSpaceForUnit(caster, point, false)
	ProjectileManager:ProjectileDodge(caster)
	
	local blinkIndex = ParticleManager:CreateParticle("particles/earthshaker_arcana_blink_start1.vpcf", PATTACH_ABSORIGIN, caster)
	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle( blinkIndex, false )
		return nil
		end
	)
end