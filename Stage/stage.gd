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
@export var target_lines : Array[Line2D]
var target_curves : Array[Curve2D]
@onready var num_paths : int = target_lines.size()

#Time vars
var round_length : float = 60 * 5

func _ready() -> void:
	assert(stage_layout.data.size() > 0, "Stage layout data needs at least one element")
	assert(num_paths > 0, "Stage needs target paths to function")
	for i : int in num_paths:
		pass
		#assert(target_lines[i] != null, "Target paths need valid lines")
	
	#Timer Logic
	round_timer.timeout.connect(GameplaySignals.round_timer_expire.emit)
	round_timer.start(round_length)
	
	#Build Target Lines
	target_curves.resize(target_lines.size())
	for line_index : int  in target_lines.size():
		var line : Line2D = target_lines[line_index]
		var curve : Curve2D = Curve2D.new()
		print(curve)
		target_curves[line_index] = curve
		for point_index : int in line.points.size():
			var point : Vector2 = line.global_position + line.points[point_index]
			var prev_point : Vector2 = line.global_position + line.points[max(point_index - 1, 0)]
			var next_point : Vector2 = line.global_position + line.points[min(point_index + 1, line.points.size() - 1)]
			print(point - next_point, point - prev_point)
			curve.add_point(point, point - next_point, point - prev_point)
			
	#Spawn target cycle setup
	for event_dec : TargetEventDescriptor in stage_layout.data:
		for target_dec : TargetDescriptor in event_dec.contained_targets:
			#Describe the target
			var target : BaseTarget = base_target_scene.instantiate() as BaseTarget
			target.description = target_dec
			if target_dec.movement_type == TargetDescriptor.MovementTypes.SCROLL:
				target.trajectory = target_curves[target_dec.spawn_point]
			add_child(target)
		
		#Setup next event
		target_spawn_cooldown.start(event_dec.length)
		await target_spawn_cooldown.timeout

func increase_timer(time_value : float):
	var initial_time : float = round_timer.time_left
	round_timer.stop()
	initial_time += time_value
	round_timer.start(initial_time)
