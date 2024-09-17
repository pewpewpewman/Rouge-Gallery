#Standard Targets that give some points when shot
class_name NormalTarget
extends BaseTarget

func _ready() -> void:
	pointValue = 50
	super._ready()
