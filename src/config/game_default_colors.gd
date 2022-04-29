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
var header_panel_background := _COLOR_BACKGROUND
var screen_border := _COLOR_TEXT
var shadow := _COLOR_SHADOW

# ---

var new := Color("e0b400")
var active := Color("53c700")
var idle := Color("ffd000")
var stopping := Color("ffd000")
var selected := Color("1cb0ff")
var hovered := Color("99dbff")
var powered_down := Color("cc2c16")
