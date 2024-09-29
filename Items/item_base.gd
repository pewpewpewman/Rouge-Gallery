#Base class for items
#An item does not need a script, but ti can have one for special behavior for pickup and drops and what not
#For cleanliness, do not register item scripts with a class_name, just make them and attach them to the resource instead of the BaseItem script that is there by default
class_name BaseItem
extends Resource

enum ItemID
{
	NONE = 0,
	SUGARY_SWEETS = 4,
	UNPOPPED_KERNAL = 210
}

signal on_pickup
signal on_loss

@export var itemName : StringName = "Default Name"
@export var itemDesc : StringName = "Default Desc."
@export var itemID : ItemID = ItemID.NONE
@export var itemIcon : CompressedTexture2D = preload("res://icon.svg")
var numStacks : int = 0

func pickup() -> void:
	print("Picked up a " + itemName)
	on_pickup.emit()
	numStacks += 1

func loss() -> void:
	print("Lost a " + itemName)
	on_loss.emit()
	numStacks -= 1
