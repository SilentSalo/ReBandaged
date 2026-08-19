ReBandaged = ReBandaged or {}

function ReBandaged.RefreshSettings()
    ReBandaged.Settings = {
        AutoPick      = SandboxVars.ReBandaged.AutoPick,
        AutoSearch    = SandboxVars.ReBandaged.AutoSearch,
        AutoDisinfect = SandboxVars.ReBandaged.AutoDisinfect,
        SpecifyPick   = SandboxVars.ReBandaged.SpecifyPick,
        OnlyDirty     = SandboxVars.ReBandaged.OnlyDirty,
        AutoTranslate = SandboxVars.ReBandaged.AutoTranslate,
    }
end

ReBandaged.RefreshSettings()
Events.OnGameStart.Add(ReBandaged.RefreshSettings)

