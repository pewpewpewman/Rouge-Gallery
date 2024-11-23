class_name PlayerStateBase
extends Node

@onready var player : PlayerCharacter = get_parent()

func on_enter() -> void:
	pass
	#print("Entered ", self.name)

func on_exit() -> void:
	pass
	#print("Exited ", self.name)
