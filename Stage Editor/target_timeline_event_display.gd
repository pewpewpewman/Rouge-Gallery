extends Control

@onready var target_menu : PackedScene = preload("res://Stage Editor/target_instance_display.tscn")

@onready var target_list: VBoxContainer = $ElementOrganizer/EventScroller/TargetList
@onready var create_target: Button = $ElementOrganizer/CreateTarget
@onready var event_length: SpinBox = $ElementOrganizer/EventLength
@onready var left: Button = $ElementOrganizer/MoveButtons/Left
@onready var right: Button = $ElementOrganizer/MoveButtons/Right
@onready var delete_event: Button = $ElementOrganizer/DeleteEvent

func _ready() -> void:
	create_target.pressed.connect(_on_create_target_pressed)
	delete_event.pressed.connect(queue_free)

func _on_create_target_pressed() -> void:
	var new_target_menu : Control = target_menu.instantiate()
	target_list.add_child(new_target_menu)
	new_target_menu.up.pressed.connect(move_target_position.bind(new_target_menu, -1))
	new_target_menu.down.pressed.connect(move_target_position.bind(new_target_menu, 1))
	receive_underlying_data()

func rebuild_menus(matcher : TargetEventDescriptor) -> void:
	for target : TargetDescriptor in matcher.contained_targets:
		var new_target_menu : Control = target_menu.instantiate()
		target_list.add_child(new_target_menu)
		new_target_menu.up.pressed.connect(move_target_position.bind(new_target_menu, -1))
		new_target_menu.down.pressed.connect(move_target_position.bind(new_target_menu, 1))
		new_target_menu.rebuild_menus(target)
	event_length.value = matcher.length

func receive_underlying_data() -> TargetEventDescriptor:
	var output : TargetEventDescriptor = TargetEventDescriptor.new()
	for target_ui : Control in target_list.get_children():
		output.contained_targets.append(target_ui.receive_underlying_data())
	output.length = event_length.value
	return output

func move_target_position(target_ui : Control, direction : int) -> void:
	var index : int = target_list.get_children().find(target_ui)
	target_list.move_child(target_ui, max(index + direction, 0))
