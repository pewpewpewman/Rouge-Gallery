#Class for targets that give the player more time
class_name TimerTarget
extends BaseTarget

var timeValue : float = 30

signal timer_target_destoryed(timeValue : float)

func _ready() -> void:
	pointValue = 100
	super._ready()
	
func _on_destroyed():
	super._on_destroyed()
	timer_target_destoryed.emit(timeValue)
