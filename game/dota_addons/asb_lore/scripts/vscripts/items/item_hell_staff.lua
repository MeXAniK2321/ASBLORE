item_hell_staff = class({})
LinkLuaModifier("modifier_item_hell_staff", "items/item_hell_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hell_staff_debuff", "items/item_hell_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hell_staff_debuff2", "items/item_hell_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hell_staff_true", "items/item_hell_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hell_staff_invul", "items/item_hell_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hell_staff_judgment", "items/item_hell_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hell_staff_cooldown", "items/item_hell_staff", LUA_MODIFIER_MOTION_NONE)

function item_hell_staff:GetIntrinsicModifierName()
	return "modifier_item_hell_staff"
end
function item_hell_staff:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()


	
	target:AddNewModifier(self:GetCaster(), self, "modifier_item_hell_staff_true", {duration = 8.0})
	if not target:HasModifier("modifier_item_hell_staff_debuff2") then
	target:AddNewModifier(self:GetCaster(), self, "modifier_item_hell_staff_debuff", {duration = 8.0})
end
	caster:EmitSound("hell.staff_cast")
end
modifier_item_hell_staff_cooldown = class({})
function modifier_item_hell_staff_cooldown:IsHidden() return true end
function modifier_item_hell_staff_cooldown:IsDebuff() return false end
function modifier_item_hell_staff_cooldown:IsPurgable() return false end
function modifier_item_hell_staff_cooldown:IsPurgeException() return false end
function modifier_item_hell_staff_cooldown:RemoveOnDeath() return false end
---------------------------------------------------------------------------------------------------------------------
modifier_item_hell_staff = class({})
function modifier_item_hell_staff:IsHidden() return true end
function modifier_item_hell_staff:IsDebuff() return false end
function modifier_item_hell_staff:IsPurgable() return false end
function modifier_item_hell_staff:IsPurgeException() return false end
function modifier_item_hell_staff:RemoveOnDeath() return false end
function modifier_item_hell_staff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hell_staff:DeclareFunctions()
	local func = { 	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_HEALTH_BONUS,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_EVENT_ON_TAKEDAMAGE,	 
        MODIFIER_PROPERTY_MANA_BONUS,}
	return func
end
function modifier_item_hell_staff:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_item_hell_staff:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_item_hell_staff:GetModifierBonusStats_Intellect()
	return self.intellect
end
function modifier_item_hell_staff:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.strength = self.ability:GetSpecialValueFor("bonus_strength")
	self.agility = self.ability:GetSpecialValueFor("bonus_agility")
	self.intellect = self.ability:GetSpecialValueFor("bonus_intellect")

end

function modifier_item_hell_staff:OnTakeDamage(keys)
	if IsServer() then
	local caster = self:GetParent()
		if keys.attacker == caster then
		if not keys.attacker:IsIllusion() then
		if keys.unit == caster then return end
		if not self:GetParent():HasModifier("modifier_item_hell_staff_cooldown") then
			if not keys.unit:HasModifier("modifier_item_hell_staff_debuff") then
		if self:GetParent():IsAlive() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hell_staff_cooldown", {duration = 25.0 })
      keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hell_staff_debuff2", {duration = 5.0 })
	EmitSoundOn("voodoo.sfx", caster)
			end
		end
	end
	end
end
end
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_hell_staff_debuff = class({})
function modifier_item_hell_staff_debuff:IsHidden() return false end
function modifier_item_hell_staff_debuff:IsDebuff() return true end
function modifier_item_hell_staff_debuff:IsPurgable() return false end
function modifier_item_hell_staff_debuff:IsPurgeException() return false end
function modifier_item_hell_staff_debuff:RemoveOnDeath() return true end
 function modifier_item_hell_staff_debuff:DeclareFunctions()
	local func = { 
					MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
					MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					MODIFIER_PROPERTY_DISABLE_HEALING,   
					}
	return func
end
function modifier_item_hell_staff_debuff:GetDisableHealing()
	return 1
end

function modifier_item_hell_staff_debuff:GetModifierIncomingDamage_Percentage( params )
	

		return 13
	end
function modifier_item_hell_staff_debuff:OnIntervalThink()
if self:GetParent():HasModifier("modifier_fountain_aura_effect_lua") then
	self:Destroy()
	end
if self:GetParent():IsMagicImmune() then 
else
local damage = 40
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage( damageTable )
	
end
end

function modifier_item_hell_staff_debuff:OnAbilityFullyCast(params)
	if IsServer() then
	
	self.mana = self:GetParent():GetMaxMana()
	self.damage = self.mana * 0.3
			local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end
		
		if params.ability:IsItem() then return end
	
		
		if pass then
		self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
		local mana_burn =  math.min( self:GetParent():GetMana(), self.damage )
        self:GetParent():ReduceMana( mana_burn )		
		ApplyDamage( self.damageTable )
		self:PlayEffects()
		
		end
	end
	end
	
function modifier_item_hell_staff_debuff:GetEffectName()
	return "particles/hell_staff_debuff_vodoo.vpcf"
end
function modifier_item_hell_staff_debuff:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end
function modifier_item_hell_staff_debuff:OnCreated(table)
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    EmitSoundOnClient("star.theme_7", Player)
	
	self:StartIntervalThink( 0.5 )
	end
end
function modifier_item_hell_staff_debuff:OnDestroy(table)
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    StopSoundOn("star.theme_7", Player)
	end
