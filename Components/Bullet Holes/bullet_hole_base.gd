#Base class for canvas items getting shot. The bse canvas item does not give enough info for making bullet shots, and UI stuff is different to sprites, so this base class is needed
#WARNING: THIS CLASS IS NOT TO BE PUT IN THE SCENE TREE, ONLY ITS CHILDREN
class_name BulletHoleComponent
extends Node

#Component Connections
@export var holeVictim : CanvasItem

#Shader Vars
var bulletHoleShader : Shader = load("res://bullet_holes.gdshader").duplicate()
var shotLocations : PackedVector2Array = [Vector2(-1.0, -1.0)]
var unnormalizedShotLocations : PackedVector2Array = [Vector2(-1.0, -1.0)] #needed to track when bullets go through other bullet holes
const MAX_BULLET_HOLES : int = 32 #Remember to keep consistant with shader constant
var shotLocationIndex : int = 0
var holeRadius : float = 10.0
var shotLocationsStringName : StringName = "shotLocations"
var bulletHoleSizeStringName : StringName = "bulletHoleSize"
var imageScaleStringName : StringName = "imageScale"

func _ready() -> void:
	assert(holeVictim != null, "Bullet hole component needs a valid canvas item!")
	
	shotLocations.resize(MAX_BULLET_HOLES)
	shotLocations.fill(Vector2(-1.0, -1.0))
	
	unnormalizedShotLocations.resize(MAX_BULLET_HOLES)
	unnormalizedShotLocations.fill(Vector2(-1.0, -1.0))
	
	if (holeVictim.material == null || holeVictim.material is CanvasItemMaterial):
		holeVictim.material = ShaderMaterial.new()
	holeVictim.material.shader = bulletHoleShader
	holeVictim.material.set_shader_parameter(bulletHoleSizeStringName, holeRadius)
	holeVictim.material.set_shader_parameter(shotLocationsStringName, shotLocations)
