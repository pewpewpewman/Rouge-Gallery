class_name InRoundState
extends GameStateBase

func state_enter() -> void:
	#Add Gameplay Elements
	mainRef.stage = (load("res://stage.tscn") as PackedScene).instantiate()
	mainRef.hud = (load("res://Menus/hud.tscn") as PackedScene).instantiate()
	mainRef.playerCharacter = (load("res://Player/player_character.tscn") as PackedScene).instantiate()
	add_child(mainRef.stage)
	add_child(mainRef.hud)
	add_child(mainRef.playerCharacter)
	
	mainRef.stage.game_over.connect(mainRef._on_game_end)
	
	print("Entered Round State")
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


func state_exit() -> void:
	#Remove Gameplay Elements
	mainRef.stage.queue_free()
	mainRef.hud.queue_free()
	mainRef.playerCharacter.queue_free()
	print("Exited Round State")

func _process(_delta : float) -> void:
	mainRef.hud.update_timer(mainRef.stage.roundDurationTime.time_left)
