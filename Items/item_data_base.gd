#Singleton for holding all item data
extends Node

@export var items : Array[ItemBase]
var itemDict : Dictionary

func _ready():
	for i :int in items.size():
		assert(!itemDict.has(items[i].itemID), "Item dictionary cannot add two of the same item!")
		itemDict[items[i].itemID] = items[i]
	#print("Grand Dictionary of Items: \n", itemDict)

func pick_up_item(player : PlayerCharacter, itemID : ItemBase.ItemID):
	assert(itemDict.has(itemID), "That item ID does not exist!")
	itemDict[itemID].pickup(player)
