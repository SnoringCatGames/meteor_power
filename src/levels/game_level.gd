tool
class_name GameLevel
extends SurfacerLevel


const _CONSTRUCTOR_BOT_SCENE := preload(
        "res://src/characters/construction_bot/construction_bot.tscn")
const _COMMAND_CENTER_SCENE := preload("res://src/stations/command_center.tscn")
const _EMPTY_STATION_SCENE := preload("res://src/stations/empty_station.tscn")
const _SOLAR_COLLECTOR_SCENE := preload(
        "res://src/stations/solar_collector.tscn")

const _OVERLAY_BUTTONS_FADE_DURATION := 0.3

var _nav_preselection_camera: NavigationPreselectionCamera

var command_center: CommandCenter

var meteor_controller: MeteorController

var selected_station: Station
var previous_selected_station: Station
var selected_bot: Bot
var previous_selected_bot: Bot

# Array<Station>
var stations := []

# Array<CommandCenter>
var command_centers := []
# Array<SolarCollector>
var solar_collectors := []
# Array<ScannerStation>
var scanner_stations := []
# Array<BatteryStation>
var battery_stations := []
# Array<EmptyStation>
var empty_stations := []

# Array<Bot>
var bots := []

# Array<ConstructorBot>
var constructor_bots := []
# Array<LineRunnerBot>
var line_runner_bots := []
# Array<BarrierBot>
var barrier_bots := []

# Dictionary<Bot, true>
var idle_bots := {}

# Array<PowerLine>
var power_lines := []

# Array<Command>
var command_queue := []

# Dictionary<Command, true>
var in_progress_commands := {}

# Array<String>
var command_enablement := []

# Array<String>
var previous_command_enablement := []

var tutorial_mode := TutorialMode.NONE

var first_selected_station_for_running_power_line: Station = null

# FIXME: ------------------------------
# -   Decide when to trigger this.
#     -   When hitting a target energy level?
#     -   When buying a special, very-expensive command from the command center?
#          -   "Link to mother ship"
#          -   Which both stores acquired energy, and boosts station/bot
#              efficiency and/or durability?
var did_level_succeed := false

var _static_camera: StaticCamera

var _overlay_buttons_fade_tween: ScaffolderTween
var _overlay_buttons_opacity := 1.0

var _max_command_cost := -INF


func _ready() -> void:
    _static_camera = StaticCamera.new()
    add_child(_static_camera)
    
    _overlay_buttons_fade_tween = ScaffolderTween.new(self)
    
    for command in CommandType.VALUES:
        _max_command_cost = max(_max_command_cost, CommandType.COSTS[command])
    
    command_enablement.resize(CommandType.VALUES.size())
    for command in CommandType.VALUES:
        command_enablement[command] = ""
    previous_command_enablement = command_enablement.duplicate()


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
    
    command_center = Sc.utils.get_child_by_type($Stations, CommandCenter)
    _on_station_created(command_center, true)
    
    var empty_stations := \
            Sc.utils.get_children_by_type($Stations, EmptyStation)
    for empty_station in empty_stations:
        _on_station_created(empty_station, true)
    
    # Always start with a constructor bot.
    var starting_bot := add_bot(CommandType.BOT_CONSTRUCTOR, true)
    # FIXME: ------------------- REMOVE.
    starting_bot.position.x += 96.0
    
    for station in stations:
        station._on_level_started()
    for bot in bots:
        bot._on_level_started()
    
    meteor_controller = MeteorController.new()
    self.add_child(meteor_controller)
    
    _override_for_level()
    
    update_command_enablement()
    
#    Sc.gui.hud.connect("radial_menu_opened", self, "_on_radial_menu_opened")
#    Sc.gui.hud.connect("radial_menu_closed", self, "_on_radial_menu_closed")
    Sc.slow_motion.connect(
        "slow_motion_toggled", self, "_on_slow_motion_toggled")
    
    session._score = session.total_energy
    
    Sc.camera.connect("panned", self, "_on_panned")
    Sc.camera.connect("zoomed", self, "_on_zoomed")


func _on_slow_motion_toggled(is_enabled: bool) -> void:
    var end_value := \
            0.0 if \
            is_enabled else \
            1.0
    _overlay_buttons_fade_tween.stop_all()
    _overlay_buttons_fade_tween.interpolate_method(
        self,
        "_interpolate_overlay_buttons_fade",
        _overlay_buttons_opacity,
        end_value,
        _OVERLAY_BUTTONS_FADE_DURATION)
    _overlay_buttons_fade_tween.start()


