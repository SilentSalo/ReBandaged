ReBandaged = ReBandaged or {}

local ContextMenuInterceptor = {}

ReBandaged.ContextMenuInterceptor = ContextMenuInterceptor

function ContextMenuInterceptor.Capture(callback)
    if type(callback) ~= "function" then
        error("[ReBandaged] ContextMenuInterceptor.Capture expects a callback", 0)
    end

    local _get = ISContextMenu.get
    local capturedContext

    local function CaptureContext(...)
        capturedContext = _get(...)
        return capturedContext
    end

    rawset(ISContextMenu, "get", CaptureContext)

    local success, errorMessage = pcall(callback)

    rawset(ISContextMenu, "get", _get)

    if not success then
        local fullMessage = string.format("[ReBandaged] Context menu callback failed: %s", errorMessage)
        print(fullMessage)
        error(fullMessage, 0)
    end

    return capturedContext
end