end
function modifier_item_hell_staff_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vodoo_doll_curse.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	-- ParticleManager:SetParticleControl( effect_cast, 0, vControlVector )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

modifier_item_hell_staff_debuff2 = class({})
function modifier_item_hell_staff_debuff2:IsHidden() return false end
function modifier_item_hell_staff_debuff2:IsDebuff() return true end
function modifier_item_hell_staff_debuff2:IsPurgable() return false end
function modifier_item_hell_staff_debuff2:IsPurgeException() return false end
function modifier_item_hell_staff_debuff2:RemoveOnDeath() return true end
 function modifier_item_hell_staff_debuff2:DeclareFunctions()
	local func = { 
					MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
					MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					MODIFIER_PROPERTY_DISABLE_HEALING,   
					}
	return func
end
function modifier_item_hell_staff_debuff2:GetDisableHealing()
	return 1
end

function modifier_item_hell_staff_debuff2:GetModifierIncomingDamage_Percentage( params )
	

		return 13
	end
function modifier_item_hell_staff_debuff2:OnIntervalThink()
if self:GetParent():HasModifier("modifier_fountain_aura_effect_lua") then
	self:Destroy()
	end
if self:GetParent():IsMagicImmune() then 
else
local damage = 40
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage( damageTable )
	
end
end

function modifier_item_hell_staff_debuff2:OnAbilityFullyCast(params)
	if IsServer() then
	
	self.mana = self:GetParent():GetMaxMana()
	self.damage = self.mana * 0.3
			local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end
		
		if params.ability:IsItem() then return end
	
		
		if pass then
		self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
		local mana_burn =  math.min( self:GetParent():GetMana(), self.damage )
        self:GetParent():ReduceMana( mana_burn )		
		ApplyDamage( self.damageTable )
		self:PlayEffects()
		
		end
	end
	end
	
function modifier_item_hell_staff_debuff2:GetEffectName()
	return "particles/vodoo_doll_curse_target.vpcf"
end
function modifier_item_hell_staff_debuff2:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end
function modifier_item_hell_staff_debuff2:OnCreated(table)
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    EmitSoundOnClient("star.theme_7", Player)
	
	self:StartIntervalThink( 0.5 )
	end
end
function modifier_item_hell_staff_debuff2:OnDestroy(table)
	if IsServer() then
		local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    StopSoundOn("star.theme_7", Player)
	end
end
function modifier_item_hell_staff_debuff2:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vodoo_doll_curse.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	-- ParticleManager:SetParticleControl( effect_cast, 0, vControlVector )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end
modifier_item_hell_staff_true = class({})

--------------------------------------------------------------------------------

function modifier_item_hell_staff_true:IsHidden()
	return false
end

function modifier_item_hell_staff_true:IsDebuff()
	return false
end

function modifier_item_hell_staff_true:IsPurgable()
	return false
end

function modifier_item_hell_staff_true:RemoveOnDeath()
	return false
end
function modifier_item_hell_staff_true:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_item_hell_staff_true:OnCreated( kv )
	-- get references
	

	if IsServer() then

	end
end


--------------------------------------------------------------------------------

function modifier_item_hell_staff_true:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,

	}

	return funcs
end

function modifier_item_hell_staff_true:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
	end
end

function modifier_item_hell_staff_true:KillLogic( params )
      
	local target = params.unit
	local attacker = params.attacker
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and target~=self:GetCaster() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

	-- logic
	if pass and (not self:GetParent():PassivesDisabled()) then
		-- check if it is a hero
		if target:IsRealHero() then
		
		
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_item_hell_staff_judgment", -- modifier name
		{duration = 17} -- kv
	)
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_item_hell_staff_invul", -- modifier name
		{duration = 15.98} -- kv
	)

	end
	end
	end
function modifier_item_hell_staff_true:GetEffectName()
	return "particles/hell_staff_debuff.vpcf"
end
function modifier_item_hell_staff_true:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/hell_staff_text_test.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end

modifier_item_hell_staff_invul = class({})
function modifier_item_hell_staff_invul:IsHidden() return false end
function modifier_item_hell_staff_invul:IsDebuff() return true end
function modifier_item_hell_staff_invul:IsPurgable() return false end
function modifier_item_hell_staff_invul:IsPurgeException() return false end
function modifier_item_hell_staff_invul:RemoveOnDeath() return true end
function modifier_item_hell_staff_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end

modifier_item_hell_staff_judgment = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_hell_staff_judgment:IsHidden()
	return false
end

function modifier_item_hell_staff_judgment:IsDebuff()
	return true
end

function modifier_item_hell_staff_judgment:IsStunDebuff()
	return true
end

function modifier_item_hell_staff_judgment:IsPurgable()
	return false
end



--------------------------------------------------------------------------------
-- Initializations
function modifier_item_hell_staff_judgment:OnCreated( kv )
	-- references


	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( 16 )

	-- play effects
	local sound_cast = "hell.staff"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_item_hell_staff_judgment:OnRefresh( kv )
	
end

function modifier_item_hell_staff_judgment:OnRemoved()
end

function modifier_item_hell_staff_judgment:OnDestroy()
end

function modifier_item_hell_staff_judgment:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_item_hell_staff_judgment:Silence()
	  self:GetParent():Kill(self, self:GetCaster())


	

	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_item_hell_staff_judgment:GetEffectName()
	return "particles/hell_staff_judgment_aura.vpcf"
end

function modifier_item_hell_staff_judgment:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

