local screenX, screenY = guiGetScreenSize()
sx, sy = (screenX/1366), (screenY/768)

function reMap(value, low1, high1, low2, high2)

	return low2 + (value - low1) * (high2 - low2) / (high1 - low1);

end

local responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1);


function loadFonts()

    guiSetInputMode("no_binds_when_editing");
    fonts = {
        Roboto11 = dxCreateFont("assets/fonts/RobotoCondensed-Regular.ttf", respc(11), false, "antialiased") or "default",
        Roboto14 = dxCreateFont("assets/fonts/RobotoCondensed-Regular.ttf", respc(14), false, "antialiased")or "default",
        Roboto16 =  dxCreateFont("assets/fonts/RobotoCondensed-Regular.ttf", respc(16), false, "cleartype")or "default",
        Roboto18 =  dxCreateFont("assets/fonts/RobotoCondensed-Regular.ttf", respc(18), false, "cleartype")or "default",
        RobotoB18 =  dxCreateFont("assets/fonts/RobotoCondensed-Bold.ttf", respc(18), false, "antialiased")or "default",
    }

end

local registerEvent = function(eventName, element, func)

	addEvent(eventName, true);
	addEventHandler(eventName, element, func);

end

addEventHandler("onAssetsLoaded", root, function ()

	loadFonts();

end)

addEventHandler("onClientResourceStart", resourceRoot, function ()

	loadFonts();

end)

function resp(value)

    return value * responsiveMultipler;

end

function respc(value)

    return math.ceil(value * responsiveMultipler);

end

Interaction = {}

local selectedElement = nil;
local elementInteractions = {};
local panelW, panelH = respc(300), respc(65);
local panelX, panelY = (screenX - panelW) / 4, (screenY - panelH) / 2;
local scrollbarW = respc(12);
local iconW, iconH = respc(40), respc(40);
local rowW, rowH =  panelW, respc(40);
local rowX = panelX;
local actionTextX = panelX + iconH + respc(10)
local maxRow = 6
local interactionActive = false

Interaction.Show = function(element)

    elementInteractions = pull(element);
    if #elementInteractions > 0 then
        effectOn = true;
        createElementOutlineEffect(element, true);
        selectedElement = element;
        interactionActive = true;
    	removeEventHandler("onClientRender", root, Interaction.Render);
        addEventHandler("onClientRender", root, Interaction.Render);
    end

end

Interaction.Close = function()

    elementInteractions = {};
    interactionActive = false;
    destroyElementOutlineEffect(selectedElement);
    effectOn = false;
    removeEventHandler("onClientRender", root, Interaction.Render);

end

Interaction.Render = function()

    if interactionActive then

        Interaction.Panel(elementInteractions);

    end

end

Interaction.Panel = function(interactions)

    if interactionActive then

        local px, py, pz = getElementPosition(localPlayer)
        local ex, ey, ez = getElementPosition(selectedElement)

        if getDistanceBetweenPoints3D(px, py, pz, ex, ey, ez) > getElementRadius(selectedElement) * 2 then

            Interaction.Close();
            return;

        end

        local adjustH = #interactions;
        if #interactions > 6 then

            adjustH = maxRow;

        end

        if getElementType(selectedElement) == "vehicle" then

			textW = 200;
            panelW = textW + respc(70);
            rowW = textW + respc(70);

        end

        local interactionOffset = scrollData["interactionOffset"] or 0;
        local calculatedRowW = rowW;
        if #interactions > adjustH then

            drawScrollbar("interaction", rowX + rowW - scrollbarW, panelY + panelH, scrollbarW, rowH * adjustH, adjustH, #interactions);
            calculatedRowW = rowW - scrollbarW;

        end

        for i = 1, adjustH do

            local interaction = interactions[i + interactionOffset];
            if interaction then

	            local rowY = panelY + panelH + (rowH * (i - 1));
	            dxDrawInteractionButton("interaction:" .. i, interaction[1], rowX, rowY + (i*3), calculatedRowW, rowH, {47, 51, 61, 255}, {150, 150, 255, 255}, {255, 255, 255}, fonts.Roboto11, "left", "center", interaction[2], iconW, iconH, {77, 81, 91});

	        end

        end

        activeButtonChecker();

    end
end

function inDistance3D(element1, element2, distance)

	if isElement(element1) and isElement(element2) then

	    local x1, y1, z1 = getElementPosition(element1);
	    local x2, y2, z2 = getElementPosition(element2);
	    local distance2 = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2);

	    if distance2 <= distance then

	        return true, distance2;

	    end

	end

    return false, 99999;

end


addEventHandler("onClientClick", root, 

    function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)

        if bankPanel then return end;
        if button == "right" and state == "down" then

            if not interactionActive then

                local cameraX, cameraY, cameraZ = getCameraMatrix();
                worldX, worldY, worldZ = (worldX - cameraX) * 200, (worldY - cameraY) * 200, (worldZ - cameraZ) * 200;

                local _, _, _, _, hitElement = processLineOfSight(cameraX, cameraY, cameraZ, worldX + cameraX, worldY + cameraY, worldZ + cameraZ, false, true, true, true, false, false, false, false, localPlayer);
                if hitElement then

                    clickedElement = hitElement;

                end

                if isElement(clickedElement) then

                    if getElementData(clickedElement, "amazing >> haveInteraction") or getElementType(clickedElement) == "player" or getElementType(clickedElement) == "vehicle" then
                        
                        if inDistance3D(clickedElement, localPlayer, getElementRadius(clickedElement) * 3.5) then

                            if clickedElement ~= selectedElement then
                                
                                destroyElementOutlineEffect(selectedElement);
                                effectOn = false;
                            
                            end

                            Interaction.Show(clickedElement);

                        end

                    end


                end

            end

        elseif button == "left" and state == "down" then

            if interactionActive then

                for i = 1, #elementInteractions do

                    if activeButton == "interaction:" .. i then

                        local k = i + scrollData["interactionOffset"];
                        if elementInteractions[k][3] then 

                            if type(elementInteractions[k][3]) == "string" then

                                triggerEvent(elementInteractions[k][3], localPlayer, selectedElement, i - 1);

                            else

                                elementInteractions[k][3](localPlayer, selectedElement, i - 1);

                            end

                        end
                        
                        if elementInteractions[k] and elementInteractions[k][4] then

                            Interaction.Close();

                        end
                        
                    end

                end

            end

        end

    end

)

addEventHandler("onClientKey", getRootElement(),

    function (key, press)

        if interactionActive then

            if press then

                local offset = scrollData["interactionOffset"] or 0;
                if key == "mouse_wheel_down" and offset < #elementInteractions - maxRow then

                    offset = offset + 1;

                elseif key == "mouse_wheel_up" and offset > 0 then

                    offset = offset - 1;

                end

                scrollData["interactionOffset"] = offset;

            end

        end

    end

)
