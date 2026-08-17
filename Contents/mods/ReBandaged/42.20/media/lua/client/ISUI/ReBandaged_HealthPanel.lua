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
        local isOnlyDirty = SandboxVars.ReBandaged and SandboxVars.ReBandaged.OnlyDirty == true

        if isOnlyDirty and bodyPart:getBandageLife() > 0 then
            return
        end

        local doctor  = self.otherPlayer or self.character
        local patient = self.character

        local availableBandages = ReBandaged.getAvailableBandages(doctor)

        if availableBandages and #availableBandages > 0 then
            ReBandaged.buildContextMenu(context, self, bodyPart, availableBandages, doctor, patient)
        end
    end
end

function ISHealthPanel:onReplaceBandage(bodyPart, newBandage, doctor, patient)
    ISInventoryPaneContextMenu.transferIfNeeded(doctor, newBandage)

    local removeAction = ISApplyBandage:new(doctor, patient, nil, bodyPart, false)
    local applyAction  = ISApplyBandage:new(doctor, patient, newBandage, bodyPart, true)

    ISTimedActionQueue.add(removeAction)
    ISTimedActionQueue.addAfter(removeAction, applyAction)
end