func _interpolate_overlay_buttons_fade(opacity: float) -> void:
    _overlay_buttons_opacity = opacity
    for station in stations:
        station.buttons.modulate.a = opacity


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


func quit(
        has_finished: bool,
        immediately: bool) -> void:
    # -   Even if we quit through the pause menu, consider the session
    #     "finished" if we met the level-success condition.
    # -   Unless we are restarting.
    has_finished = !session._is_restarting and did_level_succeed
    if did_level_succeed:
        session._game_over_explanation = Description.LEVEL_SUCCESS_EXPLANATION
    else:
        session._game_over_explanation = Description.LEVEL_FAILURE_EXPLANATION
    for bot in bots:
        session.bot_pixels_travelled += bot.distance_travelled
    .quit(has_finished, immediately)


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


func _on_panned() -> void:
    for bot in bots:
        bot._on_panned()
    for station in stations:
        station._on_panned()
    for power_line in power_lines:
        power_line._on_panned()


func _on_zoomed() -> void:
    for bot in bots:
        bot._on_zoomed()
    for station in stations:
        station._on_zoomed()
    for power_line in power_lines:
        power_line._on_zoomed()


func _on_radial_menu_opened() -> void:
    _update_camera()


func _on_radial_menu_closed() -> void:
    _update_camera()


func _on_active_player_character_changed() -> void:
    ._on_active_player_character_changed()
    
    if _previous_active_player_character == selected_bot and \
            is_instance_valid(selected_bot):
        selected_bot.set_is_selected(false)
    
    if is_instance_valid(selected_bot) and \
            is_instance_valid(selected_station):
        selected_station.set_is_selected(false)
        _update_selected_station(null)
    
    clear_station_power_line_selection()
    _update_camera()
    
    level_control_press_controller.are_touches_disabled = \
            is_instance_valid(_active_player_character)
    
    Sc.gui.hud.fade(is_instance_valid(_active_player_character))


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
        _update_selected_bot(bot)
    else:
        if bot != selected_bot:
            # No change.
            return
        _update_selected_bot(null)
    
    # Deselect any selected station.
    if is_selected and \
            is_instance_valid(selected_station):
        selected_station.set_is_selected(false)
        _update_selected_station(null)


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
        _update_selected_station(station)
    else:
        if station != selected_station:
            # No change.
            return
        _update_selected_station(null)
    
    # Deselect any selected bot.
#    if is_selected and \
#            is_instance_valid(selected_bot):
#        selected_bot.set_is_selected(false)
#        _update_selected_bot(null)


func _clear_selection() -> void:
    if is_instance_valid(selected_bot):
        selected_bot.set_is_selected(false)
        _update_selected_bot(null)
    if is_instance_valid(selected_station):
        selected_station.set_is_selected(false)
        _update_selected_station(null)


func _update_selected_bot(selected_bot: Bot) -> void:
    if self.selected_bot == selected_bot:
        return
    previous_selected_bot = self.selected_bot
    self.selected_bot = selected_bot


func _update_selected_station(selected_station: Station) -> void:
    if self.selected_station == selected_station:
        return
    previous_selected_station = self.selected_station
    self.selected_station = selected_station


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
    camera.transition_extra_zoom(extra_zoom)


func add_command(
        type: int,
        target_station: Station,
        next_target_station: Station = null) -> void:
    var command := Command.new(
        type,
        target_station,
        next_target_station)
    command_queue.push_back(command)
    _try_next_command()


func _try_next_command() -> void:
    if command_queue.empty() or \
            idle_bots.empty():
        return
    
    # FIXME: ---------- Refactor this to instead use the next command that has
    #                   an available free bot of the correct type.
    var command: Command = command_queue.pop_front()
    in_progress_commands[command] = true
    command.is_active = true
    
    var bot := get_bot_for_command(command.target_station, CommandType.RUN_WIRE)
    bot.start_command(command)


func cancel_command(command: Command) -> void:
    if command.is_active:
        command_queue.erase(command)
    else:
        in_progress_commands.erase(command)


func deduct_energy(cost: int) -> void:
    if session.current_energy == 0:
        return
    var previous_energy: int = session.current_energy
    session.current_energy -= cost
    session.current_energy = max(session.current_energy, 0)
    if (previous_energy > _max_command_cost) != \
            (session.current_energy > _max_command_cost):
        update_command_enablement()
    if session.current_energy == 0:
        quit(false, false)


