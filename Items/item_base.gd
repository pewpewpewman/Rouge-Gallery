#Base class for items
#An item does not need a script, but ti can have one for special behavior for pickup and drops and what not
#For cleanliness, do not register item scripts with a class_name, just make them and attach them to the resource instead of the BaseItem script that is there by default
class_name BaseItem
extends Resource

enum ItemID
{
	NONE = 0,
	SUGARY_SWEETS = 4,
	UNPOPPED_KERNAL = 210,
	CRISPY_COLA = 302
}

signal on_pickup
signal on_loss

@export var item_name : StringName = "Default Name"
@export var item_desc : StringName = "Default Desc."
@export var item_id : ItemID = ItemID.NONE
@export var item_icon : CompressedTexture2D = preload("res://icon.svg")
var num_stacks : int = 0

func pickup() -> void:
	print("Picked up a " + item_name)
	on_pickup.emit()
	num_stacks += 1

func loss() -> void:
	print("Lost a " + item_name)
	on_loss.emit()
	num_stacks -= 1
