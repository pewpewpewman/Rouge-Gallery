class_name UnpoppedKernel
extends ItemBase

func _init():
	itemName = "Unpopped Kernel"
	itemDesc = "Firing a shot makes another shot happen in 3 random places in an area. +1 shot and +5% area radius per stack. Bad for your teeth.			"

func pickup(player : PlayerCharacter) -> void:
	super.pickup(player)
	player.shotCooldownTime -= player.shotCooldownTime * 0.10

func loss(player : PlayerCharacter) -> void:
	super.loss(player)
