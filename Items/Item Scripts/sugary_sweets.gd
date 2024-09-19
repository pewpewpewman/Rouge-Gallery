class_name SugarySweets
extends ItemBase

func _init():
	itemName = "Sugary Sweets"
	itemDesc = "Shoot 10% faster.			 Pairs well with some cola"

func pickup(player : PlayerCharacter) -> void:
	super.pickup(player)
	player.shotCooldownTime -= player.shotCooldownTime * 0.10

func loss(player : PlayerCharacter) -> void:
	super.loss(player)
