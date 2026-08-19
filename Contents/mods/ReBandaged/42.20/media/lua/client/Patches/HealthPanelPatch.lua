local _doBodyPartContextMenu = ISHealthPanel.doBodyPartContextMenu

function ISHealthPanel:doBodyPartContextMenu(bodyPart, x, y)
    local context = ReBandaged.ContextMenuInterceptor.Capture(function()
        _doBodyPartContextMenu(self, bodyPart, x, y)
    end)

    if context then
        local doctor  = self.otherPlayer or self.character
        local patient = self.character

        ReBandaged.ContextMenuBuilder.Build(context, bodyPart, doctor, patient)
    end
end