--!nocheck
--!nolint
task.spawn(function()
    repeat task.wait() until shared["_db/autosavetimer"] ~= nil
    local resetCounterValue = shared["_db/autosavetimer"]

    while true do
        local threshold = task.wait();
        if (not shared["_db/environment"].studiomode and shared["_db/autosavetimer"] > 0) then 
            shared["_db/autosavetimer"] -= threshold
            continue 
        end
        
        if not (shared["_db/memory"]) then shared["_db/memory"] = {}; continue end
        if (shared["_db/memory"] == {}) then continue end
        local storedMemory = shared["_db/memory"]
        shared["_db/memory"] = {}

        for key, data in storedMemory do
            game:GetService("DataStoreService"):GetDataStore(shared["_db/info"].datastorename):UpdateAsync(key, function(currentData)
                currentData = currentData or {}
                
                if (key == shared["_db/keys"].settingsdata) and shared["_db/environment"].studiomode then
                    return data
                end

                if (key == shared["_db/keys"].donationsdata) then
                    for entryKey, data in data do
                        currentData[entryKey] = data
                    end
                    
                    return currentData
                end

                return currentData
            end)
        end
    
        shared["_db/autosavetimer"] = resetCounterValue
    end
end)
    

return nil