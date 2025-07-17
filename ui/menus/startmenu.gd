extends Control

@onready var scene_manager: SceneManager = get_tree().get_first_node_in_group("scene_manager")


@onready var play_button: StandardButton = $PlayButton
# @onready var customize_button: StandardButton = $VBox/CustomizeButton
@onready var friends_button: StandardButton = $FriendsButton
@onready var tools_button: StandardButton = $SecondaryButtons/ToolsButton
@onready var settings_button: StandardButton = $SecondaryButtons/SettingsButton
@onready var quit_button: StandardButton = $QuitButton


func _ready():
	play_button.pressed.connect(_on_play_pressed)
#	customize_button.pressed.connect(_on_customize_pressed)
	friends_button.pressed.connect(_on_friends_pressed)
	tools_button.pressed.connect(_on_tools_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	if scene_manager:
		scene_manager.transition_to_scene("play_menu", "res://ui/menus/play/play.tscn")

func _on_customize_pressed():
	if scene_manager:
		scene_manager.transition_to_scene("customize", "res://ui/menus/customize/customize.tscn")

func _on_friends_pressed():
	if scene_manager:
		scene_manager.transition_to_scene("friends", "res://ui/menus/friends.tscn")

func _on_tools_pressed():
	print("Tools button pressed")

func _on_settings_pressed():
	if scene_manager:
		scene_manager.transition_to_scene("options", "res://ui/menus/options/optionsmenu.tscn")

func _on_quit_pressed():
	get_tree().quit(0)

func _on_scene_entered():
	modulate = Color.TRANSPARENT
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
