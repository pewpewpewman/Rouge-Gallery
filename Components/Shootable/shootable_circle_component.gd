class_name ShootableCircleComponent
extends ShootableBase

@export var target_radius : float = 0.0 #only used for circular targets

func _ready():
	super._ready()
	if component_owner is Sprite2D and target_radius == 0:
		target_radius = component_owner.texture.get_width() * component_owner.scale.x / 2.0

func check_shot(shot_location : Vector2) -> bool:
	return Geometry2D.is_point_in_circle(shot_location, component_owner.global_position, target_radius)
