#Base class for items
class_name ItemBase
extends Node

static var itemName : StringName = "default item name"
static var desc : StringName = "default item decs"
static var numStacks : int = 0

func on_pickup() -> void:
	print("Default item pick up")

func on_loss() -> void:
	print("Default item lost")

func _process(detla : float) -> void:
	pass
