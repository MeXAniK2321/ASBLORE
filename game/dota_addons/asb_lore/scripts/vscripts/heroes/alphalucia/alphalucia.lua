
local tLuciaWaveAnimations = { ACT_DOTA_CAST1_STATUE, ACT_DOTA_CAST2_STATUE, ACT_DOTA_CAST3_STATUE }

---------------------------------------------------------------------------------------------------------------
-- Alpha Lucia Sword Wave(Q)
---------------------------------------------------------------------------------------------------------------

alpha_lucia_sword_wave = alpha_lucia_sword_wave or class({})

function alpha_lucia_sword_wave:Spawn()
    if IsServer() then
		local hCaster    = self:GetCaster()
		-- Dota 2 engine is not setting BodyGroups correctly from model doc editor... GABEN ???
		AlphaLuciaBodyGroups(hCaster, 1, 0, 1, 0.01)
	end
end
function alpha_lucia_sword_wave:GetCastAnimation()
    self.nAnim = math.max( 1, (self.nAnim and self.nAnim + 1 or 1) % 4 )
    return tLuciaWaveAnimations[self.nAnim] 
end
function alpha_lucia_sword_wave:OnSpellStart()
    local hCaster    = self:GetCaster()
                           
    self:CreateSwordWave(hCaster:HasModifier("modifier_alpha_lucia_sword"))			   
end
function alpha_lucia_sword_wave:CreateSwordWave(bSword)
    local hCaster      = self:GetCaster()
    local vCursorLoc   = self:GetCursorPosition()
	local vDirection   = GetDirection(vCursorLoc, hCaster)
    local fRadius      = 300
	-- Rotation is handled in the particle engine based on even and odd numbers 
	-- (Example: 1 = 45deg, 2 = -45deg, 3 = 45deg, 4 = -45deg etc...)
	local fSpeed       = 2000--3500
    self.fSpeed        = (self.fSpeed == fSpeed) and fSpeed + 1 or fSpeed
    local fDistance    = 2000
	
	--hCaster:StartGestureWithPlaybackRate(nRandom, 1)
	
    self.iTARGET_TEAM  = self:GetAbilityTargetTeam()
    self.iTARGET_TYPE  = self:GetAbilityTargetType()
    self.iTARGET_FLAGS = self:GetAbilityTargetFlags()
    
	--local nSwipeFX = ParticleManager:CreateParticle("particles/heroes/anime_hero_alphalucia/sword_slashes_basic/sword_slash_basic_test.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
                     --ParticleManager:ReleaseParticleIndex(nSwipeFX)
					 
	--if true then return end
	
	--EmitGlobalSound("zawarudo")
	
	local hSwordWave =  {   
                            Ability             = self,
                            EffectName          = "particles/heroes/anime_hero_alphalucia/alphalucia_sword_wave_main.vpcf",
                            vSpawnOrigin        = hCaster:GetOrigin() + vDirection * -300,
                            fDistance           = fDistance,
                            fStartRadius        = fRadius,
                            fEndRadius          = fRadius,
                            Source              = hCaster,
                            bHasFrontalCone     = false,
                            bReplaceExisting    = false,
                            iUnitTargetTeam     = self.iTARGET_TEAM,
                            iUnitTargetFlags    = self.iTARGET_FLAGS,
                            iUnitTargetType     = self.iTARGET_TYPE,
                            --fExpireTime         = GameRules:GetGameTime() + 30,
                            --bDeleteOnHit        = false,
                            vVelocity           = vDirection * self.fSpeed,
                            bProvidesVision     = true,
                            iVisionRadius     	= fRadius,
                            iVisionTeamNumber 	= hCaster:GetTeamNumber(),
                            --ExtraData 			= { fProjDmg = f__ProjDmg }
                        }
    
    return ProjectileManager:CreateLinearProjectile(hSwordWave)
end
function alpha_lucia_sword_wave:OnProjectileHit(hTarget, vLocation)
    if IsNotNull(self)
	    and IsNotNull(hTarget) then
		local hCaster = self:GetCaster()
		
		hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {duration = 1.0})
		ApplyDamage({
			victim = hTarget,
			attacker = hCaster,
			damage = 500,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self,
			damage_flags = 0
		})
	end
end
function alpha_lucia_sword_wave:OnProjectileThink(vLocation)
    if IsNotNull(self) then
        GridNav:DestroyTreesAroundPoint(vLocation, 300, false)
	end
end

---------------------------------------------------------------------------------------------------------------
-- Alpha Lucia Area Slash (W)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_alpha_lucia_area_slash", "heroes/alphalucia/alphalucia.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

alpha_lucia_area_slash = alpha_lucia_area_slash or class({})

function alpha_lucia_area_slash:OnSpellStart()
    local hCaster    = self:GetCaster()
                           
    hCaster:AddNewModifier(hCaster, self, "modifier_alpha_lucia_area_slash", { duration = 4.0 })
end
---------------------------------------------------------------------------------------------------------------

