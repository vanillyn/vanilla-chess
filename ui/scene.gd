class_name SceneManager
extends Control

signal scene_changed(scene_id: String)
signal loading_complete

@export var transition_duration: float = 0.5
@export var transition_type: Tween.TransitionType = Tween.TRANS_CUBIC

@onready var background: AnimatedBackground = $Background
@onready var container: Control = $Content

var current_scene: Control = null
var scene_stack: Array[String] = []
var loaded_scenes: Dictionary = {}
var tween: Tween
var loading: bool = false

func _ready():
	add_to_group("scene_manager")

	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	if background:
		background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	if container:
		container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	show_loading_screen()

func show_loading_screen():


	loading = true

	var loading_screen_scene = preload("res://ui/loading/loading.tscn")
	var loading_screen = loading_screen_scene.instantiate()
	if not loading_screen.has_signal("loading_complete"):
		print("loading_complete signal not found!")
	else:
		print("connecting loading_complete")
		loading_screen.loading_complete.connect(_loaded)
	container.add_child(loading_screen)
	current_scene = loading_screen

	loading_screen.loading_complete.connect(_loaded)

func _loaded():
	loading = false
	
	await get_tree().create_timer(0.5).timeout

	transition_to_scene("main_menu")
	loading_complete.emit()

func load_scene(scene_id: String, scene_path: String):
	if not loaded_scenes.has(scene_id):
		var scene = load(scene_path)
		if scene:
			loaded_scenes[scene_id] = scene
			print("Loaded scene: ", scene_id)
		else:
			print("Failed to load scene: ", scene_path)

func transition_to_scene(scene_id: String, scene_path: String = ""):
	if loading and scene_id != "main_menu":
		return

	if not loaded_scenes.has(scene_id) and scene_path != "":
		load_scene(scene_id, scene_path)
	
	if not loaded_scenes.has(scene_id):
		print("Scene not found: ", scene_id)
		return
	
	if scene_stack.is_empty() or scene_stack[-1] != scene_id:
		scene_stack.append(scene_id)
	
	if background:
		background.transition_to_background(scene_id)

	_transition_content(scene_id)

	scene_changed.emit(scene_id)

func _transition_content(scene_id: String):
	var toscene = loaded_scenes[scene_id].instantiate()
	
	if not container:
		return
	
	toscene.modulate = Color.TRANSPARENT
	toscene.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	container.add_child(toscene)
	
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	
	if current_scene:
		tween.tween_property(current_scene, "modulate", Color.TRANSPARENT, transition_duration * 0.6).set_trans(transition_type)
		tween.tween_callback(current_scene.queue_free).set_delay(transition_duration * 0.6)
	
	tween.tween_property(toscene, "modulate", Color.WHITE, transition_duration * 0.6).set_delay(transition_duration * 0.4).set_trans(transition_type)
	
	current_scene = toscene

func go_back():
	if loading:
		return
		
	if scene_stack.size() > 1:
		scene_stack.pop_back()
		var previous_scene = scene_stack[-1]
		scene_stack.pop_back()
		transition_to_scene(previous_scene)

func get_current_scene_id() -> String:
	if scene_stack.is_empty():
		return ""
	return scene_stack[-1]

func get_current_scene() -> Control:
	return current_scene

func _load_game():
	load_scene("main_menu", "res://ui/menus/startmenu.tscn")
	load_scene("play_menu", "res://ui/menus/play/play.tscn")
	# TODO: Add these menus.
	# load_scene("options", "res://ui/menus/options/options.tscn")
	# load_scene("friends", "res://ui/menus/friends/friends.tscn")

func clear_scene_stack():
	scene_stack.clear()

func add_scene_transition_effect(effect_name: String, duration: float = 0.5):
	transition_duration = duration
	
	match effect_name:
		"quick":
			transition_duration = 0.2
			transition_type = Tween.TRANS_QUART
		"smooth":
			transition_duration = 0.5
			transition_type = Tween.TRANS_CUBIC
		"slow":
			transition_duration = 0.8
			transition_type = Tween.TRANS_SINE
