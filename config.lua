Config = {}

--                           x          y          z       heading 
Config.Location = vector4(1129.661, -987.9384, 45.97944, 145)
Config.Distance = 5 -- distance view 3dText
Config.PorcentageMax = 50 --max 100
Config.PorcentageMin = 30 -- min 0
Config.Minwashing = 10000 -- min money for washing

--telepoter if you your washman is in moded room enter vector3 else nil
Config.Enter = nil --vector3(1005.9, -3101.3, 5.901041) --
Config.Out = nil--vector3(1138.191, -3199.188, -39.66574) --


--time for washing Money it's working without|| for player offline: the player receve the money in the next connection
Config.time = {
    ["second"] = 15,
    ["minute"] = 0,
    ["hour"] = 0,
    ["days"] = 0
}