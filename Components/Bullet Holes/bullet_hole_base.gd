#Base class for canvas items getting shot. The bse canvas item does not give enough info for making bullet shots, and UI stuff is different to sprites, so this base class is needed
#WARNING: THIS CLASS IS NOT TO BE PUT IN THE SCENE TREE, ONLY ITS CHILDREN
class_name BulletHoleComponent
extends Node

#Component Connections
@export var hole_victim : CanvasItem

#Shader Vars
var bullet_hole_shader : Shader = load("res://Components/Bullet Holes/bullet_holes.gdshader").duplicate()
var shot_locations : PackedVector2Array = [Vector2(-1.0, -1.0)]
var unnormalized_shot_locations : PackedVector2Array = [Vector2(-1.0, -1.0)] #needed to track when bullets go through other bullet holes
const MAX_BULLET_HOLES : int = 32 #Remember to keep consistant with shader constant
var shot_location_index : int = 0
var hole_radius : float = 10.0
var shot_locations_string_name : StringName = "shot_locations"
var bullet_hole_size_string_name : StringName = "bullet_hole_size"
var image_scale_string_name : StringName = "image_scale"

func _ready() -> void:
	assert(hole_victim != null, "Bullet hole component needs a valid canvas item!")
	
	shot_locations.resize(MAX_BULLET_HOLES)
	shot_locations.fill(Vector2(-1.0, -1.0))
	
	unnormalized_shot_locations.resize(MAX_BULLET_HOLES)
	unnormalized_shot_locations.fill(Vector2(-1.0, -1.0))
	
	if (hole_victim.material == null || hole_victim.material is CanvasItemMaterial):
		hole_victim.material = ShaderMaterial.new()
	hole_victim.material.shader = bullet_hole_shader
	hole_victim.material.set_shader_parameter(bullet_hole_size_string_name, hole_radius)
	hole_victim.material.set_shader_parameter(shot_locations_string_name, shot_locations)
