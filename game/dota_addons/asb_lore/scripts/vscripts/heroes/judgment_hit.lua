judgment_hit = class({})
LinkLuaModifier( "modifier_judgment_hit", "modifiers/modifier_judgment_hit.lua" ,LUA_MODIFIER_MOTION_NONE )

--[[Author: Valve
	Date: 26.09.2015.]]
--------------------------------------------------------------------------------

function judgment_hit:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function judgment_hit:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function judgment_hit:GetChannelTime()
	self.creep_duration = self:GetSpecialValueFor( "creep_duration" )
	self.hero_duration = self:GetSpecialValueFor( "hero_duration" )

	if IsServer() then
		if self.hVictim ~= nil then
			if self.hVictim:IsConsideredHero() then
				return self.hero_duration
			else
				return self.creep_duration
			end
		end

		return 0.0
	end

	return self.hero_duration
end

--------------------------------------------------------------------------------

function judgment_hit:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function judgment_hit:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_judgment_hit", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function judgment_hit:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_judgment_hit" )
	end
end