func add_energy(energy: int) -> void:
    if session.current_energy == 0:
        return
    var previous_energy: int = session.current_energy
    session.current_energy += energy
    session.total_energy += energy
    session._score = session.total_energy
    if (previous_energy > _max_command_cost) != \
            (session.current_energy > _max_command_cost):
        update_command_enablement()


func update_command_enablement() -> void:
    # Disable any command for which there isn't enough energy.
    if session.current_energy < _max_command_cost:
        for command in CommandType.VALUES:
            var previous_enablement: bool = command_enablement[command] == ""
            var next_enablement: bool = \
                CommandType.COSTS[command] <= session.current_energy
            if previous_enablement != next_enablement:
                command_enablement[command] = \
                    "" if \
                    next_enablement else \
                    Description.NOT_ENOUGH_ENERGY
    
    # Disable bot-creation when at max bot capacity.
    if session.total_bot_count >= session.bot_capacity:
        command_enablement[CommandType.BOT_CONSTRUCTOR] = \
            Description.MAX_BOT_CAPACITY
        command_enablement[CommandType.BOT_LINE_RUNNER] = \
            Description.MAX_BOT_CAPACITY
        command_enablement[CommandType.BOT_BARRIER] = \
            Description.MAX_BOT_CAPACITY
    
    # Disable bot-recycling when there's only one bot left.
    if session.total_bot_count <= 1:
        command_enablement[CommandType.BOT_RECYCLE] = \
            Description.CANNOT_TRASH_LAST_BOT
    
    # Disable wire-running when there's only one station left.
    if session.total_station_count <= 1:
        command_enablement[CommandType.RUN_WIRE] = \
            Description.CANNOT_RUN_WIRE_WITH_ONE_STATION
    
    if did_level_succeed:
        # FIXME: --------------- Add support for second and third links.
        command_enablement[CommandType.STATION_LINK_TO_MOTHERSHIP] = \
                Description.ALREADY_LINKED_TO_MOTHERSHIP
        
    # FIXME: LEFT OFF HERE: --------------------------
    if tutorial_mode != TutorialMode.NONE:
        pass
    
#    command_enablement[CommandType.BOT_CONSTRUCTOR]
#    command_enablement[CommandType.BOT_LINE_RUNNER]
#    command_enablement[CommandType.BOT_BARRIER]
#    command_enablement[CommandType.BOT_COMMAND]
#    command_enablement[CommandType.BOT_STOP]
#    command_enablement[CommandType.BOT_MOVE]
#    command_enablement[CommandType.BOT_RECYCLE]
#    command_enablement[CommandType.BOT_INFO]
#
#    command_enablement[CommandType.STATION_EMPTY]
#    command_enablement[CommandType.STATION_COMMAND]
#    command_enablement[CommandType.STATION_SOLAR]
#    command_enablement[CommandType.STATION_SCANNER]
#    command_enablement[CommandType.STATION_BATTERY]
#    command_enablement[CommandType.STATION_LINK_TO_MOTHERSHIP]
#    command_enablement[CommandType.STATION_RECYCLE]
#    command_enablement[CommandType.STATION_INFO]
#
#    command_enablement[CommandType.RUN_WIRE]
    
    var changed := false
    for i in command_enablement.size():
        if command_enablement[i] != previous_command_enablement[i]:
            changed = true
            break
    
    if changed:
        previous_command_enablement = command_enablement.duplicate()
        for entities in [bots, stations]:
            for entity in entities:
                entity._on_command_enablement_changed()


func set_selected_station_for_running_power_line(station: Station) -> void:
    if is_instance_valid(first_selected_station_for_running_power_line):
        if first_selected_station_for_running_power_line == station:
            Sc.logger.print("Same wire end: Cancelling wire-run command")
            clear_station_power_line_selection()
        else:
            Sc.logger.print("Second wire end")
            add_command(
                CommandType.RUN_WIRE,
                first_selected_station_for_running_power_line,
                station)
            clear_station_power_line_selection()
    else:
        Sc.logger.print("First wire end")
        first_selected_station_for_running_power_line = station
        station._on_command_enablement_changed()
        for other_station in station.station_connections:
            other_station._on_command_enablement_changed()


func get_is_first_station_selected_for_running_power_line() -> bool:
    return is_instance_valid(first_selected_station_for_running_power_line)


