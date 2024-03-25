RotatableCamera = {}

if RotatableCamera.modName == nil then RotatableCamera.modName = g_currentModName end

function RotatableCamera:onLoad(savegame)    
    self.spec_RotatableCamera = self["spec_"..RotatableCamera.modName..".RotatableCamera"]
end

function RotatableCamera.prerequisitesPresent(specializations)
    return true
end

function RotatableCamera:actionToggleRotation()
    if self.isClient then
        local spec = self.spec_RotatableCamera
        local cam = self.spec_enterable.activeCamera

        if cam ~= nil then
            -- originalIsRotatable is also used to indicate the camera has been changed
            if spec.originalIsRotatable == nil then 
                spec.originalIsRotatable = cam.isRotatable 

                -- These are only required if the camera is originally not rotatable
                if not cam.isRotatable then
                    local rotX, rotY, rotZ = getRotation(cam.rotateNode)
                    spec.originalRotX = rotX
                    spec.originalRotY = rotY
                    spec.originalRotZ = rotZ
                end
            end
            
            -- Toggle rotatable
            cam.isRotatable = not cam.isRotatable
        end
    end
end

function RotatableCamera:actionResetCamera()
    if self.isClient then
        local spec = self.spec_RotatableCamera
        local cam = self.spec_enterable.activeCamera

        -- originalIsRotatable is also used to indicate the camera has been changed
        if cam ~= nil and spec.originalIsRotatable ~= nil then

            -- Reset rotatability regardless of type
            cam.isRotatable = spec.originalIsRotatable

            -- Only reset rotation if the camera was originally fixed
            if not spec.originalIsRotatable then 
                cam.rotX = spec.originalRotX
                cam.rotY = spec.originalRotY
                cam.rotZ = spec.originalRotZ

                spec.originalRotX = nil
                spec.originalRotY = nil
                spec.originalRotZ = nil
            end
            
            spec.originalIsRotatable = nil
        end
    end
end

function RotatableCamera:onRegisterActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_RotatableCamera
        self:clearActionEventsTable(spec.actionEvents)
        RotatableCamera.actionEvents = {} 

        if self:getIsActiveForInput(true) and spec ~= nil then 

            local _, actionEventId = self:addActionEvent(RotatableCamera.actionEvents, InputAction.ROTATABLE_CAMERA_TOGGLE, self, RotatableCamera.actionToggleRotation, false, true, false, true, nil)
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_LOW)
            g_inputBinding:setActionEventTextVisibility(actionEventId, false)
            _, actionEventId = self:addActionEvent(RotatableCamera.actionEvents, InputAction.ROTATABLE_CAMERA_RESET, self, RotatableCamera.actionResetCamera, false, true, false, true, nil)
            g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_LOW)
            g_inputBinding:setActionEventTextVisibility(actionEventId, false)
        end
    end
end

function RotatableCamera.registerEventListeners(vehicleType)
    SpecializationUtil.registerEventListener(vehicleType, "onLoad", RotatableCamera);
    SpecializationUtil.registerEventListener(vehicleType, "onRegisterActionEvents", RotatableCamera);
end
