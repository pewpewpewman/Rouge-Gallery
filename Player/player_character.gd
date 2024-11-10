#script for basic player class - handles moving with mouse and shooting / selecting options
class_name PlayerCharacter #player character is registered as a class so they can be passed in signal
extends Node2D

#Children References
@onready var outer : Sprite2D = $Outer
@onready var inner : Sprite2D = $Inner

#States
@onready var regular_state : RegularState = $RegularState
@onready var reloading_state : ReloadingState = $ReloadingState
@onready var cooldown_state : CooldownState = $CooldownState
@onready var currentState : PlayerStateBase = $RegularState

#Shooting Vars
var shot_cooldown_time : float = 1 #measureed in seconds
var highest_z_index : int = -50
var shot_object : Node = null

#Ammo Vars
var max_ammo : int = 6
var current_ammo : int = max_ammo
var total_reload_time : float = 2

#Score vars
var num_hole_passes : int = 0
var hit_streak : int = 0

func _ready() -> void:
	GameplaySignals.through_hole_bonus.connect(_on_through_hole_bonus)
	GameplaySignals.object_shot.connect(_on_object_shot)
	
	#Shooting connections
	GameplaySignals.in_shot_range.connect(_on_in_shot_range)
	
	##Item pickup connections
	ItemDataBase.items_dict[BaseItem.ItemID.SUGARY_SWEETS].on_pickup.connect(_on_sugary_sweet_pickup)
	ItemDataBase.items_dict[BaseItem.ItemID.CRISPY_COLA].on_pickup.connect(_on_crispy_cola_pickup)
	
	##Item loss connections
	ItemDataBase.items_dict[BaseItem.ItemID.SUGARY_SWEETS].on_loss.connect(_on_sugary_sweet_loss)
	ItemDataBase.items_dict[BaseItem.ItemID.CRISPY_COLA].on_loss.connect(_on_crispy_cola_loss)

	for i : int in 20: 
		#ItemDataBase.pick_up_item(BaseItem.ItemID.UNPOPPED_KERNAL)
		#ItemDataBase.pick_up_item(BaseItem.ItemID.SUGARY_SWEETS)
		#ItemDataBase.pick_up_item(BaseItem.ItemID.CRISPY_COLA)
		pass

func change_state(new_state : PlayerStateBase):
	currentState.process_mode = Node.PROCESS_MODE_DISABLED
	currentState.on_exit()
	currentState = new_state
	currentState.on_enter()
	currentState.process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event : InputEvent) -> void:
	if (event is InputEventMouseMotion):
		self.position = event.position

func _on_in_shot_range(z_index : int):
	highest_z_index = max(highest_z_index, z_index)

func _on_through_hole_bonus() -> void:
	num_hole_passes += 1

func _on_object_shot(object : Node):
	shot_object = object

func fire_shot(location : Vector2) -> void:
	GameplaySignals.search_aimed_objects.emit(location)
	GameplaySignals.found_highest_z.emit(highest_z_index) #this is basically actually putting the trigger and firing
	highest_z_index = -50
	num_hole_passes = 0

func firing_routine() -> void:
		#main shot routine
		fire_shot(self.global_position)
		current_ammo -= 1
		GameplaySignals.bullet_used.emit(current_ammo, max_ammo, shot_cooldown_time)
		if shot_object != null && shot_object is BaseTarget:
			hit_streak += 1
		else:
			hit_streak = 0
		shot_object = null
		
		#handle unpopped kernals
		var unpopped_kernel_ref : BaseItem = ItemDataBase.items_dict[BaseItem.ItemID.UNPOPPED_KERNAL]
		for i : int in unpopped_kernel_ref.extra_shot_count:
			var shotMag : float = randf_range(0.0, unpopped_kernel_ref.extra_shot_radius)
			var shotDeg : float = randf_range(0, 2.0 * PI)
			var shotX : float = shotMag * cos(shotDeg)
			var shotY : float = shotMag * sin(shotDeg)
			fire_shot(self.global_position + Vector2(shotX, shotY))
			

##
## ITEM PICKUP RESPONSES
##

func _on_sugary_sweet_pickup() -> void:
	shot_cooldown_time -= shot_cooldown_time * 0.10

func _on_crispy_cola_pickup() -> void:
	total_reload_time -= total_reload_time * 0.10
	print("new reload time: ", total_reload_time)

##
## ITEM LOSS RESPONSES
##

func _on_sugary_sweet_loss() -> void:
	shot_cooldown_time += shot_cooldown_time * 0.10

func _on_crispy_cola_loss() -> void:
	total_reload_time += total_reload_time * 0.10
