class_name RegularState
extends PlayerStateBase

func _input(event : InputEvent) -> void:
	if (event.is_action_pressed("fire_gun")):
		player.firing_routine()
		player.change_state(player.cooldown_state)
	if (event.is_action_pressed("reload")):
		player.change_state(player.reloading_state) ##TODO: FIX MANUAL RELOADING
