#Component for making bullet holes appear in objects
#To use this component, connect a shootable component and a canvas item you want hole to appear in
#The canvas item and the shooting area should match as well as possible
extends Node2D

#Component Connections
@export var shootableComponent : ShootableComponent
@export var holeVictim : Sprite2D

#Shader Vars
var bulletHoleShader : Shader = load("res://bullet_holes.gdshader").duplicate()
var shotLocations : Array[Vector2] = [Vector2(-1.0, -1.0)]
const MAX_BULLET_HOLES : int = 32 #Remember to keep consistant with shader constant
var shotLocationIndex : int = 0
var shotLocationsStringName : StringName = "shotLocations"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(shootableComponent != null, "Bullet hole component needs a valid shootable component!")
	shootableComponent.was_shot.connect(_on_was_shot)
	
	assert(holeVictim != null, "Bullet hole component needs a valid canvas item!")
	if (holeVictim.material == null || holeVictim.material is CanvasItemMaterial):
		holeVictim.material = ShaderMaterial.new()
	holeVictim.material.shader = bulletHoleShader
	shotLocations.resize(MAX_BULLET_HOLES)
	shotLocations.fill(Vector2(-1.0, -1.0))
	holeVictim.material.set_shader_parameter(shotLocationsStringName, shotLocations)

func _process(delta: float) -> void:
	holeVictim.rotation += delta

func _on_was_shot(player : PlayerCharacter) -> void:
	var holeVictimSize : Vector2 = holeVictim.get_rect().size * holeVictim.global_scale
	#.roated() is to correct the difference vector so we're basically working in unrotated space 
	var shotLocation : Vector2 = ((player.global_position - holeVictim.global_position).rotated(-holeVictim.global_rotation) + holeVictimSize * 0.5) / holeVictimSize
	
	shotLocations[shotLocationIndex % MAX_BULLET_HOLES] = shotLocation
	shotLocationIndex += 1
	holeVictim.material.set_shader_parameter(shotLocationsStringName, shotLocations)