modifier_alpha_lucia_area_slash = modifier_alpha_lucia_area_slash or class({})

function modifier_alpha_lucia_area_slash:IsHidden() return false end
function modifier_alpha_lucia_area_slash:IsDebuff() return false end
function modifier_alpha_lucia_area_slash:IsPurgable() return false end
function modifier_alpha_lucia_area_slash:IsPurgeException() return false end
function modifier_alpha_lucia_area_slash:RemoveOnDeath() return true end
function modifier_alpha_lucia_area_slash:GetPriority() return MODIFIER_PRIORITY_ULTRA end
--function modifier_alpha_lucia_area_slash:IsMarbleException() return true end
function modifier_alpha_lucia_area_slash:CheckState()
    local state =   {
                        [MODIFIER_STATE_STUNNED] = true
                    }

    return state
end
function modifier_alpha_lucia_area_slash:DeclareFunctions()
    local func =    {
	
                    }
    return func
end
function modifier_alpha_lucia_area_slash:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.nDashDist    = 1400
	self.nDashCount   = 4
	self.fDashDelay   = 0.25
	self.fDashInterv  = 0.11
	self.nDashesCur   = self.nDashesCur or self.nDashCount
	self.bDashStarted = self.bDashStarted or false
	if IsServer() and IsNotNull(self.parent) then
	    self.vCurPos    = self.parent:GetOrigin()
        self.vTargetPos = self.parent:GetCursorPosition() or (self.vCurPos + self.parent:GetForwardVector())
		self.vDirection = GetDirection(self.vTargetPos, self.vCurPos)
		self.vFinalPos  = self.vCurPos + self.vDirection * self.nDashDist
		
		self:StartIntervalThink(self.fDashDelay)
    end
end
function modifier_alpha_lucia_area_slash:OnIntervalThink()
    if not self.bDashStarted then
        self:StartIntervalThink(-1)
		self:StartIntervalThink(self.fDashInterv)
		self.bDashStarted = true
		self:OnIntervalThink()
		return
    end
	
	self:LuciaDash(self.nDashesCur)
	self.nDashesCur = self.nDashesCur - 1
end
function modifier_alpha_lucia_area_slash:LuciaDash(nDashes)
    if nDashes <= 0 then
	    self:Destroy()
	    return 
	end
	
	if nDashes < self.nDashCount then
	    local nDashDist = (nDashes % 2 == 0) and self.nDashDist or self.nDashDist * 0.5
	    local nDegrees  = (nDashes > 1) and -60 or 60
	    self.vCurPos    = self.parent:GetOrigin()
		self.vDirection = RotateVector2D(GetDirection(self.vTargetPos, self.vCurPos), nDegrees, true)
		self.vFinalPos  = self.vCurPos + self.vDirection * nDashDist
		self.vTargetPos = self.vFinalPos + GetDirection(self.vCurPos, self.vFinalPos)
	end
	
	local nDashFX = ParticleManager:CreateParticle("particles/econ/items/void_spirit/void_spirit_immortal_2021/void_spirit_immortal_2021_astral_step.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleControl(nDashFX, 0, self.vCurPos)
					ParticleManager:SetParticleControl(nDashFX, 1, self.vFinalPos)
					ParticleManager:ReleaseParticleIndex(nDashFX)
					
	self.parent:SetOrigin(GetGroundPosition(self.vFinalPos, self.parent))

	local hEnemies = FindUnitsInLine(self.parent:GetTeamNumber(),
									self.vCurPos,
									self.vFinalPos,
									nil,
									250,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_ALL,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
									)

	for _, hEnemy in pairs(hEnemies) do
		if IsNotNull(hEnemy) then
			hEnemy:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = 1.0})
			ApplyDamage({
				victim = hEnemy,
				attacker = self.parent,
				damage = 3300,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self.ability,
				damage_flags = 0
			})
		end
	end								
end

---------------------------------------------------------------------------------------------------------------
-- Alpha Lucia Sword (E)
---------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_alpha_lucia_sword", "heroes/alphalucia/alphalucia.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

alpha_lucia_sword = alpha_lucia_sword or class({})

function alpha_lucia_sword:OnSpellStart()
    local hCaster    = self:GetCaster()
                           
    hCaster:AddNewModifier(hCaster, self, "modifier_alpha_lucia_sword", { duration = 40.0 })
end
---------------------------------------------------------------------------------------------------------------

modifier_alpha_lucia_sword = modifier_alpha_lucia_sword or class({})

function modifier_alpha_lucia_sword:IsHidden() return false end
function modifier_alpha_lucia_sword:IsDebuff() return false end
function modifier_alpha_lucia_sword:IsPurgable() return false end
function modifier_alpha_lucia_sword:IsPurgeException() return false end
function modifier_alpha_lucia_sword:RemoveOnDeath() return true end
function modifier_alpha_lucia_sword:CheckState()
    self.state = self.state or   
	                {
                        [MODIFIER_STATE_STUNNED] = true,
                        [MODIFIER_STATE_INVULNERABLE] = true,
                        [MODIFIER_STATE_NO_HEALTH_BAR] = true
                    }

    return self.state
