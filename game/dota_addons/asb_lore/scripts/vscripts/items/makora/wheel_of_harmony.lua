require("items/makora/wheel_of_harmony_shared")

item_wheel_of_harmony = class({})

function item_wheel_of_harmony:GetIntrinsicModifierName()
    return WheelOfHarmonyShared.GetIntrinsicModifierName(self)
end

function item_wheel_of_harmony:OnSpellStart()
    WheelOfHarmonyShared.OnSpellStart(self)
end

function item_wheel_of_harmony:OnChargeCountChanged(_chargeCount, ...)
end
