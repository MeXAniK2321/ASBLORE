LinkLuaModifier("modifier_zawarudo", "items/item_zawarudo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zawarudo_time_stop", "items/item_zawarudo", LUA_MODIFIER_MOTION_NONE)

local nZawarudoDuration = 8.0

local function GetZawarudoMainModifier()
    local hZawarudoModifier = nil
    for _, hHero in pairs(HeroList:GetAllHeroes()) do 
        if IsNotNull(hHero) and hHero:HasModifier("modifier_zawarudo_time_stop") then
            local hModifier = hHero:FindModifierByName("modifier_zawarudo_time_stop")
			if hModifier and hModifier.caster and hModifier.caster == hHero then
			    hZawarudoModifier = hModifier
			end
        end
    end
    return hZawarudoModifier
end


item_zawarudo = item_zawarudo or class({})


function item_zawarudo:GetIntrinsicModifierName()
    return "modifier_zawarudo"
end
function item_zawarudo:GetBehavior()
    local hCaster = self:GetCaster()
    local iBehavior = self.BaseClass.GetBehavior(self)
    if hCaster:HasModifier("modifier_zawarudo_time_stop") then
        iBehavior = bit.bor(iBehavior, DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE)
    end
    return iBehavior
end
function item_zawarudo:OnSpellStart()
    local hCaster    = self:GetCaster()
	local fDuration  = 3.1 + nZawarudoDuration
	
	local hZawarudoMainModifier = GetZawarudoMainModifier()
	if hZawarudoMainModifier and IsNotNull(hZawarudoMainModifier) then
		if hZawarudoMainModifier:GetRemainingTime() >= nZawarudoDuration + 1.8 then self:EndCooldown() return end
		
		hZawarudoMainModifier:SetDuration(nZawarudoDuration, true)
			
		hCaster.bCanMoveZawarudo = true
		hCaster.bResetZawarudo   = true
		return
	end
	
	hCaster:AddNewModifier(hCaster, self, "modifier_zawarudo_time_stop", {duration = fDuration})
    
	EmitGlobalSound("zawarudo")
end

-------------------------------------------------------------------------------------------------------
modifier_zawarudo_time_stop = modifier_zawarudo_time_stop or class({})

function modifier_zawarudo_time_stop:IsHidden() return false end
function modifier_zawarudo_time_stop:IsDebuff() return self.parent ~= self.caster end
function modifier_zawarudo_time_stop:IsPurgable() return false end
function modifier_zawarudo_time_stop:RemoveOnDeath() return false end
function modifier_zawarudo_time_stop:IsAura() return self.parent == self.caster end
function modifier_zawarudo_time_stop:CheckState()
    local state =   {
                        [MODIFIER_STATE_STUNNED] = true,
						[MODIFIER_STATE_FROZEN]  = self.parent ~= self.caster
                    }
					
    if self.parent.bResetZawarudo then
		self.nRemainingTimeSelf = nZawarudoDuration
		self.parent.bResetZawarudo = false
	end
	
	if self.parent.bCanMoveZawarudo and self.parent ~= self.caster and not self.nAuraPFX then
		self.nAuraPFX =  ParticleManager:CreateParticle("particles/test/custom/zawarudo_aura_jojo.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
						 --ParticleManager:SetParticleControl(self.nAuraPFX, 0, self.parent:GetAbsOrigin())     
		self:AddParticle(self.nAuraPFX, false, false, -1, false, false)
	end
	
	if self.nRemainingTimeSelf and self.nRemainingTimeSelf > 0 and self:GetRemainingTime() <= nZawarudoDuration then
		self.nRemainingTimeSelf = self.nRemainingTimeSelf - 0.1
	end
	
	if self.nRemainingTimeSelf <= 0 and self.parent.bCanMoveZawarudo then
		self.parent.bCanMoveZawarudo = false
	end
	
	--print(self.nRemainingTimeSelf)
	
	if self.parent and self.parent.bCanMoveZawarudo then return {} end

    return (self.parent ~= self.caster or self:GetRemainingTime() > self.fTimeStopMoves or self.nRemainingTimeSelf <= 0) and state or {}
end
function modifier_zawarudo_time_stop:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
						MODIFIER_PROPERTY_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
						MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
                    }
	
	if self.parent and self.parent.bCanMoveZawarudo then return func end				
					
    return (self.parent == self.caster) and func or {}
end
function modifier_zawarudo_time_stop:GetModifierIgnoreMovespeedLimit(keys)
	return 1
end
function modifier_zawarudo_time_stop:GetModifierMoveSpeed_Limit(keys)
	return 2000
end
function modifier_zawarudo_time_stop:GetModifierMoveSpeed_Absolute(keys)
	return 2000
end
function modifier_zawarudo_time_stop:GetModifierPercentageCasttime(keys)
	return 10000
end
function modifier_zawarudo_time_stop:OnCreated(hTable)
	self.parent  = self:GetParent()
	self.caster  = self:GetCaster()
	self.ability = self:GetAbility()
	
	self.fTimeStopBegins = self:GetDuration() - 1.8
	self.fTimeStopMoves  = self:GetDuration() - 3.1
	self.nRadiusGain     = 20000
	
	self.nRemainingTimeSelf = self.nRemainingTimeSelf or nZawarudoDuration

	if IsServer() and self.parent == self.caster then
	    if self.parent:HasModifier("modifier_zawarudo_time_stop") and self.parent ~= self.caster then
		    self.fTimeStopMoves = self:GetDuration()
			return
		end
		
		self.nAuraPFX =  ParticleManager:CreateParticle("particles/test/custom/zawarudo_aura_dio.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
						 --ParticleManager:SetParticleControl(self.nAuraPFX, 0, self.parent:GetAbsOrigin())     
		self:AddParticle(self.nAuraPFX, false, false, -1, false, false)
		
	    --self.fGameTime   = self.fGameTime or GameRules:GetGameTime()
		self.hTimer = Timers:CreateTimer(1.8, function()
			self.iParticle = ParticleManager:CreateParticle("particles/item/zawarudo/zawarudo_main.vpcf", PATTACH_WORLDORIGIN, nil)
							 ParticleManager:SetParticleControl(self.iParticle, 0, self.parent:GetOrigin() )
			self:AddParticle(self.iParticle, false, false, -1, false, false)
		end)
	end
end
function modifier_zawarudo_time_stop:OnRefresh(hTable)
	--self:OnCreated(hTable)
end
function modifier_zawarudo_time_stop:OnDestroy()
	if IsServer() and self.hTimer then Timers:RemoveTimer(self.hTimer) end
	if not self.caster:HasModifier("modifier_zawarudo_time_stop") then
	    self.parent.bCanMoveZawarudo = false
	end
end
function modifier_zawarudo_time_stop:GetModifierAura()
	return "modifier_zawarudo_time_stop"
end
function modifier_zawarudo_time_stop:GetAuraRadius()
	return math.max(0, self.fTimeStopBegins - self:GetRemainingTime() ) * self.nRadiusGain --( GameRules:GetGameTime() - self.fGameTime ) * self.nRadiusGain
end
function modifier_zawarudo_time_stop:GetAuraDuration()
	return 0.03
end
function modifier_zawarudo_time_stop:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end
function modifier_zawarudo_time_stop:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_zawarudo_time_stop:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_zawarudo_time_stop:GetAuraEntityReject(hEntity)
	return hEntity == self.parent --or hEntity.bCanMoveZawarudo
end