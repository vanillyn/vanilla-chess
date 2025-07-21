extends Control

@onready var scene_manager: SceneManager = get_tree().get_first_node_in_group("scene_manager")


@onready var chess_button: StandardButton = $ChessButton
@onready var shogi_button: StandardButton = $ShogiButton
@onready var back_button: StandardButton = $SecondaryButtons/BackButton
@onready var settings_button: StandardButton = $SecondaryButtons/SettingsButton


func _ready():
	chess_button.pressed.connect(_play_chess)
	shogi_button.pressed.connect(_play_shogi)
	back_button.pressed.connect(_on_back_pressed)
	settings_button.pressed.connect(_on_settings_pressed)

func _play_chess():
	if scene_manager:
		scene_manager.transition_to_scene("chess_main", "res://ui/menus/play/chess/chess.tscn")

func _on_back_pressed():
	if scene_manager:
		scene_manager.go_back()

func _on_settings_pressed():
	if scene_manager:
		scene_manager.transition_to_scene("options", "res://ui/menus/options/optionsmenu.tscn")

func _play_shogi():
	if scene_manager:
		scene_manager.transition_to_scene("shogi_main", "res://ui/menus/play/shogi/shogi.tscn")

func _on_scene_entered():
	modulate = Color.TRANSPARENT
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
