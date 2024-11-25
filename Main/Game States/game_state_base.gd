#Base class for game states - used to as children of Main and control overall control of whats happeneing
class_name GameStateBase
extends Node

@onready var main_ref : Node = get_parent()

func state_enter() -> void:
	pass
	#print("Entered State")

func state_exit() -> void:
	pass
	#print("state exited")

func _process(_delta : float) -> void:
	pass
