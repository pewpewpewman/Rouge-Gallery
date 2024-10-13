class_name Stage
extends Node

#Children References
@onready var normalTargetTime : Timer = $NormalTargetTime
@onready var roundDurationTime : Timer = $RoundTime
@onready var specialTargetTime: Timer = $SpecialTargetTime

#Target Type Scenes
var targetStandScene : PackedScene = preload("res://Targets/target_stand.tscn")
var normalTargetScene : PackedScene = preload("res://Targets/normal_target.tscn")
var timerTargetScene : PackedScene = preload("res://Targets/timer_target.tscn")
var itemTargetScene : PackedScene = preload("res://Targets/item_target.tscn")

#Target Stream Vars
@export var streamSpawnPos : Array[Marker2D]
@onready var numStreams : int = streamSpawnPos.size()

#Time vars
var roundLength : float = 100.0
var timeToNextSpecial : float = 4.0
var timeToNextNormalLow : float = 0.5
var timeToNextNormalHigh : float = 2.0

signal game_over

@onready var screenSize : Vector2 = get_window().size

func _ready() -> void:
	assert(numStreams > 0, "Stage needs target spawning points to function")
	for i : int in numStreams:
		assert(streamSpawnPos[i] != null, "Target Spawning positions need valid markers")
	
	normalTargetTime.timeout.connect(_on_normal_target_time_timeout)
	normalTargetTime.wait_time = 2.0
	
	specialTargetTime.timeout.connect(_on_special_target_time_timeout)
	specialTargetTime.timeout.connect(randomize_special_target_time)
	randomize_special_target_time()
	ramdomize_normal_target_time()
	
	roundDurationTime.timeout.connect(_on_round_time_timeout)
	roundDurationTime.start(roundLength)

func _on_normal_target_time_timeout() -> void:
	var standLifeTime : float = 8.0
	var target : BaseTarget
	var targetStand : Sprite2D = targetStandScene.instantiate()

	var choice : int = randi_range(0, 100)
	if choice <= 90:
		target = normalTargetScene.instantiate()
	elif choice <= 95:
		target = itemTargetScene.instantiate()
	elif choice <= 100:
		target = timerTargetScene.instantiate()
		
	add_child(target)
	add_child(targetStand)
	var row = randi_range(0, numStreams - 1)
	target.z_index = -row * 3 + 1
	targetStand.z_index =  -row * 3
	spawn_scrolling_target(target, targetStand, streamSpawnPos[row].position, standLifeTime)
	ramdomize_normal_target_time()


func _on_special_target_time_timeout() -> void:
	#see what type  of target throw we're doing
	var willArc : bool = true
	if randi_range(1, 3) == 1:
		willArc = false
	var target : TimerTarget = timerTargetScene.instantiate()
	target.timer_target_destoryed.connect(increase_timer)
	add_child(target)
	
	var throwHeight : int
	var time  : float = 1.5
	
	if willArc:
		var spawnY : int = randi_range(3.0 * screenSize.y / 4.0, 5.0 * screenSize.y / 6.0)
		throwHeight = randi_range(50, 400)
		spawn_thrown_target(target, Vector2(-30, spawnY), Vector2(screenSize.x + 30, spawnY), throwHeight, time)
	else:
		var spawnX : int = randi_range(100, screenSize.x - 100)
		throwHeight = randi_range(450, 550)
		spawn_thrown_target(target, Vector2(spawnX, screenSize.y), Vector2(spawnX, screenSize.y), throwHeight, time)

func randomize_special_target_time() -> void:
	var time : float = randf_range(4.0, 10.0)
	specialTargetTime.start(time)

func ramdomize_normal_target_time() -> void:
	var time : float = randf_range(timeToNextNormalLow, timeToNextNormalHigh)
	normalTargetTime.start(time)

func _on_round_time_timeout() -> void:
	game_over.emit()

func increase_timer(timeValue : float):
	var initialTime : float = roundDurationTime.time_left
	roundDurationTime.stop()
	initialTime += timeValue
	roundDurationTime.start(initialTime)

func spawn_thrown_target(target : BaseTarget, initialPos : Vector2, endPos : Vector2, height : float, animTime : float) -> void:
	var tween : Tween = get_tree().create_tween()
	var halfWayX : float = (endPos.x - initialPos.x) / 2.0
	target.thrown = true
	target.position = initialPos
	target.z_index = randi_range(0, -9)
	target.trajectory.add_point(initialPos, Vector2.ZERO, Vector2(halfWayX, -height))
	target.trajectory.add_point(endPos, Vector2(-halfWayX, -height), Vector2.ZERO)
	
	tween.tween_property(target, "trajectoryTracker", 1.0, animTime).set_ease(Tween.EASE_OUT_IN)
	tween.parallel()
	tween.tween_property(target, "rotation", 2.0 * PI, animTime)
	tween.tween_callback(target.death_free_check)

func spawn_scrolling_target(target : BaseTarget, targetStand : Sprite2D, initialPosition : Vector2, animTime : float) -> void:
	var targetDragger : RemoteTransform2D = targetStand.get_child(0) #gets target dragger
	var targetStandTween : Tween = get_tree().create_tween()
	var endPos : Vector2
	
	endPos.y = initialPosition.y
	if initialPosition.x > 0:
		endPos.x = -30 #causes objects popping out of existance - not super noticable
	else:
		endPos.x = screenSize.x + 30
	
	targetStand.position = initialPosition
	
	targetDragger.remote_path = target.get_path()
	target.dragger = targetDragger
	
	targetStandTween.tween_property(targetStand, "position", endPos, animTime)
	targetStandTween.finished.connect(targetStand.queue_free)
	targetStandTween.finished.connect(target.death_free_check)
	
