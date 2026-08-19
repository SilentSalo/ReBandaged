ReBandaged = ReBandaged or {}

local Text = {}

ReBandaged.Text = Text

function Text.ReplaceBandage()
    return getText("ContextMenu_Replace_Bandage")
end

function Text.ReplaceWith(itemName)
    if not itemName then
        return getText("ContextMenu_ReplaceWith", "")
    end

    local text = getText("ContextMenu_ReplaceWith", itemName)
    text = string.gsub(text, "%(", "")
    text = string.gsub(text, "%)", "")
    return text:gsub("^%l", string.upper)
end

function Text.RemoveBandage()
    return getText("ContextMenu_Remove_Bandage")
end

