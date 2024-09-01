local tPandoraItems = {
                          npc_dota_hero_naga_siren = "item_brs_canon",            -- Black Rock Shooter
                          npc_dota_hero_night_stalker = "item_witch_gift",        -- Natsuki Subaru
                          npc_dota_hero_phantom_lancer = "item_mistsplitter",     -- Raiden Shogun
                          npc_dota_hero_beastmaster = "item_billy_bike",          -- Billy Herrington
                          npc_dota_hero_marci = "item_naofumi_shield",            -- Naofumi
                          npc_dota_hero_pangolier = "item_murchielago",           -- Ulquiorra
                          npc_dota_hero_dark_willow = "item_library_of_elchea",   -- Jibril
                          npc_dota_hero_bounty_hunter = "item_fullmetal_arm",     -- Edward Elric
                          npc_dota_hero_faceless_void = "item_all_fiction_screw", -- Kumagawa
                          npc_dota_hero_slark = "item_earth",                     -- Arcueid
                          npc_dota_hero_life_stealer = "item_old_plush_toy",      -- Kagaya Shuichi
                          npc_dota_hero_pudge = "item_pukachu",                   -- Pikachu
                          npc_dota_hero_mars = "item_dante_sword",                -- Dante
                          npc_dota_hero_drow_ranger = "item_uranus",              -- Ikaros
                          npc_dota_hero_magnataur = "item_credit_card",           -- Kambe Daisuke  
                          npc_dota_hero_abaddon = "item_yamato",                  -- Vergil
                          npc_dota_hero_abyssal_underlord = "item_rhitta",        -- Escanor
                          npc_dota_hero_death_prophet = "item_box_of_pandora",    -- Pandora
                          npc_dota_hero_chaos_knight = "item_laevatain",          -- Flandre Scarlet
                          npc_dota_hero_nyx_assassin = "item_nen_contract",       -- Kurapika
                          npc_dota_hero_lycan = "item_eye_seal",                  -- Jellal Fernandes
                          npc_dota_hero_bloodseeker = "item_hogyoku",             -- Aizen
                          npc_dota_hero_kunkka = "item_uchiha_naish",             -- Madara
                          npc_dota_hero_queenofpain = "item_homuras_shield",      -- Madoka
                          npc_dota_hero_spectre = "item_toy_knife",               -- Frisk
                          npc_dota_hero_terrorblade = "item_negi",                -- Hatsune Miku
                          npc_dota_hero_alchemist = "item_dragon_ball",           -- Son Goku
                          npc_dota_hero_monkey_king = "item_ruyi_jingu_bang",     -- Jin Mori
                          npc_dota_hero_techies = "item_deidara_c4",              -- Deidara
                          npc_dota_hero_oracle = "item_great_sage",               -- Rimuru Tempest
                          npc_dota_hero_lich = "item_papyrus",                    -- Sans
                          npc_dota_hero_winter_wyvern = "item_eternal_geass",     -- LeLouch
                          npc_dota_hero_dragon_knight = "item_boosted_gear",      -- Hyodou Issei
                          npc_dota_hero_dark_seer = "item_x_gloves",              -- Tsuna
                          npc_dota_hero_ember_spirit = "item_alastor",            -- Shana
                          npc_dota_hero_tusk = "item_panaino",                    -- Shinobu Oshino
                          npc_dota_hero_nevermore = "item_rumia_sword",           -- Rumia
                          npc_dota_hero_legion_commander = "item_esdeath_rapier", -- Esdeath
                          npc_dota_hero_ancient_apparition = "item_yoshinon",     -- Yoshino
                          npc_dota_hero_juggernaut = "item_intetsu",              -- Kurogane Ikki
                          npc_dota_hero_skeleton_king = "item_void_sword",        -- Oma Shu
                          npc_dota_hero_void_spirit = "item_music_sword",         -- Kagamine Rin
                          npc_dota_hero_bristleback = "item_accel_pribor",        -- Accelerator
                          npc_dota_hero_axe = "item_key_for_9",                   -- Bogdan
                          npc_dota_hero_ursa = "item_kanade_piano",               -- Tachibana Kanade
                          npc_dota_hero_bane = "item_yukari_umbrella",            -- Yukari Yakumo
                          npc_dota_hero_antimage = "item_tanjiro_katana",         -- Tanjiro
                          npc_dota_hero_undying = "item_index_chan",              -- Kamijou Touma
                          npc_dota_hero_omniknight = "item_georgius",             -- Keyaru
                          npc_dota_hero_elder_titan = "item_book_of_darkness",    -- Reinforce
                          npc_dota_hero_chen = "item_eternal_geass_2",            -- LeLouch
                          npc_dota_hero_riki = "item_death_perception",           -- Ryougi Shiki
                          npc_dota_hero_arc_warden = "item_trident_silver_horn",  -- Shiba Tatsuya
                          npc_dota_hero_sven = "item_sandalphon",                 -- Yatogami Tohka
                          npc_dota_hero_razor = "item_shinigami",                 -- Ichigo Kurosaki
                          npc_dota_hero_brewmaster = "item_nanaya_knife",         -- Nanaya Shiki
                          npc_dota_hero_skywrath_mage = "item_drift_mania",       -- AE86
                          npc_dota_hero_dawnbreaker = "item_national_contract",   -- Makima
                          npc_dota_hero_tiny = "item_myoujingiri",                -- Muramasa
                          npc_dota_hero_earthshaker = "item_fusion_dance",        -- Gogeta(SSJB)
                          npc_dota_hero_dazzle = "item_gojo_six_eyes",            -- Gojo Satoru
                      }

item_pandora_box = item_pandora_box or class({})
function item_pandora_box:IsStealable() return true end
function item_pandora_box:IsHiddenWhenStolen() return false end
function item_pandora_box:OnSpellStart()
	local caster = self:GetCaster()
    local hPlaceholder = caster:FindItemInInventory("item_placeholder_padoru")
    local bCheck = false
    if caster:HasScepter() and caster:GetUnitName() == "npc_dota_hero_abaddon" and not caster:HasItemInInventory("item_yamato") then
        bCheck = true
    end
	
    if caster:HasScepter() and not bCheck then
    else
        local item = nil

		if tPandoraItems[caster:GetUnitName()] then
            item = CreateItem(tPandoraItems[caster:GetUnitName()], caster, self)
        else
            item = CreateItem("item_vongolla_primo_ring", caster, self)
        end
        
        if IsNotNull(item) then
            if IsNotNull(hPlaceholder) then
                caster:RemoveItem(hPlaceholder)
            end
            --================--
            Timers:CreateTimer(0.1, function()
                caster:AddItem(item)
            end)
            --================--
            self:SpendCharge(0)
            --================--
        else
            print("No item was found for this hero !")
        end
    end
end