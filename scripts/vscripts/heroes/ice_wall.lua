function invoker_ice_wall_datadriven_on_spell_start(keys)
	keys.caster:EmitSound("Hero_Invoker.IceWall.Cast")

	local caster_point = keys.caster:GetAbsOrigin()
	local direction_to_target_point = keys.caster:GetForwardVector()
	target_point = caster_point + (direction_to_target_point * keys.WallPlaceDistance)
	local direction_to_target_point_normal = Vector(-direction_to_target_point.y, direction_to_target_point.x, direction_to_target_point.z)
	local vector_distance_from_center = (direction_to_target_point_normal * (keys.NumWallElements * keys.WallElementSpacing)) / 2
	local one_end_point = target_point - vector_distance_from_center
	
	--Display the Ice Wall particles in a line.
	local ice_wall_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(ice_wall_particle_effect, 0, target_point - vector_distance_from_center)
	ParticleManager:SetParticleControl(ice_wall_particle_effect, 1, target_point + vector_distance_from_center)
	
	local ice_wall_particle_effect_b = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_ABSORIGIN, keys.caster)
	ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 0, target_point - vector_distance_from_center)
	ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 1, target_point + vector_distance_from_center)
	
	--Ice Wall's duration is dependent on the level of Quas.
	local caster = keys.caster
	local ability = keys.ability

	local ice_wall_duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )

	
	--Ice Wall's damage per second is dependent on the level of Exort.
	
	local ice_wall_damage_per_second = ability:GetLevelSpecialValueFor( "damage_per_second", ability:GetLevel() - 1 )
	
	
	--Remove the Ice Wall particles after the duration ends.
	Timers:CreateTimer({
		endTime = ice_wall_duration,
		callback = function()
			ParticleManager:DestroyParticle(ice_wall_particle_effect, false)
			ParticleManager:DestroyParticle(ice_wall_particle_effect_b, false)
		end
	})
	
	--Create dummy units in a line that slow nearby enemies with their aura.
	for i=0, keys.NumWallElements, 5 do
		local ice_wall_unit = CreateUnitByName("npc_dummy_unit", one_end_point + direction_to_target_point_normal * (keys.WallElementSpacing * i), false, nil, nil, keys.caster:GetTeam())
		
		--We give the ice wall dummy unit its own instance of Ice Wall both to more easily make it apply the correct intensity of slow (based on Quas' level)
		--and because if Invoker uninvokes Ice Wall and the spell is removed from his toolbar, existing modifiers originating from that ability can start to error out.
		ice_wall_unit:AddAbility("ice_wall_datadriven")
		local ice_wall_unit_ability = ice_wall_unit:FindAbilityByName("ice_wall_datadriven")
		if ice_wall_unit_ability ~= nil then
			ice_wall_unit_ability:SetLevel(ability:GetLevel() - 1 ) --This ensures the correct slow intensity is applied.
			ice_wall_unit_ability:ApplyDataDrivenModifier(ice_wall_unit, ice_wall_unit, "modifier_invoker_ice_wall_datadriven_unit_ability", {duration = -1})
			ice_wall_unit_ability:ApplyDataDrivenModifier(ice_wall_unit, ice_wall_unit, "modifier_invoker_ice_wall_datadriven_unit_ability_aura_emitter_slow", {duration = -1})
			ice_wall_unit_ability:ApplyDataDrivenModifier(ice_wall_unit, ice_wall_unit, "modifier_invoker_ice_wall_datadriven_unit_ability_aura_emitter_damage", {duration = -1})
		end
		
		--Store the damage per second to deal.  This value is locked depending on Exort's level at the time Ice Wall was cast.
		ice_wall_unit.damage_per_second = ice_wall_damage_per_second
		ice_wall_unit.parent_caster = keys.caster  --Store the reference to the Invoker that spawned this Ice Wall unit.
		
		--Remove the Ice Wall auras after the duration ends, and the dummy units themselves after their aura slow modifiers will have all expired.
		Timers:CreateTimer({
			endTime = ice_wall_duration,
			callback = function()
				ice_wall_unit:RemoveModifierByName("modifier_invoker_ice_wall_datadriven_unit_ability_aura_emitter_slow")
				ice_wall_unit:RemoveModifierByName("modifier_invoker_ice_wall_datadriven_unit_ability_aura_emitter_damage")
				
				Timers:CreateTimer({
					endTime = keys.SlowDuration + 2,
					callback = function()
						ice_wall_unit:RemoveSelf()
					end
				})
			end
		})
	end
end


--[[ ============================================================================================================
	Author: Rook
	Date: April 06, 2015
	Called regularly while a unit is affected by Ice Wall's damaging aura.  Damages them.
	Additional parameters: keys.DamageInterval
================================================================================================================= ]]
function modifier_invoker_ice_wall_datadriven_unit_ability_aura_damage_on_interval_think(keys)
	if keys.caster.damage_per_second ~= nil and keys.caster.parent_caster ~= nil then
		ApplyDamage({victim = keys.target, attacker = keys.caster.parent_caster, damage = keys.caster.damage_per_second * keys.DamageInterval, damage_type = DAMAGE_TYPE_MAGICAL,})
	end
end