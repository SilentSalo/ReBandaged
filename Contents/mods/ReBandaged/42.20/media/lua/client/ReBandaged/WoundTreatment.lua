ReBandaged = ReBandaged or {}

local WoundTreatment = {}

ReBandaged.WoundTreatment = WoundTreatment

function WoundTreatment:Replace(bodyPart, newBandage, doctor, patient)
    ISInventoryPaneContextMenu.transferIfNeeded(doctor, newBandage)

    local removeAction = ISApplyBandage:new(doctor, patient, nil, bodyPart, false)
    local applyAction  = ISApplyBandage:new(doctor, patient, newBandage, bodyPart, true)

    ISTimedActionQueue.add(removeAction)

    local settings = ReBandaged.Settings

    if settings.AutoDisinfect then
        local finder        = ReBandaged.DisinfectantFinder:New(doctor, settings)
        local disinfectants = finder and finder:Find() or {}
        local disinfectant  = ReBandaged.DisinfectantUtils.GetBest(disinfectants)

        if disinfectant then
            ISInventoryPaneContextMenu.transferIfNeeded(doctor, disinfectant)
            local disinfectAction = ISDisinfect:new(doctor, patient, disinfectant, bodyPart)
            ISTimedActionQueue.addAfter(removeAction, disinfectAction)
            ISTimedActionQueue.addAfter(disinfectAction, applyAction)
            return
        end
    end

    ISTimedActionQueue.addAfter(removeAction, applyAction)
end

