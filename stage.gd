extends Node

#Children References
@onready var normalTargetSpawnTimer : Timer = $NormalTargetSpawn

#Target Type Scenes
var targetStandScene : PackedScene = preload("res://Targets/target_stand.tscn")
var normalTargetScene : PackedScene = preload("res://Targets/normal_target.tscn")

#Target Stream Vars
var streamSpawnPos : PackedVector2Array
var numStreams : int = 3

@onready var screenSize : Vector2i = get_window().get_viewport().get_visible_rect().size

func _ready() -> void:	
	streamSpawnPos.resize(numStreams)
	fill_stream_spawn_pos()
	
	normalTargetSpawnTimer.timeout.connect(_on_normal_target_spawn_timer_timeout)
	normalTargetSpawnTimer.wait_time = 2.0

func _on_normal_target_spawn_timer_timeout() -> void:
	for i : int in numStreams:
		
		var target : NormalTarget = normalTargetScene.instantiate()
		var targetStand : Sprite2D = targetStandScene.instantiate()
		var targetDragger : RemoteTransform2D = targetStand.get_node("TargetDragger")
		
		var targetStandDir : int
		var targetStandTween : Tween = get_tree().create_tween()
		var targetStandEndPosX : float = screenSize.x - streamSpawnPos[i].x
		var standLifeTime : float = 8.0
		
		add_child(targetStand)
		add_child(target)
		
		if i % 2 == 0:
			targetStandDir = -1
		else:
			targetStandDir = 1
		
		targetStand.position = streamSpawnPos[i]
		targetStand.region_rect.size.y = (screenSize.y - streamSpawnPos[i].y) / targetStand.scale.y
		
		target.z_index = numStreams - i
		targetStand.z_index = numStreams - i
		
		targetDragger.remote_path = target.get_path()
		target.dragger = targetDragger
		
		targetStandTween.tween_property(targetStand, "position", Vector2(screenSize.x - targetStand.position.x, targetStand.position.y), standLifeTime)
		targetStandTween.finished.connect(targetStand.queue_free)
		targetStandTween.finished.connect(target.queue_free)


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
		var posY : int = screenSize.y - (i * screenSize.y / 3.0 / numStreams) - 50
		var pos : Vector2 = Vector2(posX, posY)
		streamSpawnPos[i] = pos
