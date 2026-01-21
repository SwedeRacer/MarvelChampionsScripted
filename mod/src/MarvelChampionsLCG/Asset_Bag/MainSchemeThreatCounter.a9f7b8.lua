local TEXT_COLOR = "rgb(0,0,0)"
local UI_HEIGHT = "350"
local UI_WIDTH = "350"
local UI_POSITION = "0 50 -10"
local BUTTON_HEIGHT = "180"
local BUTTON_WIDTH = "200"
local BUTTON_FONT_SIZE = "160"

local debounceTimer = nil
local DEBOUNCE_DELAY = 0.3

require('!/components/counter')

function extendUI(params)
    local ui = params.ui
    local primaryButtonLabel = getDataValue("primaryButtonLabel", "ADVANCE")
    local showPrimaryButton = tostring(getDataValue("showPrimaryButton", false))
    local targetValue = tostring(getDataValue("targetValue", ""))
    local showTargetValue = targetValue ~= ""

    local primaryButton = 
    {
        tag = "Button",
        value = primaryButtonLabel,
        attributes = {
            id = "primaryButton",
            rectAlignment = "MiddleCenter",
            offsetXY = "0 280",
            onClick = "primaryButtonClicked",
            color = "rgba(0,0,1,1)",
            textColor = "rgb(1,1,1)",
            height = "120",
            width = "475",
            fontSize = "80",
            fontStyle = "Bold",
            active = showPrimaryButton
        }
    }

    table.insert(ui[1].children, primaryButton)

    local targetLabel = 
    {
        tag = "Button",
        value = "TARGET: " .. targetValue,
        attributes = {
            id = "targetValueLabel",
            rectAlignment = "MiddleCenter",
            offsetXY = "0 -130",
            color = "rgba(1,0,0,0)",
            textColor = "rgb(1,1,1)",
            height = "120",
            width = "475",
            fontSize = "50",
            fontStyle = "Bold",
            active = showTargetValue
        }
    }

    table.insert(ui[1].children, targetLabel)

    return ui
end

function getSchemeKey()
    return getDataValue("schemeKey", nil)
end

function setSchemeKey(params)
    setDataValue("schemeKey", params.schemeKey)
end

function setTargetValue(params)
    local targetValue = params.value
    local labelText = "TARGET: " .. tostring(targetValue)

    setDataValue("targetValue", targetValue)
    valueUpdated()

    if(targetValue ~= "") then
        self.UI.setAttribute("targetValueLabel", "text", labelText)
        self.UI.setAttribute("targetValueLabel", "textColor", "rgb(1,1,1)")
        self.UI.show("targetValueLabel")
    else
        self.UI.hide("targetValueLabel")
    end
end

function setPrimaryButtonOptions(params)
    setDataValue("primaryButtonLabel", params.label)
    setDataValue("primaryButtonFunction", params.clickFunction)
    setDataValue("primaryButtonParams", params.params)
end

function primaryButtonClicked()
    local functionName = getDataValue("primaryButtonFunction", "advanceScheme")
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call(functionName, {
        schemeKey = getSchemeKey()
    })
end

function showPrimaryButton()
    if(getDataValue("showPrimaryButton", false)) then return end
    setDataValue("showPrimaryButton", true)

    self.UI.setAttribute("primaryButton", "text", getDataValue("primaryButtonLabel", "ADVANCE"))
    self.UI.setAttribute("primaryButton", "textColor", "rgb(1,1,1)")
    self.UI.show("primaryButton")
end

function hidePrimaryButton()
    if(not getDataValue("showPrimaryButton", false)) then return end

    setDataValue("showPrimaryButton", false)
    self.UI.hide("primaryButton")
end

function updateHighlightState()
    local currentValue = getValue()
    local targetValue = getDataValue("targetValue", 0)

    if (targetValue == 0 or currentValue < (targetValue / 2)) then
        self.highlightOff()
        self.UI.setAttribute("targetValueLabel", "textColor", "rgb(1,1,1)")
        return
    end
    
    local percentage = (currentValue - (targetValue / 2)) / (targetValue / 2)
    percentage = math.max(0, math.min(1, percentage))

    local red = 1
    local green = 1 - percentage 
    local blue = 0
    
    local colorString = "rgb(" .. red .. "," .. green .. "," .. blue .. ")"
    
    self.highlightOn({red, green, blue})
    self.UI.setAttribute("targetValueLabel", "textColor", colorString)
end

function valueUpdated()
    if debounceTimer then
        Wait.stop(debounceTimer)
    end

    debounceTimer = Wait.time(function()
        local currentValue = getValue()
        local targetValue = getDataValue("targetValue", 0)
        local shouldFlash = targetValue > 0 and currentValue >= (targetValue * 0.75)
        
        if shouldFlash then
            local flashInterval = 0.5
            local totalFlashTime = 3 * flashInterval * 2
            
            for i = 1, 3 do
                Wait.time(function()
                    self.highlightOff()
                    self.UI.setAttribute("targetValueLabel", "textColor", "rgba(0,0,0,0)")
                end, (i - 1) * flashInterval * 2)
                
                Wait.time(function()
                    updateHighlightState()
                end, ((i - 1) * flashInterval * 2) + flashInterval)
            end
            
            -- Final check after flash sequence completes
            Wait.time(function()
                updateHighlightState()
            end, totalFlashTime)
        else
            updateHighlightState()
        end
    end, DEBOUNCE_DELAY)
end