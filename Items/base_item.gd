#Base class for items
#Item classes are used to describe the behavior of an item
class_name ItemBase
extends Resource

#player reference for effects that modify player stats
static var playerRef : PlayerCharacter

#vars unique to each item
var itemName : StringName
var itemDesc : StringName
var numStacks : int = 0
var itemIconLocation : StringName

func _ready() -> void:
	assert(numStacks == 0, "ITEM RESOURCES SHOULD ONLY BE INITALIZED ONCE")

func pickup() -> void:
	print("Picked up a " + itemName)
	numStacks += 1

func loss() -> void:
	print("Lost a " + itemName)
	numStacks -= 1