func clear_station_power_line_selection() -> void:
    var previous_first_selected_station_for_running_power_line := \
            first_selected_station_for_running_power_line
    first_selected_station_for_running_power_line = null
    if is_instance_valid(
            previous_first_selected_station_for_running_power_line):
        previous_first_selected_station_for_running_power_line \
            .set_is_selected(false)
        previous_first_selected_station_for_running_power_line \
            ._on_command_enablement_changed()
        for other_station in \
                previous_first_selected_station_for_running_power_line \
                    .station_connections:
            other_station._on_command_enablement_changed()


func connect_dynamic_power_line_to_second_station(
        origin_station: Station,
        destination_station: Station,
        bot: Bot,
        power_line: DynamicPowerLine) -> void:
    origin_station.remove_bot_connection(bot, power_line)
    origin_station.add_station_connection(destination_station, power_line)
    destination_station.add_station_connection(origin_station, power_line)
    origin_station \
        ._on_replaced_bot_plugin_with_station(bot, destination_station)
    destination_station._on_plugged_into_station(origin_station)


func add_power_line(power_line: PowerLine) -> void:
    $PowerLines.add_child(power_line)
    session.power_lines_built_count += 1
    power_lines.push_back(power_line)


func remove_power_line(power_line: PowerLine) -> void:
    assert(power_lines.has(power_line))
    power_lines.erase(power_line)
    power_line.queue_free()


func replace_dynamic_power_line(
        dynamic_power_line: DynamicPowerLine,
        static_power_line: StaticPowerLine) -> void:
    assert(dynamic_power_line.origin_station.station_connections[ \
        dynamic_power_line.destination_station] == dynamic_power_line)
    assert(dynamic_power_line.destination_station.station_connections[ \
        dynamic_power_line.origin_station] == dynamic_power_line)
    
    dynamic_power_line.origin_station.station_connections[
        dynamic_power_line.destination_station] = static_power_line
    dynamic_power_line.destination_station.station_connections[
        dynamic_power_line.origin_station] = static_power_line
    
    add_power_line(static_power_line)
    session.power_lines_built_count -= 1
    remove_power_line(dynamic_power_line)


func get_bot_for_command(
        station: Station,
        command_type: int) -> Bot:
    # FIXME: ---------------------------------------------
    # - If there was a selected-bot when pressing the first run-line button,
    #   then use that bot.
    var closest_distance_squared := INF
    var closest_bot: Bot = null
    for bot in idle_bots:
        var current_distance_squared: float = \
            bot.position.distance_squared_to(station.position)
        if current_distance_squared < closest_distance_squared:
            closest_distance_squared = current_distance_squared
            closest_bot = bot
    return closest_bot


func on_bot_idleness_changed(
        bot: Bot,
        is_idle: bool) -> void:
    if is_idle:
        assert(!idle_bots.has(bot))
        idle_bots[bot] = true
        _try_next_command()
    else:
        assert(idle_bots.has(bot))
        idle_bots.erase(bot)


func add_bot(
        bot_type: int,
        is_default_bot := false) -> Bot:
    var bot_scene: PackedScene
    match bot_type:
        CommandType.BOT_CONSTRUCTOR:
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
    
    if !is_default_bot:
        session.bots_built_count += 1
    bots.push_back(bot)
    if bot is ConstructionBot:
        if !is_default_bot:
            session.contructor_bots_built_count += 1
        constructor_bots.push_back(bot)
    elif bot is LineRunnerBot:
        if !is_default_bot:
            session.line_runner_bots_built_count += 1
        line_runner_bots.push_back(bot)
    elif bot is BarrierBot:
        if !is_default_bot:
            session.barrier_bots_built_count += 1
        barrier_bots.push_back(bot)
    else:
        Sc.logger.error("GameLevel._on_bot_created")
    _update_session_counts()
    
    return bot


func remove_bot(bot: Bot) -> void:
    bot.drop_power_line()
    if !session.is_ended:
        session.bot_pixels_travelled += bot.distance_travelled
    assert(bots.has(bot))
    bots.erase(bot)
    if bot is ConstructionBot:
        constructor_bots.erase(bot)
    elif bot is LineRunnerBot:
        line_runner_bots.erase(bot)
    elif bot is BarrierBot:
        barrier_bots.erase(bot)
    else:
        Sc.logger.error("GameLevel.remove_bot")
    _update_session_counts()
    remove_character(bot)


