#Component for an object getting shot and setting signals to react
#To use this component, you must make children editable to change the hitbox
extends Node2D

#Children References
@onready var shootingArea : Area2D = $ShootingArea

#Signals
signal was_shot(player : PlayerCharacter) #passing around the player like this may be bad

#General Use Vars
@export var hitboxes : Array[CollisionShape2D]
var aimedAt : bool = false

func _ready() -> void:
	assert(hitboxes.size() != 0, "Shootable Component needs hitboxes!")
	for hitbox : CollisionShape2D in hitboxes:
		assert(hitbox != null, "Hitboxes array must be filled with valid collision shapes!")
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
		print("ARG IVE BEEN SHOT!")
		was_shot.emit(player)
