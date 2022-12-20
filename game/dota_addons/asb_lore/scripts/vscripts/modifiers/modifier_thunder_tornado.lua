modifier_thunder_tornado = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_thunder_tornado:IsHidden()
	return true
end

function modifier_thunder_tornado:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_thunder_tornado:IsStunDebuff()
	return true
end

function modifier_thunder_tornado:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_thunder_tornado:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "toss_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
	local duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.target = self:GetParent()
	local height = 3000

	-- add arc modifier for vertical only
	self.arc = self.parent:AddNewModifier(
		self.caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			duration = duration,
			distance = 0,
			height = height,
			-- fix_end = true,
			fix_duration = false,
			isStun = true,
			activity = ACT_DOTA_FLAIL,
		} -- kv
	)
	self.arc:SetEndCallback(function( interrupted )
		-- destroy this modifier
		self:Destroy()

		-- not damage if interrupted
		if interrupted then return end

		-- find units
		local enemies = FindUnitsInRadius(
			self.caster:GetTeamNumber(),	-- int, your team number
			self.parent:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- precache damage
		local damageTable = {
			-- victim = target,
			attacker = self.caster,
			damage = self.damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}

		-- damage
		for _,enemy in pairs(enemies) do
			-- damage
			damageTable.victim = enemy
			if enemy==self.parent then
				damageTable.damage = 2*self.damage
			else
				damageTable.damage = self.damage
			end
			ApplyDamage(damageTable)
		end

		-- destroy trees
		GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.radius, false )


		-- play effects
		local sound_cast = "Ability.TossImpact"
		EmitSoundOn( sound_cast, self.parent )
	end)

	-- prepare horizontal motion
	local origin = self.target:GetOrigin()
	local direction = origin-self.parent:GetOrigin()
	local distance = direction:Length2D()
	direction.z = 0
	direction = direction:Normalized()

	-- init speed
	self.distance = distance
	if self.distance==0 then self.distance = 1 end
	self.duration = duration
	self.speed = distance/duration
	self.accel = 100
	self.max_speed = 3000

	-- apply motion
	if not self:ApplyVerticalMotionController() then
		self:Destroy()
	end

	-- emit sound
	local sound_cast = ""
	local sound_target = "mori.5_1"
	EmitSoundOn( sound_cast, self.caster )
	EmitSoundOn( sound_target, self.parent )
end

function modifier_thunder_tornado:OnRefresh( kv )
	
end

function modifier_thunder_tornado:OnRemoved()
end

function modifier_thunder_tornado:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_thunder_tornado:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects


function modifier_thunder_tornado:OnVerticalMotionInterrupted()
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_thunder_tornado:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_thunder_tornado:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end