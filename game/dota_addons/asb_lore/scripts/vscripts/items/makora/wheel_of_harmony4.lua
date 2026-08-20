require("items/makora/wheel_of_harmony_shared")

item_wheel_of_harmony4 = class({})

function item_wheel_of_harmony4:GetIntrinsicModifierName()
    return WheelOfHarmonyShared.GetIntrinsicModifierName(self)
end

function item_wheel_of_harmony4:OnSpellStart()
    WheelOfHarmonyShared.OnSpellStart(self)
end

function item_wheel_of_harmony4:OnChargeCountChanged(_chargeCount, ...)
end
