tool
class_name LevelConfig
extends SurfacerLevelConfig


const ARE_LEVELS_SCENE_BASED := true

const LEVELS_PATH_PREFIX := "res://src/levels/"

var level_manifest := {
    "0": {
        name = "Level 1",
        version = "0.0.1",
        is_test_level = false,
        sort_priority = 10,
        unlock_conditions = "unlocked",
        scene_path = LEVELS_PATH_PREFIX + "level0.tscn",
        platform_graph_character_category_names = [
            "construction_bot",
        ],
        cell_size = Vector2(32.0, 32.0),
        start_energy = 2000,
        bot_capacity = 4,
    },
    "1": {
        name = "Level 2",
        version = "0.0.1",
        is_test_level = false,
        sort_priority = 20,
        unlock_conditions = "unlocked",
        scene_path = LEVELS_PATH_PREFIX + "level1.tscn",
        platform_graph_character_category_names = [
            "construction_bot",
        ],
        cell_size = Vector2(32.0, 32.0),
        start_energy = 2000,
        bot_capacity = 4,
    },
#    "1": {
#        name = "Foo",
#        version = "0.0.1",
#        is_test_level = false,
#        sort_priority = 10,
#        unlock_conditions = "unlocked",
#        scene_path = LEVELS_PATH_PREFIX + "level1.tscn",
#        platform_graph_character_category_names = [
#            "test_character",
#        ],
#        cell_size = Vector2(32.0, 32.0),
#        intro_choreography = [
#            {
#                is_player_interaction_enabled = false,
#                zoom = 0.5,
#            },
#            {
#                duration = 0.3,
#            },
#            {
#                destination = SurfacerLevelConfig \
#                        .INTRO_CHOREOGRAPHY_DESTINATION_GROUP_NAME,
#            },
#            {
#                duration = 0.4,
#                zoom = 1.0,
#            },
#            {
#                is_player_interaction_enabled = true,
#            },
#        ],
#    },
#    "2": {
#        name = "Bar",
#        version = "0.0.1",
#        is_test_level = false,
#        sort_priority = 20,
#        unlock_conditions = "finish_previous_level",
#        scene_path = LEVELS_PATH_PREFIX + "level2.tscn",
#        platform_graph_character_category_names = [
#            "test_character",
#        ],
#        cell_size = Vector2(32.0, 32.0),
#    },
}


func _init().(
        ARE_LEVELS_SCENE_BASED,
        level_manifest) -> void:
    pass
