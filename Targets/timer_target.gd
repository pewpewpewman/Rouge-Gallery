#Class for targets that give the player more time
class_name TimerTarget
extends BaseTarget

var timeValue : float

signal timer_target_destoryed(timeValue : float)

func _ready() -> void:
	var decider : int = randi_range(0, 100)
	if decider <= 30:
		timeValue = 5.0
	elif decider <= 80:
		timeValue = 10.0
	elif decider <= 90:
		timeValue = 15.0
	else:
		timeValue = 20.0
	#print(timeValue)
	pointValue = 100
	super._ready()
	
func _on_destroyed():
	super._on_destroyed()
	#print("Timer target shot for ", timeValue, " seconds")
	timer_target_destoryed.emit(timeValue)
