class_name ItemTarget
extends BaseTarget

#An override to be used for debugging
@export var item_override : BaseItem.ItemID = BaseItem.ItemID.NONE
@export var use_override : bool = false

var item : BaseItem

func _ready():
	if !use_override:
		item = ItemDataBase.items_dict[description.item]
	else:
		item = ItemDataBase.items_dict[item_override]
	$Image/ItemImage.texture = item.item_icon
	super._ready()

func _on_destroyed():
	#this is a super shitty way of doing this
	ItemDataBase.pick_up_item(item.item_id)
	super._on_destroyed()
