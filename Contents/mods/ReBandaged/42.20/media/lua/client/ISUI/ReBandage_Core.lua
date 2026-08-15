ReBandaged = ReBandaged or {}

function ReBandaged.getAvailableBandages(inventory, doctor)
    local availableBandages = {}
    local addedTypes        = {}

    local containers = ISInventoryPaneContextMenu.getContainers(doctor)

    if not containers then
        return
    end

    for i = 0, containers:size() - 1 do
        local container = containers:get(i)
        local items = container:getItems()

        for j = 0, items:size() - 1 do
            local item = items:get(j)
            if item:getBandagePower() > 0 then
                local type = item:getFullType()
                if not addedTypes[type] then
                    table.insert(availableBandages, item)
                    addedTypes[type] = true
                end
            end
        end
    end

    return availableBandages
end

function ReBandaged.sortBandages(bandages)
    table.sort(bandages, function(a, b)
        local isSterileA = (a.isAlcoholic and a:isAlcoholic()) or (a.getAlcoholPower and a:getAlcoholPower() > 0) or false
        local isSterileB = (b.isAlcoholic and b:isAlcoholic()) or (b.getAlcoholPower and b:getAlcoholPower() > 0) or false

        if isSterileA ~= isSterileB then
            return isSterileA
        end

        local powerA = a:getBandagePower()
        local powerB = b:getBandagePower()

        if powerA == powerB then
            return a:getName() < b:getName()
        end

        return powerA > powerB
    end)
end

function ReBandaged.buildContextMenu(context, healthPanel, bodyPart, availableBandages, doctor, patient)
    local isAutoPick      = SandboxVars.ReBandaged and SandboxVars.ReBandaged.AutoPick      == true
    local isSpecifyPick   = SandboxVars.ReBandaged and SandboxVars.ReBandaged.SpecifyPick   == true
    local isAutoTranslate = SandboxVars.ReBandaged and SandboxVars.ReBandaged.AutoTranslate == true

    ReBandaged.sortBandages(availableBandages)

    local replaceText = getText("ContextMenu_ReplaceBandage")

    if isAutoTranslate then
        replaceText = getText("ContextMenu_ReplaceWith", instanceItem("Base.Bandage"):getName())
        replaceText = string.gsub(replaceText, "%(", "")
        replaceText = string.gsub(replaceText, "%)", "")
        replaceText = replaceText:gsub("^%l", string.upper)
    end

    local replaceOption = nil

    if isAutoPick then
        local bestBandage = availableBandages[1]

        if isSpecifyPick then
            replaceText = string.format("%s (%s)", replaceText, bestBandage:getName())
        end

        replaceOption = context:addOption(replaceText, healthPanel, ISHealthPanel.onReplaceBandage, bodyPart, bestBandage, doctor, patient)
        replaceOption.itemForTexture = bestBandage
    else
        replaceOption = context:addOption(replaceText, nil)

        local currentBandageType = bodyPart:getBandageType()

        if currentBandageType then
            local dummyItem = instanceItem(currentBandageType)
            if dummyItem then
                replaceOption.itemForTexture = dummyItem
            end
        end

        local subMenu = context:getNew(context)
        context:addSubMenu(replaceOption, subMenu)

        for _, bandage in ipairs(availableBandages) do
            local subOption = subMenu:addOption(bandage:getName(), healthPanel, ISHealthPanel.onReplaceBandage, bodyPart, bandage, doctor, patient)
            subOption.itemForTexture = bandage
        end
    end

    if replaceOption then
        local removeText  = getText("ContextMenu_Remove_Bandage")
        local targetIndex = nil

        for i, option in ipairs(context.options) do
            if option.name == removeText then
                targetIndex = i
                break
            end
        end

        if targetIndex then
            local replaceOptionIndex = #context.options
            local extractedOption    = table.remove(context.options, replaceOptionIndex)
            table.insert(context.options, targetIndex, extractedOption)
        end
    end
end

