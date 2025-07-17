class_name LoadingScreen
extends Control

signal loading_complete

@onready var loading_label: Label = $LoadingLabel

var scene_manager: SceneManager
var loading_timer: float = 0.0
var dot_count: int = 0

func _ready():
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	scene_manager = get_tree().get_first_node_in_group("scene_manager")
	if not scene_manager:
		var current = get_parent()
		while current:
			if current is SceneManager:
				scene_manager = current
				break
			current = current.get_parent()

		if not scene_manager:
			var root = get_tree().current_scene
			if root is SceneManager:
				scene_manager = root
	
	if not scene_manager:
		push_error("Could not find SceneManager!")
		return
	
	start_loading()

func _process(delta):
	loading_timer += delta
	if loading_timer >= 0.5:
		loading_timer = 0.0
		dot_count = (dot_count + 1) % 5
		
		var dots = ""
		for i in range(dot_count):
			dots += "."
		
		loading_label.text = "loading" + dots

func start_loading():
	await load_all_scenes()
	await get_tree().create_timer(1.0).timeout

	loading_complete.emit()

func load_all_scenes():
	scene_manager._load_game()
	await get_tree().process_frame
	
	print("All scenes loaded!")
