ReBandaged = ReBandaged or {}

local DisinfectantUtils = {}

ReBandaged.DisinfectantUtils = DisinfectantUtils

function DisinfectantUtils.IsDisinfectant(item)
    if not item then
        return false
    end

    if item.getAlcoholPower and item:getAlcoholPower() > 0 then
        return true
    end

    if item.hasComponent and item:hasComponent(ComponentType.FluidContainer) then
        local fluidContainer = item:getFluidContainer()
        local fluidAmount    = fluidContainer:getAmount()
        local alcoholAmount  = fluidContainer:getProperties():getAlcohol()

        return fluidAmount > 0.15 and alcoholAmount / fluidAmount + 0.001 >= 0.4
    end

    return false
end

function DisinfectantUtils.Sort(disinfectants)
    if not disinfectants or #disinfectants == 0 then
        return
    end

    table.sort(disinfectants, function(a, b)
        local powerA = a:getAlcoholPower()
        local powerB = b:getAlcoholPower()

        if powerA == powerB then
            return a:getName() < b:getName()
        end

        return powerA > powerB
    end)
end

function DisinfectantUtils.GetBest(disinfectants)
    if not disinfectants or #disinfectants == 0 then
        return nil
    end

    DisinfectantUtils.Sort(disinfectants)

    return disinfectants[1]
end

