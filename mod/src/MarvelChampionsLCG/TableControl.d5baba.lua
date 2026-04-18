local baseImageUrl = Global.getVar("CDN_URL") .. "/tabletops/"
local overridePanelOpen = false

function onload()
	self.interactable = false
	setUpUI()
end

function setUpUI()
	local ui = 
    {
		{
			tag = "Defaults",
			children = {
				{
					tag = "Panel",
					attributes = {
						class = "sectionHeading",
						preferredHeight = "150",
						flexibleHeight = "0",
						padding = "0 0 60 15"
					}
				},
				{
					tag = "Text",
					attributes = {
						class = "sectionHeading",
						rectAlignment = "UpperLeft",
						alignment = "UpperCenter",
						fontSize = "75",
						color = "rgba(1,1,1,1)",
						contentSizeFitter = "vertical"
					}
				},
				{
					tag = "HorizontalLayout",
					attributes = {
						class = "buttonPanel",
						preferredHeight = "90",
						flexibleHeight = "0",
						padding = "70 70 5 5",
						spacing = "40",
						contentSizeFitter = "vertical"
					}
				},
				{
					tag = "Button",
					attributes = {
						class = "overrideButton",
						height = "70",
						flexibleHeight = "0",
						color = "rgba(0,0,0,1)",
						textColor = "rgb(1,1,1)",
						outline = "rgba(1,1,1,1)",
						outlineSize = "1 1",
						fontSize = "60"
					}
				}
        	}
		},
        {
            tag="Panel",
            attributes= {
                height = "160",
                width = "1000",
                position = "0 0 -200",
				color = "rgba(0,0,0,0)",
                rotation = "0 0 180"
            },
            children = {
                {
                    tag = "Button",
                    value = "CHANGE TABLE",
                    attributes = {
                        rectAlignment = "MiddleCenter",
                        onClick = "changeTableButtonClicked",
                        color = "rgba(0,0,0,0)",
                        textColor = "rgb(1,1,1)",
                        height = "160",
                        width = "1000",
                        fontSize = "120",
                        fontStyle = "Bold"
                    }
                },
				{
					tag = "Panel",
					attributes = {
						rectAlignment = "UpperCenter",
						height = "110",
						width = "1000",
						offsetXY = "0 -310",
						color = "rgba(0,0,0,0)"
					},
					children = {
						{
							tag = "Button",
							value = "MANUAL OVERRIDES",
							attributes = {
								id = "overrideButton",
								rectAlignment = "MiddleCenter",
								color = "rgba(0,0,0,0)",
								textColor = "rgb(1,1,1)",
								height = "110",
								width = "1000",
								fontSize = "90",
								fontStyle = "Bold",
								onClick = self.getGUID() .. "/overrideButtonClicked",
							}
						}
					}
				},
				{
					tag = "VerticalLayout",
					attributes = {
						id = "overridesPanel",
						rectAlignment = "UpperCenter",
						offsetXY = "0 -430",
						height = "2000",
						width = "1000",
                		padding = "10 10 0 10",
                		childAlignment = "UpperCenter",
                		childForceExpandHeight = "false",
                		spacing = "0",
                		contentSizeFitter = "vertical",
						color = "rgba(0,0,0,0)",
						active = "false"
					},
					children = {
						{
							tag = "Panel",
							attributes = {
								class = "sectionHeading"
							},
							children = {
								{
									tag = "Text",
									value = "SCENARIO BUTTON",
									attributes = {
										class = "sectionHeading"
									}
								}
							}
						},
						{
							tag = "HorizontalLayout",
							attributes = {
								class = "buttonPanel"
							},
							children = {
								{
									tag = "Button",
									value = "SHOW",
									attributes = {
										class = "overrideButton",
										onClick = self.getGUID() .. "/showScenarioButton"
									}
								},
								{
									tag = "Button",
									value = "HIDE",
									attributes = {
										class = "overrideButton",
										onClick = self.getGUID() .. "/hideScenarioButton"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								class = "sectionHeading"
							},
							children = {
								{
									tag = "Text",
									value = "SCENARIO TOOLBAR",
									attributes = {
										class = "sectionHeading"
									}
								}
							}
						},
						{
							tag = "HorizontalLayout",
							attributes = {
								class = "buttonPanel"
							},
							children = {
								{
									tag = "Button",
									value = "SHOW",
									attributes = {
										class = "overrideButton",
										onClick = self.getGUID() .. "/showScenarioToolbar"
									}
								},
								{
									tag = "Button",
									value = "HIDE",
									attributes = {
										class = "overrideButton",
										onClick = self.getGUID() .. "/hideScenarioToolbar"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								class = "sectionHeading"
							},
							children = {
								{
									tag = "Text",
									value = "HERO BUTTONS",
									attributes = {
										class = "sectionHeading"
									}
								}
							}
						},
						{
							tag = "HorizontalLayout",
							attributes = {
								class = "buttonPanel"
							},
							children = {
								{
									tag = "Button",
									value = "SHOW",
									attributes = {
										class = "overrideButton",
										onClick = self.getGUID() .. "/showPlaymatRemoveButtons"
									}
								},
								{
									tag = "Button",
									value = "HIDE",
									attributes = {
										class = "overrideButton",
										onClick = self.getGUID() .. "/hidePlaymatRemoveButtons"
									}
								}
							}
						}
					}
				}
            }
        }
    }

    self.UI.setXmlTable(ui) 
end

function changeTableButtonClicked(player, value, id)
	local guid = self.getGUID()
    local scenarioUI = {
		{
        	tag = "Defaults",
			children = {
				{
					tag = "Panel",
					attributes = {
						class = "tableButton",
						preferredHeight = "75",
						flexibleHeight = "0",
						color = "rgba(0,0,1,1)",
						textColor = "rgb(1,1,1)",
						fontSize = "60",
						fontStyle = "Bold"
					}
				},
				{
					tag = "Image",
					attrubutes = {
						class = "tableImage",
						width = "300",
						height = "190"
					}
				}
			}
		},
		{
			tag = "Panel",
			attributes = {
				width = "630",
				height = "810",
				color = "rgba(0,0,0,1)",
				contentSizeFitter = "vertical"
			},
			children = {
				{
					tag="GridLayout",
					attributes = {
						width = "630",
						height = "810",
						padding = "10 10 10 10",
						childForceExpandHeight = "false",
						spacing = "10 10",
						cellSize = "300 190",
						startAxis = "Vertical",
						Constraint = "FixedRowCount",
						ConstraintCount = "4",
						color = "rgba(0,0,0,1)"
					},
					children = {
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-marvel-black",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-marvel-black.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-marvel-blue",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-marvel-blue.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-marvel-yellow",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-marvel-yellow.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-classic",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-classic.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-felt-black",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-felt-black.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-felt-blue",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-felt-blue.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-felt-green",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-felt-green.png"
									}
								}
							}
						},
						{
							tag = "Panel",
							attributes = {
								id = "tabletop-felt-red",
								class = "tableButton",
								onClick = guid .. "/setTableImage"
							},
							children = {
								{
									tag = "Image",
									attributes = {
										class = "tableImage",
										image = baseImageUrl .. "tabletop-thumbnail-felt-red.png"
									}
								}
							}
						}
					}
				}
			}
		}
	}

    Global.UI.setXmlTable(scenarioUI)
