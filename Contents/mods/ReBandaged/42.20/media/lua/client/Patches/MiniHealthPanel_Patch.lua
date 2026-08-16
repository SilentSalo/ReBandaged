if MiniHealthTreatment and not MiniHealthTreatment.ReBandagedPatched then
    local _doBodyPartContextMenu = MiniHealthTreatment.doBodyPartContextMenu

    function MiniHealthTreatment:onReplaceBandage(bodyPart, newBandage, doctor, patient)
        ISInventoryPaneContextMenu.transferIfNeeded(doctor, newBandage)

        local removeAction = ISApplyBandage:new(doctor, patient, nil, bodyPart, false)
        local applyAction  = ISApplyBandage:new(doctor, patient, newBandage, bodyPart, true)

        ISTimedActionQueue.add(removeAction)
        ISTimedActionQueue.add(applyAction)
    end

    function MiniHealthTreatment:doBodyPartContextMenu(bodyPart, context)
        _doBodyPartContextMenu(self, bodyPart, context)

        local isOnlyDirty = SandboxVars.ReBandaged and SandboxVars.ReBandaged.OnlyDirty == true

        if not bodyPart:bandaged() then
            return
        end

        if isOnlyDirty and bodyPart:getBandageLife() > 0 then
            return
        end

        local doctor  = mhpHandle.player
        local patient = mhpHandle.player

        local availableBandages = ReBandaged.getAvailableBandages(doctor)

        if availableBandages and #availableBandages > 0 then
            ReBandaged.buildContextMenu(context, self, bodyPart, availableBandages, doctor, patient)
        end
    end

    MiniHealthTreatment.ReBandagedPatched = true
end

