local data = {}

function onload(saved_data)
	self.interactable = false
 
    setUpUI()
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