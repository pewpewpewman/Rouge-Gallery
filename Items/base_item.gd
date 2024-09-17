#Base class for items
#Item classes are used to describe the behavior of an item
class_name ItemBase
extends Node

func on_pickup() -> void:
	print("Default item pick up")

func on_loss() -> void:
	print("Default item lost")

func _process(detla : float) -> void:
	pass
