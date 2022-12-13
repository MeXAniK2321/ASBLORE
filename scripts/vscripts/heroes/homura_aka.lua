homura_aka = class({})
LinkLuaModifier( "modifier_homura_aka", "modifiers/modifier_homura_aka", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
homura_aka.targets = {}
function homura_aka:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	-- load data
	local duration = self:GetChannelTime()

	self.targets = {}

	-- add modifier
	self.modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_homura_aka", -- modifier name
		{
			duration = duration,
			x = point.x,
			y = point.y,
			z = point.z,
		} -- kv
	)

end
--------------------------------------------------------------------------------
-- Projectile
function homura_aka:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end
	-- check if already attacked on this wave
	if self.targets[ target ]==data.wave then return false end
	self.targets[ target ] = data.wave

	-- get value
	local damage = self:GetSpecialValueFor( "arrow_damage_pct" )+ self:GetCaster():FindTalentValue("special_bonus_homura_20")
	local slow = self:GetSpecialValueFor( "arrow_slow_duration" )

	-- check frost arrow ability
	

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		-- damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)

	-- play effects
	local sound_cast = "homura.2_1"
	EmitSoundOn( sound_cast, target )

	return true
end

--------------------------------------------------------------------------------
-- Ability Channeling
function homura_aka:OnChannelFinish( bInterrupted )
	-- destroy modifier
	if not self.modifier:IsNull() then self.modifier:Destroy() end
end