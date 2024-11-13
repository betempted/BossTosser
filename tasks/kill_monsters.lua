local utils      = require "core.utils"
local enums      = require "data.enums"
local settings   = require "core.settings"
local navigation = require "core.navigation"
local explorer   = require "core.explorer"
local tracker    = require "core.tracker"

local stuck_position = nil

local task = {
    name = "Kill Monsters",
    shouldExecute = function()
        if not utils.player_on_quest(get_current_world():get_current_zone_name()) then
            return false
        end

        local close_enemy = utils.get_closest_enemy()
        return close_enemy ~= nil
    end,
    Execute = function()
        local player_pos = get_player_position()

        if explorer.check_if_stuck() then
            stuck_position = player_pos
            return false
        end

        if stuck_position and utils.distance_to(stuck_position) < 10 then
            return false
        else
            stuck_position = nil
        end

        local enemy = utils.get_closest_enemy()
        if not enemy then return false end

        local within_distance = utils.distance_to(enemy) < 6.5
        
        tracker.finished_time = 0
        tracker.start_time = 0

        if not within_distance then
            local enemy_pos = enemy:get_position()

            explorer:clear_path_and_target()
            explorer:set_custom_target(enemy_pos)
            explorer:move_to_target()
        end
    end
}

return task