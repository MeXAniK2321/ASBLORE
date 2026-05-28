
item_arcana_gift = item_arcana_gift or class({})

function item_arcana_gift:OnSpellStart()
    -- Not sure if debug traceback fixed on live versions?
	--[[local function ArcanaError(anyErr)
		print( debug.traceback("Arcana Gift Item: " .. tostring(anyErr)), 2 )
	end
    
	xpcall(function()
		local hCaster = self:GetCaster()
		local PID     = hCaster:GetPlayerOwnerID()
		local id32    = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
		
		if not IsASBPatreon(hCaster) then
			table.insert(_G.__Patreon, id32)
			COverthrowGameMode:OnNPCSpawned({ entindex = hCaster:entindex() })
		end
		
		self:SpendCharge(0)
	end, ArcanaError
	)]]--
	
	local hCaster = self:GetCaster()
	local PID     = hCaster:GetPlayerOwnerID()
	local id32    = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	
	local ok, err = pcall(function()
		if not IsASBPatreon(hCaster) then
			table.insert(_G.__Patreon, id32)
			COverthrowGameMode:OnNPCSpawned({ entindex = hCaster:entindex() })
		end
		
		self:SpendCharge(0)
	end)


    if not ok then
        print("Arcana Gift Item: Probably something broken...")
    end
end