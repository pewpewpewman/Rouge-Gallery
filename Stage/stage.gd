class_name Stage
extends Node

#Children References
@onready var round_timer : Timer = $RoundTimer
@onready var target_spawn_cooldown : Timer = $TargetSpawnCooldown

#Target Type Scenes
var target_stand_scene : PackedScene = preload("res://Targets/target_stand.tscn")
var base_target_scene : PackedScene = preload("res://Targets/base_target.tscn")
var normal_target_scene : PackedScene = preload("res://Targets/normal_target.tscn")
var timer_target_scene : PackedScene = preload("res://Targets/timer_target.tscn")
var item_target_scene : PackedScene = preload("res://Targets/item_target.tscn")

#Target Spawning Vars
@export var stage_layout : StageLayoutData
@export var scroll_paths : Array[Path2D]
@export var throw_paths : Array[Path2D]

#Time vars
var round_length : float = 60 * 5

func _ready() -> void:
	assert(stage_layout.data.size() > 0, "Stage layout data needs at least one element")
	assert(scroll_paths.size() == 3, "Stage needs to have exactly 3 paths for scrolling")
	assert(throw_paths.size() == 3, "Stage needs to have exactly 3 paths for tossing")
	for i : Path2D in  scroll_paths:
		assert(i != null, "Need scrolling target paths")
	for i : Path2D in  throw_paths:
		assert(i != null, "Need throwing target paths")
	
	#Timer Logic
	round_timer.timeout.connect(GameplaySignals.round_timer_expire.emit)
	round_timer.start(round_length)
			
	#Spawn target cycle setup
	for event_dec : TargetEventDescriptor in stage_layout.data:
		for target_dec : TargetDescriptor in event_dec.contained_targets:
			#Describe the target
			var target : BaseTarget = base_target_scene.instantiate() as BaseTarget
			target.description = target_dec
			
			var path : Path2D = (scroll_paths if target_dec.movement_type == TargetDescriptor.MovementTypes.SCROLL else throw_paths)[target_dec.spawn_point]
			if target_dec.movement_type == TargetDescriptor.MovementTypes.SCROLL:
				var target_stand : TargetStand = target_stand_scene.instantiate()
				target_stand.lifetime = target_dec.time_on_screen
				target_stand.z_index = target.z_index
				path.add_child(target_stand)
			path.add_child(target)
		
		#Setup next event
		target_spawn_cooldown.start(event_dec.length)
		await target_spawn_cooldown.timeout

func increase_timer(time_value : float):
	var initial_time : float = round_timer.time_left
	round_timer.stop()
	initial_time += time_value
	round_timer.start(initial_time)
