local data = {}

function onload(saved_data)
	self.interactable = false

    loadSavedData(saved_data)
 
    setUpUI()
end

function loadSavedData(saved_data)
    if saved_data ~= "" then
       local loaded_data = JSON.decode(saved_data)
       data = loaded_data
    end
end
 
function setValue(key, value)
    data[key] = value
    local saved_data = JSON.encode(data)
    self.script_state = saved_data
end
 
function getValue(key, default)
    if data[key] == nil then
       return default
    end
 
    return data[key]
end

function setUpUI()
    local ui = 
    {
        {
            tag="Panel",
            attributes={
                height="200",
                width="125",
                color="rgba(0,0,0,0)",
                position="0 0 -12",
                rotation="0 0 180"
            },
            children={
                {
                    tag="Text",
                    value="SHOW DECK",
                    attributes={
                        fontSize="80",
                        scale="0.25 0.25",
                        width="1000",
                        height="120",
                        rectAlignment="UpperCenter",
                        offsetXY="0 -5",
                        color="rgb(1,1,1)"
                    }
                },
                {
                    tag="Button",
                    value="DRAW",
                    attributes={
                        id="releaseButton",
                        rectAlignment="LowerCenter",
                        offsetXY="0 10",
                        onClick="drawButtonClicked",
                        textColor="rgb(1,1,1)",
                        color="rgb(0.3,0.6,1)",
                        scale="0.25 0.25",
                        height="80",
                        width="250",
                        fontSize="60",
                        fontStyle="Bold"
                    }
                }
            }
        }
    }
 
    self.UI.setXmlTable(ui)
end

function drawButtonClicked()
	local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
	scenarioManager.call("spiralDrawShowCard")
end