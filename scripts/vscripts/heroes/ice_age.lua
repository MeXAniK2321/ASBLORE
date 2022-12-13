function bvo_aokiji_skill_5_cast(keys)
	local caster = keys.caster
	local multi = keys.multi+caster:FindTalentValue("special_bonus_yoshino_25")
	local ability = keys.ability
	ability.hitUnits = {}
	--ability.ringDummys = {}

	local wave = 0
	Timers:CreateTimer(0.12, function()
		if wave < 2 then
			wave = wave + 1
			local radius = wave * 340
			localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
			            caster:GetAbsOrigin(),
			            nil,
			            radius,
			            DOTA_UNIT_TARGET_TEAM_ENEMY,
			            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			            DOTA_UNIT_TARGET_FLAG_NONE,
			            FIND_ANY_ORDER,
			            false)

			--particle dummy
			caster:EmitSound("yoshino.cry")
			local shards = 8 * wave
			for i = 1, shards do
				local point_projectile = caster:GetAbsOrigin() + Vector(radius, 0, 0)
				local rotation = QAngle( 0, i * (360 / shards), 0 )
				local rot_vector = RotatePosition(caster:GetAbsOrigin(), rotation, point_projectile)
				local dummy = CreateUnitByName("npc_dummy_unit", rot_vector, false, nil, nil, caster:GetTeam())
				dummy.angle = i * (360 / shards)
				dummy:AddAbility("custom_point_dummy")
				local abl = dummy:FindAbilityByName("custom_point_dummy")
				if abl ~= nil then abl:SetLevel(1) end
				dummy:SetModel("models/particle/ice_shards.vmdl")
				dummy:SetOriginalModel("models/particle/ice_shards.vmdl")
				dummy:SetModelScale(30.0)
				local vec_up = Vector( dummy:GetAbsOrigin().x, dummy:GetAbsOrigin().y, dummy:GetAbsOrigin().z - 60)
				dummy:SetAbsOrigin(vec_up)
				ability:ApplyDataDrivenModifier(caster, dummy, "bvo_aokiji_skill_5_dummy_modifier", {duration=1.0} )
				--table.insert(ability.ringDummys, dummy)
			end
			--
			for _,target in pairs(localUnits) do
				local flag = false
				for _,hit in pairs(ability.hitUnits) do
					if target == hit then flag = true end
				end
				if not flag then
					local damageTable = {
						victim = target,
						attacker = caster,
						damage = multi,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					ApplyDamage(damageTable)
					ability:ApplyDataDrivenModifier(caster, target, "bvo_aokiji_skill_5_freeze_modifier", {duration=2.0} )
					table.insert(ability.hitUnits, target)
				end
			end
			return 0.12
		else
			return nil
		end
	end)
end

function bvo_aokiji_skill_5_dummy(keys)
	local caster = keys.target

	local vec_up = Vector( caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z - 10)
	caster:SetAbsOrigin(vec_up)
end

function bvo_aokiji_skill_5_dummy_end(keys)
	local caster = keys.target
	caster:RemoveSelf()
end