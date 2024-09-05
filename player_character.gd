#script for basic player class - handles moving with mouse and shooting / selecting options
extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		self.position = event.position
	if (event is InputEventMouseButton and event.pressed):
		GameplaySignals.player_shot.emit(self.global_position)
