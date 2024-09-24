class_name UnpoppedKernel
extends ItemBase

var extraShotRadius : int = 128 #measured in pixels
var extraShotCount : int

func _init():
	itemName = "Unpopped Kernel"
	itemDesc = "Firing a shot makes another shot happen in 3 random places in an area. +1 shot and +5% area radius per stack. Bad for your teeth."

func pickup(player : PlayerCharacter) -> void:
	if numStacks == 0:
		extraShotCount = 3
	else:
		extraShotCount += 1
	super.pickup(player)
	
func loss(player : PlayerCharacter) -> void:
	super.loss(player)
	if numStacks == 0:
		extraShotCount = 0
	else:
		extraShotCount -= 1
