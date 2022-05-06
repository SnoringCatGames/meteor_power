tool
class_name GameLevel
extends SurfacerLevel


const _CONSTRUCTOR_BOT_SCENE := preload(
        "res://src/characters/construction_bot/construction_bot.tscn")
const _COMMAND_CENTER_SCENE := preload("res://src/stations/command_center.tscn")
const _EMPTY_STATION_SCENE := preload("res://src/stations/empty_station.tscn")
const _SOLAR_COLLECTOR_SCENE := preload(
        "res://src/stations/solar_collector.tscn")

var _nav_preselection_camera: NavigationPreselectionCamera

var command_center: CommandCenter

var meteor_controller: MeteorController

var selected_station: Station
var selected_bot: Bot

# Array<Station>
var stations := []

# Array<Bot>
var bots := []

# Array<PowerLine>
var power_lines := []

var _first_selected_station_for_running_power_line: Station = null

var _static_camera: StaticCamera


func _ready() -> void:
    _static_camera = StaticCamera.new()
    add_child(_static_camera)


func _load() -> void:
    ._load()
    
    Sc.gui.hud.set_up()
    Sc.gui.hud.connect(
            "radial_menu_opened",
            self,
            "_on_radial_menu_opened")
    Sc.gui.hud.connect(
            "radial_menu_closed",
            self,
            "_on_radial_menu_closed")


func _start() -> void:
    ._start()
    
    _nav_preselection_camera = NavigationPreselectionCamera.new()
    add_child(_nav_preselection_camera)
    
    Sc.levels.session.current_energy = LevelSession.START_ENERGY
    Sc.levels.session.total_energy = LevelSession.START_ENERGY
    
    command_center = Sc.utils.get_child_by_type($Stations, CommandCenter)
    Sc.level._on_station_created(command_center)
    
    var empty_stations := \
            Sc.utils.get_children_by_type($Stations, EmptyStation)
    for empty_station in empty_stations:
        Sc.level._on_station_created(empty_station)
    
    # Always start with a constructor bot.
    var starting_bot := add_bot(Commands.BOT_CONSTRUCTOR)
    # FIXME: ------------------- REMOVE.
    starting_bot.position.x += 96.0
    
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


func _unhandled_input(event: InputEvent) -> void:
    if (event is InputEventScreenTouch or \
            event is InputEventMouseButton) and \
            event.pressed:
        # Close the info panel if it wasn't just opened.
        if Sc.info_panel.get_is_open() and \
                !Sc.info_panel.get_is_transitioning():
            Sc.info_panel.close_panel()
            _clear_selection()


func _on_radial_menu_opened() -> void:
    _update_camera()


func _on_radial_menu_closed() -> void:
    _update_camera()


func _on_active_player_character_changed() -> void:
    ._on_active_player_character_changed()
    
    selected_bot = _active_player_character
    
    if is_instance_valid(selected_bot) and \
            is_instance_valid(selected_station):
        selected_station.set_is_selected(false)
        selected_station = null
    
    clear_station_power_line_selection()
    _update_camera()
    
    Sc.level.level_control_press_controller.are_touches_disabled = \
            is_instance_valid(_active_player_character)


func _on_bot_selection_changed(
        bot: Bot,
        is_selected: bool) -> void:
    if is_selected:
        # Deselect any previously selected bot.
        if is_instance_valid(selected_bot):
            if bot == selected_bot:
                # No change.
                return
            else:
                selected_bot.set_is_selected(false)
        selected_bot = bot
    else:
        if bot != selected_bot:
            # No change.
            return
        selected_bot = null
    
    # Deselect any selected station.
    if is_selected and \
            is_instance_valid(selected_station):
        selected_station.set_is_selected(false)
        selected_station = null


func _on_station_selection_changed(
        station: Station,
        is_selected: bool) -> void:
    if is_selected:
        # Deselect any previously selected station.
        if is_instance_valid(selected_station):
            if station == selected_station:
                # No change.
                return
            else:
                selected_station.set_is_selected(false)
        selected_station = station
    else:
        if station != selected_station:
            # No change.
            return
        selected_station = null
    
    # Deselect any selected bot.
    if is_selected and \
            is_instance_valid(selected_bot):
        selected_bot.set_is_selected(false)
        selected_bot = null


func _clear_selection() -> void:
    if is_instance_valid(selected_bot):
        selected_bot.set_is_selected(false)
        selected_bot = null
    if is_instance_valid(selected_station):
        selected_station.set_is_selected(false)
        selected_station = null


func _update_camera() -> void:
    var extra_zoom: float
    if Sc.gui.hud.get_is_radial_menu_open():
        swap_camera(_static_camera, true)
        extra_zoom = 1.0
    elif is_instance_valid(_active_player_character):
        _nav_preselection_camera.target_character = _active_player_character
        swap_camera(_nav_preselection_camera, true)
        extra_zoom = 1.4
    else:
        swap_camera(_default_camera, true)
        extra_zoom = 1.0
    Sc.level.camera.transition_extra_zoom(extra_zoom)


func deduct_energy(cost: int) -> void:
    if Sc.levels.session.current_energy == 0:
        return
    Sc.levels.session.current_energy -= cost
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
    # FIXME: LEFT OFF HERE: ---------------------------------------------
    # - Automatically select bot based on temporal distance.
    var bot: Bot = bots[0]
    match button_type:
        Commands.STATION_RECYCLE:
            bot.move_to_destroy_station(station)
        Commands.RUN_WIRE:
            if is_instance_valid(
                    _first_selected_station_for_running_power_line):
                print("Second wire end")
                bot.move_to_attach_power_line(
                        _first_selected_station_for_running_power_line,
                        station)
                clear_station_power_line_selection()
            else:
                print("First wire end")
                _first_selected_station_for_running_power_line = station
        
        Commands.STATION_COMMAND:
            pass
        Commands.STATION_SOLAR:
            assert(station is EmptyStation)
            bot.move_to_build_station(station, button_type)
        Commands.STATION_SCANNER:
            assert(station is EmptyStation)
            bot.move_to_build_station(station, button_type)
        Commands.STATION_BATTERY:
            assert(station is EmptyStation)
            bot.move_to_build_station(station, button_type)
        
        Commands.BOT_CONSTRUCTOR:
            bot.move_to_build_bot(station, button_type)
        Commands.BOT_LINE_RUNNER:
            bot.move_to_build_bot(station, button_type)
        Commands.BOT_REPAIR:
            bot.move_to_build_bot(station, button_type)
        Commands.BOT_BARRIER:
            bot.move_to_build_bot(station, button_type)
        _:
            Sc.logger.error("GameLevel._on_station_button_pressed")
    
    if button_type != Commands.RUN_WIRE:
        clear_station_power_line_selection()


func clear_station_power_line_selection() -> void:
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


func add_bot(bot_type: int) -> Bot:
    var bot_scene: PackedScene
    match bot_type:
        Commands.BOT_CONSTRUCTOR:
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
        new_station_type: int) -> void:
    var station_position := old_station.position
    remove_station(old_station)
    var station_scene: PackedScene
    match new_station_type:
        Commands.STATION_COMMAND:
            station_scene = _COMMAND_CENTER_SCENE
        Commands.STATION_SOLAR:
            station_scene = _SOLAR_COLLECTOR_SCENE
        Commands.STATION_BATTERY:
            pass
        Commands.STATION_SCANNER:
            pass
        Commands.STATION_EMPTY:
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
    station._destroy()


func get_music_name() -> String:
    return "just_keep_building"


func get_slow_motion_music_name() -> String:
    # FIXME: Add slo-mo music
    return ""
