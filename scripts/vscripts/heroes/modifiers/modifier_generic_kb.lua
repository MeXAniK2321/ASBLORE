LinkLuaModifier("modifier_projectile_bug", "heroes/modifiers/modifier_projectile_bug", LUA_MODIFIER_MOTION_NONE)

modifier_generic_kb = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_kb:IsHidden()
	return false
end

function modifier_generic_kb:IsPurgable()
	return false
end

function modifier_generic_kb:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_kb:OnCreated( kv )
	if IsServer() then
		-- creation data (default)
			-- kv.distance (0)
			-- kv.height (-1)
			-- kv.duration (0)
			-- kv.direction_x, kv.direction_y, kv.direction_z (xy:-forward vector, z:0)
			-- kv.tree_destroy_radius (hull-radius), can be null if -1 
			-- kv.IsStun (false)
			-- kv.IsFlail (true)
			-- kv.IsPurgable() // later 
			-- kv.IsMultiple() // later

		-- references
		self.distance = kv.distance
		self.height = kv.height
		self.duration = kv.duration

		if kv.direction_x and kv.direction_y then
			self.direction = Vector(kv.direction_x,kv.direction_y,0):Normalized()
		else
			if self.gintoki then
				self.direction = self:GetParent():GetForwardVector()
			else
				self.direction = -(self:GetParent():GetForwardVector())
			end
		end
		self.tree = kv.tree_destroy_radius or self:GetParent():GetHullRadius()

		--[[ if kv.IsStun  then self.stun = kv.IsStun==1 else self.stun = false end
		if kv.IsFlail then self.flail = kv.IsFlail==1 else self.flail = true end ]]

		self.stun = true
		self.flail = true

		-- check duration
		if self.duration == 0 then
			self:Destroy()
			return
		end

		-- load data
		self.parent = self:GetParent()
		self.origin = self.parent:GetOrigin()

		-- horizontal init
		self.hVelocity = self.distance/self.duration

		-- vertical init
		local half_duration = self.duration/2
		self.gravity = 2*self.height/(half_duration*half_duration)
		self.vVelocity = self.gravity*half_duration

		-- apply motion controllers
		if self.distance>0 then
			if self:ApplyHorizontalMotionController() == false then 
				self:Destroy()
				return
			end
		end
		if self.height>=0 then
			if self:ApplyVerticalMotionController() == false then
				self:Destroy()
				return
			end
		end

		-- tell client of activity
		if self.stun then
			self:SetStackCount( 1 )
		elseif self.flail then
			self:SetStackCount( 2 )
		end
	else
		self.anim = self:GetStackCount()
		self:SetStackCount( 0 )
	end
end

function modifier_generic_kb:OnRefresh( kv )
	if not IsServer() then return end
end

function modifier_generic_kb:OnDestroy( kv )
	if not IsServer() then return end

	if not self.interrupted then
		-- destroy trees
		if self.tree>0 then
			GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree, true )
		end
	end

	if self.EndCallback then
		self.EndCallback( self.interrupted )
	end

	GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(), 100, true)

	self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 1)

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_projectile_bug", {duration = 0.1})
end

--------------------------------------------------------------------------------
-- Setter
function modifier_generic_kb:SetEndCallback( func ) 
	self.EndCallback = func
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_generic_kb:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_generic_kb:UpdateHorizontalMotion( me, dt )
	local parent = self:GetParent()

	-- set position
	local target = self.direction*self.distance*(dt/self.duration)

	-- change position
	parent:SetOrigin( parent:GetOrigin() + target )

	GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(), self.tree, true)
end

function modifier_generic_kb:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end

function modifier_generic_kb:UpdateVerticalMotion( me, dt )
	-- set time
	local time = dt/self.duration

	-- change height
	self.parent:SetOrigin( self.parent:GetOrigin() + Vector( 0, 0, self.vVelocity*dt ) )

	-- calculate vertical velocity
	self.vVelocity = self.vVelocity - self.gravity*dt
end

function modifier_generic_kb:OnVerticalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_generic_kb:GetEffectName()
	if not IsServer() then return end
	if self.stun == true then
		return "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_stunned_orbit.vpcf"
	end
end

function modifier_generic_kb:GetEffectAttachType()
	if not IsServer() then return end
	return PATTACH_OVERHEAD_FOLLOW
end