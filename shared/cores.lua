Cores = {
    {
        Name = "ESX",
        ResourceName = "es_extended",
        GetFramework = function() return exports["es_extended"]:getSharedObject() end
    },
    {
        Name = "QBCore",
        ResourceName = "qb-core",
        GetFramework = function() return exports["qb-core"]:GetCoreObject() end
    },
    {
        Name = "QBXCore",
        ResourceName = "qbx_core",
        GetFramework = function() return exports["qbx_core"]:GetCoreObject() end
    }
}