ReBandaged = ReBandaged or {}

local DisinfectantFinder = {}
DisinfectantFinder.__index = DisinfectantFinder

ReBandaged.DisinfectantFinder = DisinfectantFinder

function DisinfectantFinder:New(doctor, settings)
    if not doctor or not settings then
        return nil
    end

    return setmetatable({
        Doctor   = doctor,
        Settings = settings
    }, DisinfectantFinder)
end

function DisinfectantFinder:FindInContainers()
    local containers = ISInventoryPaneContextMenu.getContainers(self.Doctor)

    if not containers then
        return {}
    end

    local availableDisinfectants = {}
    local addedTypes        = {}

    for i = 0, containers:size() - 1 do
        local container = containers:get(i)
        local items     = container:getItems()

        for j = 0, items:size() - 1 do
            local item = items:get(j)
            if ReBandaged.DisinfectantUtils.IsDisinfectant(item) then
                local type = item:getFullType()
                if not addedTypes[type] then
                    table.insert(availableDisinfectants, item)
                    addedTypes[type] = true
                end
            end
        end
    end

    return availableDisinfectants
end

function DisinfectantFinder:FindInInventory()
    local inventory = self.Doctor:getInventory()

    if not inventory then
        return {}
    end

    local availableDisinfectants = {}
    local addedTypes        = {}

   local items = inventory:getItems()

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if ReBandaged.DisinfectantUtils.IsDisinfectant(item) then
            local type = item:getFullType()
            if not addedTypes[type] then
                table.insert(availableDisinfectants, item)
                addedTypes[type] = true
            end
        end
    end

    return availableDisinfectants
end

function DisinfectantFinder:Find()
    if self.Settings.AutoSearch then
        return self:FindInContainers()
    else
        return self:FindInInventory()
    end
end

