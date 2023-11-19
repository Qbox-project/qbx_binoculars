-- Variables
local maxFov = 70.0
local minFov = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomSpeed = 10.0 -- camera zoom speed
local lrSpeed = 8.0 -- speed by which the camera pans left-right
local udSpeed = 8.0 -- speed by which the camera pans up-down
local binoculars = false
local fov = (maxFov + minFov) * 0.5
local storeBinoclarKey = 177 -- backspace

-- Functions
local function checkInputRotation(cam, zoomValue)
    local rightAxisX = GetControlNormal(0, 220)
    local rightAxisY = GetControlNormal(0, 221)
    local rot = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local newZ = rot.z + rightAxisX * -1.0 * (udSpeed) * (zoomValue + 0.1)
        local newX = math.max(math.min(20.0, rot.x + rightAxisY * -1.0 * (lrSpeed) * (zoomValue + 0.1)), -89.5)
        SetCamRot(cam, newX, 0.0, newZ, 2)
        SetEntityHeading(cache.ped, newZ)
    end
end

local function handleZoom(cam)
    local scrollUpControl = IsPedSittingInAnyVehicle(cache.ped) and 17 or 241
    local scrollDownControl = IsPedSittingInAnyVehicle(cache.ped) and 16 or 242

    if IsControlJustPressed(0, scrollUpControl) then
        fov = math.max(fov - zoomSpeed, minFov)
    end

    if IsControlJustPressed(0, scrollDownControl) then
        fov = math.min(fov + zoomSpeed, maxFov)
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

--EVENTS--
local cam = nil
local scaleform = nil
RegisterNetEvent('qbx_binoculars:client:toggle', function()
    if cache.vehicle then return end
    binoculars = not binoculars

    if binoculars then
        TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_BINOCULARS', 0, true)
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        AttachCamToEntity(cam, cache.ped, 0.0, 0.0, 1.0, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(cache.ped), 2)
        RenderScriptCams(true, false, 5000, true, false)
    else
        ClearPedTasks(cache.ped)
        RenderScriptCams(false, true, 1000, false, false)
        SetScaleformMovieAsNoLongerNeeded()
        DestroyCam(cam, false)
        cam = nil
    end

    while binoculars do
        scaleform = lib.requestScaleformMovie('BINOCULARS')
        BeginScaleformMovieMethod(scaleform, 'SET_CAM_LOGO')
        ScaleformMovieMethodAddParamInt(0) -- 0 for nothing, 1 for LSPD logo
        EndScaleformMovieMethod()

        if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle binoculars
            binoculars = false
            ClearPedTasks(cache.ped)
            RenderScriptCams(false, true, 1000, false, false)
            SetScaleformMovieAsNoLongerNeeded()
            DestroyCam(cam, false)
            cam = nil
        end

        local zoomValue = (1.0 / (maxFov - minFov)) * (fov - minFov)
        checkInputRotation(cam, zoomValue)
        handleZoom(cam)
        hideHUDThisFrame()
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        Wait(0)
    end
end)
