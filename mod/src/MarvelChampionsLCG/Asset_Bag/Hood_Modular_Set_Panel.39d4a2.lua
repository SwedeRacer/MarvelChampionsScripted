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
                width="300",
                color="rgba(0,0,0,0)",
                position="0 0 -12",
                rotation="0 0 180"
            },
            children={
                {
                  tag="Panel",
                  attributes={
                      width="195",
                      height="20",
                      color="rgba(0,0,0,0.75)",
                      rectAlignment="UpperCenter",
                      offsetXY="0 -5"
                  },
                  children={
                      {
                          tag="Text",
                          value="7 SETS REMAINING",
                          attributes={
                              id="remainingSets",
                              fontSize="80",
                              scale="0.25 0.25",
                              width="1000",
                              height="120",
                              rectAlignment="MiddleCenter",
                              color="rgb(1,1,1)"
                          }
                      }
                  }
                },
                {
                    tag="Button",
                    value="ADD ENCOUNTER SET",
                    attributes={
                        id="releaseButton",
                        rectAlignment="LowerCenter",
                        offsetXY="0 10",
                        onClick="addEncounterSet",
                        textColor="rgb(1,1,1)",
                        color="rgba(0,0,1,1)",
                        scale="0.25 0.25",
                        height="100",
                        width="950",
                        fontSize="80",
                        fontStyle="Bold"
                    }
                }
            }
        }
    }
 
    self.UI.setXmlTable(ui)
end

function addEncounterSet()
    local scenarioManager = getObjectFromGUID(Global.getVar("GUID_SCENARIO_MANAGER"))
    local remainingSets = scenarioManager.call("addHoodEncounterSet")

    local setLabel = 
        remainingSets == 0 and "NO SETS" or
        remainingSets == 1 and "1 SET" or 
        tostring(remainingSets) .. " SETS"

    self.UI.setAttribute("remainingSets", "text", setLabel .. " REMAINING")
end
