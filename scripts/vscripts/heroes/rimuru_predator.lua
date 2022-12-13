rimuru_predator = class({})
LinkLuaModifier( "modifier_rimuru_predator", "heroes/rimuru_predator.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "rimuru_predator_target", "heroes/rimuru_predator.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silence_item", "heroes/rimuru_predator.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muted", "modifiers/modifier_muted", LUA_MODIFIER_MOTION_NONE )
function rimuru_predator:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_flare_circle")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function rimuru_predator:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor( "duration" )
	if target:TriggerSpellAbsorb( self ) then return end
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_muted", -- modifier name
		{ duration = 4 } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"rimuru_predator_target", -- modifier name
		{ duration = duration } -- kv
	)
	
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_rimuru_predator", { duration = duration } )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_silence_item", { duration = duration } )
    self:EmitSound("rimuru.predator")
end
modifier_rimuru_predator = class({})

function modifier_rimuru_predator:IsHidden()
    return false
end

function modifier_rimuru_predator:IsPurgable()
    return false
end
function modifier_rimuru_predator:OnCreated(hTable)
    if IsServer() then
        local ability = self:GetParent():FindAbilityByName("rimuru_slime_awake")
        if ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
end
function modifier_rimuru_predator:OnDestroy()
    if IsServer() then
        local ability = self:GetParent():FindAbilityByName("rimuru_slime_awake")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
end
function modifier_rimuru_predator:DeclareFunctions()
	local func = {	
					
					MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
					 
					}
	return func
end


function modifier_rimuru_predator:GetModifierMoveSpeed_AbsoluteMin()
	 return 300
end
rimuru_predator_target = class({})

function rimuru_predator_target:IsPurgable()
    return false
end

function rimuru_predator_target:OnCreated( kv )
    self:StartIntervalThink(0.03)
    if not IsServer() then return end
    self.model_scale = self:GetParent():GetModelScale()
    self:StartIntervalThink(0.1)
    self:GetParent():AddNoDraw()
    self.particle = ParticleManager:CreateParticleForPlayer("", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
    self:AddParticle( self.particle, false, false, -1, false, true )        
    self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
     Timers:CreateTimer(self.duration,function()
        ParticleManager:DestroyParticle (self.particle, false)
        return nil
    end)
end

function rimuru_predator_target:OnIntervalThink()
    if not IsServer() then return end
    local target = self:GetParent ()
    local target_pos = target:GetAbsOrigin ()
    local caster = self:GetAbility ():GetCaster ()
    target:SetAbsOrigin (self:GetCaster ():GetAbsOrigin ())
    if not caster:IsAlive() then
        target:RemoveModifierByName ("rimuru_predator_target")
    end
end

function rimuru_predator_target:OnDestroy( kv )
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
if not IsServer() then return end
local point = self:GetCaster():GetAbsOrigin()

FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin(), true)
    local chance = math.random(100)
    local npcName = self:GetParent():GetUnitName()
    
    self:GetParent():RemoveNoDraw()
    
    local distance = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
    local direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
    local bump_point = self:GetCaster():GetAbsOrigin() - direction * distance
    local knockbackProperties =
    {
        center_x = bump_point.x,
        center_y = bump_point.y,
        center_z = bump_point.z,
        duration = 0.5,
        knockback_duration = 0.5,
        knockback_distance = 400,
        knockback_height = 350
    }
    self:GetParent():RemoveModifierByName("modifier_knockback")
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", knockbackProperties)
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_stunned_lua", { duration = 2.5 })
        local caster = self:GetCaster()
        ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(),ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
    
end

function rimuru_predator_target:CheckState()
    local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_NIGHTMARED] = true,
        [MODIFIER_STATE_HEXED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }

    return state
end
function rimuru_predator_target:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
       
        
		
    }

    return funcs
end

function rimuru_predator_target:GetBonusNightVision()
    return -9999999
end
function rimuru_predator_target:GetBonusDayVision()

    return -999999

end
modifier_silence_item = class({})

function modifier_silence_item:CheckState() 
  local state =
      {
   [MODIFIER_STATE_MUTED] = true
      }
  return state
end

function modifier_silence_item:IsPurgable()
    return false
end

function modifier_silence_item:IsHidden()
    return true
end