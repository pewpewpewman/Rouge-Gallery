#Singleton for holding all item data
extends Node

@export var items : Array[BaseItem]
var items_dict : Dictionary

func _ready():
	for i : int in items.size():
		assert(!items_dict.has(items[i].item_id), "Item dictionary cannot add two of the same item!")
		items_dict[items[i].item_id] = items[i]
	print("Grand Dictionary of Items: \n", items_dict)

func pick_up_item(item_id : BaseItem.ItemID):
	assert(items_dict.has(item_id), "That item ID does not exist!")
	items_dict[item_id].pickup()
