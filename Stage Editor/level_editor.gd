extends Control

@onready var event_menu : PackedScene = preload("res://Stage Editor/target_timeline_event_display.tscn")

@onready var level_editor: PanelContainer = $"."
@onready var timeline: ScrollContainer = $Organizer/Timeline
@onready var event_organizer: HBoxContainer = $Organizer/Timeline/EventOrganizer
@onready var create_event: Button = $Organizer/Timeline/EventOrganizer/CreateEvent
@onready var save_scene: Button = $Organizer/ExtraHolders/SaveScene
@onready var load_scene: Button = $Organizer/ExtraHolders/LoadScene
@onready var scene_path: TextEdit = $Organizer/ExtraHolders/ScenePath

var stage_name : String = ""

func _ready() -> void:
	timeline.get_h_scroll_bar().custom_minimum_size.y = 15
	create_event.pressed.connect(_on_create_button_pressed)
	save_scene.pressed.connect(save_data)
	load_scene.pressed.connect(load_data)
	scene_path.text_changed.connect(_on_scene_path_text_set)

func _on_scene_path_text_set() -> void:
	stage_name = scene_path.text
	
func _on_create_button_pressed() -> void:
	var new_event_menu : Control = event_menu.instantiate()
	event_organizer.add_child(new_event_menu)
	new_event_menu.left.pressed.connect(move_event_position.bind(new_event_menu, -1))
	new_event_menu.right.pressed.connect(move_event_position.bind(new_event_menu, 1))
	receive_underlying_data()
	event_organizer.move_child(create_event, event_organizer.get_child_count())

func receive_underlying_data() -> StageLayoutData:
	var output : StageLayoutData = StageLayoutData.new()
	for event_ui : Control in event_organizer.get_children():
		if event_ui is not Button:
			output.data.append(event_ui.receive_underlying_data())
	return output

func rebuild_menus(matcher : StageLayoutData) -> void:
	for event : TargetEventDescriptor in matcher.data:
		var new_event_menu : Control = event_menu.instantiate()
		event_organizer.add_child(new_event_menu)
		new_event_menu.left.pressed.connect(move_event_position.bind(new_event_menu, -1))
		new_event_menu.right.pressed.connect(move_event_position.bind(new_event_menu, 1))
		new_event_menu.rebuild_menus(event)
	event_organizer.move_child(create_event, event_organizer.get_child_count())

func move_event_position(event_ui : Control, direction : int) -> void:
	var index : int = event_organizer.get_children().find(event_ui)
	event_organizer.move_child(event_ui, max(index + direction, 0))
	event_organizer.move_child(create_event, event_organizer.get_child_count())
	
func save_data() -> void:
	var layout : StageLayoutData = receive_underlying_data()
	if stage_name != "":
		ResourceSaver.save(layout, "/home/mpaule/Godot Projects/Rouge Gallery/Stage Editor/Made Stages/" + stage_name + ".tres")
	else:
		printerr("please enter a valid stage name")

func load_data() -> void:
	if ResourceLoader.exists("/home/mpaule/Godot Projects/Rouge Gallery/Stage Editor/Made Stages/" + stage_name + ".tres"):
		var temp_timeline : StageLayoutData = ResourceLoader.load("/home/mpaule/Godot Projects/Rouge Gallery/Stage Editor/Made Stages/" + stage_name + ".tres", "StageLayoutData")
		for event_ui : Control in event_organizer.get_children():
			if event_ui is not Button:
				event_ui.queue_free()
		rebuild_menus(temp_timeline)
	else:
		printerr("stage name " + stage_name + " not found.")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("fullscreen_game"):
			var window_state : bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
			if window_state:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
