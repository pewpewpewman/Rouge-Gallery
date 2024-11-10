class_name Stage
extends Node

#Children References
@onready var normal_target_time : Timer = $NormalTargetTime
@onready var round_duration_time : Timer = $RoundTime
@onready var special_target_time : Timer = $SpecialTargetTime

#Target Type Scenes
var target_stand_scene : PackedScene = preload("res://Targets/target_stand.tscn")
var normal_target_scene : PackedScene = preload("res://Targets/normal_target.tscn")
var timer_target_scene : PackedScene = preload("res://Targets/timer_target.tscn")
var item_target_scene : PackedScene = preload("res://Targets/item_target.tscn")

#Target Stream Vars
@export var stage_layout : StageLayoutData
@export var stream_spawn_pos : Array[Marker2D]
@onready var num_streams : int = stream_spawn_pos.size()

#Time vars
var round_length : float = 100.0
var time_to_next_special : float = 4.0
var time_to_next_normal_low : float = 0.5
var time_to_next_normal_high : float = 2.0

signal game_over

@onready var screen_size : Vector2 = get_window().size

func _ready() -> void:
	assert(num_streams > 0, "Stage needs target spawning points to function")
	for i : int in num_streams:
		assert(stream_spawn_pos[i] != null, "Target Spawning positions need valid markers")
	
	##OLD SPAWNING SYSTEM!!
	#normal_target_time.timeout.connect(_on_normal_target_time_timeout)
	#normal_target_time.wait_time = 2.0
	#
	#special_target_time.timeout.connect(_on_special_target_time_timeout)
	#special_target_time.timeout.connect(randomize_special_target_time)
	#randomize_special_target_time()
	#ramdomize_normal_target_time()
	
	round_duration_time.timeout.connect(game_over.emit)
	round_duration_time.start(round_length)

#func _on_normal_target_time_timeout() -> void:
	#var stand_life_time : float = 8.0
	#var target : BaseTarget
	#var target_stand : Sprite2D = target_stand_scene.instantiate()
#
	#var choice : int = randi_range(0, 100)
	#if choice <= 90:
		#target = normal_target_scene.instantiate()
	#elif choice <= 95:
		#target = item_target_scene.instantiate()
	#elif choice <= 100:
		#target = timer_target_scene.instantiate()
		#
	#add_child(target)
	#add_child(target_stand)
	#var row = randi_range(0, num_streams - 1)
	#target.z_index = -row * 3 + 1
	#target_stand.z_index =  -row * 3
	#spawn_scrolling_target(target, target_stand, stream_spawn_pos[row].position, stand_life_time)
	#ramdomize_normal_target_time()


#func _on_special_target_time_timeout() -> void:
	##see what type  of target throw we're doing
	#var will_arc : bool = true
	#if randi_range(1, 3) == 1:
		#will_arc = false
	#var target : TimerTarget = timer_target_scene.instantiate()
	#target.timer_target_destoryed.connect(increase_timer)
	#add_child(target)
	#
	#var throw_height : int
	#var time  : float = 1.5
	#
	#if will_arc:
		#var spawn_y : int = randi_range(3.0 * screen_size.y / 4.0, 5.0 * screen_size.y / 6.0)
		#throw_height = randi_range(50, 400)
		#spawn_thrown_target(target, Vector2(-30, spawn_y), Vector2(screen_size.x + 30, spawn_y), throw_height, time)
	#else:
		#var spawn_x : int = randi_range(100, screen_size.x - 100)
		#throw_height = randi_range(450, 550)
		#spawn_thrown_target(target, Vector2(spawn_x, screen_size.y), Vector2(spawn_x, screen_size.y), throw_height, time)

#func randomize_special_target_time() -> void:
	#var time : float = randf_range(4.0, 10.0)
	#special_target_time.start(time)
#
#func ramdomize_normal_target_time() -> void:
	#var time : float = randf_range(time_to_next_normal_low, time_to_next_normal_high)
	#normal_target_time.start(time)

func increase_timer(time_value : float):
	var initial_time : float = round_duration_time.time_left
	round_duration_time.stop()
	initial_time += time_value
	round_duration_time.start(initial_time)

func spawn_thrown_target(target : BaseTarget, initial_pos : Vector2, end_pos : Vector2, height : float, anim_time : float) -> void:
	var tween : Tween = get_tree().create_tween()
	var half_way_x : float = (end_pos.x - initial_pos.x) / 2.0
	target.thrown = true
	target.position = initial_pos
	target.z_index = randi_range(0, -9)
	target.trajectory.add_point(initial_pos, Vector2.ZERO, Vector2(half_way_x, -height))
	target.trajectory.add_point(end_pos, Vector2(-half_way_x, -height), Vector2.ZERO)
	
	tween.tween_property(target, "trajectory_tracker", 1.0, anim_time).set_ease(Tween.EASE_OUT_IN)
	tween.parallel()
	tween.tween_property(target, "rotation", 2.0 * PI, anim_time)
	tween.tween_callback(target.death_free_check)

func spawn_scrolling_target(target : BaseTarget, target_stand : Sprite2D, initial_position : Vector2, anim_time : float) -> void:
	var target_dragger : RemoteTransform2D = target_stand.get_child(0) #gets target dragger
	var target_stand_tween : Tween = get_tree().create_tween()
	var end_pos : Vector2
	
	end_pos.y = initial_position.y
	if initial_position.x > 0:
		end_pos.x = -30 #causes objects popping out of existance - not super noticable
	else:
		end_pos.x = screen_size.x + 30
	
	target_stand.position = initial_position
	
	target_dragger.remote_path = target.get_path()
	target.dragger = target_dragger
	
	target_stand_tween.tween_property(target_stand, "position", end_pos, anim_time)
	target_stand_tween.finished.connect(target_stand.queue_free)
	target_stand_tween.finished.connect(target.death_free_check)
	
