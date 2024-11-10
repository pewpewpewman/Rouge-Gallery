#Class for targets that give the player more time
class_name TimerTarget
extends BaseTarget

var time_value : float

signal timer_target_destoryed(time_value : float)

func _ready() -> void:
	var decider : int = randi_range(0, 100)
	if decider <= 30:
		time_value = 5.0
	elif decider <= 80:
		time_value = 10.0
	elif decider <= 90:
		time_value = 15.0
	else:
		time_value = 20.0
	#print(time_value)
	point_value = 100
	super._ready()
	
func _on_destroyed():
	super._on_destroyed()
	#print("Timer target shot for ", time_value, " seconds")
	timer_target_destoryed.emit(time_value)
