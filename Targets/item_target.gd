class_name ItemTarget
extends BaseTarget

#An override to be used for debugging
@export var item_override : BaseItem.ItemID = BaseItem.ItemID.NONE
@export var use_override : bool = false

var item : BaseItem
func _ready():
	if use_override:
		var item_choice = randi_range(0, ItemDataBase.items.size() - 1)
		item = ItemDataBase.items[item_choice]

	$Label.text = "THIS IS A " + item.item_name
	super._ready()

func _on_destroyed():
	#this is a super shitty way of doing this
	ItemDataBase.pick_up_item(item.item_id)
	super._on_destroyed()
