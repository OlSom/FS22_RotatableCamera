if g_specializationManager:getSpecializationByName("RotatableCamera") == nil then
    g_specializationManager:addSpecialization(
      "RotatableCamera", 
      "RotatableCamera", 
      Utils.getFilename("RotatableCamera.lua", 
      g_currentModDirectory), 
      nil
    )
end

for typeName, typeEntry in pairs(g_vehicleTypeManager.types) do
  if SpecializationUtil.hasSpecialization(Enterable, typeEntry.specializations) then
       g_vehicleTypeManager:addSpecialization(typeName, "RotatableCamera")
  end
end