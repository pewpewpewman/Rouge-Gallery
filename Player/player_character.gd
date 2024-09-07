#script for basic player class - handles moving with mouse and shooting / selecting options
class_name PlayerCharacter #player character is registered as a class so they can be passed in signal
extends Node2D

#Children References
@onready var reticle : Sprite2D = $Reticle
@onready var firingArea : Area2D = $FiringArea
@onready var firingHitboxShape = $FiringArea/FiringHitboxShape

#General Purpose Vars
var canShoot : bool = true

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	$ShotCooldown.timeout.connect(_on_shot_cooldown)

func _process(delta : float) -> void:
	if (canShoot && Input.is_action_pressed("fireGun")):
		GameplaySignals.player_shot.emit(self)
		canShoot = false
		$ShotCooldown.start()

func _input(event : InputEvent) -> void:
	if (event is InputEventMouseMotion):
		self.position = event.position

func _on_shot_cooldown():
	canShoot = true
