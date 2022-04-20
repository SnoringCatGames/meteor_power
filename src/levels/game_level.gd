tool
class_name GameLevel
extends SurfacerLevel


const _CONSTRUCTOR_BOT_SCENE := preload(
        "res://src/characters/construction_bot/construction_bot.tscn")
const _COMMAND_CENTER_SCENE := preload("res://src/stations/command_center.tscn")
const _EMPTY_STATION_SCENE := preload("res://src/stations/empty_station.tscn")
const _SOLAR_COLLECTOR_SCENE := preload(
        "res://src/stations/solar_collector.tscn")


const ENERGY_COST_PER_BUTTON := {
    OverlayButtonType.MOVE: 1,
    OverlayButtonType.DESTROY: 10,
    
    OverlayButtonType.RUN_WIRE: 30,
    
    OverlayButtonType.COMMAND_CENTER: 500,
    OverlayButtonType.SOLAR_COLLECTOR: 300,
    OverlayButtonType.SCANNER_STATION: 500,
    OverlayButtonType.BATTERY_STATION: 500,
    
    OverlayButtonType.BUILD_CONSTRUCTOR_BOT: 200,
    OverlayButtonType.BUILD_LINE_RUNNER_BOT: 1000,
    OverlayButtonType.BUILD_REPAIR_BOT: 1000,
    OverlayButtonType.BUILD_BARRIER_BOT: 1000,
    
    OverlayButtonType.DYNAMIC_POWER_LINE_HIT: 20,
    OverlayButtonType.STATIC_POWER_LINE_HIT: 10,
    OverlayButtonType.STATION_HIT: 40,
    OverlayButtonType.BOT_HIT: 80,
    
    OverlayButtonType.BOT_ALIVE: 1,
}

var _nav_preselection_camera: NavigationPreselectionCamera

var bot_selector: BotSelector

var command_center: CommandCenter

var main_bot: ConstructionBot

var meteor_controller: MeteorController

# Array<Station>
var stations := []

# Array<Bot>
var bots := []

# Array<PowerLine>
var power_lines := []

var _first_selected_station_for_running_power_line: Station = null


func _load() -> void:
    ._load()
    
    Sc.gui.hud.set_up()


func _start() -> void:
    ._start()
    
    _nav_preselection_camera = NavigationPreselectionCamera.new()
    add_child(_nav_preselection_camera)
    
    Sc.levels.session.current_energy = LevelSession.START_ENERGY
    Sc.levels.session.total_energy = LevelSession.START_ENERGY
    
    bot_selector = BotSelector.new()
    add_child(bot_selector)
    
    command_center = Sc.utils.get_child_by_type($Stations, CommandCenter)
    Sc.level._on_station_created(command_center)
    
    var empty_stations := \
            Sc.utils.get_children_by_type($Stations, EmptyStation)
    for empty_station in empty_stations:
        Sc.level._on_station_created(empty_station)
    
    main_bot = add_bot("constructor_bot")
    
    for station in stations:
        station._on_level_started()
    for bot in bots:
        bot._on_level_started()
    
    meteor_controller = MeteorController.new()
    self.add_child(meteor_controller)
    
    _override_for_level()


func _override_for_level() -> void:
    if level_id == "0":
        pass
    elif level_id == "1":
        pass
    else:
        Sc.logger.error("GameLevel._override_for_level")


func _destroy() -> void:
    ._destroy()
    for station in stations:
        station.queue_free()
    for power_line in power_lines:
        power_line.queue_free()


#func _on_initial_input() -> void:
#    ._on_initial_input()


#func quit(immediately := true) -> void:
#    .quit(immediately)


#func _on_intro_choreography_finished() -> void:
#    ._on_intro_choreography_finished()


#func pause() -> void:
#    .pause()


#func on_unpause() -> void:
#    .on_unpause()


func _on_bot_selection_changed(selected_bot) -> void:
#    Sc.logger.print("GameLevel._on_bot_selection_changed")
    clear_station_selection()
    for station in stations:
        station._on_bot_selection_changed(selected_bot)
    for bot in bots:
        bot.set_is_selected(bot == selected_bot)
    if is_instance_valid(selected_bot):
        _nav_preselection_camera.target_character = selected_bot
        swap_camera(_nav_preselection_camera)
    else:
        swap_camera(_default_camera)


func deduct_energy_for_action(button_type: int) -> void:
    if Sc.levels.session.current_energy == 0:
        return
    var energy_cost: int = ENERGY_COST_PER_BUTTON[button_type]
    Sc.levels.session.current_energy -= energy_cost
    Sc.levels.session.current_energy = max(Sc.levels.session.current_energy, 0)
    if Sc.levels.session.current_energy == 0:
        Sc.level.quit(false, false)


