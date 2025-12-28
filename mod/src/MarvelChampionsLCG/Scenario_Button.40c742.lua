function onload(saved_data)
    self.interactable = false
end

function showUI()
    local buttonImageUrl = Global.getVar("CDN_URL") .. "/assets/scenario-setup-button-v2.png"
    
	local ui = 
    {
        {
            tag="Panel",
            attributes= {
                height = "100",
                width = "300",
                position = "0 0 -198",
				color = "rgba(0,0,0,0)",
                rotation = "0 0 180"
            },
            children = {
                {
                    tag = "Image",
                    attributes = {
                        image = buttonImageUrl,
                        position = "-380 430 0",
                        height = "1838",
                        width = "2912"
                    }
                },
                {
                    tag = "Button",
                    attributes = {
                        rectAlignment = "MiddleCenter",
                        onClick = "displayScenarioSelectionUI",
                        color = "rgba(0,0,0,0)",
                        height = "550",
                        width = "1400",
                        fontSize = "120",
                        fontStyle = "Bold"
                    }
                }
            }
        }
    }

    self.UI.setXmlTable(ui) 
end

function hideUI()
    self.UI.setXml("")
end

function displayScenarioSelectionUI()
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    scenarioManager.call("displayScenarioSelectionUI")
end