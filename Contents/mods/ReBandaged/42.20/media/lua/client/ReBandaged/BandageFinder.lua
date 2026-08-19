ReBandaged = ReBandaged or {}

local BandageFinder = {}
BandageFinder.__index = BandageFinder

ReBandaged.BandageFinder = BandageFinder

function BandageFinder:New(doctor, settings)
    if not doctor or not settings then
        return nil
    end

    return setmetatable({
        Doctor   = doctor,
        Settings = settings
    }, BandageFinder)
end

function BandageFinder:FindInContainers()
    local containers = ISInventoryPaneContextMenu.getContainers(self.Doctor)

    if not containers then
        return {}
    end

    local availableBandages = {}
    local addedTypes        = {}

    for i = 0, containers:size() - 1 do
        local container = containers:get(i)
        local items     = container:getItems()

        for j = 0, items:size() - 1 do
            local item = items:get(j)
            if ReBandaged.BandageUtils.IsBandage(item) then
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

function BandageFinder:FindInInventory()
    local inventory = self.Doctor:getInventory()

    if not inventory then
        return {}
    end

    local availableBandages = {}
    local addedTypes        = {}

   local items = inventory:getItems()

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if ReBandaged.BandageUtils.IsBandage(item) then
            local type = item:getFullType()
            if not addedTypes[type] then
                table.insert(availableBandages, item)
                addedTypes[type] = true
            end
        end
    end

    return availableBandages
end

function BandageFinder:Find()
    if self.Settings.AutoSearch then
        return self:FindInContainers()
    else
        return self:FindInInventory()
    end
end

