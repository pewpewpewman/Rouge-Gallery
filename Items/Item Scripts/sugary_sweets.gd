class_name SugarySweets
extends ItemBase

func _init():
	itemName = "Sugary Sweets"
	itemDesc = "Shoot 10% faster. Pairs well with some cola"

func pickup(player : PlayerCharacter) -> void:
	player.shotCooldownTime -= player.shotCooldownTime * 0.10
	super.pickup(player)

func loss(player : PlayerCharacter) -> void:
	player.shotCooldownTime += player.shotCooldownTime * 0.10
	super.loss(player)
