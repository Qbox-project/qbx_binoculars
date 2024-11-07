local MAX_FOV = 70.0
local MIN_FOV = 5.0 -- max zoom level (smaller fov is more zoom)
local ZOOM_SPEED = 10.0 -- camera zoom speed
local LR_SPEED = 8.0 -- speed by which the camera pans left-right
local UD_SPEED = 8.0 -- speed by which the camera pans up-down
local binoculars = false
local fov = (MAX_FOV + MIN_FOV) * 0.5

local cam = nil
local scaleform

local function checkInputRotation(zoomValue)
    if not cam then return end

    local rightAxisX = GetControlNormal(0, 220)
    local rightAxisY = GetControlNormal(0, 221)
    local rot = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local newZ = rot.z + rightAxisX * -1.0 * (UD_SPEED) * (zoomValue + 0.1)
        local newX = math.max(math.min(20.0, rot.x + rightAxisY * -1.0 * (LR_SPEED) * (zoomValue + 0.1)), -89.5)
        SetCamRot(cam, newX, 0.0, newZ, 2)
        SetEntityHeading(cache.ped, newZ)
    end
end

local function handleZoom()
    if not cam then return end

    local scrollUpControl = IsPedSittingInAnyVehicle(cache.ped) and 17 or 241
    local scrollDownControl = IsPedSittingInAnyVehicle(cache.ped) and 16 or 242

    if IsControlJustPressed(0, scrollUpControl) then
        fov = math.max(fov - ZOOM_SPEED, MIN_FOV)
    end

    if IsControlJustPressed(0, scrollDownControl) then
        fov = math.min(fov + ZOOM_SPEED, MAX_FOV)
    end

    local currentFov = GetCamFov(cam)
    local fovDifference = fov - currentFov

    if math.abs(fovDifference) > 0.01 then
        local newFov = currentFov + fovDifference * 0.05
        SetCamFov(cam, newFov)
    end
end

local function hideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()

    local hide = {1, 2, 3, 4, 6, 7, 8, 9, 11, 12, 13, 15, 18, 19}
    for i = 1, #hide do
        HideHudComponentThisFrame(hide[i])
    end
end

local function closeBinoculars()
    ClearPedTasks(cache.ped)
    RenderScriptCams(false, true, 500, false, false)

    if cam then
        DestroyCam(cam, false)
        cam = nil
    end

    scaleform:Dispose()
    scaleform = nil
end

local keybind = lib.addKeybind({
    name = 'closeBinoculars',
    description = 'Close Binoculars',
    defaultKey = 'BACK',
    onPressed = function()
        if not binoculars then return end
        binoculars = false
        closeBinoculars()
    end,
})

lib.callback.register('qbx_binoculars:client:toggle', function()
    if cache.vehicle or IsPedSwimming(cache.ped) or QBX.PlayerData.metadata.isdead or QBX.PlayerData.metadata.ishandcuffed or QBX.PlayerData.metadata.inlaststand then return end
    binoculars = not binoculars

    if binoculars then
        TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_BINOCULARS', 0, true)

        cam = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)
        AttachCamToEntity(cam, cache.ped, 0.0, 0.2, 0.7, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(cache.ped), 2)
        RenderScriptCams(true, false, 500, true, false)

        keybind:disable(false)

        scaleform = qbx.newScaleform('BINOCULARS') -- Create a new scaleform
        scaleform:MethodArgs("SET_CAM_LOGO", {0}) -- Set the cam logo
        scaleform:Draw(true) -- Draw the scaleform
    else
        closeBinoculars()
        keybind:disable(true)
    end

    CreateThread(function()
        while binoculars do
            local zoomValue = (1.0 / (MAX_FOV - MIN_FOV)) * (fov - MIN_FOV)
            checkInputRotation(zoomValue)
            handleZoom()
            hideHUDThisFrame()
            Wait(0)
        end
    end)
end)