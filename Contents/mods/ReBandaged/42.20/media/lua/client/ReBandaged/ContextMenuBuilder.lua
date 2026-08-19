ReBandaged = ReBandaged or {}

local ContextMenuBuilder = {}

ReBandaged.ContextMenuBuilder = ContextMenuBuilder

function ContextMenuBuilder.Build(context, bodyPart, doctor, patient)
	if not ReBandaged.Settings or not ReBandaged.BandageUtils or not ReBandaged.BandageFinder or not ReBandaged.WoundTreatment or not ReBandaged.Text then
		return
	end

	if not bodyPart:bandaged() then
		return
	end

    local settings = ReBandaged.Settings

	if settings.OnlyDirty and not ReBandaged.BandageUtils.IsDirty(bodyPart) then
        return
    end

	local finder   = ReBandaged.BandageFinder:New(doctor, settings)
	local bandages = finder and finder:Find() or {}

	if not bandages or #bandages == 0 then
		return
	end

	local replaceText = ReBandaged.Text.ReplaceBandage()

	if settings.AutoTranslate then
        local itemName = instanceItem("Base.Bandage"):getName()
		replaceText = ReBandaged.Text.ReplaceWith(itemName)
	end

	local replaceOption = nil

	if settings.AutoPick then
		local bestBandage = ReBandaged.BandageUtils.GetBest(bandages)

		if not bestBandage then
			return
		end

		if settings.SpecifyPick then
			replaceText = string.format("%s (%s)", replaceText, bestBandage:getName())
		end

		replaceOption = context:addOption(
			replaceText,
			ReBandaged.WoundTreatment,
			ReBandaged.WoundTreatment.Replace,
			bodyPart,
			bestBandage,
			doctor,
			patient
		)
		replaceOption.itemForTexture = bestBandage
	else
		replaceOption = context:addOption(replaceText, nil)

		local bandageType = bodyPart:getBandageType()

		if bandageType then
			replaceOption.itemForTexture = instanceItem(bandageType)
		end

		local subMenu = context:getNew(context)
		context:addSubMenu(replaceOption, subMenu)

		for _, bandage in ipairs(bandages) do
			local subOption = subMenu:addOption(
				bandage:getName(),
				ReBandaged.WoundTreatment,
				ReBandaged.WoundTreatment.Replace,
				bodyPart,
				bandage,
				doctor,
				patient
			)
			subOption.itemForTexture = bandage
		end
	end

	local removeText = ReBandaged.Text.RemoveBandage()

	for index, option in ipairs(context.options) do
		if option.name == removeText then
			local replaceOptionIndex = #context.options
			local extractedOption    = table.remove(context.options, replaceOptionIndex)
			table.insert(context.options, index, extractedOption)
			break
		end
	end
end

