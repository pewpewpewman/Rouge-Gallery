#Component for making bullet holes appear in sprites
#To use this component, connect a shootable component and a canvas item you want hole to appear in
class_name BulletHoleSpriteComponent
extends BulletHoleComponent

#Component Connections
var hole_victim_sprite : Sprite2D
@export var shootable_component : ShootableBase

func _ready() -> void:
	super._ready()
	assert(shootable_component != null, "Bullet hole component needs a valid shootable component!")
	assert(hole_victim is Sprite2D, "Bullet Component for sprites must use a sprite")
	shootable_component.component_shot.connect(_on_was_shot)
	hole_victim_sprite = hole_victim as Sprite2D
	hole_victim_sprite.material.set_shader_parameter(image_scale_string_name, hole_victim_sprite.global_scale)

#it deeplt hurts my soul to do this, but for some reason _set() is not affected by it's attached object being changed
func _process(_delta: float) -> void:
	hole_victim_sprite.material.set_shader_parameter(image_scale_string_name, hole_victim_sprite.get_rect().size * hole_victim_sprite.global_scale)

func _on_was_shot(shot_location : Vector2) -> void:
	# shot_location - hole_victim_sprite.global_position gets you a vector pointing to where on the sprite the shot occured
	# .roated(-hole_victim_sprite.global_rotation) is to correct the difference vector so we're basically working in unrotated space
	# + hole_victim_size * 0.5 undoes the fact godot uses the center as the position, the pointing vector now starts from the top left, just like UVs
	# / hole_victim_size normalizes the pointing vector, just like UVs
	#TODO: correct for skewing, although i dont think ill need it
	
	var hole_victim_size : Vector2 = hole_victim_sprite.get_rect().size * hole_victim_sprite.global_scale
	var local_shot_location : Vector2 
	
	if hole_victim_sprite.centered:
		local_shot_location = ((shot_location - hole_victim_sprite.global_position - hole_victim_sprite.offset).rotated(-hole_victim_sprite.rotation) + hole_victim_size * 0.5) / hole_victim_size
	else:
		local_shot_location = (shot_location - hole_victim_sprite.global_position - hole_victim_sprite.offset).rotated(-hole_victim_sprite.rotation) / hole_victim_size
	
	shot_locations[shot_location_index % MAX_BULLET_HOLES] = local_shot_location
	unnormalized_shot_locations[shot_location_index % MAX_BULLET_HOLES] = shot_location
	shot_location_index += 1
	hole_victim_sprite.material.set_shader_parameter(shot_locations_string_name, shot_locations)