end

function overrideButtonClicked(player, value, id)
	if overridePanelOpen then
		self.UI.hide("overridesPanel")
		self.UI.setAttribute("overrideButton", "text", "MANUAL OVERRIDES")
		self.UI.setAttribute("overrideButton", "textColor", "rgba(1,1,1,1)")
		overridePanelOpen = false
	else
		self.UI.show("overridesPanel")
		self.UI.setAttribute("overrideButton", "text", "HIDE OVERRIDES")
		self.UI.setAttribute("overrideButton", "textColor", "rgba(1,1,1,1)")
		overridePanelOpen = true
	end
end

function setTableImage(player, value, id)
	Global.call("showScenarioControlPanel")
	local currentCover = Global.call("findObjectByTag", {tag="table-cover"})
	local tableUrl = baseImageUrl .. id .. ".png"

	local tableJson = [[
		{
			"Name": "Custom_Tile",
			"Transform": {
				"posX": 0.0,
				"posY": -2,
				"posZ": 0.0,
				"rotX": 0.0,
				"rotY": 180.0,
				"rotZ": 0.0,
				"scaleX": 28.0,
				"scaleY": 1.0,
				"scaleZ": 28.0
			},
			"Nickname": "",
			"Description": "",
			"GMNotes": "",
			"ColorDiffuse": {
				"r": 1.0,
				"g": 1.0,
				"b": 1.0
			},
			"Locked": true,
			"Grid": true,
			"Snap": true,
			"IgnoreFoW": false,
			"Autoraise": true,
			"Sticky": true,
			"Tooltip": true,
			"GridProjection": false,
			"HideWhenFaceDown": false,
			"Hands": false,
			"XmlUI": "",
			"Tags": [
				"table-cover"
			],
			"CustomImage": {
				"ImageURL": "]] .. tableUrl .. [[",
				"ImageSecondaryURL": "",
				"ImageScalar": 1,
				"WidthScale": 0,
				"CustomTile": {
					"Type": 0,
					"Thickness": 0.1,
					"Stackable": false,
					"Stretch": true
				}
			},
			"LuaScript": "function onload() self.interactable = false end",
			"LuaScriptState": "",
			"GUID": "tablecover"
		}]]

	spawnObjectJSON({
		json = tableJson,
		callback_function = function(spawned_object)
			Wait.frames(function()
				spawned_object.setPosition({0, 0.85, 0})
				if currentCover ~= nil then
					currentCover.destroy()
				end
			end,
			30)
		end
	})
end

function showScenarioButton()
	local scenarioButton = getObjectFromGUID(Global.getVar("GUID_SCENARIO_BUTTON"))
	scenarioButton.call("showUI")
end

function hideScenarioButton()
	local scenarioButton = getObjectFromGUID(Global.getVar("GUID_SCENARIO_BUTTON"))
	scenarioButton.call("hideUI")
end

function showScenarioToolbar()
	local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
	scenarioManager.call("showScenarioControlPanel")
end

function hideScenarioToolbar()
	Global.UI.setXml("")
end

function showPlaymatRemoveButtons()
	local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
	heroManager.call("showHeroSelection", {skipScenarioCheck = true})
end

function hidePlaymatRemoveButtons()
	local heroManager = getObjectFromGUID(Global.getVar("GUID_HERO_MANAGER"))
	heroManager.call("hideHeroSelection")
end