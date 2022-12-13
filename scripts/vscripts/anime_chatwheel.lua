

if not CustomChatWheel then
	_G.CustomChatWheel = {}
end

local chat = LoadKeyValues("scripts/npc/anime_chatwheel.txt")
local LOADED = false

-----------------------------------------------------------------------------------------------------------------------------------------------------------
local votimer = {}
local SelectVO = function(keys)
    

	print(keys.num)
	local heroes = {
	    
	    "anime_custom1",
	    "anime_custom2",
	    "anime_custom3",
	    "anime_custom4",
	    "anime_custom5",
	    "anime_custom6",
	    "anime_custom7",
	    "anime_custom8",
	    --//8
	    "anime_custom9",
	    "anime_custom10",
	    "anime_custom11",
	    "anime_custom12",
	    "anime_custom13",
	    "anime_custom14",
	    "anime_custom15",
	    "anime_custom16",
	    --//16
	    "anime_custom17",
	    "anime_custom18",
	    "anime_custom19",
	    "anime_custom20",
	    "anime_custom21",
	    "anime_custom22",
	    "anime_custom23",
	    "anime_custom24",
	    "anime_custom25",
	    "anime_custom26",
	    "anime_custom27",
	    "anime_custom28",
	    "anime_custom29",
	    "anime_custom30",
	    "anime_custom31"
	 
	
	}
	local selectedid = 1
	local selectedid2 = nil
	local selectedstr = nil
	local startheronums = 110
	if keys.num >= startheronums then
		local locnum = keys.num - startheronums
		local mesarrs = {
			"_1",
			"_2",
			"_3",
			"_4",
			"_5",
			"_6",
			"_7",
			"_8"
		}
		selectedstr = heroes[math.floor(locnum/8)+1]..mesarrs[math.fmod(locnum,8)+1]
		print(math.floor(locnum/8))
		print(selectedstr)
		selectedid = math.floor(locnum/8)+2
		selectedid2 = math.fmod(locnum,8)+1
	else
		if keys.num < (startheronums-8) then
			local mesarrs = {
				"non_sorted_1_1",--             "Astolfo: Bye bye"
				"non_sorted_1_2",--             "Astolfo: cry"
				"non_sorted_1_3",--             "Astolfo: La Black Luna"
				"non_sorted_1_4",--             "Astolfo: Mikoon♪"
				"non_sorted_1_5",--             "Astolfo: Sorry♪"
				"non_sorted_1_6",--             "Astolfo: Take that"
				"non_sorted_1_7",--             "Fooooock you"
				"non_sorted_1_8",--             "Dio:*Angry Noises*"

				"non_sorted_2_1",--             "Archer: UBW1"
				"non_sorted_2_2",--             "Archer: UBW2"
				"non_sorted_2_3",--             "Archer: UBW3"
				"non_sorted_2_4",--             "Archer: UBW4"
				"non_sorted_2_5",--             "Archer: UBW5"
				"non_sorted_2_6",--             "Archer: UBW6"
				"non_sorted_2_7",--             "Archer: UBW7"
				"non_sorted_2_8",--             "Servant Archer. I answer to your summon."

				"non_sorted_3_1",--             "Archer: This is the end"
				"non_sorted_3_2",--             "Gawain: NININININ"
				"non_sorted_3_3",--             "Iskandar: Mmm"
				"non_sorted_3_4",--             "Kirei: Excellent"
				"non_sorted_3_5",--             "Kirei: You Are Boring"
				"non_sorted_3_6",--             "Medea: Rulu Breaker"
				"non_sorted_3_7",--             "Tamamo: Mikoon♪"
				"non_sorted_3_8",--             "Tamamo: Mikon♪"

				"non_sorted_4_1",--             "Nero: Padoru Padoru"
				"non_sorted_4_2",--             "Lloyd: Congratulations"
				"non_sorted_4_3",--             "*Bokko Sound*"
				"non_sorted_4_4",--             "SpeeeedwaGONnnn"
				"non_sorted_4_5",--             "Esidisi: cry1"
				"non_sorted_4_6",--             "Esidisi: cry2"
				"non_sorted_4_7",--             "Timestops"
				"non_sorted_4_8",--             "Muda ora muda ora"

				"non_sorted_5_1",--             "Joseph: Happy! Fun! Nice to meet you, man!"
				"non_sorted_5_2",--             "Joseph: hohohohohooo"
				"non_sorted_5_3",--             "sonochinosadame"
				"non_sorted_5_4",--             "JOOOOOOOOOOJO"
				"non_sorted_5_5",--             "Ayaya"
				"non_sorted_5_6",--             "Stand Proud"
				"non_sorted_5_7",--             "BREAKDOWN BREAKDOWN"
				"non_sorted_5_8",--             "Fighting Gold"

				"non_sorted_6_1",--             "Dio: Goodbye JOJO 1"
				"non_sorted_6_2",--             "Dio: Goodbye JOJO 2"
				"non_sorted_6_3",--             "Dio: Hah"
				"non_sorted_6_4",--             "Dio: Hm"
				"non_sorted_6_5",--             "Dio: Hoo"
				"non_sorted_6_6",--             "Dio: Interesting"
				"non_sorted_6_7",--             "Dio: I reject humanity"
				"non_sorted_6_8",--             "Dio: I will smash you flat"

				"non_sorted_7_1",--             "Dio: JOJO"
				"non_sorted_7_2",--             "Kono Dio Da"
				"non_sorted_7_3",--             "Dio: Kuah"
				"non_sorted_7_4",--             "Dio: Mudamudamudamuda"
				"non_sorted_7_5",--             "Dio: Mudamudamudamudamudamudamuda MUDA"
				"non_sorted_7_6",--             "Dio: NiceFight, Jojo"
				"non_sorted_7_7",--             "Dio: Nine seconds have pasted"
				"non_sorted_7_8",--             "Dio: Oke oke"

				"non_sorted_8_1",--             "Dio: RODAROLLADA"
				"non_sorted_8_2",--             "Dio: Rooowryyyaaa"
				"non_sorted_8_3",--             "Dio: Saaaaaaaa JOJO"
				"non_sorted_8_4",--             "Dio: WRYYYYYYY"
				"non_sorted_8_5",--             "Dio: WRYYYYYYY♪"
				"non_sorted_8_6",--             "Dio: WRYYYYA"
				"non_sorted_8_7",--             "Dio: Wryyyyyyyyy"
				"non_sorted_8_8",--             "Dio: WWWWWWWWWRYYY"

				"non_sorted_9_1",--             "Hakuryuu: Baka, baka, omae wa minna baka! (Stupid, stupid, we're all stupid!)"
				"non_sorted_9_2",--             "Bucciarati: Arrivederci (Goodbye)"
				"non_sorted_9_3",--             "Giorno: (Piano)"
				"non_sorted_9_4",--             "Scar: Jugenmujugen"
				"non_sorted_9_5",--            	"Light: Keikaku Doori (According to plan)"
				"non_sorted_9_6",--             "Nani? (What?)"
				"non_sorted_9_7",--             "Kenshiro: Omae wa mou shindeiru (You're already dead)"
				"non_sorted_9_8", --             "Erwin: Shinzou sasageyo! (Devote your hearts!)"
				
				
				
			}
			selectedstr = mesarrs[keys.num]
			print(selectedstr)
			selectedid2 = keys.num
		else
			local locnum = keys.num - (startheronums-8)
			local nowheroname = string.sub(PlayerResource:GetSelectedHeroEntity(keys.PlayerID):GetName(), 15)
			local mesarrs = {
				"_1",
				"_2",
				"_3",
				"_4",
				"_5",
				"_6",
				"_7",
				"_8"
			}
			local herolocid = 2
			for i=1, #heroes do
				if nowheroname == heroes[i] then
					break
				end
				herolocid = herolocid + 1
			end
			selectedstr = nowheroname..mesarrs[locnum+1]
			selectedid = herolocid
			print(selectedid)
			selectedid2 = locnum+1
		end
	end
	if selectedstr ~= nil and selectedid2 ~= nil then
		local heroesvo = 
		{
			{
				"anime_chatwheel_non_sorted_1_1",             --"Astolfo: Bye bye"
				"anime_chatwheel_non_sorted_1_2",             --"Astolfo: cry"
				"anime_chatwheel_non_sorted_1_3",             --"Astolfo: La Black Luna"
				"anime_chatwheel_non_sorted_1_4",             --"Astolfo: Mikoon♪"
				"anime_chatwheel_non_sorted_1_5",             --"Astolfo: Sorry♪"
				"anime_chatwheel_non_sorted_1_6",             --"Astolfo: Take that"
				"anime_chatwheel_non_sorted_1_7",             --"Fooooock you"
				"anime_chatwheel_non_sorted_1_8",             --"Dio:*Angry Noises*"

				"anime_chatwheel_non_sorted_2_1",             --"Archer: UBW1"
				"anime_chatwheel_non_sorted_2_2",             --"Archer: UBW2"
				"anime_chatwheel_non_sorted_2_3",             --"Archer: UBW3"
				"anime_chatwheel_non_sorted_2_4",             --"Archer: UBW4"
				"anime_chatwheel_non_sorted_2_5",             --"Archer: UBW5"
				"anime_chatwheel_non_sorted_2_6",             --"Archer: UBW6"
				"anime_chatwheel_non_sorted_2_7",             --"Archer: UBW7"
				"anime_chatwheel_non_sorted_2_8",             --"Servant Archer. I answer to your summon."

				"anime_chatwheel_non_sorted_3_1",             --"Archer: This is the end"
				"anime_chatwheel_non_sorted_3_2",             --"Gawain: NININININ"
				"anime_chatwheel_non_sorted_3_3",             --"Iskandar: Mmm"
				"anime_chatwheel_non_sorted_3_4",             --"Kirei: Excellent"
				"anime_chatwheel_non_sorted_3_5",             --"Kirei: You Are Boring"
				"anime_chatwheel_non_sorted_3_6",             --"Medea: Rulu Breaker"
				"anime_chatwheel_non_sorted_3_7",             --"Tamamo: Mikoon♪"
				"anime_chatwheel_non_sorted_3_8",             --"Tamamo: Mikon♪"

				"anime_chatwheel_non_sorted_4_1",             --"Nero: Padoru Padoru"
				"anime_chatwheel_non_sorted_4_2",             --"Lloyd: Congratulations"
				"anime_chatwheel_non_sorted_4_3",             --"*Bokko Sound*"
				"anime_chatwheel_non_sorted_4_4",             --"SpeeeedwaGONnnn"
				"anime_chatwheel_non_sorted_4_5",             --"Esidisi: cry1"
				"anime_chatwheel_non_sorted_4_6",             --"Esidisi: cry2"
				"anime_chatwheel_non_sorted_4_7",             --"Timestops"
				"anime_chatwheel_non_sorted_4_8",             --"Muda ora muda ora"

				"anime_chatwheel_non_sorted_5_1",             --"Joseph: Happy! Fun! Nice to meet you, man!"
				"anime_chatwheel_non_sorted_5_2",             --"Joseph: hohohohohooo"
				"anime_chatwheel_non_sorted_5_3",             --"sonochinosadame"
				"anime_chatwheel_non_sorted_5_4",             --"JOOOOOOOOOOJO"
				"anime_chatwheel_non_sorted_5_5",             --"Ayaya"
				"anime_chatwheel_non_sorted_5_6",             --"Stand Proud"
				"anime_chatwheel_non_sorted_5_7",             --"BREAKDOWN BREAKDOWN"
				"anime_chatwheel_non_sorted_5_8",             --"Fighting Gold"

				"anime_chatwheel_non_sorted_6_1",             --"Dio: Goodbye JOJO 1"
				"anime_chatwheel_non_sorted_6_2",             --"Dio: Goodbye JOJO 2"
				"anime_chatwheel_non_sorted_6_3",             --"Dio: Hah"
				"anime_chatwheel_non_sorted_6_4",             --"Dio: Hm"
				"anime_chatwheel_non_sorted_6_5",             --"Dio: Hoo"
				"anime_chatwheel_non_sorted_6_6",             --"Dio: Interesting"
				"anime_chatwheel_non_sorted_6_7",             --"Dio: I reject humanity"
				"anime_chatwheel_non_sorted_6_8",             --"Dio: I will smash you flat"

				"anime_chatwheel_non_sorted_7_1",             --"Dio: JOJO"
				"anime_chatwheel_non_sorted_7_2",             --"Kono Dio Da"
				"anime_chatwheel_non_sorted_7_3",             --"Dio: Kuah"
				"anime_chatwheel_non_sorted_7_4",             --"Dio: Mudamudamudamuda"
				"anime_chatwheel_non_sorted_7_5",             --"Dio: Mudamudamudamudamudamudamuda MUDA"
				"anime_chatwheel_non_sorted_7_6",             --"Dio: NiceFight, Jojo"
				"anime_chatwheel_non_sorted_7_7",             --"Dio: Nine seconds have pasted"
				"anime_chatwheel_non_sorted_7_8",             --"Dio: Oke oke"

				"anime_chatwheel_non_sorted_8_1",             --"Dio: RODAROLLADA"
				"anime_chatwheel_non_sorted_8_2",             --"Dio: Rooowryyyaaa"
				"anime_chatwheel_non_sorted_8_3",             --"Dio: Saaaaaaaa JOJO"
				"anime_chatwheel_non_sorted_8_4",             --"Dio: WRYYYYYYY"
				"anime_chatwheel_non_sorted_8_5",             --"Dio: WRYYYYYYY♪"
				"anime_chatwheel_non_sorted_8_6",             --"Dio: WRYYYYA"
				"anime_chatwheel_non_sorted_8_7",             --"Dio: Wryyyyyyyyy"
				"anime_chatwheel_non_sorted_8_8",             --"Dio: WWWWWWWWWRYYY"
				
			
				

				"anime_chatwheel_non_sorted_9_1",             --"Hakuryuu: Baka, baka, omae wa minna baka! (Stupid, stupid, we're all stupid!)"
				"anime_chatwheel_non_sorted_9_2",             --"Bucciarati: Arrivederci (Goodbye)"
				"anime_chatwheel_non_sorted_9_3",             --"Giorno: (Piano)"
				"anime_chatwheel_non_sorted_9_4",             --"Scar: Jugenmujugen"
				"anime_chatwheel_non_sorted_9_5",             --"Light: Keikaku Doori (According to plan)"
				"anime_chatwheel_non_sorted_9_6",             --"Nani? (What?)"
				"anime_chatwheel_non_sorted_9_7",             --Kenshiro: Omae wa mou shindeiru (You're already dead)"
				"anime_chatwheel_non_sorted_9_8",					--"Erwin: Shinzou sasageyo! (Devote your hearts!)"
				
				
				
				
				
				
				},
			
			{
				"chatwheel.01",--			"Trace on"	archer_cast_01
				"chatwheel.02",--			"Kuse ga warukute ne (Sorry, bad habits)"	archer_cast_02
				"chatwheel.03",--			"Laugh"	archer_laugh_01
				"chatwheel.04",--			"Muda-da"	archer_attack_05
				"chatwheel.05",--			"Masutā.. sumanai.. (Sorry, Master)" archer_lose_02
				"chatwheel.06",--			"Arigato"	"archer_thanks_02"
				"chatwheel.07",--			"Yatte kureru (How dare you)"	archer_underattack_01
				"chatwheel.08"--			"Yare-yare"	archer_deny_02
			},
			{
				"chatwheel.09",--			"Ora-ora"	blanc_attack_02
				"chatwheel.10",--			"Temē wa watashi o okora seta (You pissed me off)"	blanc_kill_07
				"chatwheel.11",--			"Muda-da"	blanc_deny_02			
				"chatwheel.12",--			"Laugh"	blanc_laugh_01
				"chatwheel.13",--			"Kono yaro"	blanc_lose_04
				"chatwheel.14",--			"Arigatō"	blanc_thanks_02
				"chatwheel.15",--			"Jigoku ni ochiro ne! (Fall into the Hell!"	blanc_firstblood_02
				"chatwheel.16"--			"Kakugo wa dekite ndarou na (I am ready)"	blanc_immort_01
			},
			{
				"chatwheel.17",--			"tadada"	ethel_attack_07
				"chatwheel.18",--			"Sats.Sats.Sats. (Kill.Kill.Kill.)"	ethel_kill_01
				"chatwheel.19",--			"Gomen'nasai (I am sorry)"	ethel_kill_06
				"chatwheel.20",--			"Motto (More)" ethel_haste_02
				"chatwheel.21",--			"Sa..tsu.. (Ki..ll.."	ethel_death_01	
				"chatwheel.22",--			"Ranchāmōdo (Ranger mode)"	ethel_attack_01
				"chatwheel.23",--			"Ari...gato"	ethel_thanks_01
				"chatwheel.24"--			"Don'na toki demo issho (Together at any time)" ethel_spawn_03
			},
			{
				"chatwheel.25",--			"Muda-muda-muda-muda"	ge_attack_01
				"chatwheel.26",--			"Golden Experience"	ge_cast_02
				"chatwheel.27",--			"Aaaaaaah!!"	ge_death_01
				"chatwheel.28",--			"Kono Giorno Giovanna. Yume ga aru"	ge_spawn_01
				"chatwheel.29",--			"Grazie"	ge_thanks_01
				"chatwheel.30",--			"Arividerci"	ge_kill_04
				"chatwheel.31",--			"Iya no pawā o (This Power)"	ge_doubdam_02
				"chatwheel.32"--			"NANI?!"	ge_anger_01
			},
			{
				"chatwheel.33",--			"Laugh"	joseph_laugh_02
				"chatwheel.34",--			"Bye-bye. Ciao"	joseph_kill_07
				"chatwheel.35",--			"Nani-nani?"	joseph_immort_02			
				"chatwheel.36",--			"SHIIIIIZAAAAAA!!"	joseph_death_03
				"chatwheel.37",--			"Kawaii~"	joseph_blink_02	
				"chatwheel.38",--			"Watashi wa tekira shio motte mairimashita no (I brought a tequila)"	joseph_bottle_02
				"chatwheel.39",--			"Very nice yo"	joseph_cast_02
				"chatwheel.40"--			"OHH! NOOOOO!"	joseph_death_14
			},
			{
				"chatwheel.41",--			"Kekka dakeda konoyo ni wa kekka dake ga nokoru (Result! Only Result is important)"	diav_kill_01
				"chatwheel.42",--			"Suimasendeshita bosu hai (I'm sorry, boss, yes)" diav_spawn_03
				"chatwheel.43",--			"Moshimoshi hai Doppio-desu"	diav_spawn_02
				"chatwheel.44",--			"UOOOOOOOOOOOOOOOOOOOOOOOOH!" diav_haste_02
				"chatwheel.45",--			"Laugh"	diav_laugh_01
				"chatwheel.46",--			"Yosoku dekiru zo (I can predict)" diav_deny_03
				"chatwheel.47",--			"Tsugi wa nani (What's next?)"	diav_deny_04
				"chatwheel.48"--			"Masaka!"	diav_death_04
			},
			{
				"chatwheel.49",--			"O tsukare (Well done!)"	kirito_deny_04
				"chatwheel.50",--			"Laugh"	kirito_laugh_02
				"chatwheel.51",--			"Arigato" kirito_thanks_02
				"chatwheel.52",--			"Theaaaaaaah!" kirito_attack_02
				"chatwheel.53",--			"Motto hayaku (Faster)" kirito_attack_06
				"chatwheel.54",--			"ite-te-te" kirito_death_04
				"chatwheel.55",--		"Yare-Yare" kirito_kill_10
				"chatwheel.56"			--"Rinkusutato! (Link! Start!)"--"ember_spirit_embr_bottle_02",--			"Ore ni makasete kure (Leave it to me)" kirito_bottle_02
			},
			{
				"chatwheel.57",--			"Killer Queen!" kq_cast_01
				"chatwheel.58",--			"Laugh" kq_laugh_04
				"chatwheel.59",--			"Ba-ba-bakana" kq_death_04
				"chatwheel.60",--			"Imada!" kq_cast_02
				"chatwheel.61",--			"Nante sugasugashī kibun'na nda (What a refreshing feeling)"	kq_immort_01
				"chatwheel.62",--			"Kore wa... Nanda?!"	kq_death_02 
				"chatwheel.63",--			"Kimihitori ka ne (Are you... alone?)"	kq_spawn_01
				"chatwheel.64"--			"Oi-oi"	kq_move_08
			},
			{
				"chatwheel.65",--			"Ara-ara~"	kur_move_05
				"chatwheel.66",--			"Bleeea~"	kur_firstblood_01
				"chatwheel.67",--		"Laugh"	kur_laugh_03
				"chatwheel.68",--			"Zaaaafkieeeeel!"	kur_lose_01_death_01
				"chatwheel.69",--			"Daijobu desu-yo"	kur_nomana_01
				"chatwheel.70",--		"Ehe~..Masaka"	kur_thanks_01
				"chatwheel.71",--			"Ara-ara"	kur_move_04
				"chatwheel.72"--			"Ara!" kur_anger_01
			},
			{
				"chatwheel.73",--			"Why are you surprised?"	maki_kill_01
				"chatwheel.74",--			"Shut up, you asshole!"	maki_attack_02
				"chatwheel.75",--			"If you don't shut your mouth then I'll shut it for you.. permanently" maki_levelup_03
				"chatwheel.76",--			"What is that?" maki_sceptor_01
				"chatwheel.77",--			"You... F*cking asshole"	maki_death_04
				"chatwheel.78",--			"All you've proven is that you're an idiot."	maki_kill_02
				"chatwheel.79",--			"How dare you?"	maki_death_03
				"chatwheel.80"--			"Stop right now"	maki_kill_06
			},
			{
				"chatwheel.81",--			"Bakuretsu~ bakuretsu~ La-la-la"	meg_move_03
				"chatwheel.82",--			"Watashi n no bakuretsu mahō (I'll show my explosion magic)"	meg_attack_01
				"chatwheel.83",--			"Screaming"	meg_anger_02
				"chatwheel.84",--			"Laugh" meg_laugh_01
				"chatwheel.85",--			"Onegaishimasu~ (Please~)" meg_regen_01
				"chatwheel.86",--		"Chinchinmaru" meg_item_02
				"chatwheel.87",--			"Chomusuke desu" meg_scepter_03
				"chatwheel.88"--			"Nan desu-ka?" meg_lose_02
			},
			{
				"chatwheel.89",--			"Hey! Am I super or what?"	nep_kill_02
				"chatwheel.90",--			"I'll nep your face"	nep_kill_05
				"chatwheel.91",--			"Judgement!"	nep_lasthit_03
				"chatwheel.92",--			"Laugh"	nep_laugh_01
				"chatwheel.93",--			"Nep-nep-nep"	nep_laugh_02
				"chatwheel.94",--			"Gonna do my best"	nep_level_04
				"chatwheel.95",--			"Time to get serious"	nep_respawn_01
				"chatwheel.96"--			"Thank you"	nep_thanks_01
			},
			{
				"chatwheel.97",--			"Laugh"	noire_laugh_01
				"chatwheel.98",--			"Sayōnara to"	noire_kill_03
				"chatwheel.99",--			"Shikatanai wa ne (I can't help it)"	noire_deny_02
				"chatwheel.100",--			"Nan-bai-gaeshi ga o konomi kashira (How many times is your preference?)"	noire_doubdam_02
				"chatwheel.101",--			"Theaaaaah!"	noire_haste_02
				"chatwheel.102",--			"Yowai kuse ni detekuru kara yo (I'm coming out of weakness)"	noire_immort_01
				"chatwheel.103",--			"Screaming"	noire_death_08
				"chatwheel.104"--		"Suki-darake (Full of love)"	noire_blink_01
			},
			{
				"chatwheel.105",--			"I knew you could handle it"	raven_ally_01
				"chatwheel.106",--			"I'll be over in a heartbeat"	raven_attack_05
				"chatwheel.107",--			"Have enough yet?"	raven_kill_05
				"chatwheel.108",--			"That's what I thought"	raven_lasthit_05
				"chatwheel.109",--			"Thank you"	raven_thanks_01
				"chatwheel.110",--			"So you can believe me when I say this wasn't personal"	raven_kill_04
				"chatwheel.111",--			"Standing there shaking like a scared little girl"	raven_kill_09
				"chatwheel.112"--			"You don't want to do this"	raven_kill_10
			},
			{
				"chatwheel.113",--			"Toki ga watashi o mikata shite iru (Time is on my side)"	sakuya_respawn_03
				"chatwheel.114",--			"Laugh" sakuya_laugh_01
				"chatwheel.115",--			"Kore de owaru yo (That's it)"	sakuya_kill_04
				"chatwheel.116",--			"Yare-yare"	sakuya_kill_01
				"chatwheel.117",--			"Dō iu koto ka setsumei shite itadakeru? (Can you explain what it means?)"	sakuya_levelup_01
				"chatwheel.118",--			"Nigashimasen wa (I won't let you escape)"	sakuya_attack_05
				"chatwheel.119",--			"Yatto demashi ne (It finally came out)"	sakuya_blink_01
				"chatwheel.120"--			"Dō shita no (What's wrong?"	sakuya_move_04
			},
			{
				"chatwheel.121",--			
				"chatwheel.122",--			
				"chatwheel.123",--			
				"chatwheel.124",--			
				"chatwheel.125",--			
				"chatwheel.126",--			
				"chatwheel.127",--			
				"chatwheel.128"--		
			},
{
				"chatwheel.129",--			
				"chatwheel.130",--			
				"chatwheel.131",--			
				"chatwheel.132",--			
				"chatwheel.133",--			
				"chatwheel.134",--			
				"chatwheel.135",--			
				"chatwheel.136"--		
			},
			{
				"chatwheel.137",--			
				"chatwheel.138",--			
				"chatwheel.139",--			
				"chatwheel.140",--			
				"chatwheel.141",--			
				"chatwheel.142",--			
				"chatwheel.143",--			
				"chatwheel.144"--		
			},
			{
				"chatwheel.145",--			
				"chatwheel.146",--			
				"chatwheel.147",--			
				"chatwheel.148",--			
				"chatwheel.149",--			
				"chatwheel.150",--			
				"chatwheel.151",--			
				"chatwheel.152"--		
			},
			{
				"chatwheel.153",--			
				"chatwheel.154",--			
				"chatwheel.155",--			
				"chatwheel.156",--			
				"chatwheel.157",--			
				"chatwheel.158",--			
				"chatwheel.159",--			
				"chatwheel.160"--		
			},
			{
				"chatwheel.161",--			
				"chatwheel.162",--			
				"chatwheel.163",--			
				"chatwheel.164",--			
				"chatwheel.165",--			
				"chatwheel.166",--			
				"chatwheel.167",--			
				"chatwheel.168"--		
			},
			{
				"chatwheel.169",--			
				"chatwheel.170",--			
				"chatwheel.171",--			
				"chatwheel.172",--			
				"chatwheel.173",--			
				"chatwheel.174",--			
				"chatwheel.175",--			
				"chatwheel.176"--		
			},
			{
				"chatwheel.177",--			
				"chatwheel.178",--			
				"chatwheel.179",--			
				"chatwheel.180",--			
				"chatwheel.181",--			
				"chatwheel.182",--			
				"chatwheel.183",--			
				"chatwheel.184"--		
			},
			{
				"chatwheel.185",--			
				"chatwheel.186",--			
				"chatwheel.187",--			
				"chatwheel.188",--			
				"chatwheel.189",--			
				"chatwheel.190",--			
				"chatwheel.191",--			
				"chatwheel.192"--		
			},
			{
				"chatwheel.193",--			
				"chatwheel.194",--			
				"chatwheel.195",--			
				"chatwheel.196",--			
				"chatwheel.197",--			
				"chatwheel.198",--			
				"chatwheel.199",--			
				"chatwheel.200"--		
			},
			{
				"chatwheel.201",--			
				"chatwheel.202",--			
				"chatwheel.203",--			
				"chatwheel.204",--			
				"chatwheel.205",--			
				"chatwheel.206",--			
				"chatwheel.207",--			
				"chatwheel.208"--		
			},
			{
				"chatwheel.209",--			
				"chatwheel.210",--			
				"chatwheel.211",--			
				"chatwheel.212",--			
				"chatwheel.213",--			
				"chatwheel.214",--			
				"chatwheel.215",--			
				"chatwheel.216"--		
			},
			{
				"chatwheel.217",--			
				"chatwheel.218",--			
				"chatwheel.219",--			
				"chatwheel.220",--			
				"chatwheel.221",--			
				"chatwheel.222",--			
				"chatwheel.223",--			
				"chatwheel.224"--		
			},
			{
				"chatwheel.225",--			
				"chatwheel.226",--			
				"chatwheel.227",--			
				"chatwheel.228",--			
				"chatwheel.229",--			
				"chatwheel.230",--			
				"chatwheel.231",--			
				"chatwheel.232"--		
			},
			{
				"chatwheel.233",--			
				"chatwheel.234",--			
				"chatwheel.235",--			
				"chatwheel.236",--			
				"chatwheel.237",--			
				"chatwheel.238",--			
				"chatwheel.239",--			
				"chatwheel.240"--		
			},
			{
				"chatwheel.241",--			
				"chatwheel.242",--			
				"chatwheel.243",--			
				"chatwheel.244",--			
				"chatwheel.245",--			
				"chatwheel.246",--			
				"chatwheel.247",--			
				"chatwheel.248"--		
			},
		}
		
        local player = PlayerResource:GetPlayer(keys.PlayerID)
		local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
	if hero:GetLevel() > 0 then
		if votimer[keys.PlayerID] ~= nil then
			if GameRules:GetGameTime() - votimer[keys.PlayerID] > 10 then
				--print(selectedstr, "ww")
				--EmitAnnouncerSound(heroesvo[selectedid][selectedid2])
				CustomGameEventManager:Send_ServerToAllClients("anime_chatwheel_sound_play", {player_id = keys.PlayerID, sound = heroesvo[selectedid][selectedid2]})
				
				--GameRules:SendCustomMessage("<font color='#70EA72'>".."test".."</font>",-1,0)
				Say(PlayerResource:GetPlayer(keys.PlayerID), chat["anime_chatwheel_message_"..selectedstr], false)
				--Say(PlayerResource:GetPlayer(keys.PlayerID), "#dota_chatwheel_message_"..selectedstr, false)
				votimer[keys.PlayerID] = GameRules:GetGameTime()

				
			end
		else
		
			--EmitAnnouncerSound(heroesvo[selectedid][selectedid2])
			CustomGameEventManager:Send_ServerToAllClients("anime_chatwheel_sound_play", {player_id = keys.PlayerID, sound = heroesvo[selectedid][selectedid2]})

			Say(PlayerResource:GetPlayer(keys.PlayerID), chat["anime_chatwheel_message_"..selectedstr], false)
			--Say(PlayerResource:GetPlayer(keys.PlayerID), "#dota_chatwheel_message_"..selectedstr, false)
			votimer[keys.PlayerID] = GameRules:GetGameTime()
		
		end
	end
end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------
function CustomChatWheel:OnPlayerChat(keys)
	local text = keys.text
	local PID = keys.playerid
	--local id32 = PlayerResource:GetSteamAccountID(PID)
	--print(Time(), GameRules:GetGameTime(), GameRules:GetDOTATime(true, true))
    --local NetTable = CustomNetTables:GetTableValue("anime_patreon_new", "anime_patreon")
    --if NetTable then
       -- local player_table = NetTable[tostring(id32)]

       -- if player_table and tonumber(player_table.pactive or 0) >= 1 and tonumber(player_table.plevel or 0) >= 5 then
			if string.sub(text, 0,4) == "-cw " then
				local data = {}
				data.num = tonumber(string.sub(text, 5))
				data.PlayerID = PID
				SelectVO(data)
			end
		--end
	--end
end


if not LOADED then
	--print("WTF")
	RegisterCustomEventListener("SelectVO", SelectVO)

	ListenToGameEvent( "player_chat", Dynamic_Wrap( CustomChatWheel, "OnPlayerChat" ), CustomChatWheel )

	LOADED = true
end
