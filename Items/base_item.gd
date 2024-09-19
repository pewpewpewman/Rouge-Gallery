#Base class for items
#Item classes are used to describe the behavior of an item
class_name ItemBase
extends Resource

enum ItemID
{
	NONE = 0,
	SUGARY_SWEETS = 4
}

var itemName : StringName
var itemDesc : StringName
var itemIconLocation : StringName
var numStacks : int = 0
@export var itemID : ItemID = ItemID.NONE

func pickup(player : PlayerCharacter) -> void:
	print("Picked up a " + itemName)
	numStacks += 1

func loss(player : PlayerCharacter) -> void:
	print("Lost a " + itemName)
	numStacks -= 1