func add_energy(enery: int) -> void:
    if Sc.levels.session.current_energy == 0:
        return
    Sc.levels.session.current_energy += enery
    Sc.levels.session.total_energy += enery


func _on_station_button_pressed(
        station: Station,
        button_type: int) -> void:
    var bot: Bot = bot_selector.selected_bot
    match button_type:
        OverlayButtonType.DESTROY:
            bot.move_to_destroy_station(station)
        OverlayButtonType.RUN_WIRE:
            if is_instance_valid(
                    _first_selected_station_for_running_power_line):
                print("Second wire end")
                bot.move_to_attach_power_line(
                        _first_selected_station_for_running_power_line,
                        station)
                clear_station_selection()
            else:
                print("First wire end")
                _first_selected_station_for_running_power_line = station
        
        OverlayButtonType.COMMAND_CENTER:
            pass
        OverlayButtonType.SOLAR_COLLECTOR:
            assert(station is EmptyStation)
            bot.move_to_build_station(station, "solar")
        OverlayButtonType.SCANNER_STATION:
            assert(station is EmptyStation)
            bot.move_to_build_station(station, "scanner")
        OverlayButtonType.BATTERY_STATION:
            assert(station is EmptyStation)
            bot.move_to_build_station(station, "battery")
        
        OverlayButtonType.BUILD_CONSTRUCTOR_BOT:
            bot.move_to_build_bot(station, "constructor_bot")
        OverlayButtonType.BUILD_LINE_RUNNER_BOT:
            bot.move_to_build_bot(station, "line_runner_bot")
        OverlayButtonType.BUILD_REPAIR_BOT:
            bot.move_to_build_bot(station, "repair_bot")
        OverlayButtonType.BUILD_BARRIER_BOT:
            bot.move_to_build_bot(station, "barrier_bot")
        _:
            Sc.logger.error("GameLevel._on_station_button_pressed")
    
    if button_type != OverlayButtonType.RUN_WIRE:
        clear_station_selection()


func clear_station_selection() -> void:
    _first_selected_station_for_running_power_line = null


func add_power_line(power_line: PowerLine) -> void:
    $PowerLines.add_child(power_line)
    _on_power_line_created(power_line)


func remove_power_line(power_line: PowerLine) -> void:
    _on_power_line_destroyed(power_line)


func _on_power_line_created(power_line: PowerLine) -> void:
    power_lines.push_back(power_line)


func _on_power_line_destroyed(power_line: PowerLine) -> void:
    self.power_lines.erase(power_line)
    power_line.queue_free()


func add_bot(bot_name: String) -> Bot:
    var bot_scene: PackedScene
    match bot_name:
        "constructor_bot":
            bot_scene = _CONSTRUCTOR_BOT_SCENE
        _:
            Sc.logger.error("GameLevel.add_bot")
            return null
    var bot: Bot = add_character(
            bot_scene,
            command_center.position + Vector2(0, -4),
            true,
            false,
            true)
    bot_selector._on_bot_created(bot)
    _on_bot_created(bot)
    return bot


func remove_bot(bot: Bot) -> void:
    _on_bot_destroyed(bot)


func _on_bot_created(bot: Bot) -> void:
    self.bots.push_back(bot)


func _on_bot_destroyed(bot: Bot) -> void:
    self.bots.erase(bot)
    bot.queue_free()


func replace_station(
        old_station: Station,
        new_station_type: String) -> void:
    var station_position := old_station.position
    remove_station(old_station)
    var station_scene: PackedScene
    match new_station_type:
        "command_center":
            station_scene = _COMMAND_CENTER_SCENE
        "solar":
            station_scene = _SOLAR_COLLECTOR_SCENE
        "scanner":
            pass
        "battery":
            pass
        "empty":
            station_scene = _EMPTY_STATION_SCENE
        _:
            Sc.logger.error("GameLevel.add_station")
    var new_station := Sc.utils.add_scene($Stations, station_scene)
    new_station.position = station_position
    _on_station_created(new_station)


func add_station(station: Station) -> void:
    $Stations.add_child(station)
    _on_station_created(station)


func remove_station(station: Station) -> void:
    # Remove any attached power lines.
    for power_line in power_lines:
        if power_line.start_attachment == station or \
                power_line.end_attachment == station:
            power_line.on_attachment_removed()
            Sc.level.remove_power_line(power_line)
    _on_station_destroyed(station)

func _on_station_created(station: Station) -> void:
    self.stations.push_back(station)


func _on_station_destroyed(station: Station) -> void:
    self.stations.erase(station)
    station.queue_free()


func get_music_name() -> String:
    return "just_keep_building"


func get_slow_motion_music_name() -> String:
    # FIXME: Add slo-mo music
    return ""
