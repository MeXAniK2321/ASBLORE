holy_chain = class({})
LinkLuaModifier( "modifier_holy_chain", "heroes/holy_chain", LUA_MODIFIER_MOTION_NONE )


function holy_chain:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local buffDuration = self:GetSpecialValueFor("duration")

	-- Add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_holy_chain", -- modifier name
		{ duration = buffDuration } -- kv
	)
	caster:EmitSound("kurapika.2")
	if self:GetCaster():HasModifier("modifier_emperor_time") then
    target:Purge( false, true, false, true, false)
	else
	end
	-- Play Effects

end


modifier_holy_chain = class({})

function modifier_holy_chain:IsPurgable()
    return false
end

function modifier_holy_chain:DeclareFunctions()
    local funcs = {
        
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }

    return funcs
end

function modifier_holy_chain:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("heal")
end

function modifier_holy_chain:GetEffectName()
    return "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_hero_heal.vpcf"
end

function modifier_holy_chain:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_holy_chain:StatusEffectPriority()
    return 5
end