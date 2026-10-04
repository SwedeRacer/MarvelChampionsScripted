function onload(saved_data)
    -- createBoostButton()
    setUpUI()
end

function createBoostButton()
    self.createButton({
        label = "BOOST",
        click_function = "drawBoost",
        function_owner = self,
        position = {-1, 0.1, 0},
        rotation = {0, 0, 0},
        width = 3400,
        height = 1500,
        font_size = 1700,
        color = {1, 1, 0}
    })

    self.createButton({
        label = "X",
        click_function = "discardBoost",
        function_owner = self,
        position = {4, 0.1, 0},
        rotation = {0, 0, 0},
        width = 1000,
        height = 1500,
        font_size = 1700,
        color = {1, 0, 0}
    })
end

function setUpUI()
    local ui = {{
        tag = "Panel",
        attributes = {
            height = "200",
            width = "1000",
            color = "rgba(0,0,0,0)",
            position = "0 0 -20",
            rotation = "0 0 180"
        },
        children = {{
            tag = "Button",
            value = "BOOST",
            attributes = {
                rectAlignment = "MiddleLeft",
                onClick = "drawBoost",
                color = "rgb(1,1,0)",
                textColor = "rgb(0,0,0)",
                scale = "0.25 0.25",
                height = "1200",
                width = "2950",
                fontSize = "1000",
                fontStyle = "Bold"
            }
        }, {
            tag = "Button",
            value = "X",
            attributes = {
                rectAlignment = "MiddleRight",
                onClick = "discardBoost",
                color = "rgb(1,0,0)",
                textColor = "rgb(0,0,0)",
                scale = "0.25 0.25",
                height = "1200",
                width = "850",
                fontSize = "1000",
                fontStyle = "Bold"
            }
        }}
    }}

    self.UI.setXmlTable(ui)
end

function drawBoost(object, player, isRightClick)
    Global.call("drawBoostcard")
end

function discardBoost(object, player, isRightClick)
    Global.call("discardBoostcard")
end
