
modifier_vainglory = class({})
function modifier_vainglory:IsHidden()
	return true
end

function modifier_vainglory:IsPurgable()
	return false
end
function modifier_vainglory:OnCreated()
    if not IsServer() then return end
    self.carapaced_units = {}
    self.caster_stun = true
end

function modifier_vainglory:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_vainglory:OnTakeDamage( params )
    if not IsServer() then return end
    if params.unit == self:GetParent() then
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_chance" )
	if RandomInt(0, 100)<self.crit_chance then
	if self:GetAbility():IsFullyCastable() then
	   
		if params.attacker == self:GetParent() then return end
		if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
			if not self.carapaced_units[ params.attacker:entindex() ] then		       				
			end
			local hp = self:GetParent():GetMaxHealth() * 0.05
			if self:GetCaster():HasTalent("special_bonus_pandora_20") then
			self.heal = self:GetAbility():GetSpecialValueFor("heal") + hp
			else
			self.heal = self:GetAbility():GetSpecialValueFor("heal")
			end
			local delay = 0.2

	Timers:CreateTimer(delay,function()
	self:GetCaster():Heal( self.heal, self )
	end)
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		450,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		end
			
			self.carapaced_units[ params.attacker:entindex() ] = params.attacker
			self.parent = self:GetParent()
			local cooldown = self:GetAbility():GetSpecialValueFor("cooldown")
EmitSoundOn("Pandora.1", self.parent)
   self:GetAbility():StartCooldown(cooldown)
   self:PlayEffects()
		end
    end
end
end
end

function modifier_vainglory:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vainglory_heal.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end