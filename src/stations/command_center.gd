tool
class_name CommandCenter
extends Station


const ENTITY_COMMAND_TYPE := CommandType.STATION_COMMAND

const OUTLET_OFFSETS := [
    Vector2(-24.0, -15.0),
    Vector2(-19.0, -15.0),
    Vector2(-24.0, -10.0),
    Vector2(-19.0, -10.0),
]

# Array<Dictionary<Bot|Station, true>>
var outlets := []

# Dictionary<Bot|Station, int>
var entity_to_outlet_index := {}


func _init().(ENTITY_COMMAND_TYPE) -> void:
    shield_activated = true
    
    outlets.resize(4)
    for i in outlets.size():
        outlets[i] = {}


func _ready() -> void:
    Sc.slow_motion.set_time_scale_for_node($ShaderOutlineableAnimatedSprite)


func get_buttons() -> Array:
    return [
        CommandType.RUN_WIRE,
#        CommandType.BOT_CONSTRUCTOR,
#        CommandType.BOT_LINE_RUNNER,
#        CommandType.BOT_BARRIER,
    ]


func _get_radial_menu_item_types() -> Array:
    return [
        CommandType.RUN_WIRE,
        CommandType.BOT_CONSTRUCTOR,
        CommandType.BOT_LINE_RUNNER,
        CommandType.BOT_BARRIER,
        CommandType.STATION_LINK_TO_MOTHERSHIP,
        CommandType.STATION_INFO,
    ]


func _update_outline() -> void:
    $ShaderOutlineableAnimatedSprite.is_outlined = \
            active_outline_alpha_multiplier > 0.0
    $ShaderOutlineableAnimatedSprite.outline_color = outline_color
    $ShaderOutlineableAnimatedSprite.outline_color.a *= \
            active_outline_alpha_multiplier


func get_next_outlet_index() -> int:
    var min_connected_index := -1
    var min_connection_count := INF
    for i in outlets.size():
        if outlets[i].size() < min_connection_count:
            min_connection_count = outlets[i].size()
            min_connected_index = i
    return min_connected_index


func _on_plugged_into_bot(bot) -> void:
    ._on_plugged_into_bot(bot)
    assert(!entity_to_outlet_index.has(bot))
    var i := get_next_outlet_index()
    outlets[i][bot] = true
    entity_to_outlet_index[bot] = i


func _on_unplugged_from_bot(bot) -> void:
    ._on_unplugged_from_bot(bot)
    assert(entity_to_outlet_index.has(bot))
    var i: int = entity_to_outlet_index[bot]
    outlets[i].erase(bot)
    entity_to_outlet_index.erase(bot)


func _on_replaced_bot_plugin_with_station(
        bot,
        destination_station: Station) -> void:
    ._on_replaced_bot_plugin_with_station(bot, destination_station)
    assert(entity_to_outlet_index.has(bot))
    assert(!entity_to_outlet_index.has(destination_station))
    var i: int = entity_to_outlet_index[bot]
    outlets[i].erase(bot)
    entity_to_outlet_index.erase(bot)
    outlets[i][destination_station] = true
    entity_to_outlet_index[destination_station] = i


func _on_plugged_into_station(origin_station: Station) -> void:
    ._on_plugged_into_station(origin_station)
    assert(!entity_to_outlet_index.has(origin_station))
    var i := get_next_outlet_index()
    outlets[i][origin_station] = true
    entity_to_outlet_index[origin_station] = i


func _on_disconnected_from_station(other: Station) -> void:
    ._on_disconnected_from_station(other)
    assert(entity_to_outlet_index.has(other))
    var i: int = entity_to_outlet_index[other]
    outlets[i].erase(other)
    entity_to_outlet_index.erase(other)


func get_power_line_attachment_position(entity_on_other_end) -> Vector2:
    var i: int = entity_to_outlet_index[entity_on_other_end]
    var wire_attachment_offset: Vector2 = OUTLET_OFFSETS[i]
    return self.position + wire_attachment_offset
