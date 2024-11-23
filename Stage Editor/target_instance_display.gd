extends Control

@onready var type_select: OptionButton = $ElementOrganizer/TypeSelect
@onready var item_select: OptionButton = $ElementOrganizer/ItemSelect
@onready var time_reward: SpinBox = $ElementOrganizer/TimeReward
@onready var movement_type: OptionButton = $ElementOrganizer/MovementType
@onready var spawn_point: OptionButton = $ElementOrganizer/SpawnPoint
@onready var time_on_screen: SpinBox = $ElementOrganizer/TimeOnScreen
@onready var up: Button = $ElementOrganizer/HBoxContainer/Up
@onready var down: Button = $ElementOrganizer/HBoxContainer/Down
@onready var delete_button: Button = $ElementOrganizer/DeleteButton

func _ready() -> void : 
	for item : BaseItem in ItemDataBase.items:
		item_select.add_item(item.item_name)
		
	#Delete Button
	delete_button.pressed.connect(queue_free)
	
	#Hiding uneeded menu functions
	type_select.item_selected.connect(_on_type_select)
	movement_type.item_selected.connect(_on_movement_type_select)
	
	#make buttons mirror default selections
	rebuild_menus(TargetDescriptor.new())

func _on_type_select(type : int) -> void:
	if type == TargetDescriptor.TargetTypes.BASIC:
		item_select.visible = false
		time_reward.visible = false
	if type == TargetDescriptor.TargetTypes.TIME:
		item_select.visible = false
		time_reward.visible = true
	if type == TargetDescriptor.TargetTypes.ITEM:
		item_select.visible = true
		time_reward.visible = false

func _on_movement_type_select(type : int) -> void:
	if type == TargetDescriptor.MovementTypes.SCROLL:
		spawn_point.set_item_text(0, "High")
		spawn_point.set_item_text(1, "Mid")
		spawn_point.set_item_text(2, "Low")
	if type == TargetDescriptor.MovementTypes.TOSS:
		spawn_point.set_item_text(0, "Right")
		spawn_point.set_item_text(1, "Center")
		spawn_point.set_item_text(2, "Left")

#function for making the data in the display match that of the actual internal data
func rebuild_menus(matcher : TargetDescriptor) -> void:
	type_select.select(matcher.type)
	#This is very bad, but it will do 
	var datas_item : BaseItem
	for item in ItemDataBase.items:
		if item.item_id == matcher.item:
			datas_item = ItemDataBase.items_dict[item.item_id]
	item_select.select(ItemDataBase.items.find(datas_item))
	time_reward.value = matcher.time_reward
	movement_type.select(matcher.movement_type)
	spawn_point.select(matcher.spawn_point)
	time_on_screen.value = matcher.time_on_screen
	_on_type_select(matcher.type)
	_on_movement_type_select(matcher.movement_type)

func receive_underlying_data() -> TargetDescriptor:
	var output : TargetDescriptor = TargetDescriptor.new()
	output.type = type_select.selected
	output.item = ItemDataBase.items[item_select.selected].item_id
	output.time_reward = time_reward.value
	output.movement_type = movement_type.selected
	output.spawn_point = spawn_point.selected
	output.time_on_screen = time_on_screen.value 
	return output
