#component for detecting when an object is shot and making bullet holes appear
extends Node2D

#children references
@onready var firingArea : Area2D = $FiringArea
@onready var firingBox : CollisionShape2D = $FiringArea/FiringBox

#general purpose vars
var aimedAt : bool = false

#bullet hole vars
@export var bulletHoleVictim : CanvasItem
var bulletHoleLocationsShaderParam : StringName = "shotLocations"
const MAX_BULLET_HOLES : int = 32
var bulletHoleLocations : PackedVector2Array = []
var currentHoleLocation : int = 0

func _ready() -> void:
	assert(firingBox.shape is RectangleShape2D, "Bullet hole component must use a square bounding box for building bullet holes")
	assert(bulletHoleVictim, "A valid canvas item is needed for bullet holes to appear")
	
	#signal connections
	GameplaySignals.player_shot.connect(_on_component_shot)
	firingArea.area_entered.connect(_on_area_entered)
	firingArea.area_exited.connect(_on_area_exited)

	if bulletHoleVictim.material == null:
		bulletHoleVictim.material = ShaderMaterial.new()
	bulletHoleVictim.material.shader = load("res://bullet_holes.gdshader").duplicate()
	bulletHoleVictim.material.set_shader_parameter(bulletHoleLocationsShaderParam, bulletHoleLocations)
	bulletHoleLocations.resize(MAX_BULLET_HOLES)
	bulletHoleLocations.fill(Vector2(-1.0, -1.0))

func _on_area_entered(area : Area2D):
	aimedAt = true

func _on_area_exited(area : Area2D):
	aimedAt = false

func _on_component_shot(shotSourceLocation : Vector2):
	if aimedAt:
		var shotLocationScaled : Vector2  = (shotSourceLocation - (firingBox.global_position - firingBox.shape.size * 0.5)) / firingBox.shape.size
		bulletHoleLocations[currentHoleLocation % MAX_BULLET_HOLES] = shotLocationScaled
		get_parent().material.set_shader_parameter(bulletHoleLocationsShaderParam, bulletHoleLocations)
		currentHoleLocation += 1
