function CastIcarusDive( event )
	local caster		= event.caster
	local ability		= event.ability

	local hpCost		= event.hp_cost
	local dashLength	= event.dash_length
	local dashWidth		= event.dash_width
	local dashDuration	= event.dash_duration

	local modifierCasterName	= event.modifier_caster_name

	local casterOrigin	= caster:GetAbsOrigin()
	local casterAngles	= caster:GetAngles()
	local forwardDir	= caster:GetForwardVector()
	local rightDir		= caster:GetRightVector()

	local ellipseCenter	= casterOrigin + forwardDir * ( dashLength / 2 )

	local startTime = GameRules:GetGameTime()

	caster:SetContextThink( DoUniqueString("updateIcarusDive"), function ( )

		local elapsedTime = GameRules:GetGameTime() - startTime
		local progress = elapsedTime / dashDuration

		-- Interrupted
		if not caster:HasModifier( modifierCasterName ) then
			return nil
		end

		-- Calculate potision
		local theta = -2 * math.pi * progress
		local x =  math.sin( theta ) * dashWidth * 1
		local y = -math.cos( theta ) * dashLength * 0.5

		local pos = ellipseCenter + rightDir * x + forwardDir * y
		local yaw = casterAngles.y + 90 + progress * -360  

		pos = GetGroundPosition( pos, caster )
		caster:SetAbsOrigin( pos )
		caster:SetAngles( casterAngles.x, yaw, casterAngles.z )

		return 0.03
	end, 0 )

	-- Spend HP cost
	caster:SetHealth( caster:GetHealth() * ( 100 - hpCost ) / 100 )

	-- Swap sub ability
	
end

--[[
	Author: Ractidous
	Date: 28.01.2015.
	End icarus dive.
]]
function EndIcarusDive( event )
	local caster	= event.caster
	local ability	= event.ability

	-- Swap main ability
	
end

--[[
	Author: Ractidous
	Date: 28.01.2015.
	Check current states and interrupt icarus dive if the caster is getting disabled.
]]
function CheckToInterrupt( event )
	local caster	= event.caster

	if caster:IsStunned() or caster:IsHexed() or caster:IsFrozen() or caster:IsNightmared() or caster:IsOutOfGame() then
		-- Interrupt the ability
		caster:RemoveModifierByName( event.modifier_caster_name )
	end
end

--[[
	Author: Ractidous
	Date: 28.01.2015.
	Apply the burn modifier if the target doesn't have that.
]]
function CheckToBurn( event )
	local caster		= event.caster
	local target		= event.target
	local ability		= event.ability
	local modifierName	= event.modifier_burn_name

	if not target:HasModifier( modifierName ) then
		ability:ApplyDataDrivenModifier( caster, target, modifierName, {} )
	end
end


