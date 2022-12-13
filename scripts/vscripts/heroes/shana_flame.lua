breathe_fire_datadriven = class({})
LinkLuaModifier("modifier_breathe_fire_datadriven", "heroes/shana_flame.lua", LUA_MODIFIER_MOTION_NONE)
function breathe_fire_datadriven:IsStealable() return true end
function breathe_fire_datadriven:IsHiddenWhenStolen() return false end
function breathe_fire_datadriven:IsLearned() return true end
