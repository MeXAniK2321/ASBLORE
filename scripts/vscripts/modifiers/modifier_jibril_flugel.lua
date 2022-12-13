modifier_jibril_flugel = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_jibril_flugel:IsHidden()
	return false
end

function modifier_jibril_flugel:IsDebuff()
	return false
end

function modifier_jibril_flugel:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_jibril_flugel:OnCreated( kv )
	-- references

	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_billy_25")


	if not IsServer() then return end
	-- set creation time
	self.create_time = GameRules:GetGameTime()

	-- dodge projectiles
	ProjectileManager:ProjectileDodge( self:GetParent() )


if IsServer() then
		self:SetStackCount(0)
	end
	
end

function modifier_jibril_flugel:OnRefresh( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_jibril_25")



	if not IsServer() then return end
	-- dodge projectiles
	ProjectileManager:ProjectileDodge( self:GetParent() )
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_jibril_flugel:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROJECTILE_NAME,

		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return funcs
end

function modifier_jibril_flugel:GetModifierBaseAttackTimeConstant()
	return 1.7
end
function modifier_jibril_flugel:GetModifierProjectileName()
if self:GetParent():HasModifier("modifier_jibril_flugel_damage") then
	return "particles/jibril_projectile.vpcf"
	else
	return end
end

function modifier_jibril_flugel:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	if not params.attacker:IsIllusion() then
			local current = self:GetStackCount()
			local caster = self:GetParent()
			if current == 4 then

	-- calculate time
	local time = GameRules:GetGameTime() - self.create_time
	time = math.min( time, 1 )

	-- create modifier
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_jibril_flugel_damage", -- modifier name
		{
			duration = 10,
			record = params.record,
			damage = self.bonus_damage  + self:GetCaster():FindTalentValue("special_bonus_jibril_25"),
			time = time,
			target = params.target:entindex(),
		} -- kv
	)

	-- play sound
	local sound_cast = "jibril.sfx_2"
	EmitSoundOn( sound_cast, self:GetParent() )
	self:SetStackCount(0)

	else
			self:AddStack(1)
	
	end
	end
	
end



function modifier_jibril_flugel:RemoveOnDeath()
	return false
end
function modifier_jibril_flugel:AllowIllusionDuplicate()
 return false 
 end


function modifier_jibril_flugel:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
	if not self:GetParent():HasScepter() then
		if after > 5 then
			after = 4
		end
	else
		if after > 5 then
			after = 4
		end
	end
	self:SetStackCount( after )
end
modifier_jibril_flugel_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_jibril_flugel_damage:IsHidden()
	return true
end

function modifier_jibril_flugel_damage:IsDebuff()
	return false
end

function modifier_jibril_flugel_damage:IsPurgable()
	return false
end

function modifier_jibril_flugel_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_jibril_flugel_damage:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.damage = kv.damage
	self.record = kv.record
	self.time = kv.time
	self.target = EntIndexToHScript( kv.target )

	self.target_pos = self.target:GetOrigin()
	self.target_prev = self.target_pos

	-- create custom projectile
	self:PlayEffects()
end

function modifier_jibril_flugel_damage:OnRefresh( kv )
	
end

function modifier_jibril_flugel_damage:OnRemoved()
end

function modifier_jibril_flugel_damage:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_jibril_flugel_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_PROJECTILE_DODGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, -- this does nothing but tracking target's movement, for projectile dodge purposes
	}

	return funcs
end
function modifier_jibril_flugel_damage:OnAttackLanded( params )
	if not IsServer() then return end
	if params.record~=self.record then return end
	if params.attacker~=self:GetParent() then return end
	if not params.attacker:IsIllusion() then
			local current = self:GetStackCount()
			local caster = self:GetParent()
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_slow", {duration = 0.3 })
			end
			end
function modifier_jibril_flugel_damage:OnAttackRecordDestroy( params )
	if not IsServer() then return end
	if params.record~=self.record then return end

	-- destroy buff if attack finished (proc/miss/whatever)
	self:StopEffects( false )
	self:Destroy()
end
function modifier_jibril_flugel_damage:GetModifierProcAttack_BonusDamage_Magical( params )
	if params.record~=self.record then return end

	-- overhead event
	SendOverheadEventMessage(
		nil, --DOTAPlayer sendToPlayer,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		params.target,
		self.damage,
		self:GetParent():GetPlayerOwner() -- DOTAPlayer sourcePlayer
	)

	-- play effects
	local sound_cast = "Hero_DarkWillow.Shadow_Realm.Damage"
	EmitSoundOn( sound_cast, self:GetParent() )

	return self.damage 
end

function modifier_jibril_flugel_damage:OnProjectileDodge( params )
	if not IsServer() then return end
	if params.target~=self.target then return end

	-- set target CP to last known location
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self.target,
		PATTACH_CUSTOMORIGIN,
		"attach_hitloc",
		self.target_prev, -- unknown
		true -- unknown, true
	)
end
function modifier_jibril_flugel_damage:GetModifierBaseAttack_BonusDamage()
	if not IsServer() then return end

	-- track target's position each frame
	self.target_prev = self.target_pos
	self.target_pos = self.target:GetOrigin()

	-- the property actually does nothing
	return 0
end

--------------------------------------------------------------------------------
-- Graphics and Animations
function modifier_jibril_flugel_damage:PlayEffects()
	-- Get Resources
	

	-- Get data
	local speed = self:GetParent():GetProjectileSpeed()

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self.target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( speed, 0, 0 ) )
	ParticleManager:SetParticleControl( self.effect_cast, 5, Vector( self.time, 0, 0 ) )
end

function modifier_jibril_flugel_damage:StopEffects( dodge )
	-- destroy effects
	ParticleManager:DestroyParticle( self.effect_cast, dodge )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end