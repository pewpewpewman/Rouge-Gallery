class_name CooldownState
extends PlayerStateBase

func on_enter() -> void:
	super.on_enter()
	
	#Reticle Animation
	var reticle_tween : Tween = get_tree().create_tween()
	var animFunc : Callable = func animFunc(x : float) -> void:
		player.outer.rotation = x * TAU
		player.outer.scale = Vector2(0.1, 0.1) * (cos(x * TAU) + 5.0) / 6.0
	
	reticle_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	reticle_tween.tween_method(animFunc, 0.0, 1.0, player.shot_cooldown_time) #This ties the cooldown time to an animation time and not an actual timer node!!
	reticle_tween.finished.connect(player.change_state.bind(player.reloading_state if player.current_ammo == 0 else player.regular_state))

func on_exit() -> void:
	super.on_exit()
	player.outer.rotation = 0
	player.outer.scale = Vector2(0.1, 0.1)
