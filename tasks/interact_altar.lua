-- Import required modules
local utils      = require "core.utils"
local enums      = require "data.enums"
local tracker    = require "core.tracker"
local explorer   = require "core.explorer"
local settings   = require "core.settings"

-- Function to find and return the altar actor
local function interact_with_altar()
    local actors = actors_manager:get_all_actors()
    for _, actor in pairs(actors) do
        local name = actor:get_skin_name()
        -- Check if the actor is one of the boss altars
        if name == "Boss_WT4_Varshan" or name == "Boss_WT4_Duriel" or name == "Boss_WT4_PenitantKnight" or name == "Boss_WT4_Andariel" or name == "Boss_WT4_MegaDemon" or name == "Boss_WT4_S2VampireLord" then
            return actor
        end
    end
    return nil
end

-- Variable to track the time when the boss was last summoned
local boss_summon_time = 0

-- Define the task
local task = {
    name = "Interact Altar",
    
    -- Function to determine if the task should be executed
    shouldExecute = function()
        local is_in_boss_zone = utils.match_player_zone("Boss_WT4_") or utils.match_player_zone("Boss_WT3_")
        return is_in_boss_zone and interact_with_altar()
    end,

    -- Main execution function for the task
    Execute = function()
        local current_time = get_time_since_inject()
        
        -- Wait for 5 seconds after boss summon before allowing interaction again
        if boss_summon_time > 0 and current_time - boss_summon_time < 1 then
            return
        end

        local altar = interact_with_altar()
        if altar then
            local actor_position = altar:get_position()
            -- Move towards the altar if not close enough
            if utils.distance_to(actor_position) > 2 then
                pathfinder.force_move_raw(actor_position)
            end

            -- Interact with the altar when close enough
            if utils.distance_to(actor_position) <= 2 then
                interact_object(altar)
                utility.summon_boss()
                settings.altar_activated = true
                boss_summon_time = current_time  -- Update the boss summon time
            end
        end

        -- Mark the task as not running
        explorer.is_task_running = false
    end
}

-- Return the task
return task