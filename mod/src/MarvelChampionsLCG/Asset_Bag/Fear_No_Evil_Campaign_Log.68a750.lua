require('!/components/campaign_log')

function setUpUI()
    local ui = {{
        tag = "Defaults",
        children = {{
            tag = "InputField",
            class = "campaignLogField",
            attributes = {
                navigation = "None",
                textOffset = "2 2 2 2",
                color = "rgba(1,1,1,0.35)",
                scale = "0.25 0.25",
                placeholder = " ",
                textAlignment = "MiddleCenter",
                characterValidation = "Integer",
                onValueChanged = "textValueChanged"
            }
        }, {
            tag = "Toggle",
            class = "campaignLogField",
            attributes = {
                toggleWidth = "52.5",
                toggleHeight = "52.5",
                scale = "0.25 0.25",
                colors = "rgba(1,1,1,0.1)|rgba(1,1,1,0.1)|rgba(1,1,1,0.1)|rgba(1,1,1,0.1)",
                onValueChanged = "toggleValueChanged"
            }
        }}
    }, {
        tag = "Panel",
        attributes = {
            height = "370",
            width = "370",
            color = "rgba(0,0,0,0)",
            position = "0 0 -6",
            rotation = "0 0 180"
        },
        children = {{
            tag = "InputField",
            attributes = {
                id = "player1Identity",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "340",
                offsetXY = "-132 119",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "player1HitPoints",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "-127 100.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "player2Identity",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "340",
                offsetXY = "-44 119",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "player2HitPoints",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "-38 100.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "player3Identity",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "340",
                offsetXY = "44 119.25",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "player3HitPoints",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "47.5 100.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "player4Identity",
                class = "campaignLogField",
                fontSize = "44",
                height = "60",
                width = "340",
                offsetXY = "132 119",
                characterValidation = "None"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "player4HitPoints",
                class = "campaignLogField",
                fontSize = "26",
                height = "45",
                width = "75",
                offsetXY = "136.5 100.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario1Completed",
                class = "campaignLogField",
                offsetXY = "-152.74 57"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenario1Villain",
                class = "campaignLogField",
                fontSize = "44",
                height = "75",
                width = "510",
                offsetXY = "11 57",
                characterValidation = "None"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario1Progress1",
                class = "campaignLogField",
                offsetXY = "93 57"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario1Progress2",
                class = "campaignLogField",
                offsetXY = "126.25 57"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario1Failed",
                class = "campaignLogField",
                offsetXY = "159.5 57"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario2Completed",
                class = "campaignLogField",
                offsetXY = "-152.74 34.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenario2Villain",
                class = "campaignLogField",
                fontSize = "44",
                height = "75",
                width = "510",
                offsetXY = "11 34.5",
                characterValidation = "None"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario2Progress1",
                class = "campaignLogField",
                offsetXY = "93 34.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario2Progress2",
                class = "campaignLogField",
                offsetXY = "126.25 34.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario2Failed",
                class = "campaignLogField",
                offsetXY = "159.5 34.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario3Completed",
                class = "campaignLogField",
                offsetXY = "-152.74 12"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenario3Villain",
                class = "campaignLogField",
                fontSize = "44",
                height = "75",
                width = "510",
                offsetXY = "11 12",
                characterValidation = "None"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario3Progress1",
                class = "campaignLogField",
                offsetXY = "93 12"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario3Progress2",
                class = "campaignLogField",
                offsetXY = "126.25 12"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario3Failed",
                class = "campaignLogField",
                offsetXY = "159.5 12"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario4Completed",
                class = "campaignLogField",
                offsetXY = "-152.74 -10.5"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenario4Villain",
                class = "campaignLogField",
                fontSize = "44",
                height = "75",
                width = "510",
                offsetXY = "11 -10.5",
                characterValidation = "None"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario4Progress1",
                class = "campaignLogField",
                offsetXY = "93 -10.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario4Progress2",
                class = "campaignLogField",
                offsetXY = "126.25 -10.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario4Failed",
                class = "campaignLogField",
                offsetXY = "159.5 -10.5"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario5Completed",
                class = "campaignLogField",
                offsetXY = "-152.74 -33"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "scenario5Villain",
                class = "campaignLogField",
                fontSize = "44",
                height = "75",
                width = "510",
                offsetXY = "11 -33",
                characterValidation = "None"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario5Progress1",
                class = "campaignLogField",
                offsetXY = "93 -33"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario5Progress2",
                class = "campaignLogField",
                offsetXY = "126.25 -33"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "scenario5Failed",
                class = "campaignLogField",
                offsetXY = "159.5 -33"
            }
        }, {
            tag = "InputField",
            attributes = {
                id = "removedAlliesAndSupports",
                class = "campaignLogField",
                fontSize = "32",
                height = "390",
                width = "1010",
                textAlignment = "UpperLeft",
                textOffset = "10 10 5 5",
                lineType = "MultiLineNewLine",
                offsetXY = "46 -107.5",
                characterValidation = "None"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "trustEstablished",
                class = "campaignLogField",
                offsetXY = "-15 -167.75"
            }
        }, {
            tag = "Toggle",
            attributes = {
                id = "maryDefeated",
                class = "campaignLogField",
                offsetXY = "56 -167.75"
            }
        }}
    }}

    self.UI.setXmlTable(ui)

    Wait.frames(function()
        populateLog()
    end, 30)
end
