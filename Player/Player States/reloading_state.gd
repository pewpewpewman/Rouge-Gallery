class_name ReloadingState
extends PlayerStateBase

@onready var reload_timer: Timer = $ReloadTimer

func _ready() -> void:
	reload_timer.timeout.connect(player.change_state.bind(self))

func on_enter() -> void:
	super.on_enter()
	if player.current_ammo != player.max_ammo:
		player.current_ammo += 1
		GameplaySignals.bullet_reloaded.emit(player.current_ammo, player.max_ammo, player.total_reload_time / player.max_ammo)
		reload_timer.start(player.total_reload_time / player.max_ammo)
	else:
		player.change_state(player.regular_state)
