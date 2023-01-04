skelejoke = class({})
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skelejoke", "modifiers/modifier_skelejoke", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jokk", "heroes/skelejoke.lua", LUA_MODIFIER_MOTION_NONE )

function skelejoke:GetIntrinsicModifierName()
    return "modifier_jokk"
end
function skelejoke:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("sans_global_shortcut")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function skelejoke:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	self.target = target
	local caster_vector = caster:GetForwardVector()
EmitSoundOn( "Joke.Cast", self:GetCaster() )
	-- load data
	local duration = self:GetSpecialValueFor( "debuff_duration" )
	if target:TriggerSpellAbsorb( self ) then return end

	-- add debuff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = duration } -- kv
	)
	target:SetForwardVector(caster_vector * -1)

	-- play effects
	self:PlayEffects( target )
	self:PlayEffects( caster )
end

--------------------------------------------------------------------------------
function skelejoke:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/test_joke.vpcf"
	 if not IsServer() then return end
    if not target:IsIllusion() then
        local Player = PlayerResource:GetPlayer(target:GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end
function skelejoke:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/test_joke_end.vpcf"
	 if not IsServer() then return end
    if not target:IsIllusion() then
        local Player = PlayerResource:GetPlayer(target:GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end
function skelejoke:OnChannelFinish( bInterrupted )
local broke = GameRules:GetGameTime() - self:GetChannelStartTime()
self.target:RemoveModifierByName( "modifier_stunned" )
self.broke = 1.4
if broke > self.broke then
local caster = self:GetCaster()
local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_sans_25")
local damageTable = {
		victim = self.target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	EmitSoundOn( "Joke.End", self:GetCaster() )
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_5)
 self.target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 0.2})
	self.target:AddNewModifier(self:GetCaster(), self, "modifier_generic_silenced_lua", {duration = 2})
	self:PlayEffects2(self.target)
	self:PlayEffects2(caster)
	end
end
modifier_jokk = class ({})
function modifier_jokk:IsHidden() return true end
function modifier_jokk:IsDebuff() return false end
function modifier_jokk:IsPurgable() return false end
function modifier_jokk:IsPurgeException() return false end
function modifier_jokk:RemoveOnDeath() return false end

function modifier_jokk:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_jokk:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_jokk:OnIntervalThink()
    if IsServer() then
        local skeleton = self:GetParent():FindAbilityByName("sans_slap")
        if skeleton and not skeleton:IsNull() then
            if self:GetParent():HasScepter() then
                if skeleton:IsHidden() then
                    skeleton:SetHidden(false)
                end
            else
                if not skeleton:IsHidden() then
                    skeleton:SetHidden(true)
                end
            end
        end
    end
end