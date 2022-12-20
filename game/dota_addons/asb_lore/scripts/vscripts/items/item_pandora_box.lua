item_pandora_box = class({})
function item_pandora_box:IsStealable() return true end
function item_pandora_box:IsHiddenWhenStolen() return false end
function item_pandora_box:OnSpellStart()
	local caster = self:GetCaster()
	if caster:HasScepter() then
	else
	self:SpendCharge()

	
		if caster:GetUnitName()== "npc_dota_hero_naga_siren" then
		local item = CreateItem("item_brs_canon", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_night_stalker" then
		local item = CreateItem("item_witch_gift", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_phantom_lancer" then
		local item = CreateItem("item_mistsplitter", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_beastmaster" then
		local item = CreateItem("item_billy_bike", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_marci" then
		local item = CreateItem("item_naofumi_shield", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_pangolier" then
		local item = CreateItem("item_murchielago", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_dark_willow" then
		local item = CreateItem("item_library_of_elchea", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_bounty_hunter" then
		local item = CreateItem("item_fullmetal_arm", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_faceless_void" then
		local item = CreateItem("item_all_fiction_screw", caster, self)
	    caster:AddItem(item)
			elseif caster:GetUnitName()== "npc_dota_hero_slark" then
		local item = CreateItem("item_earth", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_life_stealer" then
		local item = CreateItem("item_old_plush_toy", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_pudge" then
		local item = CreateItem("item_pukachu", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_mars" then
		local item = CreateItem("item_dante_sword", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_drow_ranger" then
		local item = CreateItem("item_uranus", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_magnataur" then
		local item = CreateItem("item_credit_card", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_abaddon" then
		local item = CreateItem("item_yamato", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_abyssal_underlord" then
		local item = CreateItem("item_rhitta", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_death_prophet" then
		local item = CreateItem("item_box_of_pandora", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_chaos_knight" then
		local item = CreateItem("item_laevatain", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_nyx_assassin" then
		local item = CreateItem("item_nen_contract", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_lycan" then
		local item = CreateItem("item_eye_seal", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_bloodseeker" then
		local item = CreateItem("item_hogyoku", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_kunkka" then
		local item = CreateItem("item_uchiha_naish", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_queenofpain" then
		local item = CreateItem("item_homuras_shield", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_spectre" then
		local item = CreateItem("item_toy_knife", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_terrorblade" then
		local item = CreateItem("item_negi", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_alchemist" then
		local item = CreateItem("item_dragon_ball", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_monkey_king" then
		local item = CreateItem("item_ruyi_jingu_bang", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_techies" then
		local item = CreateItem("item_deidara_c4", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_oracle" then
		local item = CreateItem("item_great_sage", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_lich" then
		local item = CreateItem("item_papyrus", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_winter_wyvern" then
		local item = CreateItem("item_eternal_geass", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_dragon_knight" then
		local item = CreateItem("item_boosted_gear", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_dark_seer" then
		local item = CreateItem("item_x_gloves", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_ember_spirit" then
		local item = CreateItem("item_alastor", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_tusk" then
		local item = CreateItem("item_panaino", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_nevermore" then
		local item = CreateItem("item_rumia_sword", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_legion_commander" then
		local item = CreateItem("item_esdeath_rapier", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_ancient_apparition" then
		local item = CreateItem("item_yoshinon", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_juggernaut" then
		local item = CreateItem("item_intetsu", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_skeleton_king" then
		local item = CreateItem("item_void_sword", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_void_spirit" then
		local item = CreateItem("item_music_sword", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_bristleback" then
		local item = CreateItem("item_accel_pribor", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_axe" then
		local item = CreateItem("item_key_for_9", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_ursa" then
		local item = CreateItem("item_kanade_piano", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_bane" then
		local item = CreateItem("item_yukari_umbrella", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_antimage" then
		local item = CreateItem("item_tanjiro_katana", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_undying" then
		local item = CreateItem("item_index_chan", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_omniknight" then
		local item = CreateItem("item_georgius", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_elder_titan" then
		local item = CreateItem("item_book_of_darkness", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_chen" then
		local item = CreateItem("item_eternal_geass_2", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_riki" then
		local item = CreateItem("item_death_perception", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_arc_warden" then
		local item = CreateItem("item_trident_silver_horn", caster, self)
	    caster:AddItem(item)
		elseif caster:GetUnitName()== "npc_dota_hero_sven" then
		local item = CreateItem("item_sandalphon", caster, self)
	    caster:AddItem(item)
		else
		local item = CreateItem("item_vongolla_primo_ring", caster, self)
	    caster:AddItem(item)
		end
		end
end