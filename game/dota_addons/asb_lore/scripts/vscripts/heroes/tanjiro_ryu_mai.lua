LinkLuaModifier("modifier_tanjiro_ryu_mai_caster", "heroes/tanjiro_ryu_mai.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tanjiro_ryu_mai_marker", "heroes/tanjiro_ryu_mai.lua", LUA_MODIFIER_MOTION_NONE)
if tanjiro_ryu_mai == nil then tanjiro_ryu_mai = class({}) end
function tanjiro_ryu_mai:IsStealable() return true end
function tanjiro_ryu_mai:IsHiddenWhenStolen() return false end
function tanjiro_ryu_mai:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function tanjiro_ryu_mai:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()
		local original_direction = (caster:GetAbsOrigin() - target_loc):Normalized()
		local effect_radius = self:GetSpecialValueFor("radius")
		local attack_interval = self:GetSpecialValueFor("interval")
		local sleight_targets = {}
		if  self:GetCaster():HasModifier( "modifier_enbu" ) then
		self.sleight_cast = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf"
		self.sleight_tgt = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf"
		self.sleight_trail = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf"
		else
				self.sleight_cast = "particles/tanjiro_mai.vpcf"
		self.sleight_tgt = "particles/tanjiro_mai_cut.vpcf"
		self.sleight_trail = "particles/tanjiro_trail.vpcf"
		end

		caster:EmitSound("tanjiro.2")
		local cast_pfx = ParticleManager:CreateParticle(self.sleight_cast, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
		ParticleManager:SetParticleControl(cast_pfx, 1, Vector(effect_radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for _, enemy in pairs(nearby_enemies) do
			sleight_targets[#sleight_targets + 1] = enemy:GetEntityIndex()
			enemy:AddNewModifier(caster, self, "modifier_tanjiro_ryu_mai_marker", {duration = (#sleight_targets - 1) * attack_interval})
			local damageTable = {
		attacker = caster,
		damage = self:GetSpecialValueFor("bonus_damage") + self:GetCaster():FindTalentValue("special_bonus_tanjiro_25"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		
		end

		

		--Bonus check for dissapearing
		Timers:CreateTimer((((#sleight_targets - 1) * attack_interval) + 1), function()
			if caster:HasModifier("modifier_tanjiro_ryu_mai_caster") then
				caster:RemoveModifierByName("modifier_tanjiro_ryu_mai_caster")
			end
		end)

		--print(#sleight_targets)
		if #sleight_targets >= 1 then
			local previous_position = caster:GetAbsOrigin()
			local current_count = 1
			local current_target = EntIndexToHScript(sleight_targets[current_count])
			caster:AddNewModifier(caster, self, "modifier_tanjiro_ryu_mai_caster", {})
			ProjectileManager:ProjectileDodge(caster)
			Timers:CreateTimer(FrameTime(), function()
				if current_target:IsAlive() then
					-- Particles and sound
					caster:EmitSound("Hero_EmberSpirit.SleightOfFist.Damage")
					--caster:EmitSound("Akame.Sleight.Cut")
					local slash_pfx = ParticleManager:CreateParticle(self.sleight_tgt, PATTACH_ABSORIGIN_FOLLOW, current_target)
					ParticleManager:SetParticleControl(slash_pfx, 0, current_target:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(slash_pfx)

					local trail_pfx = ParticleManager:CreateParticle(self.sleight_trail, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(trail_pfx, 0, current_target:GetAbsOrigin())
					ParticleManager:SetParticleControl(trail_pfx, 1, previous_position)
					ParticleManager:ReleaseParticleIndex(trail_pfx)

					if caster:HasModifier("modifier_tanjiro_ryu_mai_caster") then
						caster:SetAbsOrigin(current_target:GetAbsOrigin() + original_direction * 64)
					
					end
				end

				current_count = current_count + 1
				
				if #sleight_targets >= current_count and caster:HasModifier("modifier_tanjiro_ryu_mai_caster") and not current_target:IsNull() then
					previous_position = current_target:GetAbsOrigin()
					current_target = EntIndexToHScript(sleight_targets[current_count])
					return attack_interval
				else
					if caster:HasModifier("modifier_tanjiro_ryu_mai_caster") then
						FindClearSpaceForUnit(caster, caster_loc, true)
					end
					caster:RemoveModifierByName("modifier_tanjiro_ryu_mai_caster")
					for _, target in pairs(sleight_targets) do
						EntIndexToHScript(target):RemoveModifierByName("modifier_tanjiro_ryu_mai_marker")
					end
				end
			end)
		end
	end
end		
--------------------------------------------------------------------------------------------------------------------
modifier_tanjiro_ryu_mai_marker = modifier_tanjiro_ryu_mai_marker or class ({})
function modifier_tanjiro_ryu_mai_marker:IsDebuff() return true end
function modifier_tanjiro_ryu_mai_marker:IsHidden() return true end
function modifier_tanjiro_ryu_mai_marker:IsPurgable() return false end
function modifier_tanjiro_ryu_mai_marker:GetEffectName()
	return "particles/tanjiro_mai_marker.vpcf"
end
function modifier_tanjiro_ryu_mai_marker:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
--------------------------------------------------------------------------------------------------------------------
modifier_tanjiro_ryu_mai_caster = modifier_tanjiro_ryu_mai_caster or class ({})
function modifier_tanjiro_ryu_mai_caster:IsDebuff() return false end
function modifier_tanjiro_ryu_mai_caster:IsHidden() return true end
function modifier_tanjiro_ryu_mai_caster:IsPurgable() return false end
function modifier_tanjiro_ryu_mai_caster:OnCreated()
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end

function modifier_tanjiro_ryu_mai_caster:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_DISARMED] = true
		}
		return state
	end
end
function modifier_tanjiro_ryu_mai_caster:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE}
	return funcs
end
function modifier_tanjiro_ryu_mai_caster:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
function modifier_tanjiro_ryu_mai_caster:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()
	end
end