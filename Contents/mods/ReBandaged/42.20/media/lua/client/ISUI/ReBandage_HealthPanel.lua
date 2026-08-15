local _doBodyPartContextMenu = ISHealthPanel.doBodyPartContextMenu

function ISHealthPanel:doBodyPartContextMenu(bodyPart, x, y)
    local context            = nil
    local _ISContextMenu_get = ISContextMenu.get

    ISContextMenu.get = function(...)
        context = _ISContextMenu_get(...)
        return context
    end

    _doBodyPartContextMenu(self, bodyPart, x, y)
    ISContextMenu.get = _ISContextMenu_get

    if context and bodyPart:bandaged() then
        local doctor  = self.otherPlayer or self.character
        local patient = self.character

        local inventory         = doctor:getInventory()
        local availableBandages = ReBandaged.getAvailableBandages(inventory, doctor)

        if #availableBandages > 0 then
            ReBandaged.buildContextMenu(context, self, bodyPart, availableBandages, doctor, patient)
        end
    end
end

function ISHealthPanel:onReplaceBandage(bodyPart, newBandage, doctor, patient)
    ISInventoryPaneContextMenu.transferIfNeeded(doctor, newBandage)

    local removeAction = ISApplyBandage:new(doctor, patient, nil, bodyPart, false)
    local applyAction  = ISApplyBandage:new(doctor, patient, newBandage, bodyPart, true)

    ISTimedActionQueue.add(removeAction)
    ISTimedActionQueue.add(applyAction)
end

