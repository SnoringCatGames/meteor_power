tool
class_name GameDefaultColors
extends Reference


var _COLOR_BACKGROUND := Color("0b031b")
var _COLOR_BACKGROUND_LIGHTER := Color("100422")
var _COLOR_BACKGROUND_DARKER := Color("080317")

var _COLOR_TEXT := Color("eeeeee")
var _COLOR_HEADER := Color("d6d2a3")
var _COLOR_FOCUS := Color("d6d2a3")

var _COLOR_BUTTON := Color("3f4361")
var _COLOR_BUTTON_LIGHTER := Color("636a94")
var _COLOR_BUTTON_DARKER := Color("31325c")

var _COLOR_SHADOW := Color("88000000")
const _COLOR_SIMPLE_TRANSPARENT_BLACK := Color("cc000000")

var _HUD_KEY_VALUE_BOX_MODULATE_COLOR := Color(0.1, 0.7, 1.2, 1.0)
var _BUTTON_PULSE_MODULATE_COLOR := Color(1.5, 1.5, 3.0, 1.0)

# Should match Project Settings > Rendering > Environment > Default Clear Color.
var background := _COLOR_BACKGROUND

var boot_splash_background := ColorFactory.palette("default_splash_background")
var text := _COLOR_TEXT
var header := _COLOR_HEADER
var focus_border := _COLOR_FOCUS
var link_normal := _COLOR_BUTTON_LIGHTER
var link_hover := _COLOR_BUTTON
var link_pressed := _COLOR_BUTTON_DARKER
var button_normal := _COLOR_BUTTON
var button_pulse_modulate := _BUTTON_PULSE_MODULATE_COLOR
var button_disabled := _COLOR_BUTTON_LIGHTER
var button_focused := _COLOR_BUTTON_LIGHTER
var button_hover := _COLOR_BUTTON_LIGHTER
var button_pressed := _COLOR_BUTTON_DARKER
var button_border := _COLOR_TEXT
var dropdown_normal := _COLOR_BACKGROUND
var dropdown_disabled := _COLOR_BACKGROUND_LIGHTER
var dropdown_focused := _COLOR_BACKGROUND_LIGHTER
var dropdown_hover := _COLOR_BACKGROUND_LIGHTER
var dropdown_pressed := _COLOR_BACKGROUND_DARKER
var dropdown_border := _COLOR_BACKGROUND_DARKER
var tooltip := _COLOR_BACKGROUND
var tooltip_bg := _COLOR_TEXT
var popup_background := _COLOR_BACKGROUND_LIGHTER
var scroll_bar_background := _COLOR_BACKGROUND_LIGHTER
var scroll_bar_grabber_normal := _COLOR_BUTTON
var scroll_bar_grabber_hover := _COLOR_BUTTON_LIGHTER
var scroll_bar_grabber_pressed := _COLOR_BUTTON_DARKER
var slider_background := _COLOR_BACKGROUND_DARKER
var zebra_stripe_even_row := _COLOR_BACKGROUND_LIGHTER
var overlay_panel_background := _COLOR_BACKGROUND_DARKER
var overlay_panel_border := _COLOR_TEXT
var notification_panel_background := _COLOR_BACKGROUND_DARKER
var notification_panel_border := _COLOR_TEXT
var header_panel_background := ColorFactory.opacify("button_normal", 0.4)
var screen_border := _COLOR_TEXT
var shadow := _COLOR_SHADOW
var simple_transparent_black := _COLOR_SIMPLE_TRANSPARENT_BLACK

# ---

var highlight_light_green := Color("eaffdb")
var highlight_green := Color("85f23a")
var highlight_light_blue := Color("a8ecff")
var highlight_blue := Color("1cb0ff")
var highlight_dark_blue := Color("003066")
var highlight_disabled := Color("bb8b8b8b")
var highlight_yellow := Color("ccc016")
var highlight_orange := Color("cc7a16")
var highlight_red := Color("cc2c16")
var highlight_light_purple := Color("f2e0ff")
var highlight_purple := Color("b04fff")
var highlight_dark_purple := Color("51048f")

#var highlight_pink := Color("ca4fff")
#var highlight_pink_new := Color("d94fff")
#var highlight_blue_selected := Color("667aff")
#var highlight_light_blue_selected := Color("d9deff")

var highlight_teal := Color("4fffc4")
var highlight_light_teal := Color("d4fff0")
var highlight_dark_teal := Color("005236")
var highlight_green_selected := Color("4fff7b")
var highlight_light_green_selected := Color("d4ffde")
var highlight_blue_selected := Color("39e1f7")
var highlight_light_blue_selected := Color("adf5ff")
#var highlight_green_idle_selected := Color("81ff4f")
#var highlight_green_new_selected := Color("9bff4f")
var highlight_yellow_idle_selected := Color("e5ff4f")
var highlight_yellow_new_selected := Color("f9ff85")

var highlight_purply_blue := Color("9f96ff")
var faint_orange := Color("ffdea6")

var energy := Color("fdff70")

var modulation_button_normal := highlight_teal
var modulation_button_hover := highlight_light_teal
var modulation_button_pressed := highlight_dark_teal
var modulation_button_disabled := highlight_disabled

var bot_idle := ColorFactory.opacify("highlight_yellow_idle_selected", 0.6)
var bot_active := ColorFactory.opacify("highlight_teal", 0.4)
var bot_new := ColorFactory.opacify("highlight_yellow_new_selected", 0.9)
var bot_powered_down := ColorFactory.opacify("highlight_red", 0.9)
var bot_selected := ColorFactory.opacify("highlight_blue_selected", 0.9)
var bot_player_control_active := ColorFactory.opacify("highlight_purple", 0.9)
var bot_hovered := ColorFactory.opacify("highlight_light_blue_selected", 0.9)

var station_normal := ColorFactory.opacify("highlight_teal", 0.65)
var station_disconnected := ColorFactory.opacify("highlight_red", 0.9)
var station_selected := ColorFactory.opacify("highlight_blue_selected", 0.9)
var station_hovered := ColorFactory.opacify("highlight_light_blue_selected", 0.9)

var hud_icon := highlight_purply_blue
#var hud_totals := faint_orange
var hud_totals := Color("b8a98f")
var info_panel_header := highlight_purply_blue
#var info_panel_header := header

var separator := ColorFactory.opacify("button_hover", 0.6)

var hud_count_min := Color.from_hsv(0.3, 0.05, 0.5)
var hud_count_max := Color.from_hsv(0.1, 0.7, 1.0)
var hud_count_non_zero_min: Color = lerp(hud_count_min, hud_count_max, 0.4)

#var modulation_button_normal := highlight_purple
#var modulation_button_hover := highlight_light_purple
#var modulation_button_pressed := highlight_dark_purple
#var modulation_button_disabled := highlight_disabled

#var bot_idle := ColorFactory.opacify("highlight_pink", 0.8)
#var bot_active := ColorFactory.opacify("highlight_purple", 0.6)
#var bot_new := ColorFactory.opacify("highlight_pink_new", 0.9)
#var bot_powered_down := ColorFactory.opacify("highlight_red", 0.9)
#var bot_selected := ColorFactory.opacify("highlight_blue_selected", 0.9)
#var bot_hovered := ColorFactory.opacify("highlight_light_blue_selected", 0.9)
#
#var station_normal := ColorFactory.opacify("highlight_purple", 0.7)
#var station_disconnected := ColorFactory.opacify("highlight_red", 0.9)
#var station_selected := ColorFactory.opacify("highlight_blue_selected", 0.9)
#var station_hovered := ColorFactory.opacify("highlight_light_blue_selected", 0.9)
