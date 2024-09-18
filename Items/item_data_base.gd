#An autoloaded singleton for holding the data of all objects
extends Node

var itemScripts : PackedStringArray = [
	
	"sugary_sweets"
	
]

#Dictionary for all item instances; keys are the same as the item's script's name
var itemDict : Dictionary = {}

func _ready() -> void:
	var index : int = 0
	for scriptName : String in itemScripts:
		itemDict[scriptName] = load("res://Items/Item Scripts/" + scriptName + ".gd").new() as ItemBase
		index += 1
	print(itemDict)
