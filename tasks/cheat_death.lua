local plugin_label = 'Bosser' -- change to your plugin name

local utils = require "core.utils"
local settings = require 'core.settings'
local enums = require "data.enums"

local status_enum = {
    IDLE = 'idle'
}
local task = {
    name = 'cheat_death', -- change to your choice of task name
    status = status_enum['IDLE']
}

function task.shouldExecute()
    local local_player = get_local_player();
    local is_player_in_bossroom = true --(utils.match_player_zone("Boss_WT4_") or utils.match_player_zone("Boss_WT3_"))
    if settings.cheat_death and is_player_in_bossroom and local_player then
        local player_current_health = local_player:get_current_health();
        local player_max_health = local_player:get_max_health();
        local health_percentage = player_current_health / player_max_health;
        -- console.print("health current : " .. tostring(health_percentage))
        -- console.print("threshold : " .. tostring(settings.escape_percentage / 100))
        return health_percentage <=  (settings.escape_percentage / 100)
    end
    return false
end

function task.Execute()
    -- console.print("run run run run run")
    reset_all_dungeons()
end

return task