#class_name SugarySweets
#extends BaseItem
#
#func pickup() -> void:
	#player.shotCooldownTime -= player.shotCooldownTime * 0.10
	#super.pickup()
#
#func loss() -> void:
	#player.shotCooldownTime += player.shotCooldownTime * 0.10
	#super.loss()