end
function modifier_alpha_lucia_sword:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
                    }
    return func
end
function modifier_alpha_lucia_sword:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

	if IsServer() and IsNotNull(self.parent) then
	    self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
		self.iParticle = ParticleManager:CreateParticle("particles/heroes/anime_hero_alphalucia/alphalucia_ground_test.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		AlphaLuciaBodyGroups(self.parent, 1, 1, 0)
		self:StartIntervalThink(2.5)
    end
end
function modifier_alpha_lucia_sword:OnIntervalThink()
	self.state = {}
	-- Set the modified animations by removing standard idle
	self.parent:RemoveGesture(ACT_DOTA_IDLE)
	if self.iParticle then
	    ParticleManager:DestroyParticle(self.iParticle, true)
	    ParticleManager:ReleaseParticleIndex(self.iParticle)
		self.iParticle = nil
	end
	return self:StartIntervalThink(-1)
end
function modifier_alpha_lucia_sword:GetActivityTranslationModifiers()
    return "alpha_lucia_sword"
end
function modifier_alpha_lucia_sword:OnDestroy()
    if IsServer() then
		AlphaLuciaBodyGroups(self.parent, 1, 0, 1)
	end
end

---------------------------------------------------------------------------------------------------------------
-- Alpha Lucia Stinger (D)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_alpha_lucia_stinger", "heroes/alphalucia/alphalucia.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

alpha_lucia_stinger = alpha_lucia_stinger or class({})

function alpha_lucia_stinger:OnSpellStart()
    local hCaster    = self:GetCaster()
                           
    hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	EmitSoundOn("alpha_lucia.stingermain", hCaster)
	hCaster:AddNewModifier(hCaster, self, "modifier_alpha_lucia_stinger", { duration = 4.0 })
end
---------------------------------------------------------------------------------------------------------------

modifier_alpha_lucia_stinger = modifier_alpha_lucia_stinger or class({})

function modifier_alpha_lucia_stinger:IsHidden() return false end
function modifier_alpha_lucia_stinger:IsDebuff() return false end
function modifier_alpha_lucia_stinger:IsPurgable() return false end
function modifier_alpha_lucia_stinger:IsPurgeException() return false end
function modifier_alpha_lucia_stinger:RemoveOnDeath() return true end
function modifier_alpha_lucia_stinger:GetPriority() return MODIFIER_PRIORITY_ULTRA end
--function modifier_alpha_lucia_stinger:IsMarbleException() return true end
function modifier_alpha_lucia_stinger:CheckState()
    local state =   {
                        [MODIFIER_STATE_STUNNED] = true
                    }

    return state
end
function modifier_alpha_lucia_stinger:DeclareFunctions()
    local func =    {
	
                    }
    return func
end
function modifier_alpha_lucia_stinger:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
	
	if IsServer() and IsNotNull(self.parent) then
		-- DASH WITHOUT SWORD
		self.nDashDist    = 1400
		self.nDashWidth   = 350
		self.nSlashCount  = 5 + 1 -- One Extra for Alpha Lucia's first Dash
		self.fDashDelay   = 1.0
		self.fSlashInterv = 0.25
		self.nSlashesCur  = nSlashesCur or self.nSlashCount
		self.bDashStarted = self.bDashStarted or false
		
		-- DASH WITH SWORD
		--===================================================================--
		self.bSword     = self.parent:HasModifier("modifier_alpha_lucia_sword")
		--===================================================================--

		if self.bSword then
			self.nDashDist     = 1400
			self.nDashWidth    = 350
			self.nExtraDashes  = 10 + 1 -- Two extra + main
			self.nDegrees      = 15 -- Degrees to rotate the extra dashes
			self.fDashDelay    = 1.0
			self.fSlashInterv  = 0.03
			self.nSlashRadius  = 290
			self.nSlashPerLine = math.floor(self.nDashDist / self.nSlashRadius)
			self.nSlashLimit   = self.nSlashPerLine + (self.nSlashPerLine * self.nExtraDashes)
			self.fTimeBefore   = self.nSlashPerLine * self.fSlashInterv -- Time before starting the extra dashes
			self.nSlashing     = self.nSlashing or self.nSlashLimit
			self.bDashStarted  = self.bDashStarted or false
			
			self.vRightVector  = self.parent:GetRightVector()
			
			self.fTimeStarted     = GameRules:GetGameTime() + self.fDashDelay
			self.nCurrentProgress = self.nCurrentProgress or 1
			
			self.iParticle = ParticleManager:CreateParticle("particles/heroes/anime_hero_alphalucia/alphalucia_rainbow_model_main.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			self:AddParticle(self.iParticle, false, false, -1, false, false)
		end
	    
		self.vCurPos    = self.parent:GetOrigin()
        self.vTargetPos = self.parent:GetCursorPosition() or (self.vCurPos + self.parent:GetForwardVector())
		self.vDirection = GetDirection(self.vTargetPos, self.vCurPos)
		self.vFinalPos  = self.vCurPos + self.vDirection * self.nDashDist
		self.vBaseDir   = self.vDirection
		
		self:StartIntervalThink(self.fDashDelay)
    end
end
function modifier_alpha_lucia_stinger:OnIntervalThink()
    if not self.bDashStarted then
        self:StartIntervalThink(-1)
		self:StartIntervalThink(self.fSlashInterv)
		self.bDashStarted = true
		self:OnIntervalThink()
		return
    end
	
	if not self.bSword then
		self:LuciaSlash(self.nSlashesCur)
		self.nSlashesCur  = self.nSlashesCur  - 1
	else
	    self:LuciaRampage(self.nSlashing)
		self.nSlashing = self.nSlashing - 1	
	end
end
function modifier_alpha_lucia_stinger:LuciaSlash(nSlashes)
    if nSlashes <= 0 then
	    self:Destroy()
	    return 
	end
	
	if nSlashes < self.nSlashCount then
	    local nSlashDist = self.nDashDist * 0.5
	    local nDegrees   = (nSlashes % 2 == 0) and 60 or -60
		self.vDirection  = RotateVector2D(self.vBaseDir, nDegrees, true)
		-- Do this so the slashes intersect the main line -\-/-\-/-\ instead of _\_/_\_/_\
		self.vCurPos     = (nSlashes == self.nSlashCount - 1) and (self.vCurPos - self.vDirection * (nSlashDist * 0.5)) or self.vCurPos
		self.vFinalPos   = self.vCurPos + self.vDirection * nSlashDist
		
		local nSlashFX   = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf", PATTACH_WORLDORIGIN, nil)
						   ParticleManager:SetParticleControl(nSlashFX, 0, self.vCurPos)
						   ParticleManager:SetParticleControl(nSlashFX, 1, self.vFinalPos)
						   ParticleManager:ReleaseParticleIndex(nSlashFX)
						 
		self.vCurPos     = self.vFinalPos
	else
		local nDashFX = ParticleManager:CreateParticle("particles/econ/items/void_spirit/void_spirit_immortal_2021/void_spirit_immortal_2021_astral_step.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleControl(nDashFX, 0, self.vCurPos)
						ParticleManager:SetParticleControl(nDashFX, 1, self.vFinalPos)
						ParticleManager:ReleaseParticleIndex(nDashFX)
						
		self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
		self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
		self.parent:SetOrigin(GetGroundPosition(self.vFinalPos, self.parent))
	end

	local hEnemies = FindUnitsInLine(self.parent:GetTeamNumber(),
									self.vCurPos,
									self.vFinalPos,
									nil,
									self.nDashWidth,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_ALL,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
									)

	for _, hEnemy in pairs(hEnemies) do
		if IsNotNull(hEnemy) then
			hEnemy:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = 1.0})
			ApplyDamage({
				victim = hEnemy,
				attacker = self.parent,
				damage = 500,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self.ability,
				damage_flags = 0
			})
		end
	end								
end
-- Not the pattern
--[[function modifier_alpha_lucia_stinger:LuciaRampage(nSlashes)
     if nSlashes <= 0 then
	    self:Destroy()
	    return 
	end
	
	if nSlashes < self.nSlashLimit - 1 then
		local nCurrent    = ( nSlashes < ( self.nSlashLimit - 1 ) - self.nSlashPerLine  ) and self.nExtraDashes or 1
	    for i = 1, nCurrent do
		    local nDegrees    = (i > 1) and ( i % 2 == 0 and self.nDegrees or self.nDegrees * (-1) ) or 0
		    local vDirection  = RotateVector2D(self.vDirection, nDegrees, true)
		    local vCurrentPos = self.vCurPos + (vDirection * self.nSlashRadius) * self.nCurrentProgress
							 
		    local nRadius   = RandomInt(75, 225)
			local nRotation = RandomInt(0, 1) == 0 and 540 or -540
			local nRoll     = RandomInt(15, 25)
		    local nSlashFX = ParticleManager:CreateParticle("particles/heroes/anime_hero_alphalucia/alphalucia_swipe_test.vpcf", PATTACH_WORLDORIGIN, nil)
			                 ParticleManager:SetParticleControl(nSlashFX, 0, vCurrentPos)
						     ParticleManager:SetParticleControl( nSlashFX, 2, Vector(nRadius, 0, 0) )
							 ParticleManager:SetParticleControl( nSlashFX, 3, Vector(nRotation, nRoll, 0) )
						     ParticleManager:ReleaseParticleIndex(nSlashFX)
							 
			self.nSlashing = i > 1 and (self.nSlashing - 1) or self.nSlashing
			
			--print("SLASHING")
			--print(self.nSlashPerLine)
			--print(self.nSlashLimit)
		end
		
		self.nCurrentProgress = math.max(1, (self.nCurrentProgress + 1) % (self.nSlashPerLine + 1) )
	else
		local nDashFX = ParticleManager:CreateParticle("particles/econ/items/void_spirit/void_spirit_immortal_2021/void_spirit_immortal_2021_astral_step.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleControl(nDashFX, 0, self.vCurPos)
						ParticleManager:SetParticleControl(nDashFX, 1, self.vFinalPos)
						ParticleManager:ReleaseParticleIndex(nDashFX)
						
		self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
		self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
		self.parent:SetOrigin(GetGroundPosition(self.vFinalPos, self.parent))
	end						
end]]--
function modifier_alpha_lucia_stinger:LuciaRampage(nSlashes)
     if nSlashes <= 0 then
	    self:Destroy()
	    return 
	end
	
	if nSlashes < self.nSlashLimit - 1 then
		local nCurrent    = ( nSlashes < ( self.nSlashLimit - 1 ) - self.nSlashPerLine  ) and self.nExtraDashes or 1
		    local nDegrees     = (nCurrent  > 1) and ( nCurrent  % 2 == 0 and self.nDegrees or self.nDegrees * (-1) ) or 0
		    local vDirection   = RotateVector2D(self.vDirection, 0, true)
			local vRightVector = (nCurrent  > 1) and ( nCurrent  % 2 == 0 and self.vRightVector or self.vRightVector * (-1) ) or 0
		    local vCurrentPos  = (nCurrent  <= 1) 
			                     and self.vCurPos + (vDirection * self.nSlashRadius) * self.nCurrentProgress
								 or self.vCurPos + RandomVector(self.nSlashRadius) + (vDirection * self.nSlashRadius) * self.nCurrentProgress
							 
		    local nRadius   = (nCurrent  > 1) and RandomInt(75, self.nSlashRadius * 1.1) or self.nSlashRadius * 0.5
			local nDirect   = RandomInt(0, 1) == 0 and 1 or -1
			local nRotation = 1200 * nDirect
			local nRoll     = (nCurrent  > 1) and RandomInt(1, 25) * (nDirect * -1) or 5 * (nDirect * -1)
			local sSlashFX = RandomInt(0, 1) == 0
			                 and "particles/heroes/anime_hero_alphalucia/alphalucia_swipe_test.vpcf"
							 or "particles/heroes/anime_hero_alphalucia/alphalucia_swipe_test_rainbow.vpcf"
		    local nSlashFX = ParticleManager:CreateParticle(sSlashFX, PATTACH_WORLDORIGIN, nil)
			                 ParticleManager:SetParticleControl(nSlashFX, 0, vCurrentPos)
						     ParticleManager:SetParticleControl( nSlashFX, 2, Vector(nRadius, 0, 0) )
							 ParticleManager:SetParticleControl( nSlashFX, 3, Vector(nRotation, nRoll, RandomInt(-200, 200)) )
						     ParticleManager:ReleaseParticleIndex(nSlashFX)
							 
			--print("SLASHING")
			--print(self.nSlashPerLine)
			--print(self.nSlashLimit)
		
		self.nCurrentProgress = math.max(1, (self.nCurrentProgress + 1) % (self.nSlashPerLine + 1) )
	else
		local nDashFX = ParticleManager:CreateParticle("particles/econ/items/void_spirit/void_spirit_immortal_2021/void_spirit_immortal_2021_astral_step.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleControl(nDashFX, 0, self.vCurPos)
						ParticleManager:SetParticleControl(nDashFX, 1, self.vFinalPos)
						ParticleManager:ReleaseParticleIndex(nDashFX)
						
		self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
		self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
		self.parent:SetOrigin(GetGroundPosition(self.vFinalPos, self.parent))
	end						
end

---------------------------------------------------------------------------------------------------------------
-- Alpha Lucia Bike (F)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_alpha_lucia_bike_nodrift", "heroes/alphalucia/alphalucia.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

alpha_lucia_bike = alpha_lucia_bike or class({})

function alpha_lucia_bike:OnSpellStart()
    local hCaster    = self:GetCaster()

	hCaster:StartGesture(ACT_DOTA_CAST_DRAGONBREATH)
	hCaster:AddNewModifier(hCaster, self, "modifier_alpha_lucia_bike_nodrift", { duration = 10.0 })
end
---------------------------------------------------------------------------------------------------------------

modifier_alpha_lucia_bike_nodrift = modifier_alpha_lucia_bike_nodrift or class({})

function modifier_alpha_lucia_bike_nodrift:IsHidden() return false end
function modifier_alpha_lucia_bike_nodrift:IsDebuff() return false end
function modifier_alpha_lucia_bike_nodrift:IsPurgable() return false end
function modifier_alpha_lucia_bike_nodrift:IsPurgeException() return false end
function modifier_alpha_lucia_bike_nodrift:RemoveOnDeath() return true end
function modifier_alpha_lucia_bike_nodrift:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_alpha_lucia_bike_nodrift:GetPriority() return MODIFIER_PRIORITY_ULTRA end
--function modifier_alpha_lucia_bike_nodrift:IsMarbleException() return true end
function modifier_alpha_lucia_bike_nodrift:CheckState()
    local state =   {
						[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true, 
						[MODIFIER_STATE_NO_UNIT_COLLISION]           = true
                    }

    return state
end
function modifier_alpha_lucia_bike_nodrift:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_DISABLE_TURNING,
                        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
                        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
                        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
                        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
						--MODIFIER_PROPERTY_MODEL_CHANGE,

                        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
						MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
						MODIFIER_EVENT_ON_ORDER,
                    }
    return func
end
function modifier_alpha_lucia_bike_nodrift:GetModifierDisableTurning(keys)
    if IsNotNull(self.ability) then
        return 1
    end
end
function modifier_alpha_lucia_bike_nodrift:GetModifierIgnoreCastAngle(keys)
    if IsNotNull(self.ability) then
        return 1
    end
end
function modifier_alpha_lucia_bike_nodrift:GetModifierIgnoreMovespeedLimit(keys)
    if IsNotNull(self.ability) then
        return 1
    end
end
function modifier_alpha_lucia_bike_nodrift:GetModifierMoveSpeed_Limit(keys)
    if IsNotNull(self.ability) then
        return self.iMoveSpeed
    end
end
function modifier_alpha_lucia_bike_nodrift:GetModifierMoveSpeed_Absolute(keys)
    if IsClient()
        and IsNotNull(self.ability) then
        return math.abs(self:GetStackCount())
    end
end
function modifier_alpha_lucia_bike_nodrift:GetModifierTotalDamageOutgoing_Percentage(keys)
    if IsNotNull(self.ability) then
        return 125
    end
end
function modifier_alpha_lucia_bike_nodrift:GetOverrideAnimation(keys)
    if IsNotNull(self.ability) then
        return ACT_DOTA_RUN 
    end
end
--[[function modifier_alpha_lucia_bike_nodrift:GetModifierModelChange()
    if IsNotNull(self.ability) then
        return "models/heroes/alphalucia/alphaluciaae86.vmdl"
    end
end]]--
function modifier_alpha_lucia_bike_nodrift:GetActivityTranslationModifiers()
    return "alpha_lucia_bike"
end
function modifier_alpha_lucia_bike_nodrift:GetDisableAutoAttack(keys)
    if IsNotNull(self.ability) then
        return 1
    end
end
function modifier_alpha_lucia_bike_nodrift:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
	
	self.fAutoLength = 200
	self.fAutoWidth  = 125
	self.PauseTime   = self.PauseTime or 1

	self.iMoveSpeed        = 1650
	self.iMoveSpeedBumped  = 25
	self.nBaseDegTurnRate  = 120
	self.iCurrentMS        = self.iCurrentMS or (self.iMoveSpeed * 0.25)
	self.fTargetTurnAngle  = self.fTargetTurnAngle or 0
	self.fTurnedAmount     = self.fTurnedAmount or 0
	self.nTurnDirection    = self.nTurnDirection or 0
	
	self.hKnockBackTable = {
								should_stun        = 1,
								knockback_duration = 1,
								duration           = 1,
								knockback_distance = 25,
								knockback_height   = self.fAutoWidth,
								center_x           = nil,
								center_y           = nil,
								center_z           = nil 
							}
	
	if IsServer() and IsNotNull(self.parent) then
	    AlphaLuciaBodyGroups(self.parent, 0, 0, 0)
		self.parent:RemoveGesture(ACT_DOTA_IDLE)
		
		self.ABILITY_TARGET_TEAM  = self.ability:GetAbilityTargetTeam() 
		self.ABILITY_TARGET_TYPE  = self.ability:GetAbilityTargetType() 
		self.ABILITY_TARGET_FLAGS = self.ability:GetAbilityTargetFlags()
		
		self.hDriftedTartgets     = self.hDriftedTartgets or {}
		
		if self:ApplyHorizontalMotionController() == false then
		end
    end
end
function modifier_alpha_lucia_bike_nodrift:OnHorizontalMotionInterrupted()
    if IsServer() then
    end
end
function modifier_alpha_lucia_bike_nodrift:UpdateHorizontalMotion(me, dt)
    if IsServer() then
	
	    --====================================--
		self.PauseTime = self.PauseTime > 0 and self.PauseTime - dt or 0
		if self.PauseTime > 0 then return end
		--====================================--
		if not self.DriftingFX then
			local vColor =   Vector(255, 255, 255)

			self.DriftingFX =   ParticleManager:CreateParticle("particles/heroes/anime_hero_ae86/ae86_drift.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
								ParticleManager:SetParticleControl(self.DriftingFX, 0, self.parent:GetAbsOrigin())
								ParticleManager:SetParticleControl(self.DriftingFX, 10, self.parent:GetForwardVector())
								ParticleManager:SetParticleControl(self.DriftingFX, 60, vColor)
								ParticleManager:SetParticleControl(self.DriftingFX, 61, vColor)
								ParticleManager:SetParticleControl(self.DriftingFX, 62, vColor)
			self:AddParticle(self.DriftingFX, false, false, -1, false, false)
		end
		--====================================--         
		local iCurrentMS       = self.iCurrentMS
		
		self.parent:SetModifierStackCount("modifier_alpha_lucia_bike_nodrift", self.parent, iCurrentMS)

		local nMultiplier      = math.abs(self.fTargetTurnAngle) < self.nBaseDegTurnRate and 1 or 2
		
		local iTurn_LR_Degrees = ( self.fTurnedAmount < math.abs(self.fTargetTurnAngle) ) and (self.nBaseDegTurnRate * nMultiplier * self.nTurnDirection) or 0

		self.fTurnedAmount = ( self.fTurnedAmount < math.abs(self.fTargetTurnAngle) ) and (self.fTurnedAmount + math.abs(iTurn_LR_Degrees) * dt) or math.abs(self.fTargetTurnAngle)
								
		self.iCurrentMS      = self.iCurrentMS < self.iMoveSpeed and (self.iCurrentMS + self.iMoveSpeed * 0.45 * dt) or self.iMoveSpeed

		local vCurrentLoc    = me:GetOrigin()

		local vCurrentFowVec = me:GetForwardVector()
			  vCurrentFowVec = RotateVector2D(vCurrentFowVec, iTurn_LR_Degrees * dt, true)
			  vCurrentLoc    = vCurrentLoc + vCurrentFowVec * iCurrentMS * dt
			  
		
		local hEnemies = FindUnitsInLine(
											self.parent:GetTeamNumber(),
											vCurrentLoc + vCurrentFowVec * self.fAutoLength * 0.5,
											vCurrentLoc + vCurrentFowVec * self.fAutoLength * -0.5,
											nil,
											self.fAutoWidth,
											self.ABILITY_TARGET_TEAM, 
											self.ABILITY_TARGET_TYPE,
											self.ABILITY_TARGET_FLAGS)
		
		local fCurGameTime = GameRules:GetGameTime()
		for _, hEnemy in pairs(hEnemies) do
			if IsNotNull(hEnemy) then
			    local iEnemyIndex = hEnemy:entindex()
				if ( self.hDriftedTartgets[iEnemyIndex] or 0 ) > fCurGameTime or type(iEnemyIndex) ~= "number" then 
				    goto Next 
				end
				
				self.hKnockBackTable.center_x = vCurrentLoc.x
				self.hKnockBackTable.center_y = vCurrentLoc.y
				self.hKnockBackTable.center_z = vCurrentLoc.z
				hEnemy:RemoveModifierByName("modifier_knockback")
				hEnemy:AddNewModifier(self.parent, self.ability, "modifier_knockback", self.hKnockBackTable, hEnemy:IsOpposingTeam(self.parent:GetTeamNumber()))

				for i = 1, 5 do
					self.parent:AnimePerformAttack( hEnemy,                     --hTarget
													true,                       --bProcessProcs
													true,                       --bSkipCooldown
													true,                       --bBreakInvis
													false,                      --bUseProjectile
													false,                      --bFakeAttack
													false,                      --bNeverMiss
													{
														__sProjectileName = nil,
														__sAttackSound    = nil,

														__fOverrideDamage = nil,
														__fPostCritDamage = nil,
														__fCritDamage     = nil,

														__fPhysicalDamage = nil,
														__fMagicalDamage  = nil,
														__fPureDamage     = nil,
														__fFeedbackDamage = nil,

														__bSupressCleave  = nil,
														__bCleaveRange    = nil
													})
				end

				self.hDriftedTartgets[iEnemyIndex] = fCurGameTime + 1.0
				self.ImpactFX = ParticleManager:CreateParticle("particles/heroes/anime_hero_ae86/arcana/alphalucia_drift_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hEnemy)
								ParticleManager:ReleaseParticleIndex(self.ImpactFX)
				EmitSoundOn("AE86.Theme.Arcana.DriftHit", hEnemy)
                
				::Next::
			end
		end

			vCurrentLoc = GetGroundPosition(vCurrentLoc, me)

		local vTraverseLoc = GetGroundPosition(vCurrentLoc + vCurrentFowVec * self.fAutoLength * 0.5, me)

			vCurrentFowVec = GetDirection(vTraverseLoc, vCurrentLoc, true)

		--08.03.2023 Fixes because gabe did longer time for autoreupdate motion modifier.... nice cringe...
		local nDist    = math.abs(GetDistance(vCurrentLoc, vTraverseLoc, true) - GetDistance(vCurrentLoc, vTraverseLoc))
		--GridNav:FindPathLength(vCurrentLoc, vTraverseLoc) > -1 and 
		--print(nDist, GridNav:FindPathLength(vCurrentLoc, vTraverseLoc))
		local bCanPath = ( ( GridNav:IsTraversable(vTraverseLoc) and not GridNav:IsBlocked(vTraverseLoc) and nDist < 35 ) or me:HasFlyMovementCapability() )
		--print(GridNav:FindPathLength(vCurrentLoc, vTraverseLoc), GetDistance(vCurrentLoc, vTraverseLoc), GetDistance(vCurrentLoc, vTraverseLoc, true))
		--TODO: Make High speed fix
		me:SetForwardVector(vCurrentFowVec, true)

		if bCanPath then
			
			GridNav:DestroyTreesAroundPoint( vTraverseLoc, self.fAutoWidth, true )
			GridNav:DestroyTreesAroundPoint( vCurrentLoc, self.fAutoWidth, true )

			--me:SetOrigin(vCurrentLoc)
			--FindClearSpaceForUnit(me, vCurrentLoc, true)
			me:SetAbsOrigin(vCurrentLoc)
		else
		--     me:SetForwardVector(vCurrentFowVec, true)
		--     --me:SetOrigin(vCurrentLoc)
		--     --me:SetAbsOrigin(vCurrentLoc)
			--FindClearSpaceForUnit(me, vCurrentLoc, true)
			me:SetForwardVector(-vCurrentFowVec, true)
			self.fTargetTurnAngle  = 0
			self.iCurrentMS        = self.iMoveSpeedBumped
			self.nTurnDirection    = 0
			self.fTurnedAmount     = 0
		end
    end
end
function modifier_alpha_lucia_bike_nodrift:OnOrder(keys)
	if IsServer() and keys.unit == self.parent then
		local order_type  = keys.order_type

		if order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION
			or order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET
			or order_type == DOTA_UNIT_ORDER_ATTACK_MOVE
			or order_type == DOTA_UNIT_ORDER_ATTACK_TARGET 
			or order_type == DOTA_UNIT_ORDER_PICKUP_ITEM 
			or order_type == DOTA_UNIT_ORDER_PICKUP_RUNE then
			
			local vNewPos = keys.target or self.parent.newest_pos or self.parent:GetCursorPosition()--keys.target or keys.new_pos or self.parent:GetCursorPosition()
			if not vNewPos then return end

			local vCurrentFowVec = self.parent:GetForwardVector()
			local vNewDirection  = GetDirection(vNewPos, self.parent:GetOrigin())

			local nDegrees = math.deg(math.atan2(vNewDirection.y, vNewDirection.x) - math.atan2(vCurrentFowVec.y, vCurrentFowVec.x))

			if nDegrees > 180 then nDegrees = nDegrees - 360 end
			if nDegrees < -180 then nDegrees = nDegrees + 360 end

			self.fTargetTurnAngle  = nDegrees
			self.nTurnDirection    = nDegrees > 0 and 1 or -1
			self.fTurnedAmount     = 0
		end
	end
end
function modifier_alpha_lucia_bike_nodrift:OnDestroy()
	if IsServer() then
	    --AlphaLuciaBodyGroups(self.parent, 1, 0, 1)
		self.parent:StartGesture(ACT_DOTA_CAST_EMP)
	end
end


---------------------------------------------------------------------------------------------------------------
-- Alpha Lucia Bike (R)
---------------------------------------------------------------------------------------------------------------
--LinkLuaModifier("modifier_alpha_lucia_bike_nodrift", "heroes/alphalucia/alphalucia.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

alpha_lucia_slash_test = alpha_lucia_slash_test or class({})

function alpha_lucia_slash_test:OnSpellStart()
    local hCaster    = self:GetCaster()

	local nSwipeFX = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_start_golden.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
                     ParticleManager:ReleaseParticleIndex(nSwipeFX)
end

---------------------------------------------------------------------------------------------------------------
-- HELPER FUNCTIONS -------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- EYE'S FUNCTION for fixing SetBodyGroupByName, modified by me directly on CBaseModelEntity.SetBodyGroupByName
if IsServer() then
	CBaseModelEntity.SetBodyGroupByName = function(self, sName, nChoice)
		if IsNotNull(self) and type(self.SetBodygroupByName) == "function" then
			self.___tBodyGroupData = self.___tBodyGroupData or {}
			self.___tBodyGroupData[sName] = nChoice or nil

			return self:SetBodygroupByName(sName, nChoice)
		end
	end
	
	AlphaLuciaBodyGroups = function(hCaster, nBike, nSwordSheathOnly, nSwordMain, fWaitLonger)
	    fWaitLonger = fWaitLonger or 0
		
		-- Wait a bit or it will not set it on spawn
		Timers:CreateTimer(fWaitLonger, function()
		    if not hCaster then return end
			
			nBike = nBike or 1
			nSwordSheathOnly = nSwordSheathOnly or 0
			nSwordMain = nSwordMain or 1
			
			hCaster:SetBodyGroupByName("bike", nBike)
			hCaster:SetBodyGroupByName("swordsheathonly", nSwordSheathOnly)
			hCaster:SetBodyGroupByName("swordmain", nSwordMain)
			
			print("Alpha Lucia Bodygroups: ".. "Bike " .. nBike .. " | SwordSheath " .. nSwordSheathOnly .. " | SwordMain " .. nSwordMain)
		end)
	end
end