func replace_station(
        old_station: Station,
        new_station_type: int) -> void:
    for bot in old_station.bot_connections:
        var power_line: DynamicPowerLine = old_station.bot_connections[bot]
        assert(bot.held_power_line == power_line)
        bot.drop_power_line()
        bot.stop_on_surface(false, true)
        remove_power_line(power_line)
    
    for other_station in old_station.station_connections:
        var power_line: PowerLine = \
            old_station.station_connections[other_station]
        other_station.remove_station_connection(old_station)
        remove_power_line(power_line)
    
    var previous_station_count: int = session.total_station_count
    var station_position := old_station.position
    remove_station(old_station)
    var station_scene: PackedScene
    match new_station_type:
        CommandType.STATION_COMMAND:
            station_scene = _COMMAND_CENTER_SCENE
        CommandType.STATION_SOLAR:
            station_scene = _SOLAR_COLLECTOR_SCENE
        CommandType.STATION_BATTERY:
            pass
        CommandType.STATION_SCANNER:
            pass
        CommandType.STATION_EMPTY:
            station_scene = _EMPTY_STATION_SCENE
        _:
            Sc.logger.error("GameLevel.replace_station")
    var new_station := station_scene.instance()
    new_station.position = station_position
    $Stations.add_child(new_station)
    _on_station_created(new_station)


func remove_station(station: Station) -> void:
    assert(stations.has(station))
    stations.erase(station)
    if station is CommandCenter:
        command_centers.erase(station)
    elif station is SolarCollector:
        solar_collectors.erase(station)
    elif station is ScannerStation:
        scanner_stations.erase(station)
    elif station is BatteryStation:
        battery_stations.erase(station)
    elif station is EmptyStation:
        empty_stations.erase(station)
    else:
        Sc.logger.error("GameLevel.remove_station")
    station._destroy()
    _update_session_counts()


func _on_station_created(
        station: Station,
        is_default_station := false) -> void:
    if !is_default_station and !(station is EmptyStation):
        session.stations_built_count += 1
    stations.push_back(station)
    if station is CommandCenter:
        if !is_default_station:
            session.command_centers_built_count += 1
        command_centers.push_back(station)
    elif station is SolarCollector:
        if !is_default_station:
            session.solar_collectors_built_count += 1
        solar_collectors.push_back(station)
    elif station is ScannerStation:
        if !is_default_station:
            session.scanner_stations_built_count += 1
        scanner_stations.push_back(station)
    elif station is BatteryStation:
        if !is_default_station:
            session.battery_stations_built_count += 1
        battery_stations.push_back(station)
    elif station is EmptyStation:
        empty_stations.push_back(station)
    else:
        Sc.logger.error("GameLevel._on_station_created")
    _update_session_counts()


func on_station_health_depleted(station: Station) -> void:
    # FIXME: ------------------------ Play sound
    replace_station(station, CommandType.STATION_EMPTY)


func on_bot_health_depleted(bot: Bot) -> void:
    # FIXME: ------------------------ Play sound
    remove_bot(bot)


func on_power_line_health_depleted(power_line: PowerLine) -> void:
    Sc.audio.play_sound("wire_break")
    if power_line.end_attachment is Bot:
        # NOTE: This is covered by drop_power_line.
#        power_line.start_attachment \
#            .remove_bot_connection(power_line.end_attachment, power_line)
        power_line.end_attachment.drop_power_line()
        power_line.end_attachment.stop_on_surface(false, true)
    else:
        power_line.start_attachment \
            .remove_station_connection(power_line.end_attachment)
        power_line.end_attachment \
            .remove_station_connection(power_line.start_attachment)
    remove_power_line(power_line)


func _update_session_counts() -> void:
    session.command_center_count = command_centers.size()
    session.solar_collector_count = solar_collectors.size()
    session.scanner_station_count = scanner_stations.size()
    session.battery_station_count = battery_stations.size()
    session.empty_station_count = empty_stations.size()
    
    session.constructor_bot_count = constructor_bots.size()
    session.line_runner_bot_count = line_runner_bots.size()
    session.barrier_bot_count = barrier_bots.size()
    
    session.power_line_count = power_lines.size()
    
    update_command_enablement()


func get_music_name() -> String:
    return "just_keep_building"


func get_slow_motion_music_name() -> String:
    # FIXME: Add slo-mo music
    return ""
