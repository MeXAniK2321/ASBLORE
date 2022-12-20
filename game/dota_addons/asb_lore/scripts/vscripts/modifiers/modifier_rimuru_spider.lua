modifier_rimuru_spider = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rimuru_spider:IsHidden()
	return false
end

function modifier_rimuru_spider:IsDebuff()
	return true
end

function modifier_rimuru_spider:IsStunDebuff()
	return false
end

function modifier_rimuru_spider:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rimuru_spider:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) -- special value
	self.interval = 0.5

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- Play Effects
		self.sound_target = "rimuru.spider"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_rimuru_spider:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) -- special value
	self.interval = 0.5

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- Play Effects
		self.sound_target = "rimuru.spider"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_rimuru_spider:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_rimuru_spider:CheckState()
	local state = {

	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_rimuru_spider:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_rimuru_spider:GetEffectName()
	return "particles/rimuru_spider_buff.vpcf"
end

function modifier_rimuru_spider:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end