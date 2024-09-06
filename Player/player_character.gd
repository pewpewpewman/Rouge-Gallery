#script for basic player class - handles moving with mouse and shooting / selecting options
class_name PlayerCharacter #player character is registered as a class so they can be passed in signal
extends Node2D

#Children References
@onready var reticle : Sprite2D = $Reticle
@onready var firingArea : Area2D = $FiringArea
@onready var firingHitboxShape = $FiringArea/FiringHitboxShape

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(delta : float) -> void:
	pass

func _input(event : InputEvent) -> void:
	if (event is InputEventMouseMotion):
		self.position = event.position
	if (event is InputEventMouseButton and event.pressed):
		GameplaySignals.player_shot.emit(self)
