class_name StandardButton
extends Control

signal pressed

@export var text: String = "Button" : set = set_text
@export var font_size: int = 16 : set = set_font_size
@export var button_style: ButtonStyle : set = set_button_style
@export var hover_scale: float = 1.05
@export var press_scale: float = 0.95
@export var animation_speed: float = 0.1
@export var style_resource: ButtonTheme

@onready var shadow: NinePatchRect = $Shadow
@onready var background: NinePatchRect = $Background
@onready var label: Label = $Label
var tween: Tween

var is_hovered := false
var is_pressed := false
var is_disabled := false

enum ButtonStyle {
	PRIMARY,
	SECONDARY,
	ACCENT,
	CUSTOM
}

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	_apply_style()
	_update_visual_state()
	call_deferred("_auto_size_button")

func _auto_size_button():
	if not label or not label.get_theme_font("font") or label.get_theme_font_size("font_size") == 0:
		call_deferred("_auto_size_button")
		return

	custom_minimum_size = label.get_theme_font("font").get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, label.get_theme_font_size("font_size")) + Vector2(40, 20)
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.set_offset(0, 0)

func _apply_style():
	if not style_resource:
		style_resource = _get_default_style()

	if shadow:
		shadow.texture = style_resource.background_texture
		shadow.modulate = style_resource.shadow_color
		shadow.patch_margin_left = style_resource.patch_margin_left
		shadow.patch_margin_right = style_resource.patch_margin_right
		shadow.patch_margin_top = style_resource.patch_margin_top
		shadow.patch_margin_bottom = style_resource.patch_margin_bottom
		shadow.position = Vector2(style_resource.shadow_offset_x, style_resource.shadow_offset_y)

	if background:
		background.texture = style_resource.background_texture
		background.patch_margin_left = style_resource.patch_margin_left
		background.patch_margin_right = style_resource.patch_margin_right
		background.patch_margin_top = style_resource.patch_margin_top
		background.patch_margin_bottom = style_resource.patch_margin_bottom

	if label:
		label.text = text
		label.add_theme_color_override("font_color", style_resource.text_color)
		label.add_theme_font_size_override("font_size", font_size)
		if style_resource.font:
			label.add_theme_font_override("font", style_resource.font)

func _get_default_style() -> ButtonTheme:
	var s = ButtonTheme.new()
	s.text_color = Color.WHITE
	s.hover_color = Color(1.2, 1.2, 1.2)
	s.press_color = Color(0.8, 0.8, 0.8)
	s.disabled_color = Color(0.5, 0.5, 0.5)
	return s

func _on_mouse_entered():
	if not is_disabled:
		is_hovered = true
		_update_visual_state()

func _on_mouse_exited():
	if not is_disabled:
		is_hovered = false
		_update_visual_state()

func _on_gui_input(event: InputEvent):
	if is_disabled or not (event is InputEventMouseButton):
		return

	var btn := event as InputEventMouseButton
	if btn.button_index == MOUSE_BUTTON_LEFT:
		if btn.pressed:
			is_pressed = true
		elif is_pressed:
			is_pressed = false
			if is_hovered:
				pressed.emit()
		_update_visual_state()

func _update_visual_state():
	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)

	var scale := Vector2.ONE
	var mod := Color.WHITE

	if is_disabled:
		mod = style_resource.disabled_color
	elif is_pressed:
		scale *= press_scale
		mod = style_resource.press_color
	elif is_hovered:
		scale *= hover_scale
		mod = style_resource.hover_color

	tween.tween_property(self, "scale", scale, animation_speed)
	tween.tween_property(self, "modulate", mod, animation_speed)

func set_text(value: String):
	text = value
	if label:
		label.text = text
		call_deferred("_auto_size_button")

func set_font_size(value: int):
	font_size = value
	if label:
		label.add_theme_font_size_override("font_size", font_size)
		call_deferred("_auto_size_button")

func set_button_style(value: ButtonStyle):
	button_style = value
	_apply_style()

func set_disabled(disabled: bool):
	is_disabled = disabled
	_update_visual_state()

func simulate_press():
	if not is_disabled:
		pressed.emit()

func set_style_resource(resource: ButtonTheme):
	style_resource = resource
	_apply_style()
	_update_visual_state()
