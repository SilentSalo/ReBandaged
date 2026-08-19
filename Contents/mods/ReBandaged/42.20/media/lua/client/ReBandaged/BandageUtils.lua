ReBandaged = ReBandaged or {}

local BandageUtils = {}

ReBandaged.BandageUtils = BandageUtils

function BandageUtils.IsBandage(item)
    return item and item:getBandagePower() > 0
end

function BandageUtils.IsDirty(bodyPart)
    if not bodyPart:bandaged() then
        return false
    end

    return bodyPart:getBandageLife() <= 0
end

function BandageUtils.IsSterile(bandage)
    if not BandageUtils.IsBandage(bandage) then
        return false
    end

    local isAlcoholic     = bandage.isAlcoholic and bandage:isAlcoholic()
    local hasAlcoholPower = bandage.getAlcoholPower and bandage:getAlcoholPower() > 0

    return isAlcoholic or hasAlcoholPower
end

function BandageUtils.Sort(bandages)
    if not bandages or #bandages == 0 then
        return
    end

    table.sort(bandages, function(a, b)
        local isSterileA = BandageUtils.IsSterile(a)
        local isSterileB = BandageUtils.IsSterile(b)

        if isSterileA ~= isSterileB then
            return isSterileA
        end

        local powerA = a:getBandagePower()
        local powerB = b:getBandagePower()

        if powerA == powerB then
            return a:getName() < b:getName()
        end

        return powerA > powerB
    end)
end

function BandageUtils.GetBest(bandages)
    if not bandages or #bandages == 0 then
        return nil
    end

    BandageUtils.Sort(bandages)

    return bandages[1]
end
