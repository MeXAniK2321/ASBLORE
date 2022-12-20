modifier_ryougi_shikiE = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ryougi_shikiE:IsHidden()
	return false
end

function modifier_ryougi_shikiE:IsPurgable()
	return false
end

function modifier_ryougi_shikiE:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ryougi_shikiE:OnCreated( kv )
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

		-- apply motion controllers
		if self.distance>0 then
			if self:ApplyHorizontalMotionController() == false then 
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

function modifier_ryougi_shikiE:OnRefresh( kv )
	if not IsServer() then return end
end

function modifier_ryougi_shikiE:OnDestroy( kv )
	if not IsServer() then return end

	if not self.interrupted then
		-- destroy trees
		if self.tree>0 then
			GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 400, true )
		end
	end

	if self.EndCallback then
		self.EndCallback( self.interrupted )
	end

	self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 1)
end

--------------------------------------------------------------------------------
-- Setter
function modifier_ryougi_shikiE:SetEndCallback( func ) 
	self.EndCallback = func
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ryougi_shikiE:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_ryougi_shikiE:UpdateHorizontalMotion( me, dt )
	local parent = self:GetParent()

	-- set position
	local target = self.direction*self.distance*(dt/self.duration)

	-- change position
	parent:SetOrigin( parent:GetOrigin() + target )
end

function modifier_ryougi_shikiE:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end