slark_shadow_dance_lua = class({})
LinkLuaModifier( "modifier_slark_shadow_dance_lua", "modifiers/modifier_slark_shadow_dance_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_shadow_dance_lua_passive", "modifiers/modifier_slark_shadow_dance_lua_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_doom_scorched_earth_lua", "modifiers/modifier_doom_scorched_earth_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shadow_dance_visual", "heroes/slark_shadow_dance_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function slark_shadow_dance_lua:GetIntrinsicModifierName()
	return "modifier_slark_shadow_dance_lua_passive"
end

--------------------------------------------------------------------------------
-- Custom KV
function slark_shadow_dance_lua:GetCooldown( level )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cooldown_scepter" )
	end

	return self.BaseClass.GetCooldown( self, level )
end

--------------------------------------------------------------------------------
-- Ability Start
function slark_shadow_dance_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetAbsOrigin()

	-- load data
	local bDuration = self:GetSpecialValueFor("duration")

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_slark_shadow_dance_lua", -- modifier name
		{ duration = bDuration } -- kv
	)
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_doom_scorched_earth_lua", -- modifier name
		{ duration = bDuration } -- kv
	)
		self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_shadow_dance_visual", -- modifier name
		{ duration = bDuration }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	self.thinker = self.thinker:FindModifierByName("modifier_shadow_dance_visual")

	-- Play effects
	EmitSoundOn("rumia_1", caster)
	EmitSoundOn( "nevermore_nev_attack_02", caster )
	
end


modifier_shadow_dance_visual = class({})

function modifier_shadow_dance_visual:IsPurgable()
    return false
end

function modifier_shadow_dance_visual:OnCreated( kv )
    self:StartIntervalThink(0.01)
    if not IsServer() then return end
   
   
   
    
end

function modifier_shadow_dance_visual:OnIntervalThink()
    if not IsServer() then return end
    local target = self:GetCaster()
    local target_pos = target:GetAbsOrigin ()
    local caster = self:GetAbility ():GetCaster ()
    self:GetParent():SetAbsOrigin (target:GetAbsOrigin ())
   
end
function modifier_shadow_dance_visual:OnDestroy( kv )
 local target = self:GetCaster()
    local target_pos = target:GetAbsOrigin ()
    local caster = self:GetAbility ():GetCaster ()
    
    
end
function modifier_shadow_dance_visual:GetEffectName()
	return "particles/slark_shadow_dance1.vpcf"
end

function modifier_shadow_dance_visual:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end