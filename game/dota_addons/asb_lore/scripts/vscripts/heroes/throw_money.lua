throw_money = class({})
LinkLuaModifier( "modifier_throw_money", "modifiers/modifier_throw_money", LUA_MODIFIER_MOTION_NONE )

function throw_money:CastFilterResultTarget(target)
local caster = self:GetCaster()
local gold = self:GetSpecialValueFor("gold") + self:GetCaster():FindTalentValue("special_bonus_daisuke_20")
   local gold1 = caster:GetGold()
   if gold > gold1  then
        return UF_FAIL_CUSTOM
    end
     if target:IsMagicImmune() then
        return UF_FAIL_ENEMY
    end
end 
function throw_money:GetCustomCastErrorTarget(target)
local caster = self:GetCaster()
   local gold = self:GetSpecialValueFor("gold") + self:GetCaster():FindTalentValue("special_bonus_daisuke_20")
   local gold1 = caster:GetGold()
   if gold > gold1  then
        return "#dota_hud_error_not_enough_gold"
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function throw_money:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local gold = self:GetSpecialValueFor("gold_self") - self:GetCaster():FindTalentValue("special_bonus_daisuke_20")
	PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )


	-- get projectile_data
	local projectile_name = "particles/money_toss.vpcf"
	local projectile_speed = self:GetSpecialValueFor("dagger_speed")
	local projectile_vision = 450

	-- Create Projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,				-- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	self:PlayEffects1()
end

function throw_money:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end
if target == caster then return end
	self:Hit( target, true )
	
	

	

	self:PlayEffects2( hTarget )
end
function throw_money:Hit( target, dragonform )
	local caster = self:GetCaster()
	  local gold = caster:GetGold()
	  if gold > 6000 then
	  self.money_duration = 2
	  else
	   self.money_duration = gold * 0.0003
	  end

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_daisuke_20")

	-- damage
	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
	target:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_throw_money",
		{duration = 0.1}
	)
	
	else
	target:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_throw_money",
		{duration = self.money_duration}
	)
	end
	
	

	
end

--------------------------------------------------------------------------------
function throw_money:PlayEffects1()
	-- Get Resources
	local sound_cast = "daisuke_1"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function throw_money:PlayEffects2( target )
	-- Get Resources
	local sound_target = "daisuke_2"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end