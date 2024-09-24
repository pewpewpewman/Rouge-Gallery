class_name ShootableCircleComponent
extends ShootableBase

@export var targetRadius : float #only used for circular targets

func _ready():
	super._ready()
	if componentOwner is Sprite2D and targetRadius == 0.0:
		targetRadius = componentOwner.texture.get_width() * componentOwner.scale.x / 2.0

func check_shot(shotLocation : Vector2) -> bool:
	return Geometry2D.is_point_in_circle(shotLocation, componentOwner.position, targetRadius)
