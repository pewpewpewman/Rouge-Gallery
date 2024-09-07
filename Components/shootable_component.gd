#Component for an object getting shot and setting signals to react
#To use this component, add collision shapes and add them to the array of hitboxes
class_name ShootableComponent #shootable component is registered as a class so it can be used in exports
extends Node2D

#Children References
@onready var shootingArea : Area2D = $ShootingArea

#Signals
signal was_shot(player : PlayerCharacter) #passing around the player like this may be bad

#General Use Vars
@export var hitbox : CollisionShape2D
var aimedAt : bool = false

func _ready() -> void:
	assert(hitbox != null, "Hitbox must have a valid collision shapes!")
	hitbox.reparent(shootingArea)
	shootingArea.area_entered.connect(_on_area_entered)
	shootingArea.area_exited.connect(_on_area_exited)
	GameplaySignals.player_shot.connect(_on_shot)

func _on_area_entered(area : Area2D):
	aimedAt = true

func _on_area_exited(area : Area2D):
	aimedAt = false

func _on_shot(player : PlayerCharacter):
	if aimedAt:
		was_shot.emit(player)
