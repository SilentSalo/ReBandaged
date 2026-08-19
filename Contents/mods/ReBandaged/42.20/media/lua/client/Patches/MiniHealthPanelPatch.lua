if MiniHealthTreatment and not MiniHealthTreatment.ReBandagedPatched then
    local _doBodyPartContextMenu = MiniHealthTreatment.doBodyPartContextMenu

    function MiniHealthTreatment:doBodyPartContextMenu(bodyPart, context)
        _doBodyPartContextMenu(self, bodyPart, context)

        local doctor  = mhpHandle.player
        local patient = doctor

        ReBandaged.ContextMenuBuilder.Build(context, bodyPart, doctor, patient)
    end

    MiniHealthTreatment.ReBandagedPatched = true
end

