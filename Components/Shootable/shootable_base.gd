#Component for an object getting shot and setting signals to react
class_name ShootableBase
extends Node2D

#Owner reference
@export var componentOwner : Node2D

#Signals
signal was_shot(shotLocation : Vector2) #passing around the player like this may be bad #dw i made it just the shot pos	

func _ready() -> void:
	assert(componentOwner != null, "Shot detection component needs a valid owner")
	GameplaySignals.player_shot.connect(_on_shot)

func _on_shot(shotLocation : Vector2) -> void:
	if check_shot(shotLocation):
		was_shot.emit(shotLocation)

#func thats overriden in children
func check_shot(shotLocation : Vector2):
	pass
