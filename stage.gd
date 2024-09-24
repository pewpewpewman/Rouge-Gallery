class_name Stage
extends Node

#Children References
@onready var normalTargetTime : Timer = $NormalTargetTime
@onready var roundDurationTime : Timer = $RoundTime

#Target Type Scenes
var targetStandScene : PackedScene = preload("res://Targets/target_stand.tscn")
var normalTargetScene : PackedScene = preload("res://Targets/normal_target.tscn")

#Target Stream Vars
var streamSpawnPos : PackedVector2Array
var numStreams : int = 3

#Time vars
var roundLength : float = 100.0

signal game_over

@onready var screenSize : Vector2 = get_window().get_viewport().get_visible_rect().size

func _ready() -> void:
	streamSpawnPos.resize(numStreams)
	fill_stream_spawn_pos()
	
	normalTargetTime.timeout.connect(_on_normal_target_time_timeout)
	normalTargetTime.wait_time = 2.0
	
	roundDurationTime.timeout.connect(_on_round_time_timeout)
	roundDurationTime.start(roundLength)

func _on_normal_target_time_timeout() -> void:
	var standLifeTime : float = 8.0
	for i : int in numStreams:
		var target : NormalTarget = normalTargetScene.instantiate()
		add_child(target)
		target.z_index += i
		spawn_scrolling_target(target, streamSpawnPos[i], standLifeTime)

func fill_stream_spawn_pos() -> void:
	for i : int in numStreams:
		var direction : int
		if i % 2 == 0:
			direction = 1
		else:
			direction = -1

		var halfScreen : int = screenSize.x / 2.0
		# + 20 * direction to account for target srite size; could need changing
		var posX : int = halfScreen + halfScreen * direction + 20 * direction
		var posY : int = screenSize.y - (i * screenSize.y / 3.0 / numStreams) - 125
		var pos : Vector2 = Vector2(posX, posY)
		streamSpawnPos[i] = pos

func _on_round_time_timeout() -> void:
	game_over.emit()

func increase_timer(timeValue : float):
	var initialTime : float = roundDurationTime.time_left
	roundDurationTime.stop()
	initialTime += timeValue
	roundDurationTime.start(initialTime)

func spawn_thrown_target(target : BaseTarget, initialPos : Vector2, endPos : Vector2, animTime : float) -> void:
	var trajectory : Curve2D = Curve2D.new()

func spawn_scrolling_target(target : BaseTarget, initialPosition : Vector2, animTime : float) -> void:
	var targetStand : Sprite2D = targetStandScene.instantiate()
	var targetDragger : RemoteTransform2D = targetStand.get_child(0) #gets target dragger
	var targetStandTween : Tween = get_tree().create_tween()
	var endPos : Vector2
	endPos.y = initialPosition.y
	if initialPosition.x > 0:
		endPos.x = -40
	else:
		endPos.x = screenSize.x + 40
	
	add_child(targetStand)
	targetStand.position = initialPosition
	
	targetDragger.remote_path = target.get_path()
	target.dragger = targetDragger
	
	targetStandTween.tween_property(targetStand, "position", endPos, animTime)
	targetStandTween.finished.connect(targetStand.queue_free)
	targetStandTween.finished.connect(target.queue_free)
	
