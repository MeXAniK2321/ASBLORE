modifier_cruel_sun = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_cruel_sun:IsHidden()
	return false
end

function modifier_cruel_sun:IsDebuff()
	return true
end

function modifier_cruel_sun:IsStunDebuff()
	return true
end

function modifier_cruel_sun:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_cruel_sun:OnCreated( kv )
	-- references
	self.ability = self:GetAbility()

	if IsServer() then
		self.projectile = kv.projectile

		-- face towards
		self:GetParent():SetForwardVector( -self:GetAbility().projectiles[kv.projectile].direction )
		self:GetParent():FaceTowards( self.ability.projectiles[self.projectile].init_pos )

		-- try apply
		if self:ApplyHorizontalMotionController() == false then
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 0.5 } -- kv
	)
	
			self:Destroy()
		end
	end
end

function modifier_cruel_sun:OnRefresh( kv )
	
end

function modifier_cruel_sun:OnRemoved()
self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 0.5 } -- kv
	)
	if not IsServer() then return end
	-- Compulsory interrupt
	self:GetParent():InterruptMotionControllers( false )
end

function modifier_cruel_sun:OnDestroy()
 self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 0.5 } -- kv
	)
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_cruel_sun_debuff", -- modifier name
		{ duration = 2 } -- kv
	)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_cruel_sun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_cruel_sun:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_cruel_sun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_cruel_sun:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_cruel_sun:UpdateHorizontalMotion( me, dt )
	-- check projectile data
	if not self.ability.projectiles[self.projectile] then
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 0.5 } -- kv
	)
		self:Destroy()
		return
	end

	-- get location
	local data = self.ability.projectiles[self.projectile]

	if not data.active then return end

	-- move parent to projectile location
	self:GetParent():SetOrigin( data.location + data.direction*60 )
end

function modifier_cruel_sun:OnHorizontalMotionInterrupted()
	if IsServer() then
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 0.5 } -- kv
	)
		self:Destroy()
	end
end