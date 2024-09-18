class_name SugarySweets
extends ItemBase

func _init():
	itemName = "Sugary Sweets"
	itemDesc = "Shoot 5% faster - Pairs well with some cola"

func pickup() -> void:
	super.pickup()
	playerRef.shotCooldownTime -= playerRef.shotCooldownTime * 0.15
