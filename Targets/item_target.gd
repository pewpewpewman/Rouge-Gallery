class_name ItemTarget
extends BaseTarget

#An override to be used for debugging
@export var itemOverride : BaseItem.ItemID = BaseItem.ItemID.NONE

var item : BaseItem
func _ready():
	if itemOverride == BaseItem.ItemID.NONE:
		var itemChoice = randi_range(0, ItemDataBase.items.size() - 1)
		item = ItemDataBase.items[itemChoice]
	else:
		item = ItemDataBase.itemDict[itemOverride]
	$Label.text = "THIS IS A " + item.itemName
	super._ready()

func _on_destroyed():
	#this is a super shitty way of doing this
	ItemDataBase.pick_up_item(item.itemID)
	super._on_destroyed()
